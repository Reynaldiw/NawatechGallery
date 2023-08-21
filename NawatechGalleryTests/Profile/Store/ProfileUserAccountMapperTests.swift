//
//  ProfileUserAccountMapperTests.swift
//  NawatechGalleryTests
//
//  Created by Reynaldi on 21/08/23.
//

import XCTest
import NawatechGallery

final class ProfileUserAccountMapperTests: XCTestCase {
    func test_map_deliversErrorOnInvalidData() throws {
        let invalidData = Data("Invalid values".utf8)
        
        XCTAssertThrowsError(
            try ProfileUserAccountMapper.map(invalidData)
        )
    }
}
