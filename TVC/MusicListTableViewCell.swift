//
//  MusicListTableViewCell.swift
//  Aurora
//
//  Created by AugursMacbook on 10/11/21.
//

import UIKit

protocol MusicTapDelegate: class {
    func didMusicSelectItem(musicDict: NSDictionary, indexPath: Int)
}

protocol PreviewTapDelegate: class {
    func didPreviewSelectItem(musicDict: NSDictionary)
}

protocol FavouriteTapDelegate: class {
    func didFavouriteSelectItem(musicDict: NSDictionary)
}


class MusicListTableViewCell: UITableViewCell {

    weak var delegateMusicTap: MusicTapDelegate?
    weak var delegatePreviewTap: PreviewTapDelegate?
    weak var delegateFavouriteTap: FavouriteTapDelegate?
    
    @IBOutlet weak var collectionView_Ctrl: UICollectionView!
    
    let margin: CGFloat = 10
    var songMusicList : NSMutableArray = []
    var db:DBHelper = DBHelper()
    var favourite:[favourite] = []
    var selectedArray : NSMutableArray = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedArray = []
        guard let collectionView = collectionView_Ctrl, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

           flowLayout.minimumInteritemSpacing = margin
           flowLayout.minimumLineSpacing = margin
           flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        collectionView_Ctrl.delegate = self
        collectionView_Ctrl.dataSource = self
        print(songMusicList)
        self.favourite = self.db.read()
        print(self.favourite)
        for i in 0..<self.songMusicList.count
        {
            let tempDict = self.songMusicList.object(at: i) as? NSDictionary
            for j in 0..<self.favourite.count
            {
                if tempDict?.object(forKey: "musicID") as! String == self.favourite[j].musicId
                {
                    var dict = tempDict as! [String: AnyObject]
                    print(dict)
                    dict["isFavourite"] = self.favourite[j].updateStatus as AnyObject
                    self.songMusicList.replaceObject(at: i, with: dict as NSDictionary)
                }
            }
        }
        
        for k in 0..<self.songMusicList.count
        {
            let songDict = self.songMusicList.object(at: k) as? NSDictionary
            if songDict?.object(forKey: "isFavourite") != nil
            {
                self.selectedArray.add("no")
            }
            else
            {
                self.selectedArray.add("yes")
            }
        }
        
        print(self.songMusicList)
        
        collectionView_Ctrl.reloadData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func previewBtn_Action(_ sender: UIButton)
    {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.collectionView_Ctrl)
        let cellIndexPath = self.collectionView_Ctrl.indexPathForItem(at: pointInTable)
        let tempDict = songMusicList.object(at: cellIndexPath!.row) as? NSDictionary
        delegatePreviewTap?.didPreviewSelectItem(musicDict: tempDict!)
    }
    
    
    @IBAction func faouruteBtn_ction(_ sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.collectionView_Ctrl)
        let cellIndexPath = self.collectionView_Ctrl.indexPathForItem(at: pointInTable)
        let tempDict = songMusicList.object(at: cellIndexPath!.row) as? NSDictionary
        if tempDict?.object(forKey: "musicPremium") is String
        {
            if tempDict?.object(forKey: "musicPremium") != nil && tempDict?.object(forKey: "musicPremium") as! String == "1"
            {
                if let isPurchase = UserDefaults.standard.object(forKey: "isMusicPurchase"), isPurchase as! String == "yes"
                {
                    if selectedArray.object(at: cellIndexPath!.row) as? String == "yes"
                    {
                        selectedArray.replaceObject(at: cellIndexPath!.row, with: "no")
                        db.insert(songId: (tempDict?.object(forKey: "musicID") as? String)!, updateStatus: "1")
                    }
                    else
                    {
                        selectedArray.replaceObject(at: cellIndexPath!.row, with: "yes")
                        self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                    }
                }
            }
            else
            {
                if selectedArray.object(at: cellIndexPath!.row) as? String == "yes"
                {
                    selectedArray.replaceObject(at: cellIndexPath!.row, with: "no")
                    db.insert(songId: (tempDict?.object(forKey: "musicID") as? String)!, updateStatus: "1")
                }
                else
                {
                    selectedArray.replaceObject(at: cellIndexPath!.row, with: "yes")
                    self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                }
                
            }
        }
        else
        {
            if tempDict?.object(forKey: "musicPremium") != nil && tempDict?.object(forKey: "musicPremium") as! Int == 1
            {
                if let isPurchase = UserDefaults.standard.object(forKey: "isMusicPurchase"), isPurchase as! String == "yes"
                {
                    if selectedArray.object(at: cellIndexPath!.row) as? String == "yes"
                    {
                        selectedArray.replaceObject(at: cellIndexPath!.row, with: "no")
                        db.insert(songId: (tempDict?.object(forKey: "musicID") as? String)!, updateStatus: "1")
                    }
                    else
                    {
                        selectedArray.replaceObject(at: cellIndexPath!.row, with: "yes")
                        self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                    }
                }
            }
            else
            {
                if selectedArray.object(at: cellIndexPath!.row) as? String == "yes"
                {
                    selectedArray.replaceObject(at: cellIndexPath!.row, with: "no")
                    db.insert(songId: (tempDict?.object(forKey: "musicID") as? String)!, updateStatus: "1")
                }
                else
                {
                    selectedArray.replaceObject(at: cellIndexPath!.row, with: "yes")
                    self.db.deleteByID(id: (tempDict?.object(forKey: "musicID") as? String)!)
                }
            }
        }
      //  NotificationCenter.default.post(name: NSNotification.Name("Favourite"), object: nil, userInfo: nil)
        delegateFavouriteTap?.didFavouriteSelectItem(musicDict: tempDict!)
       // awakeFromNib()
    }
    
}

