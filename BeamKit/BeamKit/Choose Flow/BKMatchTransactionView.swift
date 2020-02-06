//
//  BKMatchTransactionView.swift
//  BeamKit
//
//  Created by ALEXANDRA SALVATORE on 1/27/20.
//  Copyright © 2020 Beam Impact. All rights reserved.
//

import UIKit

class BKMatchTransactionView: UIView {
    // label
    // circle with check
    // cent amount
}

class BKCheckButton: UIButton {
    
    let circleView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.beamGray4.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    // TODO tint color -- see backbutton
    let check: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "beam-check"))
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
    
    override var intrinsicContentSize: CGSize {
       // TODO deal with this// recalculate all this is copied from gradient button
        let size = super.intrinsicContentSize
        let width = size.width +
            titleEdgeInsets.left + titleEdgeInsets.right
        let height = size.height +
            titleEdgeInsets.top + titleEdgeInsets.bottom

        return CGSize(width: width, height: height)
    }
    
    func setupViews() {
        backgroundColor = .white
        clipsToBounds = true
        addSubview(circleView.usingConstraints())
        addSubview(check.usingConstraints())
        titleEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        setTitleColor(.white, for: .normal)
    }
}
