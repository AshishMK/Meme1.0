//
//  SentMemeCollectionViewController.swift
//  Meme1.0
//
//  Created by Ashish Nautiyal on 10/3/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemeCollectionCell"

class SentMemeCollectionViewController: UICollectionViewController {
    //MARK: Properties
    @IBOutlet var sentMemeCollection: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]! {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    var lastOrientation = UIDevice.current.orientation.isLandscape
    
    override func viewWillAppear(_ animated: Bool) {
        sentMemeCollection.reloadData()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(newMeme))
            self.configureFlowLayout(view.frame.size.width )
    }
    
    func configureFlowLayout(_ cellWidth: CGFloat){
        // Configure the cell
        lastOrientation = UIDevice.current.orientation.isLandscape
        let dim = view.frame.size.width  > view.frame.size.height ? view.frame.size.height : view.frame.size.width
        var span : Int = 3
        let space:CGFloat = 8.0
        
        var dimension  = (dim - (2 * space)) / CGFloat(span)
        
        span = Int(cellWidth / dimension)
        
        dimension  = (cellWidth - (( CGFloat(span) - 1)  * space)) / CGFloat(span)
        
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
 
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if lastOrientation == UIDevice.current.orientation.isLandscape{
        return
        }
        self.configureFlowLayout(view.frame.size.height )
    }
    
    @objc func newMeme(){
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditorViewController")as! MemeEditorViewController
        self.present(resultVC, animated: true, completion: nil)
    }


    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemeCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = meme.originalImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        cell.layoutIfNeeded()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.memeIndex = (indexPath as NSIndexPath).row
          detailController.hidesBottomBarWhenPushed = true
      self.navigationController!.pushViewController(detailController, animated: true)
    }



}
