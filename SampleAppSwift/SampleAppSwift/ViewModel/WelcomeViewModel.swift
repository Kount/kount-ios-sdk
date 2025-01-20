//
//  WelcomeViewModel.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 21-03-24.
//

class WelcomeViewModel  {
    var onOpenSettings: (() -> Void)?
    
    
    func openSettings() {
        onOpenSettings?()
    }
}
