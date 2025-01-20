//
//  LibraryPickerViewModel.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 21-03-24.
//

import CoreMotion

class LibraryPickerViewModel {
    var libraryOptions: [LibraryOption]
    var title: String
    
    init(libraryCategory: LibraryCategory) {
        switch libraryCategory {
        case .coreMotion:
            title = "Core Motion"
            libraryOptions = [
                LibraryOption(title: "Accelerometer", libraryType: .accelerometer, isEnabled: false),
                LibraryOption(title: "Altimeter Absolute", libraryType: .altimeterAbsolute, isEnabled: false),
                LibraryOption(title: "Altimeter Relative", libraryType: .altimeterRelative, isEnabled: false),
                LibraryOption(title: "Device Motion", libraryType: .deviceMotion, isEnabled: false),
                LibraryOption(title: "Gyroscope", libraryType: .gyroscope, isEnabled: false),
                LibraryOption(title: "Magnetometer", libraryType: .magnetometer, isEnabled: false),
                LibraryOption(title: "Motion Activity", libraryType: .motionActivity, isEnabled: false),
                LibraryOption(title: "Pedometer", libraryType: .pedometer, isEnabled: false),
            ]
        case .darwin:
            title = "Darwin"
            libraryOptions = [
                LibraryOption(title: "Kernel and Hardware", libraryType: .kernelHardware, isEnabled: false)
            ]
        case .system:
            title = "System"
            libraryOptions = [
                LibraryOption(title: "Disk Space", libraryType: .diskSpace, isEnabled: false),
            ]
        case .uiKit:
            title = "UIKit"
            libraryOptions = [
                LibraryOption(title: "Device Info", libraryType: .deviceInfo, isEnabled: false),
                LibraryOption(title: "Screen Brightness", libraryType: .screenBrightness, isEnabled: false)
            ]
        }
    }
    
    func toggleLibrary(at index: Int) {
        let libraryType = libraryOptions[index].libraryType
        let isEnabled = libraryOptions[index].isEnabled
        libraryOptions[index].isEnabled.toggle()
        
        if isEnabled {
            LibraryManager.shared.shouldEnableLibrary(false, for: libraryType)
        } else {
            LibraryManager.shared.shouldEnableLibrary(true, for: libraryType)
        }
    }
    
    func getEnabledLibraries() -> [LibraryType] {
        return libraryOptions.filter { $0.isEnabled }.map { $0.libraryType }
    }
}
