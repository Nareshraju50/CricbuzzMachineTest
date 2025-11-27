//
//  String+Extension.swift
//  CricbuzzTask
//
//  Created by K Naresh on 23/11/25.
//

import Foundation

extension String {
    
    func isNotEmpty() -> Bool {
        return self != "" && self != "N/A"
    }
}
