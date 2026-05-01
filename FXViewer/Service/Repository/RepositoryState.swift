//
//  RepositoryState.swift
//  FXViewer
//
//  Created by Nik Dub on 9/23/25.
//

protocol RepositoryState {}

enum CurrencyRepositoryState: RepositoryState {
    case idle
    case updated([CurrencyModel])
    case cached([CurrencyModel])
    case error(FXError)
}
