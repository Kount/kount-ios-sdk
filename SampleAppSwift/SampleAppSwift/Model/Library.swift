//
//  Library.swift
//  SampleAppSwift
//
//  Created by Alejandro Villalobos on 17-06-24.
//

protocol Library {
    var type: LibraryType { get }
    var parameters: [LibraryParameter] { get }
    
    func start()
    func stop()
}
