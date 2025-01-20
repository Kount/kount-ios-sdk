//
//  KernelAndCPULibrary.swift
//  SampleAppSwift
//
//  Created by Felipe Plaza on 28-08-24.
//

import Foundation

final class KernelHardwareLibrary: Library {
    private weak var observer: LibraryDataObserver?
    private var sysctlProvider: SysctlProvider
    
    var type: LibraryType { return .kernelHardware }
    var parameters: [LibraryParameter] = []
    
    init(observer: LibraryDataObserver, sysctlProvider: SysctlProvider = DefaultSysctlProvider()) {
        self.sysctlProvider = sysctlProvider
        self.observer = observer
        self.parameters = [
            // CPU Info
            LibraryParameter(name: "CPU Type", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Number of Processors", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Number of Physical CPU Cores", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Number of Logical CPU Cores", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "CPU Frequency", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Maximum CPU Frequency", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Minimum CPU Frequency", requiresLiveUpdates: false, value: "..."),
            
            // Memory Info
            LibraryParameter(name: "Amount of RAM", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Memory Page Size", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Pointer Authentication", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Memory Tagging Encryption", requiresLiveUpdates: false, value: "..."),
            
            // Battery Info
            LibraryParameter(name: "Current Battery Capacity", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Maximum Power Capacity", requiresLiveUpdates: false, value: "..."),
            
            // Device Info
            LibraryParameter(name: "Device Hostname", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Device Model", requiresLiveUpdates: false, value: "..."),
            
            //Operating Sistem Info
            LibraryParameter(name: "Kernel Name", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Kernel Version", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Operating System Version", requiresLiveUpdates: false, value: "..."),
            
            // Security Info
            LibraryParameter(name: "Host Security Level ID", requiresLiveUpdates: false, value: "..."),
            
            // Network & File Info
            LibraryParameter(name: "L1 Cache Size of the CPU", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "L2 Cache Size of the CPU", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Maximum Buffer Size for Network Sockets", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Maximum File Size", requiresLiveUpdates: false, value: "..."),
            LibraryParameter(name: "Maximum Number of Open File", requiresLiveUpdates: false, value: "...")
        ]
    }
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.fetchInitialData()
        }
    }
    
    func stop() {
        // No-op since there's no ongoing process to stop.
    }
    
    private func getCPUType() -> String {
        if let cpuType = sysctlProvider.sysctlInt32(name: "hw.cputype") {
            switch cpuType {
            case CPUType.ARM:
                return "ARM"
            case CPUType.ARM64:
                return "ARM64"
            case CPUType.X86:
                return "x86"
            case CPUType.X86_64:
                return "x86_64"
            default:
                return "Unknown"
            }
        } else {
            return "Unknown"
        }
    }
    
    private func getMemorySize() -> String {
        if let memSize = sysctlProvider.sysctlUInt64(name: "hw.memsize") {
            let doubleSize = Double(memSize) / (1024 * 1024 * 1024)
            return "\(doubleSize.rounded(.up)) GB"
        } else {
            return "0 GB"
        }
    }
    
    private func getCPUFrequency() -> String {
        if let cpuFrequency = sysctlProvider.sysctlUInt64(name: "hw.cpufrequency") {
            let intFrequency = Int(cpuFrequency) / 1_000_000
            return "\(intFrequency) MHz"
        } else {
            return "0 MHz"
        }
    }
    
    private func getBatteryDesignCapacity() -> String {
        if let batteryDesign = sysctlProvider.sysctlUInt64(name: "hw.acpi.battery.design") {
            let intBatteryDesign = Int(batteryDesign)
            return "\(intBatteryDesign) mAh"
        } else {
            return "0 mAh"
        }
    }
    
    private func getNumberOfCPUCores() -> String {
        if let cpuCores = sysctlProvider.sysctlInt32(name: "hw.ncpu") {
            let intCPUCores = Int(cpuCores)
            return "\(intCPUCores)"
        } else {
            return "0"
        }
    }
    
    private func getMaxFileSize() -> String {
        if let memSize = sysctlProvider.sysctlUInt64(name: "kern.maxfilesize") {
            let intSize = Int(memSize)
            return "\(intSize) bytes"
        } else {
            return "0 bytes"
        }
    }
    
    private func getKernelVersion() -> String {
        if let kernelVersion = sysctlProvider.sysctlString(name: "kern.osrelease") {
            return kernelVersion
        } else {
            return "Unknown"
        }
    }
    
    private func getHostName() -> String {
        if let hostName = sysctlProvider.sysctlString(name: "kern.hostname") {
            return hostName
        } else {
            return "Unknown"
        }
    }
    
    private func getDeviceModel() -> String {
        if let deviceModel = sysctlProvider.sysctlString(name: "kern.model") {
            return deviceModel
        } else {
            return "Unknown"
        }
    }
    
    private func getKernelName() -> String {
        if let kernelName = sysctlProvider.sysctlString(name: "kern.ostype") {
            return kernelName
        } else {
            return "Unknown"
        }
    }
    
    private func getOSVersion() -> String {
        if let osVersion = sysctlProvider.sysctlString(name: "kern.osversion") {
            return osVersion
        } else {
            return "Unknown"
        }
    }
    
    private func getMaxCPUFrequency() -> String {
        if let maxCPUFrequency = sysctlProvider.sysctlUInt64(name: "hw.cpufrequency_max") {
            let intMaxFrequency = Int(maxCPUFrequency) / 1_000_000
            return "\(intMaxFrequency) MHz"
        } else {
            return "0 MHz"
        }
    }
    
    private func getMinCPUFrequency() -> String {
        if let minCPUFrequency = sysctlProvider.sysctlUInt64(name: "hw.cpufrequency_min") {
            let intMinFrequency = Int(minCPUFrequency) / 1_000_000
            return "\(intMinFrequency) MHz"
        } else {
            return "0 MHz"
        }
    }
    
    private func getBatteryRemainingCapacity() -> String {
        if let currentBattery = sysctlProvider.sysctlUInt64(name: "hw.acpi.battery.remaining") {
            let intCurrentBattery = Int(currentBattery)
            return "\(intCurrentBattery) mAh"
        } else {
            return "0 mAh"
        }
    }
    
    private func getL1CacheSize() -> String {
        if let cacheSize = sysctlProvider.sysctlUInt64(name: "hw.l1cachesize") {
            let intCacheSize = Int(cacheSize)
            return "\(intCacheSize) bytes"
        } else {
            return "0 bytes"
        }
    }
    
    private func getL2CacheSize() -> String {
        if let cacheSize = sysctlProvider.sysctlUInt64(name: "hw.l2cachesize") {
            let intCacheSize = Int(cacheSize)
            return "\(intCacheSize) bytes"
        } else {
            return "0 bytes"
        }
    }
    
    private func getPhysicalCPUCores() -> String {
        if let cpuCores = sysctlProvider.sysctlInt32(name: "hw.physicalcpu") {
            let intCPUCores = Int(cpuCores)
            return "\(intCPUCores)"
        } else {
            return "0"
        }
    }
    
    private func getKernelSecureLevel() -> String {
        if let secureLevel = sysctlProvider.sysctlInt32(name: "kern.securelevel") {
            let intSecureLevel = Int(secureLevel)
            return "\(intSecureLevel)"
        } else {
            return "0"
        }
    }
    
    private func getLogicalCPUCores() -> String {
        if let cpuCores = sysctlProvider.sysctlInt32(name: "hw.logicalcpu") {
            let intCPUCores = Int(cpuCores)
            return "\(intCPUCores)"
        } else {
            return "0"
        }
    }
    
    private func getMemoryTaggingEncryptionSupport() -> String {
        if let _ = sysctlProvider.sysctlInt32(name: "hw.optional.arm.FEAT_MTE") {
            return "Supported"
        } else {
            return "Not Supported"
        }
    }
    
    private func getPointerAuthenticationSupport() -> String {
        if let _ = sysctlProvider.sysctlInt32(name: "hw.optional.arm.FEAT_PAuth") {
            return "Supported"
        } else {
            return "Not Supported"
        }
    }
    
    private func getPageSize() -> String {
        if let pageSize = sysctlProvider.sysctlInt32(name: "hw.pagesize") {
            let intPageSize = Int(pageSize)
            return "\(intPageSize) bytes"
        } else {
            return "0 bytes"
        }
    }
    
    private func getMaxSocketBufferSize() -> String {
        if let maxBufferSize = sysctlProvider.sysctlInt32(name: "kern.ipc.maxsockbuf") {
            let intMaxBufferSize = Int(maxBufferSize)
            return "\(intMaxBufferSize) bytes"
        } else {
            return "0 bytes"
        }
    }
    
    private func getMaxOpenFiles() -> String {
        if let maxOpenFiles = sysctlProvider.sysctlInt32(name: "kern.maxfiles") {
            let intMaxOpenFiles = Int(maxOpenFiles)
            return "\(intMaxOpenFiles)"
        } else {
            return "0"
        }
    }
    
    private func fetchInitialData() {
        let data = fetchLibraryData()
        observer?.didUpdateLibraryData(data, for: type)
    }
    
    private func fetchLibraryData() -> [String: String] {
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            switch parameter.name {
            case "CPU Frequency":
                data[parameter.name] = getCPUFrequency()
            case "CPU Type":
                data[parameter.name] = getCPUType()
            case "Number of Processors":
                data[parameter.name] = getNumberOfCPUCores()
            case "Maximum CPU Frequency":
                data[parameter.name] = getMaxCPUFrequency()
            case "Minimum CPU Frequency":
                data[parameter.name] = getMinCPUFrequency()
            case "Number of Physical CPU Cores":
                data[parameter.name] = getPhysicalCPUCores()
            case "Number of Logical CPU Cores":
                data[parameter.name] = getLogicalCPUCores()
            case "Amount of RAM":
                data[parameter.name] = getMemorySize()
            case "Memory Tagging Encryption":
                data[parameter.name] = getMemoryTaggingEncryptionSupport()
            case "Memory Page Size":
                data[parameter.name] = getPageSize()
            case "Pointer Authentication":
                data[parameter.name] = getPointerAuthenticationSupport()
            case "Current Battery Capacity":
                data[parameter.name] = getBatteryRemainingCapacity()
            case "Maximum Power Capacity":
                data[parameter.name] = getBatteryDesignCapacity()
            case "Device Hostname":
                data[parameter.name] = getHostName()
            case "Device Model":
                data[parameter.name] = getDeviceModel()
            case "Kernel Name":
                data[parameter.name] = getKernelName()
            case "Kernel Version":
                data[parameter.name] = getKernelVersion()
            case "Operating System Version":
                data[parameter.name] = getOSVersion()
            case "Host Security Level ID":
                data[parameter.name] = getKernelSecureLevel()
            case "L1 Cache Size of the CPU":
                data[parameter.name] = getL1CacheSize()
            case "L2 Cache Size of the CPU":
                data[parameter.name] = getL2CacheSize()
            case "Maximum Buffer Size for Network Sockets":
                data[parameter.name] = getMaxSocketBufferSize()
            case "Maximum File Size":
                data[parameter.name] = getMaxFileSize()
            default:
                //Maximum Number of Open File
                data[parameter.name] = getMaxOpenFiles()
            }
        }
        return data
    }
}
