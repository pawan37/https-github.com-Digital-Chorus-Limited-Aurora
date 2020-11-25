//
//  PurchasePopViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 28/08/20.
//

import UIKit

class PurchasePopViewController: UIViewController {

    @IBOutlet var mainView_Ctrl: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.mainView_Ctrl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(PurchasePopViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        mainView_Ctrl.addGestureRecognizer(tapGesture)
        mainView_Ctrl.isUserInteractionEnabled = true
        
        popUpView?.layer.cornerRadius = 30
        continueBtn.layer.cornerRadius = 18


        // Do any additional setup after loading the view.
    }
    
    func showAnimate()
        
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations:
            {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer)
        
    {
        removeAnimate()
    }
    
    func removeAnimate()
        
    {
        UIView.animate(withDuration: 0.0, animations:
            {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    

    

}
