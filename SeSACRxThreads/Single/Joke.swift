//
//  Joke.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import Foundation

struct Joke: Codable {
    let error: Bool
    let category, type, joke: String
    let id: Int
    let safe: Bool
    let lang: String
}
