//
//  Constants.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftUI

/**
 * # Constants
 *
 * This file gathers contant values that are shared all around the project.
 * Modifying the values of these constants will reflect along the complete interface of the application.
 *
 **/


/**
 * # GameState
 * Defines the different states of the game.
 * Used for supporting the navigation in the project template.
 */

enum GameState {
    case mainScreen
    case playing
    case gameOver
}

typealias Instruction = (icon: String, title: String, description: String)

/**
 * # MainScreenProperties
 *
 * Keeps the information that shows up on the main screen of the game.
 *
 */

struct MainScreenProperties {
    static let gameTitle: String = "Keeping it"
    static let gameTitle2: String = "clean"
    
    static let gameInstructions: [Instruction] = [
        (icon: "hand.point.up.left", title: "Swipe to move", description: "Swipe left and right to move the boat"),
        (icon: "globe.americas", title: "Catch them", description: "Pick up the plastic before it falls into the sea"),
        (icon: "xmark.shield", title: "Don't let them pass!", description: "If three plastic bottle pass, you lose!")
    ]
    
    /**
     * To change the Accent Color of the application edit it on the Assets folder.
     */
    
    static let accentColor: Color = Color.accentColor
}
