//
//  Extensions.swift
//  ZKCarousel
//
//

import Foundation

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    
}

extension UIImageView {
    func addBlackGradientLayer(frame: CGRect){
//        let gradient = CAGradientLayer()
//        gradient.frame = frame
//        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
//        gradient.locations = [0.0, 0.6]
//        self.layer.insertSublayer(gradient, at: 0)
    }
}

// DELEGATE PROTOCOL
public protocol ZKCarouselDelegate {
    func didSlideChange(_ sender: ZKCarousel)
    func didPressPlay(_ sender: ZKCarousel)
}
