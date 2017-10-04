//
//  CollectionPopInDelegate.swift
//  WeatherApp
//
//  Created by Marvin DRION on 04/10/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//


protocol CollectionPopInDelegate: class {
    func didSelectItem(object: Any)
    func getLabel(object: Any) -> String
    func getId(object: Any) -> String
}

