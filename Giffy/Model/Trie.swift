//
//  Trie.swift
//  Giffy
//
//  Created by Paul Ossenbruggen on 6/15/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import Foundation

class Trie : Encodable, Decodable  {
    enum TrieErrors : Error {
        case loadError()
        case saveError()
    }
    
    var children: [String: Trie] = [:] // can't encode decode characters
    let leaf: Bool
    
    init(leaf: Bool) {
        self.leaf = leaf
    }
    
    /// returns results in sorted order
    func findValues(forTerm string : String) -> [String] {
        let transformedString = string.lowercased()
        let base = findBase(transformedString)
        var results = [String]()
        base?.compileResults(fromBase: transformedString, path:"", results: &results)
        results.sort(by: <)
        return results
    }
    
    static func addWords(_ words : ArraySlice<String.SubSequence>) -> Trie {
        let root =  Trie(leaf: false)
        for word in words {
            print(word)
            root.addRemaining(word.lowercased())
        }
        return root
    }
    
    static func constructTrie(size: Int = Int.max) throws -> Trie {
        // just read the first N words from dictionary.
        let file = try String(contentsOfFile: "/usr/share/dict/words", encoding: .utf8)
        let split = file.split(separator: "\n")
        let words = size == Int.max ? split[0..<split.count] : split[0..<size]
        return Trie.addWords(words)
    }
    
    func save(path: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        let string = String(data: data, encoding: .utf8)
        try string?.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    static func load(path: String) throws -> Trie {
        let string = try String(contentsOfFile: path, encoding: .utf8)
        let decoder = JSONDecoder()
        if let data = string.data(using: .utf8, allowLossyConversion: false) {
            return try decoder.decode(Trie.self, from: data)
        } else {
            throw TrieErrors.loadError()
        }
    }
    
    static func erase(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    private func addRemaining(_ word : String) {
        var word = word
        let char = String(word.remove(at: word.startIndex))
        var child = children[char]
        if child == nil {
            child = Trie(leaf: word.isEmpty)
            children[char] = child
        }
        if !word.isEmpty {
            child!.addRemaining(word)
        }
    }
    
    private func findBase(_ word  : String) -> Trie? {
        var word = word
        if !word.isEmpty {
            let char = String(word.remove(at: word.startIndex))
            if let trie = children[char] {
                return trie.findBase(word)
            } else {
                return nil
            }
        }
        return self
    }
    
    private func compileResults(fromBase baseString: String,
                                    path : String, results : inout [String])  {
        if leaf {
            results.append("\(baseString)\(path)")
        }
        
        for (key, value) in children {
            let newPath = "\(path)\(key)"
            value.compileResults(fromBase: baseString, path: newPath, results: &results)
        }
    }
}

