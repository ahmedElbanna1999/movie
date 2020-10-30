//
//  ViewController.swift
//  movie
//
//  Created by rivile on 10/30/20.
//  Copyright © 2020 rivile. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate {
   
    

    
    @IBOutlet weak var Field: UITextField!
    
    @IBOutlet weak var table: UITableView!
    
    var movies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        Field.delegate = self
    }

    // :- Field
    
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchMovies()
    return true
        }
    func searchMovies() {
            Field.resignFirstResponder()
    guard let text = Field.text, !text.isEmpty else {
    return
            }

        
        let query = text.replacingOccurrences(of: "", with: "%20" )
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?apikey=3aea79ac&s=f\(query)type=movie")!, completionHandler: {data , response , error in
            guard let data = data , error == nil else {
                return
            }
            // Convert
            var result: MovieResult?
            do {
            result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
            print("error")
            }
            guard let finalResult = result else {
            return
            }

            
                        // Ubdate our movie arrey
            
            let newMovies = finalResult.search
                self.movies.append(contentsOf: newMovies)
            
            // refresh our table
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
            }).resume()
    }
    
    
    // :- table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
       }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show movies details
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
}
struct MovieResult: Codable {
    let search:[Movie]
    
}


struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys: String, CodingKey {
           case Title, Year, imdbID, _Type = "Type", Poster
       }
       
   }

