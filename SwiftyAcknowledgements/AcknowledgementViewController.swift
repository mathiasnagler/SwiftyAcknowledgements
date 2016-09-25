//
//  AcknowledgementViewController.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright (c) 2015 Mathias Nagler. All rights reserved.
//

import UIKit

open class AcknowledgementViewController: UIViewController {
    
    // MARK: Properties
    
    /// The font size used for displaying the acknowledgement's text
  open var fontSize: CGFloat = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body).pointSize {
        didSet {
            textView.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    /// The Acknowledgement instance that is displayed by the ViewController.
    open let acknowledgement: Acknowledgement
    
    /// The textView used for displaying the acknowledgement's text
    open fileprivate(set) lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.alwaysBounceVertical   = true
        textView.font                   = UIFont.systemFont(ofSize: self.fontSize)
        textView.textContainerInset     = UIEdgeInsetsMake(12, 10, 12, 10)
        textView.isUserInteractionEnabled = true
        
        #if os(iOS)
            textView.isEditable           = false
            textView.dataDetectorTypes  = .link
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
    
    override open var preferredFocusedView: UIView? {
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
    
    open override func viewDidLoad() {
        view.addSubview(textView)
        
        #if os(tvOS)
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 0.7, constant: 0))
        #else
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        #endif
            
        textView.text = acknowledgement.text
        title = acknowledgement.title
        textView.contentOffset = CGPoint.zero
        
        #if os(tvOS)
            textView.superview?.layer.mask = gradientLayer
        #endif

        super.viewDidLoad()
    }
    
    open override func viewDidLayoutSubviews() {
        #if os(tvOS)
            gradientLayer.frame = textView.frame
        #endif
        
        super.viewDidLayoutSubviews()
    }
    
}
