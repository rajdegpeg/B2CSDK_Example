//
//  ViewController.swift
//  B2CSDK_Example
//
//  Created by Raj Kadam on 22/06/22.
//

import UIKit
import B2CSDK
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func actionDegpegSDKDemo(_ sender: UIButton) {
        print(#function)
        openSDK()
    }

    func openSDK(){
        // 1. app id
        // 2. content publisher Id / content prover id
        // 3. app secret
        let appId = "degpegdegpeg _mediaXuUwyvni"
        let secretKey = "Nnra8P2iGqT2uJFU"
        let manager = DegpegManager.init(appID: appId, secret: secretKey, userId: "6278c4556cb38a7a9c10df6e", userName: "Raj Kadam", influencerID: "6278c4546cb38a7a9c10df6d")
        if let vc = manager.getRootViewController() {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

