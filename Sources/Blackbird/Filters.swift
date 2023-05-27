//
//  Filters.swift
//  Blackbird
//
//  Created by Ethan Lipnik on 10/4/19.
//

import Foundation

public enum ColorFilter: String {
    case noir = "CIPhotoEffectNoir"
    case chrome = "CIPhotoEffectChrome"
    case fade = "CIPhotoEffectFade"
    case instant = "CIPhotoEffectInstant"
    case mono = "CIPhotoEffectMono"
    case process = "CIPhotoEffectProcess"
    case tonal = "CIPhotoEffectTonal"
    case transfer = "CIPhotoEffectTransfer"
    case sepia = "CISepiaTone"
    case thermal = "CIThermal"
    case vigantte = "CIVignette"
    case xray = "CIXRay"
    case invert = "CIColorInvert"
}

public enum BlurFilter: String {
    case bokeh = "CIBokehBlur"
    case box = "CIBoxBlur"
    case disc = "CIDiscBlur"
    case gaussian = "CIGaussianBlur"
    case variable = "CIMaskedVariableBlur"
    case median = "CIMedianFilter"
    case morphGradient = "CIMorphologyGradient"
    case motion = "CIMotionBlur"
}

public enum ColorAdjustment: String {
    case clamp = "CIColorClamp"
    case controls = "CIColorControls"
    case matrix = "CIColorMatrix"
    case polynomial = "CIColorPolynomial"
    case exposure = "CIExposureAdjust"
    case gamma = "CIGammaAdjust"
    case hue = "CIHueAdjust"
    case linearToSRGBTone = "CILinearToSRGBToneCurve"
    case SRGBToneToLinear = "CISRGBToneCurveToLinear"
    case tempatureAndTint = "CITemperatureAndTint"
    case tone = "CIToneCurve"
    case vibrance = "CIVibrance"
}

public enum DepthAdjustment: String {
    case depthToDisparity = "CIDepthToDisparity"
    case disparityToDepth = "CIDisparityToDepth"
}

public struct Filter {
    public var name: String
    public var filter: String

    public init(filter: String) {
        self.filter = filter

        switch filter {
        case "CIPhotoEffectNoir":
            name = "Noir"
        case "CIPhotoEffectChrome":
            name = "Chrome"
        case "CIPhotoEffectFade":
            name = "Fade"
        case "CIPhotoEffectInstant":
            name = "Instant"
        case "CIPhotoEffectMono":
            name = "Mono"
        case "CIPhotoEffectProcess":
            name = "Process"
        case "CIPhotoEffectTonal":
            name = "Tonal"
        case "CIPhotoEffectTransfer":
            name = "Transfer"
        case "CISepiaTone":
            name = "Sepia"
        case "CIThermal":
            name = "Thermal"
        case "CIVignette":
            name = "Vigantte"
        case "CIXRay":
            name = "Xray"
        case "CIColorInvert":
            name = "Invert"
        default:
            name = ""
        }
    }
}
