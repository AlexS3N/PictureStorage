
import UIKit

class Image: Codable {
    
    var name: String
    var caption: String
    var like: Bool
    
    init(name: String, caption: String, like: Bool) {
        self.name = name
        self.caption = caption
        self.like = like
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case caption
        case like
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(caption, forKey: .caption)
        try container.encode(like, forKey: .like)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.like = try container.decode(Bool.self, forKey: .like)
    }
}
