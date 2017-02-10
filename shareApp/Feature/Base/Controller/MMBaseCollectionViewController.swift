//
//  MMBaseCollectionViewController.swift
//  ShareApp
//
//  Created by liulianqi on 16/8/2.
//  Copyright © 2016年 sunxianglong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MMBaseCollectionViewController: UICollectionViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(String.init(describing: type(of: self)))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(String.init(describing: type(of: self)))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      let   backBtn = UIButton.init(type: .custom)
        backBtn.frame = CGRect(x: 0, y: 0, width: 44, height: 44);
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
//        backBtn.addTarget(self, action: #selector(self.popViewControllerAnimated), forControlEvents: .TouchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backBtn)
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        return cell
    }
    
    deinit{
        
        log("\(String.init(describing: type(of: self))) ---> 被销毁 ")
    }
    
}
