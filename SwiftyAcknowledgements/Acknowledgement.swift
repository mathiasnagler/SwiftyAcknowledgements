//
//  Acknowledgement.swift
//  SwiftyAcknowledgements
//
//  Created by Mathias Nagler on 08.09.15.
//  Copyright © 2015 Mathias Nagler. All rights reserved.
//

import Foundation

public struct Acknowledgement: Equatable {
    
    // MARK: Properties
    
    public let title: String
    public let text: String
    
    // MARK: Initialization
    
    /// Initializes a new Acknowledgement instance with the given title and text
    public init(title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    // MARK: Loading Acknowledgement from Plist
    
    /**
    Loads a plist at a given path and initializes an Acknowledgement instance for every
    element of the plist. The plist's top level element has to be an array and every
    element in the array should be a dictionary with the two keys **title** and **text**.
    If the plist is not in the correct format an empty array will be returned.
    - Returns: An array of Acknowledgements.
    */
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

// MARK: - Equatable

public func ==(lhs: Acknowledgement, rhs: Acknowledgement) -> Bool {
    return ((lhs.title == rhs.title) && (lhs.text == rhs.text))
}