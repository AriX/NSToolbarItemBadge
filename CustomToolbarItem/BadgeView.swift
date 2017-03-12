//
//  BadgeView.swift
//  CustomToolbarItem
//
//  Created by Ari on 3/11/17.
//  Copyright © 2017 CustomToolbarItem. All rights reserved.
//

import Cocoa

class BadgeView: NSView {
    
    var badgeValue: String
    var badgeFontName: String
    var badgeTextColor: NSColor
    
    var badgeFillColor: NSColor
    
    override init(frame: NSRect) {
        self.badgeValue = "0"
        self.badgeFillColor = NSColor.red
        self.badgeTextColor = NSColor.white
        self.badgeFontName = "Helvetica-Bold"
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let context = NSGraphicsContext.current()?.cgContext else { return }

        let locations: [CGFloat] = [1.0, 0.5, 0.0]
        let colors = [self.badgeFillColor.cgColor]
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let gradient: CGGradient? = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let paragraphStyle = NSMutableParagraphStyle.default()
        
        context.saveGState()
        context.setAllowsFontSmoothing(true)
        context.setAllowsAntialiasing(true)
        context.setAllowsFontSubpixelQuantization(true)
        context.setAllowsFontSubpixelPositioning(true)
        context.setBlendMode(CGBlendMode.copy)
        
        let size = dirtyRect.size
        var imageRect = NSMakeRect(0, 0, size.width, size.height)
        
        let iconsize = size.width * 0.5
        let lineWidth = max(1, iconsize * 0.11)
        let pointSize = iconsize - (lineWidth * 2.0)
        var radius = iconsize * 0.5
        
        // Draw at top right corner
        let position = (size.width) - CGFloat(iconsize)
        let indent: NSPoint = NSMakePoint(position, position)
        var rect: NSRect = NSMakeRect(indent.x, indent.y, CGFloat(iconsize), CGFloat(iconsize))
        
        // work out the area
        let font = NSFont(name: self.badgeFontName, size: CGFloat(pointSize))
        
        // color the text
        var attr: [AnyHashable: Any]? = nil
        attr = [NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: font!, NSForegroundColorAttributeName: self.badgeTextColor]
        
        let textSize: NSRect = self.badgeValue.boundingRect(with: NSZeroSize, options: .usesFontLeading, attributes: attr as! [String : Any]?)
        if (textSize.size.width + CGFloat(lineWidth*4) >= rect.size.width) {
            let maxWidth = size.width - CGFloat(lineWidth * 2)
            let width = min(textSize.size.width + (lineWidth * 4), maxWidth)
            
            rect.origin.x -= (width - rect.size.width)
            rect.size.width = width
            
            let newRadius = radius - (radius * (width - rect.size.width) / (maxWidth - rect.size.width))
            radius = max(iconsize * 0.4, newRadius)
        }
        
        let startPoint = CGPoint(x: CGFloat(rect.midX), y: CGFloat(rect.minY))
        let endPoint = CGPoint(x: CGFloat(rect.midX), y: CGFloat(rect.maxY))
        
        // Draw the ellipse
        let minx: CGFloat = rect.minX
        let midx: CGFloat = rect.midX
        let maxx: CGFloat = rect.maxX
        let miny: CGFloat = rect.minY
        let midy: CGFloat = rect.midY
        let maxy: CGFloat = rect.maxY
        
        // Draw the gradiant
//        context.saveGState()
        context.beginPath()
        context.move(to: CGPoint(x: minx, y: midy))
        context.addArc(tangent1End: CGPoint(x: minx, y: miny), tangent2End: CGPoint(x: midx, y: miny), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: midy), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: CGFloat(radius))
        context.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: midy), radius: CGFloat(radius))
        context.closePath()
        context.clip()
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        
        
        // Draw the text
        let textBounds: NSRect = self.badgeValue.boundingRect(with: NSZeroSize, options: .usesDeviceMetrics, attributes: attr as! [String : Any]?)
        rect.origin.x = rect.midX - (textSize.size.width * 0.5)
        rect.origin.x -= (textBounds.size.width - textSize.size.width) * 0.5
        rect.origin.y = rect.midY
        rect.origin.y -= textBounds.origin.y
        rect.origin.y -= ((textBounds.size.height - textSize.origin.y) * 0.5)
        rect.size.height = textSize.size.height
        rect.size.width = textSize.size.width
        self.badgeValue.draw(in: rect, withAttributes: attr as! [String : Any]?)
        context.restoreGState()
    }
    
}
