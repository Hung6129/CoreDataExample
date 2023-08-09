//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Hưng Nguyễn on 09/08/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  private var model = [ToDoListItem]()
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let modelItem = model[indexPath.row]

    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    _ = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d yyyy, h:mm:ss a"
    let formattedDateInString = formatter.string(from: modelItem.createdAt!)
    print(formattedDateInString)
    cell.textLabel?.text = modelItem.name
    cell.detailTextLabel?.text = "Create at: " + formattedDateInString
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let modelItem = model[indexPath.row]
    let sheet = UIAlertController(title: "Edit", message: nil,preferredStyle: .actionSheet)
    sheet.addAction(UIAlertAction(title: "Edit", style: .default,handler: {_ in

      let alert = UIAlertController(title: "Edit item", message: "Edit your item", preferredStyle: .alert)
      alert.addTextField(configurationHandler: nil)
      alert.textFields?.first?.text = modelItem.name
      alert.addAction(
        UIAlertAction(title: "Update", style: .cancel,handler: {
          [weak self] _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
            return
          }
          self?.updateItems(item: modelItem, newName: text)
        }))
      self.present(alert, animated: true)
    }))
    sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: nil))
    sheet.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: {
      [weak self]  _ in self?.deleteItems(item: modelItem)
    }))

    present(sheet, animated: true)

  }




  let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  override func viewDidLoad() {

    super.viewDidLoad()

    title = "ToDoList"
    getAllItems()
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = view.bounds
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
  }

  @objc private func didTapAdd(){
    let alert = UIAlertController(title: "New item", message: "Enter new item",preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: "Submit", style: .cancel,handler: {
      [weak self] _ in guard let field = alert.textFields?.first, let text = field.text ,!text.isEmpty
      else {
        return
      }
      self?.createItems(name: text)
    }))
    present(alert, animated: true)
  }





  // Coredata logic
  func getAllItems()  {
    do{
      model = try contex.fetch(ToDoListItem.fetchRequest())
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }catch{

    }
  }

  func createItems(name:String)  {
    let newItem = ToDoListItem(context: contex)
    newItem.name = name
    newItem.createdAt = Date()
    do{
      try contex.save()
      getAllItems()
    }catch{

    }

  }
  func deleteItems(item:ToDoListItem)  {
    contex.delete(item)
    do{
      try contex.save()
      getAllItems()
    }catch{

    }

  }
  func updateItems(item:ToDoListItem,newName:String)  {
    item.name = newName
    do{
      try contex.save()
      getAllItems()
    }catch{

    }
  }

}

