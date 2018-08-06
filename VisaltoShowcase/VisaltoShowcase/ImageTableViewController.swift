//
//  ImageTableViewController.swift
//  TestVisaltoUI
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation
import UIKit
import Visalto

class ImageTableViewController: UITableViewController {
    
    let urls = TestImageURLs.urls
    let imageCellidentifier = "imageCellIdentifier"
    
    override init(style: UITableViewStyle) {
        super.init(style: style)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: imageCellidentifier, for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let imageCell = cell as? ImageTableViewCell else {
            return
        }
        
        cell.selectionStyle = .none
        
        let url = urls[indexPath.row]
        imageCell.imageURL = url
        
        Visalto.shared.loadImage(with: url, completionQueue: .main) { result in
            
            guard imageCell.imageURL == url else { return }
            
            if case .success(let image) = result {
                imageCell.updateImageView(with: image)
            }

        }
        
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let url = urls[indexPath.row]
        Visalto.shared.cancelLoading(for: url)
    }
        
}

private extension ImageTableViewController {
    
    func configure() {
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: imageCellidentifier)
    }
    
}
