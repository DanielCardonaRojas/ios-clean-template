//
//  DataManagerTest.swift
//
//  Created by Daniel Esteban Cardona Rojas on 11/8/17.
//  Copyright © 2017 Daniel Esteban Cardona Rojas. All rights reserved.
//

import XCTest
@testable import myapp

class DataManagerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDataManager() {
        let apiRepo = AnyRepository(ApiRepository<LightShow>(baseURL: "api.somthing.com"))
        let dataManager : DataManager<LightShow> = DataManager(apiRepository: apiRepo, cacheRepository: nil)
        let _ : GetLightShowsUseCase = GetLightShowsUseCase(manager: dataManager)
        let _ : GetLightShowsUseCase = GetLightShowsUseCase(manager: DataManager<LightShow>.defaultDataManager())
    }
    

}
