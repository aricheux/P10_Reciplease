//
//  P10_RecipleaseUITests.swift
//  P10_RecipleaseUITests
//
//  Created by RICHEUX Antoine on 17/04/2018.
//  Copyright © 2018 Richeux Antoine. All rights reserved.
//

import XCTest

class P10_RecipleaseUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        app.tables.buttons["Clear"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element.tap()
        
        let addButton = app.buttons["Add"]
        addButton.tap()
        sleep(1)
        app.alerts["Erreur"].buttons["Ok"].tap()
        app.typeText("eggs")
        addButton.tap()
        app.typeText("cheese")
        addButton.tap()
        element.children(matching: .table).element.tap()
        app.tabBars.buttons["Favorites"].tap()
        sleep(2)
        app.tabBars.buttons["Search"].tap()
        app.buttons["Search for recipe"].tap()
        sleep(2)
 
        let tablesQuery = app.tables
        tablesQuery.staticTexts["English muffins, cooked bacon, shredded cheddar cheese, large eggs, kosher salt"].tap()
        
        let recipeDetailNavigationBar = app.navigationBars["Recipe detail"]
        let ratingElement = recipeDetailNavigationBar.otherElements["Rating"]
        ratingElement.tap()
        sleep(1)
        recipeDetailNavigationBar.buttons["Result"].tap()
        tablesQuery.staticTexts["Broccoli and Cheese Mini Egg Omelets"].tap()
        ratingElement.tap()
        sleep(1)
        app.tabBars.buttons["Favorites"].tap()
        sleep(1)
        
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["English muffins, cooked bacon, shredded cheddar cheese, large eggs, kosher salt"].tap()
        app.navigationBars["Recipe detail"].otherElements["Rating"].tap()
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Broccoli and Cheese Mini Egg Omelets"].tap()
        tablesQuery.staticTexts[" - 1/4 cup reduced fat shredded cheddar (Sargento)"].swipeUp()
        tablesQuery.buttons["Show website"].tap()
        
    }
    
}
