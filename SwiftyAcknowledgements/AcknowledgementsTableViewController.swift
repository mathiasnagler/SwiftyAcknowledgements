//
//  AcknowledgementsTableViewController.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright (c) 2015 Mathias Nagler. All rights reserved.
//

import UIKit

public class AcknowledgementsTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBInspectable public var headerText: String? {
        didSet {
            view.setNeedsLayout()
        }
    }
    
    @IBInspectable public var footerText: String? {
        didSet {
            view.setNeedsLayout()
        }
    }

    private var acknowledgementsPlistPath = NSBundle.mainBundle().pathForResource("Acknowledgements", ofType: "plist")
    
    private lazy var acknowledgements: [Acknowledgement] = {
        guard let acknowledgementsPlistPath = self.acknowledgementsPlistPath else {
            return [Acknowledgement]()
        }

        return Acknowledgement.acknowledgementsFromPlistAtPath(acknowledgementsPlistPath)
    }()
    
    // MARK: - Initialization
    
    public init(acknowledgementsPlistPath: String? = nil) {
        super.init(style: .Plain)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UIViewController
    
    public override func viewDidLoad() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseId)
        
        super.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
//        tableView.tableHeaderView = tableHeaderView
//        tableView.tableFooterView = tableFooterView
        
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - UITableViewDataSource
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UITableViewCell.reuseId, forIndexPath: indexPath)
        cell.textLabel?.text = acknowledgements[indexPath.row].text
        return cell
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgements.count
    }
    
    // MARK: - UITableViewDelegate
    
    public var tableHeaderView: UIView? {
        guard let headerText = headerText else {
            return nil
        }
        
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .Center
        headerLabel.text = headerText
        headerLabel.numberOfLines = 0
        headerLabel.textColor = .grayColor()
        headerLabel.font = UIFont.systemFontOfSize(12)
        
        headerView.addSubview(headerLabel)
        headerView.leadingAnchor.constraintEqualToAnchor(headerLabel.leadingAnchor, constant: -16).active = true
        headerView.trailingAnchor.constraintEqualToAnchor(headerLabel.trailingAnchor, constant: 16).active = true
        headerView.topAnchor.constraintEqualToAnchor(headerLabel.topAnchor, constant: -16).active = true
        headerView.bottomAnchor.constraintEqualToAnchor(headerLabel.bottomAnchor, constant: 16).active = true
        
        let widthConstraint = headerView.widthAnchor.constraintEqualToConstant(tableView.bounds.width)
        widthConstraint.active = true
        let height = headerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        widthConstraint.active = false
        
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        headerView.translatesAutoresizingMaskIntoConstraints = true
        
        return headerView
    }
    
    public var tableFooterView: UIView? {
        guard let footerText = footerText else {
            return nil
        }
        
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        let footerLabel = UILabel()
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.textAlignment = .Center
        footerLabel.text = footerText
        footerLabel.numberOfLines = 0
        footerLabel.textColor = .grayColor()
        footerLabel.font = UIFont.systemFontOfSize(12)
        
        footerView.addSubview(footerLabel)
        footerView.leadingAnchor.constraintEqualToAnchor(footerLabel.leadingAnchor, constant: -16).active = true
        footerView.trailingAnchor.constraintEqualToAnchor(footerLabel.trailingAnchor, constant: 16).active = true
        footerView.topAnchor.constraintEqualToAnchor(footerLabel.topAnchor, constant: -16).active = true
        footerView.bottomAnchor.constraintEqualToAnchor(footerLabel.bottomAnchor, constant: 16).active = true
        
        let widthConstraint = footerView.widthAnchor.constraintEqualToConstant(tableView.bounds.width)
        widthConstraint.active = true
        let height = footerView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        widthConstraint.active = false
        
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        footerView.translatesAutoresizingMaskIntoConstraints = true
        
        return footerView
    }

}

private extension UITableViewCell {
    static var reuseId: String {
        return String(self).componentsSeparatedByString(".").last!
    }
}
