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
    
    @IBOutlet weak var faderLbl: UILabel!
    @IBOutlet weak var faderSwitch_ctrl: UISwitch!
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
    
        
        timerView_Ctrl.layer.cornerRadius = 30.0
        timerView_Ctrl.clipsToBounds = true
        
     
        timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
        timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
        
        if UserDefaults.standard.object(forKey: "timerOn") != nil
        {
           if UserDefaults.standard.object(forKey: "timerOn") as! String == "yes"
           {
            switch_Ctrl.isOn = true
          
            timerSlider_Ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
        
            timerSlider_Ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
        
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            Aurora_lbl.textColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            description_Lbl.textColor = UIColor.black
         //   fader_lbl.textColor = UIColor.black
            timer_Lbl.textColor = UIColor.black
            timerSettingLbl.textColor = UIColor.black
            countingLbl.textColor = UIColor.black
            faderSwitch_ctrl.isOn = true
            faderLbl.textColor = UIColor.black
            let tempfaderValue = UserDefaults.standard.object(forKey: "timerValues") as! Int
            //let faderValue = UserDefaults.standard.object(forKey: "faderValues") as! Int
            timerSlider_Ctrl.value = Float(tempfaderValue)
          //  faderSlider_ctrl.value = Float(faderValue)
            var tempFader : Int = 0
            tempFader = tempfaderValue - 5

            
            if UserDefaults.standard.object(forKey: "faderOn") != nil
            {
                if UserDefaults.standard.object(forKey: "faderOn") as? String == "yes"
                {
                    description_Lbl.text = "The music will start fading out after " + String(tempFader) + " minutes and will stop after " + String(tempfaderValue) + " minutes"
                }
                else
                {
                    description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
                }
            }
            else
            {
                description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
            }
           }
          else
           {
            switch_Ctrl.isOn = false
            Aurora_lbl.textColor = UIColor.gray
            description_Lbl.textColor = UIColor.gray
            timer_Lbl.textColor = UIColor.gray
            timerSettingLbl.textColor = UIColor.gray
            countingLbl.textColor = UIColor.gray
            timerSlider_Ctrl.minimumTrackTintColor = UIColor.gray
            timerSlider_Ctrl.maximumTrackTintColor = UIColor.gray
          
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
            faderSwitch_ctrl.isOn = false
            faderLbl.textColor = UIColor.gray
            if UserDefaults.standard.object(forKey: "timerValues") != nil
            {
                let tempfaderValue = UserDefaults.standard.object(forKey: "timerValues") as! Int
                timerSlider_Ctrl.value = Float(tempfaderValue)
                var tempFader : Int = 0
                tempFader = tempfaderValue - 5
                
                if UserDefaults.standard.object(forKey: "faderOn") != nil
                {
                    if UserDefaults.standard.object(forKey: "faderOn") as? String == "yes"
                    {
                        description_Lbl.text = "The music will start fading out after " + String(tempFader) + " minutes and will stop after " + String(tempfaderValue) + " minutes"
                    }
                    else
                    {
                        description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
                    }
                }
                else
                {
                    description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
                }
            
            }
            }
        }
        else
        {
            if UserDefaults.standard.object(forKey: "timerValues") != nil
            {
                let tempfaderValue = UserDefaults.standard.object(forKey: "timerValues") as! Int
                timerSlider_Ctrl.value = Float(tempfaderValue)
                var tempFader : Int = 0
                tempFader = tempfaderValue - 5
//
                
                if UserDefaults.standard.object(forKey: "faderOn") != nil
                {
                    if UserDefaults.standard.object(forKey: "faderOn") as? String == "yes"
                    {
                        description_Lbl.text = "The music will start fading out after " + String(tempFader) + " minutes and will stop after " + String(tempfaderValue) + " minutes"
                    }
                    else
                    {
                        description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
                    }
                }
                else
                {
                    description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
                }
             
            }
            else
            {
                UserDefaults.standard.set(30, forKey: "timerValues")
                UserDefaults.standard.set(23, forKey: "faderValues")
                timerSlider_Ctrl.value = 30.0
                description_Lbl.text = "The music will stop after 30 minutes"
                //faderSlider_ctrl.value = 23.0
            }
            switch_Ctrl.isOn = true
         
            timerSlider_Ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
         
            timerSlider_Ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
        
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
            
            Aurora_lbl.textColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            description_Lbl.textColor = UIColor.black
            timer_Lbl.textColor = UIColor.black
            timerSettingLbl.textColor = UIColor.black
            countingLbl.textColor = UIColor.black
            faderSwitch_ctrl.isOn = false
            faderLbl.textColor = UIColor.black
        }
        
        if UserDefaults.standard.object(forKey: "faderOn") != nil
        {
            if UserDefaults.standard.object(forKey: "faderOn") as? String == "yes"
            {
                faderSwitch_ctrl.isOn = true
            }
            else
            {
                faderSwitch_ctrl.isOn = false
            }
        }
        else
        {
            faderSwitch_ctrl.isOn = false
        }
    }
    

    
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
        var tempFader : Int = 0
        tempFader = timerSlider - 5

        if UserDefaults.standard.object(forKey: "faderOn") != nil
        {
           if UserDefaults.standard.object(forKey: "faderOn") as? String == "yes"
           {
             description_Lbl.text = "The music will start fading out after " + String(tempFader) + " minutes and will stop after " + String(timerSlider) + " minutes"
           }
           else
           {
             description_Lbl.text = "The music will stop after " + String(timerSlider) + " minutes"
           }
        }
        else
        {
            description_Lbl.text = "The music will stop after " + String(timerSlider) + " minutes"
        }
        
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
         
            timerSlider_Ctrl.minimumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
         
            timerSlider_Ctrl.maximumTrackTintColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
        
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
                Aurora_lbl.textColor = UIColor(red: 253/255, green: 141/255, blue: 141/255, alpha: 1)
            description_Lbl.textColor = UIColor.black
            timer_Lbl.textColor = UIColor.black
            timerSettingLbl.textColor = UIColor.black
            countingLbl.textColor = UIColor.black
            faderSwitch_ctrl.isOn = true
            faderLbl.textColor = UIColor.black
        }
        else
        {
            UserDefaults.standard.set("no", forKey: "timerOn")
            Aurora_lbl.textColor = UIColor.gray
            description_Lbl.textColor = UIColor.gray
            timer_Lbl.textColor = UIColor.gray
            timerSettingLbl.textColor = UIColor.gray
            countingLbl.textColor = UIColor.gray
            timerSlider_Ctrl.minimumTrackTintColor = UIColor.gray
            timerSlider_Ctrl.maximumTrackTintColor = UIColor.gray
         
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            timerSlider_Ctrl.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
            faderSwitch_ctrl.isOn = false
            faderLbl.textColor = UIColor.gray
        }
    }
    
    @IBAction func faderSwitch_Action(_ sender: Any)
    {
        let tempfaderValue = UserDefaults.standard.object(forKey: "timerValues") as! Int
        timerSlider_Ctrl.value = Float(tempfaderValue)
        var tempFader : Int = 0
        tempFader = tempfaderValue - 5

        if faderSwitch_ctrl.isOn
        {
           UserDefaults.standard.set("yes", forKey: "faderOn")
           description_Lbl.text = "The music will start fading out after " + String(tempFader) + " minutes and will stop after " + String(tempfaderValue) + " minutes"
        }
        else
        {
            UserDefaults.standard.set("no", forKey: "faderOn")
            description_Lbl.text = "The music will stop after " + String(tempfaderValue) + " minutes"
        }
    }
    
}
