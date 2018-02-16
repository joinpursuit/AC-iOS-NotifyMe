//
//  PodcastCell.swift
//  NotifyMe
//
//  Created by Alex Paul on 2/15/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import SnapKit

class PodcastCell: UITableViewCell {
    
    lazy var podcastImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var podcastTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var author: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "PodcastCell")
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PodcastCell {
    private func setupViews() {
        setupPodcastImage()
        setupPodcastTitle()
        setupAuthor()
    }
    
    private func setupPodcastImage() {
        addSubview(podcastImage)
        podcastImage.snp.makeConstraints { (make) in
            make.height.equalTo(snp.height)
            make.width.equalTo(podcastImage.snp.height)
            make.leading.equalTo(self)
        }
    }
    
    private func setupPodcastTitle() {
        let padding: CGFloat = 16
        addSubview(podcastTitle)
        podcastTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(podcastImage.snp.trailing).offset(padding)
            make.top.equalTo(snp.top).offset(padding)
            make.trailing.equalTo(self).offset(-padding)
        }
    }
    
    private func setupAuthor() {
        let padding: CGFloat = 16
        addSubview(author)
        author.snp.makeConstraints { (make) in
            make.leading.equalTo(podcastTitle.snp.leading)
            make.top.equalTo(podcastTitle.snp.bottom)
            make.trailing.equalTo(self).offset(-padding)
        }
    }
    
    public func configureCell(podcast: Podcast) {
        podcastImage.kf.setImage(with: podcast.artworkUrl600)
        podcastTitle.text = podcast.collectionName
        author.text = podcast.artistName
    }
}
