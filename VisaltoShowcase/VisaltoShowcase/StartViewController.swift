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
        
        configureStartButton()
        configureDropCacheButton()

    }
        
    @objc private func didTapButton(_ button: UIButton) {
        let imageTableViewController = ImageTableViewController(style: .plain)
        navigationController?.pushViewController(imageTableViewController, animated: true)
    }
    
    @objc private func didTapDropCacheButton(_ barButtonItem: UIBarButtonItem) {
        Visalto.shared.clearCache()
    }
    
}

private extension StartViewController {
    
    func configureStartButton() {
        
        let nextButton = UIButton(type: .custom)
        nextButton.setTitleColor(UIColor(named: "appleBlue"), for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Start", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 25)
        nextButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(nextButton)
        
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }
    
    func configureDropCacheButton() {
        
        let dropCacheButton = UIBarButtonItem(title: "Drop cache", style: .plain, target: self, action: #selector(didTapDropCacheButton(_:)))
        navigationItem.rightBarButtonItem = dropCacheButton
        
    }
    
}
