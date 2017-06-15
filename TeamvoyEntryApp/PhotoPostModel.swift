//
//  PhotoPostModel.swift
//  TeamvoyEntryApp
//
//  Created by Ostap Romaniv on 6/13/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

import UIKit

class PhotoPostModel {
    let photoStr: String?
    let authorPhotoStr: String?
    let authorInfo: String?
    var likesCount: Int?
    
    init(photoStr: String? = nil, authorPhotoStr: String? = nil, authorInfo: String? = nil, likesCount: Int? = nil) {
        self.photoStr = photoStr
        self.authorPhotoStr = authorPhotoStr
        self.authorInfo = authorInfo
        self.likesCount = likesCount
    }
    
}