extension MusicListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songMusicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicList", for: indexPath) as? UICollectionViewCell
        let musicImage_imageview = cell?.viewWithTag(1) as! UIImageView
        let musicName = cell?.viewWithTag(2) as? UILabel
        let musicDescription = cell?.viewWithTag(3) as? UILabel
        let newImage = cell?.viewWithTag(5) as? UIImageView
        let premiumBtn = cell?.viewWithTag(6) as? UIButton
        let previewBtn = cell?.viewWithTag(99) as? UIButton
        let freeImage = cell?.viewWithTag(77) as? UIImageView
        
        musicImage_imageview.layer.cornerRadius = 17.0
        musicImage_imageview.clipsToBounds = true
        
        let musicDict = songMusicList.object(at: indexPath.row) as? NSDictionary
        
        musicImage_imageview.setImageWith(URL(string: (musicDict?.object(forKey: "smallImageURL") as? String)!), placeholderImage: UIImage(named: "default-song-loading"))
        musicName?.text = musicDict?.object(forKey: "musicName") as? String ?? ""
        musicDescription?.text = musicDict?.object(forKey: "musicDescription") as? String ?? ""
        if let preview = musicDict?.object(forKey: "previewMp3") {
            print(preview)
            if preview as! String == "" {
                previewBtn?.isHidden = true
            } else {
                previewBtn?.isHidden = false
            }
        } else {
            previewBtn?.isHidden = true
        }
        
        if musicDict?.object(forKey: "musicNew") != nil
        {
            if musicDict?.object(forKey: "musicNew") is String
            {
                if musicDict?.object(forKey: "musicNew") as! String == "1"
                {
                    newImage?.isHidden = false
                }
                else
                {
                    newImage?.isHidden = true
                }
            }
            else
            {
                if musicDict?.object(forKey: "musicNew") as! Int == 1
                {
                    newImage?.isHidden = false
                }
                else
                {
                    newImage?.isHidden = true
                }
            }
        }
        else
        {
            newImage?.isHidden = true
        }
        
        if musicDict?.object(forKey: "musicPremium") != nil
        {
            if musicDict?.object(forKey: "musicPremium") is String
            {
                if musicDict?.object(forKey: "musicPremium") as? String == "1"
                {
                    freeImage?.isHidden = true
                    if let isPurchase = UserDefaults.standard.object(forKey: "isMusicPurchase"), isPurchase as! String == "yes" {
                        if selectedArray.object(at: indexPath.row) as? String == "no"
                        {
                            premiumBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                        }
                        else
                        {
                            premiumBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                        }
                    } else {
                        premiumBtn?.isHidden = false
                        premiumBtn?.setImage(UIImage(named: "padlock"), for: .normal)
                    }
                }
                else
                {
                    freeImage?.isHidden = false
                    if selectedArray.object(at: indexPath.row) as? String == "no"
                    {
                        premiumBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                    }
                    else
                    {
                        premiumBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                    }
                    premiumBtn?.isHidden = false
                }
            }
            else
            {
                if musicDict?.object(forKey: "musicPremium") as? Int == 1
                {
                    freeImage?.isHidden = true
                    if let isPurchase = UserDefaults.standard.object(forKey: "isMusicPurchase"), isPurchase as! String == "yes" {
                        if selectedArray.object(at: indexPath.row) as? String == "no"
                        {
                            premiumBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                        }
                        else
                        {
                            premiumBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                        }
                    } else {
                        premiumBtn?.isHidden = false
                        premiumBtn?.setImage(UIImage(named: "padlock"), for: .normal)
                    }
                }
                else
                {
                    freeImage?.isHidden = false
                    if selectedArray.object(at: indexPath.row) as? String == "no"
                    {
                        premiumBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
                    }
                    else
                    {
                        premiumBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
                    }
                    premiumBtn?.isHidden = false
                }
            }
        }
        else
        {
            if selectedArray.object(at: indexPath.row) as? String == "no"
            {
                premiumBtn?.setImage(UIImage(named: "heart-Pink-2"), for: .normal)
            }
            else
            {
                premiumBtn?.setImage(UIImage(named: "heart-white 2"), for: .normal)
            }
            premiumBtn?.isHidden = false
        }

        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tempDict = songMusicList.object(at: indexPath.row) as! NSDictionary
        delegateMusicTap?.didMusicSelectItem(musicDict: tempDict, indexPath: indexPath.row)
        // print(recommandCellArray?[indexPath.row].productID ?? "")
    }
    
}

extension MusicListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let size = collectionViewLayout.frame.size
  
        return CGSize(width:collectionView_Ctrl.bounds.width/1.55, height: collectionView_Ctrl.bounds.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

