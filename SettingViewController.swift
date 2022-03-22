//
//  SettingViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 25/08/20.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableview_Ctrl: UITableView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var videoBg_Ctrl: UIView!
    var titleArray = ["Feedback","Manage downloads","","Rate us in the App Store"]
    var avPlayer: AVPlayer!
    var avpController = AVPlayerViewController()
    var dynamicPagesArray : NSMutableArray = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getDynamicOption()
       // bgView_Ctrl.layer.cornerRadius = 30
     //   bgView_Ctrl.layer.maskedCorners = [.layerMinXMinYCorner]
    }
    
    @IBAction func downloadSwitch_Action(_ sender: UISwitch)
    {
        if sender.isOn == true
        {
            UserDefaults.standard.setValue("yes", forKey: "wifiOn")
        }
        else
        {
            UserDefaults.standard.setValue("no", forKey: "wifiOn")
        }
    }
    
    @IBAction func backBtn_Action(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getDynamicOption()
    {
        MBProgressHUD.showAdded(to: view, animated: true)
        var baseUrl : String = ""
        baseUrl = Constant.serverURL + "appStaticPages"
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
                        let tempArray = (response.result.value! as! NSDictionary).object(forKey: "appStaticPages") as? NSArray
                        self.dynamicPagesArray = tempArray?.mutableCopy() as! NSMutableArray
                        for i in 0..<tempArray!.count {
                            let tempDict = tempArray?.object(at: i) as! NSDictionary
                            print(tempDict)
                            self.titleArray.append(tempDict.object(forKey: "pageTitle") as? String ?? "")
                        }
                        self.tableview_Ctrl.reloadData()
                    }
                    else
                    {
                        supportingfuction.showMessageHudWithMessage("No Items Found." as NSString,delay: 2.0)
                    }
                }
                else
                {
                     supportingfuction.showMessageHudWithMessage("No Items Found." as NSString,delay: 2.0)
                }
            }
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
            let donloadSwitch = cell.viewWithTag(2) as? UISwitch
            if UserDefaults.standard.object(forKey: "wifiOn") != nil
            {
                if UserDefaults.standard.object(forKey: "wifiOn") as! String == "yes"
                {
                    donloadSwitch?.isOn = true
                }
                else
                {
                    donloadSwitch?.isOn = false
                }
            }
            else
            {
                donloadSwitch?.isOn = true
            }
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
      
        if indexPath.row == 3
        {
            guard let url = URL(string: "https://apps.apple.com/us/app/aurora-sleep-music/id1544762843") else { return }
            UIApplication.shared.open(url)
        }
        else if indexPath.row == 2
        {
            
        }
        else if indexPath.row == 1
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageDownloadViewController") as! ManageDownloadViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 0
        {
          //  guard let url = URL(string: "https://www.getmishi.com/feedback") else { return }
           // UIApplication.shared.open(url)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = "https://www.getmishi.com/feedback"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let tempDict = dynamicPagesArray.object(at: indexPath.row - 4) as? NSDictionary
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            vc.url = tempDict?.object(forKey: "pageUrl") as? String ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


