//
//  Podcast.swift
//  NotifyMe
//
//  Created by Alex Paul on 2/15/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import Foundation
import UIKit

struct Podcast: Codable {
    let collectionName: String
    let artworkUrl600: URL
    let artistName: String
}

struct Results: Codable {
    let results: [Podcast]
}
