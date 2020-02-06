//
//  ChooseNonprofitVC.swift
//  beam-ios-sdk
//
//  Created by ALEXANDRA SALVATORE on 7/15/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import UIKit

class ChooseNonprofitVC: UIViewController {

    let transaction: Transaction
  //TODO  var flow: RedeemVisitFlow?
  //TODO  var context: VisitContext?
    
    let header: VisitHeaderView

    let first: NonprofitView = .init(frame: .zero)
    let second: NonprofitView = .init(frame: .zero)
    let third: NonprofitView = .init(frame: .zero)
    let fourth: NonprofitView = .init(frame: .zero)
    var showFourth: Bool = true
    
    init(with transaction: Transaction) {
        self.transaction = transaction
        header = VisitHeaderView(with: transaction)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(header.usingConstraints())
        view.addSubview(first.usingConstraints())
        view.addSubview(second.usingConstraints())
        view.addSubview(third.usingConstraints())
        view.addSubview(fourth.usingConstraints())
        
        configureNonprofits()
        addTargets()
        setupConstraints()
    }
    
    func configureNonprofits() {
        guard let nonprofits = transaction.storeNon.nonprofits else { return }
        let firstNon = nonprofits.count > 0 ? nonprofits[0] : nil
        first.configure(with: firstNon)
        let secondNon = nonprofits.count > 1 ? nonprofits[1] : nil
        second.configure(with: secondNon)
        let thirdNon = nonprofits.count > 2 ? nonprofits[2] : nil
        third.configure(with: thirdNon)
        let fourthNon = nonprofits.count > 3 ? nonprofits[3] : nil
        fourth.configure(with: fourthNon)
        showFourth = !fourth.isHidden
    }
    
    func setupConstraints() {
        let views: Views = ["header": header,
                            "first": first,
                            "second": second,
                            "third": third,
                            "fourth": fourth]
        
        var formats: [String] = ["H:|[header]|",
                                 "H:|[first]|",
                                 "H:|[second]|",
                                 "H:|[third]|",
                                 "H:|[fourth]|"]
        
        if showFourth {
            formats.append("V:|[header][first]-2-[second]-2-[third]-2-[fourth]|")
        } else {
            formats.append("V:|[header][first]-2-[second]-2-[third]|")
        }
        
        var constraints: Constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                                      views: views)
        
        constraints += [NSLayoutConstraint(item: first,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: second,
                                           attribute: .height,
                                           multiplier: 1.0,
                                           constant: 0.0),
                        NSLayoutConstraint(item: second,
                                           attribute: .height,
                                           relatedBy: .equal,
                                           toItem: third,
                                           attribute: .height,
                                           multiplier: 1.0,
                                           constant: 0.0)]
        
        if showFourth {
            constraints += [NSLayoutConstraint(item: third,
                                               attribute: .height,
                                               relatedBy: .equal,
                                               toItem: fourth,
                                               attribute: .height,
                                               multiplier: 1.0,
                                               constant: 0.0)]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension ChooseNonprofitVC {
    
    func addTargets() {
        // TODO header.backButton.addTarget(self,
         //                           action: #selector(didTapBackButton),
       //                             for: .touchUpInside)
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
    }
    
    @objc
    func didTapBackButton() {
       // TODO flow?.navigateBack(from: self)
    }
}

extension ChooseNonprofitVC: NonprofitViewDelegate {
    
    func didSelect(_ nonprofit: Nonprofit?) {
        guard let nonprofit = nonprofit else {
           // TODO flow?.navigateBack(from: self)
            return
        }
        // turn off user interaction so doesn't call api twice
        view.isUserInteractionEnabled = false
        
       // TODO flow?.redeem(transaction, nonprofit: nonprofit, from: self)
    }
}

class VisitHeaderView: UIView {
    let transaction: Transaction
  //  fileprivate let backButton: BackArrowButton = .init(frame: .zero)
    // TODO Back arrow
    
    let navBarView: UIView = .init(with: .clear)
    
    let beamLogoImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "fullSunsetLogo")  //.maskWithColor(color: .beamGray3)
        return view
    }()
    
    let chainLogoImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()
    
