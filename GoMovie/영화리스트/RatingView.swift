//
//  RatingView.swift
//  GoMovie
//
//  Created by 503-03 on 28/11/2018.
//  Copyright © 2018 shenah. All rights reserved.
//

import UIKit
class RatingView: UIView {
    
    var StarMax = 5.0  //  最大评分
    var StarHeight = 22.0  //星星高度
    var StarSpace = 4.0     //星星间距
    var emptyImageViews = [UIImageView]()
    var fillImageViews = [UIImageView]()
    
    var value = 0.0 {
        didSet {
            if value > StarMax {
                value = StarMax
            }else if value < 0{
                value = 0
                
            }
            
            for (i,imageView) in fillImageViews.enumerated(){
                let i = Double(i)
                
                if value >= i + 1 {
                    
                    imageView.layer.mask = nil
                    imageView.isHidden = false
                    
                }else if value > i && value < i + 1 {
                    let maskLayer = CALayer()
                    maskLayer.frame = CGRect(x:0,y:0,width:(value - i) * StarHeight,height:StarHeight)
                    maskLayer.backgroundColor = UIColor.red.cgColor
                    imageView.layer.mask = maskLayer
                    imageView.isHidden = false
                    
                }else {
                    
                    imageView.layer.mask = nil
                    imageView.isHidden = true
                }
            }
        }
    }
    
    init(StarHeight:Double,StarMax:Double){
        
        self.StarHeight = StarHeight
        self.StarMax = StarMax
        self.StarSpace = StarHeight * 0.15
        
        let frame = CGRect(x:0,y:0,width:StarHeight * StarMax + StarSpace * (StarMax - 1),height:StarHeight)
        
        
        super.init(frame: frame)
        
        
        for i in 0..<Int(StarMax) {
            let i = Double(i)
            let emptyImageView = UIImageView(image: UIImage(named:"star_empty"))
            let fillImageView = UIImageView(image: UIImage(named:"star_full"))
            
            
            let frame = CGRect(x:StarHeight * i + StarSpace *  i, y:0,width:StarHeight,height:StarHeight )
            emptyImageView.frame = frame
            fillImageView.frame = frame
            
            emptyImageViews.append(emptyImageView)
            fillImageViews.append(fillImageView)
            
            addSubview(emptyImageView)
            addSubview(fillImageView)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //没有评分
    
    static var KeyNoRating = "KeyNoRating"
    
    static func showNORating(view:UIView){
        for subview in view.subviews {
            if let subview = subview as? RatingView {
                subview.isHidden = true
                return
            }
        }
        
        var label:UILabel = (objc_getAssociatedObject(view, &KeyNoRating) as? UILabel)!
        
        if label == nil {
            label = UILabel(frame:view.bounds)
            
            label.font = UIFont.systemFont(ofSize: 13.0)
            view.addSubview(label)
            label.text = "평점없음"
            objc_setAssociatedObject(view, &KeyNoRating, label, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        label.isHidden = false
        
        
        
    }
    
    
    static func showInView(view:UIView,value:Double,StarMax:Double = 5.0){
        
        for subview in view.subviews {
            if let subview = subview as? RatingView {
                subview.value = value
                return
            }
        }
        
        // xcode8的坑，一定要layoutIfNeeded才会autolayout布局
        view.layoutIfNeeded()
        let ratingView = RatingView(StarHeight: Double(view.frame.size.height), StarMax: StarMax)
        ratingView.isHidden = false
        
        view.addSubview(ratingView)
        ratingView.value = value
        
        if let label = objc_getAssociatedObject(view, &KeyNoRating) as? UILabel {
            label.isHidden = true
        }
        
    }
    
    
    
    
    
}



    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


