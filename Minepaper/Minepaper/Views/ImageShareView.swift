//
//  ImageShareController.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import Foundation
import SwiftUI

struct ImageShareView: UIViewControllerRepresentable {
    
    var activityItems: [UIImage]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
