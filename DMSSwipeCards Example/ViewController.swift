//
//  ViewController.swift
//  DMSSwipeCards Example
//
//  Created by Kamil on 13.11.2017.
//  Copyright © 2017 Kamil. All rights reserved.
//

import UIKit
import DMSwipeCards
import Alamofire

class ViewController: UIViewController {

    private var swipeView: DMSwipeCardsView<String>!
    private var count = 0
    var imageArray = [String]()
    var imageUrlArray = [String]()
    var descriptionArray = [String]()
    var x = 0
    var labelSize = 25
    
    var dictionary: [String: String] = [:]
    
    var imageView = UIImageView()
    
  
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request("https://newsapi.org/v1/articles?source=mashable&sortBy=top&apiKey=a0206fa4f2034d1496ad852f9a26eca4").responseJSON { response in
        
            
            if let json = response.result.value  as? [String: Any],
                let artic = json["articles"] as? [[String:String]] {
                
                print("JSON: \(String(describing: json["status"]))") // serialized json response
              
                for obj in artic{
                    
                    self.imageArray.append(obj["title"]!)
                    self.descriptionArray.append(obj["description"]!)
                    self.imageUrlArray.append(obj["urlToImage"]!)
                
                    
                    for (index, element) in self.imageArray.enumerated()
                    {
                        self.dictionary[element] = self.descriptionArray[index]
                        print(self.dictionary)
                    }
                    
                    
                    }
                }
            
        }
        
        
        
        
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        /*
         * In this example we're using `String` as a type.
         * You can use DMSwipeCardsView though with any custom class.
         */
        
        let viewGenerator: (String, CGRect) -> (UIView) = { (element: String, frame: CGRect) -> (UIView) in
            let container = UIView(frame: CGRect(x: 30, y: 20, width: frame.width - 60, height: frame.height - 40))
            
           
           
            self.imageView = UIImageView(frame: container.bounds)
            
            let imgURL = NSURL(string: self.imageUrlArray[0])
            
            if imgURL != nil {
                let data = NSData(contentsOf: (imgURL as URL?)!)
                if self.x == 0{
                self.imageView.image = UIImage(data: data! as Data)
                }
                }
    
            self.imageView.contentMode = .center
            self.imageView.contentMode = .scaleAspectFill
            self.imageView.clipsToBounds = true
            self.imageView.layer.cornerRadius = 16
            container.addSubview(self.imageView)
            
           /* let label = UILabel(frame: container.bounds)
            label.text = element
            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 48, weight: UIFont.Weight.thin)
            label.clipsToBounds = true
            label.layer.cornerRadius = 16
            container.addSubview(label)
            */
            
          
            
            let tranpView = UIView(frame: CGRect(x: 0, y: (container.frame.height) - ((frame.height - 40)/6), width: frame.width - 60 , height: (frame.height - 40)/6))
            let xColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
            tranpView.layer.cornerRadius = 16
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.imageView.frame
            gradient.colors = [UIColor.clear.cgColor, xColor.cgColor]
            gradient.locations = [0.0, 1.0]
            self.imageView.layer.insertSublayer(gradient, at: 0)

            
            if element.count > 20 && element.count < 30 {
                self.labelSize = 35
            } else if element.count > 5 && element.count < 20 {
                self.labelSize = 40
            }else if element.count > 30 && element.count < 40 {
                self.labelSize = 20
            }
            
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width - 60, height: (frame.height - 40)/6))
            label.text = element
            label.font = UIFont.systemFont(ofSize: CGFloat(self.labelSize), weight: UIFont.Weight.thin)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 2
            tranpView.addSubview(label)
            container.addSubview(tranpView)
            label.textColor = UIColor.white
            
            
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale
            
            return container
        }
        
        let overlayGenerator: (SwipeMode, CGRect) -> (UIView) = { (mode: SwipeMode, frame: CGRect) -> (UIView) in
            let label = UILabel()
            label.frame.size = CGSize(width: 100, height: 100)
            label.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            label.layer.cornerRadius = label.frame.width / 2
            label.backgroundColor = mode == .left ? UIColor.red : UIColor.green
            label.clipsToBounds = true
            label.text = mode == .left ? "👎" : "👍"
            label.font = UIFont.systemFont(ofSize: 24)
            label.textAlignment = .center
            return label
        }
        
        let frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 160)
        swipeView = DMSwipeCardsView<String>(frame: frame,
                                             viewGenerator: viewGenerator,
                                             overlayGenerator: overlayGenerator)
        swipeView.delegate = self
        
        self.swipeView.addCards(self.imageArray, onTop: true)
        self.view.addSubview(self.swipeView)
  
        
        
        let button = UIButton(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 40))
        button.setTitle("Haberler", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonTapped() {
      //  let ac = UIAlertController(title: "Load on top / on bottom?", message: nil, preferredStyle: .actionSheet)
       // ac.addAction(UIAlertAction(title: "On Top", style: .default, handler: { (a: UIAlertAction) in
        
        if x == 0 {
            self.view.addSubview(self.swipeView)
       
          
            
            
            self.swipeView.addCards(self.imageArray, onTop: true)
           
            if self.imageUrlArray[0] != "" {
            let imgURL = NSURL(string: self.imageUrlArray[self.x])
            
            if imgURL != nil {
                let data = NSData(contentsOf: (imgURL as URL?)!)
                self.imageView.image = UIImage(data: data! as Data)
            }
            }else{
                print("error")
            }
        }

     /*   }))
        ac.addAction(UIAlertAction(title: "On Bottom", style: .default, handler: { (a: UIAlertAction) in
            self.view.addSubview(self.swipeView)
            
            self.swipeView.addCards(self.imageArray, onTop: false)
        
          
        }))
        self.present(ac, animated: true, completion: nil)
   */ }
    
}




extension ViewController: DMSwipeCardsViewDelegate {
    func swipedLeft(_ object: Any) {
        print("Swiped left: \(object)")
        x = x+1
        if x == imageArray.count {
            x=0
        }
   
        let imgURL = NSURL(string: self.imageUrlArray[self.x])
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            self.imageView.image = UIImage(data: data! as Data)
        }
        
        
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped right: \(object)")
  
        x = x+1
        if x == imageArray.count {
            x=0
        }
      
        let imgURL = NSURL(string: self.imageUrlArray[self.x])
        
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            self.imageView.image = UIImage(data: data! as Data)
        }
        
    }
    
    func cardTapped(_ object: Any) {
        let key = dictionary.index(forKey: object as! String)
        print(dictionary[key!].value)
        
        let detail = UIAlertController(title: object as? String, message: dictionary[key!].value, preferredStyle: .actionSheet)
        detail.addAction(UIAlertAction(title: "Okudum", style: .default, handler: { (a: UIAlertAction) in } ) )
        self.present(detail, animated: true, completion: nil)
        
        
    }
    
    func reachedEndOfStack() {
        print("Reached end of stack")
    }
    
    class Colors {
        var gl:CAGradientLayer!
        
        init() {
            let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
            let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor
            
            self.gl = CAGradientLayer()
            self.gl.colors = [colorTop, colorBottom]
            self.gl.locations = [0.0, 1.0]
        }
    }


}

