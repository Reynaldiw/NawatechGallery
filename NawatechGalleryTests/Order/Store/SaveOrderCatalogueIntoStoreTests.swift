//
//  SaveOrderCatalogueIntoStoreTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 22/08/23.
//

import XCTest
import NawatechGallery

final class SaveOrderCatalogueIntoStoreTests: XCTestCase {
    
    func test_save_doesNotSaveUponSUTCreation() {
        let store = StoreSaverStub()
        let sut = StoreOrderCatalogueSaver(store: store)
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_save_requestsValueInsertion() {
        let orderID = UUID()
        let store = StoreSaverStub()
        let sut = StoreOrderCatalogueSaver(store: store, orderID: orderID)
        
        try? sut.save(UUID())
        
        XCTAssertEqual(store.messages, [.save(name: orderID.uuidString)])
    }
    
    func test_save_deliversErrorOnInsertionError() throws {
        let anyError = NSError(domain: "any-error", code: 0)
        let store = StoreSaverStub(error: anyError)
        let sut = StoreOrderCatalogueSaver(store: store, orderID: UUID())
        
        XCTAssertThrowsError(try sut.save(UUID()))
    }
    
    func test_save_didNotDeliversErrorOnSuccessfulInsertion() {
        let store = StoreSaverStub(error: nil)
        let sut = StoreOrderCatalogueSaver(store: store, orderID: UUID())
        
        XCTAssertNoThrow(try sut.save(UUID()))
    }
    
    //MARK: - Helpers
    
    private class StoreSaverStub: StoreSaver {
        
        enum Message: Equatable {
            case save(name: String)
        }
        
        private(set) var messages: [Message] = []
        
        private var error: Error?
        
        init(error: Error? = nil) {
            self.error = error
        }
        
        func save(_ value: [String : Any], namedWith name: String) throws {
            messages.append(.save(name: name))
            
            if let error = error {
                throw error
            }
        }
    }
}
