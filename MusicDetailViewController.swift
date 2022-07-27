//
//  MusicDetailViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 24/08/20.
//

import UIKit
import Alamofire
import ParticlesLoadingView
import SpriteKit
import SwiftySound
import AVFoundation
import EzPopup
import AVKit


class MusicDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PopupViewControllerDelegate {
    
    @IBOutlet weak var scrollView_Ctrl: UIScrollView!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var optionView: UIView!
    private var lastContentOffset: CGFloat = 0
    @IBOutlet weak var descriptionView_Ctrl: UIView!
    @IBOutlet weak var title_Lbl: UILabel!
    @IBOutlet weak var setting_Btn: UIButton!
    @IBOutlet weak var back_Btn: UIButton!
    
    @IBOutlet weak var swipeGetureBGView: UIView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var scrollContentView_Ctrl: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var topViewCnst: NSLayoutConstraint!
    @IBOutlet weak var bgImage_Imageview: UIImageView!
    @IBOutlet weak var desciption_txtView: UITextView!
    @IBOutlet weak var openDesciption_btn: UIButton!
    @IBOutlet weak var heightCnst: NSLayoutConstraint!
    @IBOutlet weak var AnimationClose_btn: UIButton!
    
    @IBOutlet weak var collectionView_Ctrl: UICollectionView!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var greenView_Ctrl: UIView!
    @IBOutlet weak var description_Lbl: UILabel!
    @IBOutlet weak var rectangleBgView: UIView!
    @IBOutlet weak var uperdescriptionView: UIView!
    @IBOutlet weak var heartIcon_Btn: UIButton!
    @IBOutlet weak var playBTn: UIButton!
    
    @IBOutlet weak var reviewTop_const: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var Animation_CollectionView: UICollectionView!
    
    
    let timerOptionArray = ["Infinite loop","10 mins","20 mins","30 mins","40 mins","1 hour","2 hours","4 hours","8 hours"]
    var musicDetailDict : NSDictionary = [:]
    var isOpen : Bool = true
    var favourite:[favourite] = []
    var db:DBHelper = DBHelper()
    var compositionMusicArray : NSMutableArray = []
    var tempCompositionArray : NSMutableArray = []
    var tempSoundArray : NSMutableArray = []
    var downloadedUrlArray : NSMutableArray = []
    private var multySound: Sound?
    var multySoundArray = [Sound]()
    private var soundMultySound: Sound?
    var SoundmultySoundArray = [Sound]()
    var volumeArray : NSMutableArray = []
    var isPlay : Bool = true
    var isPlayOnce : Bool = true
    var isPlaySoundOnce : Bool = true
    var downloadSoundArray : NSMutableArray = []
    var filterVolumeArray : NSMutableArray = []
    var localCompositionArray : NSMutableArray = []
    var localSoundArray : NSMutableArray = []
    var isFavourite : Bool = true
    var totalSecond = Int()
    var timer : Timer?
    var totalSize : Float = 0.0
    var iscalculateSize : Bool = true
    var reviewArray : NSMutableArray = []
    var motionAnimatArray : NSMutableArray = []
    let customAlertVC = TimerOptionPopViewController.instantiate()
    var avPlayer: AVPlayer!
    var isuserPaid : String = ""
    
    @IBOutlet weak var backgroundAnimation_View: UIView!
    @IBOutlet weak var timer_Lbl: UILabel!
    @IBOutlet weak var infinity_Imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading   view.
        print(musicDetailDict)
        
        if musicDetailDict.object(forKey: "largeImageURL") != nil
        {
            bgImage_Imageview?.setImageWith(URL(string: (musicDetailDict.object(forKey: "largeImageURL") as? String)!), placeholderImage: UIImage(named: "user-1"))
        }
        else
        {
           bgImage_Imageview.image = UIImage(named: "songBanner")
        }
        optionView.clipsToBounds = true
        optionView.layer.cornerRadius = 30
        optionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       // optionView.backgroundColor = UIColor(red: 249/255, green: 229/255, blue: 229/255, alpha: 0.33)
        
        descriptionView_Ctrl.clipsToBounds = true
        descriptionView_Ctrl.layer.cornerRadius = 30
        descriptionView_Ctrl.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        descriptionView_Ctrl.backgroundColor = UIColor.clear
        scrollView_Ctrl.contentSize = CGSize(width: self.scrollView_Ctrl.frame.width, height: 400)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .up
        self.uperdescriptionView.addGestureRecognizer(swipeDown)
        
        let swipeDown2 = UISwipeGestureRecognizer(target: self, action: #selector(resondToSwipeUp))
        swipeDown2.direction = .down
        self.bgView_Ctrl.addGestureRecognizer(swipeDown2)
        
        let swipeDown3 = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeLeft))
        swipeDown3.direction = .right
        self.uperdescriptionView.addGestureRecognizer(swipeDown3)
        
        
        getMusicComposition()
        setUPMusicDetail()
        

        if let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Spark", ofType: "sks")!) as? SKEmitterNode {
                rectangleBgView.layer.borderWidth = 1.0
                rectangleBgView.layer.borderColor = UIColor.lightGray.cgColor
                rectangleBgView.layer.cornerRadius = rectangleBgView.frame.size.width / 2
                rectangleBgView.addParticlesAnimation(with: emitter)
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView_Ctrl.collectionViewLayout = layout
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.scrollDirection = .horizontal
        self.Animation_CollectionView.collectionViewLayout = layout2
        
        greenView_Ctrl!.layer.cornerRadius = (greenView_Ctrl?.frame.size.height)! / 2
        greenView_Ctrl!.clipsToBounds = true
        
        getAnimation()
        getReviews()
        
        
