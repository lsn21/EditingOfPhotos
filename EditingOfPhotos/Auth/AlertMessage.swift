//
//  AlertMessage.swift
//  EditingOfPhotos
//
//  Created by SIARHEI LUKYANAU on 07.09.2024.
//

import Foundation

enum TypeAlert {
    case error
    case verification
    case reset
}

struct AlertMessage: Identifiable {
    var id = UUID()
    let typeAlert: TypeAlert
    let title: String
    let message: String
}
