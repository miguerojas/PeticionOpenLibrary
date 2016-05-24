//
//  BusquedaViewController.swift
//  Library
//
//  Created by MIGUEL on 23/05/16.
//  Copyright © 2016 Miguel Rojas. All rights reserved.
//

import UIKit

class BusquedaViewController: UIViewController {

    // ISBN del libro seleccionado
    var isbn = ""
    
    @IBOutlet weak var uiTextISBN: UITextField!
    @IBOutlet weak var uiButtonAdd: UIButton!
    @IBOutlet weak var Titulo: UITextField!
    @IBOutlet weak var Autores: UITextField!
    
  
  
   
    @IBOutlet weak var uiImageCover: UIImageView!
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view.
        if (self.isbn != "") {
            connectTo()
        }
        
        // ocultamos ISBN
        self.uiTextISBN.hidden = self.isbn != ""
        self.uiButtonAdd.hidden = self.isbn != ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func textFieldDoneEditing(sender : UIControl) {
        self.isbn = self.uiTextISBN.text!
        self.uiTextISBN.resignFirstResponder()
        
        // conectamos openlibrary.org
        connectTo()
}
    
    func connectTo() {
        
        let library = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
        let url = NSURL(string:"\(library)\(self.isbn)")
        
        let session = NSURLSession.sharedSession()
        let block = { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                if ((error?.code) != nil) {
                    let ac = UIAlertController(title: "ISBN", message: "Problemas al cargar openlibrary.org",
                                               preferredStyle: .Alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    
                    // mostramos mensaje de error
                    self.presentViewController(ac, animated: true, completion: nil)
                }
                
                if (data != nil) {
                    do {
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
                        let isbn = json as! NSDictionary
                        
                        if (isbn["ISBN:\(self.isbn)"] == nil) {
                            let ac = UIAlertController(title: "ISBN", message: "ISBN No Encontrado.",
                                                       preferredStyle: .Alert)
                            ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            
                            // mostramos mensaje de error
                            self.presentViewController(ac, animated: true, completion: nil)
                            
                            return
                        }
                        
                        if let title = (isbn["ISBN:\(self.isbn)"] as! NSDictionary)["title"] {
                            self.Titulo.text = title as! NSString as String
                            print(self.Titulo.text)
                        }
                        
                        if let authors = (isbn["ISBN:\(self.isbn)"] as! NSDictionary)["authors"] {
                            var tmp = ""
                            for author in authors as! NSArray {
                                tmp = tmp + (author["name"] as! NSString as String)
                            }
                            self.Autores.text = tmp
                        }
                        
                        if let cover = (isbn["ISBN:\(self.isbn)"] as! NSDictionary)["cover"] {
                            let url = cover["medium"] as! NSString as String
                            self.uiImageCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)
                        }
                        
                    } catch _ {
                        print("Error al acceder a los datos de openlibrary.org")
                    }
                }
            }
        }
        
        let dt = session.dataTaskWithURL(url!, completionHandler: block)
        dt.resume()
        
    }
    
}
