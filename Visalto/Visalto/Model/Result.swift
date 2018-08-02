//
//  Result.swift
//  Visalto
//
//  Created by Vladislav Fitc on 02/08/2018.
//  Copyright © 2018 Vladislav Fitc. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Swift.Error)
}
