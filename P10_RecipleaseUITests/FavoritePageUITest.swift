//
//  FavoritePageUITest.swift
//  P10_RecipleaseUITests
//
//  Created by RICHEUX Antoine on 21/05/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import XCTest

class FavoritePageUITest: XCTestCase {
    
    var app: XCUIApplication!
    var detailTable: XCUIElement?
    var favoriteTable: XCUIElement?
    
    override func setUp() {
        super.setUp()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        detailTable = app.tables["detailTable"]
        favoriteTable = app.tables["favoriteTable"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_ResultPage() {
        showEmptyCellIfNoFavorite()
        searchRecipeAndGoToResultPage()
        addRecipeInFavorite()
        checkIfFavoriteExistAndDelete()
        showEmptyCellIfNoFavorite()
    }
    
    func showEmptyCellIfNoFavorite() {
        app.tabBars.buttons["Favorites"].tap()
        if let table = favoriteTable {
            XCTAssertTrue(table.cells.element(boundBy: 0).staticTexts["Aucun favori enregistré"].exists)
        }
    }
    
    func searchRecipeAndGoToResultPage(){
        app.tabBars.buttons["Search"].tap()
        addIngredient("Eggs")
        addIngredient("Cheese")
        app.buttons["Search for recipe"].tap()
        sleep(3)
        XCTAssert(app.navigationBars["Recipe result"].exists)
    }
    
    func addIngredient(_ ingredient: String){
        let ingredientField = app.textFields["eggs, cheese, ham..."]
        ingredientField.tap()
        ingredientField.typeText(ingredient)
        app.tables.staticTexts[ingredient].tap()
        app.buttons["Add"].tap()
    }
    
    func addRecipeInFavorite() {
        app.tables["resultTable"].cells.element(boundBy: 1).tap()
        if let table = detailTable {
            XCTAssertTrue(table.cells.element(boundBy: 1).staticTexts["Cheese Eggs"].exists)
            app.navigationBars["Recipe detail"].otherElements["Rating"].tap()
            app.navigationBars["Recipe detail"].buttons["Result"].tap()
        }
        app.tables["resultTable"].cells.element(boundBy: 1).tap()
    }
    
    func checkIfFavoriteExistAndDelete() {
        app.tabBars.buttons["Favorites"].tap()
        if let table = favoriteTable {
            XCTAssertTrue(table.cells.element(boundBy: 0).staticTexts["Cheese Eggs"].exists)
            table.cells.element(boundBy: 0).tap()
        }
        app.navigationBars["Recipe detail"].otherElements["Rating"].tap()
    }
}
