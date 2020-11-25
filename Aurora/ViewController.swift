//
//  ViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 22/08/20.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import SQLite3
import SwiftySound

class ViewController: UIViewController {

    @IBOutlet weak var collectionView_Ctrl: UICollectionView!
    @IBOutlet weak var tableView_ctrl: UITableView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    
    
    
    var songTypeArray : NSMutableArray = []
    let songImagesArray = ["Spirit.png","Whispers.png","Another.png","wp","road"]
    var selectedIndex : Int = 0
    var selectedArray : NSMutableArray = []
    var songListArray : NSMutableArray = []
    var allSongListArray : NSMutableArray = []
    var selectedTags : String = "All"
    var isfromSelection : Bool = true
    var db:DBHelper = DBHelper()
    var favourite:[favourite] = []
    
    
    override func viewDidLoad()
        
    {
        super.viewDidLoad()
        self.favourite = self.db.read()
        print(self.favourite)
        
//        let moviePath = Bundle.main.path(forResource: "aurora1024", ofType: "mp4")
//        if let path = moviePath {
//            let url = NSURL.fileURL(withPath: path)
//            self.avPlayer = AVPlayer(url: url)
//            self.avpController = AVPlayerViewController()
//            self.avpController.player = self.avPlayer
//            avpController.view.frame = bgView_Ctrl.frame
//            avpController.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            avpController.showsPlaybackControls = false
//            self.addChild(avpController)
//            self.bgView_Ctrl.addSubview(avpController.view)
//            self.avPlayer.play()
//
//        //    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.finishVideo), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//        }
        
        if supportingfuction.checkNetworkReachability() == true
        {
            if UserDefaults.standard.object(forKey: "isOneTime") != nil
            {
                getsonngListFromLocal()
            }
            else
            {
                getSongList(selectedTags: selectedTags)
            }
            getSongTypeList()
        }
        else
        {
            songTypeArray = self.db.getTagfromLocal()
            getsonngListFromLocal()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        selectedTags = "All"
        selectedIndex = 0
        isfromSelection = true
    }
    
    func getsonngListFromLocal()
    {
        songListArray = self.db.getMusicDetail(selectedTag: selectedTags)
        if selectedTags == "All"
        {
            self.allSongListArray = self.songListArray
        }
        for i in 0..<self.songListArray.count
        {
            let tempdict = self.songListArray.object(at: i) as? NSDictionary
            for j in 0..<self.favourite.count
            {
                if tempdict?.object(forKey: "musicID") as! String == self.favourite[j].musicId
                {
                    var dict = tempdict as! [String: AnyObject]
                    print(dict)
                    dict["isFavourite"] = self.favourite[j].updateStatus as AnyObject
                    self.songListArray.replaceObject(at: i, with: dict as NSDictionary)
                }
            }
        }
        
        for k in 0..<self.songListArray.count
        {
            let songDict = self.songListArray.object(at: k) as? NSDictionary
            if songDict?.object(forKey: "isFavourite") != nil
            {
                self.selectedArray.add("no")
            }
            else
            {
                self.selectedArray.add("yes")
            }
        }
    }
    
    func getSongTypeList()
    {
        songTypeArray = []
        MBProgressHUD.showAdded(to: view, animated: true)
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "tagListings"
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                   MBProgressHUD.hide(for: self.view, animated: true)
                   if(response.response?.statusCode == 200)
                   {
                    let tempArray = (response.result.value! as! NSDictionary).object(forKey: "tags") as? NSArray
                    self.songTypeArray = tempArray?.mutableCopy() as! NSMutableArray
                    for i in 0..<self.songTypeArray.count
                    {
                        let tempDict = self.songTypeArray.object(at: i) as? NSDictionary
                        var tagDesciption : String = ""
                        if tempDict?.object(forKey: "tagDescription") != nil
                        {
                            tagDesciption = (tempDict?.object(forKey: "tagDescription") as? String)!
                        }
                        else
                        {
                            tagDesciption = ""
                        }
                        self.db.insertTag(createdDate: (tempDict?.object(forKey: "_createdDate") as? String)!, tagId: (tempDict?.object(forKey: "_id") as? String)!, owner: (tempDict?.object(forKey: "_owner") as? String)!, updateDate: (tempDict?.object(forKey: "_updatedDate") as? String)!, tagDescription: tagDesciption, tagLive: String(tempDict?.object(forKey: "tagLive") as! Int), tagName: tempDict?.object(forKey: "tagName") as! String, tagOrder: String(tempDict?.object(forKey: "tagOrder") as! Int))
                      }
                    }
                    self.collectionView_Ctrl.reloadData()
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    supportingfuction.showMessageHudWithMessage("Something went wrong. Please try again." as NSString,delay: 2.0)
                }
        }
    }
    
    func getSongList(selectedTags : String)
        
    {
        songListArray = []
        selectedArray = []
        let tempRecordArray : NSMutableArray = []
        if isfromSelection == false
        {
           MBProgressHUD.showAdded(to: view, animated: true)
        }
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "musicListings?tag=" + selectedTags
        Alamofire.request(baseUrl, method : .get, parameters: nil, headers: nil)
            .responseJSON
            { response in
                print(response)
                if String(describing: response.result) == "SUCCESS"
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    if(response.response?.statusCode == 200)
                    {
                        UserDefaults.standard.set("yes", forKey: "isOneTime")
                        let tempArray = (response.result.value! as! NSDictionary).object(forKey: "musicListings") as? NSArray
                        for m in 0..<tempArray!.count
                        {
                           let newDict = tempArray?.object(at: m) as? NSDictionary
                           if newDict?.object(forKey: "musicNew") as? Int == 1
                           {
                             self.songListArray.add(newDict!)
                           }
                           else
                           {
                             tempRecordArray.add(newDict!)
                           }
                        }
                        for l in 0..<tempRecordArray.count
                        {
                            let tempNewDict = tempRecordArray.object(at: l) as? NSDictionary
                            self.songListArray.add(tempNewDict!)
                        }
                      //  self.songListArray = tempArray?.mutableCopy() as! NSMutableArray
                        print(self.songListArray)
                        var musicPremium : String = ""
                        var musicNew : String = ""
                        var selectedTag : String = ""
                        var musicDescription : String = ""
                        var musicDesciption2 : String = ""
                        for i in 0..<self.songListArray.count
                        {
                            let tempdict = self.songListArray.object(at: i) as? NSDictionary
                            
                            if tempdict?.object(forKey: "musicPremium") != nil
                            {
                                musicPremium = String(tempdict?.object(forKey: "musicPremium") as! Int)
                            }
                            else
                            {
                                musicPremium = ""
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
                            self.db.insertMusicDetail(createdDate: (tempdict?.object(forKey: "_createdDate") as? String)!, id: (tempdict?.object(forKey: "_id") as? String)!, owner: (tempdict?.object(forKey: "_owner") as? String)!, updatedDate: (tempdict?.object(forKey: "_updatedDate") as? String)!, largeImage: (tempdict?.object(forKey: "largeImageURL") as? String)!, musicDescription: musicDescription, musicDescription2: musicDesciption2, musicID: (tempdict?.object(forKey: "musicID") as? String)!, musicLive: String(tempdict?.object(forKey: "musicLive") as! Int), musicName: tempdict?.object(forKey: "musicName") as! String, musicNew: musicNew, musicPremium: musicPremium, smallImageURL: tempdict?.object(forKey: "smallImageURL") as! String, tag: selectedTag)
                            if selectedTags == "All"
                            {
                                self.allSongListArray = self.songListArray
                            }
                            for j in 0..<self.favourite.count
                            {
                                if tempdict?.object(forKey: "musicID") as! String == self.favourite[j].musicId
                                {
                                    var dict = tempdict as! [String: AnyObject]
                                    print(dict)
                                    dict["isFavourite"] = self.favourite[j].updateStatus as AnyObject
                                    self.songListArray.replaceObject(at: i, with: dict as NSDictionary)
                                }
                            }
                        }
                        
                        for k in 0..<self.songListArray.count
                        {
                            let songDict = self.songListArray.object(at: k) as? NSDictionary
                            if songDict?.object(forKey: "isFavourite") != nil
                            {
                                self.selectedArray.add("no")
                            }
                            else
                            {
                                self.selectedArray.add("yes")
                            }
                        }
                    }
                }
                else
                {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    supportingfuction.showMessageHudWithMessage("No Music Found." as NSString,delay: 2.0)
                }
                self.tableView_ctrl.reloadData()
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool)
    {
       NotificationCenter.default.removeObserver(self)
    }

    @IBAction func timerBtn_Action(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func purchaseBtn_Action(_ sender: UIButton)
    {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableView_ctrl)
        let cellIndexPath = self.tableView_ctrl.indexPathForRow(at: pointInTable)
        let selectedIndexRow = cellIndexPath!.row
        let tempDict = songListArray.object(at: selectedIndexRow) as? NSDictionary
        
        if tempDict?.object(forKey: "musicPremium") is String
        {
            if tempDict?.object(forKey: "musicPremium") != nil && tempDict?.object(forKey: "musicPremium") as! String == "1"
            {
                
            }
            else
            {
                if selectedArray.object(at: selectedIndexRow) as? String == "yes"
                {
                    selectedArray.replaceObject(at: selectedIndexRow, with: "no")
                    db.insert(songId: (tempDict?.object(forKey: "musicID") as? String)!, updateStatus: "1")
                }
                else
                {
                    selectedArray.replaceObject(at: selectedIndexRow, with: "yes")
                    self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                }
//                if selectedTags == "Favourites"
//                {
//                    self.favourite = self.db.read()
//                    showFavouriteMusic()
//                }
            }
        }
        else
        {
            if tempDict?.object(forKey: "musicPremium") != nil && tempDict?.object(forKey: "musicPremium") as! Int == 1
            {
                
            }
            else
            {
                if selectedArray.object(at: selectedIndexRow) as? String == "yes"
                {
                    selectedArray.replaceObject(at: selectedIndexRow, with: "no")
                    db.insert(songId: (tempDict?.object(forKey: "musicID") as? String)!, updateStatus: "1")
                }
                else
                {
                    selectedArray.replaceObject(at: selectedIndexRow, with: "yes")
                    self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                }
//                if selectedTags == "Favourites"
//                {
//                    self.favourite = self.db.read()
//                    showFavouriteMusic()
//                }
            }
        }
        tableView_ctrl.reloadData()
//        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "PurchasePopViewController")  as! PurchasePopViewController
//        popOverVC.view.frame = self.view.frame
//        self.view.addSubview(popOverVC.view)
//        self.addChild(popOverVC)
    }
    
    @IBAction func settingBtn_Action(_ sender: Any)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        
    {
        return songTypeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        
    {
        let cell = collectionView_Ctrl.dequeueReusableCell(withReuseIdentifier: "SongType", for: indexPath as IndexPath) as UICollectionViewCell
        let titleLbl = cell.viewWithTag(2) as? UILabel
        let bgView = cell.viewWithTag(1)
        
        bgView?.layer.cornerRadius = 12
        bgView?.clipsToBounds = true
        
        let tagsDict = songTypeArray.object(at: indexPath.row) as? NSDictionary
        if selectedIndex == indexPath.row
        {
            bgView?.backgroundColor = UIColor(red:253.0/255.0, green:141.0/255.0, blue:141.0/255.0, alpha: 1)
            titleLbl?.textColor = UIColor.black
        }
        else
        {
            bgView?.backgroundColor = UIColor(red:0.0/255.0, green:26.0/255.0, blue:63.0/255.0, alpha: 0.33)
            titleLbl?.textColor = UIColor(red:253.0/255.0, green:141.0/255.0, blue:141.0/255.0, alpha: 1)
        }
        titleLbl?.text = tagsDict?.object(forKey: "tagName") as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.favourite = self.db.read()
        isfromSelection = false
        selectedIndex = indexPath.row
        let tagsDict = songTypeArray.object(at: indexPath.row) as? NSDictionary
        selectedTags = (tagsDict?.object(forKey: "tagName") as? String)!
       // selectedTags = tempTag.replacingOccurrences(of: " ", with: "%20")
        if selectedIndex == 1
        {
           //showFavouriteMusic()
            songListArray = []
            selectedArray = []
            for i in 0..<self.allSongListArray.count
            {
                let tempdict = self.allSongListArray.object(at: i) as? NSDictionary
                for j in 0..<self.favourite.count
                {
                    if tempdict?.object(forKey: "musicID") as! String == self.favourite[j].musicId
                    {
                        var dict = tempdict as! [String: AnyObject]
                        print(dict)
                        dict["isFavourite"] = self.favourite[j].updateStatus as AnyObject
                        self.songListArray.add(dict as NSDictionary)
                    }
                }
            }
            
            for k in 0..<self.songListArray.count
            {
                let songDict = self.songListArray.object(at: k) as? NSDictionary
                if songDict?.object(forKey: "isFavourite") != nil
                {
                    self.selectedArray.add("no")
                }
                else
                {
                    self.selectedArray.add("yes")
                }
            }
            self.tableView_ctrl.reloadData()
        }
        else
        {
            if UserDefaults.standard.object(forKey: "isOneTime") != nil
            {
             self.allSongListArray = self.db.getMusicDetail(selectedTag: "All")
               if selectedTags == "All"
               {
                 songListArray = []
                 selectedArray = []
                 songListArray = self.allSongListArray
                for i in 0..<self.songListArray.count
                {
                    let tempdict = self.songListArray.object(at: i) as? NSDictionary
                    for j in 0..<self.favourite.count
                    {
                        if tempdict?.object(forKey: "musicID") as! String == self.favourite[j].musicId
                        {
                            var dict = tempdict as! [String: AnyObject]
                            print(dict)
                            dict["isFavourite"] = self.favourite[j].updateStatus as AnyObject
                            self.songListArray.replaceObject(at: i, with: dict as NSDictionary)
                        }
                    }
                }
                
                for k in 0..<self.songListArray.count
                {
                    let songDict = self.songListArray.object(at: k) as? NSDictionary
                    if songDict?.object(forKey: "isFavourite") != nil
                    {
                        self.selectedArray.add("no")
                    }
                    else
                    {
                        self.selectedArray.add("yes")
                    }
                }
               }
               else
               {
                 selectedArray = []
                 songListArray = self.db.getMusicDetail(selectedTag: selectedTags)
                for i in 0..<self.songListArray.count
                {
                    let tempdict = self.songListArray.object(at: i) as? NSDictionary
                    for j in 0..<self.favourite.count
                    {
                        if tempdict?.object(forKey: "musicID") as! String == self.favourite[j].musicId
                        {
                            var dict = tempdict as! [String: AnyObject]
                            print(dict)
                            dict["isFavourite"] = self.favourite[j].updateStatus as AnyObject
                            self.songListArray.replaceObject(at: i, with: dict as NSDictionary)
                        }
                    }
                }
                
                for k in 0..<self.songListArray.count
                {
                    let songDict = self.songListArray.object(at: k) as? NSDictionary
                    if songDict?.object(forKey: "isFavourite") != nil
                    {
                        self.selectedArray.add("no")
                    }
                    else
                    {
                        self.selectedArray.add("yes")
                    }
                }
               }
                tableView_ctrl.reloadData()
            }
            else
            {
               getSongList(selectedTags: selectedTags)
            }
        }
        
        collectionView_Ctrl.reloadData()
    }
    
    func showFavouriteMusic()
    {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        
    {
        let tagsDict = songTypeArray.object(at: indexPath.item) as? NSDictionary
        let label = UILabel(frame: CGRect.zero)
        label.text =  tagsDict?.object(forKey: "tagName") as? String
        label.sizeToFit()
        return CGSize(width: label.frame.width + 30, height: 48)
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate
    
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return songListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        let cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "SongList")
        
        let bgImage = cell.viewWithTag(1) as? UIImageView
        let newLbl = cell.viewWithTag(2) as? UIImageView
        let favBtn = cell.viewWithTag(3) as? UIButton
        let songName = cell.viewWithTag(5) as? UILabel
        
        bgImage?.layer.cornerRadius = 20
        bgImage?.clipsToBounds = true
        
        let tempDict = songListArray.object(at: indexPath.row) as? NSDictionary
        print(tempDict)
        if tempDict?.object(forKey: "smallImageURL") != nil
        {
           bgImage?.setImageWith(URL(string: (tempDict?.object(forKey: "smallImageURL") as? String)!), placeholderImage: UIImage(named: "user-1"))
        }
        else
        {
           bgImage?.image = UIImage(named: "default-songimage")
        }
        
        songName?.text = tempDict?.object(forKey: "musicName") as? String
        
        if tempDict?.object(forKey: "musicNew") != nil
        {
            if tempDict?.object(forKey: "musicNew") is String
            {
                if tempDict?.object(forKey: "musicNew") as! String == "1"
                {
                    newLbl?.isHidden = false
                }
                else
                {
                    newLbl?.isHidden = true
                }
            }
            else
            {
                if tempDict?.object(forKey: "musicNew") as! Int == 1
                {
                    newLbl?.isHidden = false
                }
                else
                {
                    newLbl?.isHidden = true
                }
            }
        }
        else
        {
            newLbl?.isHidden = true
        }

        if tempDict?.object(forKey: "musicPremium") != nil
        {
            if tempDict?.object(forKey: "musicPremium") is String
            {
                if tempDict?.object(forKey: "musicPremium") as? String == "1"
                {
                    favBtn?.isHidden = false
                    favBtn?.setImage(UIImage(named: "padlock"), for: .normal)
                }
                else
                {
                    if selectedArray.object(at: indexPath.row) as? String == "yes"
                    {
                        favBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                    }
                    else
                    {
                        favBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                    }
                    favBtn?.isHidden = false
                }
            }
            else
            {
                if tempDict?.object(forKey: "musicPremium") as? Int == 1
                {
                    favBtn?.isHidden = false
                    favBtn?.setImage(UIImage(named: "padlock"), for: .normal)
                }
                else
                {
                    if selectedArray.object(at: indexPath.row) as? String == "yes"
                    {
                        favBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                    }
                    else
                    {
                        favBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                    }
                    favBtn?.isHidden = false
                }
            }
        }
        else
        {
            if selectedArray.object(at: indexPath.row) as? String == "yes"
            {
                favBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
            }
            else
            {
                favBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
            }
           favBtn?.isHidden = false
        }
        
     //   }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        
    {
        let tempDict = songListArray.object(at: indexPath.row) as? NSDictionary
        if tempDict?.object(forKey: "musicPremium") != nil
        {
            if tempDict?.object(forKey: "musicPremium") is String
            {
                if tempDict?.object(forKey: "musicPremium") as? String == "1"
                {
                    let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "PurchasePopViewController")  as! PurchasePopViewController
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    self.addChild(popOverVC)
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MusicDetailViewController") as! MusicDetailViewController
                    vc.musicDetailDict = tempDict?.mutableCopy() as! NSMutableDictionary
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else
            {
                if tempDict?.object(forKey: "musicPremium") as? Int == 1
                {
                    let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "PurchasePopViewController")  as! PurchasePopViewController
                    popOverVC.view.frame = self.view.frame
                    self.view.addSubview(popOverVC.view)
                    self.addChild(popOverVC)
                }
                else
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MusicDetailViewController") as! MusicDetailViewController
                    vc.musicDetailDict = tempDict?.mutableCopy() as! NSMutableDictionary
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MusicDetailViewController") as! MusicDetailViewController
            vc.musicDetailDict = tempDict?.mutableCopy() as! NSMutableDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
}


