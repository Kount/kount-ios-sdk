//
//  LibraryKitViewModel.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 03-06-24.
//

import Foundation

class LibraryKitViewModel {
    let options: [LibraryKitOption] = [
        LibraryKitOption(title: "CoreMotion", imageName: "layers", isEnabled: true),
        LibraryKitOption(title: "Darwin", imageName: "layers", isEnabled: true),
        LibraryKitOption(title: "System", imageName: "layers", isEnabled: true),
        LibraryKitOption(title: "UIKit", imageName: "layers", isEnabled: true)
    ]
}
