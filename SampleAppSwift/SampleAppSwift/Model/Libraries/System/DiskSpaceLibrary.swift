//
//  DiskSpaceLibrary.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 27-08-24.
//

import Foundation

protocol DiskSpaceManagerProtocol {
    func getUsedDiskSpace() -> String?
    func getAvailableDiskSpace() -> String?
    func getTotalDiskSpace() -> String?
}

final class DiskSpaceLibrary: Library {
    private weak var observer: LibraryDataObserver?
    private let fileManager: FileManager
    
    var type: LibraryType { return .diskSpace }
    var parameters: [LibraryParameter] = []
    
    init(observer: LibraryDataObserver, fileManager: FileManager = FileManager.default) {
        self.observer = observer
        self.fileManager = fileManager
        self.parameters = [
            LibraryParameter(name: "Total Disk Space", requiresLiveUpdates: false, value: getTotalDiskSpace() ?? "N/A"),
            LibraryParameter(name: "Available Disk Space", requiresLiveUpdates: false, value: getAvailableDiskSpace() ?? "N/A"),
            LibraryParameter(name: "Used Disk Space", requiresLiveUpdates: false, value: getUsedDiskSpace() ?? "N/A")
        ]
    }
    
    func start() {
        observer?.didUpdateLibraryData(fetchLibraryData(), for: type)
    }
    
    func stop() {
        // No-op since there's no ongoing process to stop.
    }
    
    private func fetchLibraryData() -> [String: String] {
        var data: [String: String] = [:]
        parameters.forEach { parameter in
            data[parameter.name] = parameter.value
        }
        return data
    }
    
    func getUsedDiskSpace() -> String? {
        guard let totalSpace = getTotalDiskSpaceInBytes(), let freeSpace = getAvailableDiskSpaceInBytes() else {
            return nil
        }
        let usedSpace = totalSpace - freeSpace
        return ByteCountFormatter.string(fromByteCount: usedSpace, countStyle: .file)
    }
    
    func getAvailableDiskSpace() -> String? {
        return getDiskSpace(for: .systemFreeSize)
    }
    
    func getTotalDiskSpace() -> String? {
        return getDiskSpace(for: .systemSize)
    }
    
    private func getDiskSpace(for key: FileAttributeKey) -> String? {
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let space = attributes[key] as? NSNumber {
                return ByteCountFormatter.string(fromByteCount: space.int64Value, countStyle: .file)
            }
        } catch {
            print("Error retrieving disk space: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func getTotalDiskSpaceInBytes() -> Int64? {
        return getDiskSpaceInBytes(for: .systemSize)
    }
    
    private func getAvailableDiskSpaceInBytes() -> Int64? {
        return getDiskSpaceInBytes(for: .systemFreeSize)
    }
    
    private func getDiskSpaceInBytes(for key: FileAttributeKey) -> Int64? {
        do {
            let attributes = try fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
            if let space = attributes[key] as? NSNumber {
                return space.int64Value
            }
        } catch {
            print("Error retrieving disk space: \(error.localizedDescription)")
        }
        return nil
    }
}
