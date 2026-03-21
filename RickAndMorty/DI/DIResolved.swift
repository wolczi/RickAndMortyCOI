//
//  DIResolved.swift
//  RickAndMorty
//
//  Created by Przemek Wołczacki on 21/03/2026.
//

import Foundation
import Swinject

@propertyWrapper
struct DIResolved<T> {
    let wrappedValue: T
    
    init(name: String? = nil, file: String = #file, line: Int = #line) {
        let value = DI.synchronizedResolver.resolve(T.self, name: name)
        
        wrappedValue = value!
    }
}
