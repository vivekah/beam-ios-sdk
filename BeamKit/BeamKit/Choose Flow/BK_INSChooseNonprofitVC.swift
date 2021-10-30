//
//  BK_INSChooseNonprofitVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/16/21.
//

import UIKit

public protocol BK_INSChooseNonprofitVCDelegate: class {
    func didDismiss()
}

public class BK_INSChooseNonprofitVC: UIViewController {

    let transaction: BKTransaction
    var flow: BKChooseNonprofitFlow {
        return BeamKitContext.shared.chooseFlow
    }
    
    let scrollView: UIScrollView = .init(frame: .zero)
    let contentView: UIView = .init(frame: .zero)
    let header: BK_INSVisitHeaderView
    public weak var delegate: BKChooseNonprofitViewDelegate?

    let first: BK_INSNonprofitButton = .init(frame: .zero)
    let second: BK_INSNonprofitButton = .init(frame: .zero)
    let third: BK_INSNonprofitButton = .init(frame: .zero)
    let fourth: BK_INSNonprofitButton = .init(frame: .zero)
    var showFourth: Bool = true
    let footer: BK_INSVisitFooterView = .init(frame: .zero)
    var selectedNonprofit: BK_INSNonprofitButton? = nil
    let placeholder: UIView = .init(frame: .zero)
    
    init(with transaction: BKTransaction) {
        self.transaction = transaction
        header = BK_INSVisitHeaderView(with: transaction)
        super.init(nibName: nil, bundle: nil)
    }
    
    public class func new() -> BK_INSChooseNonprofitVC? {
        guard let trans = BeamKitContext.shared.chooseFlow.context.currentTransaction else { return nil }
        return BK_INSChooseNonprofitVC.init(with: trans)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(scrollView.usingConstraints())
        scrollView.addSubview(contentView.usingConstraints())
        contentView.addSubview(header.usingConstraints())
        contentView.addSubview(first.usingConstraints())
        contentView.addSubview(second.usingConstraints())
        contentView.addSubview(third.usingConstraints())
        contentView.addSubview(fourth.usingConstraints())
        contentView.addSubview(placeholder.usingConstraints())
        placeholder.backgroundColor = .white
        view.addSubview(footer.usingConstraints())
        
        configureNonprofits()
        addTargets()
        setupConstraints()
        
    //    scrollView.contentSize.width =
    }
    
    func configureNonprofits() {
        guard let nonprofits = transaction.storeNon.nonprofits else { return }
        let selected = BeamKitContext.shared.getNonprofitID()

        let firstNon = nonprofits.count > 0 ? nonprofits[0] : nil
        first.configure(with: firstNon)
        if selected == firstNon?.id {
            selectedNonprofit = first
            first.makeSelected()
            footer.toggle(on: true)
        }
        let secondNon = nonprofits.count > 1 ? nonprofits[1] : nil
        second.configure(with: secondNon)
        if selected == secondNon?.id {
            selectedNonprofit = second
            second.makeSelected()
            footer.toggle(on: true)
        }
        let thirdNon = nonprofits.count > 2 ? nonprofits[2] : nil
        third.configure(with: thirdNon)
        if selected == thirdNon?.id {
            selectedNonprofit = third
            third.makeSelected()
            footer.toggle(on: true)
        }
        let fourthNon = nonprofits.count > 3 ? nonprofits[3] : nil
        fourth.configure(with: fourthNon)
        if selected == fourthNon?.id {
            selectedNonprofit = fourth
            fourth.makeSelected()
            footer.toggle(on: true)
        }
        showFourth = !fourth.isHidden
        
     
    }
    
    func setupConstraints() {
        let views: Views = ["header": header,
                            "content": contentView,
                            "scroll": scrollView,
                            "first": first,
                            "second": second,
                            "third": third,
                            "fourth": fourth,
                            "buffer": placeholder,
                            "footer": footer]
        
        var formats: [String] = ["V:|[scroll]|",
                                 "H:|[scroll]|",
                                 "V:|[content]|",
                                 "H:|[content]|",
                                 "H:|[header]|",
                                 "H:|[footer]|",
                                 "V:[footer(100)]|",
                                 "H:|-16-[buffer]-16-|",
                                 "H:|-16-[first]-16-|",
                                 "H:|-16-[second]-16-|",
                                 "H:|-16-[third]-16-|",
                                 "H:|-16-[fourth]-16-|"]
        var insets: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            insets = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 8
        }
        let metrics = ["top": insets,
                       "height": 160]
        
        if showFourth {
            formats.append("V:|-top-[header]-12-[first(height)]-8-[second(height)]-8-[third(height)]-8-[fourth(height)][buffer(100)]|")
        } else {
            formats.append("V:|-top-[header]-12-[first(height)]-8-[second(height)]-8-[third(height)][buffer(100)]|")
        }
        
        var constraints: Constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                                      metrics: metrics,
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
}

extension BK_INSChooseNonprofitVC {
    
