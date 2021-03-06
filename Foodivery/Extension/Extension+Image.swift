//
//  HomeViewController.swift
//  Islamic Center App
//
//  Created by Ammar on 11/28/17.
//  Copyright © 2017 Mujadidia. All rights reserved.
//
#if !os(macOS)
    import UIKit
    
    // MARK: - Properties
    public extension UIImage {
        
        /// SwifterSwift: Size in bytes of UIImage
        public var bytesSize: Int {
            return UIImageJPEGRepresentation(self, 1)?.count ?? 0
        }
        
        /// SwifterSwift: Size in kilo bytes of UIImage
        public var kilobytesSize: Int {
            return bytesSize / 1024
        }
        
        /// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
        public var original: UIImage {
            return withRenderingMode(.alwaysOriginal)
        }
        
        /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
        public var template: UIImage {
            return withRenderingMode(.alwaysTemplate)
        }
        
    }
    
    
    // MARK: - Methods
    public extension UIImage {
        
        /// SwifterSwift: Compressed UIImage from original UIImage.
        ///
        /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
        /// - Returns: optional UIImage (if applicable).
        public func compressed(quality: CGFloat = 0.5) -> UIImage? {
            guard let data = compressedData(quality: quality) else {
                return nil
            }
            return UIImage(data: data)
        }
        
        /// SwifterSwift: Compressed UIImage data from original UIImage.
        ///
        /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
        /// - Returns: optional Data (if applicable).
        public func compressedData(quality: CGFloat = 0.5) -> Data? {
            return UIImageJPEGRepresentation(self, quality)
        }
        
        /// SwifterSwift: UIImage Cropped to CGRect.
        ///
        /// - Parameter rect: CGRect to crop UIImage to.
        /// - Returns: cropped UIImage
        public func cropped(to rect: CGRect) -> UIImage {
            guard rect.size.height < size.height && rect.size.height < size.height else {
                return self
            }
            guard let image: CGImage = cgImage?.cropping(to: rect) else {
                return self
            }
            return UIImage(cgImage: image)
        }
        
        /// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
        ///
        /// - Parameters:
        ///   - toHeight: new height.
        ///   - orientation: optional UIImage orientation (default is nil).
        /// - Returns: optional scaled UIImage (if applicable).
        public func scaled(toHeight: CGFloat, with orientation: UIImageOrientation? = nil) -> UIImage? {
            let scale = toHeight / size.height
            let newWidth = size.width * scale
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
            draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        
        /// SwifterSwift: UIImage scaled to width with respect to aspect ratio.
        ///
        /// - Parameters:
        ///   - toWidth: new width.
        ///   - orientation: optional UIImage orientation (default is nil).
        /// - Returns: optional scaled UIImage (if applicable).
        public func scaled(toWidth: CGFloat, with orientation: UIImageOrientation? = nil) -> UIImage? {
            let scale = toWidth / size.width
            let newHeight = size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: toWidth, height: newHeight))
            draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        
        /// SwifterSwift: UIImage filled with color
        ///
        /// - Parameter color: color to fill image with.
        /// - Returns: UIImage filled with given color.
        public func filled(withColor color: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.setFill()
            guard let context = UIGraphicsGetCurrentContext() else {
                return self
            }
            
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0);
            context.setBlendMode(CGBlendMode.normal)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            guard let mask = self.cgImage else {
                return self
            }
            context.clip(to: rect, mask: mask)
            context.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        
        
        public func isPortrait() -> Bool {
            if self.size.height > self.size.width {
                return true
            }else{
                return false
            }
        }
                
        public func saveImageInDocumentDirectory(withImageName imgName: String) {
            if let data = UIImageJPEGRepresentation(self, 0.8) {
                let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                let filePath = documentsDirectory.appendingPathComponent(imgName)
                try? data.write(to: filePath)
            }else{
                print("error in converting image")
            }
        }

        public func getOverlayImage(withColor color: UIColor) -> UIImage {
            let image = self.withRenderingMode(.alwaysTemplate)
            return image
        }
        
    }
    
    
    // MARK: - Initializers
    public extension UIImage {
        
        /// SwifterSwift: Create UIImage from color and size.
        ///
        /// - Parameters:
        ///   - color: image fill color.
        ///   - size: image size.
        public convenience init(color: UIColor, size: CGSize) {
            UIGraphicsBeginImageContextWithOptions(size, false, 1)
            color.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
            guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
                self.init()
                return
            }
            UIGraphicsEndImageContext()
            guard let aCgImage = image.cgImage else {
                self.init()
                return
            }
            self.init(cgImage: aCgImage)
        }
        
        public convenience init(view: UIView) {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
            view.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.init(cgImage: image!.cgImage!)
        }
        
    }
#endif
