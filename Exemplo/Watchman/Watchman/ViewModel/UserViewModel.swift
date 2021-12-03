//
//  UserViewModel.swift
//  Watchman
//
//  Created by Pedro Henrique on 02/12/21.
//

import Foundation
import Combine
import UserNotifications

class UserViewModel: ObservableObject {
    
    private let watch = WatchConnectivityProvider()
    
    @Published
    private(set) var loading = false

    @Published
    private(set) var users = [User]() {
        didSet {
            loading = false
        }
    }
    
    @Published
    var selectedUser: User?
    
    private var usersCancellationToken: AnyCancellable?
    
    
    #if os(watchOS)
        init() {
            watch.onUserSelected = onUSerSelected(_:)
        }
    
        func onUSerSelected(_ user: User?) {
            DispatchQueue.main.async { [weak self] in
                self?.selectedUser = user
            }
        }
        
    #endif
    
    
    func fetchUsers() {
        usersCancellationToken?.cancel()
        
        
        let session = URLSession.shared
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/users") {
            loading = true
            usersCancellationToken = session.dataTaskPublisher(for: url)
                .tryMap(readResponse(_:))
                .decode(type: [User].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .breakpointOnError()
                .sink(receiveCompletion: sinkError(_:)) { self.users = $0 }
            
        }
    }
    
    func sendToWatch(_ user: User) {
        selectedUser = user
        if let data = try? JSONEncoder().encode(user) {
            watch.send(data: data)
            
            let content = UNMutableNotificationContent()
            content.body = "Selected User"
            
            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: nil
            )
            
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge]) { authorized, error in
                    if authorized {
                        UNUserNotificationCenter.current()
                            .add(request) { error in
                                if let error = error {
                                    debugPrint(error.localizedDescription)
                                }
                            }
                    }
                    if let error = error {
                        debugPrint(error.localizedDescription)
                    }
                }
        }
    }
    
    private func readResponse(_ transform: (data: Data, res: URLResponse)) throws -> Data {
        guard let response = transform.res as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  throw URLError(.badServerResponse)
              }
        return transform.data
    }
    
}
