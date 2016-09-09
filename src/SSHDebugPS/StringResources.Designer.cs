﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Microsoft.SSHDebugPS {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class StringResources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal StringResources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("Microsoft.SSHDebugPS.StringResources", typeof(StringResources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Connecting to the remote system failed due to authentication failure. Enter your updated connection info and try connecting again..
        /// </summary>
        internal static string AuthenticationFailureDescription {
            get {
                return ResourceManager.GetString("AuthenticationFailureDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Authentication Failure.
        /// </summary>
        internal static string AuthenticationFailureHeader {
            get {
                return ResourceManager.GetString("AuthenticationFailureHeader", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The specified directory {0} could not be created or accessed..
        /// </summary>
        internal static string Error_InvalidDirectory {
            get {
                return ResourceManager.GetString("Error_InvalidDirectory", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unable to obtain process listing. &apos;ps&apos; command failed..
        /// </summary>
        internal static string Error_PSFailed {
            get {
                return ResourceManager.GetString("Error_PSFailed", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Source file &apos;{0}&apos; not found.
        /// </summary>
        internal static string Error_SourceFileNotFound {
            get {
                return ResourceManager.GetString("Error_SourceFileNotFound", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Enter credentials to connect to {0}.
        /// </summary>
        internal static string HeaderTextFormat {
            get {
                return ResourceManager.GetString("HeaderTextFormat", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to SSH (Secure Shell) Transport allows connecting Visual Studio to computers running an SSH server with a bash-like shell (ex: Linux, macOS, etc)..
        /// </summary>
        internal static string PSDescription {
            get {
                return ResourceManager.GetString("PSDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &lt;username&gt;.
        /// </summary>
        internal static string UserName_PlaceHolder {
            get {
                return ResourceManager.GetString("UserName_PlaceHolder", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Connecting to {0}....
        /// </summary>
        internal static string WaitingOp_Connecting {
            get {
                return ResourceManager.GetString("WaitingOp_Connecting", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Running command &apos;{0}&apos; on the remote system....
        /// </summary>
        internal static string WaitingOp_ExecutingCommand {
            get {
                return ResourceManager.GetString("WaitingOp_ExecutingCommand", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Running ps on the remote system....
        /// </summary>
        internal static string WaitingOp_ExecutingPS {
            get {
                return ResourceManager.GetString("WaitingOp_ExecutingPS", resourceCulture);
            }
        }
    }
}
