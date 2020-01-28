//
//  MoviesListViewModel.swift
//  YTS
//
//  Created by ahmed elmemy on 1/23/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class MoviesListViewModel {
    let apiService :APIServiceProtocol
    
    private var  movie: [Movie] = [Movie]()
    

    var CellViewModel = Variable<[MovieListCellViewModel]>([])
    var alertMessage = Variable<String>("")
    var state =  Variable<State>(.empty)

    func RxSwift(){
        CellViewModel.asObservable()
        alertMessage.asObservable()
        state.asObservable()
    }
    


    
    var numbeOfCells : Int
    {
        return CellViewModel.value.count
    }

    var selectedMovie: Movie?
    
    
    
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    
    func initFetch() {
        state.value = .loading
        apiService.fetchPopularMovies { [weak self] (success, movies, error) in
            guard let self = self else {
                return
            }
            
            guard error == nil else {
                self.state.value = .error
                self.alertMessage.value = error?.rawValue ?? ""
                return
            }
            
            self.processFetchedMovies(movies: movies)
            self.state.value = .populated
        }
        
        
    }
    
    
    func createCellViewModel(movies : Movie)->MovieListCellViewModel
    {
        return MovieListCellViewModel(name: movies.title, image: movies.largeCoverImage, date: "\(movies.year)")
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> MovieListCellViewModel {
        return CellViewModel.value[indexPath.row]
    }
    
    private func processFetchedMovies( movies: [Movie] ) {
        self.movie = movies // Cache
        var vms = [MovieListCellViewModel]()
        for movie in movies {
            vms.append( createCellViewModel(movies: movie) )
        }
        self.CellViewModel.value = vms
    }
    
    
    
    
    
}
extension MoviesListViewModel
{
    func userPressed(at indexPath:IndexPath)  {
        let movie = self.movie[indexPath.row]
        selectedMovie = movie
    }
}
