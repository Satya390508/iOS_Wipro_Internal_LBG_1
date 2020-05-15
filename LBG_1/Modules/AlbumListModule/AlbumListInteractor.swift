//
//  AlbumListInteractor.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation


protocol PresenterToInteractorAlbumSearchListProtocol {
	
	var presenter: InteractorToPresenterAlbumSearchListProtocol? {get set}
	func getAlbumSearchListFromNetwork(with queryText: String)

}

protocol InteractorToPresenterAlbumSearchListProtocol {
	func albumSearchSuccess(albumList: [Album])
	func albumSearchFailed(errorMsg: String)

}


class AlbumListInteractor : PresenterToInteractorAlbumSearchListProtocol {
	var presenter: InteractorToPresenterAlbumSearchListProtocol?

	var reachability = InternetReachability.networkReachabilityForInternetConnection()

	/**
	* Get data from external sources such as
	* - URLSession based networking call (REST API)
	* - Get data from local data base (xml, plist, strings file, coredata, sqlite)
	* - Get data from file systems (e.g. image from within a folder )
	*/
	
	func getAlbumSearchListFromNetwork(with queryText: String) {
		
		guard let  reachability = reachability, reachability.isReachable else {
			self.presenter?.albumSearchFailed(errorMsg: K_Msg_NetErr_SearchList)
			return
		}

		NetworkServices.fetchAlbumList(for: queryText) { (receivedData, errorMsg) in
			if errorMsg != nil {
				self.presenter?.albumSearchFailed(errorMsg: errorMsg!)
				return
			}
			
			guard let receivedData = receivedData, receivedData.count > 0 else {
				print("data nil / 0 size")
				self.presenter?.albumSearchFailed(errorMsg: K_Msg_EmptyListReceived + "\"\(queryText)\".")
				return
			}
			
			do {
				let albumSearchResult = try JSONDecoder().decode(AlbumSearchResult.self, from: receivedData)
				guard let searchItem = albumSearchResult.searchItem, let albumList = searchItem.albums, albumList.count > 0 else {
					self.presenter?.albumSearchFailed(errorMsg: K_Msg_EmptyListReceived + "\"\(queryText)\".")
					return
				}
				self.presenter?.albumSearchSuccess(albumList: albumList)
			}
			catch {
				self.presenter?.albumSearchFailed(errorMsg: K_Msg_ParsingFailed + "\n\"\(error.localizedDescription)\"")
			}
		}
	}
}
