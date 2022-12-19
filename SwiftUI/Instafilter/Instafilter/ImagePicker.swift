//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Joseph Van Alstyne on 12/19/22.
//

import Foundation
import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	class Coordinator: NSObject, PHPickerViewControllerDelegate {
		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			picker.dismiss(animated: true)
			
			guard let provider = results.first?.itemProvider else { return }
			
			if provider.canLoadObject(ofClass: UIImage.self) {
				provider.loadObject(ofClass: UIImage.self) { image, _ in
					self.parent.image = image as? UIImage
				}
			}
		}
		
		var parent: ImagePicker
		
		init(_ parent: ImagePicker) {
			self.parent = parent
		}
	}
	
	@Binding var image: UIImage?
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	func makeUIViewController(context: Context) -> PHPickerViewController {
		var config = PHPickerConfiguration()
		config.filter = .images
		
		let picker = PHPickerViewController(configuration: config)
		picker.delegate = context.coordinator
		return picker
	}
	
	func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
		// Not used
	}
}
