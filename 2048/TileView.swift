//
//  TileView.swift
//  2048
//
//  Created by nan_macos on 2020/11/20.
//  Copyright © 2020 nan_macos. All rights reserved.
//

import UIKit

class TileView : UIView{
    //数字块中的值
    var value : Int = 0 {
        didSet{
            backgroundColor = delegate.tileColor(value: value)
            lable.textColor = delegate.numberColor(value: value)
            lable.text = "\(value)"
        }
    }
    //提供颜色选择
    unowned let delegate : AppearanceProviderProtocol
    //一个数字块也就是一个lable
    var lable : UILabel

    init(position : CGPoint, width : CGFloat, value : Int, delegate d: AppearanceProviderProtocol){
        delegate = d
        lable = UILabel(frame : CGRect(x: 0 , y: 0 , width: width , height: width))
        lable.textAlignment = NSTextAlignment.center
        lable.minimumScaleFactor = 0.5
        lable.font = UIFont(name: "HelveticaNeue-Bold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        super.init(frame: CGRect(x: position.x, y: position.y, width: width, height: width))
        addSubview(lable)
        lable.layer.cornerRadius = 6

        self.value = value
        backgroundColor = delegate.tileColor(value: value)
        lable.textColor = delegate.numberColor(value: value)
        lable.text = "\(value)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
