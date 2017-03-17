//
//  PhotoViewController.swift
//  HackerBooks
//
//  Created by Jose Javier Montes Romero on 17/3/17.
//  Copyright © 2017 Jose Javier Montes Romero. All rights reserved.
//

import UIKit
import CoreData


class PhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var pickerController: UIImagePickerController = UIImagePickerController()
    
    var aNote: Annotation?
    internal var context: NSManagedObjectContext?
    
    @IBOutlet weak var imagePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = aNote?.managedObjectContext
        if let imgageData = aNote?.photo?.data{
            imagePhoto.image = UIImage(data: imgageData as Data)
        }

        
    }

    @IBAction func changePhoto(_ sender: Any) {
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        // 2
        self.present(pickerController, animated: true, completion: nil)
    }

    @IBAction func closeView(_ sender: Any) {
        saveContext(context: context!)
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePhoto.image = image
        let photo = AnnotationPhoto(context: context!)
        photo.data = UIImagePNGRepresentation(image!) as NSData?
        aNote?.photo = photo

        self.dismiss(animated: true, completion: nil)
    }

}
