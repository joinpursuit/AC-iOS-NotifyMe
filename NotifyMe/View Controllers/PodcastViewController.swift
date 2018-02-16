//
//  PodcastViewController.swift
//  NotifyMe
//
//  Created by Alex Paul on 2/15/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Kingfisher

class PodcastViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.bounds)
        tv.register(PodcastCell.self, forCellReuseIdentifier: "PodcastCell")
        tv.dataSource = self
        tv.rowHeight = 80
        return tv
    }()
    
    private var podcasts = [Podcast]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        if let podcasts = JSONParser.parseJSONFile(filename: "podcasts", type: "json") {
            self.podcasts = podcasts
        }
        navigationItem.title = "Podcasts"
    }
}

extension PodcastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastCell", for: indexPath) as! PodcastCell
        cell.selectionStyle = .none
        let podcast = podcasts[indexPath.row]
        cell.configureCell(podcast: podcast)
        return cell
    }
}
