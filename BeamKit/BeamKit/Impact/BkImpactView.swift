//
//  BkImpactView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 11/14/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

protocol BKImpactViewDelegate: class {
    var presentingViewController: UIViewController { get }
}

class BKImpactView: UIView {
    
    lazy var flow: BKImpactFlow = .init()
    weak var delegate: BKImpactViewDelegate?
    
    let backgroundImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let tintView: UIView = .init(with: .beamGray3)
    
    let causeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamRegular(size: 12.0)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = .white
        label.backgroundColor = .clear
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamBold(size: 24)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .white
        return label
    }()
    
    let progressBar: GradientProgressBar = .init(tintType: .blur)
    
    let seeMoreButton: BKGradientButton = {
        let button = BKGradientButton(frame: .zero)
        button.setTitle("See More of Your Impact", for: .normal)
        button.titleLabel?.font = UIFont.beamBold(size: 18)
        button.roundCorners = false
        return button
    }()
    
    // TODO powered by beam
    // TODO default size // intrinsic size
    // TODO setup INFO
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(frame: CGRect, delegate: BKImpactViewDelegate) {
        self.delegate = delegate
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        tintView.alpha = 0.25

        addSubview(backgroundImage.usingConstraints())
        backgroundImage.addSubview(tintView.usingConstraints())
        backgroundImage.addSubview(nameLabel.usingConstraints())
        backgroundImage.addSubview(progressBar.usingConstraints())
        backgroundImage.addSubview(causeLabel.usingConstraints())
        
        addSubview(seeMoreButton.usingConstraints())
        
        isUserInteractionEnabled = true
        seeMoreButton.addTarget(self, action: #selector(seeMore), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["back": backgroundImage,
                            "tint": tintView,
                            "name": nameLabel,
                            "bar": progressBar,
                            "cause": causeLabel,
                            "learn": seeMoreButton]
        let formats: [String] = ["H:|-30-[name]->=10-|",
                                 "H:|-30-[bar]-30-|",
                                 "H:|[learn]|",
                                 "V:|[back][learn(50)]|",
                                 "H:|[tint]|",
                                 "V:|[tint]|",
                                 "H:|[back]|",
                                 "H:|-30-[cause]->=10-|",
                                 "V:|-8-[cause]->=10-[name]-10-[bar(9)]-20-|"]
        let constraints: Constraints =
            NSLayoutConstraint.constraints(withFormats: formats, views: views)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // TODO add intrinsic content size
}

extension BKImpactView {
    @objc
    func seeMore() {
        // TODO error out in dev mode if no delegate
        // possibly on redraw remove button if no delgate????
        guard let delegate = delegate else { return }
        flow.showFullImpact(from: delegate.presentingViewController)
    }
}
