import XCTest
@testable import BilibiliAPI

final class BilibiliAPITests: XCTestCase {
    func testAPI() {
        let apiProvider = APIProvider()
        try! apiProvider.addClientInfo(for: .browser, ClientInfo.forBrowser(userAgent: "Some UserAgent", keys: nil))
        try! apiProvider.addClientInfo(for: .iphone7260, ClientInfo(build: 7260, device: nil, mobiApp: nil, platform: nil, userAgent: nil, keys: nil))
        for api in [
            SearchQuery(keyword: "东方", order: .danmaku, duration: .all, regionID: VideoRegion.all.rawValue, pageNumber: 1),
//            API.getTagTabInfo(tid: nil, tagName: "东方"),
            TagDetailQuery(tid: 166, pageNumber: 3),
            TagTopQuery(tid: 166, pageNumber: 3),
//            API.getVideoInfo(aid: 640001),
            VideoRelatedVideosQuery(aid: 640001),
            VideoTagsQuery(aid: 2557),
            UserSubmissionsQuery(uid: 364812769, pageNumber: 2),
            UserFavoriteFolderListQuery(uid: 3621415),
            FavoriteFolderVideosQuery(uid: 3621415, fid: 1443151, pageNumber: nil),
            ] as [APIQuery] {
            print(try! apiProvider.buildRequest(for: api).url)
        }
    }

    static var allTests = [
       ("testAPI", testAPI),
    ]
}
