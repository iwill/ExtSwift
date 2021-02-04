//
//  ViewController.swift
//  iOSExample
//
//  Created by Mr. Ming on 2021-01-09.
//  Copyright (c) 2021 Mr. Ming <minglq.9@gmail.com>. Released under the MIT license.
//

import UIKit

import ExtSwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testOperators()
    }
    
    func testOperators() {
        
        let some: String? = "x", some2: String? = "y", none: String? = nil
        
        print(??some  == true)
        print(!?some  == false)
        print(??none  == false)
        print(!?none  == true)
        
        print(!?some  == !(??some))
        print(!?none  == !(??none))
        
        print(!true   == false)
        print(!false  == true)
        print(!1      == false)
        print(!0      == true)
        print(!1.0    == false)
        print(!0.0    == true)
        print(!some   == false)
        print(!none   == true)
        
        print(!!true  == true)
        print(!!false == false)
        print(!!1     == true)
        print(!!0     == false)
        print(!!1.0   == true)
        print(!!0.0   == false)
        print(!!some  == true)
        print(!!none  == false)
        
        print(!!some  == !(!some))
        print(!!true  == !(!true))
        print(!!1     == !(!1))
        print(!!1.0   == !(!1.0))
        print(!!none  == !(!none))
        print(!!false == !(!false))
        print(!!0     == !(!0))
        print(!!0.0   == !(!0.0))
        
        print(0 ??! 1 == 1)
        print(1 ??! 0 == 1)
        print(0 ??! 0 == 0)
        print(1 ??! 2 == 1)
        
        // print(0 ?!! 1 == 0)
        // print(1 ?!! 0 == 0)
        // print(0 ?!! 0 == 0)
        // print(1 ?!! 2 == 2)
        
        print(false ??! true  == true)
        print(true  ??! false == true)
        print(false ??! false == false)
        print(true  ??! true  == true)
        
        // print(false ?!! true  == false)
        // print(true  ?!! false == false)
        // print(false ?!! false == false)
        // print(true  ?!! true  == true)
        
        print(none  ??! some  == some)
        print(some  ??! none  == some)
        print(none  ??! none  == none)
        print(some  ??! some2 == some)
        
        // print(none  ?!! some  == none)
        // print(some  ?!! none  == none)
        // print(none  ?!! none  == none)
        // print(some  ?!! some2 == some2)
        
    }
    
}

