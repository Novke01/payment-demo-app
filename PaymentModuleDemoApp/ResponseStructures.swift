//
//  ResponseStructures.swift
//  Dms
//
//  Created by Marko Stajic on 12/2/16.
//  Copyright © 2016 DMS. All rights reserved.
//

import Foundation

public struct GeneralResponse {
    public let success: Bool
    public let error: Error?
    public let message: String
}

public struct LoginResponse {
    public let success: Bool
    public let user: User?
    public let error: Error?
    public let message: String
}

public struct CardsResponse {
    public let success: Bool
    public let cards: [Card]?
    public let error: Error?
    public let message: String
}

public struct TransactionsResponse {
    public let success: Bool
    public let transacations: [Transaction]?
    public let error: Error?
    public let message: String
}

public struct TransactionResponse {
    public let success: Bool
    public let transaction: Transaction?
    public let error: Error?
    public let message: String
}

public struct ChannelsResponse {
    public let success: Bool
    public let channels: [Channel]?
    public let error: Error?
    public let message: String
}
