//
//  AlbumListPresenter.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation


protocol PresenterToRouterAlbumSearchListProtocol {
	static func createAlbumSearchListRouter(albumListVC: ViewController)
}

protocol PresenterToViewAlbumSearchListProtocol {
	func onAlbumSearchSucces(albumList: [Album])
	func onAlbumSearchFailed(errorMsg: String)
}

protocol ViewToPresenterAlbumSearchListProtocol {
	
	var presenterView: PresenterToViewAlbumSearchListProtocol? {get set}
	var interactor: PresenterToInteractorAlbumSearchListProtocol? {get set}
	var router: PresenterToRouterAlbumSearchListProtocol? {get set}
	
	func getDataFromAlbumListInteractor(for queryText: String)
}


class AlbumListPresenter: ViewToPresenterAlbumSearchListProtocol {
	
	var presenterView: PresenterToViewAlbumSearchListProtocol?
	
	var interactor: PresenterToInteractorAlbumSearchListProtocol?
	
	var router: PresenterToRouterAlbumSearchListProtocol?
	
	func getDataFromAlbumListInteractor(for queryText: String)  {
		if queryText.isEmpty {
			self.presenterView?.onAlbumSearchFailed(errorMsg: K_Msg_SearchEmpty)
			return
		}
		self.interactor?.getAlbumSearchListFromNetwork(with: queryText)
	}
}

extension AlbumListPresenter: InteractorToPresenterAlbumSearchListProtocol {
	func albumSearchSuccess(albumList: [Album]) {
		self.presenterView?.onAlbumSearchSucces(albumList: albumList)
	}
	
	func albumSearchFailed(errorMsg: String) {
		self.presenterView?.onAlbumSearchFailed(errorMsg: errorMsg)
	}
}
