//
//  AlbumListRouter.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation
import UIKit


class AlbumListRouter : PresenterToRouterAlbumSearchListProtocol {

	static var mainstoryboard: UIStoryboard {
		return UIStoryboard(name: "Main", bundle: nil)
	}

	static func createAlbumSearchListRouter(albumListVC: ViewController) {

		let presenter: ViewToPresenterAlbumSearchListProtocol & InteractorToPresenterAlbumSearchListProtocol = AlbumListPresenter()

		albumListVC.albumListPresenter = presenter as? AlbumListPresenter
		albumListVC.albumListPresenter?.router = AlbumListRouter()
		albumListVC.albumListPresenter?.presenterView = albumListVC
		albumListVC.albumListPresenter?.interactor = AlbumListInteractor()
		albumListVC.albumListPresenter?.interactor?.presenter = presenter
	}
}


