//
//  AcknowledgementViewController.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright (c) 2015 Mathias Nagler. All rights reserved.
//

import UIKit

public class AcknowledgementViewController: UIViewController {
    
    // MARK: Properties
    
    public let acknowledgement: Acknowledgement
    public private(set) var textView: UITextView!
    
    // MARK: Initialization
    
    public required init(acknowledgement: Acknowledgement) {
        self.acknowledgement = acknowledgement
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(acknowledgement:) instead.")
    }
    
    // MARK: UIViewController Overrides
    
    public override func loadView() {
        let textView = UITextView(frame: CGRectZero)
        textView.alwaysBounceVertical   = true
        textView.font                   = UIFont.systemFontOfSize(17)
        textView.text                   = acknowledgement.text
        textView.editable               = false
        textView.dataDetectorTypes      = .Link
        textView.textContainerInset     = UIEdgeInsetsMake(12, 10, 12, 10)
        
        self.view       = textView
        self.textView   = textView
    }
    

    
}
