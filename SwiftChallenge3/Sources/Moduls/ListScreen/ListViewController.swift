//
//  ListViewController.swift
//  SwiftChallenge3
//
//  Created by Андрей Кузнецов on 21.09.2022.
//

import UIKit

class ListViewController: UITableViewController {
    
    var playList: PlayListModel? {
        didSet {
            title = playList?.playListName
            tableView.reloadData()
        }
    }
    
    var realmManager = RealmBaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        realmManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        realmManager.loadFavourites()
    }
    
    private func configureTableView() {
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: TrackTableViewCell.reuseIdentifier)
    }
    
    private func configureUI() {
        let sortButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(sortPlaylist))
        sortButtonItem.image = UIImage(systemName: "list.bullet.indent")
        self.navigationItem.rightBarButtonItem  = sortButtonItem
    }
    
    @objc private func sortPlaylist() {
        print("Sort Playlist")
    }
}

// MARK: - TableView data source

extension ListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playList?.tracks.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.reuseIdentifier, for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        cell.track = playList?.tracks[indexPath.row]
        return cell
    }
}

// MARK: - TableView delegate

extension ListViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let track = playList?.tracks[indexPath.row] else { return }
        realmManager.addToRecentPlayed(track: track)
        print("Segue in controller player")
    }
}

//MARK: - Realm Base Manager Delegate

extension ListViewController: RealmBaseManagerDelegate {
    
    func showError(error: Error) {
        print("!!!ListViewController - Realm Base Error!!!")
        print(error.localizedDescription)
    }
    
    func favouriteTracksDidLoad(_ playList: PlayListModel) {
        self.playList = playList
        self.configureUI()
    }
    
    func recentPlayedTracksDidLoad(_ playList: PlayListModel) {
        
    }
}
