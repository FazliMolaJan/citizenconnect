//
//  ServicesViewController.swift
//  citizenconnect
//
//  Created by Shahzaib Shahid on 07/03/2018.
//  Copyright © 2018 cfp. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase
import  Popover

class ServicesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate{
    var layoutObjects = [Layout]()
    var pdfViewer: PdfViewer!
    var popover:Popover!
    fileprivate var texts = ["About us"]
    @IBOutlet weak var CollectionView: UICollectionView!
    var mSegue:UIStoryboardSegue!
    var SpinnerView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuButton = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: .plain, target: self, action: #selector(showMenu))
        menuButton.tintColor = UIColor.white
        let emergencyCallButton  = UIBarButtonItem(image: UIImage(named: "phone_filled"), style: .plain, target: self, action: #selector(emergencyCall))
        emergencyCallButton.tintColor = UIColor.white
        self.navigationItem.setRightBarButtonItems([menuButton, emergencyCallButton], animated: true)
        self.navigationItem.title = "Services"
         SpinnerView = UIViewController.displaySpinner(onView: self.view)
        Layout.getLayout(dataBaseReference: Firebase.Database.LayoutServices , Datatype: "services", completion: { (LayoutServices) in
            for layout in LayoutServices {
                self.layoutObjects.append(layout)
            }
            self.CollectionView.reloadData()
            UIViewController.removeSpinner(spinner: self.SpinnerView)
        }) { (error) in
            
        }
    }
    @objc func showMenu() ->Void {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width/2, height: 35))
        tableView.delegate = self
        tableView.dataSource = self
        let startPoint = CGPoint(x: self.view.frame.width - 10, y: 55)
        popover = Popover()
        popover.show(tableView, point: startPoint)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      mSegue = segue
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let servicesNC = mSegue.destination as! ServicesNC
        let servicesVC =  servicesNC.viewControllers.first as! PdfViewer
        servicesVC.stringPassed = layoutObjects[indexPath.row].name
        performSegue(withIdentifier: "showServices",
                     sender: self)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  22.5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2 - 5.0 , height: collectionViewSize/2 - 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LayoutServices", for: indexPath) as! LayoutServicesCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string: layoutObjects[indexPath.row].icon),placeholderImage:#imageLiteral(resourceName: "placeHolder"))
        cell.DataSetName.text = layoutObjects[indexPath.row].name
        cell.ViewBg.backgroundColor = UIColor(hexString: layoutObjects[indexPath.row].color)
        
        
        cell.backgroundColor = UIColor.white
        cell.contentView.layer.cornerRadius = 4.0
        
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    @objc func emergencyCall()->Void {
        performSegue(withIdentifier: "popUpEmergencyCalls", sender: self)
    }
    
}
extension ServicesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popover.dismiss()
         performSegue(withIdentifier: "aboutUs", sender: self)
    }
}

extension ServicesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
        return cell
    }
}
