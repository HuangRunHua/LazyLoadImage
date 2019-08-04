//
//  TableViewController.swift
//  LazyLoadImage
//
//  Created by Runhua Huang on 2019/7/14.
//  Copyright © 2019 Runhua Huang. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        if let savedImages = Image.loadImages() {
            images = savedImages
        } else {
            images = Image.loadSampleImages()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    @IBAction func addNewImageButtontapped(_ sender: UIBarButtonItem) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertViewController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertViewController.addAction(photoLibraryAction)
        }

        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
        
        // --- 没有这一句话会有约束警告 ---
        alertViewController.view.subviews.flatMap({$0.constraints}).filter{ (one: NSLayoutConstraint)-> (Bool)  in
            return (one.constant < 0) && (one.secondItem == nil) &&  (one.firstAttribute == .width)
            }.first?.isActive = false
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // 获取图片唯一的ID，这里使用String(data: selectedImage.pngData()!, encoding: .unicode)!
            let image = Image(imageData: selectedImage.pngData()!, recordID: String(data: selectedImage.pngData()!, encoding: .unicode)!)
            images.append(image)
            Image.saveImages(images)
            dismiss(animated: true, completion: nil)
        }
    }
    


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        /**
         *另外在下载图片之前先把cell的imageView的image置为nil
         *可以防止图片下载失败而导致显示了以前的图片.
         *如果照片有在缓存里面就去缓存里面取，没有就添加到缓存里面
         */
        cell.lazyImageView.image = nil
        
        if let imageFromCache = imageCache.object(forKey: images[indexPath.row].recordID as AnyObject) as? UIImage {
            cell.lazyImageView.image = imageFromCache
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75) {
                // 获取cell真正的indexPath.
                if let index = tableView.indexPath(for: cell) {
                    if let data = images[index.row].imageData {
                        let imageToCache = UIImage(data: data)
                        // 给缓存添加照片
                        imageCache.setObject(imageToCache!, forKey: images[indexPath.row].recordID! as AnyObject)
                        cell.lazyImageView.image = UIImage(data: data)
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}
