//
//  GameOverView.swift
//  ArcadeGameTemplate
//

import SwiftUI

struct GameOverView: View {
    
    @Binding var currentGameState: GameState
    
    var body: some View {
            
            VStack {
                Spacer()
                    Text("High score")
                        .foregroundColor(.yellow)
                        .font(Font.custom("Chava", size: 54))
                        .padding(.bottom, 1)
                
                    Text("\(ArcadeGameLogic.shared.highScore)")
                        .foregroundColor(.yellow)
                        .font(Font.custom("Chava", size: 54))
                        .padding(.bottom, 55)
                
//                Spacer()
                Divider()
                    .frame(width: 0.8 * UIScreen.main.bounds.width)
                    .padding(.bottom, 55)
                
                Text("Your score")
                    .foregroundColor(.white)
                    .font(Font.custom("Chava", size: 30))
                    .padding(.bottom, 1)
                
                Text("\(ArcadeGameLogic.shared.currentScore)")
                    .foregroundColor(.white)
                    .font(Font.custom("Chava", size: 40))
                    .padding(.bottom, 105)
                
                Spacer()
                
                Button {
                    ArcadeGameLogic.shared.plasticTouches = 0
                    ArcadeGameLogic.shared.hearts = 3
                    withAnimation {
                        self.restartGame()
                    }
                } label: {
                    ZStack {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .background(Circle().foregroundColor(Color(uiColor: UIColor.systemGray6))
                                .frame(width: 110, height: 100, alignment: .center))
                        
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 2)
                            .frame(width: 110, height: 100)
                    }
                }
            }
            .padding(.bottom, 80)
            .onAppear(){
                MusicClass.shared.stop()
            }
            .background(
                Image("backPolluted")
                    .resizable()
                    .frame(width: 1 * UIScreen.main.bounds.width, height: 1 * UIScreen.main.bounds.height)
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
