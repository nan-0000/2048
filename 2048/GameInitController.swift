//
//  GameInitControllerViewController.swift
//  2048
//
//  Created by nan_macos on 2020/11/20.
//  Copyright © 2020 nan_macos. All rights reserved.
//

import UIKit

protocol GameModelProtocol : class {
    func changeScore(score : Int)
    func insertTile(position : (Int , Int), value : Int)
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int)
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int)
}

class GameInitController : UIViewController ,GameModelProtocol{
    var dimension : Int  = 4//2048游戏中每行每列含有多少个块
    var threshold : Int  = 2084//最高分数，判断输赢时使用，今天暂时不会用到，预留
    let boardWidth: CGFloat = 260.0  //游戏区域的长度和高度
    let thinPadding: CGFloat = 3.0  //游戏区里面小块间的间距
    let viewPadding: CGFloat = 10.0  //计分板和游戏区块的间距
    let verticalViewOffset: CGFloat = 0.0  //一个初始化属性，后面会有地方用到
    var bord : GameComponentView?
    var gameModle : GameModle?
    var scoreV : ScoreOfGameView?
    
    init(dimension d : Int , threshold t : Int)
    {
        dimension = d < 2 ? 2 : d
        threshold = t < 8 ? 8 : t
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red : 0xfa/255, green : 0xfa/255, blue : 0xd2/255, alpha : 1)

        
        setupSwipeConttoller()
    }
    func reset() {
        assert(bord != nil && gameModle != nil)
        let b = bord!
        let m = gameModle!
        b.reset()
        m.reset()
        m.insertRandomPositoinTile(value: 2)
        m.insertRandomPositoinTile(value: 2)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }

    func setupGame()
    {
        let viewWidth = view.bounds.size.width
        let viewHeight = view.bounds.size.height
        //获取游戏区域左上角那个点的x坐标
        func xposition2Center(view v : UIView) -> CGFloat{
            let vWidth = v.bounds.size.width
            return 0.5*(viewWidth - vWidth)

        }
        //获取游戏区域左上角那个点的y坐标
        func yposition2Center(order : Int , views : [UIView]) -> CGFloat {
            assert(views.count > 0)
            let totalViewHeigth = CGFloat(views.count - 1)*viewPadding +
                views.map({$0.bounds.size.height}).reduce(verticalViewOffset, {$0 + $1})
            let firstY = 0.5*(viewHeight - totalViewHeigth)

            var acc : CGFloat = 0
            for i in 0..<order{
                acc += viewPadding + views[i].bounds.size.height
            }
            return acc + firstY
        }
        //获取具体每一个区块的边长，即：(游戏区块长度-间隙总和)/块数
        let width = (boardWidth - thinPadding*CGFloat(dimension + 1))/CGFloat(dimension)
        //初始化一个游戏区块对象
        let gamebord = GameComponentView(
            demension : dimension,
            titleWidth: width,
            titlePadding: thinPadding,
            backgroundColor:  UIColor(red : 0xff/255, green : 0xd7/255, blue : 0x00/255, alpha : 1),
            foregroundColor:UIColor(red : 0xF9/255, green : 0xF9/255, blue : 0xE3/255, alpha : 0.5)
        )
        let scoreView = ScoreOfGameView(
               backgroundColor:  UIColor(red : 0x00/255, green : 0x64/255, blue : 0x00/255, alpha : 1),
               textColor: UIColor(red : 0xF3/255, green : 0xF1/255, blue : 0x1A/255, alpha : 0.5),
            font: UIFont(name: "HelveticaNeue-Bold", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
           )
        //现在面板中所有的视图对象
        let views = [scoreView,gamebord]
        /*记分板*/
        //定位其在主面板中左上角的绝对位置
        var f = scoreView.frame
        f.origin.x = xposition2Center(view: scoreView)
        f.origin.y = yposition2Center(order: 0, views: views)
        scoreView.frame = f
        
        //设置游戏区块在整个面板中的的绝对位置，即左上角第一个点
        f = gamebord.frame
        f.origin.x = xposition2Center(view: gamebord)
        f.origin.y = yposition2Center(order: 1, views: views)
        gamebord.frame = f
        //将游戏对象加入当前面板中
        view.addSubview(gamebord)
        view.addSubview(scoreView)
        
        scoreV = scoreView
        bord = gamebord
        //调用其自身方法来初始化一个分数
        scoreView.scoreChanged(newScore: 0)
        
        gamebord.insertTile(pos: (3,1) , value : 2)
        gamebord.insertTile(pos: (1,3) , value : 2)
        
       // assert(gameModle != nil)
        //gameModle 放在init会错误？？？？？
        gameModle = GameModle(dimension: dimension , threshold: threshold , delegate: self )
        let modle = gameModle!
        modle.insertRandomPositoinTile(value: 2)
        modle.insertRandomPositoinTile(value: 2)
        modle.insertRandomPositoinTile(value: 2)


    }
    
    func changeScore(score : Int){
        assert(scoreV != nil)
        let s =  scoreV!
        s.scoreChanged(newScore: score)
    }
    
    
    func insertTile(position pos : (Int , Int) , value : Int){
        assert(bord != nil)
        let b = bord!
        b.insertTile(pos: pos, value: value)
    }
    
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
        assert(bord != nil)
        let b = bord!
        b.moveOneTiles(from: from, to: to, value: value)
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(bord != nil)
        let b = bord!
        b.moveTwoTiles(from: from, to: to, value: value)
    }
    //注册监听器，监听当前视图里的手指滑动操作，上下左右分别对应下面的四个方法
    //向上滑动的方法，调用queenMove，传入MoveDirection.UP
    @objc func upCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.UP , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //向下滑动的方法，调用queenMove，传入MoveDirection.DOWN
    @objc func downCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.DOWN , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //向左滑动的方法，调用queenMove，传入MoveDirection.LEFT
    @objc func leftCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.LEFT , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    //向右滑动的方法，调用queenMove，传入MoveDirection.RIGHT
    @objc func rightCommand(r : UIGestureRecognizer) {
        let m = gameModle!
        m.queenMove(direction: MoveDirection.RIGHT , completion: { (changed : Bool) -> () in
            if  changed {
                self.followUp()
            }
        })
    }
    func setupSwipeConttoller()
    {
        let upSwipe = UISwipeGestureRecognizer(target: self , action:  #selector(GameInitController.upCommand(r:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizer.Direction.up
        view.addGestureRecognizer(upSwipe)

        let downSwipe = UISwipeGestureRecognizer(target: self , action:  #selector(GameInitController.downCommand(r:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizer.Direction.down
        view.addGestureRecognizer(downSwipe)

        let leftSwipe = UISwipeGestureRecognizer(target: self , action:  #selector(GameInitController.leftCommand(r:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self , action: #selector(GameInitController.rightCommand(r:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(rightSwipe)
    }

    //移动之后需要判断用户的输赢情况，如果赢了则弹框提示，给一个重玩和取消按钮
    func followUp() {
        assert(gameModle != nil)
        let m = gameModle!
        let (userWon, _) = m.userHasWon()
        if userWon {
            let winAlertView = UIAlertController(title: "結果", message: "你贏了", preferredStyle: UIAlertController.Style.alert)
            let resetAction = UIAlertAction(title: "重置", style: UIAlertAction.Style.default, handler: {(u : UIAlertAction) -> () in
                self.reset()
            })
            winAlertView.addAction(resetAction)
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil)
            winAlertView.addAction(cancleAction)
            self.present(winAlertView, animated: true, completion: nil)
            return
        }
        //如果没有赢则需要插入一个新的数字块
        let randomVal = Int(arc4random_uniform(10))
        m.insertRandomPositoinTile(value: randomVal == 1 ? 4 : 2)
        //插入数字块后判断是否输了，输了则弹框提示
        if m.userHasLost() {
            NSLog("You lost...")
            let lostAlertView = UIAlertController(title: "結果", message: "你輸了", preferredStyle: UIAlertController.Style.alert)
            let resetAction = UIAlertAction(title: "重置", style: UIAlertAction.Style.default, handler: {(u : UIAlertAction) -> () in
                self.reset()
            })
            lostAlertView.addAction(resetAction)
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: nil)
            lostAlertView.addAction(cancleAction)
            self.present(lostAlertView, animated: true, completion: nil)
        }
    }
    
}

