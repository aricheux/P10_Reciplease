//
//  P10_RecipleaseUITests.swift
//  P10_RecipleaseUITests
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import XCTest

class SearchPageUITest: XCTestCase {
    
    var app: XCUIApplication!
    var ingredientTable: XCUIElement?
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        ingredientTable = app.tables["ingredientTable"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_SearchPage() {
        showPopupIfAddEmptyIngredient()
        addTwoIngredientWithList()
        clearAllIngredients()
        addTwoIngredientWithList()
        searchRecipe()
    }
    
    func showPopupIfAddEmptyIngredient() {
        app.buttons["Add"].tap()
        let erreurAlert = app.alerts["Erreur"]
        XCTAssert(erreurAlert.staticTexts["Veuillez renseigner un ingrédient"].exists)
        let okButton = erreurAlert.buttons["Ok"]
        okButton.tap()
    }
    
    func addTwoIngredientWithList() {
        addIngredient("Eggs")
        addIngredient("Cheese")
        
        if let table = ingredientTable {
            table.tap()
            XCTAssertTrue(table.cells.count == 3)
        }
    }
    
    func addIngredient(_ ingredient: String){
        let ingredientField = app.textFields["eggs, cheese, ham..."]
        ingredientField.tap()
        ingredientField.typeText(ingredient)
        app.tables.staticTexts[ingredient].tap()
        app.buttons["Add"].tap()
    }
    
    func clearAllIngredients() {
        if let table = ingredientTable {
            table.cells.element(boundBy: 0).buttons["Clear"].tap()
            XCTAssertTrue(table.cells.count == 1)
        }
    }
    
    func searchRecipe(){
        app.buttons["Search for recipe"].tap()
        sleep(1)
        XCTAssert(app.navigationBars["Recipe result"].exists)
    }
}
