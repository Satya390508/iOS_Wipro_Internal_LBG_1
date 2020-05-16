//
//  AlbumDetailVC.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 14/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import UIKit


class AlbumDetailVC: UIViewController {
	
	@IBOutlet weak var imgvw_large: UIImageView!
	@IBOutlet weak var lbl_name: UILabel!
	@IBOutlet weak var lbl_artist: UILabel!

	var albumDetailPresenter: AlbumDetailPresenter?
	
	var album: Album?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		AlbumDetailRouter.createAlbumDetailRouter(albumDetailVC: self)
		
		self.lbl_name.text = "Album Name : \(album?.name ?? "N/A")"
		self.lbl_artist.text = "Artist Name : \(album?.artist ?? "N/A")"
		self.imgvw_large.image = UIImage(named: "music_icon")
		
		let largeImg: AlbumImage = (album?.image?.filter {$0.size == "large"}.last)!
		if !largeImg.link!.isEmpty {
			let imgUrl = URL(string: largeImg.link!)!
			self.albumDetailPresenter?.getImage(for: imgUrl)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}


// MARK:- TableView DataSource Methods
extension AlbumDetailVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let tcell: UITableViewCell?
		if indexPath.row == 0 {
			tcell = tableView.dequeueReusableCell(withIdentifier: KAlbumDetailCellID)
		}
		else {
			tcell = tableView.dequeueReusableCell(withIdentifier: KTrackListCellID)
		}
		
		return tcell!
	}
}

// MARK:- Presenter Methods
extension AlbumDetailVC: PresenterToViewAlbumDetailProtocol {
	func onAlbumDetailSucces(albumList: [Album]) {
		/// TODO: - Success Handler
	}
	
	func onAlbumDetailFailed(errorMsg: String) {
		/// TODO: - Failure Handler
	}
	
	func onImageUpdate(_ updatedImg: UIImage?) {
		if updatedImg != nil {
			DispatchQueue.main.async {
				self.imgvw_large.image = updatedImg
			}
		}
	}
}
