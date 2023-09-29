//
//  UIObjects.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import Foundation
import SwiftUI

struct TabletPhoneStack<Content: View>: View {
    
    var horizontalAlignment = HorizontalAlignment.center
    var verticalAlignment = VerticalAlignment.center
    var spacing: CGFloat?
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            VStack(
                alignment: horizontalAlignment,
                spacing: spacing,
                content: content
            )
        }
        else {
            HStack(
                alignment: verticalAlignment,
                spacing: spacing,
                content: content
            )
        }
    }
}

class WallpaperOption: ObservableObject {
    
    init(imageName: String, uiImage: UIImage) {
        _imageName = imageName
        _uiImage = uiImage
    }
    
    var image: Image {
        get {
            return Image(uiImage: uiImage)
        }
    }
    
    private var _uiImage: UIImage = UIImage()
    var uiImage: UIImage {
        set {
            _uiImage = newValue
        }
        get {
            return _uiImage
        }
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
