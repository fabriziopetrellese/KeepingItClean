//
//  MusicClass.swift
//  EarthDefenderStarterProject
//
//  Created by Fabrizio Petrellese on 01/04/22.
//

import AVFoundation

class MusicClass {
    static let shared = MusicClass()
    var isPlaying = true
    var audioPlayer = AVAudioPlayer()
    
    func setup(){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "newMusic", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func play() {
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        audioPlayer.volume = 0.2
        isPlaying = true
    }
    
    func stop() {
        audioPlayer.stop()
        isPlaying = false
    }
}
