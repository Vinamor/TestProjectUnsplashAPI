//
//  PhotoPostTableViewCell.swift
//  TeamvoyEntryApp
//
//  Created by Ostap Romaniv on 6/13/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit

protocol PhotoPostTableViewCellDelegate: class {
    func userDidLikeTapScripture(cell: PhotoPostTableViewCell)
}

class PhotoPostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var liked = false
    var delegate: PhotoPostTableViewCellDelegate?

    // MARK: - IBOutlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorInfo: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    
    // MARK: - IBAction
    @IBAction func like(_ sender: UIButton) {
        delegate?.userDidLikeTapScripture(cell: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
