//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Denise Miller on 5/31/15.
//  Copyright (c) 2015 Miller Tech House. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordingInProcess: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordingInProcess.hidden = true
        self.view.backgroundColor = UIColor.blueColor();
        pauseButton.hidden = true
        playButton.hidden = true
        
    }

    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        pauseButton.hidden = true
        playButton.hidden = false
        
    }
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        pauseButton.hidden = false
        playButton.hidden = true
        stopButton.hidden = false
    }
    @IBAction func startRecording(sender: UIButton) {
        
        recordingInProcess.hidden = false
        stopButton.hidden = false
        pauseButton.hidden = false
        //disable record button
        //record voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil , error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }

    @IBAction func stopRecording(sender: UIButton) {
        stopButton.hidden = true
        audioRecorder.stop()
        var audioSession =  AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag)
        {
            //TODO save file
            recordedAudio = RecordedAudio()
            recordedAudio.filePathURL = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            //performed segway
            self.performSegueWithIdentifier("StopRecording", sender: recordedAudio)
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "StopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
}

