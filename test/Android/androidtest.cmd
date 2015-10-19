@echo off
setlocal

if not defined VisualStudioVersion (
    if defined VS140COMNTOOLS (
        call "%VS140COMNTOOLS%\VsDevCmd.bat"
        goto :EnvSet
    )

    echo Error: build.cmd requires Visual Studio 2015.
    exit /b -1
)
:EnvSet

set _DeviceId=
set _Platform=
set _SdkRoot=%ProgramFiles(x86)%\Android\android-sdk
set _NdkRoot=%ProgramData%\Microsoft\AndroidNDK\android-ndk-r10e
set _Verbose=
set _TestsToRun=

if "%~1"=="" goto Help
if "%~1"=="-?" goto Help
if "%~1"=="/?" goto Help

set _ProjectRoot=%~dp0..\..\

set _GlassPackageName=Microsoft.VisualStudio.Glass
set _GlassPackageVersion=1.0.0

set _GlassDir=%_ProjectRoot%%_GlassPackageName%\

:: Get Glass from NuGet
if NOT exist "%_GlassDir%glass2.exe" echo Getting Glass from NuGet.& call "%_ProjectRoot%tools\NuGet\nuget.exe" install %_GlassPackageName% -Version %_GlassPackageVersion% -ExcludeVersion -OutputDirectory %_ProjectRoot%
if NOT "%ERRORLEVEL%"=="0" echo ERROR: Failed to get Glass from NuGet.& exit /b -1

:: Ensure the project has been built
if NOT exist "%_GlassDir%Microsoft.MIDebugEngine.dll" echo The project has not been built. Building now with default settings.& call %_ProjectRoot%build.cmd
if NOT "%ERRORLEVEL%"=="0" echo ERROR: Failed to build MIEngine project.& exit /b -1

:: Copy libadb.dll to the glass directory 
xcopy /Y /D "%VSINSTALLDIR%Common7\IDE\PrivateAssemblies\libadb.dll" "%_GlassDir%"
if not "%ERRORLEVEL%"=="0" echo ERROR: Unable to copy libadb.dll from Visual Studio installation.& exit /b -1

call :EnsureGlassRegisterd
call :EnsureLaunchOptionsGenBuilt


:ArgLoopStart
if "%~1"=="" goto ArgLoopEnd
if /i "%~1"=="/DeviceId"    goto SetDeviceId
if /i "%~1"=="/Platform"    goto SetPlatform
if /i "%~1"=="/SdkRoot"     goto SetSdkRoot
if /i "%~1"=="/NdkRoot"     goto SetNdkRoot
if /i "%~1"=="/v"           set _Verbose=1& goto NextArg
if /i "%~1"=="/Tests"       goto SetTests
echo ERROR: Unknown argument '%~1'.&exit /b -1

:NextArg
shift
goto ArgLoopStart

:SetDeviceId
shift
set _DeviceId=%~1
goto :NextArg

:SetPlatform
shift
set _Platform=%~1&
goto :NextArg

:SetSdkRoot
shift
set _SdkRoot=%~1
goto :NextArg

:SetNdkRoot
shift
set _NdkRoot=%~1
goto :NextArg

:SetTests
shift
if "%~1"=="" goto SetTestsDone
set _TestsToRun="%~1" %_TestsToRun%
goto SetTests
:SetTestsDone
goto ArgLoopEnd

:ArgLoopEnd

if NOT exist "%_SdkRoot%" echo ERROR: Android SDK does not exist at "%_SdkRoot%".& exit /b -1
if NOT exist "%_NdkRoot%" echo ERROR: Android NDK does not exist at "%_NdkRoot%".& exit /b -1

if "%_DeviceId%"=="" echo ERROR: DeviceId must be specified. Possible devices are:& "%_AdbExe%" devices &goto Help
if "%_Platform%"=="" echo ERROR: Platform must be specified.& goto Help

set _GlassFlags=-f TestScript.xml -e ErrorLog.xml -s SessionLog.xml -err -nodefaultsetup -nodvt
if not "%_Verbose%"=="1" set _GlassFlags=%_GlassFlags% -q

set _GlassLog=
if NOT "%_Verbose%"=="1" set _GlassLog=^> glass.log

if "%_Verbose%"=="1" (
    echo DeviceId:    %_DeviceId%
    echo Platform:    %_Platform%
    echo SdkRoot:     "%_SdkRoot%"
    echo NdkRoot:     "%_NdkRoot%"
    echo Tests:       %_TestsToRun%
	echo Glass Flags: %_GlassFlags%
)

if "%_TestsToRun%"=="" goto RunAll
goto RunArgs

