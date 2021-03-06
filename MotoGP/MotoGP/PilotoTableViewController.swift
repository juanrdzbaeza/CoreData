//
//  PilotoTableViewController.swift
//  MotoGP
//
//  Created by Juan Rodríguez Baeza on 22/11/17.
//  Copyright © 2017 Juan Rodríguez Baeza. All rights reserved.
//

import UIKit
import CoreData

class PilotoTableViewController: UITableViewController {
    
    var escuderia: Escuderia?
    
    var listaPilotos = [Piloto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(self.nuevoPiloto)
        )

    }// fin de viewDidLoad(_:)
    
    /*
     *
     */
    func nuevoPiloto() {
        let nuevoPilotoPopView   = UIAlertController(title: "PILOTOS", message: "dale un nombre al nuevo piloto", preferredStyle: .Alert)
        let confirmAction           = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            /*
             *
             */
            if let campoTexto = nuevoPilotoPopView.textFields![0] as? UITextField{
                self.guardarPiloto(campoTexto.text!)
                self.tableView.reloadData()
                }
            }
        ))
        let cancelAction            = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
        nuevoPilotoPopView.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder   = "Nombre del piloto"
        })
        nuevoPilotoPopView.addAction(confirmAction)
        nuevoPilotoPopView.addAction(cancelAction)
        self.presentViewController(nuevoPilotoPopView, animated: true, completion: nil)
    }// fin de la funcion nuevoPiloto(_:)
    
    /*
     * La unica diferencia de esta funcion con la de guardarEscuderia(_:) es que al asignar el 
     * nombre pasado por parametro al nuevo piloto, justo despues le asignamos su escuderia,
     * que es la que hemos enviado a traves del segue desde EscuderiaTableViewController
     *
     */
    func guardarPiloto(nuevoPiloto: String) {
        let appDelegate         = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext      = appDelegate.managedObjectContext
        let entidadPilotos      = NSEntityDescription.entityForName("Piloto", inManagedObjectContext: managedContext)
        let piloto              = Piloto(entity: entidadPilotos!, insertIntoManagedObjectContext: managedContext)
        piloto.setValue(nuevoPiloto, forKey: "nombre")
        // asignamos la escuderia al piloto
        piloto.escuderia = self.escuderia
        do{
            try managedContext.save()
            listaPilotos.append(piloto)
        }
        catch{
            print("error al guardar piloto")
        }
    }// fin de la funcion guardarPiloto(_:)
    
    /*
     * En esta funcion se recogen los pilotos de a base de datos, pero a diferencia de 
     * lo que hacemos en EscuderiaTableViewController.viewWillAppear(_:), la listaPilotos
     * la llenamos solo con los pilotos cuya escuderia coincida con la de la variable global,
     * puesto que son esos los que queremos mostrar.
     */
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Piloto")
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for p in results {
                if (p.escuderia === self.escuderia){
                    listaPilotos.append(p as! Piloto)
                }
            }
        }
        catch{
            print("error al cargar pilotos de la base de datos")
        }
    }// fin de la funcion viewWillAppear(_:)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaPilotos.count
    }
    /*
     *
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celdaDePiloto") as! PilotoTableViewCell
        let piloto = listaPilotos[indexPath.row]
        cell.etiquetaNombrePiloto.text = (piloto.valueForKey("nombre") as! String)
        return cell
    }
    
   /*
    *
    */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete { return }
        let appDelegate         = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext      = appDelegate.managedObjectContext
        managedContext.deleteObject(listaPilotos[indexPath.row])
        listaPilotos.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
    }

}