    let plusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.beamBold(size: 15)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .beamOrange4
        label.text = "+"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .beamGray3
        return label
    }()
    
    init(with transaction: Transaction) {
        self.transaction = transaction
        super.init(frame: .zero)
        setup()
        
        // TODO MULTIPLIER LABBELS
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        descriptionLabel.attributedText = descriptionString
        let store = transaction.storeNon.store
        if let rectLogo = store?.rectLogo,
            let url = URL(string: rectLogo) {
            chainLogoImageView.setImageWithUrl(url, priority: .veryHigh)
        } else if let logo = store?.logo,
            let url = URL(string: logo) {
            chainLogoImageView.setImageWithUrl(url, priority: .veryHigh)
        }
        
       // backButton.tint(.beamGray3)
      //  backButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        addSubview(navBarView.usingConstraints())
      //  navBarView.addSubview(backButton.usingConstraints())
        navBarView.addSubview(beamLogoImageView.usingConstraints())
        navBarView.addSubview(chainLogoImageView.usingConstraints())
        navBarView.addSubview(plusLabel.usingConstraints())
        addSubview(descriptionLabel.usingConstraints())
        
        setupConstraints()
    }
    
    var donationString: NSAttributedString {
        let amount = transaction.amount
        var donationString = "$" + String(amount)
        
        let percent = transaction.storeNon.store?.percent ?? 0.01
        let amtInt = Int(percent * 100)
        donationString = String(amtInt) + "%"
//        TODO boosts
//        if transaction.multiplier > 1 {
//            donationString.append(" x \(visit.multiplier)")
//        }
        
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.beamBold(size: 12) as Any,
                                                          .foregroundColor: UIColor.beamGray3]
        
        let attributedString = NSAttributedString(string: donationString,
                                                  attributes: attributes)
        return attributedString
    }
    
    lazy var descriptionString: NSAttributedString = {
        let name = transaction.storeNon.store?.name ?? "We"
        let beginText = "\(name) will donate "
        let endText = " to one nonprofit below. Swipe left to learn more, and tap to choose your donation."
        
        let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.beamRegular(size: 12) as Any,
                                                          .foregroundColor: UIColor.beamGray3]
        
        let desc = NSMutableAttributedString(string: beginText,
                                             attributes: attributes)
        
        let attributedEnd = NSAttributedString(string: endText,
                                               attributes: attributes)
        desc.append(donationString)
        desc.append(attributedEnd)
        return desc
    }()
    
    func setupConstraints() {
       // let insets = .zero // UIApplication.appDelegate.flow.safeAreaInsets
        let insets = UIEdgeInsets.zero // TODO check insets
        let views: Views = [//"back": backButton,
                            "beam": beamLogoImageView,
                            "chain": chainLogoImageView,
                            "plus": plusLabel,
                            "desc": descriptionLabel,
                            "nav": navBarView]
        
        let metrics: [String: Any] = ["navHeight": UIView.beamDefaultNavBarHeight,
                                      "top": insets.top]
        
        let formats: [String] = ["H:|-30-[back]",
                                 "H:|[nav]|",
                                 "H:[beam(70)]-[plus]-[chain(70)]->=10-|",
                                 "V:|-top-[nav(navHeight)]-5-[desc(navHeight)]|",
                                 "H:|-30-[desc]-30-|",
                                 "V:|-5-[chain]-2-|",
                                 "V:|-5-[beam]-2-|"]
        
        var constraints: Constraints = NSLayoutConstraint.center(plusLabel, in: navBarView)
        
        constraints += NSLayoutConstraint.constraints(withFormats: formats,
                                                      options: [],
                                                      metrics: metrics,
                                                      views: views)
        constraints += [//NSLayoutConstraint.centerOnY(backButton, in: navBarView),
                        NSLayoutConstraint.centerOnY(beamLogoImageView, in: navBarView),
                        NSLayoutConstraint.centerOnY(chainLogoImageView, in: navBarView)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override var intrinsicContentSize: CGSize {
        let width = bounds.width
        let height = UIView.beamDefaultNavBarHeight * 2 + 5
        return CGSize(width: width, height: height)
    }
}
