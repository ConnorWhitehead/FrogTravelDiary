import UIKit
struct TripModel {
    let id: UUID
    var title: String
    var image: UIImage?
    var dayModels = [DayModel]() {
        didSet {
            dayModels = dayModels.sorted(by: <)
        }
    }
    init(title: String, image: UIImage? = nil, dayModels: [DayModel]? = nil) {
        id = UUID()
        self.title = title
        self.image = image
        if let dayModels = dayModels {
            self.dayModels = dayModels
        }
    }
}
