//
//  AutoComplete.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/16/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class AutoComplete {
    static let storedTriePath = "/tmp/trieDict"
    static let dictonaryWordsPath = "/usr/share/dict/words"
    
    let trie : Trie
    
    init() throws {
        do {
            self.trie = try Trie(storedDataPath: AutoComplete.storedTriePath)
        } catch  {
            trie = try Trie(dictonaryWordsPath: AutoComplete.dictonaryWordsPath)
            try trie.save(path: AutoComplete.storedTriePath)
        }
    }
    
    func reset() throws {
        try Trie.remove(path: AutoComplete.storedTriePath)
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
