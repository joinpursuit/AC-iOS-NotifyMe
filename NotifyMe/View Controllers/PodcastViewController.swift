//
//  PodcastViewController.swift
//  NotifyMe
//
//  Created by Alex Paul on 2/15/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications

class PodcastViewController: UIViewController {
    
    private var unNotificationCenter: UNUserNotificationCenter!
    private var currentSelectedPodcast: Podcast!
    private var currentImage: UIImage!
    private var alarmTime: TimeInterval = 0.0 {
        didSet {
            triggerTimeNotification()
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.bounds)
        tv.register(PodcastCell.self, forCellReuseIdentifier: "PodcastCell")
        tv.dataSource = self
        tv.delegate = self
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
        
        // ask the user permission for notifications
        unNotificationCenter = UNUserNotificationCenter.current()
        unNotificationCenter.delegate = self
        unNotificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("request access error: \(error)")
            } else {
                print("access granted")
            }
        }
        
        view.addSubview(tableView)
        if let podcasts = JSONParser.parseJSONFile(filename: "podcasts", type: "json") {
            self.podcasts = podcasts
        }
        navigationItem.title = "Podcasts"
    }
    
    private func triggerTimeNotification() {
        // create content
        let content = UNMutableNotificationContent()
        content.title = "\(currentSelectedPodcast.collectionName) Reminder"
        content.body = "\(currentSelectedPodcast.collectionName) will start live feed very shortly."
        content.sound = UNNotificationSound.default()
        
        // adding an image to our notification message
        // we need to write to disk, so we are writing to the documents folder
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageIdentifier = "image.png"
        let filePath = documentDirectory.appendingPathComponent(imageIdentifier)
        
        // converts an image to data to write to disk
        let imageData = UIImagePNGRepresentation(currentImage)
        do {
            try imageData?.write(to: filePath) // e.g. /Documents/image.png
            let attachment = try UNNotificationAttachment.init(identifier: imageIdentifier, url: filePath, options: nil)
            content.attachments = [attachment]
        } catch {
            print("write error: \(error)")
        }
        
        // configure trigger
        // other ways of triggering local notifications:
        // * UNCalendarNotificationTrigger()
        // * UNLocationNotificationTrigger()
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: alarmTime, repeats: false)
        
        // create request
        let request = UNNotificationRequest(identifier: "PodcastAlarm", content: content, trigger: trigger)
        
        // schedule request
        unNotificationCenter.add(request) { (error) in
            if let error = error {
                print("request notification error: \(error)")
            }
        }
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

extension PodcastViewController: UITableViewDelegate {
    fileprivate func showAlertSheet() {
        let alertController = UIAlertController(title: "Reminder", message: "Live feed of Podcast starting soon", preferredStyle: .actionSheet)
        let twentySecondsAction = UIAlertAction(title: "20 Seconds", style: .default, handler: { action in self.alarmTime = 20.0 })
        let oneMinuteAction = UIAlertAction(title: "1 minute", style: .default, handler: { action in self.alarmTime = 60.0 })
        let oneHourAction = UIAlertAction(title: "1 hour", style: .default, handler: { action in self.alarmTime = 3600.0 })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(twentySecondsAction)
        alertController.addAction(oneMinuteAction)
        alertController.addAction(oneHourAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PodcastCell
        currentImage = cell.podcastImage.image
        currentSelectedPodcast = podcasts[indexPath.row]
        showAlertSheet()
    }
}

extension PodcastViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
