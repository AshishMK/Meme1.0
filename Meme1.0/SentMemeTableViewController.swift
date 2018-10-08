//
//  SentMemeTableViewController.swift
//  Meme1.0
//
//  Created by Ashish Nautiyal on 10/2/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var sentMemeTable: UITableView!
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableCell")! as! SentMemeTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // Set the name and image
        cell.fillCell(meme: meme)
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
           (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if (UIApplication.shared.delegate as! AppDelegate).memes.count == 0{
                self.setEditing(false, animated: true)
        }
        }}
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(newMeme))
        navigationItem.leftBarButtonItem = editButtonItem
        newMeme()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        sentMemeTable.reloadData()
         }
    

    @objc func newMeme(){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.present(resultVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memeIndex = (indexPath as NSIndexPath).row
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailController, animated: true)
    }
   
    // Implemention of editing
    open override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        sentMemeTable.setEditing(editing, animated: animated)
        navigationItem.rightBarButtonItem?.isEnabled = !editing
     }
   

}
