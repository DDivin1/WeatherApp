//
// WeatherAppTest.swift
//  UnitTests
//
//  Created by Dmitry Divin on 7.03.26.
//

@testable import WeatherApp
import XCTest

// MARK: - WeatherAppTest
final class CityPresenterTest: XCTestCase {
    
    // MARK: - Constants
    private enum TestConstants {
        static let moscowName = "Moscow"
        static let moscowCountry = "RU"
        static let moscowLongitude: Double = 37.62
        static let moscowLatitude: Double = 55.75
        
        static let londonName = "London"
        static let londonCountry = "GB"
        static let londonLongitude: Double = -0.13
        static let londonLatitude: Double = 51.51
        
        static let searchQuery = "Moscow"
        static let expectationTimeout: TimeInterval = 1
        static let asyncDelay: TimeInterval = 0.1
    }
    
    // MARK: - Properties
    var sut: CityPresenter!
    
    private var networkServiceStub: NetworkServiceStub!
    private var citiesStorageMock: CitiesStorageMock!
    private var mainPresenterMock: MainPresenterMock!
    private var viewMock: CityViewMock!
    
    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        networkServiceStub = NetworkServiceStub()
        citiesStorageMock = CitiesStorageMock()
        mainPresenterMock = MainPresenterMock()
        viewMock = CityViewMock()
        
        sut = CityPresenter(
            networkService: networkServiceStub,
            citiesStorage: citiesStorageMock,
            mainPresenter: mainPresenterMock
        )
        
        sut.view = viewMock
    }
    
    override func tearDown() {
        super.tearDown()
        networkServiceStub = nil
        citiesStorageMock = nil
        mainPresenterMock = nil
        viewMock = nil
        sut = nil
    }

    // MARK: - Tests
    func test_loadSavedCities() {
        // Given
        let expectedCities = [
            CityInfo(
                name: TestConstants.moscowName,
                country: TestConstants.moscowCountry,
                longitude: TestConstants.moscowLongitude,
                latitude: TestConstants.moscowLatitude
            ),
            CityInfo(
                name: TestConstants.londonName,
                country: TestConstants.londonCountry,
                longitude: TestConstants.londonLongitude,
                latitude: TestConstants.londonLatitude
            )
        ]
        citiesStorageMock.setSavedCities(expectedCities)
        
        // When
        sut.loadSavedCities()
        
        // Then
        XCTAssertTrue(citiesStorageMock.getSavedCityCalled)
        XCTAssertTrue(viewMock.displaySavedCitiesCalled)
        XCTAssertEqual(viewMock.lastDisplayedSavedCities?.count, 2)
        XCTAssertEqual(viewMock.lastDisplayedSavedCities?.first?.name, TestConstants.moscowName)
        XCTAssertEqual(viewMock.lastDisplayedSavedCities?.first?.country, TestConstants.moscowCountry)
    }
    
    func test_ViewDidLoad() {
        // Given
        let expectedCity = [
            CityInfo(
                name: TestConstants.moscowName,
                country: TestConstants.moscowCountry,
                longitude: TestConstants.moscowLongitude,
                latitude: TestConstants.moscowLatitude
            )
        ]
        citiesStorageMock.setSavedCities(expectedCity)
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewMock.displaySavedCitiesCalled)
        XCTAssertEqual(viewMock.lastDisplayedSavedCities?.first?.name, TestConstants.moscowName)
        XCTAssertEqual(viewMock.lastDisplayedSavedCities?.first?.country, TestConstants.moscowCountry)
    }
    
    func test_searchCity() {
        // Given
        let query = TestConstants.searchQuery
        let expectedCity = [
            CityInfo(
                name: TestConstants.moscowName,
                country: TestConstants.moscowCountry,
                longitude: TestConstants.moscowLongitude,
                latitude: TestConstants.moscowLatitude
            )
        ]
        networkServiceStub.setSearchCitiesResult(expectedCity)
        let expectation = self.expectation(description: "Search cities completion")
        
        // When
        sut.searchCity(query: query)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + TestConstants.asyncDelay) {
            XCTAssertTrue(self.networkServiceStub.searchCitiesCalled)
            XCTAssertEqual(self.networkServiceStub.lastSearchedQuery, query)
            XCTAssertTrue(self.viewMock.displaySearchResultsCalled)
            XCTAssertEqual(self.viewMock.lastDisplayedSearchResults?.count, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: TestConstants.expectationTimeout)
    }
    
    func test_didSelectCity() {
        // Given
        let city = CityInfo(
            name: TestConstants.moscowName,
            country: TestConstants.moscowCountry,
            longitude: TestConstants.moscowLongitude,
            latitude: TestConstants.moscowLatitude
        )
        
        // When
        sut.didSelectCity(city)
        
        // Then
        XCTAssertTrue(citiesStorageMock.saveCitiesCalled)
        XCTAssertEqual(citiesStorageMock.lastSavedCurrentCity?.name, TestConstants.moscowName)
        XCTAssertTrue(citiesStorageMock.saveCitiesCalled)
        XCTAssertEqual(citiesStorageMock.lastSavedCity?.name, TestConstants.moscowName)
        XCTAssertTrue(mainPresenterMock.didSelectCityCalled)
        XCTAssertEqual(mainPresenterMock.lastSelectedCity?.name, TestConstants.moscowName)
    }
    
    func test_deleteCity() {
        // Given
        let cityToDelete = CityInfo(
            name: TestConstants.moscowName,
            country: TestConstants.moscowCountry,
            longitude: TestConstants.moscowLongitude,
            latitude: TestConstants.moscowLatitude
        )
        let remainCity = CityInfo(
            name: TestConstants.londonName,
            country: TestConstants.londonCountry,
            longitude: TestConstants.londonLongitude,
            latitude: TestConstants.londonLatitude
        )
        
        citiesStorageMock.setSavedCities([cityToDelete, remainCity])
        
        // When
        sut.deleteCity(cityToDelete)
        
        // Then
        XCTAssertTrue(citiesStorageMock.removeCityCalled)
        XCTAssertEqual(citiesStorageMock.lastRemovedCity?.name, TestConstants.moscowName)
        XCTAssertTrue(citiesStorageMock.getSavedCityCalled)
        XCTAssertTrue(viewMock.displaySavedCitiesCalled)
    }
}
