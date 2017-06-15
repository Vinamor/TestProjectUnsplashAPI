//
//  MainTVC.swift
//  TeamvoyEntryApp
//
//  Created by Ostap Romaniv on 6/13/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SVProgressHUD

class MainTVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var posts = [PhotoPostModel?]()
    var cell = PhotoPostTableViewCell()
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingControl: UISegmentedControl!
    
    
    // MARK: - IBActions
    @IBAction func sortPhotos(_ sender: UISegmentedControl) {
        posts = []
        switch(sortingControl.selectedSegmentIndex) {
        case 0:
            self.request(sort: "latest")
        case 1:
            self.request(sort: "oldest")
        case 2:
            self.request(sort: "popular")
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    @IBAction func refreshTable(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerXib()
        configureTableView()
        
        switch(sortingControl.selectedSegmentIndex) {
        case 0:
            request(sort: "latest")
        case 1:
           request(sort: "oldest")
        case 2:
            request(sort: "popular")
        default:
            break
        }
        
        SVProgressHUD.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoPostTableViewCellID", for: indexPath) as? PhotoPostTableViewCell else { return UITableViewCell() }
    
        let post = posts[indexPath.row]
        
        cell.delegate = self
        
        cell.authorPhoto.sd_setImage(with: URL(string:(post?.authorPhotoStr)!))
        cell.authorPhoto.layer.cornerRadius = 0.5 * cell.authorPhoto.frame.size.height
        cell.authorPhoto.clipsToBounds = true
        cell.photo.sd_setImage(with: URL(string:(post?.photoStr)!))
        cell.authorInfo.text = post?.authorInfo ?? "Default Text"
        //cell.likeLabel.text = String(describing: post?.likesCount ?? 0) + " likes"
        if isLiked {
            cell.likeLabel.text = "\((post?.likesCount)! + 1)" + " likes"
        } else {
            cell.likeLabel.text = "\((post?.likesCount)!)" + " likes"
        }
        return cell
    }

}

extension MainTVC {
    
    // Register my xib
    func registerXib(){
        tableView.register(UINib(nibName: "PhotoPostTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoPostTableViewCellID")
    }
    
    // Automatically channges the size of the row
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 305
    }
    
    func request(sort: String) {
        
        let baseURL = "https://api.unsplash.com/"
        var photosURL = baseURL + "photos/curated?order_by="
        photosURL += sort
        photosURL += "&client_id=25deeecd15756ad893f23bcc67a6ec9ad0f4014b063919dcb44722bb766db958"
        
        Alamofire.request(photosURL).responseJSON { response in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [[String:Any]] {
                    for JSONObject in JSON {
                        let likesCount = JSONObject["likes"] as? Int
                        if let json2 = JSONObject["user"] as? [String:Any] {
                            let authorInfo = json2["name"] as? String
                            if let profileImg = json2["profile_image"] as? [String:Any] {
                                let authorPhotoStr = profileImg["medium"] as? String
                                
                                if let json3 = JSONObject["urls"] as? [String:Any] {
                                    let photoStr = json3["full"] as? String
                                    
                                    if let aName = authorInfo,let aPhoto = authorPhotoStr, let photo = photoStr,let likes = likesCount {
                                        
                                        self.posts.append(PhotoPostModel(photoStr: photo, authorPhotoStr: aPhoto, authorInfo: aName, likesCount: likes))
                                        
                                        self.tableView.reloadData()
                                        SVProgressHUD.dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainTVC: PhotoPostTableViewCellDelegate {
    func userDidLikeTapScripture(cell: PhotoPostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell), let like = posts[indexPath.row]?.likesCount
            else { return }
        if !cell.liked {
            cell.likeLabel.text = "\(like + 1)" + " likes"
            cell.likeButton.setImage(UIImage(named: "Liked"), for: .normal)
            cell.liked = true
            isLiked = true
        } else {
            cell.likeLabel.text = "\(like)" + " likes"
            cell.likeButton.setImage(UIImage(named: "Unliked"), for: .normal)
            cell.liked = false
            isLiked = false
        }
        let defaults = UserDefaults.standard
        defaults.set(cell.liked, forKey: "liked")
    }
}

