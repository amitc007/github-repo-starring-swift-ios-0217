//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    let gitAPIClient = GithubAPIClient()  //for testing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        } 
        
        print("In viewDidLoad")
        //let repoName = "OLI9292/swift-algorithm-club"
        //let repoName = "amitc007/swift-welcome-swift-intro-000"
        //gitAPIClient.checkIfRepositoryIsStarred(repoName, completion: { print("In viewDidLoad resp status:\($0)") } )
        
        //gitAPIClient.starRepository(named: repoName, completion: {print("completed func starRepository") })
        
        //gitAPIClient.unstarRepository(named: repoName, completion: {print("completed func unstarRepository") })

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var starred = false
        var msg = String()
        
        let gitRepo =  self.store.repositories[indexPath.row]
        
        //let myGroup = DispatchGroup()
        //myGroup.enter()
        store.toggleStarStatus(for: gitRepo) {
            starred = $0
            print("In didSelectRowAt:starred:\(starred)")
            if starred {
                msg = "You just starred \(gitRepo.fullName)"
            } else {
                msg = "You just unstarred \(gitRepo.fullName)"
            }

            //alertController
            
            OperationQueue.main.addOperation {
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "ok", style: .default, handler: nil )
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: {
                    self.accessibilityLabel = msg
                })
            }
           

            //myGroup.leave()
        } //store.toggleStarStatus
        
        
    } //func

    
}
