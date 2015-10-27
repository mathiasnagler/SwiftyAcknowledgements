//
//  ViewController.swift
//  iOS Example
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import UIKit
import SwiftyAcknowledgements

class ViewController: UIViewController {

    @IBAction func showAcknowledgements() {
        let vc = AcknowledgementsTableViewController()
        vc.headerText = "SwiftyAcknowledgements makes use of the following third party libraries:"
        vc.footerText = "Third party libraries integrated using Carthage:\nhttp://github.com/carthage"
        
        vc.acknowledgements.append(Acknowledgement(title: "Custom Acknowledgement", text: "This is a custom acknowledgement added via code."))
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

