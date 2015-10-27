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
    
    /// The Acknowledgement instance that is displayed by the ViewController.
    public let acknowledgement: Acknowledgement
    
    /// The ViewController's view
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
        textView.textContainerInset     = UIEdgeInsetsMake(12, 10, 12, 10)
        
        #if os(iOS)
            textView.editable           = false
            textView.dataDetectorTypes  = .Link
        #endif
        
        self.view       = textView
        self.textView   = textView
    }
    
    public override func viewDidLoad() {
        title = acknowledgement.title
        textView.contentOffset = CGPointZero

        super.viewDidLoad()
    }
    
}
