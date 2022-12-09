//
//  Project39Tests.swift
//  Project39Tests
//
//  Created by Joseph Van Alstyne on 12/9/22.
//

import XCTest
@testable import Project39

final class Project39Tests: XCTestCase {

    override func setUpWithError() throws {
		
		// Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
		
		// Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testAllWordsLoaded() {
		let playData = PlayData()
		XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
	}
	
	func testWordCountsAreCorrect() {
		let playData = PlayData()
		XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home does not appear 174 times")
		XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Fun does not appear 4 times")
		XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Mortal does not appear 41 times")
	}
	
	func testWordsLoadQuickly() {
		measure {
			_ = PlayData()
		}
	}
	
	func testUserFilterWorks() {
		let playData = PlayData()

		playData.applyUserFilter("100")
		XCTAssertEqual(playData.filteredWords.count, 495, "495 words that appear 100+ times not found")

		playData.applyUserFilter("1000")
		XCTAssertEqual(playData.filteredWords.count, 55, "55 words that appear 1,000+ times not found")

		playData.applyUserFilter("10000")
		XCTAssertEqual(playData.filteredWords.count, 1, "1 word that appears 10,000+ times not found")

		playData.applyUserFilter("test")
		XCTAssertEqual(playData.filteredWords.count, 56, "56 words that match 'test' not found")

		playData.applyUserFilter("swift")
		XCTAssertEqual(playData.filteredWords.count, 7, "7 words that match 'swift' not found")

		playData.applyUserFilter("objective-c")
		XCTAssertEqual(playData.filteredWords.count, 0, "0 words that match 'objective-c' not found")
	}

}
