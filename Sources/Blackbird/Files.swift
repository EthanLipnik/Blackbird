//
//  File.swift
//  
//
//  Created by Ethan Lipnik on 10/10/19.
//

import Foundation

class Files: NSObject {
	static let `default` = Files()
	
	var cache: [String: URL] = [:]
	let baseURL = urlForRestServicesTestsDir()
	
	override init() {
		super.init()
		guard let enumerator = FileManager.default.enumerator(
			at: baseURL,
			includingPropertiesForKeys: [.nameKey],
			options: [.skipsHiddenFiles, .skipsPackageDescendants],
			errorHandler: nil) else {
				fatalError("Could not enumerate \(baseURL)")
		}

		for case let url as URL in enumerator where url.isFileURL {
			cache[url.lastPathComponent] = url
		}
	}
	
	static func urlForRestServicesTestsDir() -> URL {
		let currentFileURL = URL(fileURLWithPath: "\(#file)", isDirectory: false)
		return currentFileURL
			.deletingLastPathComponent()
			.deletingLastPathComponent()
	}
	
	func url(for fileName: String) -> URL? {
		return cache[fileName]
	}
}