    func addTargets() {
         header.backButton.addTarget(self,
                                    action: #selector(didTapBackButton),
                                    for: .touchUpInside)
        first.delegate = self
        second.delegate = self
        third.delegate = self
        fourth.delegate = self
        
        footer.selectButton.addTarget(self,
                                      action: #selector(didTapChooseButton),
                                      for: .touchUpInside)
    }
    
    @objc
    func didTapBackButton() {
        flow.navigateBack(from: self)
    }
}

extension BK_INSChooseNonprofitVC: BK_INSNonprofitButtonDelegate {
    
    func didSelect(_ nonprofit: BKNonprofit?, button: BK_INSNonprofitButton) {
        guard let nonprofit = nonprofit else {
            flow.navigateBack(from: self)
            return
        }
        // turn off user interaction so doesn't call api twice
        // view.isUserInteractionEnabled = false
        selectedNonprofit?.deslect()
        selectedNonprofit = button
        button.makeSelected()
        footer.toggle(on: true)
    }
    
    @objc
    func didTapChooseButton() {
        guard let nonprofit = selectedNonprofit?.nonprofit else { return }
        flow.favorite(nonprofit: nonprofit, from: self) {
            BeamKitContext.shared.saveNonprofit(id: nonprofit.id)
            BeamKitContext.shared.saveNonprofit(name: nonprofit.name)
        }
    }
}

class BK_INSVisitHeaderView: UIView {
    let transaction: BKTransaction
    fileprivate let backButton: BKBackButton = .init(frame: .zero)
    
    let navBarView: UIView = .init(with: .white)
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamBold(size: 25)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .instacartTitleGrey
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .beamRegular(size: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.textColor = .instacartDescriptionGrey
        return label
    }()
    
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
    
    
    init(with transaction: BKTransaction) {
        self.transaction = transaction
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        descriptionLabel.text = transaction.storeNon.subtitle
        titleLabel.text = transaction.storeNon.title

        addSubview(navBarView.usingConstraints())
        navBarView.addSubview(backButton.usingConstraints())
        addSubview(descriptionLabel.usingConstraints())
        addSubview(titleLabel.usingConstraints())
        addSubview(poweredByLabel.usingConstraints())
        addSubview(learnMoreLabel.usingConstraints())
        setupConstraints()
    }

    
    func setupConstraints() {
        let insets = UIEdgeInsets.zero
        let views: Views = ["back": backButton,
                            "title": titleLabel,
                            "desc": descriptionLabel,
                            "poweredBy": poweredByLabel,
                            "learnMore": learnMoreLabel,
                            "nav": navBarView]
        

        let metrics: [String: Any] = ["navHeight": UIView.beamDefaultNavBarHeight,
                                      "top": insets.top,
                                      "pad": 5]
        
        let formats: [String] = ["H:|-30-[back(25)]",
                                 "H:|[nav]|",
                                 "V:|-top-[nav(navHeight)]-5-[title]-[desc]-[poweredBy]|",
                                 "V:[desc]-[learnMore]|",
                                 "H:|-16-[learnMore]->=16-[poweredBy]-16-|",
                                 "H:|-16-[title]-16-|",
                                 "H:|-16-[desc]-16-|"]
        
        var constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                      options: [],
                                                      metrics: metrics,
                                                      views: views)
        constraints += [NSLayoutConstraint.centerOnY(backButton, in: navBarView),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override var intrinsicContentSize: CGSize {
        let width = bounds.width
        let height = UIView.beamDefaultNavBarHeight * 2 + 5
        return CGSize(width: width, height: height)
    }
}


class BK_INSVisitFooterView: UIView {
    var isDisabled: Bool = true
    
    public let selectButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .instacartDisableGrey
        button.titleLabel?.font = .beamSemiBold(size: 15)
        button.setTitleColor(.instacartDescriptionGrey, for: .normal)
        button.setTitle("Choose nonprofit", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectButton.layer.cornerRadius = 5
    }
    
    func setup() {
        backgroundColor = .white
        addSubview(selectButton.usingConstraints())
        setupConstraints()
       // layer.shadowOffset = CGSize(width: 8, height: 8)
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowColor = UIColor.instacartDescriptionGrey.cgColor
        layer.shadowRadius = 9
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
    }
    
    func setupConstraints() {
        let views: Views = ["button": selectButton]
        
        let formats: [String] = ["H:|-[button]-|",
                                 "V:|-[button]-|"]
    
        let constraints = NSLayoutConstraint.constraints(withFormats: formats,
                                                         options: [],
                                                         metrics: nil,
                                                         views: views)
    
        NSLayoutConstraint.activate(constraints)
    }
    
    public func toggle(on: Bool) {
        selectButton.isEnabled = on
        selectButton.backgroundColor = on ? .instacartGreen : .instacartDisableGrey
        let titleColor: UIColor = on ? .white : .instacartDescriptionGrey
        selectButton.setTitleColor(titleColor, for: .normal)
        isDisabled = !on
    }
}

