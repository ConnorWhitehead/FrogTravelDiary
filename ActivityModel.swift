import Foundation
import UIKit
struct ActivityModel {
    var id: String!
    var title = ""
    var subtitle = ""
    var activityType: ActivityType
    var photo: UIImage?
    init(title: String, subtitle: String, activityType: ActivityType, photo: UIImage? = nil) {
        id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.activityType = activityType
        self.photo = photo
    }
}
extension ActivityModel: Equatable {
    static func == (lhs: ActivityModel, rhs: ActivityModel) -> Bool {
        return lhs.id == rhs.id
    }
}
