![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

### Introduction to CoreData
CoreData is a framework provided by Apple that allows you to work with data models, and it abstracts the underlying database operations. It is commonly used to manage the model layer of an application and provides features like object relationships, caching, and undo management.


### Sample To-Do List Application
Check out the included sample To-Do List application in this repository. It demonstrates the concepts described above and provides a practical example of using CoreData in a real application.


### Creating, Reading, Updating, and Deleting Data

``` swift
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
```
