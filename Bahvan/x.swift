//
//  Product.swift
//  Bahvan
//
//  Created by Marvin Amaro on 8/31/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

import Foundation
import UIKit

class Product : NSObject {
    //var productName : String
    var productImage : UIImage! = nil
    var productDescription : String! = nil

    override init() {
        super.init()
    }

    init(productImage: UIImage, productDescription: String){
        self.productImage = productImage
        self.productDescription = productDescription
    }
}
