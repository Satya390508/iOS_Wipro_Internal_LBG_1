//
//  AlbumDetailPresenter.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import UIKit


protocol PresenterToRouterAlbumDetailProtocol {
	static func createAlbumDetailRouter(albumDetailVC: AlbumDetailVC)
}

protocol PresenterToViewAlbumDetailProtocol {
	func onAlbumDetailSucces(albumList: [Album]) // TODO: - Need to change to AlbumDetail Object
	func onAlbumDetailFailed(errorMsg: String)
}

protocol ViewToPresenterAlbumDetailProtocol {
	
	var presenterView: PresenterToViewAlbumDetailProtocol? {get set}
	var interactor: PresenterToInteractorAlbumDetailProtocol? {get set}
	var router: PresenterToRouterAlbumDetailProtocol? {get set}
	
	func getDataFromAlbumDetailInteractor(for queryText: String)
}


class AlbumDetailPresenter: ViewToPresenterAlbumDetailProtocol {
	
	var presenterView: PresenterToViewAlbumDetailProtocol?
	
	var interactor: PresenterToInteractorAlbumDetailProtocol?
	
	var router: PresenterToRouterAlbumDetailProtocol?
	
	func getDataFromAlbumDetailInteractor(for queryText: String)  {
		if queryText.isEmpty {
			self.presenterView?.onAlbumDetailFailed(errorMsg: K_Msg_SearchEmpty)
			return
		}
		self.interactor?.getAlbumDetailFromNetwork(with: queryText)
	}
	
	func getImage(for imageUrl: URL) {
		self.interactor?.getImageFromNetwork(with: imageUrl)
	}
}

extension AlbumDetailPresenter: InteractorToPresenterAlbumDetailProtocol {
	func albumDetailSuccess(albumList: [Album]) {
		self.presenterView?.onAlbumDetailSucces(albumList: albumList)
	}
	
	func albumDetailFailed(errorMsg: String) {
		self.presenterView?.onAlbumDetailFailed(errorMsg: errorMsg)
	}
	
	func updateImage(_ downloadedImg: UIImage?) {
		guard let detailView = self.presenterView as? AlbumDetailVC, let updatedImg = downloadedImg else { return }
		DispatchQueue.main.async {
			detailView.imgvw_large.image = updatedImg
		}
	}
}
