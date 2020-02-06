//
//  BackArrowButton.swift
//  Beam
//
//  Created by ALEXANDRA SALVATORE on 11/29/18.
//  Copyright © 2018 Beam Impact. All rights reserved.
//

import UIKit

//TODO eval 
class BackArrowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    init(tint: UIColor) {
        super.init(frame: .zero)
        setup()
        self.tint(tint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func tint(_ color: UIColor) {
//        setImage(#imageLiteral(resourceName: "back-arrow").maskWithColor(color: color), for: .normal)
    }
    
    // TODO IMAGE????
    func setup() {
        setImage(#imageLiteral(resourceName: "back-arrow"), for: .normal)
        imageView?.backgroundColor = .clear
        imageView?.contentMode = .scaleAspectFit
        imageView?.clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 5, right: 8)
    }
}
