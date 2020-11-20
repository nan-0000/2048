//
//  BaseModle.swift
//  2048
//
//  Created by nan_macos on 2020/11/20.
//  Copyright © 2020 nan_macos. All rights reserved.
//

import Foundation

//数组中存放的枚举，要么空要么一个带值的Tile
enum TileEnum {
    case Empty
    case Tile(Int)
}
//用户操作---上下左右
enum MoveDirection {
    case UP,DOWN,LEFT,RIGHT
}
//用于存放数字块的移动状态，是否需要移动以及两个一块合并并移动等，关键数据是数组中位置以及最新的数字块的值
enum TileAction{
    case NOACTION(source : Int , value : Int)
    case MOVE(source : Int , value : Int)
    case SINGLECOMBINE(source : Int , value : Int)
    case DOUBLECOMBINE(firstSource : Int , secondSource : Int , value : Int)

    func getValue() -> Int {
        switch self {
        case let .NOACTION(_, value) : return value
        case let .MOVE(_, value) : return value
        case let .SINGLECOMBINE(_, value) : return value
        case let .DOUBLECOMBINE(_, _, value) : return value
        }
    }

    func getSource() -> Int {
        switch self {
        case let .NOACTION(source , _) : return source
        case let .MOVE(source , _) : return source
        case let .SINGLECOMBINE(source , _) : return source
        case let .DOUBLECOMBINE(source , _ , _) : return source
        }
    }
}
//最终的移动数据封装，标注了所有需移动的块的原位置及新位置，以及块的最新值
enum MoveOrder{
    case SINGLEMOVEORDER(source : Int , destination : Int , value : Int , merged : Bool)
    case DOUBLEMOVEORDER(firstSource : Int , secondSource : Int , destination : Int , value : Int)
}
struct SequenceGamebord<T> {
    var demision : Int
    //存放实际值的数组
    var tileArray : [T]

    init(demision d : Int , initValue : T )
    {
        self.demision = d
        tileArray = [T](repeating: initValue, count : d*d)
    }
    //通过当前的x,y坐标来计算存储和取出的位置
    subscript(row : Int , col : Int) -> T {
        get{
            assert(row >= 0 && row < demision && col >= 0 && col < demision)
            return tileArray[demision*row + col]
        }
        set{
            assert(row >= 0 && row < demision && col >= 0 && col < demision)
            tileArray[demision*row + col] = newValue
        }
    }
    //初始化时使用
    mutating func setAll(value : T){
        for i in 0..<demision {
            for j in 0..<demision {
                self[i , j] = value
            }
        }
    }
}
