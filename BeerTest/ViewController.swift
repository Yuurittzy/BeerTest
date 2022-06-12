//
//  ViewController.swift
//  BeerTest
//
//  Created by Yu on 11/06/22.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var targetView:UIView?
    var movingView:UIView?
    var refX:CGFloat = 0.0
    var refY:CGFloat = 0.0
    
    let motionManager = CMMotionManager()
    var timer : Timer = Timer()
    var contador = 0

    @objc func tiempo () {
        contador += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let W = self.view.bounds.size.width / 6
        let H = self.view.bounds.size.height / 6
        self.targetView = UIView(frame:CGRect(x:0,
                                              y:0,
                                              width: W,
                                              height: H))
        self.targetView!.backgroundColor = UIColor.purple
        self.targetView?.center = self.view.center
        self.view.addSubview(self.targetView!)
        self.movingView = UIView(frame:CGRect(x:0,
                                              y:0,
                                              width: W,
                                              height: H))
        self.movingView!.backgroundColor = UIColor.green
        self.view.addSubview(self.movingView!)
        refX = trunc((self.targetView?.frame.minX)!)
        refY = trunc((self.targetView?.frame.minY)!)
        iniciaAcelerometro()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(tiempo), userInfo: nil, repeats: true)
    }
    
   
    
    func iniciaAcelerometro () {
        
        let stepMoveFactor:Double = 50.0
        motionManager.startAccelerometerUpdates()  // iniciamos para recibir todas las lecturas de cambios de posición
        motionManager.accelerometerUpdateInterval = 0.1 // frecuencia de lecturas, en segundos
        motionManager.startAccelerometerUpdates(to: OperationQueue.main){ data, error in
            var rect = self.movingView!.frame
            let movetoX  = rect.origin.x + CGFloat((data?.acceleration.x)! * stepMoveFactor)
            let movetoY  = rect.origin.y - CGFloat((data?.acceleration.y)! * stepMoveFactor)
            let maxX = self.view.frame.width - rect.width
            let maxY = self.view.frame.height - rect.height
            if movetoX > 0 && movetoX < maxX {
                rect.origin.x = movetoX
            }
            if ( movetoY > 0 && movetoY < maxY ) {
                rect.origin.y = movetoY
            }
            self.movingView!.frame = rect
            if ((trunc(rect.minX) == self.refX ||
                trunc(rect.minX) == self.refX - 1 ||
                trunc(rect.minX) == self.refX + 1) &&
                (trunc(rect.minY) == self.refY ||
                    trunc(rect.minY) == self.refY - 1 ||
                    trunc(rect.minY) == self.refY + 1)) {
                self.endGame()
                self.motionManager.stopAccelerometerUpdates()
            }
        }
    }
    
    func endGame() {
        
        let alert = UIAlertController(title: "Ganaste!", message:"Bien hecho! el tiempo fue de \(contador) segundos. Desea compartir su score?", preferredStyle: .alert)
        let ac1 = UIAlertAction(title: "OK", style: .default)
        let ac2 = UIAlertAction(title: "Compartir", style: .default)
        alert.addAction(ac1)
        alert.addAction(ac2)
        self.present(alert, animated: true)
        timer.invalidate()
        contador=0
    }
   
}

