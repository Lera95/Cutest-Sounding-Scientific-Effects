import XCTest
@testable import Cutest_Sounding_Scientific_Effects

class MockView: ComicsViewControllerProtocol {
    func clearSearchText() {

    }

    func deselectRow(at indexPath: IndexPath) {
        
    }

    func reload() {

    }
}

class ComicsListPresenterTest: XCTestCase {

    var view: MockView!
    var comics: ComicsModel!
    var presenter: ComicsListPresenter!
    var router: RouterProtocol!
    var navController: UINavigationController!
    var assembly: AsselderBuilderProtocol!


    override func setUp() {
        view = MockView()
        comics = ComicsModel()
        navController = UINavigationController()
        assembly = AsselderModuleBuilder()
        router = Router(navigationController: navController, assemblyBuilder: assembly)
        presenter = ComicsListPresenter(view: view, router: router)
    }

    override func tearDown() {
        view = nil
        comics = nil
        presenter = nil
    }

    func testModuleIsNotNil() {
        XCTAssertNotNil(view, "View is nit nill")
        XCTAssertNotNil(presenter, "Presenter is nit nill")
        XCTAssertNotNil(comics, "Comics is nit nill")
    }

    func testViewCount() {
        XCTAssertNotNil(presenter.filteredCellsModelsCount(), "0")
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
