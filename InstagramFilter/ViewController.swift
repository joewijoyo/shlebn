//
//  ViewController.swift
//  InstagramFilter
//
//  Created by Joe Wijoyo on 1/18/17.
//  Copyright © 2017 Joe Wijoyo. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    //var usernames = [String]()
    var postsToDisplay: [PostToDisplay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernames = ["sallykim7", "itsronayeh", "helloosandra"]
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
                            let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [String: Any]
                            
                            if let user = json?["user"] as? [String: Any] {
                                //dump(user)
                                if let media = user["media"] as? [String: AnyObject] {
                                    if let nodes = media["nodes"] as? [[String: AnyObject]]     {
                                        //dump(nodes)
                                        for node in nodes {
                                        self.postsToDisplay.append(PostToDisplay(user:user["username"] as! String, likes:(node["likes"] as! [String: AnyObject])["count"] as! Int, followers: (user["followed_by"] as! [String: AnyObject])["count"] as! Int))
                                                //print (user["username"])
                                            print ("Followers: " + String(((user["followed_by"] as! [String: AnyObject])["count"] as! Int)) + "\n")
                                            print ("Likes: " + String(((node["likes"] as! [String: AnyObject])["count"] as! Int)) + "\n")
                                            print (user["username"] as! String + "\n")
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
        let filteredCell = tableView.dequeueReusableCell(withIdentifier: "FilteredTableViewCell") as! FilteredTableViewCell
        
        let thisCellPost = postsToDisplay[indexPath.row]
        //filteredCell.cellImage =
        filteredCell.cellText.text = "User:" + thisCellPost.user + "\n" + String(thisCellPost.likes) + "\n" + String(thisCellPost.followers)

        return filteredCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsToDisplay.count
    }
}

