//
//  NSBadgedToolbarItem.swift
//  CustomToolbarItem
//
//  Created by Marco Chiang on 3/10/17.
//  Copyright © 2017 CustomToolbarItem. All rights reserved.
//

import Cocoa
import CoreGraphics

class NSToolbarBadgedItem: NSToolbarItem {
    override func validate() {
        self.isEnabled = true
    }
    
    override func awakeFromNib() {
        if self.responds(to: #selector(self.awakeFromNib)) {
            super.awakeFromNib()
        }
        
        guard let view = self.view else { return }
        
        let badgeView = BadgeView(frame: view.bounds)
        view.addSubview(badgeView)
        
    }
}
