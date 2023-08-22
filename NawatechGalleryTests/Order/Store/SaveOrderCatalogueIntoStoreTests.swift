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
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.messages, [])
    }
    
    func test_save_requestsValueInsertion() {
        let orderID = UUID()
        let (sut, store) = makeSUT(orderID: orderID)
        
        try? sut.save(UUID())
        
        XCTAssertEqual(store.messages, [.save(name: orderID.uuidString)])
    }
    
    func test_save_deliversErrorOnInsertionError() throws {
        let storeError = NSError(domain: "any-error", code: 0)
        let (sut, _) = makeSUT(error: storeError)
        
        XCTAssertThrowsError(try sut.save(UUID()))
    }
    
    func test_save_didNotDeliversErrorOnSuccessfulInsertion() {
        let (sut, _) = makeSUT()
        
        XCTAssertNoThrow(try sut.save(UUID()))
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        orderID: UUID = UUID(),
        error: Error? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: StoreOrderCatalogueSaver, store: StoreSaverStub) {
        let store = StoreSaverStub(error: error)
        let sut = StoreOrderCatalogueSaver(store: store, orderID: orderID)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
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
