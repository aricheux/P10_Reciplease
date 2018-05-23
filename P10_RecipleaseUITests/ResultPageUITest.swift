//
//  ResultPageUITest.swift
//  P10_RecipleaseUITests
//
//  Created by RICHEUX Antoine on 19/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import UIKit
import XCTest

class ResultPageUITest: XCTestCase {
        
    var app: XCUIApplication!
    var resultTable: XCUIElement?
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        resultTable = app.tables["resultTable"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_ResultPage() {
        searchRecipeAndGoToResultPage()
        sheckResultAndGoToDetailRecipe()
    }
    
    func searchRecipeAndGoToResultPage(){
        addIngredient("Eggs")
        addIngredient("Cheese")
        app.buttons["Search for recipe"].tap()
        sleep(1)
        XCTAssert(app.navigationBars["Recipe result"].exists)
    }
    
    func addIngredient(_ ingredient: String){
        let ingredientField = app.textFields["eggs, cheese, ham..."]
        ingredientField.tap()
        ingredientField.typeText(ingredient)
        app.tables.staticTexts[ingredient].tap()
        app.buttons["Add"].tap()
    }
    
    func checkResultAndGoToDetailRecipe(){
        if let table = resultTable {
            let recipeTwo = table.cells.element(boundBy: 1)
            XCTAssertTrue(recipeTwo.staticTexts["Cheese Eggs"].exists)
            XCTAssertTrue(recipeTwo.staticTexts["eggs, american cheese slices"].exists)
            XCTAssertTrue(recipeTwo.staticTexts["15 min"].exists)
            recipeTwo.tap()
            XCTAssert(app.navigationBars["Recipe detail"].exists)
        }
    }
}
