//
//  ProgressBar.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 6/28/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

internal enum BackgroundTintType {
    case color(UIColor)
    case blur
}

internal class GradientProgressBar: UIView {
    var tintType: BackgroundTintType
    var numerator: Float = 0
    var denominator: Float = 0
    
    var rounded: Bool = true {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    private let gradientView: UIView = .init(with: .purple)
    private let rainbowGradient: CAGradientLayer = .progressRainbowGradient
    private let percentFillView: UIView = .init(with: .purple)
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        return blurEffectView
    }()
    
    init(tintType: BackgroundTintType = .color(.beamGray1)) {
        self.tintType = tintType
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rainbowGradient.frame = bounds
        let width: CGFloat = denominator == 0 ? 0 : CGFloat(numerator) / CGFloat(denominator)
        percentFillView.frame = CGRect(x: 0, y: 0, width: width * bounds.width, height: bounds.height)
        if useBlur {
            blurView.frame = bounds
            blurView.layer.cornerRadius = rounded ? blurView.bounds.height / 2 : 0
        }
        
        gradientView.layer.cornerRadius = rounded ? gradientView.bounds.height / 2 : 0
        percentFillView.layer.cornerRadius = rounded ? percentFillView.bounds.height / 2 : 0
        layer.cornerRadius = rounded ? bounds.height / 2 : 0
    }
    
    func setup() {
        if useBlur {
            addSubview(blurView)
            backgroundColor = .beamGray1
        } else if case let .color(tint) = tintType {
            backgroundColor = tint
        }
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView.clipsToBounds = true
        percentFillView.clipsToBounds = true
        addSubview(gradientView)
        gradientView.addSubview(percentFillView)
        gradientView.layer.addSublayer(rainbowGradient)
        
        gradientView.mask = percentFillView
    }
    
    var useBlur: Bool {
        if case .blur = tintType {
            return true
        }
        return false
    }
}
