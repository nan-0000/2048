//
//  ViewController.swift
//  2048
//
//  Created by nan_macos on 2020/11/20.
//  Copyright © 2020 nan_macos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func setupGame(_ sender: UIButton) {
        let game = GameInitController(dimension: 4 , threshold: 2048)
        self.present(game, animated: true , completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
       // self.navigationController?.navigationBar.isTranslucent = true; 
//        let label=UILabel(frame: CGRect(x: 50, y: 50, width: 100, height: 30))
//        print("set label")
//        label.text="hello world"
//        label.textColor=UIColor.red
 //       self.view.addSubview(label)
        // Do any additional setup after loading the view.
    }


}

