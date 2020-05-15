//
//  AlbumListEntity.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 13/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation


struct AlbumImage: Codable {
	let link: String?
	let size: String?
	
	enum AlbumImageKeys: String, CodingKey {
		case link = "#text"
		case size
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: AlbumImageKeys.self)
		link = try container.decodeIfPresent(String.self, forKey: .link) ?? "NA"
		size = try container.decodeIfPresent(String.self, forKey: .size) ?? "NA"
	}
}

struct Album: Codable {
	let name: String?
	let artist: String?
	let link: String?
	let streamable: String?
	let mbid: String?
	
	let image: [AlbumImage]?

	enum AlbumKeys: String, CodingKey {
		case name
		case artist
		case link = "url"
		case streamable
		case mbid

		case image
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: AlbumKeys.self)
		name = try container.decodeIfPresent(String.self, forKey: .name) ?? "NA"
		artist = try (container.decodeIfPresent(String.self, forKey: .artist) ?? "NA")
		link = try container.decodeIfPresent(String.self, forKey: .link) ?? "NA"
		streamable = try container.decodeIfPresent(String.self, forKey: .streamable) ?? "NA"
		mbid = try container.decodeIfPresent(String.self, forKey: .mbid) ?? "NA"
		
		image = try container.decodeIfPresent([AlbumImage].self, forKey: .image)
	}
}

struct SearchQuery: Codable {
	let text: String?
	let role: String?
	let searchTerms: String?
	let startPage: String?
	
	enum SearchQueryKeys: String, CodingKey {
		case text = "#text"
		case role
		case searchTerms
		case startPage
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: SearchQueryKeys.self)
		text = try container.decodeIfPresent(String.self, forKey: .text) ?? "NA"
		role = try container.decodeIfPresent(String.self, forKey: .role) ?? "NA"
		searchTerms = try container.decodeIfPresent(String.self, forKey: .searchTerms) ?? "NA"
		startPage = try container.decodeIfPresent(String.self, forKey: .startPage) ?? "NA"
	}
}

struct AlbumSearch: Codable {
	let query: SearchQuery?
	let totalResults: String?
	let startIndex: String?
	let itemsPerPage: String?
	let albums: [Album]? // albummatches
	let attrFor: String? // "@attr">"for">String
	
	enum AlbumSearchKeys: String, CodingKey {
		case query = "opensearch:Query"
		case totalResults = "opensearch:totalResults"
		case startIndex = "opensearch:startIndex"
		case itemsPerPage = "opensearch:itemsPerPage"
		case albums = "albummatches"
		case attrFor = "@attr"
	}
	
	enum AlbumArrayKey: String, CodingKey {
		case album = "album"
	}

	enum AttrKey: String, CodingKey {
		case forKey = "for"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: AlbumSearchKeys.self)
		query = try container.decodeIfPresent(SearchQuery.self, forKey: .query)
		totalResults = try container.decodeIfPresent(String.self, forKey: .totalResults) ?? "NA"
		startIndex = try container.decodeIfPresent(String.self, forKey: .startIndex) ?? "NA"
		itemsPerPage = try container.decodeIfPresent(String.self, forKey: .itemsPerPage) ?? "NA"

		let albumContainer = try container.nestedContainer(keyedBy: AlbumArrayKey.self, forKey: .albums)
		albums = try albumContainer.decodeIfPresent([Album].self, forKey: .album)
		
		let attrContainer = try container.nestedContainer(keyedBy: AttrKey.self, forKey: .attrFor)
		attrFor = try attrContainer.decodeIfPresent(String.self, forKey: .forKey)
	}
}

struct AlbumSearchResult: Codable {
	let searchItem: AlbumSearch?
	
	enum SearchResultKeys: String, CodingKey {
		case searchItem = "results"
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: SearchResultKeys.self)
		searchItem = try container.decodeIfPresent(AlbumSearch.self, forKey: .searchItem)
	}
}
