//
//  ImageLoadingError.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

enum ImageLoadingError: Swift.Error {
    case noData
    case invalidData(Data)
}
