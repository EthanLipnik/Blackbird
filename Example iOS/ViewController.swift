//
//  ViewController.swift
//  Example iOS
//
//  Created by Ethan Lipnik on 10/10/19.
//  Copyright © 2019 Tailosive. All rights reserved.
//

import UIKit
import Blackbird

class ViewController: UIViewController {
	@IBOutlet weak var previewImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var imageShadowView: UIView!
	
	let originalImage = UIImage(named: "Test.jpg")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		imageShadowView.layer.shadowColor = UIColor.gray.cgColor
		imageShadowView.layer.shadowOpacity = 0.4
		imageShadowView.layer.shadowRadius = 30
		
		previewImageView.layer.cornerRadius = 30
		if #available(iOS 13.0, macOS 10.15, *) {
			previewImageView.layer.cornerCurve = .continuous
		}
		previewImageView.layer.masksToBounds = true
	}
	
	@IBAction func applyEffect(_ sender: UIButton) {
		
		guard sender.tag != 0 else {
			
			[self.previewImageView, self.backgroundImageView].forEach { (imageView) in
				
				guard let imageView = imageView else { return }
				
				UIView.transition(with: imageView, duration: 0.4, options: [.transitionCrossDissolve, .beginFromCurrentState, .curveEaseInOut], animations: {
					imageView.image = self.originalImage
				})
			}
			
			return
		}
		
		let filter: ColorFilter = {
			
			switch sender.tag {
			case 1:
				return .noir
			case 2:
				return .sepia
			case 3:
				return .thermal
			case 4:
				return .instant
			default:
				return .noir
			}
		}()
		
		let image = originalImage?.appliedFilter(filter)
		
		[self.previewImageView, self.backgroundImageView].forEach { (imageView) in
			
			guard let imageView = imageView else { return }
			
			UIView.transition(with: imageView, duration: 0.4, options: [.transitionCrossDissolve, .beginFromCurrentState, .curveEaseInOut], animations: {
				imageView.image = image
			})
		}
	}
}

