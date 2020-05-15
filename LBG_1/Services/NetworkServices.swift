//
//  NetworkServices.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation
import UIKit


class NetworkServices {
	static func fetchAlbumList(for queryText: String, complitionHandler: @escaping (Data?, String?) -> Void) {
		var urlComps = URLComponents(string: BASE_URL)!
		let queryItems = [URLQueryItem(name: "format", value: "json"),
				  URLQueryItem(name: "method", value: "album.search"),
				  URLQueryItem(name: "api_key", value: API_KEY),
				  URLQueryItem(name: "album", value: queryText)]
		urlComps.queryItems = queryItems
		
		let networkTask = URLSession.shared.dataTask(with: urlComps.url!) { (receivedData, receivedResponse, receivedErr) in
			
			if (receivedErr != nil) {
				complitionHandler(nil, receivedErr?.localizedDescription)
			}

			complitionHandler(receivedData, nil)
		}
		networkTask.resume()
	}
		
	static func fetchImage(for imgUrl:URL, complitionHandler: @escaping (UIImage?) -> Void) {
		let imgDownloadTask = URLSession.shared.downloadTask(with: imgUrl) { (imgLocation, response, error) in
			
			guard let imgLocation = imgLocation else {
				complitionHandler(nil)
				return
			}
			
			let data = try! Data(contentsOf: imgLocation)
			let image = UIImage(data: data)
			complitionHandler(image)
		}
		imgDownloadTask.resume()
	}
}
