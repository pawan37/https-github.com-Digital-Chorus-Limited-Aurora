//
//  TimerViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 25/08/20.
//

import UIKit
import AVFoundation
import AVKit

class TimerViewController: UIViewController {

    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var faderView_Ctrl: UIView!
    @IBOutlet weak var timerView_Ctrl: UIView!
    @IBOutlet weak var faderSlider_ctrl: UISlider!
    @IBOutlet weak var timerSlider_Ctrl: UISlider!
    @IBOutlet weak var videoBgView_Ctrl: UIView!
    
    @IBOutlet weak var switch_Ctrl: UISwitch!
    
    @IBOutlet weak var Aurora_lbl: UILabel!
    
    @IBOutlet weak var timer_Lbl: UILabel!
    @IBOutlet weak var description_Lbl: UILabel!
    @IBOutlet weak var fader_lbl: UILabel!
    
    @IBOutlet weak var timerSettingLbl: UILabel!
    
    @IBOutlet weak var countingLbl: UILabel!
    var avPlayer: AVPlayer!
    var avpController = AVPlayerViewController()
    var faderValue : String = ""
    var timerValue : String = ""
    var timerSlideValue : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView_Ctrl.clipsToBounds = true
        bgView_Ctrl.layer.cornerRadius = 30
        bgView_Ctrl.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        faderView_Ctrl.layer.cornerRadius = 30.0
        faderView_Ctrl.clipsToBounds = true
        
        timerView_Ctrl.layer.cornerRadius = 30.0
        timerView_Ctrl.clipsToBounds = true
        
        faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
        faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
        timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
        timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
        
        if UserDefaults.standard.object(forKey: "timerOn") != nil
        {
           if UserDefaults.standard.object(forKey: "timerOn") as! String == "yes"
           {
            switch_Ctrl.isOn = true
            faderSlider_ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            timerSlider_Ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            faderSlider_ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            timerSlider_Ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            Aurora_lbl.textColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            description_Lbl.textColor = UIColor.black
            fader_lbl.textColor = UIColor.black
            timer_Lbl.textColor = UIColor.black
            timerSettingLbl.textColor = UIColor.black
            countingLbl.textColor = UIColor.black
            let tempfaderValue = UserDefaults.standard.object(forKey: "timerValues") as! Int
            timerSlider_Ctrl.value = Float(tempfaderValue)
           }
          else
           {
            switch_Ctrl.isOn = false
            Aurora_lbl.textColor = UIColor.gray
            description_Lbl.textColor = UIColor.gray
            fader_lbl.textColor = UIColor.gray
            timer_Lbl.textColor = UIColor.gray
            timerSettingLbl.textColor = UIColor.gray
            countingLbl.textColor = UIColor.gray
            faderSlider_ctrl.minimumTrackTintColor = UIColor.gray
            timerSlider_Ctrl.minimumTrackTintColor = UIColor.gray
            faderSlider_ctrl.maximumTrackTintColor = UIColor.gray
            timerSlider_Ctrl.maximumTrackTintColor = UIColor.gray
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
            }
        }
        else
        {
            if UserDefaults.standard.object(forKey: "timerValues") != nil
            {
                let tempfaderValue = UserDefaults.standard.object(forKey: "timerValues") as! Int
                timerSlider_Ctrl.value = Float(tempfaderValue)
            }
            switch_Ctrl.isOn = true
            faderSlider_ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            timerSlider_Ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            faderSlider_ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            timerSlider_Ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            
            Aurora_lbl.textColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            description_Lbl.textColor = UIColor.black
            fader_lbl.textColor = UIColor.black
            timer_Lbl.textColor = UIColor.black
            timerSettingLbl.textColor = UIColor.black
            countingLbl.textColor = UIColor.black
        }
        
//        let moviePath = Bundle.main.path(forResource: "aurora1024", ofType: "mp4")
//        if let path = moviePath {
//            let url = NSURL.fileURL(withPath: path)
//            self.avPlayer = AVPlayer(url: url)
//            self.avpController = AVPlayerViewController()
//            self.avpController.player = self.avPlayer
//            avpController.view.frame = videoBgView_Ctrl.frame
//            avpController.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            avpController.showsPlaybackControls = false
//            self.addChild(avpController)
//            self.videoBgView_Ctrl.addSubview(avpController.view)
//            self.avPlayer.play()
//        }
        // Do any additional setup after loading the view.
    }
    
//    func updateSound()
//    {
//        self.db.updateSoundByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, SooundId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, soundAudioURL: tempDict.object(forKey: "soundAudioURL") as! String, soundDisplayOrder: String(tempDict.object(forKey: "soundDisplayOrder") as! Int), soundLive: String(tempDict.object(forKey: "soundLive") as! Int), SoundName: tempDict.object(forKey: "soundName") as! String, instrumetVolumeDefault: "0", musicID: musicDetailDict.object(forKey: "musicID") as! String)
//    }
    
    @IBAction func faderSliderChange_Action(_ sender: UISlider)
    {
        let tempVolume : Int = Int(sender.value)
        UserDefaults.standard.set(tempVolume, forKey: "faderValues")
        if tempVolume > timerSlideValue
        {
            faderSlider_ctrl.value = Float(timerSlideValue)
        }
        faderValue = String(tempVolume)
    }
    
    @IBAction func timerSliderChnage_Action(_ sender: UISlider)
    {
        let timerSlider : Int = Int(sender.value)
        UserDefaults.standard.set(timerSlider, forKey: "timerValues")
        timerSlideValue = timerSlider
        timerValue = String(timerSlider)
    }
    
    @IBAction func backBtn_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switch_Action(_ sender: Any)
    {
        if switch_Ctrl.isOn == true
        {
            UserDefaults.standard.set("yes", forKey: "timerOn")
            faderSlider_ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            timerSlider_Ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            faderSlider_ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            timerSlider_Ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
                Aurora_lbl.textColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            description_Lbl.textColor = UIColor.black
            fader_lbl.textColor = UIColor.black
            timer_Lbl.textColor = UIColor.black
            timerSettingLbl.textColor = UIColor.black
            countingLbl.textColor = UIColor.black
        }
        else
        {
            UserDefaults.standard.set("no", forKey: "timerOn")
            Aurora_lbl.textColor = UIColor.gray
            description_Lbl.textColor = UIColor.gray
            fader_lbl.textColor = UIColor.gray
            timer_Lbl.textColor = UIColor.gray
            timerSettingLbl.textColor = UIColor.gray
            countingLbl.textColor = UIColor.gray
            faderSlider_ctrl.minimumTrackTintColor = UIColor.gray
            timerSlider_Ctrl.minimumTrackTintColor = UIColor.gray
            faderSlider_ctrl.maximumTrackTintColor = UIColor.gray
            timerSlider_Ctrl.maximumTrackTintColor = UIColor.gray
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            faderSlider_ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
        }
    }
    
    
    
   
    
}
