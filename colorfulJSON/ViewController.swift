//
//  ViewController.swift
//  colorfulJSON
//
//  Created by Roman on 7/5/17.
//  Copyright © 2017 Swift Solutions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let cellId = "CellId"
var colors = [UIColor]()
var redColor, greenColor, blueColor: CGFloat!
var rgb: String!
var rgbs = [String]()
var color:UIColor!

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Nav bar title
        self.navigationItem.title = "Colorful JSON"
        
        //register class for dequeueReusableCell
        tableView.register(ColorCell.self, forCellReuseIdentifier: cellId)
        
        //Alamofire
        Alamofire.request("https://jsonplaceholder.typicode.com/todos").responseJSON(completionHandler: { (response) in
            
            if let value = response.result.value {
                let json = JSON(value)
                
                let array = json.array
                
                for userJson in array! {
                    print (userJson["id"].intValue)
                    
                    //Generating RGB
                    redColor = CGFloat((userJson["id"].intValue)*2)/255.0
                    greenColor = CGFloat((userJson["id"].intValue)*1)/255.0
                    blueColor = CGFloat((userJson["id"].intValue)*3)/255.0
                    
                    //Generating Color
                    color = UIColor.init(red:redColor, green: greenColor, blue:blueColor, alpha: 1.0)
                    
                    //Creating RGB String for description
                    rgb = "R: \(Double(round(100*redColor)/100)), G: \(Double(round(100*greenColor)/100)), B: \(Double(round(100*blueColor)/100))"
                    
                    //Append color and RGB-string into arrays
                    rgbs.append(rgb)
                    colors.append(color)
                    
                    //print(color)
                
                    //Reload table data
                    (DispatchQueue.main).async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
            
            
        })

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
            }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
       
        //reverse the arrays for better visual gamma
        let userColor = colors.reversed()[indexPath.row]
        let userRGB = rgbs.reversed()[indexPath.row]
        
        //Print color in cell
        cell.textLabel?.text = userRGB
        
        //Set unique backgroundColor for each cell
        cell.backgroundColor = userColor
        return cell
    }


}//class


//custom cell for dequeueReusableCell
class ColorCell:UITableViewCell {
    
    override init(style:UITableViewCellStyle, reuseIdentifier:String?){
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}//class

