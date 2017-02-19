//
//  AcknowledgementsTableViewController.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright (c) 2015 Mathias Nagler. All rights reserved.
//

import UIKit

// MARK: - AcknowledgementsTableViewController

open class AcknowledgementsTableViewController: UITableViewController {

    // MARK: Properties
    
    /// The text to be displayed in the **UITableView**'s **tableHeader**, if any.
    @IBInspectable open var headerText: String? {
        didSet {
            tableView.tableHeaderView = newTableHeaderView
        }
    }
    
    /// The text to be displayed in the **UITableView**'s **tableFooter**, if any.
    @IBInspectable open var footerText: String? {
        didSet {
            tableView.tableFooterView = newTableFooterView
        }
    }
    
    /// The font size to be used for the **UITableView**'s **tableHeader**. Defaults to the size of **UIFontTextStyleSubheadline**
    @IBInspectable open var headerFontSize: CGFloat = UIFontDescriptor.preferredFontSizeWithTextStyle(UIFontTextStyle.subheadline.rawValue) {
        didSet {
            tableView.tableHeaderView = newTableHeaderView
        }
    }
    
    /// The font size to be used for the **UITableView**'s **tableFooter**. Defaults to the size of **UIFontTextStyleSubheadline**
    @IBInspectable open var footerFontSize: CGFloat = UIFontDescriptor.preferredFontSizeWithTextStyle(UIFontTextStyle.subheadline.rawValue) {
        didSet {
            tableView.tableFooterView = newTableHeaderView
        }
    }
    
    /// The font size to be used for the **UITableView**'s cells. Defaults to the size of **UIFontTextStyleBody**
    @IBInspectable open var detailFontSize: CGFloat = UIFontDescriptor.preferredFontSizeWithTextStyle(UIFontTextStyle.body.rawValue)

    /// The name of the plist containing the acknowledgements, defaults to **Acknowledgements**.
    @IBInspectable open var acknowledgementsPlistName = "Acknowledgements"
    
    fileprivate lazy var _acknowledgements: [Acknowledgement] = {
        guard let
            acknowledgementsPlistPath = Bundle.main.path(
                forResource: self.acknowledgementsPlistName, ofType: "plist")
        else {
            return [Acknowledgement]()
        }

        return Acknowledgement.acknowledgements(fromPlistAt: acknowledgementsPlistPath)
    }()
    
    /// The acknowledgements that are displayed by the TableViewController. The array is initialized with the contents of the
    /// plist with *acknowledgementPlistName*. To display custom acknowledements add them to the array. The tableView will
    /// reload its contents after any modification to the array.
    open var acknowledgements: [Acknowledgement] {
        set {
            _acknowledgements = sortingClosure != nil ? newValue.sorted(by: sortingClosure!) : newValue
            tableView.reloadData()
        }
        get {
            return _acknowledgements
        }
    }
    
    /// Closure type used for sorting acknowledgements.
    /// - Parameter lhs: acknowledgement *lhs*
    /// - Parameter rhs: acknowledgement *rhs*
    /// - Returns: A boolean indicating wether *lhs* is ordered before *rhs*
    public typealias SortingClosure = ((Acknowledgement, Acknowledgement) -> Bool)
    
    /// A closure used to sort the *acknowledgements* array, defaults to a closure
    /// that sorts alphabetically. The sorting closure can be changed any time and the
    /// *acknowledgements* array will then be re-sorted and afterwards the tableView
    /// will reload its contents.
    open var sortingClosure: SortingClosure? = { (left, right) in
        var comparsion = left.title.compare(right.title)
        return comparsion == .orderedAscending
    } {
        didSet {
            if let sortingClosure = sortingClosure {
                _acknowledgements = _acknowledgements.sorted(by: sortingClosure)
            }
        }
    }
    
    // MARK: Initialization
    
    public init(acknowledgementsPlistPath: String? = nil) {
        super.init(style: .grouped)
    }
    
    override internal init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(style: .grouped)
    }
    
    // MARK: UIViewController overrides
    
    open override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        if title == nil {
            title = "Acknowledgements"
        }
        
        super.viewWillAppear(animated)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        tableView.tableHeaderView = tableView.tableHeaderView
        tableView.tableFooterView = tableView.tableFooterView
    }
    
    // MARK: UITableViewDataSource
    
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        cell.textLabel?.text = acknowledgements[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgements.count
    }
    
    // MARK: UITableViewDelegate
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = AcknowledgementViewController(acknowledgement: acknowledgements[indexPath.row])
        detailViewController.fontSize = detailFontSize
        show(detailViewController, sender: self)
    }
    
    // MARK: TableView Header and Footer
    
    open var newTableHeaderView: UIView? {
        guard let headerText = headerText else {
            return nil
        }
        
        let headerView = HeaderFooterView()
        headerView.label.text = headerText
        headerView.fontSize = headerFontSize
        return headerView
    }
    
    open var newTableFooterView: UIView? {
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
        return String(describing: self).components(separatedBy: ".").last!
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
            label.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
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
    
    fileprivate func commonInit() {
        addSubview(label)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 16))
    }
    
    // MARK: UIView overrides
    
    fileprivate override func didMoveToSuperview() {
        super.didMoveToSuperview()
        resize()
    }
    
    // MARK: Private
    
    fileprivate func resize() {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: superview?.bounds.width ?? 500)
        widthConstraint.isActive = true
        let height = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        removeConstraint(widthConstraint)
        
        translatesAutoresizingMaskIntoConstraints = true
        
        self.bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: height)
    }
    
}
