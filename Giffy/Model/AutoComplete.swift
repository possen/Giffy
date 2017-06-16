//
//  AutoComplete.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/16/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class AutoComplete {
    static let path = "/tmp/trieDict"
    let trie : Trie
    
    init() throws {
        do {
            self.trie = try Trie.load(path: AutoComplete.path)
        } catch  {
            trie = try Trie.constructTrie()
            try trie.save(path: AutoComplete.path)
        }
    }
    
    func reset() throws {
        try Trie.erase(path: AutoComplete.path)
    }
    
    func findValues(forTerm string : String) -> [String] {
        if string == "resetme" {
            do {
                try reset()
                print("reset complete")
                
            } catch {
                print("reset failed")
            }
        }
        // need more than 2 chars otherwise lists are too long. 
        return string.count >= 2 ? trie.findValues(forTerm: string) : []
    }
}
