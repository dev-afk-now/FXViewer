//
//  String+Double.swift
//  FXViewer
//
//  Created by Nik Dub on 9/22/25.
//

import Foundation

extension String {
    func formatCurrency(currency: String = "EUR") -> String {
        guard let value = Double(self) else {
            return .empty
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
