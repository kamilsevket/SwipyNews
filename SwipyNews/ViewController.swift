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

var boo = false
var savedImageArr = [String]()
var readListDic: [String: String] = [:]

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var slideScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
   

    var buttonTechTap = false
    var buttonSiyasetTap = false
    var buttonMagaTap = false
    var buttonSporTap = false
    var buttonEkoTap = false
    var buttonSineTap = false
    
    private var swipeView: DMSwipeCardsView<String>!
    private var count = 0
    var imageArray = [String]()
    var readArray = [String]()
    var imageUrlArray = [String]()
    
    var descriptionArray = [String]()
    var x = 0
    var labelSize = 25
    var labelSize2 = 12
    var dictionary: [String: String] = [:]
    var imageView = UIImageView()
   
    var myTableView: UITableView!
    let cellSpacingHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        


        
    
        //----------------SCROLL VIEW WITH SLIDER--------------
        slideScrollView.delegate = self
        // CreateSlide Code
        let blueColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
        let gradientBlue: CAGradientLayer = CAGradientLayer()
        gradientBlue.frame = self.view.frame
        gradientBlue.colors = [UIColor.clear.cgColor, blueColor.cgColor]
        gradientBlue.locations = [0.0, 1.0]
        
        let greenColor = UIColor(red: 0/255, green: 131/255, blue: 143/255, alpha: 1.0)
        let gradientGreen: CAGradientLayer = CAGradientLayer()
        gradientGreen.frame = self.view.frame
        gradientGreen.colors = [UIColor.clear.cgColor, greenColor.cgColor]
        gradientGreen.locations = [0.0, 1.0]
        
        let redColor = UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1.0)
        let gradientRed: CAGradientLayer = CAGradientLayer()
        gradientRed.frame = self.view.frame
        gradientRed.colors = [UIColor.clear.cgColor, redColor.cgColor]
        gradientRed.locations = [0.0, 1.0]
        
        
        
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.backgroundImage.layer.insertSublayer(gradientBlue, at: 0)
   
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.backgroundImage.layer.insertSublayer(gradientGreen, at: 0)
 
       
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.backgroundImage.layer.insertSublayer(gradientRed, at: 0)
        
  
        
  
    
        
        let slides = [slide1,slide2,slide3]
        
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubview(toFront: pageControl)
        
    
        
        
        
         //----------------JSON DATA WITH ALAMOFIRE--------------
        

        let jsonUrl = "https://newsapi.org/v2/top-headlines?sources=the-next-web&apiKey=a0206fa4f2034d1496ad852f9a26eca4"
       
        Alamofire.request(jsonUrl).responseJSON { response in
    
            
        
            if let json = response.result.value  as? [String: Any],
                let artic = json["articles"] as? [[String:Any]] {
                
                let deneme2 = json["articles"]
                print(deneme2!)
                
                print("JSON: \(String(describing: json["status"]))") // serialized json response
              
                for obj in artic{
                 
                    self.imageArray.append(obj["title"]! as! String)
                    self.descriptionArray.append(obj["description"]! as! String )
                    self.imageUrlArray.append(obj["urlToImage"]! as! String)
                    
                    print("selamdasdasdadf")
                    for (index, element) in self.imageArray.enumerated()
                    {
                        self.dictionary[element] = self.descriptionArray[index]
                        print(self.dictionary)
                    }
                    
                    
                    }
                
                
                let jsonStatus = json["status"]! as! String
                if jsonStatus == "ok" {
                    
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

                
                
                }
            
        }
        
        
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        
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
            
            // IMAGE EFFECTS
            let tranpView = UIView(frame: CGRect(x: 0, y: (container.frame.height) - ((frame.height - 40)/6), width: frame.width - 60 , height: (frame.height - 40)/6))
            
            tranpView.layer.cornerRadius = 16
            
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = self.imageView.frame
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            gradient.locations = [0.0, 1.0]
            self.imageView.layer.insertSublayer(gradient, at: 0)

            //TITLE LABEL DETAILS
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
            
            // CONTAINER DETAILS
            container.layer.shadowRadius = 4
            container.layer.shadowOpacity = 1.0
            container.layer.shadowColor = UIColor(white: 0.9, alpha: 1.0).cgColor
            container.layer.shadowOffset = CGSize(width: 0, height: 0)
            container.layer.shouldRasterize = true
            container.layer.rasterizationScale = UIScreen.main.scale

            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragEvent(gesture:)))
            panGesture.delegate = self as? UIGestureRecognizerDelegate
            container.addGestureRecognizer(panGesture)
            
            
            
             //----------------Table View--------------

            
            
            return container
        }
        
        //----------------DMSWIPE CARDS EXAMPLE CODES--------------
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
        
        slide1.addSubview(self.swipeView)

        
        
        
        // Haberler Button
        let button = UIButton(frame: CGRect(x: 30, y: 40, width: self.view.frame.width - 60, height: 40))
        button.setTitle("Haberler", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = blueColor
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.swipeView.addCards(self.imageArray, onTop: true)
        slide1.addSubview(button)
        
        // Okuma Listesi Button
        let buttonOkuma = UIButton(frame: CGRect(x: 30, y: 40, width: self.view.frame.width - 60, height: 40))
        buttonOkuma.setTitle("Okuma Listesi", for: .normal)
        buttonOkuma.setTitleColor(UIColor.white, for: .normal)
        buttonOkuma.layer.cornerRadius = 16
        buttonOkuma.backgroundColor = greenColor
        buttonOkuma.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        slide2.addSubview(buttonOkuma)
        
        //Katagoriler Button
        let buttonKatagori = UIButton(frame: CGRect(x: 30, y: 40, width: self.view.frame.width - 60, height: 40))
        buttonKatagori.setTitle("Katagoriler", for: .normal)
        buttonKatagori.setTitleColor(UIColor.white, for: .normal)
        buttonKatagori.layer.cornerRadius = 16
        buttonKatagori.backgroundColor = redColor
        
        slide3.addSubview(buttonKatagori)
        
        
        //Table View Create
        
        let displayWidth: CGFloat = frame.width - 60
        let displayHeight: CGFloat = frame.height - 40
        self.myTableView = UITableView(frame: CGRect(x: frame.width/12, y: frame.height/5, width: displayWidth, height: displayHeight ))
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.myTableView.dataSource = self
        self.myTableView.layer.cornerRadius = 12
        self.myTableView.delegate = self
        slide2.addSubview(self.myTableView)
        
         //----------------Catagories Button--------------
        
    
        
        let buttonTech = UIButton(frame: CGRect(x: frame.width/16, y: frame.height/5, width: (self.view.frame.width - 60)/2, height: (self.view.frame.height)/6))
        buttonTech.setTitle("Teknoloji", for: .normal)
        buttonTech.setTitleColor(UIColor.white, for: .normal)
        buttonTech.layer.cornerRadius = 16
        buttonTech.backgroundColor = UIColor.orange
        buttonTech.addTarget(self, action: #selector(buttonTechTapped), for: .touchUpInside)
        slide3.addSubview(buttonTech)
        
     
        
        let buttonSiyaset = UIButton(frame: CGRect(x: (frame.width)-(self.view.frame.width - 30)/2, y: frame.height/5, width: (self.view.frame.width - 60)/2, height: (self.view.frame.height)/6))
        buttonSiyaset.setTitle("Siyaset", for: .normal)
        buttonSiyaset.setTitleColor(UIColor.white, for: .normal)
        buttonSiyaset.layer.cornerRadius = 16
        buttonSiyaset.backgroundColor = redColor
        buttonSiyaset.addTarget(self, action: #selector(buttonSiyasetTapped), for: .touchUpInside)
        slide3.addSubview(buttonSiyaset)
        
        let buttonMaga = UIButton(frame: CGRect(x: frame.width/16, y: (frame.height/2.5) + 30, width: (self.view.frame.width - 60)/2, height: (self.view.frame.height)/6))
        buttonMaga.setTitle("Magazin", for: .normal)
        buttonMaga.setTitleColor(UIColor.white, for: .normal)
        buttonMaga.layer.cornerRadius = 16
        buttonMaga.backgroundColor = blueColor
        buttonMaga.addTarget(self, action: #selector(buttonMagaTapped), for: .touchUpInside)
        slide3.addSubview(buttonMaga)
        
        let buttonSpor = UIButton(frame: CGRect(x: (frame.width)-(self.view.frame.width - 30)/2, y: (frame.height/2.5) + 30, width: (self.view.frame.width - 60)/2, height: (self.view.frame.height)/6))
        buttonSpor.setTitle("Spor", for: .normal)
        buttonSpor.setTitleColor(UIColor.white, for: .normal)
        buttonSpor.layer.cornerRadius = 16
        buttonSpor.backgroundColor = greenColor
        buttonSpor.addTarget(self, action: #selector(buttonSporTapped), for: .touchUpInside)
        slide3.addSubview(buttonSpor)
        
        let buttonEko = UIButton(frame: CGRect(x: frame.width/16, y: ((frame.height/2.5) + (self.view.frame.height)/6 + 55), width: (self.view.frame.width - 60)/2, height: (self.view.frame.height)/6))
        buttonEko.setTitle("Ekonomi", for: .normal)
        buttonEko.setTitleColor(UIColor.white, for: .normal)
        buttonEko.layer.cornerRadius = 16
        buttonEko.backgroundColor = redColor
        buttonEko.addTarget(self, action: #selector(buttonEkoTapped), for: .touchUpInside)
        slide3.addSubview(buttonEko)
     
        let buttonSine = UIButton(frame: CGRect(x: (frame.width)-(self.view.frame.width - 30)/2, y: ((frame.height/2.5) + (self.view.frame.height)/6 + 55), width: (self.view.frame.width - 60)/2, height: (self.view.frame.height)/6))
        buttonSine.setTitle("Sinema", for: .normal)
        buttonSine.setTitleColor(UIColor.white, for: .normal)
        buttonSine.layer.cornerRadius = 16
        buttonSine.backgroundColor = UIColor.orange
        buttonSine.addTarget(self, action: #selector(buttonSineTapped), for: .touchUpInside)
        slide3.addSubview(buttonSine)
        
        
        
       /* let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.7
        blurEffectView.frame = buttonTech.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        */
        
        buttonTech.setTitleColor(UIColor.white, for: UIControlState.selected)
        buttonTech.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        buttonSiyaset.setTitleColor(UIColor.white, for: UIControlState.selected)
        buttonSiyaset.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        buttonMaga.setTitleColor(UIColor.white, for: UIControlState.selected)
        buttonMaga.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        buttonSpor.setTitleColor(UIColor.white, for: UIControlState.selected)
        buttonSpor.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        buttonEko.setTitleColor(UIColor.white, for: UIControlState.selected)
        buttonEko.setTitleColor(UIColor.black, for: UIControlState.normal)
        
        buttonSine.setTitleColor(UIColor.white, for: UIControlState.selected)
        buttonSine.setTitleColor(UIColor.black, for: UIControlState.normal)

    }
    
    
    
    
    //----------------BUTTON TAPPED FUNCTION--------------
    @objc func buttonTapped() {
      //  let ac = UIAlertController(title: "Load on top / on bottom?", message: nil, preferredStyle: .actionSheet)
       // ac.addAction(UIAlertAction(title: "On Top", style: .default, handler: { (a: UIAlertAction) in
        
        if x == 0 {
            
            
            
            let blueColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1.0)
            let gradientBlue: CAGradientLayer = CAGradientLayer()
            gradientBlue.frame = self.view.frame
            gradientBlue.colors = [UIColor.clear.cgColor, blueColor.cgColor]
            gradientBlue.locations = [0.0, 1.0]
            
            let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide1.backgroundImage.layer.insertSublayer(gradientBlue, at: 0)
            
            slide1.addSubview(self.swipeView)
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


//----------------EXTENSION FOR LEFT-RIGHT SWIPE FUNCTIONS--------------
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
        
     print(savedImageArr)
        
    }
    
    func swipedRight(_ object: Any) {
        print("Swiped right: \(object)")
        
        let key = dictionary.index(forKey: object as! String)
        
        readListDic.updateValue(dictionary[key!].value, forKey: object as! String)
        readArray.append(object as! String)
        
        print(imageUrlArray.count)
        print(x)
        print(imageUrlArray.count - x)
        x = x+1
        
        let imgURL = NSURL(string: self.imageUrlArray[self.x])
        
        if imgURL != nil {
            
            let data = NSData(contentsOf: (imgURL as URL?)!)
            self.imageView.image = UIImage(data: data! as Data)
            
            savedImageArr.append(self.imageUrlArray[(self.x)-1])
            
            if x == imageArray.count - 1 {
                x=0
                
            }
            
        }
   
        self.myTableView.reloadData()
       
    }
    
    func cardTapped(_ object: Any) {
        let key = dictionary.index(forKey: object as! String)
        print(dictionary[key!].value)
        print(readListDic)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    
    }
    /*
     func createSlides() -> [Slide] {
     let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
     
     let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
     
     self.swipeView.addCards(self.imageArray, onTop: true)
     slide1.addSubview(self.swipeView)
     
     
     return [slide1, slide2]
     }*/
    
    func setupSlideScrollView(slides:[Slide]) {
        slideScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        slideScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            slideScrollView.addSubview(slides[i])
            slideScrollView.isPagingEnabled = true
        }
        
    }
    
    
    @objc func dragEvent(gesture: UIPanGestureRecognizer) {
        // Do not change Here

        
        switch gesture.state {
        case .began:
             self.slideScrollView.isScrollEnabled = false
            break
        case .changed:
            self.slideScrollView.isScrollEnabled = false
            break
        case .ended:
             self.slideScrollView.isScrollEnabled = true
            break
        default:
            break
        }
    }
    
    
    //Table View
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        let value = readListDic[readArray[indexPath.row]]
      
        let detail = UIAlertController(title: readArray[indexPath.row], message: value, preferredStyle: .actionSheet)
        detail.addAction(UIAlertAction(title: "Okudum", style: .default, handler: { (a: UIAlertAction) in } ) )
        self.present(detail, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readListDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as UITableViewCell

        
        let greenColor = UIColor(red: 0/255, green: 131/255, blue: 143/255, alpha: 1.0)
        let gradientGreen: CAGradientLayer = CAGradientLayer()
        gradientGreen.frame = self.view.frame
        gradientGreen.colors = [UIColor.clear.cgColor, greenColor.cgColor]
        gradientGreen.locations = [0.0, 1.0]
        
    
        myTableView.rowHeight = 60
        
        
        let key   = Array(readListDic.keys)[indexPath.row]
        let imgURL = NSURL(string: savedImageArr[indexPath.row])
        if imgURL != nil {
           
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.imageView?.image = UIImage(data: data! as Data)
            cell.imageView?.layer.cornerRadius = 17
          
            if key.count > 20 && key.count < 30 {
                self.labelSize2 = 18
            } else if key.count > 5 && key.count < 20 {
                self.labelSize2 = 23
            }else if key.count > 30 && key.count < 40 {
                self.labelSize2 = 10
            }
            
            
            self.myTableView.backgroundColor = greenColor
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.font = UIFont.systemFont(ofSize: CGFloat(self.labelSize2), weight: UIFont.Weight.thin)
            cell.backgroundColor = greenColor
            cell.textLabel?.numberOfLines = 3
            
            
        }
        
        
        cell.textLabel?.text = readArray[indexPath.row]

        return cell
    }
    

    
    // Button Tapped Catagories Functions
    @objc func buttonTechTapped(sender:UIButton) {
        
        if buttonTechTap == true {
            buttonTechTap = false
            sender.isSelected = !sender.isSelected;
        }else{
            
            let detail = UIAlertController(title: "Katagori ekle", message: "Teknoloji Katagorisini eklemek ister misin?", preferredStyle: .actionSheet)
            detail.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (a: UIAlertAction) in
                self.buttonTechTap = true
                sender.isSelected = !sender.isSelected;
            } ) )
            detail.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (a: UIAlertAction) in
                self.buttonTechTap = false
            } ) )
            self.present(detail, animated: true, completion: nil)
            
            
}

}
    @objc func buttonSiyasetTapped(sender:UIButton) {
        
        if buttonSiyasetTap == true {
            buttonSiyasetTap = false
            sender.isSelected = !sender.isSelected;
        }else{
            
            let detail = UIAlertController(title: "Katagori ekle", message: "Siyaset Katagorisini eklemek ister misin?", preferredStyle: .actionSheet)
            detail.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (a: UIAlertAction) in
                self.buttonSiyasetTap = true
                sender.isSelected = !sender.isSelected;
            } ) )
            detail.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (a: UIAlertAction) in
                self.buttonSiyasetTap = false
            } ) )
            self.present(detail, animated: true, completion: nil)
            
            
        }
        
    }
    @objc func buttonMagaTapped(sender:UIButton) {
        
        if buttonMagaTap == true {
            buttonMagaTap = false
            sender.isSelected = !sender.isSelected;
        }else{
            
            let detail = UIAlertController(title: "Katagori ekle", message: "Magazin Katagorisini eklemek ister misin?", preferredStyle: .actionSheet)
            detail.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (a: UIAlertAction) in
                self.buttonMagaTap = true
                sender.isSelected = !sender.isSelected;
            } ) )
            detail.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (a: UIAlertAction) in
                self.buttonMagaTap = false
            } ) )
            self.present(detail, animated: true, completion: nil)
            
            
        }
        
    }
    
    @objc func buttonSporTapped(sender:UIButton) {
        
        if buttonSporTap == true {
            buttonSporTap = false
            sender.isSelected = !sender.isSelected;
        }else{
            
            let detail = UIAlertController(title: "Katagori ekle", message: "Spor Katagorisini eklemek ister misin?", preferredStyle: .actionSheet)
            detail.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (a: UIAlertAction) in
                self.buttonSporTap = true
                sender.isSelected = !sender.isSelected;
            } ) )
            detail.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (a: UIAlertAction) in
                self.buttonSporTap = false
            } ) )
            self.present(detail, animated: true, completion: nil)
            
            
        }
        
    }
    
    @objc func buttonEkoTapped(sender:UIButton) {
        
        if buttonEkoTap == true {
            buttonEkoTap = false
            sender.isSelected = !sender.isSelected;
        }else{
            
            let detail = UIAlertController(title: "Katagori ekle", message: "Ekonomi Katagorisini eklemek ister misin?", preferredStyle: .actionSheet)
            detail.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (a: UIAlertAction) in
                self.buttonEkoTap = true
                sender.isSelected = !sender.isSelected;
            } ) )
            detail.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (a: UIAlertAction) in
                self.buttonEkoTap = false
            } ) )
            self.present(detail, animated: true, completion: nil)
            
            
        }
        
    }
    
    @objc func buttonSineTapped(sender:UIButton) {
        
        
        
        if buttonSineTap == true {
            buttonSineTap = false
            sender.isSelected = !sender.isSelected;
        }else{
            
            let detail = UIAlertController(title: "Katagori ekle", message: "Sinema Katagorisini eklemek ister misin?", preferredStyle: .actionSheet)
            detail.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (a: UIAlertAction) in
                self.buttonSineTap = true
                sender.isSelected = !sender.isSelected;
            } ) )
            detail.addAction(UIAlertAction(title: "Hayır", style: .default, handler: { (a: UIAlertAction) in
                self.buttonSineTap = false
            } ) )
            self.present(detail, animated: true, completion: nil)
            
            
        }
        
    }
    
    
}


