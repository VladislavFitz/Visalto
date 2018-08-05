//
//  StartViewController.swift
//  VisaltoShowcase
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation
import UIKit
import Visalto

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let nextButton = UIButton(type: .custom)
        nextButton.setTitleColor(.green, for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Visalto.shared.cache.clear()
    }
    
    @objc private func didTapButton(_ button: UIButton) {
        let imageTableViewController = ImageTableViewController(style: .plain)
        navigationController?.pushViewController(imageTableViewController, animated: true)
    }
    
}
