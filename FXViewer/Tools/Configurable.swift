//
//  Configurable.swift
//  FXViewer
//
//  Created by Nik Dub on 9/16/25.
//

protocol Configurable {
    associatedtype Model
    func configure(with model: Model)
}
