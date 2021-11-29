//
//  ServerSelectionViewController.swift
//  dcss-ios
//
//  Created by Jonathan Lazar on 11/28/21.
//

import Combine
import SwiftUI

struct WebTilesServer {
    let location: String
    let name: String
    let url: URL
    
    static let CKO = WebTilesServer(location: "New York, USA", name: "crawl.kelbi.org", url: URL(string: "https://crawl.kelbi.org/#lobby")!)
    static let CAO = WebTilesServer(location: "Arizona, USA", name: "crawl.akrasiac.org", url: URL(string: "http://crawl.akrasiac.org:8080/#lobby")!)
    static let CUE = WebTilesServer(location: "Amsterdam, Netherlands, Europe", name: "underhound.eu", url: URL(string: "https://underhound.eu:8080/#lobby")!)
    static let CBR2 = WebTilesServer(location: "Ohio, USA", name: "cbro.beRotato.org", url: URL(string: "https://cbro.berotato.org:8443/#lobby")!)
    
    static let all = [CKO, CAO, CUE, CBR2]
}

protocol ServerSelectionDelegate: AnyObject {
    func didSelectServer(serverURL: URL)
}

final class ServerSelectionViewController: UIHostingController<ServerSelectionView> {
    
    init(delegate: ServerSelectionDelegate) {
        let view = ServerSelectionView(delegate: delegate)
        super.init(rootView: view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ServerSelectionView: View {
    
    weak var delegate: ServerSelectionDelegate?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(WebTilesServer.all, id: \.url) { server in
                    if #available(iOS 15.0, *) {
                        text(server: server)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                let vm = DefaultServerViewModel(server: server)
                                DefaultServerView(viewModel: vm)
                            }
                    } else {
                        text(server: server)
                    }
                }
            }
            .navigationTitle("Select server")
        }
    }
    
    private func text(server: WebTilesServer) -> some View {
        Text("\(server.name) - \(server.location)")
            .onTapGesture {
                delegate?.didSelectServer(serverURL: server.url)
            }
    }
}

class DefaultServerViewModel: ObservableObject {
    
    @Published var isDefault: Bool = false
    
    private let server: WebTilesServer
    private var cancellable: Cancellable?
    
    init(server: WebTilesServer) {
        self.server = server
        cancellable = UserDefaults.standard
            .publisher(for: \.defaultServerURL)
            .sink { defaultServerURL in
                self.isDefault = defaultServerURL == server.url
            }
    }

    func toggleDefault() {
        let userDefaults = UserDefaults.standard
        if isDefault {
            userDefaults.defaultServerURL = nil
        } else {
            userDefaults.defaultServerURL = server.url
        }
    }
}
struct DefaultServerView: View {
    
    @ObservedObject var viewModel: DefaultServerViewModel

    var body: some View {
        Button(viewModel.isDefault ? "Remove default" : "Make default") {
            viewModel.toggleDefault()
        }
    }
}
