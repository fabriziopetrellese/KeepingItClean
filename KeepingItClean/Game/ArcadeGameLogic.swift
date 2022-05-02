//
//  GameLogic.swift
//  ArcadeGameTemplate
//

import Foundation
import SwiftUI

class ArcadeGameLogic: ObservableObject {
    
    static let shared: ArcadeGameLogic = ArcadeGameLogic()
    
    func setUpGame() {
        
        self.isGameOver = false
    }
    
    @Published var currentScore: Int = 0
    @AppStorage("Higher") var highScore: Int = 0
    
    func score(points: Int) {
        self.currentScore = self.currentScore + points
    }
    
    @Published var sessionDuration: TimeInterval = 0
    
    func increaseSessionTime(by timeIncrement: TimeInterval) {
        self.sessionDuration = self.sessionDuration + timeIncrement
    }
    
    func restartGame() {
        self.setUpGame()
    }
    
    @Published var isGameOver: Bool = false
    
    func finishTheGame() {
        if self.isGameOver == false {
            self.isGameOver = true
        }
    }
    
    @Published var hearts = 3
    @Published var plasticTouches = 0
    
    func loseHeart() {
        if hearts > 1 {
            hearts -= 1
        }
    }
    func bottleTouches() {
        plasticTouches += 1
    }
}
