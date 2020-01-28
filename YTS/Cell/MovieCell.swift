//
//  MovieCell.swift
//  YTS
//
//  Created by ahmed elmemy on 1/22/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//

import UIKit
import Kingfisher
class MovieCell: UICollectionViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var moviesListCellViewModel:MovieListCellViewModel?
    {
        didSet
        {
            name.text = moviesListCellViewModel?.name
            date.text = moviesListCellViewModel?.date
            let url = URL(string: ((moviesListCellViewModel?.image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)) ?? ""))
            img.kf.setImage(with: url)
        }
    }
    
}
