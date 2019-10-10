//
// Deeplab.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class DeeplabInput : MLFeatureProvider {
	
	/// ImageTensor__0 as color (kCVPixelFormatType_32BGRA) image buffer, 513 pixels wide by 513 pixels high
	var ImageTensor__0: CVPixelBuffer
	
	var featureNames: Set<String> {
		get {
			return ["ImageTensor__0"]
		}
	}
	
	func featureValue(for featureName: String) -> MLFeatureValue? {
		if (featureName == "ImageTensor__0") {
			return MLFeatureValue(pixelBuffer: ImageTensor__0)
		}
		return nil
	}
	
	init(ImageTensor__0: CVPixelBuffer) {
		self.ImageTensor__0 = ImageTensor__0
	}
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class DeeplabOutput : MLFeatureProvider {
	
	/// Source provided by CoreML
	
	private let provider : MLFeatureProvider
	
	
	/// ResizeBilinear_2__0 as 21 x 65 x 65 3-dimensional array of doubles
	lazy var ResizeBilinear_2__0: MLMultiArray = {
		[unowned self] in return self.provider.featureValue(for: "ResizeBilinear_2__0")!.multiArrayValue
		}()!
	
	var featureNames: Set<String> {
		return self.provider.featureNames
	}
	
	func featureValue(for featureName: String) -> MLFeatureValue? {
		return self.provider.featureValue(for: featureName)
	}
	
	init(ResizeBilinear_2__0: MLMultiArray) {
		self.provider = try! MLDictionaryFeatureProvider(dictionary: ["ResizeBilinear_2__0" : MLFeatureValue(multiArray: ResizeBilinear_2__0)])
	}
	
	init(features: MLFeatureProvider) {
		self.provider = features
	}
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class Deeplab {
	var model: MLModel
	
	/// URL of model assuming it was installed in the same bundle as this class
	class var urlOfModelInThisBundle : URL {
		for bundle in Bundle.allBundles {
			print(bundle.resourcePath, bundle.bundlePath, bundle.bundleURL, bundle.resourceURL)
			if let deeplab = bundle.url(forResource: "Deeplab", withExtension: "mlmodelc") {
				return deeplab
			}
		}
		return Bundle.main.url(forResource: "Deeplab", withExtension: "mlmodelc")!
	}
	
	/**
	Construct a model with explicit path to mlmodelc file
	- parameters:
	- url: the file url of the model
	- throws: an NSError object that describes the problem
	*/
	init(contentsOf url: URL) throws {
		self.model = try MLModel(contentsOf: url)
	}
	
	/// Construct a model that automatically loads the model from the app's bundle
	convenience init() {
		try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
	}
	
	/**
	Construct a model with configuration
	- parameters:
	- configuration: the desired model configuration
	- throws: an NSError object that describes the problem
	*/
	@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
	convenience init(configuration: MLModelConfiguration) throws {
		try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
	}
	
	/**
	Construct a model with explicit path to mlmodelc file and configuration
	- parameters:
	- url: the file url of the model
	- configuration: the desired model configuration
	- throws: an NSError object that describes the problem
	*/
	@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
	init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
		self.model = try MLModel(contentsOf: url, configuration: configuration)
	}
	
	/**
	Make a prediction using the structured interface
	- parameters:
	- input: the input to the prediction as DeeplabInput
	- throws: an NSError object that describes the problem
	- returns: the result of the prediction as DeeplabOutput
	*/
	func prediction(input: DeeplabInput) throws -> DeeplabOutput {
		return try self.prediction(input: input, options: MLPredictionOptions())
	}
	
	/**
	Make a prediction using the structured interface
	- parameters:
	- input: the input to the prediction as DeeplabInput
	- options: prediction options
	- throws: an NSError object that describes the problem
	- returns: the result of the prediction as DeeplabOutput
	*/
	func prediction(input: DeeplabInput, options: MLPredictionOptions) throws -> DeeplabOutput {
		let outFeatures = try model.prediction(from: input, options:options)
		return DeeplabOutput(features: outFeatures)
	}
	
	/**
	Make a prediction using the convenience interface
	- parameters:
	- ImageTensor__0 as color (kCVPixelFormatType_32BGRA) image buffer, 513 pixels wide by 513 pixels high
	- throws: an NSError object that describes the problem
	- returns: the result of the prediction as DeeplabOutput
	*/
	func prediction(ImageTensor__0: CVPixelBuffer) throws -> DeeplabOutput {
		let input_ = DeeplabInput(ImageTensor__0: ImageTensor__0)
		return try self.prediction(input: input_)
	}
	
	/**
	Make a batch prediction using the structured interface
	- parameters:
	- inputs: the inputs to the prediction as [DeeplabInput]
	- options: prediction options
	- throws: an NSError object that describes the problem
	- returns: the result of the prediction as [DeeplabOutput]
	*/
	@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
	func predictions(inputs: [DeeplabInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [DeeplabOutput] {
		let batchIn = MLArrayBatchProvider(array: inputs)
		let batchOut = try model.predictions(from: batchIn, options: options)
		var results : [DeeplabOutput] = []
		results.reserveCapacity(inputs.count)
		for i in 0..<batchOut.count {
			let outProvider = batchOut.features(at: i)
			let result =  DeeplabOutput(features: outProvider)
			results.append(result)
		}
		return results
	}
}
