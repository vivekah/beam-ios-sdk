//
//  BeamError.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 9/25/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation

public enum BeamError {
    case invalidUser
    case invalidStore
    case invalidCredentials
    case invalidConfiguration
    case networkError
    case none
}

enum BeamRegisterUserError: Error {
    case invalidEmail
    case invalidPhone
    case invalidBirthdate
}
