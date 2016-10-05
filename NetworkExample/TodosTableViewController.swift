//
//  TodosTableViewController.swift
//  NetworkExample
//
//  Created by Stannis Baratheon on 04/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class TodosTableViewController: UITableViewController {
    
    var apiUrl:String!
    var session:URLSession!
    var user:User!
    
    var todos = [Todo] ()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTodos()
        
    }
    
    private func getTodos() {
        let todosUrl = "\(apiUrl!)/todos?userid=\(user.id)"
        
        print(todosUrl)
        
        let url = URL(string: todosUrl)
        
        let todosTask = session.dataTask(with: url!) { (data, response, error) in
            
            do{
                let todosJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [Dictionary<String, Any>]
                // wanneer er zich een error voordoet, krijg je misschien geen data binnen, daarom !
                
                for item in todosJson{
                    let title = item["title"] as! String
                    print(title)
                    
                    let completed = item["completed"] as! Bool
                    
                    let todo = Todo()
                    todo.title = title
                    todo.completed = completed
                    
                    self.todos.append(todo)
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            }catch let error {
                print(error)
            }
        }
        todosTask.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)

        let todo = todos[indexPath.row]
        
        cell.textLabel?.text = todo.title
        if todo.completed {
        
            cell.accessoryType = .checkmark
        } else {
        
        
            cell.accessoryType = .none
        }
        
        
        
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
