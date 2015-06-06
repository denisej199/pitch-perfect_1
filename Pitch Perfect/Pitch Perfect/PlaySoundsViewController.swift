//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Denise Miller on 5/31/15.
//  Copyright (c) 2015 Miller Tech House. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayerEcho:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var reverbPlayers:[AVAudioPlayer] = []
    let N:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        //for echo
        audioPlayerEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        
        //for reverb
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
            reverbPlayers.append(temp)
        }
        
        //initialize AVAudioEngine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playSoundSlowly(sender: UIButton) {
        playSoundChangeSpeed(0.5)
    }
    @IBAction func playSoundQuickly(sender: UIButton) {
        playSoundChangeSpeed(2.0)
    }
    
    func playSoundChangeSpeed(speed: Float)
    {
        audioEngine.stop()
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    @IBAction func playSoundChipmuck(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playSoundDarthVador(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //create AVAudioPlayerNode object
        var audioPlayerNode = AVAudioPlayerNode()
        //Attach AVAudioPlayerNode to AVAudioEngine
        audioEngine.attachNode(audioPlayerNode)
        //Create AVAudioTimePitch and set pitch
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        //Attach AVAudioTimePitch to AVAudioEngine
        audioEngine.attachNode(changePitchEffect)
        //Connect AVAudioPlayerNode to AVAudioTimePitch
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        //COnnect AVAudioTimePitch to output
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        //schedule file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        //start engine
        audioEngine.startAndReturnError(nil)
        //play audio file
        audioPlayerNode.play()
    }
    
    @IBAction func playSoundEcho(sender: UIButton) {
    
        audioPlayer.stop()
        audioPlayer.currentTime = 0;
        
        let delay:NSTimeInterval = 0.1//100ms
        var playtime:NSTimeInterval
        playtime = audioPlayerEcho.deviceCurrentTime + delay
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 0.8;
        audioPlayerEcho.playAtTime(playtime)
    }
    
    @IBAction func playSoundReverb(sender: UIButton) {

        audioPlayer.stop()
        audioPlayer.currentTime = 0;
        
        let delay:NSTimeInterval = 0.02
        for i in 0...N {
            var curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            var player:AVAudioPlayer = reverbPlayers[i]
            //M_E is e=2.718...
            //dividing N by 2 made it sound ok for the case N=10
            var exponent:Double = -Double(i)/Double(N/2)
            var volume = Float(pow(Double(M_E), exponent))
            player.volume = volume
            player.playAtTime(player.deviceCurrentTime + curDelay)
        }
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
