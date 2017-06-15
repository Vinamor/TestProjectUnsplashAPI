//
//  RandomPhotoViewController.swift
//  RESTAPI
//
//  Created by Ostap Romaniv on 6/14/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD

class RandomPhotoViewController: UIViewController {
    
    // MARK: - Properties
    var photoPost: PhotoPostModel?
    var liked = false

    // MARK: - IBOutlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!

    
    // MARK: - IBActions
    @IBAction func like(_ sender: UIButton) {
        guard let like = photoPost?.likesCount
            else { return }
        if !liked {
            likesLabel.text = "\(like + 1)" + " likes"
            likeButton.setImage(UIImage(named: "Liked"), for: .normal)
            liked = true
        } else {
            likesLabel.text = "\(like)" + " likes"
            likeButton.setImage(UIImage(named: "Unliked"), for: .normal)
            liked = false
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        request()
        
        SVProgressHUD.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RandomPhotoViewController {
    func request() {
        let urlString = "https://api.unsplash.com/photos/random/?client_id=25deeecd15756ad893f23bcc67a6ec9ad0f4014b063919dcb44722bb766db958"
        
        Alamofire.request(urlString).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:Any] {
                    
                    let likesCount = JSON["likes"] as? Int
                    
                    if let json3 = JSON["urls"] as? [String:Any] {
                        let photoStr = json3["full"] as? String
                        
                        if let json2 = JSON["user"] as? [String:Any] {
                            
                            let authorInfo = json2["name"] as? String
                            
                            let profileImg = json2["profile_image"] as? [String:Any]
                            let authorPhotoStr = profileImg?["medium"] as? String
                            
                            if let aName = authorInfo,let aPhoto = authorPhotoStr, let photo = photoStr,let likes = likesCount {
                                
                                self.photoPost = PhotoPostModel(photoStr: photo, authorPhotoStr: aPhoto, authorInfo: aName, likesCount: likes)
                                self.fillTheData()
                                SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fillTheData() {
        self.photo.sd_setImage(with: URL(string: (photoPost?.photoStr)!))
        self.authorPhoto.sd_setImage(with: URL(string: (photoPost?.authorPhotoStr)!))
        self.authorPhoto.layer.cornerRadius = 0.5 * self.authorPhoto.frame.size.height
        self.authorPhoto.clipsToBounds = true
        self.authorName.text = photoPost?.authorInfo
        self.likesLabel.text = String(describing: photoPost?.likesCount ?? 0) + " likes"
    }
}
