//
//  AlertEssentials.swift
//  WeatherApp

import UIKit

typealias NullableCompletion = (() -> Void)?

enum AlertButton {
    case cancel, ok(NullableCompletion)
    
    var name: String {
        switch self {
        case .cancel: return "Cancel"
        case .ok: return "Ok"
        }
    }
    
    var action: NullableCompletion {
        switch self {
        case .cancel: return nil
        case .ok(let closure):
            return {
                closure?()
            }
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .cancel: return .cancel
        default: return .default
        }
    }
}
