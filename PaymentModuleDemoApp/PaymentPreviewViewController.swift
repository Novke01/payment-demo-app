//
//  PaymentPreviewViewController.swift
//  PaymentModuleDemoApp
//
//  Created by Aleksandar Novakovic on 3/20/17.
//  Copyright © 2017 Execom. All rights reserved.
//

import UIKit

class PaymentPreviewViewController: UIViewController {

    @IBOutlet weak var paymentPreviewCollection: UICollectionView!
    
    let reusableCellId = "cell"
    
    var user: User!
    var card: Card!
    var price: String!
    var currency: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        paymentPreviewCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reusableCellId)
        paymentPreviewCollection.delegate = self
        paymentPreviewCollection.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PaymentPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newCell = paymentPreviewCollection.dequeueReusableCell(withReuseIdentifier: reusableCellId, for: indexPath)
        // TODO: Add some logic
        return newCell
    }
    
}
