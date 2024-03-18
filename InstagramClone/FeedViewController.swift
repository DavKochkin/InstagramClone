//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by David Kochkin on 14.03.2024.
//

import UIKit
import Firebase


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var userEmailArray    = [String]()
    var userCommentlArray = [String]()
    var likeArray         = [Int]()
    var userImageArray    = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate   = self
        tableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error ) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentlArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        
                        
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text      = String(likeArray[indexPath.row])
        cell.commentLabel.text   = userCommentlArray[indexPath.row]
        cell.userImageView.image = UIImage(named: "select.png")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }

}
