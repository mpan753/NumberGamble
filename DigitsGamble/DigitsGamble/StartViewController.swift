//
//  StartViewController.swift
//  DigitsGamble
//
//  Created by Mia on 19/12/2017.
//  Copyright © 2017 Mia. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        racBind()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var userA: UIButton!

    @IBOutlet weak var userB: UIButton!

    @IBOutlet weak var start: UIButton!
    
    func racBind() {
        userA.rx.tap.debug
    }

}
