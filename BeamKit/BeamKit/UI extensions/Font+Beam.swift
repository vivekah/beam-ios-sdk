//
//  Font+Beam.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/26/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

internal class FontIdentifiers {
    static let regular: String = "Poppins-Regular"
    static let light: String = "Poppins-Light"
    static let lightItalic: String = "Poppins-LightItalic"
    static let boldItalic: String = "Poppins-BoldItalic"
    static let italic: String = "Poppins-Italic"
    static let medium: String = "Poppins-Medium"
    static let bold: String = "Poppins-Bold"
    static let black: String = "Poppins-Black"
    
    static let blackItalic: String = "Poppins-BlackItalic"
    static let extraLight: String = "Poppins-ExtraLight"
    static let extraLightItalic: String = "Poppins-ExtraLightItalic"
    static let extraBold: String = "Poppins-ExtraBold"
    static let extraBoldItalic: String = "Poppins-ExtraBoldItalic"
    static let thinItalic: String = "Poppins-ThinItalic"
    static let semiBold: String = "Poppins-SemiBold"
    static let thin: String = "Poppins-Thin"
    static let semiBoldItalic: String = "Poppins-SemiBoldItalic"
    static let mediumItalic: String = "Poppins-MediumItalic"
    
    static let headlineDefault = "Poppins-Regular"
    static let headlineBold = "Poppins-Bold"
    static let headlineLight = "Poppins-Light"
}

extension UIFont {
    
    internal class func beamRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.regular , size: size)
    }
    
    internal class func beamMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.medium , size: size)
    }
    
    internal class func beamLight(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.light , size: size)
    }
    
    internal class func beamLightItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.lightItalic, size: size)
    }
    
    internal class func beamItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.italic, size: size)
    }
    
    internal class func beamBold(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.bold , size: size)
    }
    
    internal class func beamSemiBold(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.semiBold , size: size)
    }
    
    internal class func beamBlack(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.black , size: size)
    }
    
    internal class func beamHeadlineDefault(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.headlineDefault , size: size)
    }
    
    internal class func beamHeadlineBold(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.headlineBold , size: size)
    }
    
    internal class func beamHeadlineLight(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.headlineLight , size: size)
    }
    
    internal class func beamBoldItalic(size: CGFloat) -> UIFont? {
        return UIFont(name: FontIdentifiers.boldItalic, size: size)
    }
}

extension UIFont {
    
    // load framework font in application
    public static let loadAllFonts: () = {
        //        registerFontWith(filenameString: "SanFranciscoText-Regular.otf", bundleIdentifierString: "Fonts")
        //TODO implemennt for all needed fonts
    }()
    
    //MARK: - Make custom font bundle register to framework
    static func registerFontWith(filenameString: String, bundleIdentifierString: String) {
        let frameworkBundle = Bundle(for: UIAlertController.self)
        let resourceBundleURL = frameworkBundle.url(forResource: bundleIdentifierString, withExtension: "bundle")
        if let url = resourceBundleURL, let bundle = Bundle(url: url) {
            let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil)
            if let fontData = NSData(contentsOfFile: pathForResourceString!), let dataProvider = CGDataProvider.init(data: fontData) {
                let fontRef = CGFont.init(dataProvider)
                var errorRef: Unmanaged<CFError>? = nil
                if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
                    print("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
                }
            }
        }
        else {
            print("Failed to register font - bundle identifier invalid.")
        }
    }
}
