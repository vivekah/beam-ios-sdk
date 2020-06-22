//
//  BKMatchTransactionView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 1/27/20.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

protocol BKMatchTransactionViewDelegate: class {
    func didToggleMatch(on: Bool)
}

class BKMatchTransactionView: UIView {
    weak var flow: BKChooseNonprofitFlow?
    weak var delegate: BKMatchTransactionViewDelegate?
    
    var _isMatched: Bool = false
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .beamGray3
        label.font = .beamSemiBold(size: 13)
        label.lineBreakMode = .byTruncatingTail
        label.text = "Unlocked: Make a Bigger Impact"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.textColor = .beamGray3
        label.font = .beamRegular(size: 12)
        label.lineBreakMode = .byTruncatingTail
        label.text = "I’d like to match the donation to get closer to funding my goal"
        return label
    }()
    lazy var selectTap = UITapGestureRecognizer(target: self, action: #selector(didTap))

    let percentageView: GradientTextView = .init(with: [UIColor.beamGradientLightYellow.cgColor,
                                                         UIColor.beamGradientLightOrange.cgColor],
                                                  text: "+1%",
                                                  font: UIFont.beamBold(size: 30))
    
    let button: BKCheckButton = .init(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .white
        addSubview(titleLabel.usingConstraints())
        addSubview(descriptionLabel.usingConstraints())
        addSubview(percentageView.usingConstraints())
        addSubview(button.usingConstraints())
        setupConstraints()
        button.addGestureRecognizer(selectTap)
    }
    
    func setupConstraints() {
        let views: [String: UIView] = ["title": titleLabel,
                                       "desc": descriptionLabel,
                                       "per": percentageView,
                                       "button": button]
        let formats: [String] = ["V:|-2-[title]-4-[desc]-2-|",
                                 "V:|->=2-[per]->=2-|",
        "H:|-10-[desc]-[per]-[button]-10-|",
        "H:|-10-[title]",
        "V:|->=2-[button(30)]->=2-|"]
        
        var constraints: [NSLayoutConstraint] =
            NSLayoutConstraint.constraints(withFormats: formats, views: views)
        constraints += [NSLayoutConstraint.centerOnY(button, in: self),
                        NSLayoutConstraint.centerOnY(percentageView, in: self),
                        NSLayoutConstraint.constrainWidth(percentageView, by: percentageView.intrinsicContentSize.width + 2)]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with name: String?, nonprofit: String, percent: CGFloat?) {
        toggleMatch(on: _isMatched)
        if let name = name {
            descriptionLabel.text = "I’d like to match \(name)'s donation to \(nonprofit) to get closer to funding my goal"
        } else {
            descriptionLabel.text = "I’d like to match the donation to \(nonprofit) to get closer to funding my goal"
        }
        let percent = percent ?? 0.01
        let amtInt = Int(percent * 100)
        let donationString = "+" + String(amtInt) + "%"
        percentageView.text = donationString
    }
    
    override var intrinsicContentSize: CGSize {
        let height = titleLabel.intrinsicContentSize.height + descriptionLabel.intrinsicContentSize.height + 8
        return CGSize(width: 0, height: height)
    }
    
    @objc
    func didTap() {
        _isMatched = !_isMatched
        toggleMatch(on: _isMatched)
    }
    
    func toggleMatch(on: Bool) {
        button.toggle(on: on)
        percentageView.toggleActive(on: on)
        delegate?.didToggleMatch(on: on)
    }
}

class BKCheckButton: UIView {
    let circleView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.beamGray3.cgColor
        view.layer.borderWidth = 2
        return view
    }()

    let check: UIImageView = {
        let view = UIImageView(frame: .zero)
        let bundle = BeamKitContext.shared.bundle
        let image = UIImage(named: "beam-check", in: bundle, compatibleWith: nil)
        view.image = image
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.layer.cornerRadius = circleView.bounds.height / 2
    }
    
    func setupViews() {
        backgroundColor = .white
      //  clipsToBounds = true
        addSubview(circleView.usingConstraints())
        addSubview(check.usingConstraints())
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: [String: UIView] = ["circle": circleView,
                                       "check": check]
        let formats: [String] = ["V:|-4-[circle]-4-|",
                                 "H:|[check]|",
                                 "V:|[check]|"]
        
        var constraints: [NSLayoutConstraint] =
            NSLayoutConstraint.constraints(withFormats: formats, views: views)
        constraints += [NSLayoutConstraint.square(circleView),
                        NSLayoutConstraint.centerOnX(circleView, in: self)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func toggle(on: Bool) {
        check.isHidden = !on
    }
    
}
