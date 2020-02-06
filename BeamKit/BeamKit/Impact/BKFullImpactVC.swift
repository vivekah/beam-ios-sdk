//
//  BKFullImpactVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/29/19.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

class BKFullImpactVC: UIViewController {
    weak var flow: BKImpactFlow?
    weak var context: BKImpactContext?
    
    // TODO BACK BUTTON
    // TODO icon/ nav bar
    let navBar: UIView = .init(frame: .zero)
    
    let tabBar: BKImpactSlideView = .init(frame: .zero)
    let carousel: BKImpactPageVC = .init(transitionStyle: .scroll,
                                         navigationOrientation: .horizontal)
    
    init(context: BKImpactContext,
         flow: BKImpactFlow) {
        self.context = context
        self.flow = flow
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = .white
        view.addSubview(navBar.usingConstraints())
        view.addSubview(tabBar.usingConstraints())
        addChild(carousel)
        view.addSubview(carousel.view.usingConstraints())
        carousel.didMove(toParent: self)
        carousel.flow = flow
        carousel.impactDelegate = self
        tabBar.delegate = self
        setupConstraints()
    }
    
    func setupConstraints() {
        let views: Views = ["title": navBar,
                            "tab": tabBar,
                            "page": carousel.view]
        
        let metrics: [String: Any] = ["topInset": 8,
                                      "headerHeight": UIView.beamDefaultNavBarHeight]
        
        let formats: [String] = ["V:|-topInset-[title(headerHeight)]-8-[tab][page]|",
                                 "H:|[title]|",
                                 "H:|[tab]|",
                                 "H:|[page]|"]
        let constraints: Constraints =
        NSLayoutConstraint.constraints(withFormats: formats,
                                       options: [],
                                       metrics: metrics,
                                       views: views)
        NSLayoutConstraint.activate(constraints)
    }
}

extension BKFullImpactVC: BKImpactSlideViewDelegate {
    func didSelectMyImpact() {
        guard let flow = flow else {
            // TODO config error
            return
        }
        flow.selectImpact(from: carousel)
    }
    
    func didSelectGlobal() {
        guard let flow = flow else {
            // TODO config error
            return
        }
        flow.selectCommunity(from: carousel)
    }
}

extension BKFullImpactVC: BKImpactPageDelegate {
    func didSwipeToGlobal() {
        tabBar.didSelectGlobal()
    }
    
    func didSwipeToImpact() {
        tabBar.didSelectMyImpact()
    }
}
