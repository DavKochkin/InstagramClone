//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by David Kochkin on 14.03.2024.
//

import UIKit
import Firebase
import SDWebImage
import OneSignalFramework


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var userEmailArray    = [String]()
    var userCommentArray = [String]()
    var likeArray         = [Int]()
    var userImageArray    = [String]()
    var documentIdArray   = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tableView.delegate   = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        // PUSH Notification

        let externalId = "8cc2ab29-a515-45e6-977e-55b456ac3e61"
        OneSignal.login(externalId)
    }
    
    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error ) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
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
        cell.userEmailLabel.text  = userEmailArray[indexPath.row]
        cell.likeLabel.text       = String(likeArray[indexPath.row])
        cell.commentLabel.text    = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row ]))
        cell.documentidLable.text = documentIdArray[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }

}
