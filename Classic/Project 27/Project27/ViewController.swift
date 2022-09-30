//
//  ViewController.swift
//  Project27
//
//  Created by Joseph Van Alstyne on 9/28/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText() {
        // Create a renderer
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // Define a paragraph style that is center aligned
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            // Create an attributes dict with above paragraph style and a font
            let atts: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            // Wrap dict and a string in an NSAttributedString instance
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: atts)
            
            // Load an image from the project and draw to context
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        // Update image view
        imageView.image = img
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let faceRect = CGRect(x: 128, y: 128, width: 256, height: 256)
            ctx.cgContext.setFillColor(UIColor.systemYellow.cgColor)
            ctx.cgContext.addEllipse(in: faceRect)
            ctx.cgContext.drawPath(using: .fill)
            
            var eyeRect = CGRect(x: 200, y: 192, width: 24, height: 64)
            ctx.cgContext.setFillColor(UIColor.darkGray.cgColor)
            ctx.cgContext.addEllipse(in: eyeRect)
            ctx.cgContext.drawPath(using: .fill)
            
            eyeRect = CGRect(x: 288, y: 192, width: 24, height: 64)
            ctx.cgContext.addEllipse(in: eyeRect)
            ctx.cgContext.drawPath(using: .fill)
            
            ctx.cgContext.move(to: CGPoint(x: 200, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 312, y: 304))
            ctx.cgContext.setStrokeColor(UIColor.darkGray.cgColor)
            ctx.cgContext.setLineWidth(4)
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = img
    }
    
    func drawLettering() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setStrokeColor(UIColor.darkGray.cgColor)
            ctx.cgContext.setLineWidth(4)
            
            ctx.cgContext.move(to: CGPoint(x: 64, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 64, y: 320))
            ctx.cgContext.move(to: CGPoint(x: 8, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 128, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 192, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 224, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 256, y: 192))
            ctx.cgContext.move(to: CGPoint(x: 320, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 320, y: 320))
            ctx.cgContext.move(to: CGPoint(x: 384, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 384, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 496, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 496, y: 192))
            
            ctx.cgContext.strokePath()
            
        }
        
        imageView.image = img
    }
    
    @IBAction func redrawTapped() {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6:
            drawEmoji()
            
        case 7:
            drawLettering()
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

}

