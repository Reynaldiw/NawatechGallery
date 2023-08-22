//
//  SendResourcePresentationAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Combine
import Foundation

final class SendResourcePresentationAdapter<Resource> {
    
    private let sender: (Resource) -> AnyPublisher<Void, Error>
    private var cancellable: Cancellable?
    private var isLoading = false
    
    var presenter: SendResourcePresenter?
    
    init(sender: @escaping (Resource) -> AnyPublisher<Void, Error>) {
        self.sender = sender
    }
    
    func send(_ resource: Resource) {
        guard !isLoading else { return }
        
        presenter?.didStartLoading()
        isLoading = true
        
        cancellable = sender(resource)
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.presenter?.didFinishLoading(with: error)
                }
                
                self?.isLoading = false
            } receiveValue: { [weak self] _ in
                self?.presenter?.didFinishLoading(with: nil)
            }
    }
}
