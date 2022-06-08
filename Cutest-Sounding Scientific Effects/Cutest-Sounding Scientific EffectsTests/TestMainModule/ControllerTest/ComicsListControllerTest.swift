import XCTest
@testable import Cutest_Sounding_Scientific_Effects

class MocComicPresenter: ComicsListPresenterProtocol {
    func didSelectedItem(at indexPath: IndexPath) {

    }

    func filteredCellsModelsCount() -> Int {
        0
    }

    func getViewModel(for indexPath: IndexPath) -> NetworkComicModel? {
       nil
    }

    func searchBarTextDidChange(searchText: String) {

    }

    func searchBarCancelButtonClicked() {

    }

    func requestData(searchText: String?) {

    }

    func searchTextWithTimer(searchText: String) {

    }

    func viewDidLoad() {

    }
}

class ComicsListControllerTest: XCTestCase {

    var view: ComicsViewControllerProtocol!
    var comics: [NetworkComicModel]!
    var presenter: MocComicPresenter!
    var router: MocRouter!


    override func setUp() {
        view = ComicsViewController()
        comics = [NetworkComicModel]()
        router = MocRouter()
        presenter = MocComicPresenter()
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
