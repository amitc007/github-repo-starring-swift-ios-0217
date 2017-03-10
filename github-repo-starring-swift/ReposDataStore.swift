//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositories(with completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
        
    } //func getRepositories
    
    func toggleStarStatus(for repo:GithubRepository, completion:@escaping (_ starred:Bool)->()) {
        var isStarred = false
        let gitClient = GithubAPIClient()
        let myGroup = DispatchGroup()
        
        //myGroup.enter()    //to prevent async execution
        gitClient.checkIfRepositoryIsStarred(repo.fullName) {
            
            isStarred = $0
            print("In toggleStarStatus:isStarred:\(isStarred)")

            if isStarred {
                gitClient.unstarRepository(named: repo.fullName) {
                    print("unstarring \(repo.fullName)")
                    isStarred = false
                    completion(isStarred)
                }
                
            } else {
                gitClient.starRepository(named: repo.fullName) {
                    print("starring \(repo.fullName)")
                    isStarred = true
                    completion(isStarred)
                }
            }
            //myGroup.leave()

            

        } //gitClient.checkIfRepositoryIsStarred
        
        
        print("After checkIfRepositoryIsStarred")
        
    } //func toggleStarStatus

    
    
    
}
