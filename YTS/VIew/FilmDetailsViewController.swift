//
//  FilmDetailsViewController.swift
//  YTS
//
//  Created by ahmed elmemy on 1/25/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//

import UIKit
import Cosmos
class FilmDetailsViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var Description: UITextView!
    
    lazy var viewModel: MovieDescriptionViewModel = {
        return MovieDescriptionViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handelData()
        initView()
    }
    
    func initView(){
        self.navigationItem.title = viewModel.selectedMovie?.title
    }
    
    func handelData(){
        name.text = viewModel.selectedMovie?.title
        
        let url = URL(string: ((viewModel.selectedMovie?.largeCoverImage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)) ?? ""))
        image.kf.setImage(with: url)
        
        year.text = "\(String(describing: viewModel.selectedMovie!.year))"
        rating.rating = viewModel.selectedMovie!.rating / 2.0
        Description.text = viewModel.selectedMovie?.descriptionFull
        
    }
    
}
