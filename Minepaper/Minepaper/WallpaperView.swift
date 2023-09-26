//
//  WallpaperView.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/24/23.
//

import SwiftUI

struct WallpaperView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isShowingShareWindow = false
    @State private var imageToShare: UIImage?
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
                                    let image: UIImage = try Utilities.downloadImageFromServer(imageName: imageName)
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
                            /*DispatchQueue.global(qos: .userInitiated).async {
                                do {
                                    let tempImage: Image = try Utilities.downloadImageFromServer(imageName: imageName)
                                    DispatchQueue.main.sync {
                                        imageToShare = tempImage
                                        isShowingShareWindow = true
                                    }
                                }
                                catch {
                                    
                                }
                            }*/
                            
                            do {
                                imageToShare = try Utilities.downloadImageFromServer(imageName: imageName)
                                isShowingShareWindow = true
                            }
                            catch {
                                
                            }
                        } label: {
                            Label("Share Wallpaper", systemImage: "square.and.arrow.up")
                                .padding()
                        }
                        .sheet(isPresented: $isShowingShareWindow) {
                            ImageShareView(activityItems: [imageToShare!])
                        }
                        .buttonStyle(.bordered)
                        .padding()
                        
                        Button {
                            let loc = "\(Constants.remoteImagesFolder)/\(imageName)"
                            if let url = URL(string: loc), UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                            else {
                                
                            }
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
