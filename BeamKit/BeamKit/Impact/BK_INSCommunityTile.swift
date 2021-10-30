//
//  BK_INSCommunityTile.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import Foundation
import UIKit

public class BK_INSCommunityTile: UIView {
    let nonprofitImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .purple
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
        
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamBold(size: 20) : UIFont.beamBold(size: 18)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.text = "World Central Kitchen"
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    
    let regionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = "Local Nonprofit"
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let infoTextLabelView: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.text = "Fund 10,000 meals to nourish communities impacted by Hurricane Ida"
        label.textColor = .instacartDescriptionGrey
        return label
    }()
    
    let causeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamRegular(size: 11.0) : UIFont.beamRegular(size: 12.0)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .instacartBeamOrange
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.text = "Climate disaster relief"
        label.minimumScaleFactor = 1
        return label
    }()
    
    let percentageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIDevice.current.is5or4Phone ? UIFont.beamRegular(size: 11.0) : UIFont.beamRegular(size: 12.0)
        label.textAlignment = .right
        label.numberOfLines = 1
        label.textColor = .instacartDescriptionGrey
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let separatorfirst: UIView = .init(with: .instacartBorderGrey)

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
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.instacartBorderGrey.cgColor
        nonprofitImage.layer.cornerRadius = 6
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(nonprofitImage.usingConstraints())
        addSubview(nameLabel.usingConstraints())
        addSubview(regionLabel.usingConstraints())
        addSubview(causeLabel.usingConstraints())
        addSubview(infoTextLabelView.usingConstraints())
        addSubview(progressBar.usingConstraints())
        addSubview(percentageLabel.usingConstraints())
        addSubview(separatorfirst.usingConstraints())
        addSubview(ctaButton.usingConstraints())
        
        setupConstraints()
    }
    
    func configure(with nonprofit: BKNonprofit?) {
        nameLabel.text = nonprofit?.name
        causeLabel.text = nonprofit?.cause
        infoTextLabelView.text = nonprofit?.impactDescription
        progressBar.numerator = CGFloat(nonprofit?.percentage ?? 0)
        progressBar.denominator = 100
        percentageLabel.text = "\(nonprofit?.percentage)%"
    }
    
    func setupConstraints() {
        let views: Views = ["image": nonprofitImage,
                            "name": nameLabel,
                            "reg": regionLabel,
                            "cause": causeLabel,
                            "goal": infoTextLabelView,
                            "sep": separatorfirst,
                            "bar": progressBar,
                            "per": percentageLabel,
                            "cta": ctaButton]
        
        let formats: [String] = ["V:[goal]-[per]",
                                 "V:|-16-[image(120)]-[reg]-[name]-[cause]-[goal]-[bar(8)]-[sep(1)]-[cta]-16-|",
                                 "H:|-16-[image]-16-|",
                                 "H:|-16-[reg]-16-|",
                                 "H:|-16-[name]-16-|",
                                 "H:|-16-[cause]-16-|",
                                 "H:|-16-[goal]-16-|",
                                 "H:|-16-[bar]-[per(20)]-16-|",
                                 "H:|-16-[sep]-16-|",
                                 "H:|-16-[cta]-16-|",

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
