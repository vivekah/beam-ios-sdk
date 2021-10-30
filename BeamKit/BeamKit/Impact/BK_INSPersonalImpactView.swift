//
//  BK_INSPersonalImpactView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import UIKit

public class BK_INSPersonalImpactView: UIView {
    
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .purple
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Join us in the fight against food insecurity"
        label.textColor = .instacartTitleGrey
        label.font = .beamBold(size: 18)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Fund meals this holiday season by simply placing your order."
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    let percentageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamRegular(size: 11.0) : UIFont.beamRegular(size: 12.0)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .instacartDescriptionGrey
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.text = "1%"
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    public let ctaButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = .beamSemiBold(size: 12)
        button.setTitleColor(.instacartGreen, for: .normal)
        button.contentHorizontalAlignment = .left;
        button.setTitle("Select a nonprofit", for: .normal)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        nonprofitImage.layer.cornerRadius = nonprofitImage.bounds.height / 2
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(nonprofitImage.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        addSubview(subLabel.usingConstraints())
        addSubview(progressBar.usingConstraints())
        addSubview(percentageLabel.usingConstraints())
        addSubview(ctaButton.usingConstraints())
        
        setupConstraints()
    }
    
    func configure(with impact: BK_INSImpact?) {
      
    }
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "title": titleLabel,
                            "sub": subLabel,
                            "bar": progressBar,
                            "per": percentageLabel,
                            "cta": ctaButton]
        
        let formats: [String] = ["H:|-16-[image(50)]-16-[title]-16-|",
                                 "V:|-[image(50)]",
                                 "V:|-[title]-[sub]-[bar(8)]-[cta]-|",
                                 "H:|-82-[sub]-16-|",
                                 "H:|-82-[bar]-[per(20)]-16-|",
                                 "H:|-82-[cta]-16-|",

        ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        constraints += [NSLayoutConstraint.init(item: percentageLabel,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: progressBar,
                                                attribute: .centerY,
                                                multiplier: 1.0,
                                                constant: 0)]
    
        NSLayoutConstraint.activate(constraints)
    }
    
}

public class BK_INSPostPurchaseView: UIView {
    
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .purple
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 2
        label.text = "Your order has funded a meal for someone in need"
        label.textColor = .instacartTitleGrey
        label.font = .beamBold(size: 18)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Test Nonprofit"
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        nonprofitImage.layer.cornerRadius = nonprofitImage.bounds.height / 2
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(nonprofitImage.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        addSubview(subLabel.usingConstraints())
        
        setupConstraints()
        let name = BeamKitContext.shared.getNonprofitName()
        subLabel.text = name
    }
    
    func configure(with nonprofit: String) {
        subLabel.text = nonprofit
    }
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "title": titleLabel,
                            "sub": subLabel]
        
        let formats: [String] = ["H:|->=16-[image(50)]->=16-|",
                                 "V:|-[image(50)]-[title]-[sub]-|",
                                 "H:|-16-[sub]-16-|",
                                 "H:|-16-[title]-16-|",

        ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        constraints += [
            NSLayoutConstraint.init(item: nonprofitImage,
                                    attribute: .centerX,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .centerX,
                                    multiplier: 1,
                                    constant: 0)
        ]

    
        NSLayoutConstraint.activate(constraints)
    }
}

