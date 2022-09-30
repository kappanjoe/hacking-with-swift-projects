//
//  DetailViewController.swift
//  Project3
//
//  Created by Joseph Van Alstyne on 7/25/22.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var selectedIndex: Int?
    var imageCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        title = "Picture \(selectedIndex! + 1) of \(imageCount!)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image else { // .jpegData(compressionQuality: 0.8)
            print("No image found")
            return
        }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let img = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let textStyle = NSMutableParagraphStyle()
            textStyle.alignment = .left
            
            let atts: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 48),
                .paragraphStyle: textStyle,
                .foregroundColor: UIColor(white: 1, alpha: 0.8),
                .backgroundColor: UIColor.darkGray.withAlphaComponent(0.3)
            ]
            
            let string = " \(selectedImage!) \n From Storm Viewer "
            let attrString = NSAttributedString(string: string, attributes: atts)
            
            attrString.draw(with: CGRect(x: 32, y: Int(image.size.height - 140), width: Int(image.size.width - 32), height: 140), options: .usesLineFragmentOrigin, context: nil)
        }
        
        let vc = UIActivityViewController(activityItems: [img], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
