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
    
    //MARK: - Helpers
    
    private class StoreSaverStub: StoreSaver {
        
        enum Message: Equatable {
            case save(value: [String: AnyHashable], name: String)
        }
        
        private(set) var messages: [Message] = []
        
        func save(_ value: [String : Any], namedWith name: String) throws {
        }
    }
}
