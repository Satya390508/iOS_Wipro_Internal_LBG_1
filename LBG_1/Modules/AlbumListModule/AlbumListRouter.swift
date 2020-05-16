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

	static var mainStoryboard: UIStoryboard {
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
	
	func pushToAlbumDetail(with album: Album, from view: UIViewController) {
		let detailVC = AlbumListRouter.mainStoryboard.instantiateViewController(withIdentifier: "AlbumDetailVC") as! AlbumDetailVC
		detailVC.album = album
		if view.navigationController != nil {
			view.navigationController?.pushViewController(detailVC, animated: true)
		}
		else {
			view.present(detailVC, animated: true, completion: nil)
		}
	}
}


