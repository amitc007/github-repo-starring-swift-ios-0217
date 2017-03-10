//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    func checkIfRepositoryIsStarred(_ repoFullName:String, completion:@escaping (Bool)->()) {
            //print("In checkIfRepositoryIsStarred")
            guard let url = URL(string: "\(githubAPIURL)/user/starred/\(repoFullName)?access_token=\(githubTok)") else { print("Invalid URL") ; return  }
       
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response ,error) in
//            print("data:\(data)")
//            print("response:\(response)")
//            print("error:\(error)")
            
            if let response = response as? HTTPURLResponse {
                print("In checkIfRepositoryIsStarred statusRes :\(response.statusCode)")
                if response.statusCode == 204 {
                    completion(true)
                } else {
                   completion(false)
                }
            }
            else { fatalError("Unable to get response \(error?.localizedDescription)" ) }

            
            }) //let task = URLSession.shared.dataTask
    
        task.resume()
    } //func checkIfRepositoryIsStarred
    
    //2. starRepository
    func starRepository(named:String, completion:@escaping ()->()) {
        
        //get the URL object
        guard let url = URL(string: "\(githubAPIURL)/user/starred/\(named)?access_token=\(githubTok)") else {
            print("Invalid URL");
            return
        }
        
        //create  URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        
        //call datatask
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response,error) in
            
                if let response = response as? HTTPURLResponse {
                    //print("In starRepository response:\(response)")
                    if response.statusCode == 204 {
                        print("In starRepository:Starred repository: \(named)")
                       completion()
                    } else {   //if could not Star repo
                        print("In starRepository: Could not star the repository: \(named)")
                    }
                    
                } else {   //if invalid response
                    fatalError("Unable to get response \(error?.localizedDescription)" )
                }  //else
            
            })
        task.resume()
        
    } //func starRepository
    
    //3. unstarRepository
    func unstarRepository(named:String, completion:@escaping ()->()) {
        //get the URL object
        guard let url = URL(string: "\(githubAPIURL)/user/starred/\(named)?access_token=\(githubTok)") else {
            print("Invalid URL");
            return
        }
        
        //create  URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        
        //call datatask
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response,error) in
            
            if let response = response as? HTTPURLResponse {
                //print("In unstarRepository response:\(response)")
                if response.statusCode == 204 {
                    print("In unstarRepository: Unstarred repository: \(named)")
                    completion()
                } else {   //if could not Star repo
                    print("In unstarRepository: Could not unstar the repository: \(named)")
                }
                
            } else {   //if invalid response
                fatalError("Unable to get response \(error?.localizedDescription)" )
            }  //else
            
        })
        task.resume()
        
    } //func unstarRepository
    
    //4.
    
}

