//
//  WallpaperView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import SwiftUI
import AlertToast
import Photos

struct WallpaperView: View {
    
    @State private var showingToast = false
    @State private var toastMessage = ""
    @State private var showingAlert = false
    @State private var alert: Alert = Alert(title: Text(""))
    
    var wallpaperOption: WallpaperOption
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        Image(uiImage: wallpaperOption.uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding()
                        Spacer()
                        
                        TabletPhoneStack {
                            Spacer()
                            Button {
                                let authStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                                if authStatus == .authorized || authStatus == .notDetermined {
                                    UIImageWriteToSavedPhotosAlbum(wallpaperOption.uiImage, nil, nil, nil)
                                    toastMessage = "Wallpaper saved"
                                    showingToast = true
                                }
                                else {
                                    alert = Alert(
                                        title: Text("Can't save photo"),
                                        message: Text("Minepaper does not have permission to save to your photos. This can be changed in settings."),
                                        primaryButton: .default(Text("Open settings")) {
                                            Utilities.openAppSettings()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                    
                                    showingAlert = true
                                }
                            } label: {
                                Label("Download Wallpaper", systemImage: "square.and.arrow.down")
                                    .padding()
                                    .font(.custom(MinecraftFonts.Regular, size: 15))
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                            
                            ShareLink(
                                item: wallpaperOption.image,
                                preview: SharePreview("Share Image", image: wallpaperOption.image)
                            ) {
                                Label("Share Wallpaper", systemImage: "square.and.arrow.up")
                                    .padding()
                                    .font(.custom(MinecraftFonts.Regular, size: 15))
                            }
                            .buttonStyle(.bordered)
                            .padding()
                            
                            Button {
                                if let url = URL(string: wallpaperOption.fullImageUrl), UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url)
                                }
                                else {
                                    toastMessage = "Failed to open in browser. Please try again later."
                                    showingToast = true
                                }
                            } label: {
                                Label("Open in Browser", systemImage: "globe")
                                    .padding()
                                    .font(.custom(MinecraftFonts.Regular, size: 15))
                            }
                            .buttonStyle(.bordered)
                            .padding()
                            
                            Spacer()
                        }
                    }
                }
            }
        }
        .toast(isPresenting: $showingToast) {
            AlertToast(type: .regular, title: toastMessage, 
                       style: AlertToast.AlertStyle.style(titleFont: .custom(MinecraftFonts.Regular, size: 20)))
        }
        .alert(isPresented: $showingAlert) {
            alert
        }
    }
}
