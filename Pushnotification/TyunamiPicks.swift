//
//  TyunamiPicks.swift
//  Pushnotification
//
//  Created by ios on 17/11/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit
import SwiftyJSON

class TyunamiPicks: UIViewController , UITableViewDelegate, UITableViewDataSource  , myProtocol  {
    
    var topDealcache:NSCache<AnyObject, AnyObject>!
    //class method
    static func myStaticmethod()    {
        print("Static Method called")

    }
    var paginatorModel : Paginator?
    var str: NSDictionary = [:]
    var myOptionalVar: String {
        get {
            return "Bhavin"
        }
        set {
            self.myOptionalVar = "Bhavin"
        }
    }

    var aryPicks : Array<Any>?
    @objc func backgroundMethod() {
        
    }
    @objc func mainThreadMethod() {
        
    }
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Performing actions in background or main thread
        performSelector(inBackground: #selector(backgroundMethod), with: nil)
        performSelector(onMainThread: #selector(mainThreadMethod), with: nil, waitUntilDone: false)
        tblView.isHidden = true
        tblView.tableFooterView = UIView()
        tblView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.getPicks()
        
        //ios 11
//        tblView.dragDelegate = self as UITableViewDragDelegate
//        tblView.dropDelegate = self as UITableViewDropDelegate
        tblView.dragInteractionEnabled = true
        
        self.topDealcache = NSCache()
    }

    func getPicks() {
        let strUrl = "http://dev.tyunami.com:80/public/api/v1/covers/tyunamiPicks";
        let request = NetworkClass.sharedInstance.createGETRequestForURL(url: strUrl)
        NetworkClass.sharedInstance.getResponseForRequest(request: request) { (response, error, json) in
            if let err = error {
                print("\(err)")
                return
            }
            guard let resp = response else {
                print("Response is nil")
                return
            }
            if resp.statusCode == 200 {
                guard let js = json else {
                    print("json is nil")
                    return
                }
                    //Model using Codable
                do {
                    //you can use the below code to create models
                    let data = try? JSONSerialization.data(withJSONObject: js, options: JSONSerialization.WritingOptions.prettyPrinted)
                    self.paginatorModel = try JSONDecoder().decode(Paginator.self, from: data!)
                    print("Current page is \(String(describing: self.paginatorModel?.currentPage))")
                    self.paginatorModel?.currentPage = 4
                    print("current page is \(String(describing: self.paginatorModel?.currentPage))")
                    let feed = self.paginatorModel?.aryCovers[0]
                    let name = feed?.user?.name
                    print("\(name!)")
                    print("\(feed?.title! ?? "Bhavin")")
                    
//                ------------------------------- -----------------------------
            //we can also store the model in UserDefaults using Codable/Decodable here is an example..
                    let defaults = UserDefaults.standard
                    if let obj = defaults.object(forKey: "feed") as? Data {
                        let jsonDecoder = JSONDecoder()
                        let defFeed : FeedsModel = try! jsonDecoder.decode(FeedsModel.self, from: obj)
                        print("User defaults stored Feed\(defFeed)")
                    }
                    else {
                        let jsonEncoder = JSONEncoder()
                        let dt = try! jsonEncoder.encode(feed!)
                        defaults.set(dt, forKey: "feed")
                    }
                    
                    //when you are processing something try to use try! or try? as shown below for ex. when jsonserialization , nsdatawithcontentoffile etc.
                    //Using SwiftyJSON
                    let js = ["id":2,"title":nil,"descrip":"sadf"] as [String : Any?]
                    let d = try? JSONSerialization.data(withJSONObject: js, options: .prettyPrinted)
                    let json = try! JSON(data: d!)
                    let title = json["title"].string
                    print("\(String(describing: title))")
                }
                catch let error as Error {
                    print("error is \(error)")
                }
                
                
                

                if js is Dictionary<String, Any> {
                    
                    self.aryPicks = js.value(forKey: "data") as? Array
                    print("\(self.aryPicks!)")
                    DispatchQueue.main.async {
                        if self.aryPicks!.count > 0 {
                            self.tblView.isHidden = false
                            self.tblView.reloadData()
                        }
                    }
                }
            }
            else {
                print("response is \(resp.statusCode)")
            }
        }
    }

//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let model = self.paginatorModel?.aryCovers[indexPath.row]
//        let s = "Bhavin"
//        let provider = NSItemProvider(object: s as NSItemProviderWriting)
//        let item = UIDragItem(itemProvider: provider)
//        item.localObject = model
//        return [item]
//    }
//    func tableView(_ tableView: UITableView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
//        let model = self.paginatorModel?.aryCovers[indexPath.row]
//        let s = "Bhavin"
//        let provider = NSItemProvider(object: s as NSItemProviderWriting)
//        let item = UIDragItem(itemProvider: provider)
//        item.localObject = model
//        return [item]
//    }
//
//    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
//        return session.canLoadObjects(ofClass: NSString.self)
//    }
//    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
//        return UITableViewDropProposal(operation: .copy, intent: .automatic)
//    }
//    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
//        let destinationIndexPath : IndexPath
//        if let indexPath = coordinator.destinationIndexPath {
//            destinationIndexPath = indexPath
//        }else {
//            let section = tableView.numberOfSections - 1
//            let row = tableView.numberOfRows(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        coordinator.session.loadObjects(ofClass: NSString.self) { items in
//            guard let string = items as? [String] else { return }
//
//            var indexPaths = [IndexPath]()
//
//            for (index, value) in string.enumerated() {
//                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
////                self.arrImg.insert(value, at: indexPath.row)
//                indexPaths.append(indexPath)
//            }
//            tableView.insertRows(at: indexPaths, with: .automatic)
//        }
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let aryPic = self.aryPicks {
                return aryPic.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      /*Default cell
         
         var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "identifier")
        if cell  == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "identifier")
        }
        
        let dict : NSDictionary = self.aryPicks![indexPath.row] as! NSDictionary
        let desc = dict.value(forKey: "description") as? String
        let title = dict.value(forKey: "title") as? String
        if let str = title {
            cell!.detailTextLabel?.text = str
        }
        if  let st = desc {
            cell!.tex
         tLabel?.text = st
        }
        return cell!*/
        
       /* let dict : NSDictionary = self.aryPicks![indexPath.row] as! NSDictionary
        let title = dict.value(forKey: "title") as? String
        if let ttile = title {
            ttile.myStringExtensionMethod()
        }

        //method calling from extension which is Category in ObjC
        title?.myStringExtensionMethod()
     */
        let feed = self.paginatorModel?.aryCovers[indexPath.row]
        
        var cell: CustomeCell! = tableView.dequeueReusableCell(withIdentifier: "CustomeCell") as? CustomeCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "CustomeCell", bundle: nil), forCellReuseIdentifier: "CustomeCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomeCell") as? CustomeCell
        }
        if let str = feed?.title {
            cell.lblTitle.text = str

        }
        if let thumbPath = feed?.thumbFilePath {
           /* if (self.topDealcache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                print("Cached image used")
                cell.imgView.image = self.topDealcache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }
            else {
            self.loadImageWithSimpleDataTask(img: cell, imgURL: thumbPath, indexPath: indexPath)
//            self.loadImageWithDownloadTask(cell: cell, imgURL: thumbPath)
            }*/
//            self.simpleLoadImage(url: thumbPath, completion: { (data) in
//                cell.imgView.image = UIImage.init(data: data)
//            })
            cell.simpleLoadImage(url: thumbPath, completion: { (data) in
                
            })
        }
        cell.delegate = self as myProtocol
        cell.completionHandler = {
            (string) -> Void in
            print("my String\(string)")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func btnTapped(customCell: CustomeCell) {
        print("\(customCell)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func simpleLoadImage(url : String,completion :@escaping ( _ data : Data) -> Void){
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            let request = URLRequest.init(url: URL.init(string: url)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 120.0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    if let data = data {
                        completion(data)
                    }
                }
            }
            task.resume()
        }
    }
    //storing to cache
    func loadImageWithSimpleDataTask(img:CustomeCell, imgURL: String, indexPath : IndexPath) {
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            let request = URLRequest.init(url: URL.init(string: imgURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 120.0)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    if let data = data {
                        if let cell = img.superview?.superview as? CustomeCell {
                            let indexPath = self.tblView.indexPath(for: cell)
                            self.topDealcache.setObject(img, forKey: (indexPath! as NSIndexPath).row as AnyObject)
                        }
                        img.imageView!.image = UIImage.init(data: data)
                    }
                }
            }
            task.resume()
        }   
    }
    
    func loadImageWithDownloadTask(cell:CustomeCell, imgURL: String) {
        let url:URL! = URL(string: imgURL)
        let session = URLSession.shared
        let task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
            //Save file here..
            DispatchQueue.main.async {
                let data = try? Data.init(contentsOf: location!)
                
            cell.imgView.image = UIImage.init(data: data!)
            }
            
        })
        task.resume()
    }
}



extension String {
    func myStringExtensionMethod() {
        print("MY Extension method called")
    }
}
