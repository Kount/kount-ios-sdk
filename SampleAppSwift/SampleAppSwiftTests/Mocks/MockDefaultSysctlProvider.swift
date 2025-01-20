//
//  MockDefaultSysctlProvider.swift
//  SampleAppSwiftTests
//
//  Created by Felipe Plaza on 03-09-24.
//
import Darwin
@testable import SampleAppSwift

class MockSysctlProvider: SysctlProvider {
    var sysctlReturnValue: Int32 = 0
    var sysctlType: Int32 = CPUType.ARM64
    var sysctlCPUCores: Int32 = 6
    var sysctlPhysicalCores: Int32 = 6
    var sysctlLogicalCores: Int32 = 6
    var sysctlKernelSecureLevel: Int32 = 0
    var sysctlMemoryTaggingEncryption: Int32 = 0
    var sysctlPointerAuthentication: Int32 = 0
    var sysctlPageSize: Int32 = 16384
    var sysctlSocketBufferSize: Int32 = 6291456
    var sysctlMaxOpenFiles: Int32 = 10
    var sysctlKernelVersion: String = "20.6.0"
    var sysctlKernelName: String = "Darwin"
    var sysctlOSVersion: String = "22A354"
    var sysctlKernelModel: String = "Unknown"
    var sysctlHostname: String = "localhost"
    var sysctlCPUFrequency: UInt64 = 3500000000
    var sysctlMaxCPUFrequency: UInt64 = 4000000000
    var sysctlMinCPUFrequency: UInt64 = 3200000000
    var sysctlMaxBatteryCapacity: UInt64 = 4323
    var sysctlCurrentBattery: UInt64 = 3243
    var sysctlMemorySize: UInt64 = 16 * 1024 * 1024 * 1024 // 16 GB
    var sysctlMaxFileSize: UInt64 = 4294967296
    var sysctlL1CacheSize: UInt64 = 4294967
    var sysctlL2CacheSize: UInt64 = 4194304

    func sysctlbyname(_ name: String,
                      _ oldp: UnsafeMutableRawPointer?,
                      _ oldlenp: UnsafeMutablePointer<Int>?,
                      _ newp: UnsafeMutableRawPointer?,
                      _ newlen: Int) -> Int32 {
        if sysctlReturnValue != 0 {
            return sysctlReturnValue
        }

        return name.withCString { cName in
            if strcmp(cName, "hw.cputype") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlType
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.ncpu") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlCPUCores
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.physicalcpu") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlPhysicalCores
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.logicalcpu") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlLogicalCores
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "kern.securelevel") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlKernelSecureLevel
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.optional.arm.FEAT_MTE") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlMemoryTaggingEncryption
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.optional.arm.FEAT_PAuth") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlPointerAuthentication
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "kern.ipc.maxsockbuf") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlSocketBufferSize
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.pagesize") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlPageSize
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "kern.maxfiles") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: Int32.self).pointee = sysctlMaxOpenFiles
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<Int32>.size
                }
                return 0
            } else if strcmp(cName, "hw.memsize") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlMemorySize
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "kern.maxfilesize") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlMaxFileSize
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.cpufrequency") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlCPUFrequency
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.acpi.battery.design") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlMaxBatteryCapacity
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.acpi.battery.remaining") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlCurrentBattery
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.cpufrequency_max") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlMaxCPUFrequency
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.cpufrequency_min") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlMinCPUFrequency
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.l1cachesize") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlL1CacheSize
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "hw.l2cachesize") == 0 {
                if let oldp = oldp {
                    oldp.assumingMemoryBound(to: UInt64.self).pointee = sysctlL2CacheSize
                }
                if let oldlenp = oldlenp {
                    oldlenp.pointee = MemoryLayout<UInt64>.size
                }
                return 0
            } else if strcmp(cName, "kern.osrelease") == 0 {
                guard let oldlenp = oldlenp else {
                    return -1 // oldlenp is required to determine buffer size
                }

                if let oldp = oldp {
                    let requiredLength = sysctlKernelVersion.utf8.count + 1
                    let bufferSize = oldlenp.pointee
                    let maxLength = min(bufferSize, requiredLength)

                    sysctlKernelVersion.withCString { cString in
                        strncpy(oldp.assumingMemoryBound(to: CChar.self), cString, maxLength - 1)
                        oldp.assumingMemoryBound(to: CChar.self)[maxLength - 1] = 0 // Null terminator
                    }
                }

                oldlenp.pointee = sysctlKernelVersion.utf8.count + 1
                return 0
            } else if strcmp(cName, "kern.ostype") == 0 {
                guard let oldlenp = oldlenp else {
                    return -1 // oldlenp is required to determine buffer size
                }

                if let oldp = oldp {
                    let requiredLength = sysctlKernelName.utf8.count + 1
                    let bufferSize = oldlenp.pointee
                    let maxLength = min(bufferSize, requiredLength)

                    sysctlKernelName.withCString { cString in
                        strncpy(oldp.assumingMemoryBound(to: CChar.self), cString, maxLength - 1)
                        oldp.assumingMemoryBound(to: CChar.self)[maxLength - 1] = 0 // Null terminator
                    }
                }

                oldlenp.pointee = sysctlKernelName.utf8.count + 1
                return 0
            } else if strcmp(cName, "kern.model") == 0 {
                guard let oldlenp = oldlenp else {
                    return -1 // oldlenp is required to determine buffer size
                }

                if let oldp = oldp {
                    let requiredLength = sysctlKernelModel.utf8.count + 1
                    let bufferSize = oldlenp.pointee
                    let maxLength = min(bufferSize, requiredLength)

                    sysctlKernelModel.withCString { cString in
                        strncpy(oldp.assumingMemoryBound(to: CChar.self), cString, maxLength - 1)
                        oldp.assumingMemoryBound(to: CChar.self)[maxLength - 1] = 0 // Null terminator
                    }
                }

                oldlenp.pointee = sysctlKernelName.utf8.count + 1
                return 0
            } else if strcmp(cName, "kern.hostname") == 0 {
                guard let oldlenp = oldlenp else {
                    return -1 // oldlenp is required to determine buffer size
                }

                if let oldp = oldp {
                    let requiredLength = sysctlHostname.utf8.count + 1
                    let bufferSize = oldlenp.pointee
                    let maxLength = min(bufferSize, requiredLength)

                    sysctlHostname.withCString { cString in
                        strncpy(oldp.assumingMemoryBound(to: CChar.self), cString, maxLength - 1)
                        oldp.assumingMemoryBound(to: CChar.self)[maxLength - 1] = 0 // Null terminator
                    }
                }

                oldlenp.pointee = sysctlHostname.utf8.count + 1
                return 0
            } else if strcmp(cName, "kern.osversion") == 0 {
                guard let oldlenp = oldlenp else {
                    return -1 // oldlenp is required to determine buffer size
                }

                if let oldp = oldp {
                    let requiredLength = sysctlOSVersion.utf8.count + 1
                    let bufferSize = oldlenp.pointee
                    let maxLength = min(bufferSize, requiredLength)

                    sysctlOSVersion.withCString { cString in
                        strncpy(oldp.assumingMemoryBound(to: CChar.self), cString, maxLength - 1)
                        oldp.assumingMemoryBound(to: CChar.self)[maxLength - 1] = 0 // Null terminator
                    }
                }

                oldlenp.pointee = sysctlOSVersion.utf8.count + 1
                return 0
            } else {
                return -1 // Unknown sysctl name
            }
        }
    }
}
