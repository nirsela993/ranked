//
//  CategoriesViewController.swift
//  ranked
//
//  Created by macDevMachinVB on 11/03/2017.
//  Copyright © 2017 Nir Sela. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var categorieNames: [String] = ["Funny","Food","Cute","WTF","Funny","Food","Cute","WTF"]
    var categoryImages: [String] = ["Funny.png","food.png","cute.png","wtf.png","Funny.png","food.png","cute.png","wtf.png"]
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categorieNames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCategory", for: indexPath) as! CategoryCell

        cell.cellLable.text = self.categorieNames[indexPath.row]
        
        cell.cellImage.image =  UIImage(named: self.categoryImages[indexPath.row])
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selcted \(self.categorieNames[indexPath.row] )")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "categoryPageSelection"){
            (segue.destination as! categoryView).categoryName = (sender as! CategoryCell).cellLable.text
            
        }
    }
    

}
