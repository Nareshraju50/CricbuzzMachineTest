//
//  UIViewController+ Ext.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import UIKit

extension UIViewController {
    
    enum StoryBoard: String {
         case main = "Main"
     }
    
    static func instance(_ storyboard: StoryBoard = .main) -> UIViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle(for: self))
        return storyBoard.instantiateViewController(withIdentifier: self.className)
    }
    
    static var className: String {
        get {
            return String(describing: self)
        }
    }
}

