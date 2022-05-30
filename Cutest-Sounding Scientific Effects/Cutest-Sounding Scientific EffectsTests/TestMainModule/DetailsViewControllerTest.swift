import XCTest
@testable import Cutest_Sounding_Scientific_Effects

class DetailsMocView: DetailsComicViewControllerProtocol {
    func downloaded(comic: XkcdManagerModel) {

    }
}

class DetailsViewControllerTest: XCTestCase {

    var view: DetailsMocView!
    var router: RouterProtocol!
    var comic: XkcdManagerModel!
    var presenter: DetailsComicViewPresenter!
    var navController: UINavigationController!
    var assembly: AsselderBuilderProtocol!

    override func setUp() {
        view = DetailsMocView()
        navController = UINavigationController()
        assembly = AsselderModuleBuilder()
        router = Router(navigationController: navController, assemblyBuilder: assembly)
        comic = XkcdManagerModel(month: "10",
                                 num: 1,
                                 link: "",
                                 year: "1995",
                                 news: "Hello you",
                                 safe_title: "Title",
                                 transcript: "Bla bla",
                                 alt: "",
                                 img: "",
                                 title: "title",
                                 day: "11")
        presenter = DetailsComicViewPresenter(view: view, router: router, id: 0)
    }

    override func tearDown() {
        view = nil
        comic = nil
        presenter = nil
        navController = nil
        assembly = nil
        router = nil
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testModuleIsNotNil() {
        XCTAssertNotNil(view, "View is not nil")
        XCTAssertNotNil(presenter, "Presenter is not nil")
        XCTAssertNotNil(comic, "Comic is not nil")
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
