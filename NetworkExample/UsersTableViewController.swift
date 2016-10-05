//
//  UsersTableViewController.swift
//  NetworkExample
//
//  Created by Tywin Lannister on 04/10/16.
//  Copyright © 2016 Training. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var users = [User]() // lege array
    private let apiUrl:String = "https://jsonplaceholder.typicode.com"
    private var session:URLSession!
    @IBOutlet weak var refresh: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
        
        
        refresh.addTarget(self, action: #selector(getUsers), for: .valueChanged)
        
        getUsers()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getUsers(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let usersUrl = "\(apiUrl)/users"
        let url = URL(string: usersUrl)
        
        let usersTask = session.dataTask(with: url!) { (data, response, error) in
            
            do{
            let usersJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [Dictionary<String, Any>]
            // wanneer er zich een error voordoet, krijg je misschien geen data binnen, daarom !
            
                for item in usersJson{
                    let id = item["id"] as! Int
                    let name = item["name"] as! String
                    let email = item["email"] as! String
                    
                    let user = User()
                    user.id = id
                    user.name = name
                    user.email = email
                    
                    self.users.append(user)
                    
                    
                }
                
                DispatchQueue.main.async {
                    self.refresh.endRefreshing()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                
                }
                
            
            }catch let error {
                print(error)
            }
        }
        usersTask.resume()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)

        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userTodosSegue" {
        
            let controller = segue.destination as! TodosTableViewController
            controller.apiUrl = apiUrl
            controller.session = session
            
            let selectedCell = tableView.indexPathForSelectedRow
            
            let user = users[selectedCell!.row]
            
            
            controller.user = user
            
        
        }
        
        
        
    }
    

}
