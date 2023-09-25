//
//  WallpaperView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import SwiftUI

struct WallpaperView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private var imageName = ""
    
    init(image: String) {
        imageName = image
    }
    
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    VStack {
                        let url = "\(Constants.remoteImagesFolder)/\(imageName)"
                        AsyncImage(url: URL(string: url)) { image in
                            image.image?
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        }
                        .padding()
                        Spacer()
                        
                        Button {
                            DispatchQueue.global(qos: .userInitiated).async {
                                do {
                                    let image = try Utilities.downloadImageFromServer(imageName: imageName)
                                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                                }
                                catch {
                                    print("sdfasdf")
                                }
                            }
                        } label: {
                            Label("Download Wallpaper", systemImage: "square.and.arrow.down")
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        
                        Button {
                            do {
                                /*let image = try Utilities.downloadImageFromServer(imageName: imageName)
                                let items = [image]
                                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                                present(ac, animated: true)*/
                                
                                let isc = ImageShareController()
                                let image = try Utilities.downloadImageFromServer(imageName: imageName)
                                isc.shareImage(image: image)
                            }
                            catch {
                                
                            }
                        } label: {
                            Label("Share Wallpaper", systemImage: "square.and.arrow.up")
                                .padding()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        Button {
                            
                        } label: {
                            Label("Open in Browser", systemImage: "globe")
                                .padding()
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    //Heavily based off of https://stackoverflow.com/questions/56571349/custom-back-button-for-navigationviews-navigation-bar-in-swiftui
    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left") // set image here
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor)
                    Text("Go Back")
            }
        }
}
