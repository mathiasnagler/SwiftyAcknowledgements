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
    
    /// The font size used for displaying the acknowledgement's text
    public var fontSize: CGFloat = UIFontDescriptor.preferredFontSizeWithTextStyle(UIFontTextStyleBody) {
        didSet {
            textView.font = UIFont.systemFontOfSize(fontSize)
        }
    }
    
    /// The Acknowledgement instance that is displayed by the ViewController.
    public let acknowledgement: Acknowledgement
    
    /// The textView used for displaying the acknowledgement's text
    public private(set) lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRectZero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.alwaysBounceVertical   = true
        textView.font                   = UIFont.systemFontOfSize(self.fontSize)
        textView.textContainerInset     = UIEdgeInsetsMake(12, 10, 12, 10)
        textView.userInteractionEnabled = true
        
        #if os(iOS)
            textView.editable           = false
            textView.dataDetectorTypes  = .Link
        #endif

        #if os(tvOS)
            textView.selectable = true
            textView.panGestureRecognizer.allowedTouchTypes = [UITouchType.Indirect.rawValue]
        #endif
        
        return textView
    }()

    #if os(tvOS)
        private var gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor,
                UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
            gradientLayer.locations = [0, 0.06, 1, 1]
            return gradientLayer
        }()
    #endif
    
    override public var preferredFocusedView: UIView? {
        return textView
    }
    
    // MARK: Initialization
    
    /// Initializes a new AcknowledgementViewController instance and configures it using the given acknowledgement.
    /// - Parameter acknowledgement: The acknowledgement that the viewController should display
    /// - Returns: A newly initialized AcknowledgementViewController instance configured with the acknowledgements title and text.
    public required init(acknowledgement: Acknowledgement) {
        self.acknowledgement = acknowledgement
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented, use init(acknowledgement:) instead.")
    }
    
    // MARK: UIViewController Overrides
    
    public override func viewDidLoad() {
        view.addSubview(textView)
        
        #if os(tvOS)
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.7, constant: 0))
        #else
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
        #endif
            
        textView.text = acknowledgement.text
        title = acknowledgement.title
        textView.contentOffset = CGPointZero
        
        #if os(tvOS)
            textView.superview?.layer.mask = gradientLayer
        #endif

        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        #if os(tvOS)
            gradientLayer.frame = textView.frame
        #endif
        
        super.viewDidLayoutSubviews()
    }
    
}
