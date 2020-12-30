//
//  PurchasePopViewController.swift
//  Aurora
//
//  Created by Augurs Technologies Pvt Ltd on 28/08/20.
//

import UIKit
import StoreKit

class PurchasePopViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet var mainView_Ctrl: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var purchaseDetail_popViewCtrl: UIView!
    
    var tapGesture = UITapGestureRecognizer()
    let product_id: NSString = "com_augurs_aurora_songs" //product id
    var item = SKProduct()
    var isPurchaseClicked : Bool = true
    //    £9.99 / year
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView_Ctrl.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(PurchasePopViewController.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        mainView_Ctrl.addGestureRecognizer(tapGesture)
        mainView_Ctrl.isUserInteractionEnabled = true
        //descriptionLabel.text = "asdfgasfdgfgfdfg \r\n sdffdsgdgf \r\n asdfggasdfdgfg"
        
        popUpView?.layer.cornerRadius = 30
        continueBtn.layer.cornerRadius = 18
        
        purchaseDetail_popViewCtrl?.layer.cornerRadius = 30
        
        // IAP setup
        SKPaymentQueue.default().add(self)
        sendRequest()
        //        SandBox: “https://sandbox.itunes.apple.com/verifyReceipt”
        //        iTunes Store : “https://buy.itunes.apple.com/verifyReceipt”
        //        receiptValidation()
    }
    override func viewWillAppear(_ animated: Bool) {
//        if let price = UserDefaults.standard.object(forKey: "isMusicPrice") {
//            priceLabel.text =  "£\(price) / year"
//        } else {
//            priceLabel.text =  "£0 / year"
//        }
        if let isMusicDesc = UserDefaults.standard.object(forKey: "isMusicDesc") {
            let replaced1 = (isMusicDesc as! String).replacingOccurrences(of: "\n", with: "\r\n")
            //let replaced2 = replaced1.replacingOccurrences(of: "\r\n\r\n", with: "\r\n")
            descriptionLabel.text = replaced1
        } else {
            descriptionLabel.text = ""
        }
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
    
    func removeAnimate() {
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
    
    @IBAction func continueBtnAction(_ sender: Any) {
        isPurchaseClicked = false
        sendRequest()
    }
    
    func sendRequest()
    {
        MBProgressHUD.showAdded(to: view, animated: true)
        if SKPaymentQueue.canMakePayments() {
            let productID:NSSet = NSSet(array: [self.product_id as NSString]);
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            productsRequest.delegate = self
            productsRequest.start()
            print("Fetching Products")
        } else {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view.window, animated: true)
            }
            print("can't make purchases")
        }
    }
    @IBAction func restorePurchaseBtnAction(_ sender: Any) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    @IBAction func subscriptionDetail_Action(_ sender: Any)
    {
        purchaseDetail_popViewCtrl.isHidden = false
        popUpView.isHidden = true
    }
    
    
    @IBAction func closeBtn_Action(_ sender: Any)
    {
        purchaseDetail_popViewCtrl.isHidden = true
        popUpView.isHidden = false
    }
    
    @IBAction func term_Action(_ sender: Any)
    {
        guard let url = URL(string: "https://www.aurorasleepmusic.com/app-terms") else { return }
        UIApplication.shared.open(url)
    }
    
    func buyProduct(product: SKProduct) {
        isPurchaseClicked = true
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
        let count: Int = response.products.count
        if count > 0 {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id as String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                print(validProduct)
                if isPurchaseClicked == true
                {
                    let numberFormatter = NumberFormatter()
                    numberFormatter.formatterBehavior = .behavior10_4
                    numberFormatter.numberStyle = .currency
                    numberFormatter.locale = validProduct.priceLocale
                    let price1Str = numberFormatter.string(from: validProduct.price)!
                  //  let tempString = String(format: "%.2f", price1Str)
                    
                    DispatchQueue.main.async {
                        self.priceLabel.text =  price1Str + " / year"
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
                else
                {
                  self.buyProduct(product: validProduct)
                }
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view.window, animated: true)
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                self.continueBtn.isEnabled = true
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    // Save this value
                    UserDefaults.standard.set("yes", forKey: "isMusicPurchase")
                    NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil, userInfo: nil)
                    //Do unlocking etc stuff here in case of new purchase
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view.window, animated: true)
                    }
                    removeAnimate()
                    break;
                case .failed:
                    print("Purchased Failed");
                    print(trans.transactionState)
                    
                    let alert = UIAlertController(title: "Aurora", message: "Payment failed", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction!) in
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    //   NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil, userInfo: nil)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view.window, animated: true)
                    }
                    removeAnimate()
                    
                    break;
                case .restored:
                    print("Already Purchased")
                    UserDefaults.standard.set("yes", forKey: "isMusicPurchase")
                    NotificationCenter.default.post(name: Notification.Name("refreshTableView"), object: nil, userInfo: nil)
                    
                    //Do unlocking etc stuff here in case of restor
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view.window, animated: true)
                    }
                    removeAnimate()
                default:
                    break;
                }
            }
        }
    }
    
    //If an error occurs, the code will go to this function
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        // Show some alert
        print("Error: ", error)
        supportingfuction.showMessageHudWithMessage(error.localizedDescription as NSString,delay: 2.0)
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view.window, animated: true)
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue)
        
    {
        for transact:SKPaymentTransaction in queue.transactions {
            if transact.transactionState == SKPaymentTransactionState.restored {
                let t: SKPaymentTransaction = transact as SKPaymentTransaction
                let prodID = t.payment.productIdentifier as String
                print(t)
                print(prodID)
                //restore prodID
                SKPaymentQueue .default().finishTransaction(transact)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    //        func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error)
    //
    //        {
    //            print(error)
    //            for transaction:SKPaymentTransaction  in queue.transactions {
    //                if transaction.transactionState == SKPaymentTransactionState.restored {
    //                    SKPaymentQueue.default().finishTransaction(transaction)
    //                    MBProgressHUD.hide(for: self.view, animated: true)
    //                    break
    //                }
    //            }
    //            MBProgressHUD.hide(for: self.view, animated: true)
    //        }
    
}


