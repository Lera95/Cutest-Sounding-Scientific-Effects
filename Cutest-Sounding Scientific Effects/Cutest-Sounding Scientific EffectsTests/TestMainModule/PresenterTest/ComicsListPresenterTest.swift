import XCTest
@testable import Cutest_Sounding_Scientific_Effects

class MockView: ComicsViewControllerProtocol {

    var isShowEmptyMessageLabel = false
    var isClearSearchText = false
    var isDeselectRow = false
    var isReload = false


    func showEmptyMessageLabel() {
        isShowEmptyMessageLabel = true
    }

    func removeEmptyMessageLabel() {
        isShowEmptyMessageLabel = false
    }

    func clearSearchText() {
        isClearSearchText = true
    }

    func deselectRow(at indexPath: IndexPath) {
        isDeselectRow = true
    }

    func reload() {
        isReload = true
    }
}

class MocRouter: RouterProtocol {

    var isPopToRout = false
    var isSetInitialViewController = false
    var isShowDetailsViewController = false
    var navigationController: UINavigationController?
    var assemblyBuilder: AsselderBuilderProtocol?

    func setInitialViewController() {
        isSetInitialViewController = true
    }

    func popToRoot() {
        isPopToRout = true
    }

    func showDetailsViewController(at indexPath: IndexPath) {
        isShowDetailsViewController = true
    }
}

class MocNetwork: NetworkManagerProtocol {

    var model: [NetworkComicModel]!

    init() {}

    required init(model: [NetworkComicModel]) {
        self.model = model
    }

    func getComics(text: String, completion: @escaping (Result<[NetworkComicModel], XCError>) -> Void) {
        if text.isEmpty {
            completion(.success(model))
        } else {
            completion(.success([]))
        }
    }

    func getImageData(_ url: String) -> Data {
        Data()
    }
}

class ComicsListPresenterTest: XCTestCase {

    var view: MockView!
    var comics: [NetworkComicModel]!
    var presenter: ComicsListPresenter!
    var router: MocRouter!
    var network: MocNetwork!


    override func setUp() {
        view = MockView()
        comics = [NetworkComicModel]()
        router = MocRouter()
        network = MocNetwork(model: [NetworkComicModel(id: 0,
                                                       publishedAt: "",
                                                       news: "",
                                                       safeTitle: "",
                                                       title: "",
                                                       transcript: "",
                                                       alt: "",
                                                       sourceURL: "",
                                                       explainURL: "",
                                                       interactiveURL: "")])
        presenter = ComicsListPresenter(view: view, router: router, networkManager: network)
    }

    override func tearDown() {
        view = nil
        comics = nil
        presenter = nil
        network = nil
        router = nil
    }

    func testModuleIsNotNil() {
        XCTAssertNotNil(view, "View is nit nill")
        XCTAssertNotNil(presenter, "Presenter is nit nill")
        XCTAssertNotNil(comics, "Comics is nit nill")
        XCTAssertNotNil(network, "Network is nit nill")
        XCTAssertNotNil(router, "Router is nit nill")
    }

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(presenter.filteredCellsModelsCount() > 0)
        XCTAssertTrue(!view.isShowEmptyMessageLabel)
    }

    func testRequestData() {
        presenter.requestData(searchText: "A")
        XCTAssertTrue(presenter.filteredCellsModelsCount() == 0)
        XCTAssertTrue(view.isShowEmptyMessageLabel)
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
