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
    var picNodeArray = [picNode]()
    var postsToDisplay: [PostToDisplay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usernames = ["sallykim7","itsronayeh","haileesteinfeld"]

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
                                    if let nodes = media["nodes"] as? [[String: AnyObject]] {
                                        //dump(nodes)
                                        var maxLikeNode = nodes[0]
                                        for node in nodes {
                                            if (((node["likes"] as! [String: AnyObject])["count"] as! Int) > ((maxLikeNode["likes"] as! [String: AnyObject])["count"] as! Int)){
                                                maxLikeNode = node
                                            }
                                        }
                                        //print("win! " + String(user["username"] as! String) + "\n")
                                        let pNode = picNode(userName: user["username"] as! String, image: maxLikeNode["display_src"] as! String, likes: ((maxLikeNode["likes"] as! [String: AnyObject])["count"] as! Int), followers: ((user["followed_by"] as! [String: AnyObject])["count"] as! Int))
                                        self.picNodeArray.append(pNode)
                                        //print("size: " + String(picNodeArray.count))
                                        self.postsToDisplay.append(PostToDisplay(imageURL: pNode.image, user: pNode.userName, likes: pNode.likes, followers: pNode.followers))
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
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
        /*
        picNodeArray.sort{
            Double($0.likes)/Double($0.followers)*Double($0.likes) < Double($1.likes)/Double($1.followers)*Double($1.likes)
        }
        
        var count = 0
        for picNode in picNodeArray{
            print ("hey")
            //                        print(String(picNode.userName) + " ")
            //                        print("Followers: " + String(picNode.followers) + " ")
            //                        print("Likes: " + String(picNode.likes) + "\n")
            self.postsToDisplay.append(PostToDisplay(imageURL: picNode.image, user: picNode.userName, likes: picNode.likes, followers: picNode.followers))
            
            count += 1
            //self.imageView.image = picNode.image
            
            DispatchQueue.main.async {
                count += 1
                //self.imageView.image = picNode.image
                //self.tableView.reloadData()
            }
            //print(count)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }*/
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

