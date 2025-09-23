//
//  FileManager.swift
//  FXViewer
//
//  Created by Nik Dub on 9/22/25.
//

import Foundation

final class FileManagerService: Storage {
    private let storage = FileManager.default
    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            
    }
    
    func getValue<T>(for key: String) -> T? where T : StorageObject {
        guard let url = fileURL?.appendingPathComponent(key),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let model = T(from: data)
            return model
        } catch {
            print("Failed to load: \(error.localizedDescription)")
            return nil
        }
    }
    
    func set(_ value: any StorageObject, for key: String) {
        guard let url = fileURL?.appendingPathComponent(key),
        let data = value.toData() else {
            return
        }
        do {
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
    }
    
    func removeValue(for key: String) {
        guard let url = fileURL?.appendingPathComponent(key) else {
            return
        }
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
                print("File removed: \(url.lastPathComponent)")
            }
        } catch {
            print("Failed to remove file: \(error.localizedDescription)")
        }
    }
    
    func clear() {
        removeValue(for: .empty)
    }
}
