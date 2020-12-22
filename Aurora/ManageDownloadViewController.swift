//
//  ManageDownloadViewController.swift
//  Aurora
//
//  Created by Augurs iOS  on 12/12/20.
//

import UIKit

class ManageDownloadViewController: UIViewController {
    @IBOutlet weak var tableview_Ctrl: UITableView!
    @IBOutlet weak var bgView_Ctrl: UIView!
    @IBOutlet weak var videoBg_Ctrl: UIView!
    
    var downloadArray : NSMutableArray = []
    var db:DBHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgView_Ctrl.layer.cornerRadius = 30
        bgView_Ctrl.layer.maskedCorners = [.layerMinXMinYCorner]
        self.downloadArray = self.db.getdownload()
        print(downloadArray)
        if downloadArray.count == 0
        {
            supportingfuction.showMessageHudWithMessage("No music is downloaded" as NSString,delay: 2.0)
        }
        
    }
    
    @IBAction func backBtn_Action(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteSongBtnAction(_ sender: UIButton) {
        let pointInTable: CGPoint = sender.convert(sender.bounds.origin, to: self.tableview_Ctrl)
        let cellIndexPath = self.tableview_Ctrl.indexPathForRow(at: pointInTable)!
        deleteAction(indexPath: cellIndexPath)
    }
    
}

extension ManageDownloadViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Setting")
        let title = cell.viewWithTag(1) as? UILabel
        let size = cell.viewWithTag(2) as? UILabel
        let delete = cell.viewWithTag(3) as? UIButton
        delete?.layer.cornerRadius = 5.0
        delete?.clipsToBounds = true
        let downloadDict = downloadArray.object(at: indexPath.row) as? NSDictionary
        title?.text = downloadDict?.object(forKey: "musicName") as? String
        size?.text = ((downloadDict?.object(forKey: "size") as? String)!) + "mb"
        //  title?.text = songList[indexPath.row].name
        // size?.text = songList[indexPath.row].size
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
    //            self.deleteAction(indexPath: indexPath)
    //        }
    //        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    //        return [delete]
    //    }
    
    func deleteAction(indexPath: IndexPath) {
        let tempDict = downloadArray.object(at: indexPath.row) as? NSDictionary
        self.tableview_Ctrl.beginUpdates()
        self.downloadArray.removeObject(at: indexPath.row)
        self.db.deleteDownloadbyID(id: (tempDict?.object(forKey: "musicID") as? String)!)
        let compositionArray = self.db.getCompositionbyMusicId(Id: (tempDict?.object(forKey: "musicID") as! String))
        print(compositionArray)
        for i in 0..<compositionArray.count
        {
            let tempDict = compositionArray.object(at: i) as! NSDictionary
            if let audioUrl = URL(string: tempDict.object(forKey: "instrumentAudioURL") as! String) {
                // then lets create your document folder url
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                // lets create your destination file url
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                print(destinationUrl)
                
                // to check if it exists before downloading it
                if FileManager.default.fileExists(atPath: destinationUrl.path) {
                    print("The file already exists at path")
                    do {
                        try FileManager.default.removeItem(at: destinationUrl)
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                } else {
                    print("file doesn't exist")
                }
            }
        }
        //  self.songList.remove(at: indexPath.row)
        self.tableview_Ctrl.deleteRows(at: [indexPath], with: .automatic)
        self.tableview_Ctrl.endUpdates()
    }
}




