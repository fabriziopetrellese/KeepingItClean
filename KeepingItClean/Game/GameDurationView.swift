//
//  GameDurationView.swift
//  ArcadeGameTemplate
//

import SwiftUI

struct GameDurationView: View {
    @Binding var time: TimeInterval
    
    var body: some View {
        HStack {
            ForEach(1...ArcadeGameLogic.shared.hearts, id: \.self) { heart in
                Image("heart")
                    .resizable()
                    .frame(width: 55, height: 55)
            }
        }
        .frame(width: 165, height: 30)
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
