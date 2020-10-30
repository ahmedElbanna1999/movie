//
//  MovieTableViewCell.swift
//  movie
//
//  Created by rivile on 10/30/20.
//  Copyright © 2020 rivile. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var MovieYearLabel: UILabel!
    @IBOutlet weak var MovieTitleLabel: UILabel!
    @IBOutlet weak var MoviePosterImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell", bundle: nil)
    }
    
    func configure ( with Model : Movie) {
        
        self.MovieYearLabel.text = Model.Year
        self.MovieTitleLabel.text = Model.Title
        let url = Model.Poster
        if let data = try? Data(contentsOf: URL(string: url)!){
        self.MoviePosterImage.image = UIImage(data: data)
        }
        
    }
    
}
