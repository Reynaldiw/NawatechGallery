//
//  CombineHelpers.swift
//  NawatechGallery
//
//  Created by Reynaldi on 20/08/23.
//

import Combine
import Foundation

// MARK: - Login

public extension AuthenticationValidationService {
    typealias Publisher = AnyPublisher<UserAccount, Swift.Error>
    
    func validatePublisher(_ user: AuthenticationUserBody) -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.validate(user)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

public extension Publisher where Output == UserAccount {
    func caching(to cache: AccountCacheStoreSaver) -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { account in
            cache.saveIgnoringResult(account.id.uuidString)
        }).eraseToAnyPublisher()
    }
}

private extension AccountCacheStoreSaver {
    func saveIgnoringResult(_ accountID: String) {
        try? save(accountID)
    }
}

//MARK: Registration

public extension RegistrationUserAccountService {
    typealias Publisher = AnyPublisher<Void, Swift.Error>
    
    func registerPublisher(_ user: RegistrationUserAccount) -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.register(user)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: Motorcycle Catalogue

public extension MotorycleCatalogueStore {
    typealias Publisher = AnyPublisher<Data, Swift.Error>
    
    func retrievePublisher() -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.retrieve()
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: HTTP Client

public extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Swift.Error>
    
    func getPublisher(from url: URL) -> Publisher {
        return Deferred {
            Future { completion in
                get(from: url, completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: Account Cache Store

public extension AccountCacheStoreRetriever {
    typealias Publisher = AnyPublisher<String?, Swift.Error>
    
    func retrievePublisher() -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.retrieve()
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: User Account Store

public extension UserAccountStoreRetriever {
    typealias Publisher = AnyPublisher<Data, Swift.Error>
    
    func retrievePublisher(_ query: UserAccountQuery) -> Publisher {
        return Deferred {
            Future { completion in
                completion(Result {
                    try self.retrieve(query)
                })
            }
        }
        .eraseToAnyPublisher()
    }
}

//MARK: - Scheduler

extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler.shared
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        var minimumTolerance: SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        static let shared = Self()
        
        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max
        
        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        private func isMainQueue() -> Bool {
            return DispatchQueue.getSpecific(key: Self.key) == Self.value
        }
        
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            
            action()
        }
        
        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}

typealias AnyDispatchQueueScheduler = AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>

extension Scheduler {
    func eraseToAnyScheduler() -> AnyScheduler<SchedulerTimeType, SchedulerOptions> {
        AnyScheduler(self)
    }
}

struct AnyScheduler<SchedulerTimeType: Strideable, SchedulerOptions>: Scheduler where SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    
    private let _now: () -> SchedulerTimeType
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _schedule: (SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleAfter: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Void
    private let _scheduleAfterInterval: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Cancellable
    
    init<S>(_ scheduler: S) where SchedulerTimeType == S.SchedulerTimeType, SchedulerOptions == S.SchedulerOptions, S: Scheduler {
        _now = { scheduler.now }
        _minimumTolerance = { scheduler.minimumTolerance }
        _schedule = scheduler.schedule(options:_:)
        _scheduleAfter = scheduler.schedule(after:tolerance:options:_:)
        _scheduleAfterInterval = scheduler.schedule(after:interval:tolerance:options:_:)
    }
    
    var now: SchedulerTimeType { _now() }
    
    var minimumTolerance: SchedulerTimeType.Stride { _minimumTolerance() }
    
    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _schedule(options, action)
    }
    
    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        _scheduleAfter(date, tolerance, options, action)
    }
    
    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        _scheduleAfterInterval(date, interval, tolerance, options, action)
    }
}