//        if !UIAccessibility.isReduceTransparencyEnabled {
//            blurView.backgroundColor = .clear
//            if #available(iOS 13.0, *) {
//                let blurEffect = UIBlurEffect(style: .dark)
//                let blurEffectView = UIVisualEffectView(effect: blurEffect)
//                //always fill the view
//                blurEffectView.frame = self.view.bounds
//                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                blurView.addSubview(blurEffectView)
//            } else {
//                // Fallback on earlier versions
//            }
//            //if you have more UIViews, use an insertSubview API to place it where needed
//        } else {
//            blurView.backgroundColor = .black
//        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setupTimer()
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        isOpen = true
        desciption_txtView.isHidden = true
        openDesciption_btn.setImage(UIImage(named: "info"), for: .normal)
        scrollView_Ctrl.isScrollEnabled = true
        UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
            self.descriptionView_Ctrl.isHidden = true
            self.topViewCnst.constant = 20
            self.openDesciption_btn.isHidden = true
            self.description_Lbl.isHidden = false
            //   self.scrollView_Ctrl.isUserInteractionEnabled = true
        }, completion: { _ in })
    }
    
    @objc func resondToSwipeUp(gesture: UIGestureRecognizer)
    {
        timer?.invalidate()
        isOpen = false
        desciption_txtView.isHidden = false
        openDesciption_btn.setImage(UIImage(named: "UParrow-1"), for: .normal)
        scrollView_Ctrl.isScrollEnabled = false
        UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
            self.descriptionView_Ctrl.isHidden = false
            self.description_Lbl.isHidden = true
            self.topViewCnst.constant = 255
            // self.scrollView_Ctrl.isUserInteractionEnabled = false
        }, completion: { _ in })
    }
    
    @objc func respondToSwipeLeft(gesture: UIGestureRecognizer)
    {
        timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backBtn_Action(_ sender: Any)
    {
        timer?.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func sliderValueChanged_Action(_ sender: UISlider)
    {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.optionTableView)
        let cellIndexPath = self.optionTableView.indexPathForRow(at: pointInTable)
        let selectedIndexRow = cellIndexPath!.row
        print(selectedIndexRow)
        print(multySoundArray)
        print(sender.value)
        if sender.value == 0.0
        {
            sender.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
            sender.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
        }
        else
        {
            sender.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
            sender.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
        }
        if selectedIndexRow <= self.tempCompositionArray.count
        {
            let tempDict = compositionMusicArray.object(at: selectedIndexRow - 1) as! NSDictionary
            print(tempDict)
            let value = sender.value * 100
            let finalValue = Int(value)
            print(finalValue)
            if supportingfuction.checkNetworkReachability() == true
            {
              self.db.updateByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, compositionId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, instrumentAudioURL: tempDict.object(forKey: "instrumentAudioURL") as! String, instrumentDisplayOrder: String(tempDict.object(forKey: "instrumentDisplayOrder") as! Int), instrumentLive: String(tempDict.object(forKey: "instrumentLive") as! Int), instrumentName: tempDict.object(forKey: "instrumentName") as! String, instrumentVolumeDefault: String(finalValue), musicID: tempDict.object(forKey: "musicID") as! String)
            }
            else
            {
              self.db.updateByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, compositionId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, instrumentAudioURL: tempDict.object(forKey: "instrumentAudioURL") as! String, instrumentDisplayOrder: tempDict.object(forKey: "instrumentDisplayOrder") as! String, instrumentLive: tempDict.object(forKey: "instrumentLive") as! String, instrumentName: tempDict.object(forKey: "instrumentName") as! String, instrumentVolumeDefault: String(finalValue), musicID: tempDict.object(forKey: "musicID") as! String)
            }
            
             let localUpdatedArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
            for i in 0..<localCompositionArray.count
            {
                let newDict = localCompositionArray.object(at: i) as? NSDictionary
                for j in 0..<localUpdatedArray.count
                {
                   let updatedDict = localUpdatedArray.object(at: j) as? NSDictionary
                    if newDict?.object(forKey: "instrumentName") != nil
                    {
                        if newDict?.object(forKey: "instrumentName") as! String == updatedDict?.object(forKey: "instrumentName") as! String
                        {
                            localCompositionArray.replaceObject(at: i, with: updatedDict!)
                            //break;
                        }
                    }
                }
            }
            print(localCompositionArray)
            if self.multySoundArray.count > 0
            {
                 self.multySoundArray[selectedIndexRow - 1].volume = sender.value
            }
        }
        else
        {
            let tempDict = compositionMusicArray.object(at: selectedIndexRow - 3) as! NSDictionary
            print(tempDict)
            let value = sender.value * 100
            let finalValue = Int(value)
            print(finalValue)
            if supportingfuction.checkNetworkReachability() == true
            {
              self.db.updateSoundByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, SooundId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, soundAudioURL: tempDict.object(forKey: "soundAudioURL") as! String, soundDisplayOrder: String(tempDict.object(forKey: "soundDisplayOrder") as! Int), soundLive: String(tempDict.object(forKey: "soundLive") as! Int), SoundName: tempDict.object(forKey: "soundName") as! String, instrumetVolumeDefault: String(finalValue), musicID: musicDetailDict.object(forKey: "musicID") as! String)
            }
            else
            {
                self.db.updateSoundByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, SooundId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, soundAudioURL: tempDict.object(forKey: "soundAudioURL") as! String, soundDisplayOrder: tempDict.object(forKey: "soundDisplayOrder") as! String, soundLive: tempDict.object(forKey: "soundLive") as! String, SoundName: tempDict.object(forKey: "soundName") as! String, instrumetVolumeDefault: String(finalValue), musicID: musicDetailDict.object(forKey: "musicID") as! String)

            }
            
            localSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
            for i in 0..<localCompositionArray.count
            {
                let newDict = localCompositionArray.object(at: i) as? NSDictionary
                for j in 0..<localSoundArray.count
                {
                    let updatedDict = localSoundArray.object(at: j) as? NSDictionary
                    if newDict?.object(forKey: "soundName") != nil
                    {
                        if newDict?.object(forKey: "soundName") as! String == updatedDict?.object(forKey: "soundName") as! String
                        {
                            localCompositionArray.replaceObject(at: i, with: updatedDict!)
                            //break;
                        }
                    }
                }
            }
            if multySoundArray.count > 0
            {
                self.multySoundArray[selectedIndexRow - 3].volume = sender.value
            }
        }
    }
    
    
    @IBAction func closeAnimation_Action(_ sender: Any) {
        
        UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
        self.blurView.isHidden = true
        self.backgroundAnimation_View.isHidden = true
            self.AnimationClose_btn.isHidden = true

            //   self.scrollView_Ctrl.isUserInteractionEnabled = true
        }, completion: { _ in })
    }
    
    
    @IBAction func musicTimerBtn_Action(_ sender: Any) {
        if isPlay == false
        {
            let alert = UIAlertController(title: "Mishi", message: "Stop play to use this feature.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        } else {
            guard let customAlertVC = customAlertVC else { return }
            customAlertVC.musicDetail = musicDetailDict
            let popupVC = PopupViewController(contentController: customAlertVC, position: .bottom(0), popupWidth: view.frame.size.width, popupHeight: 350)
            customAlertVC.delegateTimerTap = self
            popupVC.backgroundAlpha = 0.3
            popupVC.backgroundColor = .black
            popupVC.canTapOutsideToDismiss = true
            //popupVC.cornerRadius = 10
            popupVC.shadowEnabled = true
            popupVC.delegate = self
            present(popupVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func openDescription_Action(_ sender: UIButton)
        
    {
        if isOpen == true
        {
            isOpen = false
            desciption_txtView.isHidden = false
            openDesciption_btn.setImage(UIImage(named: "UParrow-1"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = false
                UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.descriptionView_Ctrl.isHidden = false
                    self.openDesciption_btn.isHidden = false
                    self.descriptionView_Ctrl.isHidden = false
                    self.description_Lbl.isHidden = false
                    self.topViewCnst.constant = 255
                   // self.scrollView_Ctrl.isUserInteractionEnabled = false
                }, completion: { _ in })
        }
        else
        {
            isOpen = true
            desciption_txtView.isHidden = true
            openDesciption_btn.setImage(UIImage(named: "info"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = true
            UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                                self.descriptionView_Ctrl.isHidden = true
                                self.openDesciption_btn.isHidden = true
                                self.descriptionView_Ctrl.isHidden = true
                    self.description_Lbl.isHidden = false
                                self.topViewCnst.constant = 20
                             //   self.scrollView_Ctrl.isUserInteractionEnabled = true
                            }, completion: { _ in })
        }

    }
    
    @IBAction func resetBtn_Action(_ sender: Any)
    {
        if supportingfuction.checkNetworkReachability() == true
        {
            if isPlay == false
            {
                supportingfuction.showMessageHudWithMessage("Stop music to restore default volumes." as NSString,delay: 2.0)
                return
            }
            else
            {
                for i in 0..<compositionMusicArray.count
                {
                    let tempDict = compositionMusicArray.object(at: i) as! NSDictionary
                    print(tempDict)
                    if i < self.tempCompositionArray.count
                    {
                        self.db.updateByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, compositionId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, instrumentAudioURL: tempDict.object(forKey: "instrumentAudioURL") as! String, instrumentDisplayOrder: String(tempDict.object(forKey: "instrumentDisplayOrder") as! Int), instrumentLive: String(tempDict.object(forKey: "instrumentLive") as! Int), instrumentName: tempDict.object(forKey: "instrumentName") as! String, instrumentVolumeDefault: String(tempDict.object(forKey: "instrumentVolumeDefault") as! Int), musicID: tempDict.object(forKey: "musicID") as! String)
                    }
                    else
                    {
                        
                        self.db.updateSoundByID(createdDate: tempDict.object(forKey: "_createdDate") as! String, SooundId: tempDict.object(forKey: "_id") as! String, owner: tempDict.object(forKey: "_owner") as! String, _updatedDate: tempDict.object(forKey: "_updatedDate") as! String, soundAudioURL: tempDict.object(forKey: "soundAudioURL") as! String, soundDisplayOrder: String(tempDict.object(forKey: "soundDisplayOrder") as! Int), soundLive: String(tempDict.object(forKey: "soundLive") as! Int), SoundName: tempDict.object(forKey: "soundName") as! String, instrumetVolumeDefault: "0", musicID: musicDetailDict.object(forKey: "musicID") as! String)
                    }
                }
                self.localCompositionArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                self.localSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                for j in 0..<self.localSoundArray.count
                {
                    self.localCompositionArray.add(self.localSoundArray.object(at: j) as! NSDictionary)
                }
                print(localCompositionArray)
                self.optionTableView.reloadData()
            }
        }
        else
        {
            supportingfuction.showMessageHudWithMessage("This Functionality working with online. Please Check your Network Connectivity" as NSString,delay: 2.0)
        }
     }
    

    
    @IBAction func favourite_Action(_ sender: Any)
    {
       if isFavourite == true
       {
        isFavourite = false
        db.insert(songId: (musicDetailDict.object(forKey: "musicID") as? String)!, updateStatus: "1")
        heartIcon_Btn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
       }
        else
       {
        isFavourite = true
        self.db.deleteByID(id: (musicDetailDict.object(forKey: "musicID") as? String)!)
        heartIcon_Btn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
        }
        UserDefaults.standard.setValue("yes", forKey: "fromFavourite")
    }
    
    @IBAction func showDescription_Acion(_ sender: Any) {
        if isOpen == true
        {
            isOpen = false
            desciption_txtView.isHidden = false
            openDesciption_btn.setImage(UIImage(named: "UParrow-1"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = false
                UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.descriptionView_Ctrl.isHidden = false
                    self.openDesciption_btn.isHidden = false
                    self.description_Lbl.isHidden = true
                    self.topViewCnst.constant = 215
                   // self.scrollView_Ctrl.isUserInteractionEnabled = false
                }, completion: { _ in })
        }
        else
        {
            isOpen = true
            desciption_txtView.isHidden = true
            openDesciption_btn.setImage(UIImage(named: "info"), for: .normal)
            scrollView_Ctrl.isScrollEnabled = true
            UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
                                self.descriptionView_Ctrl.isHidden = true
                                self.openDesciption_btn.isHidden = true
                                self.description_Lbl.isHidden = true
                                self.topViewCnst.constant = 20
                             //   self.scrollView_Ctrl.isUserInteractionEnabled = true
                            }, completion: { _ in })
        }
    }
    
    
    @IBAction func playBtn_Action(_ sender: UIButton)
    {
        if supportingfuction.checkNetworkReachability() == false
        {
            let downloadloaclArray = self.db.getdownloadbyId(Id: ((musicDetailDict.object(forKey: "musicID") as? String)!))
            if downloadloaclArray.count == 0
            {
                let alert = UIAlertController(title: "You are not online.", message: "Go to settings (icon top right) to allow download without wi-fi. Please be aware this may use your data allowance.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
        
        downloadedUrlArray = []
        volumeArray = []
        multySound = nil
        multySoundArray = []
        var url : URL!
        if isPlay == true
        {
            self.db.insertDownload(musicId: (musicDetailDict.object(forKey: "musicID") as? String)!, musicName: (musicDetailDict.object(forKey: "musicName") as? String)!, size: "0")
           // startTimer()
            isPlay = false
            rectangleBgView.isHidden = false
            rectangleBgView.startAnimating()
            playBTn.isUserInteractionEnabled = false
            playBTn.setBackgroundImage(UIImage(named: "stopBtnBG"), for: .normal)
            for i in 0..<self.compositionMusicArray.count
            {
                let tempDict = self.compositionMusicArray.object(at: i) as? NSDictionary
                if localCompositionArray.count > 0
                {
                    let localDict = localCompositionArray.object(at: i) as? NSDictionary
                    if localDict?.object(forKey: "instrumentVolumeDefault") != nil
                    {
                        print(localDict?.object(forKey: "instrumentVolumeDefault") as! String)
                        if localDict?.object(forKey: "instrumentVolumeDefault") as! String == "0.0"
                        {
                            volumeArray.add(0.0)
                        }
                        else
                        {
                             volumeArray.add(Int(localDict?.object(forKey: "instrumentVolumeDefault") as! String)!)
                        }
                    }
                    else
                    {
                        volumeArray.add(0.0)
                    }
                }
                else
                {
                    if tempDict?.object(forKey: "instrumentVolumeDefault") != nil
                    {
                        volumeArray.add(tempDict?.object(forKey: "instrumentVolumeDefault") as! Int)
                    }
                    else
                    {
                        volumeArray.add(0.0)
                    }
                }
                
                if tempDict?.object(forKey: "instrumentAudioURL") != nil
                {
                    url = URL(string: (tempDict?.object(forKey: "instrumentAudioURL") as? String)!)
                }
                else
                {
                    url = URL(string: (tempDict?.object(forKey: "soundAudioURL") as? String)!)
                }
                
                self.loadFileAsync(url: url!) { (path, error) in
                //    print("PDF File downloaded to : \(path!)")
                    let fullUrl = URL.init(fileURLWithPath: path!)
                   // print(fullUrl)
                    self.downloadedUrlArray.add(fullUrl)
                    DispatchQueue.main.async
                        {
                            if self.compositionMusicArray.count == self.downloadedUrlArray.count
                            {
                                print(self.volumeArray)
                                if self.isPlayOnce == true
                                {
                                    self.isPlayOnce = false
                                    self.playSoundInstrument()
                                }
                            }
                    }
                }
            }
          //  self.playSoundInstrument()
        }
        else
        {
            timer?.invalidate()
            let timerValue = UserDefaults.standard.object(forKey: "timerValues")  as! Int
            totalSecond = timerValue * 60
            self.timer_Lbl.text = String(timerValue) + ":00"
            isPlay = true
            isPlayOnce = true
            isPlaySoundOnce = true
            iscalculateSize = true
            totalSize = 0.0
            playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
            for i in 0..<multySoundArray.count
            {
                multySoundArray[i].stop()
            }
        }
    }
    
    @IBAction func animation_Action(_ sender: Any) {
        if motionAnimatArray.count > 0{
        UIView.transition(with: self.view!, duration: 0.8, options: .transitionCrossDissolve, animations: {() -> Void in
            self.blurView.isHidden = false
            self.backgroundAnimation_View.isHidden = false
            self.AnimationClose_btn.isHidden = false
            self.Animation_CollectionView.reloadData()
            //   self.scrollView_Ctrl.isUserInteractionEnabled = true
        }, completion: { _ in })
        } else {
            supportingfuction.showMessageHudWithMessage("Some thing went wrong. Please try again" as NSString,delay: 2.0)
        }
    }
    
    
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown()
    {
        var minutes: Int
        var seconds: Int
        totalSecond = totalSecond - 1
        let timerOn = UserDefaults.standard.object(forKey: "timerValues") as! Int
        minutes = (totalSecond / 60)
        seconds = (totalSecond % 3600) % 60
        if timerOn >= 10 || timerOn <= 480
        {
            if UserDefaults.standard.object(forKey: "faderOn") != nil
            {
                if UserDefaults.standard.object(forKey: "faderOn") as! String == "yes"
                {
                    if minutes == 5 && seconds == 00
                    {
                        for i in 0..<multySoundArray.count
                        {
                            let volume = multySoundArray[i].volume
                            if volume > 0.0 && volume >= 0.2
                            {
                                self.multySoundArray[i].volume = volume - 0.2
                                print(self.multySoundArray[i].volume)
                            }
                            else if volume > 0.0 && volume >= 0.1
                            {
                                self.multySoundArray[i].volume = volume - 0.2
                                print(self.multySoundArray[i].volume)
                            }
                            print(volume)
                        }
                    }
                    else if minutes == 4 && seconds == 00
                    {
                        for i in 0..<multySoundArray.count
                        {
                            let volume = multySoundArray[i].volume
                            if volume > 0.0 && volume >= 0.1
                            {
                                self.multySoundArray[i].volume = volume - 0.1
                                print(self.multySoundArray[i].volume)
                            }
                            print(volume)
                        }
                    }
                    else if minutes == 3 && seconds == 00
                    {
                        for i in 0..<multySoundArray.count
                        {
                            let volume = multySoundArray[i].volume
                            if volume > 0.0 && volume >= 0.1
                            {
                                self.multySoundArray[i].volume = volume - 0.1
                                print(self.multySoundArray[i].volume)
                            }
                            print(volume)
                        }
                    }
                    else if minutes == 2 && seconds == 00
                    {
                        for i in 0..<multySoundArray.count
                        {
                            let volume = multySoundArray[i].volume
                            if volume > 0.0 && volume >= 0.1
                            {
                                self.multySoundArray[i].volume = volume - 0.05
                                print(self.multySoundArray[i].volume)
                            }
                            print(volume)
                        }
                    }
                    else if minutes == 1 && seconds == 00
                    {
                        for i in 0..<multySoundArray.count
                        {
                            let volume = multySoundArray[i].volume
                            if volume > 0.0 && volume >= 0.15
                            {
                                self.multySoundArray[i].volume = volume - 0.05
                                print(self.multySoundArray[i].volume)
                            }
                            print(volume)
                        }
                    }
                    else if minutes == 0 && seconds == 00
                    {
                        timer?.invalidate()
                        isPlay = true
                        isPlayOnce = true
                        isPlaySoundOnce = true
                        playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
                        for i in 0..<multySoundArray.count
                        {
                            multySoundArray[i].stop()
                        }
                    }
                }
                else
                {
                    if minutes == 0 && seconds == 00
                    {
                        timer?.invalidate()
                        isPlay = true
                        isPlayOnce = true
                        isPlaySoundOnce = true
                        playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
                        for i in 0..<multySoundArray.count
                        {
                            multySoundArray[i].stop()
                        }
                    }
                }
            }
            else
            {
                if minutes == 0 && seconds == 00
                {
                    timer?.invalidate()
                    isPlay = true
                    isPlayOnce = true
                    isPlaySoundOnce = true
                    playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
                    for i in 0..<multySoundArray.count
                    {
                        multySoundArray[i].stop()
                    }
                }
            }
        }
        
        if minutes == 0 && seconds == 00
        {
            let timerValue = UserDefaults.standard.object(forKey: "timerValues")  as! Int
            totalSecond = timerValue * 60
            self.timer_Lbl.text = String(timerValue) + ":00"
        }
        else
        {
            timer_Lbl.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func getReviews()
    {
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "getReviews?musicID=" + (musicDetailDict.object(forKey: "musicID") as! String)
       // baseUrl = "https://www.aurorasleepmusic.com/_functions/getReviews?musicID=eternalom"
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        let tempArray = (response.result.value! as! NSDictionary).object(forKey: "reviews") as? NSArray
                        self.reviewArray = tempArray?.mutableCopy() as! NSMutableArray
                        print(self.reviewArray)
//                        for i in 0..<self.reviewArray.count
//                        {
             //               self.db.deletedReview(id: self.musicDetailDict.object(forKey: "musicID") as! String)
//                        }
//
//                        for i in 0..<self.reviewArray.count
//                        {
//                            var auroraResponse : String = ""
//                            var description : String = ""
//                            var country : String = ""
//                            var owner : String = ""
//                            let reviewDict = self.reviewArray.object(at: i) as? NSDictionary
//                            if let response = reviewDict?.object(forKey: "auroraResponse")
//                            {
//                                auroraResponse = response as! String
//                            }
//                            if let descrip = reviewDict?.object(forKey: "description")
//                            {
//                                description = descrip as! String
//                            }
//                            if let count =  reviewDict?.object(forKey: "country")
//                            {
//                                country = count as! String
//                            }
//                            if let owne = reviewDict?.object(forKey: "_owner")
//                            {
//                                owner = owne as! String
//                            }
//                            print(reviewDict)
//                            self.db.insertReview(createdDate: reviewDict?.object(forKey: "_createdDate") as! String, id: reviewDict?.object(forKey: "_id") as! String, owner: owner, updatedDate: reviewDict?.object(forKey: "_updatedDate") as! String, auroraResponse: auroraResponse, country: country, description: description, firstName: reviewDict?.object(forKey: "firstName") as! String, live: String(reviewDict?.object(forKey: "live") as! Int), musicID: reviewDict?.object(forKey: "musicID") as! String, rating: String(reviewDict?.object(forKey: "rating") as! Int), recencyText: reviewDict?.object(forKey: "recencyText") as! String, reviewDate: reviewDict?.object(forKey: "reviewDate") as! String, userID: reviewDict?.object(forKey: "userID") as! String)
//
//                        }
                        self.collectionView_Ctrl.reloadData()
                    }
                    else
                    {
                       // supportingfuction.showMessageHudWithMessage("No Review Found." as NSString,delay: 2.0)
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    // supportingfuction.showMessageHudWithMessage("No Review Found." as NSString,delay: 2.0)
                }
            }
    }
    
    func playSoundInstrument()
    {
        iscalculateSize = false
        downloadedUrlArray = []
        var url : URL!
       for i in 0..<compositionMusicArray.count
       {
        let tempDict = self.compositionMusicArray.object(at: i) as? NSDictionary
        if tempDict?.object(forKey: "instrumentAudioURL") != nil
        {
            url = URL(string: (tempDict?.object(forKey: "instrumentAudioURL") as? String)!)
        }
        else
        {
            url = URL(string: (tempDict?.object(forKey: "soundAudioURL") as? String)!)
        }
        self.loadFileAsync(url: url!) { (path, error) in
            //    print("PDF File downloaded to : \(path!)")
            let fullUrl = URL.init(fileURLWithPath: path!)
            // print(fullUrl)
            self.downloadedUrlArray.add(fullUrl)
            DispatchQueue.main.async
                {
                    if self.compositionMusicArray.count == self.downloadedUrlArray.count
                    {
                        if self.isPlaySoundOnce == true
                        {
                            self.isPlaySoundOnce = false
                            self.rectangleBgView.isHidden = true
                            self.rectangleBgView.stopAnimating()
                            self.startTimer()
                            // self.multySound = nil
                            //  self.multySoundArray = []
                            for i in 0..<self.downloadedUrlArray.count
                            {
                                self.multySound = Sound(url: self.downloadedUrlArray.object(at: i) as! URL)
                                self.multySoundArray.append(self.multySound!)
                            }
                            DispatchQueue.global(qos: .background).async
                                {
                                    for j in 0..<self.multySoundArray.count
                                    {
                                        DispatchQueue.main.async
                                            {
                                                self.multySoundArray[j].play(numberOfLoops: -1, completion: nil)
                                                let tempVolume = self.volumeArray.object(at: j) as! Int
                                                let convertValue = CGFloat(tempVolume) / 100
                                                print(convertValue)
                                                
                                                if !(convertValue == 0.0)
                                                {
                                                    self.multySoundArray[j].volume = Float(convertValue)
                                                }
                                                else
                                                {
                                                    self.multySoundArray[j].volume = 0.0
                                                }
                                        }
                                    }
                               }
                            let audioSession = AVAudioSession.sharedInstance()
                            do
                            {
                                try audioSession.setCategory(AVAudioSession.Category.playback)
                            }
                            catch
                            {
                                fatalError("playback failed")
                            }
                            self.playBTn.isUserInteractionEnabled = true
                        }
                    }
            }
          }
        }
    }
    
    func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
          //  print("File already exists [\(destinationUrl.path)]")
            if iscalculateSize == false
            {
                let size = sizePerMB(url: destinationUrl)
                totalSize = totalSize + Float(size)
                let twoDecimalPlaces = String(format: "%.2f", totalSize)
                print(twoDecimalPlaces)
                self.db.updateDownloadByID(musicId: (musicDetailDict.object(forKey: "musicID") as? String)!, musicName: (musicDetailDict.object(forKey: "musicName") as? String)!, size: twoDecimalPlaces)
            }
            completion(destinationUrl.path, nil)
        }
        else
        {
            if UserDefaults.standard.object(forKey: "wifiOn") != nil
            {
                if UserDefaults.standard.object(forKey: "wifiOn") as? String == "yes"
                {
                    if supportingfuction.checkWifiReachability() == true
                    {
                        print("Connected via WIFI")
                    }
                    else
                    {
                      // supportingfuction.showMessageHudWithMessage("Wi-fi required to download music. Go to settings." as NSString,delay: 2.0)
                        self.rectangleBgView.isHidden = true
                        self.rectangleBgView.stopAnimating()
                        self.isPlay = true
                        playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
                        self.playBTn.isUserInteractionEnabled = true
                        let alert = UIAlertController(title: "Mishi", message: "Wi-fi required to download music. Go to settings.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
                else
                {
                    if supportingfuction.checkWifiReachability() == true
                    {
                        print("Connected via WIFI")
                        let alert = UIAlertController(title: "Wi-fi not detected.", message: "Go to settings (icon top right) to allow download without wi-fi. Please be aware this may use your data allowance.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                        }))
                        self.present(alert, animated: true, completion: nil)
                       // supportingfuction.showMessageHudWithMessage("You are connected with WIFI. Please change your connectivity from app Setting" as NSString,delay: 2.0)
                        self.rectangleBgView.isHidden = true
                        self.rectangleBgView.stopAnimating()
                        self.isPlay = true
                        playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
                        self.playBTn.isUserInteractionEnabled = true
                        return
                    }
                }
            }
            else
            {
                if supportingfuction.checkWifiReachability() == true
                {
                    print("Connected via WIFI")
                }
                else
                {
                    //supportingfuction.showMessageHudWithMessage("Wi-fi required to download music. Go to settings." as NSString,delay: 2.0)
                    self.rectangleBgView.isHidden = true
                    self.rectangleBgView.stopAnimating()
                    self.isPlay = true
                    playBTn.setBackgroundImage(UIImage(named: "playBtnBG"), for: .normal)
                    self.playBTn.isUserInteractionEnabled = true
                    let alert = UIAlertController(title: "Mishi", message: "Wi-fi required to download music. Go to settings.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
           // MBProgressHUD.showAdded(to: view, animated: true)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                  //  MBProgressHUD.hide(for: self.view, animated: true)
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                               // print(destinationUrl.path)
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
    
    @IBAction func timerBtn_Action(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func add_Action(_ sender: Any)
    {
        if supportingfuction.checkNetworkReachability() == true
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewViewController") as! AddReviewViewController
            vc.musicDict = musicDetailDict
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Mishi", message: "Please turn on your Internet connection.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
            }))
            self.present(alert, animated: true, completion: nil)
         //   supportingfuction.showMessageHudWithMessage("Please turn on your Internet connection." as NSString,delay: 2.0)
        }
        
    }
    
    @IBAction func settingBtn_Action(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getMusicComposition()
    {
        compositionMusicArray = []
        MBProgressHUD.showAdded(to: view, animated: true)
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "compositionListings?musicID=" + (musicDetailDict.object(forKey: "musicID") as! String)
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        if (response.result.value! as! NSDictionary).object(forKey: "compositionListings") != nil
                        {
                            let tempArray = (response.result.value! as! NSDictionary).object(forKey: "compositionListings") as? NSArray
                            self.compositionMusicArray = (tempArray?.mutableCopy() as? NSMutableArray)!
                            self.tempCompositionArray = (tempArray?.mutableCopy() as? NSMutableArray)!
                            self.localCompositionArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                            print(self.localCompositionArray)
                            if self.localCompositionArray.count == 0
                            {
                                for i in 0..<self.tempCompositionArray.count
                                {
                                    let tempDict = self.tempCompositionArray.object(at: i) as? NSDictionary
                                    self.db.insertComposition(createdDate: tempDict?.object(forKey: "_createdDate") as! String, id: tempDict?.object(forKey: "_id") as! String, owner: tempDict?.object(forKey: "_owner") as! String, updatedDate: tempDict?.object(forKey: "_updatedDate") as! String, instrumentAudioURL: tempDict?.object(forKey: "instrumentAudioURL") as! String, instrumentDisplayOrder: String(tempDict?.object(forKey: "instrumentDisplayOrder") as! Int), instrumentLive: String(tempDict?.object(forKey: "instrumentLive") as! Int), instrumentName: tempDict?.object(forKey: "instrumentName") as! String, instrumentVolumeDefault: String(tempDict?.object(forKey: "instrumentVolumeDefault") as! Int), musicId: tempDict?.object(forKey: "musicID") as! String)
                                }
                                self.localCompositionArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                            }
                            else
                            {
                                if self.tempCompositionArray.count == self.localCompositionArray.count
                                {
                                    for k in 0..<self.tempCompositionArray.count
                                    {
                                        let temponlineArray = self.tempCompositionArray.object(at: k) as! NSDictionary
                                        let tempOfflineArray = self.localCompositionArray.object(at: k) as! NSDictionary
                                        self.db.updateByID(createdDate: temponlineArray.object(forKey: "_createdDate") as! String, compositionId: temponlineArray.object(forKey: "_id") as! String, owner: temponlineArray.object(forKey: "_owner") as! String, _updatedDate: temponlineArray.object(forKey: "_updatedDate") as! String, instrumentAudioURL: temponlineArray.object(forKey: "instrumentAudioURL") as! String, instrumentDisplayOrder: String(temponlineArray.object(forKey: "instrumentDisplayOrder") as! Int), instrumentLive: String(temponlineArray.object(forKey: "instrumentLive") as! Int), instrumentName: temponlineArray.object(forKey: "instrumentName") as! String, instrumentVolumeDefault: tempOfflineArray.object(forKey: "instrumentVolumeDefault") as! String, musicID: temponlineArray.object(forKey: "musicID") as! String)
                                    }
                                    self.localCompositionArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                                }
                                else
                                {
                                    var matchArray : NSMutableArray = []
                                    matchArray = self.tempCompositionArray.mutableCopy() as! NSMutableArray
                                  //  if self.tempCompositionArray.count > self.localCompositionArray.count
                                  //  {
                                        
                                        for l in 0..<self.tempCompositionArray.count
                                        {
                                            let onlineDict = self.tempCompositionArray.object(at: l) as! NSDictionary
                                            for m in 0..<self.localCompositionArray.count
                                            {
                                                let offlineDict = self.localCompositionArray.object(at: m) as! NSDictionary
                                                if onlineDict.object(forKey: "instrumentName") as! String == offlineDict.object(forKey: "instrumentName") as! String
                                                {
                                                    matchArray.replaceObject(at: l, with: offlineDict)
                                                }
                                            }
                                        }
                                        
                                        for k in 0..<self.localCompositionArray.count
                                        {
                                            let tempDict = self.localCompositionArray.object(at: k) as! NSDictionary
                                            self.db.deleteComposition(Id: tempDict.object(forKey: "musicID") as! String, name: tempDict.object(forKey: "instrumentName") as! String)
                                        }
                                        
                                        for n in 0..<matchArray.count
                                        {
                                            //  if !(matchArray.object(at: n) is String)
                                            //   {
                                            var displayOrder : String = ""
                                            var tempinstrumetLive : String = ""
                                            var tempInstrumentVolume : String = ""
                                            
                                            let temponlineArray = matchArray.object(at: n) as! NSDictionary
                                            if temponlineArray.object(forKey: "instrumentDisplayOrder") is String
                                            {
                                                displayOrder = temponlineArray.object(forKey: "instrumentDisplayOrder") as! String
                                            }
                                            else
                                            {
                                                displayOrder = String(temponlineArray.object(forKey: "instrumentDisplayOrder") as! Int)
                                            }
                                            if temponlineArray.object(forKey: "instrumentLive") is String
                                            {
                                                tempinstrumetLive = temponlineArray.object(forKey: "instrumentLive") as! String
                                            }
                                            else
                                            {
                                                tempinstrumetLive = String(temponlineArray.object(forKey: "instrumentLive") as! Int)
                                            }
                                            
                                            if temponlineArray.object(forKey: "instrumentVolumeDefault") is String
                                            {
                                                tempInstrumentVolume = temponlineArray.object(forKey: "instrumentVolumeDefault") as! String
                                            }
                                            else
                                            {
                                                tempInstrumentVolume = String(temponlineArray.object(forKey: "instrumentVolumeDefault") as! Int)
                                            }
                                            
                                            self.db.insertComposition(createdDate: temponlineArray.object(forKey: "_createdDate") as! String, id: temponlineArray.object(forKey: "_id") as! String, owner: temponlineArray.object(forKey: "_owner") as! String, updatedDate: temponlineArray.object(forKey: "_updatedDate") as! String, instrumentAudioURL: temponlineArray.object(forKey: "instrumentAudioURL") as! String, instrumentDisplayOrder: displayOrder, instrumentLive: tempinstrumetLive, instrumentName: temponlineArray.object(forKey: "instrumentName") as! String, instrumentVolumeDefault: tempInstrumentVolume, musicId: temponlineArray.object(forKey: "musicID") as! String)
                                            // }
                                        }
                                        self.localCompositionArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                                }
                            }
                            self.getotherSound()
                           // self.optionTableView.reloadData()
                        }
                    }
                }
                else
                {
                     MBProgressHUD.hide(for: self.view, animated: true)
                    if supportingfuction.checkNetworkReachability() == true
                    {
                       supportingfuction.showMessageHudWithMessage("Something went wrong. Please try again." as NSString,delay: 2.0)
                    }
                    else
                    {
                        let tempArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                        self.compositionMusicArray = tempArray
                        self.tempCompositionArray = tempArray
                        self.localCompositionArray = tempArray
                        self.getotherSound()
                    }
                }
        }
    }
    
    func getotherSound()
    {
        MBProgressHUD.showAdded(to: view, animated: true)
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "soundsListings"
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        let tempArray = (response.result.value! as! NSDictionary).object(forKey: "soundsListings") as? NSArray
                        self.tempSoundArray = (tempArray?.mutableCopy() as? NSMutableArray)!
                        
                        self.localSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                        if self.localSoundArray.count == 0
                        {
                            for j in 0..<self.tempSoundArray.count
                            {
                                let tempDict = self.tempSoundArray.object(at: j) as? NSDictionary
                                var audioUrl : String = ""
                                if tempDict?.object(forKey: "soundAudioURL") != nil
                                {
                                    audioUrl = (tempDict?.object(forKey: "soundAudioURL") as? String)!
                                }
                                else
                                {
                                    audioUrl = ""
                                }
                                self.db.insertSound(createdDate: (tempDict?.object(forKey: "_createdDate") as? String)!, id: (tempDict?.object(forKey: "_id") as? String)!, owner: (tempDict?.object(forKey: "_owner") as? String)!, updatedDate: tempDict?.object(forKey: "_updatedDate") as! String, soundAudioURL: audioUrl, soundDisplayOrder: String(tempDict?.object(forKey: "soundDisplayOrder") as! Int), soundLive: String(tempDict?.object(forKey: "soundLive") as! Int), soundName: tempDict?.object(forKey: "soundName") as! String, soundVolumeDefault: "0", musicID: self.musicDetailDict.object(forKey: "musicID") as! String)
                            }
                            self.localSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                        }
                        else
                        {
                            if self.tempSoundArray.count == self.localSoundArray.count
                            {
                                for l in 0..<self.tempSoundArray.count
                                {
                                    let temponlineArray = self.tempSoundArray.object(at: l) as! NSDictionary
                                    let tempOfflineArray = self.localSoundArray.object(at: l) as! NSDictionary
                                    self.db.updateSoundByID(createdDate: temponlineArray.object(forKey: "_createdDate") as! String, SooundId: temponlineArray.object(forKey: "_id") as! String, owner: temponlineArray.object(forKey: "_owner") as! String, _updatedDate: temponlineArray.object(forKey: "_updatedDate") as! String, soundAudioURL: temponlineArray.object(forKey: "soundAudioURL") as! String, soundDisplayOrder: String(temponlineArray.object(forKey: "soundDisplayOrder") as! Int), soundLive: String(temponlineArray.object(forKey: "soundLive") as! Int), SoundName: temponlineArray.object(forKey: "soundName") as! String, instrumetVolumeDefault: tempOfflineArray.object(forKey: "instrumentVolumeDefault") as! String, musicID: self.musicDetailDict.object(forKey: "musicID") as! String)
                                }
                                self.localSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                            }
                            else
                            {
                                var matchSoundArray : NSMutableArray = []
                                matchSoundArray = self.tempSoundArray.mutableCopy() as! NSMutableArray
                                for l in 0..<self.tempSoundArray.count
                                {
                                    let onlineDict = self.tempSoundArray.object(at: l) as! NSDictionary
                                    for m in 0..<self.localSoundArray.count
                                    {
                                        let offlineDict = self.localSoundArray.object(at: m) as! NSDictionary
                                        if onlineDict.object(forKey: "soundName") as! String == offlineDict.object(forKey: "soundName") as! String
                                        {
                                            matchSoundArray.replaceObject(at: l, with: offlineDict)
                                        }
                                    }
                                }
                                
                                for k in 0..<self.localSoundArray.count
                                {
                                    let tempDict = self.localSoundArray.object(at: k) as! NSDictionary
                                    self.db.deleteSound(Id: self.musicDetailDict.object(forKey: "musicID") as! String, name: tempDict.object(forKey: "soundName") as! String)
                                }
                                
                                for n in 0..<matchSoundArray.count
                                {
                                    //  if !(matchArray.object(at: n) is String)
                                    //   {
                                    var displayOrder : String = ""
                                    var tempinstrumetLive : String = ""
                                    var tempInstrumentVolume : String = ""
                                    
                                    let temponlineArray = matchSoundArray.object(at: n) as! NSDictionary
                                    if temponlineArray.object(forKey: "soundDisplayOrder") is String
                                    {
                                        displayOrder = temponlineArray.object(forKey: "soundDisplayOrder") as! String
                                    }
                                    else
                                    {
                                        displayOrder = String(temponlineArray.object(forKey: "soundDisplayOrder") as! Int)
                                    }
                                    if temponlineArray.object(forKey: "soundLive") is String
                                    {
                                        tempinstrumetLive = temponlineArray.object(forKey: "soundLive") as! String
                                    }
                                    else
                                    {
                                        tempinstrumetLive = String(temponlineArray.object(forKey: "soundLive") as! Int)
                                    }
                                    
                                    if temponlineArray.object(forKey: "instrumentVolumeDefault") != nil
                                    {
                                        tempInstrumentVolume = temponlineArray.object(forKey: "instrumentVolumeDefault") as! String
                                    }
                                    else
                                    {
                                        tempInstrumentVolume = "0"
                                    }
                                    
                                    self.db.insertSound(createdDate: (temponlineArray.object(forKey: "_createdDate") as? String)!, id: (temponlineArray.object(forKey: "_id") as? String)!, owner: (temponlineArray.object(forKey: "_owner") as? String)!, updatedDate: temponlineArray.object(forKey: "_updatedDate") as! String, soundAudioURL: temponlineArray.object(forKey: "soundAudioURL") as! String, soundDisplayOrder: displayOrder, soundLive: tempinstrumetLive, soundName: temponlineArray.object(forKey: "soundName") as! String, soundVolumeDefault: tempInstrumentVolume, musicID: self.musicDetailDict.object(forKey: "musicID") as! String)
                                    // }
                                }
                                self.localSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                            }
                        }
                        for i in 0..<tempArray!.count
                        {
                            let tempDict = tempArray?.object(at: i) as? NSDictionary
                            self.compositionMusicArray.add(tempDict!)
                            let localDict = self.localSoundArray.object(at: i) as? NSDictionary
                            self.localCompositionArray.add(localDict!)
                        }
                        self.filterVolumeArray = self.compositionMusicArray
                        self.optionTableView.reloadData()
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                     if supportingfuction.checkNetworkReachability() == true
                     {
                        supportingfuction.showMessageHudWithMessage("Something went wrong. Please try again." as NSString,delay: 2.0)
                     }
                     else
                     {
                        let tempArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                        self.tempSoundArray = tempArray
                        self.localSoundArray = tempArray
                        for i in 0..<tempArray.count
                        {
                            let tempDict = tempArray.object(at: i) as? NSDictionary
                            self.compositionMusicArray.add(tempDict!)
                        }
                        self.localCompositionArray = self.compositionMusicArray
                        self.filterVolumeArray = self.compositionMusicArray
                        print(self.localCompositionArray.count)
                        print(self.compositionMusicArray.count)
                        self.tempCompositionArray = self.db.getCompositionbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                        print(self.tempCompositionArray.count)
                        self.tempSoundArray = self.db.getSoundbyMusicId(Id: (self.musicDetailDict.object(forKey: "musicID") as! String))
                        print(self.tempSoundArray.count)
                        self.optionTableView.reloadData()
                     }
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if compositionMusicArray.count > 0
        {
            return self.compositionMusicArray.count + 3
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
           return 50
        }
        else if indexPath.row == tempCompositionArray.count + 1
        {
           return 18
        }
        else if indexPath.row == tempCompositionArray.count + 2
        {
           return 50
        }
        else
        {
            if indexPath.row == tempCompositionArray.count || indexPath.row == compositionMusicArray.count + 2
            {
               return 70
            }
            else
            {
                return 56
            }
        }
    }
    
    // create a cell for each table view row
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        let cell : UITableViewCell!
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Header")
            let titleLbl = cell.viewWithTag(1) as? UILabel
            let resetBtn = cell.viewWithTag(2) as? UIButton
            let bgView = cell.viewWithTag(5)
            bgView!.backgroundColor = UIColor(red: 249/255, green: 229/255, blue: 229/255, alpha: 0.15)
            bgView!.clipsToBounds = true
            bgView!.layer.cornerRadius = 30
            bgView!.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            titleLbl?.text = "Composition"
            resetBtn?.isHidden = false
            return cell
        }
        else if indexPath.row == tempCompositionArray.count + 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "BlankCell")
            return cell
        }
        else if indexPath.row == tempCompositionArray.count + 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Header")
            let titleLbl = cell.viewWithTag(1) as? UILabel
            let resetBtn = cell.viewWithTag(2) as? UIButton
            let bgView = cell.viewWithTag(5)
            bgView!.backgroundColor = UIColor(red: 249/255, green: 229/255, blue: 229/255, alpha: 0.15)
            bgView!.clipsToBounds = true
            bgView!.layer.cornerRadius = 30
            bgView!.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            titleLbl?.text = "Other sounds"
            resetBtn?.isHidden = true
            return cell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "dataCell")
           
            let titleLbl = cell.viewWithTag(1) as? UILabel
            let slider = cell.viewWithTag(2) as? UISlider
            let bgView = cell.viewWithTag(5)
            
            if indexPath.row <= self.tempCompositionArray.count
            {
                let tempDict = tempCompositionArray.object(at: indexPath.row - 1) as? NSDictionary
                titleLbl?.text = tempDict?.object(forKey: "instrumentName") as? String
                if localCompositionArray.count > 0
                {
                    let localDict = localCompositionArray.object(at: indexPath.row - 1) as? NSDictionary
                    let value : Int = Int(localDict?.object(forKey: "instrumentVolumeDefault") as! String)!
                    let tempValue = CGFloat(value)
                    let convertValue = tempValue / 100
                    slider?.value = Float(convertValue)
                }
                else
                {
                    let tempValue = CGFloat(tempDict?.object(forKey: "instrumentVolumeDefault") as! Int)
                    let convertValue = tempValue / 100
                    slider?.value = Float(convertValue)
                }
                if slider?.value == 0.0
                {
                    slider!.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
                    slider!.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
                }
                else
                {
                    slider!.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
                    slider!.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
                }
            }
            else
            {
               let otherSoundListing = tempSoundArray.object(at: (indexPath.row - tempCompositionArray.count - 3)) as? NSDictionary
                titleLbl?.text = otherSoundListing?.object(forKey: "soundName") as? String
                if localSoundArray.count > 0
                {
                    let localDict = localSoundArray.object(at: indexPath.row - tempCompositionArray.count - 3) as? NSDictionary
                    let value : Int = Int(localDict?.object(forKey: "instrumentVolumeDefault") as! String)!
                    let tempValue = CGFloat(value)
                    let convertValue = tempValue / 100
                    slider?.value = Float(convertValue)
                }
                else
                {
                   slider?.value = 0.0
                }
                if slider?.value == 0.0
                {
                    slider!.setThumbImage(UIImage(named: "Ellipse 43"), for: .normal)
                    slider!.setThumbImage(UIImage(named: "Ellipse 43"), for: .highlighted)
                }
                else
                {
                    slider!.setThumbImage(UIImage(named: "Ellipse 33"), for: .normal)
                    slider!.setThumbImage(UIImage(named: "Ellipse 33"), for: .highlighted)
                }
            }
            
            bgView!.backgroundColor = UIColor(red: 249/255, green: 229/255, blue: 229/255, alpha: 0.15)
            
            if indexPath.row == tempCompositionArray.count
            {
                bgView!.clipsToBounds = true
                bgView!.layer.cornerRadius = 30
                bgView!.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
            else if indexPath.row == compositionMusicArray.count + 2
            {
                bgView!.clipsToBounds = true
                bgView!.layer.cornerRadius = 30
                bgView!.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
            else
            {
                bgView!.clipsToBounds = true
                bgView?.layer.cornerRadius = 0
                bgView!.layer.maskedCorners = []
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // method to run when table view cell is tapped
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == scrollView_Ctrl
        {
            if (self.lastContentOffset > scrollView.contentOffset.y)
            {
                // move up
            }
            else if (self.lastContentOffset < scrollView.contentOffset.y)
            {
                // move down
            }
            // update the new position acquired
            self.lastContentOffset = scrollView.contentOffset.y
            if self.lastContentOffset <= 0
            {
                heightCnst.constant = 390.0
                title_Lbl.isHidden = true
                back_Btn.isHidden = false
                setting_Btn.isHidden = false
            }
            else
            {
                print(compositionMusicArray.count)
                if self.compositionMusicArray.count > 12
                {
                    heightCnst.constant = 900.0
                    
                }
                else if self.compositionMusicArray.count > 15
                {
                    heightCnst.constant = 1000.0
                }
                else if self.compositionMusicArray.count > 10
                {
                    heightCnst.constant = 850.0
                }
                else
                {
                    if self.compositionMusicArray.count == 10
                    {
                        heightCnst.constant = 750.0
                    }
                    else if self.compositionMusicArray.count == 9
                    {
                        heightCnst.constant = 675.0
                    }
                    else
                    {
                        heightCnst.constant = 650.0
                    }
                }
                title_Lbl.isHidden = true
                back_Btn.isHidden = true
                setting_Btn.isHidden = true
            }
        }
    }
    
}

extension MusicDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == Animation_CollectionView{
            return motionAnimatArray.count
        } else {
            return reviewArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    {
        if collectionView == Animation_CollectionView{
            let cell = Animation_CollectionView.dequeueReusableCell(withReuseIdentifier: "Animation", for: indexPath as IndexPath) as UICollectionViewCell
            let bgImage_ImageView = cell.viewWithTag(1) as? UIImageView
            
            let animationDict = motionAnimatArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            bgImage_ImageView?.setImageWith(URL(string: (animationDict.object(forKey: "thumbImage") as? String)!), placeholderImage: UIImage(named: "musicDetailBG"))
            
            bgImage_ImageView?.layer.cornerRadius = 20
            bgImage_ImageView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            return cell
        } else {
        if indexPath.row == reviewArray.count
        {
            let cell = collectionView_Ctrl.dequeueReusableCell(withReuseIdentifier: "Add", for: indexPath as IndexPath) as UICollectionViewCell
            let bgView = cell.viewWithTag(1)
            bgView?.layer.cornerRadius = 12
            bgView?.clipsToBounds = true
            return cell
        } else {
            let cell = collectionView_Ctrl.dequeueReusableCell(withReuseIdentifier: "Review", for: indexPath as IndexPath) as UICollectionViewCell
            let bgView = cell.viewWithTag(1)
            let userName = cell.viewWithTag(3) as? UILabel
            let description = cell.viewWithTag(4) as? UILabel
            let agoLbl = cell.viewWithTag(5) as? UILabel
            let ratingImage = cell.viewWithTag(6) as? UIImageView
            let singleDesLbl = cell.viewWithTag(7) as? UILabel
            
            bgView?.layer.cornerRadius = 12
            bgView?.clipsToBounds = true
            
            let tempDict = reviewArray.object(at: indexPath.row) as? NSDictionary

            userName?.text = tempDict?.object(forKey: "firstName") as? String ?? ""
            description?.text = tempDict?.object(forKey: "description") as? String ?? ""
            
            agoLbl?.text = tempDict?.object(forKey: "recencyText") as? String ?? ""
            
            if (description?.text!.count)! > 28
            {
                singleDesLbl?.isHidden = true
                description?.isHidden = false
            } else {
                singleDesLbl?.isHidden = false
                description?.isHidden = true
                singleDesLbl?.text = tempDict?.object(forKey: "description") as? String ?? ""
            }
            
            ratingImage!.layer.cornerRadius = (ratingImage?.frame.size.height)! / 2
            ratingImage!.clipsToBounds = true
            
            if let rating = tempDict?.object(forKey: "rating") as? Int
            {
                ratingImage?.isHidden = false
               if rating == 1
               {
                ratingImage?.image = UIImage(named: "1-colour (1)")
               } else if rating == 2 {
                ratingImage?.image = UIImage(named: "2-colour (1)")
               } else if rating == 3 {
                ratingImage?.image = UIImage(named: "3-colour (1)")
               } else if rating == 4 {
                ratingImage?.image = UIImage(named: "4-colour (1)")
               } else {
                ratingImage?.image = UIImage(named: "5-colour (1)")
               }
            } else {
                ratingImage?.isHidden = true
            }
            
            return cell
        }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView == Animation_CollectionView{
            let tempDict = motionAnimatArray.object(at: indexPath.row) as? NSDictionary ?? [:]
            
            guard let url = URL(string: tempDict.object(forKey: "mp4Url") as? String ?? "") else {
                        return
                    }
            avPlayer = nil
                    // Create an AVPlayer, passing it the HTTP Live Streaming URL.
            avPlayer = AVPlayer(url: url)
                    let controller = AVPlayerViewController()
                    controller.player = avPlayer
            controller.videoGravity = .resizeAspectFill
            controller.showsPlaybackControls = false
            NotificationCenter.default.addObserver(self, selector: #selector(closePlayer), name: NSNotification.Name(rawValue: "close"), object: controller.player?.currentItem)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closePlayer))
                controller.view.addGestureRecognizer(tapGestureRecognizer)
            
                    present(controller, animated: true) {
                        
                        NotificationCenter.default.addObserver(self, selector: #selector(MusicDetailViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem)
                        
                        self.avPlayer.play()
                    }
            
        } else {
            if indexPath.row == reviewArray.count
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReviewViewController") as! AddReviewViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let tempDict = reviewArray.object(at: indexPath.row) as? NSDictionary
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewresponseViewController") as! ReviewresponseViewController
                vc.previewDetail = tempDict?.mutableCopy() as! NSDictionary
                vc.musicDetail = musicDetailDict
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func finishVideo(notification: Notification)
    {
        if let playerItem = notification.object as? AVPlayerItem {
                playerItem.seek(to: CMTime.zero, completionHandler: nil)
            self.avPlayer.play()
            }
    }
    
    @objc func closePlayer() {
        dismiss(animated: true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    {
        if collectionView == Animation_CollectionView{
            return CGSize(width: 160, height: 222)
        } else {
            if indexPath.row == reviewArray.count
            {
                return CGSize(width: 154, height: 154)
            }
            else
            {
                return CGSize(width: 256, height: 154)
            }
        }
    }
    
   
}




