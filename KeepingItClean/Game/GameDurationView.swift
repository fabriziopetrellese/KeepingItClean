//
//  GameDurationView.swift
//  ArcadeGameTemplate
//

import SwiftUI

/**
 * # GameDurationView
 * Custom UI to present how many seconds have passed since the beginning of the gameplay session.
 *
 * Customize it to match the visual identity of your game.
 */

struct GameDurationView: View {
    @Binding var time: TimeInterval
//    let hearts = 3
    
    var body: some View {
        HStack {
            ForEach(1...ArcadeGameLogic.shared.hearts, id: \.self) { heart in
                Image("heart")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
//            Spacer()
//            Text("\(Int(time))")
//                .font(Font.custom("Chava", size: 20))
//                .font(.headline)
        }
        .frame(maxWidth: 170, maxHeight: 25)
        .padding(10)
        .foregroundColor(.black)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

struct GameDurationView_Previews: PreviewProvider {
    static var previews: some View {
        GameDurationView(time: .constant(1000))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
