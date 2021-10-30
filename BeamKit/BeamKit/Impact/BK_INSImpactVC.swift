//
//  BK_INSImpactVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/16/21.
//

import UIKit

public protocol BK_INSImpactVCDelegate: class {
    func didDismiss()
    func didRequestToSelectNonprofit()
    func didRequestToViewNationalImpact()
    
}

class BK_INSImpactVC: UIViewController {
    weak var flow: BKImpactFlow?
    weak var context: BKImpactContext?
    
    let scrollView: UIScrollView = .init(frame: .zero)
    let contentView: UIView = .init(frame: .zero)
    // personal impact
    let personal: BK_INSPersonalImpactView = .init(frame: .zero)
    // sep bar
    let separatorfirst: UIView = .init(with: .instacartBorderGrey)
    // tutorial header
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.textColor = .instacartTitleGrey
        label.text = "Help us fight food insecurity"
        label.font = .beamBold(size: 25)
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
        label.textColor = .instacartTitleGrey
        label.text = "This holiday season, Instacart has partnered with 4 non-profits in support of our mission to create a world where everyone has access to the food they love and more time to enjoy it together."
        return label
    }()
    // tutorial
    
    let tutorial: BK_INSTutorialVC = .init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    // sep bar
    let separatorSecond: UIView = .init(with: .instacartBorderGrey)

    // compliance + powered by
    let poweredByLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 10)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = "Powered by Beam Impact"
        label.textColor = .instacartDescriptionGrey
        return label
    }()
    
    let learnMoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 10)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = "Learn more"
        label.textColor = .instacartDescriptionGrey
        return label
    }()
    
    // title
    // description
    // natl linklll
    let cumulative: BK_INSCumulativeImpactView = .init(frame: .zero)
    
    let separatorThird: UIView = .init(with: .instacartBorderGrey)

    // title
    private let communityImpactTitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.textColor = .instacartTitleGrey
        label.text = "Impact in your area"
        label.font = .beamBold(size: 18)
        return label
    }()
    // impact titles
    let tile: BK_INSCommunityTile = .init(frame: .zero)
    let tile1: BK_INSCommunityTile = .init(frame: .zero)
    let tile2: BK_INSCommunityTile = .init(frame: .zero)
    let tile3: BK_INSCommunityTile = .init(frame: .zero)

    init(context: BKImpactContext,
         flow: BKImpactFlow) {
        self.context = context
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        listen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setup() {
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        view.addSubview(contentView.usingConstraints())
        contentView.addSubview(personal.usingConstraints())
        contentView.addSubview(separatorfirst.usingConstraints())
        contentView.addSubview(titleLabel.usingConstraints())
        contentView.addSubview(subLabel.usingConstraints())
        contentView.addSubview(separatorSecond.usingConstraints())
        contentView.addSubview(learnMoreLabel.usingConstraints())
        contentView.addSubview(poweredByLabel.usingConstraints())
        contentView.addSubview(cumulative.usingConstraints())
        contentView.addSubview(separatorThird.usingConstraints())
        contentView.addSubview(communityImpactTitleLabel.usingConstraints())
        contentView.addSubview(tile.usingConstraints())
        contentView.addSubview(tile1.usingConstraints())
        contentView.addSubview(tile2.usingConstraints())
        contentView.addSubview(tile3.usingConstraints())

        addChild(tutorial)
        contentView.addSubview(tutorial.view.usingConstraints())
        tutorial.didMove(toParent: self)
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["content": contentView,
                            "title": titleLabel,
                            "sub": subLabel,
                            "personal": personal,
                            "tutorial": tutorial.view,
                            "learn": learnMoreLabel,
                            "powered": poweredByLabel,
                            "cum": cumulative,
                            "commTitle": communityImpactTitleLabel,
                            "tile": tile,
                            "tile1": tile1,
                            "tile2": tile2,
                            "tile3": tile3,

                            "sep1": separatorfirst,
                            "sep2": separatorSecond,
                            "sep3": separatorThird]
        
        let formats: [String] = ["H:|[content]|",
                                 "V:|[content]|",
                                 "V:|[personal(150)]-[sep1(1)]-[title]-[sub]-[tutorial(300)]-[sep2(1)]-[learn]-[cum]-[sep3(1)]-[commTitle]-[tile]-[tile1]-[tile2]-[tile3]-|",
                                 "V:[sep2]-[powered]",
                                 "H:|[personal]|",
                                 "H:|-16-[sep1]-16-|",
                                 "H:|-16-[tutorial]-16-|",
                                 "H:|-16-[learn]-[powered]-16-|",
                                 "H:|-16-[sub]-16-|",
                                 "H:|-16-[sep2]-16-|",
                                 "H:|-30-[title]-30-|",
                                 "H:|-16-[commTitle]-16-|",
                                 "H:|-40-[sep3]-40-|",
                                 "H:|-16-[tile]-16-|",
                                 "H:|-16-[tile1]-16-|",
                                 "H:|-16-[tile2]-16-|",
                                 "H:|-16-[tile3]-16-|",

                                 "H:|[cum]|",

        ]
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
        let height = NSLayoutConstraint(item: contentView,
                                        attribute: .height,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .height,
                                        multiplier: 1.0,
                                        constant: 0)
        height.priority = .defaultLow
        constraints += [ NSLayoutConstraint(item: contentView,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .width,
                                            multiplier: 1.0,
                                            constant: 0),
                         height
                         
        ]
    
        NSLayoutConstraint.activate(constraints)
    }
    
    func listen() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(impactDidLoad),
                                               name: ._bkDidUpdateCommunityImpact,
                                               object: nil)
    }
}


extension BK_INSImpactVC {
    @objc
    func impactDidLoad() {
        DispatchQueue.main.async {
            guard let context = self.context,
                let impact = context.instacartImpact else { return }
            let tiles = [self.tile, self.tile1, self.tile2, self.tile3]
            for (i, nonprofit) in impact.nonprofits.enumerated() {
                if i < tiles.count {
                    let tile = tiles[i]
                    tile.configure(with: nonprofit)
                }
                
            }
        }
    }
}
