//
//  ViewController.swift
//  Testing
//
//  Created by NghiaNT on 24/6/25.
//

import UIKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private let viewModel = PhotoListViewModel(
        fetchUseCase: FetchPhotosUseCaseImpl(
            repository: PhotoRepository()
        )
    )

    private var filtered: [PhotoEntity] = []
    private var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupTable()
        setupBindings()
        viewModel.loadNext()
    }

    private func setupGesture() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(hideTap))
        tapGes.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGes)
    }

    private func setupTable() {
        tableView.registerXib(ImageCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    @objc private func hideTap() {
        view.endEditing(true)
    }

    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func showLoadingFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        footerView.addSubview(spinner)

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])

        tableView.tableFooterView = footerView
    }

    private func hideLoadingFooter() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
        let t = String(text.prefix(15))
            .folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(
                of: "[^A-Za-z0-9!@#$%^&*():\\.,<>/\\\\\\[\\]\\?]",
                with: "",
                options: .regularExpression
            )

        searchBar.text = t

        if t.isEmpty {
            isSearching = false
        } else {
            isSearching = true
            filtered = viewModel.photos.filter {
                $0.author.lowercased().contains(t.lowercased()) || $0.id.contains(t)
            }
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filtered.count : viewModel.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: ImageCell.self, for: indexPath)
        let model = isSearching ? filtered[indexPath.row] : viewModel.photos[indexPath.row]
        cell.setupModel(model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = isSearching ? filtered[indexPath.row] : viewModel.photos[indexPath.row]
        let width = tableView.bounds.width
        let ratio = CGFloat(model.height) / CGFloat(model.width)
        let padding: CGFloat = 60 + 20
        return ratio * width + padding
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = isSearching ? filtered.count : viewModel.photos.count
        if indexPath.row == count - 5 && viewModel.hasMore && !viewModel.isLoading {
            viewModel.loadNext()
        }
    }
}
