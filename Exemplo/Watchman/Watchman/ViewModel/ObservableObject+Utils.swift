//
//  ObservableObject+Utils.swift
//  Watchman
//
//  Created by Pedro Henrique on 02/12/21.
//

import Combine

extension ObservableObject {
    
    internal func sinkError(_ completion: Subscribers.Completion<Error>) {
        switch completion {
            case .failure(let error): debugPrint(error)
            default: break
        }
    }
    
}
