//
//  ViewController.swift
//  Task
//
//  Created by Sundeep on 11/12/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    // MARK: - Cell Identifier
    let postsCell = "PostsCell"
    
    // MARK: - Refreshing Object
    let refreshControl = UIRefreshControl()
    
    // MARK: - Respones Object
    var postResponseResult = [PostResponseResult]()
        
    var page = 1

    // MARK: - TableView Object
    lazy var postsTV:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = true
        table.backgroundColor = .clear
        table.isScrollEnabled = true
        table.delegate = self
        table.dataSource = self
        refreshControl.addTarget(self, action: #selector(postsRefreshAction), for: .valueChanged)
        table.refreshControl = refreshControl
        return table
    }()
    
    // MARK: - Count Button
    lazy var countBT : UIButton = {
        let ba = UIButton()
        ba.clipsToBounds = true
        ba.frame = CGRect(x: 0, y: 0, width: 100, height: 64)
        ba.setTitleColor(UIColor.white, for: .normal)
        return ba
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "POSTS"
        
        view.backgroundColor = .white
        
        view.addSubview(postsTV)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: countBT)

        
        postsTV.setAnchor(top: view.safeTopAnchor, left: view.safeLeftAnchor , bottom: view.safeBottomAnchor  , right: view.safeRightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        let url = ApiInterface.getPostsData+String(page)
        
        ApiService.callPost(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,finish: finishPost)

        
        registerCells()
        
    }
    
    // MARK: - Registering Table View Cell
    fileprivate func registerCells() {
        
        postsTV.estimatedRowHeight = 75
        postsTV.rowHeight = UITableView.automaticDimension
        postsTV.register(PostsCell.self, forCellReuseIdentifier: postsCell)
        
    }
    
    // MARK: - Api Calling Result
    func finishPost (message:String, data:Data? , tag: String) -> Void
    {
        do
        {
            if let jsonData = data
            {
                
                if tag == "getPosts" {
                    
                    refreshControl.endRefreshing()
                    
                    let parsedData = try JSONDecoder().decode(PostsResponse.self, from: jsonData)
                    print(parsedData)
                    
                    if parsedData.hits.count > 0{
                        
                        if page == 1 {
                            
                            postResponseResult.removeAll()
                            
                        }
                        
                        postResponseResult.append(contentsOf:parsedData.hits)
                        countBT.setTitle(String(postResponseResult.count), for: .normal)
                        postsTV.reloadData()
                    
                    }
                }
            }
            
        }
        catch
        {
        
            print("Parse Error: \(error)")
            
        }
    }
    
    // MARK: - Page Refreshing
    @objc func postsRefreshAction(){
        
        page = 1
        
        let url = ApiInterface.getPostsData+String(page)

        ApiService.callPost(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,finish: finishPost)
        
    }
    
    
    // MARK: - Table View Datasource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postResponseResult.count
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTV.dequeueReusableCell(withIdentifier: postsCell, for: indexPath) as! PostsCell
        
        let index = postResponseResult[indexPath.row]

        cell.postResponseResult = index
    
        if indexPath.row == postResponseResult.count-1 {
            
            lodeMoreData()
            
        }
    
        return cell
        
    }
    
    // MARK: - Pagenation
    func lodeMoreData(){

        page = page+1
        
        let url = ApiInterface.getPostsData+String(page)
        
        ApiService.callPost(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,finish: finishPost)

        
    }
    
}

