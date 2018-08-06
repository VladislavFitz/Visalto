//
//  ImageTableViewCell.swift
//  TestVisaltoUI
//
//  Created by Vladislav Fitc on 05/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation
import UIKit

class ImageTableViewCell: UITableViewCell {
    
    let vImageView: UIImageView
    
    var imageURL: URL? {
        didSet {
            vImageView.image = .none
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        vImageView = UIImageView(frame: .zero)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        vImageView.translatesAutoresizingMaskIntoConstraints = false
        vImageView.contentMode = .scaleAspectFill
        vImageView.clipsToBounds = true
        configureLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        vImageView.image = .none
    }
    
    func updateImageView(with image: UIImage?) {
        vImageView.image = image
    }

}

private extension ImageTableViewCell {
    
    func configureLayout() {
        
        contentView.addSubview(vImageView)
        
        NSLayoutConstraint.activate([
            vImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            vImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            vImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            vImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
        ])
        
    }
    
}
