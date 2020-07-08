//
//  ViewController.swift
//  Convertly
//
//  Created by Mohammad Elhinamy on 12/2/17.
//  Copyright © 2017 Mohammad Elhinamy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    var responseData=[String:AnyObject]()
    
    //@IBOutlet weak var StartShopping: UIButton!
    @IBOutlet weak var BotMsg: UILabel!
    var flagWelcome:Bool!
    
    
    
    
    
    @IBOutlet weak var BotMsg2: UILabel!
    @IBOutlet weak var userMessage: UILabel!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var Rates: UIButton!
    
    
    var labelY=40;
    
    
    
    @IBOutlet weak var Send: UIButton!
    
    
    
    @IBAction func Please() {
        
        
        var request = URLRequest(url: URL(string: "https://convertly1.herokuapp.com/rates")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                //                    self.responseData["message"] = responseJson["message"]
                print(responseJSON)
                let label = UILabel(frame: CGRect(x: 43, y: self.labelY, width: 290, height: 111))
                label.backgroundColor = UIColor(red: 69/255, green: 125/255, blue: 53/255, alpha: 1.0)
                label.layer.cornerRadius=5;
                label.clipsToBounds=true;
                label.font = UIFont(name: "Times New Roman", size: 16)
                label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                label.numberOfLines = 0
                self.labelY+=120
                label.text=(responseJSON["message"] as? String)?.replacingOccurrences(of: "AHMED", with: "\n")
                
                
                label.sizeToFit()
                
                label.font = UIFont(name: "Times New Roman", size: 12)
                label.textAlignment = .center;
                self.ScrollView.addSubview(label)
                
            }
            
        }
        
        
        
        task.resume()
        
        
        
    }
    @IBAction func SendToApi() {
        
        
        print("INPUT MESSAGE")
        print(userInput.text)
        let label = UILabel(frame: CGRect(x: 250, y: labelY, width: 290, height: 70))
        label.backgroundColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.layer.cornerRadius=5;
        label.clipsToBounds=true;
        label.font = UIFont(name: "Times New Roman", size: 16)
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        
        labelY+=30
        
        label.text=self.userInput.text
        label.sizeToFit()
        
        label.font = UIFont(name: "Times New Roman", size: 12)
        
        label.textAlignment = .center;
        self.ScrollView.addSubview(label)
        
        
        self.ScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
        
        
        let paramters=["uuid":self.responseData["uuid"] as! String,"message":self.userInput.text!] as [String : String]
        guard let url = URL(string: "https://convertly1.herokuapp.com/chat") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.responseData["uuid"] as! String, forHTTPHeaderField: "Authorization")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: paramters, options:[]) else {return}
        request.httpBody = httpBody
        self.userInput.text=""
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let data=data{
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as![String:AnyObject]
                    if((responseJson["error"]) != nil){
                        print(responseJson["error"])
                        let label = UILabel(frame: CGRect(x: 43, y: self.labelY, width: 290, height: 111))
                        label.backgroundColor = UIColor(red: 209/255, green: 55/255, blue: 53/255, alpha: 1.0)
                        label.layer.cornerRadius=5;
                        label.clipsToBounds=true;
                        label.font = UIFont(name: "Times New Roman", size: 16)
                        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                        label.numberOfLines = 0
                        self.labelY+=30
                        label.text=responseJson["error"] as? String
                        label.sizeToFit()
                        
                        label.font = UIFont(name: "Times New Roman", size: 12)
                        label.textAlignment = .center;
                        self.ScrollView.addSubview(label)
                        //                        self.scrolling.addSubview(label)
                        self.ScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
                        
                    }else{
                        self.responseData["message"] = responseJson["message"]
                        print(self.responseData)
                        let label = UILabel(frame: CGRect(x: 43, y: self.labelY, width: 290, height: 111))
                        label.backgroundColor = UIColor(red: 69/255, green: 125/255, blue: 53/255, alpha: 1.0)
                        label.layer.cornerRadius=5;
                        label.clipsToBounds=true;
                        label.font = UIFont(name: "Times New Roman", size: 16)
                        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                        label.numberOfLines = 0
                        self.labelY+=50
                        label.text=self.responseData["message"] as? String
                        label.sizeToFit()
                        
                        label.font = UIFont(name: "Times New Roman", size: 12)
                        label.textAlignment = .center;
                        self.ScrollView.addSubview(label)
                        //                        self.scrolling.addSubview(label)
                        self.ScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
                    }
                }catch {
                    print("Ahmed")
                    print (error)
                }
            }
            }.resume()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScrollView.contentSize=CGSize(width: 400, height: 1300)
        view.addSubview(ScrollView)
        //        ScrollView.addSubview(scrolling)
        
        self.Send.isHidden=true;
        self.Rates.isHidden = true;
        userInput.isHidden=true;
        //    self.Loading.isHidden=true
        
        //         StartShopping.isHidden=true;
        let url=URL(string:"https://convertly1.herokuapp.com/welcome")
        URLSession.shared.dataTask(with: url!, completionHandler:{
            (data,response , error)in
            if(error != nil){
                print("Ahmed")
                
                print(error.debugDescription)
            }
                
                
            else{
                do{
                    self.responseData=(try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as![String:AnyObject])
                    self.flagWelcome=true
                    //                    self.Loading.isHidden=true
                    //                    self.StartShopping.isHidden=false
                    print(self.responseData)
                    
                    //                    self.StartShopping.isHidden=true;
                    //BotMsg.isHidden=false;
                    //BotMsg.backgroundColor=UIColor(patternImage: UIImage(named:"welcome.png")!)
                    print((self.responseData["message"]) as! String)
                    // BotMsg.text = self.responseData["message"] as? String
                    let label = UILabel(frame: CGRect(x: 43, y: self.labelY, width: 290, height: 111))
                    label.backgroundColor = UIColor(red: 69/255, green: 125/255, blue: 53/255, alpha: 1.0)
                    label.layer.cornerRadius=5;
                    label.clipsToBounds=true;
                    label.font = UIFont(name: "Times New Roman", size: 16)
                    label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
                    label.numberOfLines = 0
                    self.labelY+=30
                    
                    label.text=(self.responseData["message"] as? String)?.replacingOccurrences(of: "<br>", with: "\n")
                    label.sizeToFit()
                    
                    label.font = UIFont(name: "Times New Roman", size: 12)
                    label.textAlignment = .center;
                    self.ScrollView.addSubview(label)
                    //                    self.scrolling.addSubview(label)
                    self.ScrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
                    
                    
                    self.Send.isHidden=false
                    self.userInput.becomeFirstResponder();
                    self.userInput.isHidden=false
                    self.Rates.isHidden=false
                    
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //
        //          ScrollView.addGesMessageCeller(tap)
        
        
        
        
    }
    
    
    
    func keyboardWillShow(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y == 0 {
                
                //            ScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 200)
                
                
                self.view.frame.origin.y -= keyboardSize.height
                self.ScrollView.frame = CGRect(x:16,y:130,width:343,height:250);
            }
        }
    }
    
    func keyboardWillHide(notify: NSNotification) {
        
        if let keyboardSize = (notify.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0 {
                
                self.view.frame.origin.y = 0
                self.ScrollView.frame = CGRect(x:16,y: 130,width: 343,height:400);
                
            }
        }
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userInput.becomeFirstResponder();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}

