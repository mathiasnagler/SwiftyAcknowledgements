//
//  Acknowledgement.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import Foundation

public struct Acknowledgement {
    
    // MARK: Properties
    
    public let title: String
    public let text: String
    
    // MARK: Initialization
    
    public init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    // MARK: Loading Acknowledgement from Plist
    
    public static func acknowledgementsFromPlistAtPath(path: String) -> [Acknowledgement] {
        var acknowledgements = [Acknowledgement]()
        
        if let plist = NSArray(contentsOfFile: path) as? Array<Dictionary<String, String>> {
            for dict in plist {
                if let
                    title = dict["title"],
                    text = dict["text"]
                {
                    acknowledgements.append(Acknowledgement(title: title, text: text))
                }
            }
        }
        
        return acknowledgements
    }
    
}