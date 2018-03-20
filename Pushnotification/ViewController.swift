//
//  ViewController.swift
//  Pushnotification
//
//  Created by ios on 15/11/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

//Imp Links :
// id in swift : https://developer.apple.com/swift/blog/?id=39

class Person {
    
    var name: String
    
  //lazy property
    lazy var personalizedGreeting: String = {
        [unowned self] in
        return "Hello, \(self.name)!"
        }()
    
    init(name: String) {
        self.name = name
    }
}


class ViewController: UIViewController {
   

    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    
    // If you want to create constructor for the controller than below is the way to do so.
    /*var name : String
    var surName : String
    init(name: String, surName : String) {
        self.name = name
        self.surName = surName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }*/
    
    
    @IBAction func btnTapped(_ sender: Any) {
        
        guard let userName = userNameTxtFld.text, !userName.isEmpty else {
            print("Enter User NAme)")
            let alert = UIAlertController.init(title: "Enter UserName", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let password = passwordTxtFld.text, !password.isEmpty , (password.count > 6) else {
            print("Enter Password)")
            return
        }
        self.threads() //Background threads
        self.callApi(userName: userName, password: password)
       
    }
    
    func threads() {
        //        There are primarily 6 levels in Quality of Service
        //
        //        1.userInteractive (highest Priority)
        //        2.userInitiated
        //        3.default
        //        4.utility
        //        5.background
        //        6.unspecified (lowest )
        
        let t = DispatchQueue.global() //this is background queue when async but when used sync it will be main thread
        //        t.sync {
        //            self.passwordTxtFld.text = "fdgsdbsu"
        //        }
        let main = DispatchQueue.main //This is main queue
        //        thread.async { //This is background queue
        ////            self.passwordTxtFld.text = "Bhavin Triveid"
        //        }
        let threadUserInteractive = DispatchQueue(label: "label" , qos:.userInteractive) //this is background thread when used async but when used sync it will be the main thread
        //        threadUserInteractive.sync
        //         {
        //            self.passwordTxtFld.text = "fdgsdbsu"
        //        }
        let thread = DispatchQueue(label: "fdsbhbsg", qos:.userInitiated) //this is background queue when async but when used sync it will be main thread
        //        thread.sync {
        //            self.passwordTxtFld.text = "fdgsdbsu"
        //        }
        let threadDefault = DispatchQueue(label: "fdsbhbsg", qos:.default) //this is background queue when async but when used sync it will be main thread
        //                threadDefault.sync {
        //                    self.passwordTxtFld.text = "fdgsdbsu"
        //                }
        let threadBackground = DispatchQueue(label: "fdsbhbsg", qos:.background) //this is background queue when async but when used sync it will be main thread
        //                        threadBackground.async {
        //                            self.passwordTxtFld.text = "fdgsdbsu"
        //                        }
        let threadUnspecified = DispatchQueue(label: "fdsbhbsg", qos:.unspecified) //this is background queue when async but when used sync it will be main thread
        //        threadUnspecified.sync {
        //            self.passwordTxtFld.text = "fdgsdbsu"
        //        }
        //As given in the below method we have to update the UI using the DispatchQueue.main.sync/async only no these above will work
    }
    func callApi(userName:String, password:String) {
        var postString : String
        postString = String.init(format:"email=%@&password=%@",userName,password)
        let data = postString.data(using: String.Encoding.ascii)
        let urlString = "http://dev.tyunami.com:80/public/api/v1/auth/login"
        var request = NetworkClass.sharedInstance.createPOSTRequestForURL(url: urlString)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField:"content-type")
        request.httpBody = data
        
        NetworkClass.sharedInstance.getResponseForRequest(request: request) { (response,error,json) in
          /*  let threadUserInteractive = DispatchQueue(label: "label" , qos:.userInteractive) //this is background thread when used async but when used sync it will be the main thread
                    threadUserInteractive.sync
                     {
                        self.passwordTxtFld.text = "fdgsdbsu"
                    }*/
            
            if let err = error {
                print("\(err)")
                return
            }
            guard let resp = response else {
                return
            }
            if resp.statusCode == 200 {
                
                guard let js = json  else {
                    print("some error occured as json is nil")
                    return
                }
                print("\(js)")
                let picks = self.storyboard?.instantiateViewController(withIdentifier: "TyunamiPicks")
                 TyunamiPicks.myStaticmethod()
                if let pickvc = picks {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(pickvc, animated:true)
                    }
                }
            }
            else if resp.statusCode == 401 {
                print("Invalid Credentials");
                self.showAlertWithMessage(message: "Invalid Credentials")
                
            }
            else {
                print("Please Try Again");
                self.showAlertWithMessage(message: "Please try again")
            }
        }
    }
    func showAlertWithMessage(message:String) {
        let alert = UIAlertController.init(title: message, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
        self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //
        
        
        
        //tuple
        var tuple = ("Bhavin",1,true)
        tuple.0 = "Hitesh"
        print("\(tuple.0)")
        //tuple with name
        let person1 = (firstName: "John", lastName: "Smith")
        let firstName = person1.firstName // John
        let lastName = person1.lastName // Smith
        print("\(firstName),\(lastName)")
        //tuple with multiple assignments
        var (a, b, c) = (1, 2, 3)
        a = 3
        b = 4
        c = 5
        print("\(a)")
        
        //tuple iterating dictionary
        let myDictionary = ["asdf":"dsf","fdsa":"sad"]
        for (key,value) in myDictionary {
            print("My key is \(key) and it has a value of \(value)")
        }
        
        //tuple iterating array
        var tupleArray = [String]()
        tupleArray += ["f","dsf","dsf"]
        for (index,title) in tupleArray.enumerated() {
            print("index is \(index) and title is \(title)")
        }
        
        userNameTxtFld.text = "bhavin.trivedi@pankanis.com"
        passwordTxtFld.text = "Bhavin@123"
        
       
        let person = Person(name:"Bhavin")
        print("\(person.personalizedGreeting)")
        
        
//        SQLiteHelper.sharedInstance.insertMovieData()
        //        Question 6: What is the difference between functions and methods in Swift?
        //        Answer: Both are functions in the same terms any programmer usually knows of it. That is, self-contained blocks of code ideally set to perform a specific task. Functions are globally scoped while methods belong to a certain type.
        
        // The let keyword is used to declare constants while var is used for declaring variables.
        
        
        //If you know the value can be there or not and if not than you want to assign a default value than use below ??
        let missingName : String? = "Bhavin "
        let realName : String? = "John Doe"
        let existentName : String = missingName ?? realName!
        print("\(existentName)")
        
        let optionalString : String? = "Bhavin Trivedi"
        //Unwrapping optional value when you know that will always contain value (optional chaining)
        //Example very imp:  https://www.tutorialspoint.com/swift/swift_optional_chaining.htm
        //        print("\(optionalString!)")
        //If you dont know the value can be nil or not than below is used if let and guard  (below is called optional binding)
        
        if let string = optionalString {
            print("\(string)")
           
        }
        
        guard let str = optionalString else {
            print("optional string is nil")
            return
        }
        print(str)
        
        //Array and for loop
        var array = ["B","A"]
        let myA = ["fs","f"]
        array.insert(contentsOf: myA, at: 1)
        
        for a in array {
            print("\(a)")
        }
    }
    deinit {
        // Additional deinit things can be done here
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

