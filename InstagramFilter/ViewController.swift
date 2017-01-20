//
//  ViewController.swift
//  InstagramFilter
//
//  Created by Joe Wijoyo on 1/18/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var json: Array<Any>!
    
    var usernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for username in usernames {
            do {
                let requestString: String = "https://www.instagram.com/" + username + "/?__a=1"
                let requestURL: NSURL = NSURL(string: requestString)!
                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
                let session = URLSession.shared
                let task = session.dataTask(with: urlRequest as URLRequest) {
                    (data, response, error) -> Void in
                    
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        do{
                            
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                            
                            if let stations = json["stations"] as? [[String: AnyObject]] {
                                
                                for station in stations {
                                    
                                    if let name = station["stationName"] as? String {
                                        
                                        if let year = station["buildYear"] as? String {
                                            print(name,year)
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }catch {
                            print("Error with Json: \(error)")
                        }
                    }
                    
                }
                
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

