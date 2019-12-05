public enum SearchOrder: String, Codable {
    case `default` = "totalrank"
    case view = "click"
    case pubdate = "pubdate"
    case danmaku = "dm"
    case favorite = "stow"
    
    public var int: Int {
        switch self {
        case .default: return 0 // unofficial
        case .view: return 1
        case .pubdate: return 2
        case .danmaku: return 3
        case .favorite: return 4
        }
    }
    
    public init?(from int: Int) {
        switch int {
        case 0: self = .default
        case 1: self = .view
        case 2: self = .pubdate
        case 3: self = .danmaku
        case 4: self = .favorite
        case -1: return nil
        default: fatalError()
        }
    }
}

public enum UserSubmissionSearchOrder: String, Codable {
    case pubdate = "pubdate" // default
    case view = "click"
    case favorite = "stow"
}

public enum SearchDuration: Int, Codable {
    case all = 0
    case lessThan10m = 1
    case from10mTo30m = 2
    case from30mTo1h = 3
    case moreThan1h = 4
}

public enum VideoRegion: Int, Codable {
    case all = 0
//    case 番剧 = 13
//    case 动画 = 1
//    case 国创 = 167
//    case 音乐 = 3
//    case 舞蹈 = 129
//    case 游戏 = 4
//    case 科技 = 36
//    case 生活 = 160
//    case 鬼畜  = 119
//    case 时尚  = 155
//    case 广告  = 165
//    case 娱乐  = 5
//    case 影视  = 181
//    case 纪录片 = 177
//    case 电影  = 23
//    case 电视剧 = 11
////    case 小视频 = 65542
////    case 专栏  = 65541
////    case 音频  = 65543
}
