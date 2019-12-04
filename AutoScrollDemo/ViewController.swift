//
//  ViewController.swift
//  AutoScrollDemo
//
//  Created by Admin on 05/12/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    ///
    @IBOutlet weak var scrollView: UIScrollView!
   
    // MARK: - Variables
    
    ///
    private var timer: Timer?
    ///
    var isFromBegin = true
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAdvertisementAndDisplay()
        setupView()
        startAutoScroll()
    }
    
    /// filter banner model and display
    ///
    /// - Parameter screenName: screen name
    func setupAdvertisementAndDisplay() {
      
        let arrImages = ["http://starkovtattoo.spb.ru/images/300/DSC100306195.jpg", "https://thewallpaper.co//wp-content/uploads/2016/10/gorgeous-nature-arc-wallpaper-hd-desktop-cool-images-download-free-4k-high-definition-tablet-samsung-phone-wallpapers-1080p-1920x1200.jpg", "https://image.shutterstock.com/display_pic_with_logo/3913793/766886038/stock-photo-autumn-forest-nature-vivid-morning-in-colorful-forest-with-sun-rays-through-branches-of-trees-766886038.jpg", "https://image.shutterstock.com/image-photo/mountains-during-sunset-beautiful-natural-260nw-407021107.jpg"]
        
   
        var count = 0
        for (i, imagePath) in arrImages.enumerated() {
            guard let urlImage = URL(string: imagePath) else { continue }
            
            // print("ImagePath:", imagePath)
            
            let xPosition = CGFloat(i) * screenWidth
            count += 1
            let imageView = UIImageView(frame: CGRect(x: xPosition, y: 0, width: screenWidth, height: scrollView.frame.size.height))
            imageView.tag = i
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            tapGestureSetupOnImageView(imageView: imageView)
            scrollView.addSubview(imageView)
            setImage(urlImage: urlImage, imageView: imageView)
        }
        scrollView.contentSize.width = screenWidth * CGFloat(count)
    }
    
    func setImage(urlImage: URL, imageView: UIImageView) {
        
        DispatchQueue.global(qos: .default).async {
            do {
                let data = try Data(contentsOf: urlImage)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
        
//        KingfisherManager.shared.retrieveImage(with: urlImage, options: nil, progressBlock: nil) { result in
//            switch result {
//            case .success(let value):
//                imageView.image = value.image
//            case .failure(let error):
//                print("displayBanner in BannerVC", error.localizedDescription)
//                imageView.image = nil
//            }
//        }
    }
    
    /// initial setup view
    func setupView() {
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
    }
    
    /// start auto scroll with schedule timer
    @objc func startAutoScroll() {
        if isFromBegin {
            disableTimer()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { (_) in
            let contentOffset = self.scrollView.contentOffset
            if self.scrollView.contentSize.width == contentOffset.x + self.screenWidth {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: contentOffset.y), animated: false)
            } else {
                UIView.animate(withDuration: 1.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.scrollView.setContentOffset(CGPoint(x: contentOffset.x + self.screenWidth, y: contentOffset.y), animated: false)
                }, completion: nil)
            }
        }
    }
    /// tap gesture setup in advertise image
    ///
    /// - Parameter imageView: advertise imageview
    func tapGestureSetupOnImageView(imageView: UIImageView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(advertiseTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }
    /// tap click on advertisement imageview and open url
    ///
    /// - Parameter sender: tap gesture
    @objc func advertiseTap(_ sender: UITapGestureRecognizer) {
        
    }
    /// disable timer which set when screen load and auto start scrollview
    func disableTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}

