//
//  Constants.swift
//  LBG_1
//
//  Created by SatyaRanjan Mohapatra on 13/05/20.
//  Copyright © 2020 SatyaranjanMohapatra. All rights reserved.
//

import Foundation

let BASE_URL = "http://ws.audioscrobbler.com/2.0/"
let API_KEY = "3c1e366cfe22f5dcbcc3f336945bee8d"
let SECRET_KEY = "5001796d2c38005519a3ac0d520b3afa"

// Common messages
let K_Msg_ParsingFailed = "Oops! Data parsing failed."
let K_Msg_NetworkError = "Oops! You are not connected with the internet. Please check your network connectivity"

// Album Search list messages
let K_Msg_SearchEmpty = "Please type the album name and tap on search."
let K_Msg_EmptyListReceived = "Oops! Could not find a match for album name "
let K_Msg_NetErr_SearchList = K_Msg_NetworkError + " and then try searching."

// Album Detail messages
let K_Msg_EmptyDetailReceived = "Oops! Could not find the details of the album "


let KAlbumListCellID = "AlbumListCell"
let KAlbumDetailCellID = "AlbumDetailCell"
let KTrackListCellID = "TrackListCell"

