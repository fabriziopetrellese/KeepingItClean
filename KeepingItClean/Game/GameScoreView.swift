//
//  GameScoreView.swift
//  ArcadeGameTemplate
//

import SwiftUI

struct GameScoreView: View {
    @Binding var score: Int
    
    var body: some View {
        
        HStack {
            Image("target")
                .resizable()
                .frame(width: 55, height: 55)
            Spacer()
            Text("\(score)")
                .font(Font.custom("Chava", size: 28))
                .font(.headline)
        }
        .frame(width: 165, height: 30)
        .padding(10)
        .foregroundColor(.black)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
    }
}

struct GameScoreView_Previews: PreviewProvider {
    static var previews: some View {
        GameScoreView(score: .constant(0))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
