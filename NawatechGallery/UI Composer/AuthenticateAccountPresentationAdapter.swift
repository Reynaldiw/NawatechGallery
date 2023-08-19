//
//  AuthenticateAccountPresentationAdapter.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Combine
import Foundation

final class AuthenticateAccountPresentationAdapter<Account> {
    
    private let authenticate: (Account) -> AnyPublisher<Void, Error>
    private var cancellable: Cancellable?
    private var isLoading = false
    
    var presenter: AuthenticateAccountPresenter?
    
    init(authenticate: @escaping (Account) -> AnyPublisher<Void, Error>) {
        self.authenticate = authenticate
    }
    
    func authenticate(_ account: Account) {
        guard !isLoading else { return }
        
        presenter?.didStartLoading()
        isLoading = true
        
        cancellable = authenticate(account)
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
