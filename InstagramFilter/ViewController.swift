//
//  ViewController.swift
//  InstagramFilter
//
//  Created by Joe Wijoyo on 1/18/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved. WOWOOWOWOWOWOWO
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    //var usernames = [String]()
    var postsToDisplay: [PostToDisplay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFromUsernames()
        loadFromTags()
    }
    
    func loadFromTags() {
        let tags = ["thehiddenmug"]
        
        for tag in tags {
            let requestString: String = "https://www.instagram.com/explore/tags/" + tag + "/?__a=1"
            let requestURL: NSURL = NSURL(string: requestString)!
            let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
            let session = URLSession.shared
            let task = session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
                        
                        if let tag = json?["tag"] as? [String: Any] {
                            //dump(user)
                            if let top_posts = tag["top_posts"] as? [String: AnyObject] {
                                if let nodes = top_posts["nodes"] as? [[String: AnyObject]]     {
                                    //dump(nodes)
                                    for node in nodes {
                                        
                                        let imageURL = node["display_src"] as! String
                                        let user = tag["username"] as! String
                                        let likes = (node["likes"] as! [String: AnyObject])["count"] as! Int
                                        let followers = ((tag["followed_by"] as! [String: AnyObject])["count"] as! Int)
                                        
                                        self.postsToDisplay.append(PostToDisplay(imageURL: imageURL, user:user, likes: likes, followers: followers))
                                       
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func numFollowers(username: String) -> String {
        
    }
    
    func getUserFromCode(code: String) -> String {
        var user: String!
        let requestString: String = "https://www.instagram.com/p/" + code + "/?__a=1"
        let requestURL: NSURL = NSURL(string: requestString)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
                    
                    if let media = json?["media"] as? [String: Any] {
                        //dump(user)
                        if let owner = media["owner"] as? [String: AnyObject] {
                            user = owner["username"] as? String
                        }
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
        return user
    }
    
    func loadFromUsernames() {
        let usernames = ["sallykim7", "itsronayeh", "helloosandra"]
        
        for username in usernames {
                let requestString: String = "https://www.instagram.com/" + username + "/?__a=1"
                let requestURL: NSURL = NSURL(string: requestString)!
                let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
                let session = URLSession.shared
                let task = session.dataTask(with: urlRequest as URLRequest) {
                    (data, response, error) -> Void in
                    
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
                            
                            if let user = json?["user"] as? [String: Any] {
                                //dump(user)
                                if let media = user["media"] as? [String: AnyObject] {
                                    if let nodes = media["nodes"] as? [[String: AnyObject]]     {
                                        //dump(nodes)
                                        for node in nodes {
                                            self.postsToDisplay.append(PostToDisplay(imageURL: node["display_src"] as! String, user:user["username"] as! String, likes:(node["likes"] as! [String: AnyObject])["count"] as! Int, followers: (user["followed_by"] as! [String: AnyObject])["count"] as! Int))
                                            //print (user["username"])
                                            print ("Followers: " + String(((user["followed_by"] as! [String: AnyObject])["count"] as! Int)) + "\n")
                                            print ("Likes: " + String(((node["likes"] as! [String: AnyObject])["count"] as! Int)) + "\n")
                                            print (user["username"] as! String + "\n")
                                            DispatchQueue.main.async {
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                }
                            }
                        } catch {
                            print("Error with Json: \(error)")
                        }
                    }
                }
                task.resume()
        }
    }
    /*
    func downloadImage(url: URL) {
        //print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            //print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filteredCell = tableView.dequeueReusableCell(withIdentifier: "FilteredTableViewCell", for: indexPath) as! FilteredTableViewCell
        
        let thisCellPost = postsToDisplay[indexPath.row]
        //filteredCell.cellImage =
        filteredCell.cellText.text = "User:" + thisCellPost.user + "\nLikes:" + String(thisCellPost.likes) + "\nFollowers:" + String(thisCellPost.followers)
        filteredCell.imageView?.setImageFromURL(stringImageUrl: thisCellPost.imageURL!)

        return filteredCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsToDisplay.count
    }
}

extension UIImageView {
    func setImageFromURL(stringImageUrl url: String){
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

