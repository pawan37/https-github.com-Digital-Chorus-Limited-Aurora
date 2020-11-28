//
//  SettingViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 25/08/20.
//

import UIKit
import AVFoundation
import AVKit

class SettingViewController: UIViewController {

    @IBOutlet weak var tableview_Ctrl: UITableView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var videoBg_Ctrl: UIView!
    let titleArray = ["Feedback","Manage downloads","","Rate us in the App Store","FAQs","Terms and Conditions","About"]
    var avPlayer: AVPlayer!
    var avpController = AVPlayerViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        bgView_Ctrl.layer.cornerRadius = 30
        bgView_Ctrl.layer.maskedCorners = [.layerMinXMinYCorner]
        
//        let moviePath = Bundle.main.path(forResource: "aurora1024", ofType: "mp4")
//        if let path = moviePath {
//            let url = NSURL.fileURL(withPath: path)
//            self.avPlayer = AVPlayer(url: url)
//            self.avpController = AVPlayerViewController()
//            self.avpController.player = self.avPlayer
//            avpController.view.frame = videoBg_Ctrl.frame
//            avpController.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            avpController.showsPlaybackControls = false
//            self.addChild(avpController)
//            self.videoBg_Ctrl.addSubview(avpController.view)
//            self.avPlayer.play()
//        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtn_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SettingViewController : UITableViewDataSource, UITableViewDelegate
    
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        
    {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        let cell : UITableViewCell!
        if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Setting2")
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Setting")
            let title = cell.viewWithTag(1) as? UILabel
            title?.text = titleArray[indexPath.row]
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == 4
        {
            guard let url = URL(string: "https://www.aurorasleepmusic.com/app-faqs") else { return }
            UIApplication.shared.open(url)
        }
        else if indexPath.row == 5
        {
            guard let url = URL(string: "https://www.aurorasleepmusic.com/app-terms") else { return }
            UIApplication.shared.open(url)
        }
        else if indexPath.row == 6
        {
            guard let url = URL(string: "https://www.aurorasleepmusic.com/app-about") else { return }
            UIApplication.shared.open(url)
        }
    }
    
}


