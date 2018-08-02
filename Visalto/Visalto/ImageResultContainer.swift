//
//  ImageResultContainer.swift
//  Visalto
//
//  Created by Vladislav Fitc on 03/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

protocol ImageResultContainer {
    var result: Result<UIImage>? { get }
}

typealias LoadImage = Operation & ImageResultContainer
