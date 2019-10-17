//
//  HomeViewController.swift
//  Islamic Center App
//
//  Created by Ammar on 11/28/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    
    
    // MARK: - Methods
    public extension UINavigationBar {
        
        
        /// SwifterSwift: Make navigation bar transparent.
        ///
        /// - Parameter tint: tint color (default is .white).
        public func makeTransparent(withTint tint: UIColor = .white) {
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            isTranslucent = true
            tintColor = tint
            titleTextAttributes = [NSAttributedStringKey.foregroundColor: tint]
        }
        
        /// SwifterSwift: Set navigationBar background and text colors
        ///
        /// - Parameters:
        ///   - background: backgound color
        ///   - text: text color
        public func setColors(background: UIColor, text: UIColor) {
            isTranslucent = false
            backgroundColor = background
            barTintColor = background
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            tintColor = text
            titleTextAttributes = [NSAttributedStringKey.foregroundColor: text]
        }
    }
#endif
