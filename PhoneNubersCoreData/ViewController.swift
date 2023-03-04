//
//  ViewController.swift
//  PhoneNubersCoreData
//
//  Created by Irakli Nozadze on 19.12.22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Declaration
    private var models = [PhoneNumbersListItem]()
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllItems()
        title = "Your Phone Numbers"
        let nib = UINib(nibName: "PhoneNumberTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PhoneNumberTableViewCell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd() {
        let alertController = UIAlertController(title: "New Item",
                                                message: "Enter new item",
                                                preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Person's Name"
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Phone Number"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let firstTextField = alertController.textFields![0] as UITextField?, let personsName = firstTextField.text, !personsName.isEmpty,
                    let secondTextField = alertController.textFields![1] as UITextField?, let phoneNumber = secondTextField.text, !phoneNumber.isEmpty else {
                return
            }
            
            self?.createItem(personsName: personsName, phoneNumber: phoneNumber)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) -> Void in
        })
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    //    MARK: Core Data
    func saveContext() {
        do {
            try context.save()
            getAllItems()
        } catch {
            print("context could not be saved")
        }
    }
    
    func getAllItems() {
        do {
            models = try context.fetch(PhoneNumbersListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("could not fetch context")
        }
    }
    
    func createItem(personsName: String, phoneNumber: String) {
        let newItem = PhoneNumbersListItem(context: context)
        newItem.personsName = personsName
        newItem.phoneNumber = phoneNumber
        
        saveContext()
    }
    
    func deleteItem(item: PhoneNumbersListItem) {
        context.delete(item)
        
        saveContext()
    }
    
    func updateItem(item: PhoneNumbersListItem, newPersonsName: String, newPhoneNumber: String) {
        item.personsName = newPersonsName
        item.phoneNumber = newPhoneNumber
        
        saveContext()
    }
    
    func updateItemName(item: PhoneNumbersListItem, newPersonsName: String) {
        item.personsName = newPersonsName
        
        saveContext()
    }
    
    func updateItemPhoneNumber(item: PhoneNumbersListItem, newPhoneNumber: String) {
        item.phoneNumber = newPhoneNumber
        
        saveContext()
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneNumberTableViewCell",
                                                 for: indexPath) as! PhoneNumberTableViewCell
        cell.nameLabel.text = model.personsName
        cell.PhoneNumberLabel.text = model.phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        let sheet = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alertController = UIAlertController(title: "Edit",
                                                    message: "Edit your item",
                                                    preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter Person's New Name"
            }
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter New Phone Number"
            }
            let saveAction = UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let firstTextField = alertController.textFields![0] as UITextField?, let newPersonsName = firstTextField.text,
                        let secondTextField = alertController.textFields![1] as UITextField?, let newPhoneNumber = secondTextField.text else {
                    return
                }
                
                if newPersonsName.isEmpty {
                    self?.updateItemPhoneNumber(item: item, newPhoneNumber: newPhoneNumber)
                } else if newPhoneNumber.isEmpty {
                    self?.updateItemName(item: item, newPersonsName: newPersonsName)
                } else {
                    self?.updateItem(item: item, newPersonsName: newPersonsName, newPhoneNumber: newPhoneNumber)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) -> Void in })
                
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        self.present(sheet, animated: true)
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

}

