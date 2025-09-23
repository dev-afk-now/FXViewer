//
//  PullHeaderView.swift
//  FXViewer
//
//  Created by Nik Dub on 9/22/25.
//

import UIKit

protocol PullProgressDelegate: AnyObject {
    var onAction: () -> () { get set }
    func pullProgressDidChange(_ progress: CGFloat)
    func scrollDidEnd()
}

class PullHeaderView: UILabel, PullProgressDelegate {
    var onAction: () -> () = {}
    
    private var reachedRequiredProgress = false
    
    func scrollDidEnd() {
        if reachedRequiredProgress {
            reachedRequiredProgress = false
            onAction()
            self.alpha = .zero
        }
    }
    
    func pullProgressDidChange(_ progress: CGFloat) {
        self.alpha = progress
        if progress == 1 {
            reachedRequiredProgress = true
        }
    }
}
