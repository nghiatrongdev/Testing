//
//  Ex-Global.swift
//  Testing
//
//  Created by NghiaNT on 24/6/25.
//

import Foundation
import UIKit
extension NSObject {
    public var identify: String {
        String(describing: type(of: self))
    }
    
    public static var identify: String {
        String(describing: self)
    }
}

extension UITableView {
    private func reuseIndentifier<T>(for type: T.Type) -> String {
        return String(describing: type)
    }
    
    public func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: reuseIndentifier(for: cell))
    }
    
    public func registerXib(_ cell: UITableViewCell.Type) {
        let nib = UINib(nibName: cell.identify, bundle: nil)
        register(nib, forCellReuseIdentifier: cell.identify)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(for type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: reuseIndentifier(for: type), for: indexPath) as? T else {
            fatalError("Failed to dequeue cell.")
        }
        
        return cell
    }
}
