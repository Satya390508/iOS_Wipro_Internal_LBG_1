//
//  ViewController.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 12/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import UIKit
//import Reachability

class ViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	let lbl_EmptyList: UILabel = UILabel()
	let searchController = UISearchController(searchResultsController: nil)

	var albumListPresenter: AlbumListPresenter?

	var albumList = [Album]()
	var imgCache:NSCache<AnyObject, AnyObject>!
	
        override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view.

		/// Setting up the search feature
		self.searchController.searchBar.placeholder = "Search albums here!"
		self.tableView.tableHeaderView = self.searchController.searchBar
		self.searchController.searchResultsUpdater = self
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.definesPresentationContext = true

		/// Setting up the empty view for the table view for search failure
		self.tableView.tableFooterView = UIView()
		self.lbl_EmptyList.frame = CGRect(origin: CGPoint(x: 30, y: 30), size: CGSize(width: self.view.frame.width - 60, height: self.view.frame.height - 60))
		self.lbl_EmptyList.text = K_Msg_SearchEmpty
		self.lbl_EmptyList.textAlignment = .center
		self.lbl_EmptyList.numberOfLines = 0
		let emptyMsgView = UIView()
		self.tableView.backgroundView = emptyMsgView
		emptyMsgView.addSubview(lbl_EmptyList)

		self.imgCache = NSCache()

		AlbumListRouter.createAlbumSearchListRouter(albumListVC:self)
		
		self.tableView.isScrollEnabled = false // To stop scrolling the empty tableview
        }
}

// MARK:- TableView DataSource Methods
extension ViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let rowCount = self.albumList.count
		tableView.backgroundView?.isHidden = (rowCount != 0)
		return rowCount
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: KAlbumListCellID, for: indexPath) as! AlbumCell

		let currAlbum: Album = self.albumList[indexPath.row]
		cell.lbl_name.text = currAlbum.name
		cell.imgvw_icon.image = UIImage(named: "music_icon")
		
		if (self.imgCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
			cell.imgvw_icon?.image = self.imgCache.object(forKey: (indexPath.row as AnyObject)) as? UIImage
		}
		else {
			let smallImg: AlbumImage = (currAlbum.image?.filter {$0.size == "small"}.last)!
			if !smallImg.link!.isEmpty {
				let imgUrl:URL = URL(string: smallImg.link!)!
				
				NetworkServices.fetchImage(for: imgUrl) { (downloadedImg) in
					if downloadedImg != nil {
						self.imgCache.setObject(downloadedImg!, forKey: (indexPath.row as AnyObject))
						DispatchQueue.main.async {
							cell.imgvw_icon?.image = downloadedImg
						}
					}
				}
			}
		}
                return cell
        }
}

// MARK:- TableView Delegate Methods
extension ViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		DispatchQueue.main.async {
			self.searchController.searchBar.resignFirstResponder()
		}
	}
}


// MARK:- UISearchResultUpdating Methods
extension ViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		self.tableView.isScrollEnabled = searchController.isActive
		guard let searchTxt = searchController.searchBar.text else { return }		
		self.albumListPresenter?.getDataFromAlbumListInteractor(for: searchTxt)
	}
}


// MARK:- Presenter Methods
extension ViewController: PresenterToViewAlbumSearchListProtocol {
	func onAlbumSearchSucces(albumList: [Album]) {
		self.albumList.append(contentsOf: albumList)
		DispatchQueue.main.async { self.tableView.reloadData() }
	}
	
	func onAlbumSearchFailed(errorMsg: String) {
		DispatchQueue.main.async {
			self.lbl_EmptyList.text = self.searchController.isActive ? errorMsg : K_Msg_SearchEmpty
			self.albumList.removeAll()
			self.tableView.reloadData()
		}
	}
}
