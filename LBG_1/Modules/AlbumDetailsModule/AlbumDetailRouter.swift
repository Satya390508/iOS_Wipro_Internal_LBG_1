//
//  AlbumDetailRouter.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import UIKit


class AlbumDetailRouter : PresenterToRouterAlbumDetailProtocol {
	
	static func createAlbumDetailRouter(albumDetailVC: AlbumDetailVC) {
		
		let router = AlbumDetailRouter()
		let presenter = AlbumDetailPresenter()
		let interactor = AlbumDetailIntarctor()
		
		albumDetailVC.albumDetailPresenter = presenter
		albumDetailVC.albumDetailPresenter?.router = router
		albumDetailVC.albumDetailPresenter?.interactor = interactor
		albumDetailVC.albumDetailPresenter?.presenterView = albumDetailVC
		albumDetailVC.albumDetailPresenter?.interactor?.presenter = presenter
	}
}


