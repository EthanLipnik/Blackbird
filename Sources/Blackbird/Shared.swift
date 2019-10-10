//
//  Shared.swift
//  
//
//  Created by Ethan Lipnik on 10/10/19.
//

import Foundation
import CoreImage

public class Blackbird: NSObject {
	static let shared = Blackbird()
	
	let context = CIContext(options: nil)
}
