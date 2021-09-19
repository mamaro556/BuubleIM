//
//  Product.swift
//  Bahvan
//
//  Created by Marvin Amaro on 8/31/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

import Foundation
import UIKit

@objc class Product : NSObject {
    //var productName : String
    var productImage : UIImage! = nil
    var productDescription : String! = nil

    override init() {
        super.init()
    }

@objc   init(image: UIImage, productDescription: String){
        self.productImage = image
        self.productDescription = productDescription
    }
}
