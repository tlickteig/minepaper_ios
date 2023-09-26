//
//  ImageShareController.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import Foundation
import SwiftUI

struct ImageShareView: UIViewControllerRepresentable {
    
    var image: UIImage
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [image, self], applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
