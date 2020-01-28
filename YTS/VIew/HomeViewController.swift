//
//  HomeViewController.swift
//  YTS
//
//  Created by ahmed elmemy on 1/21/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class HomeViewController: UIViewController {
    
    @IBOutlet weak var MoviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate let bag = DisposeBag()
    
    lazy var viewModel: MoviesListViewModel = {
        return MoviesListViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MoviesCollectionView.delegate = self
        MoviesCollectionView.dataSource = self
        initView()
        initVM()
        viewModel.RxSwift()
    }
    
    func initView() {
        self.navigationItem.title = "Movies"
        
    }
    
    func initVM() {
        
        // RxSwift binding
        
        viewModel.alertMessage.asObservable()
            .subscribe(onNext:{ value in
                DispatchQueue.main.async {
                    self.showAlert(value)
                }
            })
        
        viewModel.state.asObservable()
            .subscribe(onNext:{ value in
                
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    switch self.viewModel.state.value {
                    case .empty, .error:
                        self.activityIndicator.stopAnimating()
                        UIView.animate(withDuration: 0.2, animations: {
                            self.MoviesCollectionView.alpha = 0.0
                        })
                    case .loading:
                        self.activityIndicator.startAnimating()
                        UIView.animate(withDuration: 0.2, animations: {
                            self.MoviesCollectionView.alpha = 0.0
                        })
                    case .populated:
                        self.activityIndicator.stopAnimating()
                        UIView.animate(withDuration: 0.2, animations: {
                            self.MoviesCollectionView.alpha = 1.0
                        })
                    }
                }
            })
        
        viewModel.CellViewModel.asObservable()
            .subscribe(onNext:{ value in
                self.MoviesCollectionView.reloadData()
            })
            
            .addDisposableTo(bag)
        
        
        viewModel.initFetch()
        
    }
    
    
    func showAlert( _ message: String ) {
        if message != ""
        {
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {return  UICollectionViewCell()}
        
        
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.moviesListCellViewModel = cellVM
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numbeOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.bounds.width/2) - 10 , height: 260)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.userPressed(at: indexPath)
        print(viewModel.selectedMovie!.id)
        let vc = Storyboard.Main.instantiate(FilmDetailsViewController.self)
        vc.viewModel.selectedMovie = viewModel.selectedMovie
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
    
}
