//
//  AlbumDetailIntarctor.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import UIKit


protocol InteractorToPresenterAlbumDetailProtocol {
	func albumDetailSuccess(albumList: [Album])
	func albumDetailFailed(errorMsg: String)
	func updateImage(_ downloadedImg: UIImage?)
}

protocol PresenterToInteractorAlbumDetailProtocol {
	var presenter: InteractorToPresenterAlbumDetailProtocol? {get set}
	func getAlbumDetailFromNetwork(with queryText: String)
	func getImageFromNetwork(with imageUrl: URL)
}


class AlbumDetailIntarctor : PresenterToInteractorAlbumDetailProtocol {
	var presenter: InteractorToPresenterAlbumDetailProtocol?
	func getAlbumDetailFromNetwork(with queryText: String) {
		
		/// TODO: -  Need to make rest api call to get all details of the selected album
	}
	
	func getImageFromNetwork(with imageUrl: URL) {
		NetworkServices.fetchImage(for: imageUrl) { (downloadedImg) in
			self.presenter?.updateImage(downloadedImg)
		}
	}
}
