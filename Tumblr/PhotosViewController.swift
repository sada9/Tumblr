//
//  PhotosViewController.swift
//  Tumblr
//
//  Created by Pattanashetty, Sadananda on 3/29/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource {

    var posts: [NSDictionary]?
    var selectedCell: PhotoCell?

    @IBOutlet weak var tumblrTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDataRequest()
        NSLog("")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "com.tumblr.cell", for: indexPath) as! PhotoCell



        if let posts = self.posts {

            cell.userId.text = posts[indexPath.row]["blog_name"] as! String

            cell.avatarImg.setImageWith(URL(string: "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50")!)

            if let photos = posts[indexPath.row]["photos"] as? [NSDictionary] {
                if let photoSizes = photos[0]["original_size"] as? NSDictionary {
                    let imgUrl = photoSizes["url"] as! String
                    cell.mainImageURL = imgUrl
                    cell.mainImage.setImageWith((URL(string: imgUrl)!))
                }
            }
        }
        return cell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.posts {
            return posts.count
        }
        return 0

    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let cell = sender as! PhotoCell

        let destination = segue.destination as! PhotoDetailsViewController
        destination.url = cell.mainImageURL
    }




    func makeDataRequest() {

        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )

        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")

                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary

                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tumblrTableView.reloadData()
                    }
                }
        });
        task.resume()
    }

}

class PhotoCell: UITableViewCell {

    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!

    var mainImageURL: String?
}


