//
//  MainScreen.swift
//  ArcadeGameTemplate
//

import SwiftUI

struct MainScreenView: View {
    
    @Binding var currentGameState: GameState
    var gameTitle: String = MainScreenProperties.gameTitle
    var gameTitle2: String = MainScreenProperties.gameTitle2
    var gameInstructions: [Instruction] = MainScreenProperties.gameInstructions
    let accentColor: Color = MainScreenProperties.accentColor
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Spacer()
            VStack {
            Text("\(self.gameTitle)")
                .font(Font.custom("Chava", size: 58))
                .padding(.top, 24.0)
                Text("\(self.gameTitle2)")
                    .font(Font.custom("Chava", size: 58))
                    .padding(.trailing, 10)
        }
            Spacer()
            ForEach(self.gameInstructions, id: \.title) { instruction in
                GroupBox(label: Label("\(instruction.title)", systemImage: "\(instruction.icon)").foregroundColor(self.accentColor).font(Font.custom("Chava", size: 18))) {
                    HStack {
                        Text("\(instruction.description)")
                            .font(Font.custom("Chava", size: 15))
                            .font(.callout)
                            .padding(.top, 3)
                        Spacer()
                    }
                }
            }
            
            Spacer()
            
            Button {
                withAnimation { self.startGame() }
            } label: {
                Text("SAVE THE SEA")
                    .font(Font.custom("Chava", size: 20))
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .foregroundColor(.white)
            .background(self.accentColor)
            .cornerRadius(10.0)
            .padding(.bottom)
            
        }
        .padding()
        .statusBar(hidden: true)
    }
    
    private func startGame() {
        self.currentGameState = .playing
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView(currentGameState: .constant(GameState.mainScreen))
    }
}
