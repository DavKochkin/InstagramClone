//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by David Kochkin on 14.03.2024.
//

import UIKit
import FirebaseStorage


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer )
    }
    
    
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let imageReference = mediaFolder.child("image.jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                         
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            print(imageUrl)
                        }
                    }
                }
            }
        }
    }
    
}
