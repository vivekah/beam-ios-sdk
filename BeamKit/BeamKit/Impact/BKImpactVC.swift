//
//  ImpactVC.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 10/9/19.
//  Copyright © 2019 Beam Impact. All rights reserved.
//

import Foundation
import UIKit

class BKImpactVC: UIViewController {
    weak var context: BKImpactContext?
    weak var flow: BKImpactFlow?
    
    let impactIdentifier = "impact_cell"
    let headerView: UIView = .init(with: .clear)
    
    // let separatorLine: UIView = .init(with: .beamGray1)
    // nonprofits you've supported
    // TODO -- update to reflect chain
    let nonprofitLabel: GradientTextView = .init(with: [UIColor.beamGradientLightYellow.cgColor,
                                                        UIColor.beamGradientLightOrange.cgColor],
                                                 text: "Nonprofits You've Supported",
                                                 font: UIFont.beamBold(size: 20))
    //table
    // todo slider
    private let impactTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.rowHeight = 340
        table.estimatedRowHeight = 340
        table.separatorInset = .zero
        table.layoutMargins = .zero
        table.separatorStyle = .none
        return table
    }()
    
    
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
        super.loadView()
        view = impactTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addSubview(nonprofitLabel)
        impactTableView.dataSource = self
        impactTableView.delegate = self
        setupHeader()
        impactTableView.tableHeaderView = headerView
        impactTableView.register(BKImpactCell.self,
                                 forCellReuseIdentifier: impactIdentifier)
        listen()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHeader()
    }
    
    func setupHeader() {
        let inset: CGFloat = 30
        let viewWidth = view.bounds.width
        headerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: 176)
        let width = viewWidth - (inset * 2)

      //  separatorLine.frame = CGRect(x: inset, y: 110, width: width, height: 1)
        nonprofitLabel.frame = CGRect(x: inset, y: 112, width: width, height: 65)
    }
    
    func listen() {
        // TODO Evaluate 
//        AppContext.shared.notificationCenter.addObserver(self,
//                                                         selector: #selector(didLoadImpact),
//                                                         name: .didLoadImpact,
//                                                         object: nil)
//
//        AppContext.shared.notificationCenter.addObserver(self,
//                                                         selector: #selector(donationsUpdate),
//                                                         name: .donationsUpdate,
//                                                         object: nil)
    }
    

}

extension BKImpactVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let context = context else {
            // TODO surface BeamError.invalidConfiguration
            return 0
        }
        return context.numberOfNonprofits
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let context = context,
            let cell = impactTableView.dequeueReusableCell(withIdentifier: impactIdentifier,
                                                             for: indexPath) as? BKImpactCell else {
            return UITableViewCell()
        }
        if let impact = context.nonprofits?[indexPath.row] {
            cell.configure(with: impact)
        }
        return cell
    }
}

extension BKImpactVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension BKImpactVC {
    @objc
    func didLoadImpact() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.impactTableView.reloadData()
            //todo update chain name
        }
    }

    @objc
    func donationsUpdate() {
        guard let context = context else {
            // TODO surface BeamError.invalidConfiguration
            return
        }
        context.loadImpact()
    }
}
