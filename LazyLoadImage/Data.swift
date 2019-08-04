//
//  Data.swift
//  LazyLoadImage
//
//  Created by Runhua Huang on 2019/7/14.
//  Copyright © 2019 Runhua Huang. All rights reserved.
//

import UIKit

class Image: Codable {
    var imageData: Data?
    var recordID: String?
    
    init(imageData: Data, recordID: String) {
        self.imageData = imageData
        self.recordID = recordID
    }
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Image").appendingPathExtension("plist")
    
    static func loadImages() -> [Image]? {
        guard let codedImages = try? Data(contentsOf: ArchiveURL) else { return nil }
        
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Image>.self, from: codedImages)
    }
    
    static func loadSampleImages() -> [Image] {
        return []
    }
    
    static func saveImages(_ images: [Image]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedImages = try? propertyListEncoder.encode(images)
        try? codedImages?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
}

var images: [Image] = []
let imageCache = NSCache<AnyObject, AnyObject>()

