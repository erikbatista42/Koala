//
//  ViewController.swift
//  Koala
//
//  Created by Erik Batista on 6/30/17.
//  Copyright © 2017 swift.lang.eu. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UIScrollViewDelegate {
    
   
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainScrollView.frame = view.frame
        
        mainScrollView.delegate = self
        
        imageArray = [#imageLiteral(resourceName: "sampleImageOne"), #imageLiteral(resourceName: "samp3"), #imageLiteral(resourceName: "sampleImageThree")]
        
        for i in 0..<imageArray.count {
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: 375, height: 425)
            
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i + 1)
            mainScrollView.isPagingEnabled = true
            
            mainScrollView.addSubview(imageView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        pageController.currentPage = Int(page)
    }
    
    
    
    
    var pageHeadings = ["Dance","Record","Share"]
    var pageImages = ["","",""]
    
    
    @IBAction func logInButton(_ sender: UIButton) {
        
    }
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}

