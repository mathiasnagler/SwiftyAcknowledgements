//
//  AcknowledgementsTableViewController.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright (c) 2015 Mathias Nagler. All rights reserved.
//

import UIKit

// MARK: - AcknowledgementsTableViewController

public class AcknowledgementsTableViewController: UITableViewController {

    // MARK: Properties
    
    /// The text to be displayed in the **UITableView**'s **tableHeader**, if any.
    @IBInspectable public var headerText: String? {
        didSet {
            tableView.tableHeaderView = newTableHeaderView
        }
    }
    
    /// The text to be displayed in the **UITableView**'s **tableFooter**, if any.
    @IBInspectable public var footerText: String? {
        didSet {
            tableView.tableFooterView = newTableFooterView
        }
    }
    
    @IBInspectable public var headerFontSize: CGFloat = UIFontDescriptor.preferredFontSizeTextStyle(UIFontTextStyleSubheadline) {
        didSet {
            tableView.tableHeaderView = newTableHeaderView
        }
    }
    
    @IBInspectable public var footerFontSize: CGFloat = UIFontDescriptor.preferredFontSizeTextStyle(UIFontTextStyleSubheadline) {
        didSet {
            tableView.tableFooterView = newTableHeaderView
        }
    }
    
    @IBInspectable public var detailFontSize: CGFloat = UIFontDescriptor.preferredFontSizeTextStyle(UIFontTextStyleBody)

    /// The name of the plist containing the acknowledgements, defaults to **Acknowledgements**.
    @IBInspectable public var acknowledgementsPlistName = "Acknowledgements"
    
    private lazy var _acknowledgements: [Acknowledgement] = {
        guard let
            acknowledgementsPlistPath = NSBundle.mainBundle().pathForResource(
                self.acknowledgementsPlistName, ofType: "plist")
        else {
            return [Acknowledgement]()
        }

        return Acknowledgement.acknowledgementsFromPlistAtPath(acknowledgementsPlistPath)
    }()
    
    public var acknowledgements: [Acknowledgement] {
        set {
            _acknowledgements = sortingClosure != nil ? newValue.sort(sortingClosure!) : newValue
            tableView.reloadData()
        }
        get {
            return _acknowledgements
        }
    }
    
    public typealias SortingClosure = ((Acknowledgement, Acknowledgement) -> Bool)
    public var sortingClosure: SortingClosure? = { (left, right) in
        var comparsion = left.title.compare(right.title)
        return comparsion == .OrderedAscending
    } {
        didSet {
            if let sortingClosure = sortingClosure {
                _acknowledgements = _acknowledgements.sort(sortingClosure)
            }
        }
    }
    
    // MARK: Initialization
    
    public init(acknowledgementsPlistPath: String? = nil) {
        super.init(style: .Grouped)
    }
    
    override internal init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(style: .Grouped)
    }
    
    // MARK: UIViewController overrides
    
    public override func viewDidLoad() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(animated: Bool) {
        if title == nil {
            title = "Acknowledgements"
        }
        
        super.viewWillAppear(animated)
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        tableView.tableHeaderView = tableView.tableHeaderView
        tableView.tableFooterView = tableView.tableFooterView
    }
    
    // MARK: UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UITableViewCell.reuseId, forIndexPath: indexPath)
        cell.textLabel?.text = acknowledgements[indexPath.row].title
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgements.count
    }
    
    // MARK: UITableViewDelegate
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = AcknowledgementViewController(acknowledgement: acknowledgements[indexPath.row])
        detailViewController.fontSize = detailFontSize
        showViewController(detailViewController, sender: self)
    }
    
    // MARK: TableView Header and Footer
    
    private var newTableHeaderView: UIView? {
        guard let headerText = headerText else {
            return nil
        }
        
        let headerView = HeaderFooterView()
        headerView.label.text = headerText
        headerView.fontSize = headerFontSize
        return headerView
    }
    
    private var newTableFooterView: UIView? {
        guard let footerText = footerText else {
            return nil
        }
        
        let footerView = HeaderFooterView()
        footerView.label.text = footerText
        footerView.fontSize = footerFontSize
        return footerView
    }

}

private extension UITableViewCell {
    static var reuseId: String {
        return String(self).componentsSeparatedByString(".").last!
    }
}

// MARK: - HeaderFooterView

private class HeaderFooterView: UIView {
    
    // MARK: Properties
    
    var fontSize: CGFloat {
        get {
            return label.font.pointSize
        }
        set {
            label.font = UIFont.systemFontOfSize(newValue)
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.textColor = .grayColor()
        label.font = UIFont.systemFontOfSize(12)
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(label)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: label, attribute: .Leading, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: label, attribute: .Trailing, multiplier: 1, constant: 16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: label, attribute: .Top, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: label, attribute: .Bottom, multiplier: 1, constant: 16))
    }
    
    // MARK: UIView overrides
    
    private override func didMoveToSuperview() {
        super.didMoveToSuperview()
        resize()
    }
    
    // MARK: Private
    
    private func resize() {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: superview?.bounds.width ?? 500)
        widthConstraint.active = true
        let height = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        removeConstraint(widthConstraint)
        
        translatesAutoresizingMaskIntoConstraints = true
        
        self.bounds = CGRectMake(0, 0, self.bounds.width, height)
    }
    
}
