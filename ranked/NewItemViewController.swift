//
//  NewItemViewController.swift
//  ranked
//
//  Created by Victor Zag on 3/12/17.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit
import CoreLocation

class NewItemViewController: UIViewController, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var FieldTitle: UITextField!
    @IBOutlet weak var FieldAuthor: UITextField!
    @IBOutlet weak var DropDown: UIPickerView!
    @IBOutlet weak var SelectedImageView: UIImageView!
    
    let locationManager = CLLocationManager();
    
    var list = PostModel.categoriesNames
    var selectedCategory: String = "";
    var UserLongitude: Double = 0;
    var UserLatitude: Double = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedCategory = self.list[0];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization();
        self.locationManager.startUpdatingLocation();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return list.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true);
        return list[row];
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.list[row];
    }
    
    @IBAction func ImportImage(_ sender: UIButton) {
        let image = UIImagePickerController();
        image.delegate = self;
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        image.allowsEditing = false;
        self.present(image, animated: true);
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.SelectedImageView.image = image;
        }
        else{
            print("could not import image, sry :(");
        }
        self.dismiss(animated: true, completion: nil);
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0];
        self.UserLatitude = location.coordinate.latitude;
        self.UserLongitude = location.coordinate.longitude;
    }
    @IBAction func ClearField(_ sender: UIButton) {
        self.FieldTitle.text = "";
        self.FieldAuthor.text = "";
        self.SelectedImageView.image = nil;
    }
    @IBAction func SaveNewItem(_ sender: UIButton) {
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        let uploadDate = dateFormatter.string(from: date)

        
        let image = self.SelectedImageView.image;
        let imagename = self.FieldTitle.text! + uploadDate + ".jpg";
        PostModel.instance.saveImage(image: image!, name: imagename, callback: {(url)  in
            let picture = url
            
            
            
            let autherNick = self.FieldAuthor.text
            let titel = self.FieldTitle.text
            let id = autherNick! + uploadDate
            let newPost = Post(id: id, category: self.selectedCategory, authorNickname: autherNick!, picture: picture!, title: titel!, uploadDate: uploadDate, latitude: self.UserLatitude, longitude: self.UserLongitude, lastUpdate:date, comments: [])
            
            PostModel.instance.addPost(post: newPost)

            let addedAlert = UIAlertController(title: "Saved", message: "Add item successful", preferredStyle: .alert)
            addedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(addedAlert, animated: true, completion: nil)
        })
        
    }
}
