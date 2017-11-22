//
//  EscuderiaTableViewController.swift
//  MotoGP
//
//  Created by Juan Rodríguez Baeza on 22/11/17.
//  Copyright © 2017 Juan Rodríguez Baeza. All rights reserved.
//

import UIKit
import CoreData

class EscuderiaTableViewController: UITableViewController {

    
    var listaEscuderias = [NSManagedObject]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(EscuderiaTableViewController.nuevaEscuderia))
    }
    
    func nuevaEscuderia(){
        
        let nuevaEscuderiaPopView = UIAlertController(title: "ESCUDERIAS", message: "dale un nombre al nuevo equipo", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            if let field = nuevaEscuderiaPopView.textFields![0] as? UITextField{
                self.guardarEscuderia(field.text!)
                self.tableView.reloadData()
                }
            
            }
        ))
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
        nuevaEscuderiaPopView.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "Nombre de la escuderia"
        })
        nuevaEscuderiaPopView.addAction(confirmAction)
        nuevaEscuderiaPopView.addAction(cancelAction)
        self.presentViewController(nuevaEscuderiaPopView, animated: true, completion: nil)
    }
    func guardarEscuderia(nuevaEscuderia: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entidadEscuderias = NSEntityDescription.entityForName("Escuderia", inManagedObjectContext: managedContext)
        let escuderia  = NSManagedObject(entity: entidadEscuderias!, insertIntoManagedObjectContext: managedContext)
        escuderia.setValue(nuevaEscuderia, forKey: "nombre")
        do{
            try managedContext.save()
            listaEscuderias.append(escuderia)
        }
        catch{
            print("error al guardar escuderia")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaEscuderias.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaDeEscuderia")! as UITableViewCell
        let item = listaEscuderias[indexPath.row]
        cell.textLabel?.text = item.valueForKey("nombre") as! String
        return cell
    }
    
    
}
