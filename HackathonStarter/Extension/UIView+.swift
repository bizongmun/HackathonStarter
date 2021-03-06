//
//  UIView+.swift
//  HackathonStarter
//
//  Created by 田中　達也 on 2016/06/30.
//  Copyright © 2016年 tattn. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }

    func screenShot(width width: CGFloat) -> UIImage? {
        let imageBounds = CGRect(x: 0, y: 0, width: width, height: bounds.size.height * (width / bounds.size.width))

        UIGraphicsBeginImageContextWithOptions(imageBounds.size, true, 0)

        drawViewHierarchyInRect(imageBounds, afterScreenUpdates: true)

        var image: UIImage?
        let contextImage = UIGraphicsGetImageFromCurrentImageContext()

        if let cgImage = contextImage.CGImage {
            image = UIImage(
                CGImage: cgImage,
                scale: UIScreen.mainScreen().scale,
                orientation: contextImage.imageOrientation
            )
        }

        UIGraphicsEndImageContext()

        return image
    }

}
