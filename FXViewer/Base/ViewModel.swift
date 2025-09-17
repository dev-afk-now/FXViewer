//
//  ViewModel.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

import Foundation
import Combine

open class BaseViewModel<State: ViewModelState>: ObservableObject {

    @Published private(set) var state: State

    var cancellables = Set<AnyCancellable>()

    func start() {
       fatalError("method 'start' should be overrided")
    }
    
    internal func updateState(newValue: State) {
        state = newValue
    }
    
    init(state: State) {
        self.state = state
    }

    deinit {
        cancel()
    }

    private func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
