//
//  Constants.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftUI


enum GameState {
    case mainScreen
    case playing
    case gameOver
}
typealias Instruction = (icon: String, title: String, description: String)


struct MainScreenProperties {
    static let gameTitle: String = "Keeping it"
    static let gameTitle2: String = "clean"
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.point.up.left", title: "Swipe to move", description: "Swipe left and right to move the boat"),
        (icon: "globe.americas", title: "Catch them", description: "Pick up the plastic before it falls into the sea"),
        (icon: "xmark.shield", title: "Don't let them pass!", description: "If three plastic bottles pass, you lose!")
    ]
    
    static let accentColor: Color = Color.accentColor
}
