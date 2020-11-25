//
//  VideoViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 31/08/20.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire

class VideoViewController: UIViewController {

    @IBOutlet weak var aurora_lbl: UILabel!
    var avPlayer: AVPlayer!
    var avpController = AVPlayerViewController()
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var videoBgView_Ctrl: UIView!
    
    var db:DBHelper = DBHelper()
    var songListArray : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_lbl.center.x = view.center.x // Place it in the center x of the view.
        title_lbl.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
        // animate it from the left to the right
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
            self.title_lbl.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let moviePath = Bundle.main.path(forResource: "aurora1024", ofType: "mp4")
        if let path = moviePath {
            let url = NSURL.fileURL(withPath: path)
            self.avPlayer = AVPlayer(url: url)
            self.avpController = AVPlayerViewController()
            self.avpController.player = self.avPlayer
            avpController.view.frame = videoBgView_Ctrl.frame
            avpController.videoGravity = AVLayerVideoGravity.resizeAspectFill
            avpController.showsPlaybackControls = false
            self.addChild(avpController)
            self.videoBgView_Ctrl.addSubview(avpController.view)
            self.avPlayer.play()
            NotificationCenter.default.addObserver(self, selector: #selector(VideoViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
        
        if supportingfuction.checkNetworkReachability() == true
        {
           getUpdatedMusic()
        }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func finishVideo()
    {
        if supportingfuction.checkNetworkReachability() == false
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    func getUpdatedMusic()
    {
         //   MBProgressHUD.showAdded(to: view, animated: true)
        var updateDate : String = ""
        if UserDefaults.standard.object(forKey: "UpdateDate") != nil
        {
           updateDate = UserDefaults.standard.object(forKey: "UpdateDate") as! String
        }
        else
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let startDate = Date()
            updateDate = formatter.string(from: startDate)
        }
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "musicUpdated?checkFromDate=" + updateDate
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let startDate = Date()
                updateDate = formatter.string(from: startDate)
                UserDefaults.standard.set(updateDate, forKey: "UpdateDate")
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        if (response.result.value! as! NSDictionary).object(forKey: "updatedMusic") != nil
                        {
                            let tempArray = (response.result.value! as! NSDictionary).object(forKey: "updatedMusic") as? NSArray
                            print(tempArray!)
                            var musicPremium : String = ""
                            var musicNew : String = ""
                            var selectedTag : String = ""
                            var musicDescription : String = ""
                            var musicDesciption2 : String = ""
                            var smallImageUrl : String = ""
                            var largeImageUrl : String = ""
                            for i in 0..<tempArray!.count
                            {
                                let tempdict = tempArray!.object(at: i) as? NSDictionary
                                self.db.deletedMusic(id: (tempdict?.object(forKey: "musicID") as? String)!)
                                if tempdict?.object(forKey: "musicPremium") != nil
                                {
                                    musicPremium = String(tempdict?.object(forKey: "musicPremium") as! Int)
                                }
                                else
                                {
                                    musicPremium = ""
                                }
                                
                                if tempdict?.object(forKey: "largeImageURL") != nil
                                {
                                    largeImageUrl = (tempdict?.object(forKey: "largeImageURL") as? String)!
                                }
                                else
                                {
                                    largeImageUrl = ""
                                }
                                
                                if tempdict?.object(forKey: "smallImageURL") != nil
                                {
                                    smallImageUrl = (tempdict?.object(forKey: "smallImageURL") as? String)!
                                }
                                else
                                {
                                    smallImageUrl = ""
                                }
                                
                                if tempdict?.object(forKey: "musicNew") != nil
                                {
                                    musicNew = String(tempdict?.object(forKey: "musicNew") as! Int)
                                }
                                else
                                {
                                    musicNew = ""
                                }
                                if tempdict?.object(forKey: "musicDescription") != nil
                                {
                                    musicDescription = tempdict?.object(forKey: "musicDescription") as! String
                                }
                                else
                                {
                                    musicDescription = ""
                                }
                                if tempdict?.object(forKey: "musicDescription2") != nil
                                {
                                    musicDesciption2 = tempdict?.object(forKey: "musicDescription2") as! String
                                }
                                else
                                {
                                    musicDesciption2 = ""
                                }
                                print(tempdict!)
                                selectedTag = (tempdict?.object(forKey: "allTags") as? String)!
                                
                                print(musicNew)
                                print(musicPremium)
                                self.db.insertMusicDetail(createdDate: (tempdict?.object(forKey: "_createdDate") as? String)!, id: (tempdict?.object(forKey: "_id") as? String)!, owner: (tempdict?.object(forKey: "_owner") as? String)!, updatedDate: (tempdict?.object(forKey: "_updatedDate") as? String)!, largeImage: largeImageUrl, musicDescription: musicDescription, musicDescription2: musicDesciption2, musicID: (tempdict?.object(forKey: "musicID") as? String)!, musicLive: String(tempdict?.object(forKey: "musicLive") as! Int), musicName: tempdict?.object(forKey: "musicName") as! String, musicNew: musicNew, musicPremium: musicPremium, smallImageURL: smallImageUrl, tag: selectedTag)
                            }
                            self.getMusicNotLive()
                        }
                        else
                        {
                          self.getMusicNotLive()
                        }
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                   // supportingfuction.showMessageHudWithMessage("No Music Found." as NSString,delay: 2.0)
                }
        }
    }
    
    func getMusicNotLive()
    {
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "musicNotLive"
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        let tempArray = (response.result.value! as! NSDictionary).object(forKey: "musicNotLive") as? NSArray
                        print(tempArray!)
                        self.songListArray = self.db.getMusicDetail(selectedTag: "All")
                        for i in 0..<self.songListArray.count
                        {
                            let tempDict = self.songListArray.object(at: i) as? NSDictionary
                            for j in 0..<tempArray!.count
                            {
                                let removeDict = tempArray?.object(at: j) as? NSDictionary
                                if tempDict?.object(forKey: "musicID") as? String == removeDict?.object(forKey: "musicID") as? String
                                {
                                    self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                                    self.db.deletedMusic(id: (tempDict?.object(forKey: "musicID") as? String)!)
                                }
                            }
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    // supportingfuction.showMessageHudWithMessage("No Music Found." as NSString,delay: 2.0)
                }
        }
    }
    
}
