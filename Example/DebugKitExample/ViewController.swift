//
//  ViewController.swift
//  DebugKitExample
//
//  Created by Aaron Sky on 8/19/18.
//

import UIKit
import DebugKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showDebug(_ sender: UIBarButtonItem) {
        let debugVC = DebugViewController()
        show(debugVC, sender: nil)
    }
}

