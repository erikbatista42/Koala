//
//  ViewController.swift
//  Koala
//
//  Created by Erik Batista on 6/30/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainScrollView.frame = view.frame
        
        imageArray = [#imageLiteral(resourceName: "dance2"), #imageLiteral(resourceName: "imgOne"), #imageLiteral(resourceName: "dance")]
        
        for i in 0..<imageArray.count {
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
    }
    
    
    
    
    
    var pageHeadings = ["Dance","Record","Share"]
    var pageImages = ["","",""]
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

