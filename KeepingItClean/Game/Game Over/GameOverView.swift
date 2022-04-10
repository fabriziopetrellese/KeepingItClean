//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameOverView
 *   This view is responsible for showing the game over state of the game.
 *  Currently it only present buttons to take the player back to the main screen or restart the game.
 *
 *  You can also present score of the player, present any kind of achievements or rewards the player
 *  might have accomplished during the game session, etc...
 **/

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    
    var body: some View {
//        ZStack {
//            Color.clear
//                .ignoresSafeArea()
            
            VStack {
//                Spacer()
                
//                Button {
//                    withAnimation { self.backToMainScreen() }
//                } label: {
//                    Image(systemName: "arrow.backward")
//                        .foregroundColor(.black)
//                        .font(.title)
//                }
//                .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 100, height: 100, alignment: .center))
                Text("Your score")
                    .foregroundColor(.white)
                    .font(Font.custom("Chava", size: 40))
                    .padding(.bottom)
                Text("\(ArcadeGameLogic.shared.currentScore)")
                    .foregroundColor(.white)
                    .font(Font.custom("Chava", size: 47))
                    .padding(.bottom, 50)
//                Spacer()
                Button {
                    ArcadeGameLogic.shared.currentScore = 0
                    ArcadeGameLogic.shared.plasticTouches = 0
                    ArcadeGameLogic.shared.hearts = 3
                    withAnimation {
                        self.restartGame()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6))
                            .frame(width: 150, height: 140, alignment: .center))
                        .padding(40)
//                        .padding(.top, 30)
//                        .padding(.bottom, 50)
                }
//                .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6)).frame(width: 150, height: 150, alignment: .center))
//                .padding(.top, 30)
//                .padding(.bottom, 50)
                
//                Spacer()
            }
            .onAppear(){
                MusicClass.shared.stop()
            }
            .background(
                Image("backPolluted")
                    .ignoresSafeArea()
            )
//        }
        .statusBar(hidden: true)
    }
    
    private func backToMainScreen() {
        self.currentGameState = .mainScreen
    }
    
    private func restartGame() {
        self.currentGameState = .playing
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(currentGameState: .constant(GameState.gameOver))
    }
}
