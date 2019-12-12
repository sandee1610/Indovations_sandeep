//
//  PostsCell.swift
//  Task
//
//  Created by Sundeep on 11/12/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

class PostsCell: UITableViewCell {
    
    // MARK: - Parsing Data
    var postResponseResult: PostResponseResult! {
        didSet {
            
            
            let attributedText = NSMutableAttributedString(string: postResponseResult.title ?? "" , attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black])
            
            let getDate = UtilityCode.convertDateFormater(postResponseResult.created_at ?? "")
            
            attributedText.append(NSAttributedString(string: "\n\n\(getDate)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
            
            contentLBL.attributedText = attributedText
            
        }
    }

    // MARK: - cell View Object
    let view: UIView = {
        let view = UIView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.setCellShadow()
        return view
    }()
    
    // MARK: - content UiLabel
    let contentLBL: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.boldSystemFont(ofSize: 20.0)
        lb.textAlignment = .left
        lb.backgroundColor = .clear
        lb.textColor = .black
        lb.numberOfLines = 0 
        return lb
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(view)
        view.addSubview(contentLBL)
        
        view.setAnchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
                
        contentLBL.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
