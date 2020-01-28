//
//  APIService.swift
//  YTS
//
//  Created by ahmed elmemy on 1/23/20.
//  Copyright © 2020 ElMeMy. All rights reserved.
//


import Foundation
import Alamofire
enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchPopularMovies( complete: @escaping ( _ success: Bool, _ movies: [Movie], _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    // Simulate a long waiting for fetching
    
    
    var Home : MoviesModel?
    var MoviesData   = [Movie]()
    
    
    
    func fetchPopularMovies( complete: @escaping ( _ success: Bool, _ movies: [Movie], _ error: APIError?)->()) {
        DispatchQueue.global().async {
            sleep(3)
            Alamofire.request(URLs.listMovies, method: .get, parameters: nil).responseJSON { (response) in
                
                switch response.result{
                case .success(_):
                    
                    do{
                        let data = try JSONDecoder().decode(MoviesModel.self, from: response.data!)
                        self.Home = data
                        self.handeleViewData(homeData: data)
                        complete(true, self.MoviesData, nil)
                        
                    }catch{
                        complete(false,[],APIError.serverOverload)
                        print(error)
                    }
                    
                case .failure(_):
                    complete(false,[],APIError.noNetwork)
                }
            }
            
        }
    }
    
    
    
    
    

    func handeleViewData(homeData: MoviesModel){
        MoviesData = homeData.data.movies
    }
}
