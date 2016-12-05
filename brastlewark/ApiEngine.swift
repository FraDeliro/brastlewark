//
//  ApiEngine.swift
//  brastlewark
//
//  Created by Francesco on 12/11/16.
//  Copyright © 2016 me. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage

//MARK: - Typedef
typealias ArrayBlock = ( _ response : [AnyObject]) -> ()
typealias ErrorBlock = (_ error : NSError) -> ()
typealias ModelBlock = ( _ response : AnyObject) -> ()
typealias BoolBlock = ( _ response : Bool) -> ()
typealias VoidBlock = () -> ()

class ApiEngine: NSObject, URLSessionDelegate {
    
    static let shared = ApiEngine()
    //api access
    private let hostName = "raw.githubusercontent.com"
    private let apiPath = "AXA-GROUP-SOLUTIONS/mobilefactory-test/master/data.json"
    var apiUrl: String {
        return "https://\(hostName)/\(apiPath)"
    }
    
    //MARK: - Initializer
    override init() {
        super.init()
    }
    
    func getBrastlewarkGnomes(succedeedBlock: @escaping ModelBlock, andErrorBlock errorBlock: @escaping ErrorBlock) {
    
        Alamofire.request(apiUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseData(completionHandler: { (response) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        let json = JSON(data: response.result.value!)
                        let dataArray = json["Brastlewark"].arrayValue
                        print(dataArray)
                        var model = [Gnome]()
                        for modelDict in dataArray {
                            let gnome = Gnome.getGnomeWithJSON(modelDict: modelDict)
                            model.append(gnome)
                        }
                        succedeedBlock(model as AnyObject)
                     }
                    break
                    
                case .failure(_):
                    errorBlock(response.result.error as! NSError)
                    print("error", response.result.error ?? "Error")
                    break
                    
                }
                
            })
    }
    
    func getGnomeImage(imageURL: String ,succedeedBlock: @escaping ModelBlock, andErrorBlock errorBlock: @escaping ErrorBlock) {
        Alamofire.request(imageURL).responseImage { response in
         switch(response.result) {
            case .success(_):
            if let image = response.result.value {
                //print("image downloaded: \(image)")
                self.cacheImage(image: image, urlString: imageURL)
                succedeedBlock(image as AnyObject)
            }
            break
            
            case .failure(_):
            errorBlock(response.result.error as! NSError)
            print("error", response.result.error ?? "Error")
            break
        }
       }
    }
    
    //MARK: = Image Caching
    
    func cacheImage(image: Image, urlString: String) {
        imageCache.add(image, withIdentifier: urlString)
    }
    
    func cachedImage(urlString: String) -> Image? {
        return imageCache.image(withIdentifier: urlString)
    }
}
