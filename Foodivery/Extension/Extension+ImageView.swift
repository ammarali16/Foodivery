//
//  HomeViewController.swift
//  Islamic Center App
//
//  Created by Ammar on 11/28/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//

import SDWebImage

#if os(iOS) || os(tvOS)
    import UIKit
    
    
    // MARK: - Methods
    public extension UIImageView {
        
        /// SwifterSwift: Set image from a URL.
        ///
        /// - Parameters:
        ///   - url: URL of image.
        ///   - contentMode: imageView content mode (default is .scaleAspectFit).
        ///   - placeHolder: optional placeholder image
        ///   - completionHandler: optional completion handler to run when download finishs (default is nil).
        public func download(from url: URL,
                             contentMode: UIViewContentMode = .scaleAspectFit,
                             placeholder: UIImage? = nil,
                             completionHandler: ((UIImage?) -> Void)? = nil) {
            
            image = placeholder
            self.contentMode = contentMode
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data,
                    let image = UIImage(data: data)
                    else {
                        completionHandler?(nil)
                        return
                }
                DispatchQueue.main.async() { () -> Void in
                    self.image = image
                    completionHandler?(image)
                }
                }.resume()
        }
        
        /// SwifterSwift: Make image view blurry
        ///
        /// - Parameter style: UIBlurEffectStyle (default is .light).
        public func blur(withStyle style: UIBlurEffectStyle = .light) {
            let blurEffect = UIBlurEffect(style: style)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
            addSubview(blurEffectView)
            clipsToBounds = true
        }
        
        /// SwifterSwift: Blurred version of an image view
        ///
        /// - Parameter style: UIBlurEffectStyle (default is .light).
        /// - Returns: blurred version of self.
        public func blurred(withStyle style: UIBlurEffectStyle = .light) -> UIImageView {
            let imgView = self
            imgView.blur(withStyle: style)
            return imgView
        }
        
        
        public func setOverlay(withColor color: UIColor) {
            self.image = self.image!.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
        
        public func setImage(urlString: String?, placeHoder: UIImage, scaleWidth: CGFloat? = nil){
            guard let urlStr = urlString else { return }
            if urlStr.length > 0 {
                if let url = URL.init(string: urlStr) {
                    let block: SDExternalCompletionBlock = {(image, error,
                        cacheType, imageURL) -> Void in
                        if let img = image {
                            if scaleWidth != nil {
                                self.image = img.scaled(toWidth: scaleWidth!)
                            }else{
                                self.image = img.scaled(toWidth: self.frame.size.width * 2)
                            }
                        }else{
                            self.image = placeHoder
                        }
                    }
                    self.sd_setImage(with: url, completed: block)
                }else{
                    self.image = placeHoder
                }
            }else{
                self.image = placeHoder
            }
        }
        /// Sets the image property of the view based on initial text, a specified background color, custom text attributes, and a circular clipping
        ///
        /// - Parameters:
        ///   - string: The string used to generate the initials. This should be a user's full name if available.
        ///   - color: This optional paramter sets the background of the image. By default, a random color will be generated.
        ///   - circular: This boolean will determine if the image view will be clipped to a circular shape.
        ///   - textAttributes: This dictionary allows you to specify font, text color, shadow properties, etc.
        
        
        private func imageSnap(text: String?,
                               color: UIColor,
                               circular: Bool,
                               textAttributes: [NSAttributedStringKey: Any]?) -> UIImage? {
            
            let scale = Float(UIScreen.main.scale)
            var size = bounds.size
            if contentMode == .scaleToFill || contentMode == .scaleAspectFill || contentMode == .scaleAspectFit || contentMode == .redraw {
                size.width = CGFloat(floorf((Float(size.width) * scale) / scale))
                size.height = CGFloat(floorf((Float(size.height) * scale) / scale))
            }
            
            UIGraphicsBeginImageContextWithOptions(size, false, CGFloat(scale))
            let context = UIGraphicsGetCurrentContext()
            if circular {
                let path = CGPath(ellipseIn: bounds, transform: nil)
                context?.addPath(path)
                context?.clip()
            }
            
            // Fill
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            // Text
            if let text = text {
                let attributes = textAttributes ?? [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                    NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0)]
                
                let textSize = text.size(withAttributes: attributes)
                let bounds = self.bounds
                let rect = CGRect(x: bounds.size.width/2 - textSize.width/2, y: bounds.size.height/2 - textSize.height/2, width: textSize.width, height: textSize.height)
                
                text.draw(in: rect, withAttributes: attributes)
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
    }
#endif
