//
//  Coordinator.swift
//  FXViewer
//
//  Created by Nik Dub on 9/17/25.
//

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func back()
    func childDidFinish(_ child: Coordinator?)
}
