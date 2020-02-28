//
//  ZKCarousel.swift
//  Delego
//
//  Created by Zachary Khan on 6/8/17.
//  Copyright © 2017 ZacharyKhan. All rights reserved.
//

import UIKit
import AVFoundation

enum MediaType: Int {
    case photo = 0, video
}

final public class ZKCarousel: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    public var slides : [ZKCarouselSlide] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.pageControl.numberOfPages = self.slides.count
                self.pageControl.size(forNumberOfPages: self.slides.count)
            }
        }
    }
    
    public var mediaTypeArr: [String] = []
    
    public var pageNumber: CGFloat = 0.0
    
    public var delegate: ZKCarouselDelegate?
    
    private lazy var tapGesture : UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tap:)))
        return tap
    }()
    
    public lazy var pageControl : UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    public lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        cv.register(VideoCell.self, forCellWithReuseIdentifier: "videoCell")
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCarousel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCarousel()
    }
    
    private func setupCarousel() {
        self.backgroundColor = .clear
        
        self.addSubview(collectionView)
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0).isActive = true
        
        self.collectionView.addGestureRecognizer(self.tapGesture)
        
        self.addSubview(pageControl)
        NSLayoutConstraint(item: pageControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20).isActive = true
        NSLayoutConstraint(item: pageControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -20).isActive = true
        NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5).isActive = true
        NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25).isActive = true
        
        self.bringSubviewToFront(pageControl)
    }
    
    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
        let index = visibleIndexPath.item
        print("YESSIR")
        print(index)
        
        if (self.mediaTypeArr[index] == "video") {
            delegate?.didPressPlay(self)
        }
//
//        if index == (slides.count-1) {
//            let indexPathToShow = IndexPath(item: 0, section: 0)
//            self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
//        } else {
//            let indexPathToShow = IndexPath(item: (index + 1), section: 0)
//            self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
//        }
    }
    
    private func getCurrentIndex() {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    }
    
    private var timer : Timer = Timer()
    public var interval : Double?
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval ?? 1.0, target: self, selector: #selector(tapGestureHandler(tap:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    public func disableTap() {
        // This function is provided in case you want to remove the default gesture and provide your own. The default gesture changes the slides on tap.
        collectionView.removeGestureRecognizer(tapGesture)
    }
    
    public func reloadAtIndex() {
//        let indexPath = self.selectedIndexPath()!
//        print("Reloading at \(indexPath)")
//        self.collectionView.reloadItems(at: [indexPath])
        self.collectionView.reloadData()

    }
    
    public func selectedIndexPath() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("CELL # \( indexPath.item) or \(self.selectedIndexPath()) --> \(self.mediaTypeArr[indexPath.item])")
        
        if self.mediaTypeArr[indexPath.item] == "video" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
            cell.slide = self.slides[indexPath.item]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
            cell.slide = self.slides[indexPath.item]
            return cell
        }
    }
        
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.slides.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(pageNumber)
//        print("Current Page \(pageNumber)")
        delegate?.didSlideChange(self)
    }
}

final public class ZKCarouselSlide : NSObject {
    
    public var slideImage : UIImage?
    public var slideVideo : AVPlayerLayer?
    public var slideTitle : String?
    public var slideDescription: String?
    
    public init(image: UIImage, title: String, description: String) {
        slideImage = image
        slideTitle = title
        slideDescription = description
    }
    
    public init(video: AVPlayerLayer, title: String, description: String) {
        slideVideo = video
        slideTitle = title
        slideDescription = description
    }
    
    override public init() {
//        super.init()
    }
    
}


