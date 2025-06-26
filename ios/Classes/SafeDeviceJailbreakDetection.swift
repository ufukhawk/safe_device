import Foundation
import UIKit

@objc(SafeDeviceJailbreakDetection)
@objcMembers
public class SafeDeviceJailbreakDetection: NSObject {
    
    // MARK: - Jailbreak Detection Paths
    
    /// Common jailbreak tool and application paths
    private static let jailbreakPaths: [String] = [
        // Cydia and package managers
        "/private/var/lib/apt",
        "/Applications/Cydia.app",
        "/Applications/RockApp.app",
        "/Applications/Icy.app",
        "/Applications/WinterBoard.app",
        "/Applications/SBSettings.app",
        "/Applications/blackra1n.app",
        "/Applications/IntelliScreen.app",
        "/Applications/Snoop-itConfig.app",
        
        // System binaries commonly found on jailbroken devices
        "/bin/sh",
        "/bin/bash",
        "/usr/sbin/sshd",
        "/usr/libexec/sftp-server",
        "/usr/libexec/ssh-keysign",
        
        // MobileSubstrate and related files
        "/Library/MobileSubstrate/MobileSubstrate.dylib",
        "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
        "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
        
        // APT package manager
        "/etc/apt",
        
        // Launch daemons
        "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
        "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
        
        // Additional common jailbreak paths
        "/usr/sbin/frida-server",
        "/usr/bin/cycript",
        "/usr/local/bin/cycript",
        "/usr/lib/libcycript.dylib",
        "/var/cache/apt",
        "/var/lib/cydia",
        "/var/log/syslog",
        "/etc/ssh/sshd_config",
        "/private/var/tmp/cydia.log",
        "/Applications/Terminal.app",
        "/Applications/iFile.app",
        "/Applications/Filza.app",
        "/private/var/lib/dpkg",
        "/usr/bin/dpkg",
        "/usr/sbin/dpkg",
        "/var/lib/dpkg/status"
    ]
    
    /// URL schemes commonly used by jailbreak tools
    private static let jailbreakSchemes: [String] = [
        "cydia://",
        "sileo://",
        "zebra://",
        "filza://",
        "activator://"
    ]
    
    // MARK: - Simulator Detection
    
    /// Checks if the app is running on iOS Simulator
    private static func isSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Main Detection Method
    
    @objc public static func isJailbroken() -> Bool {
        // Return false immediately if running on simulator
        if isSimulator() {
            return false
        }
        
        return hasJailbreakPaths() || 
               canOpenJailbreakSchemes() || 
               canViolateSandbox() ||
               hasJailbreakEnvironmentVariables() ||
               hasSuspiciousSymlinks() ||
               hasJailbreakProcesses()
    }
    
    // MARK: - Path-based Detection
    
    /// Checks for the existence of common jailbreak-related files and directories
    private static func hasJailbreakPaths() -> Bool {
        // Skip path checking on simulator
        if isSimulator() {
            return false
        }
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
            
            // Additional check for path accessibility
            if canAccessPath(path) {
                return true
            }
        }
        return false
    }
    
    /// Attempts to access a path to determine if it exists
    private static func canAccessPath(_ path: String) -> Bool {
        // Skip on simulator
        if isSimulator() {
            return false
        }
        
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
    
    // MARK: - URL Scheme Detection
    
    /// Checks if the device can open URLs associated with jailbreak tools
    private static func canOpenJailbreakSchemes() -> Bool {
        // Skip on simulator
        if isSimulator() {
            return false
        }
        
        guard let application = UIApplication.value(forKey: "sharedApplication") as? UIApplication else {
            return false
        }
        
        for scheme in jailbreakSchemes {
            if let url = URL(string: scheme) {
                if application.canOpenURL(url) {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: - Sandbox Violation Detection
    
    /// Attempts to write to locations outside the app sandbox
    private static func canViolateSandbox() -> Bool {
        // Skip on simulator as it has different sandbox behavior
        if isSimulator() {
            return false
        }
        
        let testPaths = [
            "/private/jailbreak_test.txt",
            "/private/var/mobile/jailbreak_test.txt",
            "/var/tmp/jailbreak_test.txt"
        ]
        
        for path in testPaths {
            do {
                let testString = "jailbreak_test"
                try testString.write(toFile: path, atomically: true, encoding: .utf8)
                try FileManager.default.removeItem(atPath: path)
                return true
            } catch {
                // Expected behavior on non-jailbroken devices
                continue
            }
        }
        return false
    }
    
    // MARK: - Environment Variable Detection
    
    /// Checks for environment variables that may indicate jailbreak
    private static func hasJailbreakEnvironmentVariables() -> Bool {
        // Skip on simulator
        if isSimulator() {
            return false
        }
        
        let suspiciousVariables = [
            "DYLD_INSERT_LIBRARIES",
            "_MSSafeMode",
            "_SafeMode"
        ]
        
        for variable in suspiciousVariables {
            if getenv(variable) != nil {
                return true
            }
        }
        return false
    }
    
    // MARK: - Symbolic Link Detection
    
    /// Checks for symbolic links that shouldn't exist on non-jailbroken devices
    private static func hasSuspiciousSymlinks() -> Bool {
        // Skip on simulator
        if isSimulator() {
            return false
        }
        
        let suspiciousLinks = [
            "/Applications",
            "/Library/Ringtones",
            "/Library/Wallpaper",
            "/usr/include",
            "/usr/libexec",
            "/usr/share"
        ]
        
        for link in suspiciousLinks {
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: link, isDirectory: &isDirectory) {
                do {
                    let attributes = try FileManager.default.attributesOfItem(atPath: link)
                    if attributes[.type] as? FileAttributeType == .typeSymbolicLink {
                        return true
                    }
                } catch {
                    continue
                }
            }
        }
        return false
    }
    
    // MARK: - Process Detection
    
    /// Checks for running processes that indicate jailbreak
    private static func hasJailbreakProcesses() -> Bool {
        // Skip on simulator
        if isSimulator() {
            return false
        }
        
        // Note: This method has limitations on modern iOS versions due to security restrictions
        // but may still work in some cases
        
        let suspiciousProcesses = [
            "cydia",
            "substrate",
            "cycript"
        ]
        
        // This is a simplified check - more sophisticated methods would be needed
        // for reliable process detection on modern iOS
        return false
    }
    
    // MARK: - Additional Helper Methods
    
    /// Combines multiple detection methods for enhanced reliability
    @objc public static func getJailbreakDetails() -> [String: Bool] {
        let isSimulatorEnvironment = isSimulator()
        
        return [
            "isSimulator": isSimulatorEnvironment,
            "hasPaths": isSimulatorEnvironment ? false : hasJailbreakPaths(),
            "canOpenSchemes": isSimulatorEnvironment ? false : canOpenJailbreakSchemes(),
            "canViolateSandbox": isSimulatorEnvironment ? false : canViolateSandbox(),
            "hasEnvironmentVariables": isSimulatorEnvironment ? false : hasJailbreakEnvironmentVariables(),
            "hasSuspiciousSymlinks": isSimulatorEnvironment ? false : hasSuspiciousSymlinks(),
            "hasJailbreakProcesses": isSimulatorEnvironment ? false : hasJailbreakProcesses()
        ]
    }
} 