//
//  Utilities.swift
//  Minepaper
//
//  Created by Timothy Lickteig on 9/20/23.
//

import Foundation
import SwiftUI

struct Utilities {
    
    static func getImageListFromServer() throws -> [String] {
        
        var output = [String]()
        let sephamore = DispatchSemaphore(value: 0)
        
        do {
            var request = URLRequest(url: URL(string: Constants.remoteImageListEndpoint)!)
            request.httpMethod = "GET"
            var stringResult = ""
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if data == nil || response == nil {
                    stringResult = ""
                } else {
                    stringResult = String(data: data!, encoding: String.Encoding    .utf8)!
                }
                
                sephamore.signal()
            }
            
            task.resume()
            sephamore.wait()
            
            if stringResult == "" {
                throw NetworkError.GeneralError
            }
            
            let resultData = Data(stringResult.utf8)
            let resultDict = try JSONSerialization.jsonObject(with: resultData, options: []) as! [String: Any]
            if resultDict["files"] == nil {
                throw NetworkError.DataFormatError
            }
            else if resultDict["files"] is [String] {
                output = resultDict["files"] as! [String]
            }
            else {
                throw NetworkError.DataFormatError
            }
            
        } catch {
            throw error
        }
        
        return output
    }
    
    static func downloadImageFromServer(imageName: String) throws -> UIImage {
        
        let url = "\(Constants.remoteImagesFolder)/\(imageName)"
        var output = UIImage(systemName: "x.circle.fill")
        
        if let data = try? Data(contentsOf: URL(string: url)!) {
            output = UIImage(data: data)
        }
        else {
            throw NetworkError.GeneralError
        }
        
        return output!
    }
}
