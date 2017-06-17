//
//  GiffyTests.swift
//  GiffyTests
//
//  Created by Paul Ossenbruggen on 6/16/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import XCTest

@testable import Giffy

class GiffyTests: XCTestCase {
    
    let testPath = "/tmp/TestTrieDict"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateSaveLoadTrie() {
        do {
            let trie = try Trie.constructTrie(size: 100)
            try trie.save(path: testPath)
            let newTrie = try Trie.load(path: testPath)
            print(newTrie)
            let vals = newTrie.findValues(forTerm: "ab")
            XCTAssertEqual(["ab", "aba", "ababdeh", "ababua", "abac", "abaca", "abacate", "abacay", "abacinate", "abacination", "abaciscus", "abacist", "aback", "abactinal", "abactinally", "abaction", "abactor", "abaculus", "abacus", "abadite", "abaff", "abaft", "abaisance", "abaiser", "abaissed", "abalienate", "abalienation", "abalone", "abama", "abampere", "abandon", "abandonable", "abandoned", "abandonedly", "abandonee", "abandoner", "abandonment", "abanic", "abantes", "abaptiston", "abarambo", "abaris", "abarthrosis", "abarticular", "abarticulation", "abas", "abase", "abased", "abasedly", "abasedness", "abasement", "abaser", "abasgi", "abash", "abashed", "abashedly", "abashedness", "abashless", "abashlessly", "abashment", "abasia", "abasic", "abask", "abassin", "abastardize", "abatable", "abate", "abatement", "abater", "abatis", "abatised", "abaton", "abator", "abattoir", "abatua", "abature", "abave", "abaxial", "abaxile", "abaze", "abb", "abba", "abbacomes", "abbacy", "abbadide"], vals)
        } catch let error {
            print(error)
            XCTFail()
        }
    }
    
    func testReset() {
        do {
            try Trie.remove(path: testPath)
        } catch {
            XCTFail()
        }
    }
}
