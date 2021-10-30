//
//  BK_INSCumulativeImpactView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/27/21.
//

import Foundation
import UIKit

public class BK_INSCumulativeImpactView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "Together we’ve funded 27,571 meals nationwide"
        label.textColor = .instacartTitleGrey
        label.font = .beamBold(size: 18)
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.text = "We’ve partnered with hundreds of local and national charities. "
        label.textColor = .instacartTitleGrey
        return label
    }()

    
    public let ctaButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .beamSemiBold(size: 12)
        button.setTitleColor(.instacartGreen, for: .normal)
        button.setTitle("Review national impact", for: .normal)
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setup() {
        backgroundColor = .white
        addSubview(titleLabel.usingConstraints())
        addSubview(subLabel.usingConstraints())
        addSubview(ctaButton.usingConstraints())
        
        setupConstraints()
    }
    
    func configure(with impact: BK_INSImpact?) {
        var community = BeamKitContext.shared.getCommunityMeals() ?? 27001
        community += 80
        titleLabel.text = "Together we’ve funded \(community) meals nationwide"
    }
    
    func setupConstraints() {
        let views: Views = ["title": titleLabel,
                            "sub": subLabel,
                            "cta": ctaButton]
        
        let formats: [String] = ["V:|-[title]-[sub]-[cta]-|",
                                 "H:|-16-[sub]-16-|",
                                 "H:|-16-[title]-16-|",
                                 "H:|-16-[cta]-16-|",

        ]
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
    
        NSLayoutConstraint.activate(constraints)
    }
    
}

