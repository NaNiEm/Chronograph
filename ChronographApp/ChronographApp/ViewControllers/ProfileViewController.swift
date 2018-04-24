//
//  ProfileViewController.swift
//  ChronographApp
//
//  Created by Emily Garcia on 3/27/18.
//  Copyright © 2018 Nancy Gomez. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var profileRecent: UITableView!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var editPencilImg: UIImageView!
    
    var is_editing = false
    var recentStations: [Station] = []
    var refreshControl : UIRefreshControl!
    
    // Instantiate a UIImagePickerController
    var vc : UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ProfileViewController.didPullToReFresh(_:)), for: .valueChanged)
        profileRecent.insertSubview(refreshControl, at: 0)
        profileRecent.dataSource = self
        
        nameInput.isHidden = true
        nameInput.isUserInteractionEnabled = false
        nameInput.placeholder = "Name"
        
        locationInput.isHidden = true
        locationInput.isUserInteractionEnabled = false
        locationInput.placeholder = "Location"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLoadSetup()
        
    }
    
    func viewLoadSetup(){
        // setup view did load here
        self.profileRecent.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didPullToReFresh(_ refreshControl: UIRefreshControl){
        print("refreshed, stations: ", recentStations.count)
        self.profileRecent.reloadData()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentStations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as! StationCell
        
        let station = recentStations[indexPath.row]
        cell.nameLabel.text = station.name
        cell.addressLabel.text = station.address
        return cell
    }
    
    func canEdit() {
        // hide the static views
        profileName.isHidden = true
        profileLocation.isHidden = true
        
        // allow user to input info for name
        nameInput.isHidden = false
        nameInput.isUserInteractionEnabled = true
        nameInput.placeholder = profileName.text
        
        // allow user to input info for location
        locationInput.isHidden = false
        locationInput.isUserInteractionEnabled = true
        locationInput.placeholder = profileLocation.text
    }
    func cannotEdit() {
        // replace the static views
        if ((nameInput.text?.isEmpty)! || (locationInput.text?.isEmpty)!) {
            profileName.text = "Name"
            profileLocation.text = "Location"
        } else {
            profileName.text = nameInput.text
            profileLocation.text = locationInput.text
        }
        
        // show changed static views
        profileName.isHidden = false
        profileLocation.isHidden = false
        
        // hide the input views
        nameInput.isHidden = true
        nameInput.isUserInteractionEnabled = false
        locationInput.isHidden = true
        locationInput.isUserInteractionEnabled = false
    }
    func switchEditFlag() {
        // if edit is on, turn it off
        if (is_editing) {
            // visual and prgrammatic flags
            editPencilImg.alpha = 1
            is_editing = false
            cannotEdit()
        
        // if edit is off, turn it on
        } else {
            // visual and prgrammatic flags
            editPencilImg.alpha = 0.5
            is_editing = true
            canEdit()
        }
    }
    
    @IBAction func onEditTap(_ sender: Any) {
        switchEditFlag()
    }
    @IBAction func onImageTap(_ sender: Any) {
        chooseImage()
    }
    func chooseImage() {
        if (is_editing) {
            vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                print("Camera is available 📸")
                vc.sourceType = .camera
            } else {
                print("Camera 🚫 available so we will use photo library instead")
                vc.sourceType = .photoLibrary
            }
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    // helper function
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // Implement the delegate method
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = resize(image: originalImage, newSize: CGSize(width: 300, height: 300))
        
        // Do something with the images (based on your use case)
        profileImg.image = editedImage
        // TODO: set image view to edited image or something like that
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
    }

}
// helper
extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
