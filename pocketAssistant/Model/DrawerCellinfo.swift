//
//  DrawerCellinfo.swift
//  pocketAssistant
//
//  Created by William Simiao on 31/05/19.
//  Copyright © 2019 William Simiao. All rights reserved.
//

import Foundation

public struct drawerMenuInfo: Codable {
    public var sections: [section]
}

public struct section: Codable {
    public var sectionTitle: String
    
    public var cellItens: [cellInfo]
}

public struct cellInfo: Codable {
    
    public var title: String
    
    public var leftImageName: String
    
}
