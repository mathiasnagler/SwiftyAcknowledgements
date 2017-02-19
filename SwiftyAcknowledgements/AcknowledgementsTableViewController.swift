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
            headerView.text = headerText
            updateHeaderFooterViews()
        }
    }
    
    /// The text to be displayed in the **UITableView**'s **tableFooter**, if any.
    @IBInspectable public var footerText: String? {
        didSet {
            footerView.text = footerText
            updateHeaderFooterViews()
        }
    }
    
    /// The font size to be used for the **UITableView**'s **tableHeader**. Defaults to the size of **UIFontTextStyleSubheadline**
    @IBInspectable public var headerFontSize: CGFloat = UIFontDescriptor.preferredFontSize(withTextStyle: UIFontTextStyle.subheadline.rawValue) {
        didSet {
            headerView.fontSize = headerFontSize
            updateHeaderFooterViews()
        }
    }
    
    /// The font size to be used for the **UITableView**'s **tableFooter**. Defaults to the size of **UIFontTextStyleSubheadline**
    @IBInspectable public var footerFontSize: CGFloat = UIFontDescriptor.preferredFontSize(withTextStyle: UIFontTextStyle.subheadline.rawValue) {
        didSet {
            footerView.fontSize = footerFontSize
            updateHeaderFooterViews()
        }
    }
    
    /// The font size to be used for the **UITableView**'s cells. Defaults to the size of **UIFontTextStyleBody**
    @IBInspectable public var detailFontSize: CGFloat = UIFontDescriptor.preferredFontSize(withTextStyle: UIFontTextStyle.body.rawValue)

    /// The name of the plist containing the acknowledgements, defaults to **Acknowledgements**.
    @IBInspectable public var acknowledgementsPlistName = "Acknowledgements"
    
    private lazy var _acknowledgements: [Acknowledgement] = {
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
    public var acknowledgements: [Acknowledgement] {
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
    public var sortingClosure: SortingClosure? = { (left, right) in
        var comparsion = left.title.compare(right.title)
        return comparsion == .orderedAscending
    } {
        didSet {
            if let sortingClosure = sortingClosure {
                _acknowledgements = _acknowledgements.sorted(by: sortingClosure)
            }
        }
    }
    
    private lazy var headerView: HeaderFooterView = {
        let headerView = HeaderFooterView()
        headerView.fontSize = self.headerFontSize
        return headerView
    }()
    
    private lazy var footerView: HeaderFooterView = {
        let footerView = HeaderFooterView()
        footerView.fontSize = self.footerFontSize
        return footerView
    }()
    
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        
        headerView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        tableView.tableHeaderView = headerView
        footerView.bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: 50)
        tableView.tableFooterView = footerView
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        if title == nil {
            title = "Acknowledgements"
        }
        
        super.viewWillAppear(animated)
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateHeaderFooterViews(forWidth: size.width)
    }
    
    // MARK: UITableViewDataSource
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseId, for: indexPath)
        cell.textLabel?.text = acknowledgements[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgements.count
    }
    
    // MARK: UITableViewDelegate
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = AcknowledgementViewController(acknowledgement: acknowledgements[indexPath.row])
        detailViewController.fontSize = detailFontSize
        show(detailViewController, sender: self)
    }
    
    // MARK: Private methods
    
    private func updateHeaderFooterViews() {
        updateHeaderFooterViews(forWidth: view.bounds.width)
    }
    
    private func updateHeaderFooterViews(forWidth width: CGFloat) {
        let headerWidthConstraint = NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        headerWidthConstraint.priority = 999
        headerWidthConstraint.isActive = true
        let headerHeight = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        headerWidthConstraint.isActive = false
        headerView.frame = CGRect(x: 0, y: 0, width: width, height: headerHeight)
        tableView.tableHeaderView = headerView
        
        let footerWidthConstraint = NSLayoutConstraint(item: footerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        footerWidthConstraint.priority = 999
        footerWidthConstraint.isActive = true
        let footerHeight = footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        footerWidthConstraint.isActive = false
        footerView.frame = CGRect(x: 0, y: 0, width: width, height: footerHeight)
        tableView.tableFooterView = footerView
    }

}

private extension UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
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
    
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    private lazy var label: UILabel = {
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
    
    private func commonInit() {
        addSubview(label)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: label, attribute: .leading, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: -16))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .bottom, multiplier: 1, constant: 16))
    }
    
}
