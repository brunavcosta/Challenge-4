//
//  PlaySound.swift
//  Challenge4
//
//  Created by Bruna Costa on 21/09/20.
//  Copyright © 2020 Bruna Costa. All rights reserved.
//
/*
import AVFoundation
import AVKit

let playSound = PlaySound()
final class PlaySound {
    func play () {
        var soundtrack: AVAudioPlayer?
        let url = Bundle.main.url(forResource: "soundtrack", withExtension: "mp3")! //func deve receber uma string para ir acessando os diferentes sons
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            soundtrack = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            soundtrack?.volume = 0.5
            soundtrack?.numberOfLoops = -1
            soundtrack?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
*/
