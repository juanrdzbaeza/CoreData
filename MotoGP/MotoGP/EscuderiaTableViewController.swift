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

    
    var listaEscuderias = [Escuderia]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // boton izquierdo de la barra de navegacion para entrar en modo de edicion de tabla
        navigationItem.leftBarButtonItem = editButtonItem()
        /*
         * Añadimos programáticamente un boton para que nos va a permitir abrir una ventana emergente
         * que contendrá un campo de texto donde poder escribir el nombre del objeto, y dos botones
         * uno para cancelar la accion y otro para llevarla a cabo. en el atributo "action" le decimos
         * donde comienza la accion programada para guardar el objeto nuevaEscuderia(_:)
         *
         *      action: #selector(EscuderiaTableViewController.nuevaEscuderia)
         */
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(EscuderiaTableViewController.nuevaEscuderia)
        )
    }//  fin de viewDidLoad(_:)
    /*
     * Esta funcion se encarga de crear la ventana emergente que nos permite introducir un nombre a
     * traves de un campo de texto.
     * - nuevaEscuderiaPopView es la propia ventana declarada como un UIAlertController.
     * - confirmAction es la accion para confirmar la acción que se desea realizar.
     * - cancelAction es la accion para cancelar la acción.
     *
     */
    func nuevaEscuderia(){
        let nuevaEscuderiaPopView   = UIAlertController(title: "ESCUDERIAS", message: "dale un nombre al nuevo equipo", preferredStyle: .Alert)
        let confirmAction           = UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            /*
             * dentro de la accion para confirmar esta contenida la llamada a la funcion que guarda
             * la información en la base de datos, guardarEscuderia(_:), a la cual le pasamos como
             * parametro lo que haya escrito en el campo de texto campoTexto, despues recargamos
             * la vista de la tabla.
             */
            if let campoTexto = nuevaEscuderiaPopView.textFields![0] as? UITextField{
                self.guardarEscuderia(campoTexto.text!)
                self.tableView.reloadData()
                }
            }
        ))
        let cancelAction            = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler: nil)
        nuevaEscuderiaPopView.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder   = "Nombre de la escuderia"
        })
        nuevaEscuderiaPopView.addAction(confirmAction)
        nuevaEscuderiaPopView.addAction(cancelAction)
        self.presentViewController(nuevaEscuderiaPopView, animated: true, completion: nil)
    }// fin de la funcion nuevaEscuderia(_:)
    
    /*
     * La función guardarEscuderia(_:) recibe el nombre del equipo como parametro String.
     *
     *
     */
    func guardarEscuderia(nuevaEscuderia: String) {
        let appDelegate         = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext      = appDelegate.managedObjectContext
        let entidadEscuderias   = NSEntityDescription.entityForName("Escuderia", inManagedObjectContext: managedContext)
        let escuderia           = Escuderia(entity: entidadEscuderias!, insertIntoManagedObjectContext: managedContext)
        escuderia.setValue(nuevaEscuderia, forKey: "nombre")
        do{
            try managedContext.save()
            listaEscuderias.append(escuderia)
        }
        catch{
            print("error al guardar escuderia")
        }
    }// fin de la funcion guardarEscuderia(_:)
    
    /*
     * La función viewWillAppear(_:) es ejecutada al aparecer la vista, por lo que es perfecta
     * para asignarle la funcion de consultar la base de datos y extraer la información necesaria
     * después la almacena en el array de clase listaEscuderias[], este array será luego consultado
     * y llenara la tabla listando la información que contenga.
     */
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Escuderia")
        do{
            let results = try managedContext.executeFetchRequest(fetchRequest)
            listaEscuderias = results as! [Escuderia]
        }
        catch{
            print("error al cargar escuderias de la base de datos")
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
        return listaEscuderias.count
    }
    /*
     * En esta función se consulta el contenido de listaEscuderias[] y se asigna a cada celda de
     * la tabla un valor de su contenido.
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell                            = tableView.dequeueReusableCellWithIdentifier("celdaDeEscuderia") as! EcuderiaTableViewCell
        let escuderia                       = listaEscuderias[indexPath.row]
        cell.etiquetaNombreEscuderia.text   = escuderia.valueForKey("nombre") as! String
        return cell
    }
    /*
     * En esta función se controla el modo de edicion de tabla, de forma que si se selecciona una
     * de las filas de la tabla nos muestra el boton para eliminarla, al pulsarlo desencadena
     * la accion de borrado de la base de datos
     */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != .Delete { return }
        let appDelegate         = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext      = appDelegate.managedObjectContext
        managedContext.deleteObject(listaEscuderias[indexPath.row])
        listaEscuderias.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
    }// fin de Table view data source
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != "DetalleEscuderia" {return}
        let celdaRef            = sender as! EcuderiaTableViewCell
        let destino             = segue.destinationViewController as! PilotoTableViewController
        let filaSeleccionda     = tableView.indexPathForCell(celdaRef)
        destino.escuderia       = listaEscuderias[(filaSeleccionda?.row)!]
    }
 
}







































