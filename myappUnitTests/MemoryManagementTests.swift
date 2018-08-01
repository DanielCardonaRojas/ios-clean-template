//
//  MemoryManagementTests.swift
//
//  Created by Daniel Cardona on 1/26/18.
//  Copyright © 2018 Daniel Esteban Cardona Rojas. All rights reserved.
//

import XCTest
@testable import myapp

class MemoryManagementTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPresenterDoesntRetainView() {
        let nav: UINavigationController = LightShowListWireframe.createModule(from: ())
        var viewController = nav.viewControllers.first as! MyModelListViewController
        var presenter: MyModelListPresenter = viewController.presenter!
        //TODO: Test that deallocating the view also releases the presenter.
        let otherView = LightShowListWireframe.createModule(from: ()).viewControllers.first as! MyModelListViewController
        viewController = otherView
        XCTAssertNil(presenter.view)
    }

}
