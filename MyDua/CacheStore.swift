//
//  CacheStore.swift
//  MyDua
//
//  Created by IB Arts Mac on 13/11/23.
//

import Foundation
import UIKit
class LazyImageLoaderView: UIImageView {
    
    let imagecache = NSCache<AnyObject, UIImage>()
    func loadimage(from imageurl:URL){
        
        if let chacheimg = self.imagecache.object(forKey: imageurl as AnyObject){
            self.image = chacheimg
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
            if let imgdata = try? Data(contentsOf: imageurl){
                if let image = UIImage(data: imgdata){
                    DispatchQueue.main.async {
                        self?.imagecache.setObject(image, forKey: imageurl as AnyObject)
                        self?.image = image
                    }
                }
                
            }
        }
    }
    
}
