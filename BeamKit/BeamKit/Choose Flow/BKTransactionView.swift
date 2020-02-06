//
//  BKTransactionView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/29/19.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

public protocol BKTransactionViewDelegate: class {
    var presentingViewController: UIViewController { get }
}

public enum BKBackgroundType {
    case Solid(UIColor?)
    case Gradient(UIColor?, UIColor?)
    case Image
}

public class BKTransactionView: UIView {
    let backgroundView: BKBackgroundView
    
    let labelView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamBold(size: 13)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .white
        label.text = "THIS IS A TEST OF THE LABEL can it show the text correctly and talk about impact and nonprofits and other beam tings"
        return label
    }()
    
    let changeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = .beamBold(size: 15.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Change", for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    // TODO match view
    
    public init(with type: BKBackgroundType) {
        self.backgroundView = BKBackgroundView(with: type)
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        changeButton.layer.cornerRadius = changeButton.bounds.height / 3
        super.layoutSubviews()
    }
    
    func setup() {
        // TODO LOAD IMPACT // SHOW VIEWS
        addSubview(backgroundView.usingConstraints())
        addSubview(changeButton.usingConstraints())
        addSubview(labelView.usingConstraints())
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["back": backgroundView,
                            "button": changeButton,
                            "label": labelView]
        
        let formats = ["H:|[back]|",
                       "V:|[back]|",
                       "H:|-[label]-[button]-|",
                       "V:|->=5-[label]->=5-|]",
                       "V:|->=5-[button]->=5-|]"]
        var constraints: Constraints = NSLayoutConstraint.constraints(withFormats: formats, views: views)
        
        constraints += [NSLayoutConstraint.centerOnY(labelView, in: self),
                        NSLayoutConstraint.centerOnY(changeButton, in: self),
                        NSLayoutConstraint.constrainHeight(changeButton, by: changeButton.intrinsicContentSize.height + 16),
                        NSLayoutConstraint.constrainWidth(changeButton, by: changeButton.intrinsicContentSize.width + 16)]
    }
}

class BKBackgroundView: UIImageView {
    let type: BKBackgroundType
    
    lazy var gradient: CAGradientLayer = .beamGradient
    
    init(with type: BKBackgroundType) {
        self.type = type
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        gradient.frame = bounds
        super.layoutSubviews()
    }
    
    func setup() {
        backgroundColor = .white
        contentMode = .scaleAspectFill
        clipsToBounds = true
        switch type {
        case .Gradient(nil, nil):
            addGradient()
            return
        case let .Gradient(top, bottom):
            guard let top = top,
                let bottom = bottom else {
                    addGradient()
                    return
            }
            gradient.colors = [top.cgColor,
                               bottom.cgColor]
            addGradient()
            return
        case .Solid(nil):
            backgroundColor = .beamOrange3
            return
        case let .Solid(color):
            backgroundColor = color
            return
        case .Image:
            return
        }
    }
    
    func addGradient() {
        layer.addSublayer(gradient)
    }
}
