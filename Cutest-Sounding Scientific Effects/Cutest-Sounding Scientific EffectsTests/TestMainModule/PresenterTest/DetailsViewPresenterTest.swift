import XCTest
@testable import Cutest_Sounding_Scientific_Effects

class DetailsMocView: DetailsComicViewControllerProtocol {

    var isSetTitleLabel =  false
    var isSetComicsImage =  false

    func setTitleLabel(text: String) {
        isSetTitleLabel = true
    }

    func setComicsImage(with url: URL) {
        isSetComicsImage = true
    }
}

class MocXkcdManagerProtocol: XkcdManagerProtocol {
    var delegate: ComicDelegate?
    var isGetLatest = false
    var isGetComic = false
    var isGetRandom = false
    
    func getLatest() {
        isGetLatest = true
    }

    func getComic(withID id: Int) {
        isGetComic = true
    }

    func getRandom() {
        isGetRandom = true
    }
}

class DetailsViewPresenterTest: XCTestCase {

    var view: DetailsMocView!
    var router: MocRouter!
    var comic: XkcdManagerModel!
    var presenter: DetailsComicViewPresenter!
    var xkcdManager: MocXkcdManagerProtocol!

    override func setUp() {
        view = DetailsMocView()
        router = MocRouter()
        xkcdManager = MocXkcdManagerProtocol()
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
        presenter = DetailsComicViewPresenter(view: view, router: router, id: 0, xkcdManager: xkcdManager)
    }

    override func tearDown() {
        view = nil
        comic = nil
        presenter = nil
        router = nil
        comic = nil
        xkcdManager = nil
    }

//    func viewDidLoad()
//    func prevTapped()
//    func getCurrentComic()
//    func lastTapped()
//    func randomTapped()
//    func forwardTapped()
//    func firstTapped()
//    func tap()

    func testViewDidLoad() {
        presenter.viewDidLoad()
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
        XCTAssertNotNil(router, "Router is not nil")
        XCTAssertNotNil(xkcdManager, "XkcdManager is not nil")
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
