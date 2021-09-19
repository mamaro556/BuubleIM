//
//  ProductCell.swift
//  Cellbit
//
//  Created by Marvin Amaro on 8/31/21.
//  Copyright © 2021 Bahvan. All rights reserved.
//

import Foundation
import UIKit


@objc public class ProductCell : UITableViewCell {
    var product : Product? {
        didSet {
 //           productNameLabel.text = product?.productName
            productImage.image = product?.productImage
            productDescriptionLabel.text = product?.productDescription
        }
        
    }

/*    private let productNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        return label
    }()
*/
    
    private let productImage : UIImageView = {
        let image = UIImage(named: "memory.jpg")
        let imageView = UIImageView  (image:image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView

    }()
    
    private let productDescriptionLabel : UILabel = {
        let product = UILabel()
        product.textColor = .black
        product.text = "Seagate HDD ST2000 2TB"
        product.font = UIFont.systemFont(ofSize: 12)
        product.textAlignment = .right
        product.numberOfLines = 0
        return product
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        SetupUI()
    }
    
    func SetupUI()
    {
        addSubview(productImage)
        addSubview(productDescriptionLabel)
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            productImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            productImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            productImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            productImage.trailingAnchor.constraint(equalTo: self.productDescriptionLabel.leadingAnchor, constant: 0),
            productDescriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            productDescriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }

    required init?(coder aCoder:NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
