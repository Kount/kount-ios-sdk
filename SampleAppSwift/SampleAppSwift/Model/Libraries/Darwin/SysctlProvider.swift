//
//  SysctlProvider.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 03-09-24.
//

import Foundation

protocol SysctlProvider {
    func sysctlbyname(_ name: String,
                      _ oldp: UnsafeMutableRawPointer?,
                      _ oldlenp: UnsafeMutablePointer<Int>?,
                      _ newp: UnsafeMutableRawPointer?,
                      _ newlen: Int) -> Int32
}

extension SysctlProvider {
    func sysctlbyname(_ name: String,
                      _ oldp: UnsafeMutableRawPointer?,
                      _ oldlenp: UnsafeMutablePointer<Int>?,
                      _ newp: UnsafeMutableRawPointer?,
                      _ newlen: Int) -> Int32 {
        // Explicitly reference the Darwin C function to avoid recursion
        return name.withCString { cName in
            Darwin.sysctlbyname(cName, oldp, oldlenp, newp, newlen)
        }
    }
    
    // Helper function for getting String results from sysctl calls
    func sysctlString(name: String) -> String? {
        var size = 0
        // Get the size of the data returned by sysctl
        if sysctlbyname(name, nil, &size, nil, 0) != 0 {
            return nil
        }
        // Allocate buffer and fetch the actual data
        var buffer = [CChar](repeating: 0, count: size)
        if sysctlbyname(name, &buffer, &size, nil, 0) != 0 {
            return nil
        }
        return String(cString: buffer) // Convert the C-string to a Swift String
    }
    
    // Helper function for getting Int32 results from sysctl calls
    func sysctlInt32(name: String) -> Int32? {
        var value: Int32 = 0
        var size = MemoryLayout<Int32>.size
        // Fetch the Int32 value using sysctl
        if sysctlbyname(name, &value, &size, nil, 0) != 0 {
            return nil
        }
        return value
    }
    
    // Helper function for getting UInt64 results from sysctl calls
    func sysctlUInt64(name: String) -> UInt64? {
        var value: UInt64 = 0
        var size = MemoryLayout<UInt64>.size
        // Fetch the UInt64 value using sysctl
        if sysctlbyname(name, &value, &size, nil, 0) != 0 {
            return nil
        }
        return value
    }
}

class DefaultSysctlProvider: SysctlProvider {
    func sysctlbyname(_ name: String,
                      _ oldp: UnsafeMutableRawPointer?,
                      _ oldlenp: UnsafeMutablePointer<Int>?,
                      _ newp: UnsafeMutableRawPointer?,
                      _ newlen: Int) -> Int32 {
        // Explicitly reference the Darwin C function to avoid recursion
        return name.withCString { cName in
            Darwin.sysctlbyname(cName, oldp, oldlenp, newp, newlen)
        }
    }
}
