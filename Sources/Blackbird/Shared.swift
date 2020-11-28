//
//  Shared.swift
//  
//
//  Created by Ethan Lipnik on 10/10/19.
//

import Foundation
import CoreImage

open class Blackbird: NSObject {
    public static let shared = Blackbird()
    
    public let context = CIContext(options: nil)
}
