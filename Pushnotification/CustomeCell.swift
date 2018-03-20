//
//  CustomeCell.swift
//  Pushnotification
//
//  Created by ios on 23/12/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

@objc protocol myProtocol  {
    var str : NSDictionary { get set }
    //@objc is used when you want optional property in swift.. 
    @objc optional var myOptionalVar : String {get set }
    func btnTapped(customCell : CustomeCell)
    
}
class CustomeCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    var delegate: myProtocol?
    var completionHandler: ((_ str : String) -> Void)?
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBAction func btnTapped(_ sender: Any) {
//        if let del = delegate {
//            del.btnTapped(customCell: self)
//        }
        if completionHandler != nil {
            completionHandler!("vasv")
        }
        
    }
    
    func simpleLoadImage(url : String,completion :@escaping ( _ data : Data) -> Void){
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            let request = URLRequest.init(url: URL.init(string: url)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 120.0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    if let data = data {
                        self.imgView.image = UIImage.init(data: data)
                        completion(data)
                    }
                }
            }
            task.resume()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
