//
//  LibroTableViewController.swift
//  Library
//
//  Created by MIGUEL on 23/05/16.
//  Copyright © 2016 Miguel Rojas. All rights reserved.
//

import UIKit

class LibroTableViewController: UITableViewController {

    var libros : Array<Array<String>> = Array<Array<String>>()
    
    @IBOutlet weak var uiTableLibros: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // inicializamos datos propios controlador
        self.title = "Lista Libros Seleccionados"
        
        // preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // display an Add button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add (+)", style: .Plain, target: self, action: #selector(LibroTableViewController.searchByISBN))
        
        // inicializamos lista de libros x defecto
     //   self.libros.append(["Cien años de soledad", "978-84-376-0494-7"])
       // self.libros.append(["The inside of the cup", "0665719140"])
        //self.libros.append(["The making of James Cameron's Titanic", "1557043647"])
        
        // recargamos tabla de libros
        self.uiTableLibros.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return self.libros.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)
        cell.textLabel?.text = self.libros[indexPath.row][0]
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let libroController = segue.destinationViewController as! BusquedaViewController
        libroController.isbn = ""
        if let index = self.uiTableLibros.indexPathForSelectedRow {
            libroController.isbn = self.libros[index.row][1]
        }
    }
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        let libroController = segue.sourceViewController as! BusquedaViewController
        self.libros.append([libroController.Titulo.text!, libroController.isbn])
        self.uiTableLibros.reloadData()
    }
    
    func searchByISBN() {
        performSegueWithIdentifier("LibroSegue", sender: self)
    }
    
}
