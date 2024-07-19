//
//  ViewController.swift
//  vk_test
//
//  Created by T BURNASHEVA on 19.07.2024.
//

import UIKit

let typeWeather: [String] = [
    NSLocalizedString("Sunny", comment: ""),
    NSLocalizedString("Cloudy", comment: ""),
    NSLocalizedString("Foggy", comment: ""),
    NSLocalizedString("Rain", comment: ""),
    NSLocalizedString("Thunderstorm", comment: ""),
    NSLocalizedString("Snowy", comment: ""),
    NSLocalizedString("Snowfall", comment: ""),
    NSLocalizedString("Meteor", comment: "")]

let imageWeather: [String] = [
    "sunny",
    "cloudy",
    "fog",
    "rain",
    "thunderstorm",
    "snow",
    "snowfall",
    "meteor",
]



var backgroundImageView: UIImageView = UIImageView()
var selectWeather: Int = 0
var firstStart = true

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewTop: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        selectWeather = Int.random(in: 0..<imageWeather.count)
        
        animateBackground()
        collectionView.layer.zPosition = 1
        viewTop.layer.zPosition = 1
        
    }
    
    func removeAllImageViewSubviews() {
       view.subviews.forEach { subView in
           if subView is UIImageView {
               subView.removeFromSuperview()
           }
       }
    }
        
    func animateBackground() {
        
        let imageWidth = max(self.view.frame.height, self.view.frame.width * 2)
        
        let backgroundImage = UIImage(named: imageWeather[selectWeather])!.resized(toWidth: imageWidth)
        
        removeAllImageViewSubviews()
        backgroundImageView = UIImageView(image: backgroundImage)
        self.view.addSubview(backgroundImageView)
        
        UIView.animate(withDuration: 60.0, delay: 0.0, options: [.curveLinear, .autoreverse, .repeat], animations: {
            backgroundImageView.frame = CGRectOffset(
                backgroundImageView.frame,
                -1 * backgroundImageView.frame.size.width + self.view.frame.width,
                0.0)
            }, completion: nil)
        
    }
    
    func changeImage() {
        
        UIView.transition(
            with: backgroundImageView,
            duration: 1.0,
            options: .transitionCrossDissolve,
            animations: {
                backgroundImageView.image = UIImage(named: imageWeather[selectWeather])!
            }, completion: nil)
    
    }

}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row != selectWeather) {
            selectWeather = indexPath.row
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            for index in 0..<typeWeather.count {
                let myIndexPath = IndexPath(row: index, section: 0)
                let cell = collectionView.cellForItem(at: myIndexPath) as? WeatherCell
                if (index == selectWeather) {
                    cell?.image.alpha = 1
                } else {
                    cell?.image.alpha = 0
                }
            }
            
            changeImage()
        }
        
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        typeWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        cell.label.text = typeWeather[indexPath.row]
        
        if firstStart {
            collectionView.scrollToItem(at: IndexPath(row: selectWeather, section: 0), at: .centeredHorizontally, animated: false)
            firstStart = false
        }
        
        if (indexPath.row == selectWeather) {
            cell.image.alpha = 1
        } else {
            cell.image.alpha = 0
        }
        return cell
    }
    
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