:RunAll
    set FAILED_TESTS=
    
    pushd %~dp0\
    
    for /d %%t in (*) do if exist "%%t\TestScript.xml" call :RunSingleTest "%%t"
    goto ReportResults

:RunArgs
    set FAILED_TESTS=
    
    pushd %~dp0
    for %%t in (%_TestsToRun%) do call :ValidateArg %%t
    if NOT "%FAILED_TESTS%"=="" exit /b -1
    for %%t in (%_TestsToRun%) do call :RunSingleTest %%t
    goto ReportResults

:ReportResults
    echo ----------------------------------------
    if NOT "%FAILED_TESTS%"=="" goto ReportFailure
    goto ReportSuccess
    
:ReportFailure
    echo ERROR: Failures detected 'RunTests.cmd /DeviceId %_DeviceId% /Platform %_Platform% /Tests %FAILED_TESTS%' to rerun.
    echo.
    exit /b -1
    
:ReportSuccess
    echo All tests completed succesfully.
    echo.
    exit /b 0
    
:ValidateArg
    if not exist "%~1" echo ERROR: Test '%~1' does not exist.& set FAILED_TESTS="%~1" %FAILED_TESTS%& exit /b 0
    if not exist "%~1\TestScript.xml" echo ERROR: Test '%~1' does not have a TestScript.xml file.& set FAILED_TESTS="%~1" %FAILED_TESTS%& exit /b 0
    exit /b 0

:RunSingleTest
    pushd "%~1"
    echo Running '%~1'
    
    ::Build the app
    call msbuild /p:Platform=%_Platform%;VS_NDKRoot="%_NdkRoot%";VS_SDKRoot="%_SdkRoot%";PackageDebugSymbols=true > build.log
    if NOT "%ERRORLEVEL%"=="0" echo ERROR: Failed to build %~1. See build.log for more information.& set FAILED_TESTS="%~1" "%FAILED_TESTS%"& goto RunSingleTestDone
    
    ::Deploy the app
    call "%_SdkRoot%\platform-tools\adb.exe" -s %_DeviceId% install -r %_Platform%\Debug\%~1.apk > adb.log
    if NOT "%ERRORLEVEL%"=="0" echo ERROR: adb failed for one reason or another.& set FAILED_TESTS="%~1" "%FAILED_TESTS%"& goto RunSingleTestDone
    
    ::Create temp directory
    if not exist temp mkdir temp
    
    ::Generate the LaunchOptions
    call %_GlassDir%LaunchOptionsGen.exe LaunchOptions.xml.template "SdkRoot=%_SdkRoot%\ " "NdkRoot=%_NdkRoot%\ " "TargetArchitecture=%_Platform%" "IntermediateDirectory=%~dp1temp\ " "AdditionalSOLibSearchPath=%~dp1%_Platform%\Debug\ " "DeviceId=%_DeviceId%"

    ::Run Glass
    call "%_GlassDir%glass2.exe" %_GlassFlags% %_GlassLog%
    if NOT "%ERRORLEVEL%"=="0" echo ERROR: Test failed. See ErrorLog.xml for more information.& set FAILED_TESTS="%~1" %FAILED_TESTS%
    
    :RunSingleTestDone
    popd
    exit /b 0

::These are functions called at the beginning
	
:EnsureGlassRegisterd
reg query HKLM\SOFTWARE\Microsoft\glass\14.0 1>NUL 2>NUL
if errorlevel 1 reg query HKLM\SOFTWARE\Wow6432Node\Microsoft\glass\14.0 1>NUL 2>NUL & if errorlevel 1 echo Running RegisterGlass.cmd... & call "%_GlassDir%RegisterGlass.cmd" & call "%~dp0..\RegisterMIEngine.cmd"
exit /b 0

:EnsureLaunchOptionsGenBuilt
if not exist %_GlassDir%LaunchOptionsGen.exe echo Building LaunchOptionsGen.exe& msbuild /p:Configuration=Release;OutDir=%_GlassDir% /v:quiet %~dp0..\LaunchOptionsGen\LaunchOptionsGen.csproj
exit /b 0

:Help
echo --- MIEngine Android Test Script ---
echo Usage: androidtest.cmd /DeviceId ^<id^> /Platform ^<platform^> [/SdkRoot ^<path^>] [/NdkRoot ^<path^>] [/v] [/Tests ^<test 1^> [^<test 2^> [...]]]
echo. 
echo --- Examples --- 
echo Run All Tests:
echo androidtest.cmd /DeviceId emulator-5554 /Platform x86 
echo.
echo Run two specific tests:
echo androidtest.cmd /DeviceId emulator-5554 /Platform x86 /Tests Stepping Exceptions
echo.

if exist "%_SdkRoot%" "%_SdkRoot%\platform-tools\adb.exe" devices -l

:EOF