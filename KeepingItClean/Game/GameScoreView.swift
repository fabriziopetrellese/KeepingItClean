//
//  GameScoreView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameScoreView
 * Custom UI to present how many points the player has scored.
 *
 * Customize it to match the visual identity of your game.
 */

struct GameScoreView: View {
    @Binding var score: Int
    
    var body: some View {
        
        HStack {
//            Image(systemName: "target")
//                .font(.headline)
            Image("target")
                .resizable()
                .frame(width: 50, height: 50)
            Spacer()
            Text("\(score)")
                .font(Font.custom("Chava", size: 28))
                .font(.headline)
        }
//        .frame(minWidth: 100)
        .frame(maxWidth: 170, maxHeight: 25)
        .padding(10)
        .foregroundColor(.black)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

struct GameScoreView_Previews: PreviewProvider {
    static var previews: some View {
        GameScoreView(score: .constant(100))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
