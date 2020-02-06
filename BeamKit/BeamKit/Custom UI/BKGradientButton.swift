//
//  GradientButton.swift
//  Beam
//
//  Created by ALEXANDRA SALVATORE on 11/13/18.
//  Copyright © 2018 Beam Impact. All rights reserved.
//

import UIKit

class BKGradientButton: UIButton {

    var isInverted: Bool = false {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    let gradient: CAGradientLayer = {
        let gradient: CAGradientLayer = .init()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.beamGradientLightYellow.cgColor,
                           UIColor.beamGradientLightOrange.cgColor]
        return gradient
    }()
    
    lazy var tintView: UIView = {
        let view = UIView(with: .beamGray3)
        view.alpha = 0.3
        clipsToBounds = true
        return view
    }()
    
    var roundCorners: Bool = true
    
    override func layoutSubviews() {
        if roundCorners {
            layer.cornerRadius = bounds.height / 2
        }
        gradient.frame = bounds
        mask = isInverted ? titleLabel : nil
        adjustTint()
        super.layoutSubviews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width +
            titleEdgeInsets.left + titleEdgeInsets.right
        let height = size.height +
            titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: width, height: height)
    }
    
    func setupViews() {
        clipsToBounds = true
        titleEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        layer.addSublayer(gradient)
        setTitleColor(.white, for: .normal)
    }
    
    func set(enabled: Bool) {
        isEnabled = enabled
        if enabled {
            removeTint()
        } else {
            addTint()
        }
    }
    
    func addTint() {
        guard !subviews.contains(tintView) else { return }
        addSubview(tintView)
        adjustTint()
    }
    
    func removeTint() {
        guard subviews.contains(tintView) else { return }
        tintView.removeFromSuperview()
    }
    
    func adjustTint() {
        guard subviews.contains(tintView) else { return }
        tintView.frame = bounds
        tintView.layer.cornerRadius = bounds.height / 2
    }
}
