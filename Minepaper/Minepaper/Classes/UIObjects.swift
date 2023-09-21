//
//  UIObjects.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import Foundation

class WallpaperOption: Identifiable {
    
    init(imageName: String) {
        _imageName = imageName
    }
    
    private var _imageName: String = ""
    var imageName: String {
        set {
            _imageName = newValue
        }
        get {
            return _imageName
        }
    }
    
    var fullImageUrl: String {
        get {
            return "\(Constants.remoteImagesFolder)/\(_imageName)"
        }
    }
}
