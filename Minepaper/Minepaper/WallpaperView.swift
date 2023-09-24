//
//  WallpaperView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import SwiftUI

struct WallpaperView: View {
    
    private var imageName = ""
    
    init(image: String) {
        imageName = image
    }
    
    var body: some View {
        Text(imageName)
    }
}
