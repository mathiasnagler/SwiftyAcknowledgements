//
//  AcknowledgementViewController.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright (c) 2015 Mathias Nagler. All rights reserved.
//

import UIKit

internal class AcknowledgementViewController: UIViewController {
    
    // MARK: Properties
    
    /// The font size used for displaying the acknowledgement's text
    internal var fontSize: CGFloat = UIFontDescriptor.preferredFontSize(for: .body) {
        didSet {
            textView.font = .systemFont(ofSize: fontSize)
        }
    }
    
    /// The Acknowledgement instance that is displayed by the ViewController.
    internal let acknowledgement: Acknowledgement
    
    /// The textView used for displaying the acknowledgement's text
    internal private(set) lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.alwaysBounceVertical     = true
        textView.font                     = .systemFont(ofSize: self.fontSize)
        textView.textContainerInset       = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        textView.isUserInteractionEnabled = true
        
        #if os(iOS)
            textView.isEditable         = false
            textView.dataDetectorTypes  = .link
        #endif

        #if os(tvOS)
            textView.isSelectable = true
            textView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        #endif
        
        return textView
    }()

    #if os(tvOS)
        private var gradientLayer: CAGradientLayer = {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor,
                UIColor.black.cgColor, UIColor.clear.cgColor]
            gradientLayer.locations = [0, 0.06, 1, 1]
            return gradientLayer
        }()
    #endif
    
    override internal var preferredFocusedView: UIView? {
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
    
    override func viewDidLoad() {
        view.addSubview(textView)
        
        #if os(tvOS)
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: textView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.7, constant: 0))
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
    
    override func viewDidLayoutSubviews() {
        #if os(tvOS)
            gradientLayer.frame = textView.frame
        #endif
        
        super.viewDidLayoutSubviews()
    }
    
}
