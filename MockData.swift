import Foundation
class MockData {
    static func createMockTripModelData() -> [TripModel] {
        var mockTrips = [TripModel]()
        mockTrips.append(TripModel(title: NSLocalizedString("Trip to UK!", comment: ""), image: #imageLiteral(resourceName: "bali"), dayModels: createmockDayModelData()))
        mockTrips.append(TripModel(title: NSLocalizedString("India", comment: ""), image: #imageLiteral(resourceName: "mexico")))
        mockTrips.append(TripModel(title:  NSLocalizedString("Japan Trip", comment: "")))
        return mockTrips
    }
    static func createmockDayModelData() -> [DayModel] {
        var dayModels = [DayModel]()
        dayModels.append(DayModel(title: Date(), subtitle: NSLocalizedString("Departure", comment: ""), data: createMockActivityModelData(sectionTitle: "April 18")))
        dayModels.append(DayModel(title: Date().add(days: 1), subtitle: "Exploring", data: createMockActivityModelData(sectionTitle: "April 19")))
        dayModels.append(DayModel(title: Date().add(days: 2), subtitle: "Scuba Diving!", data: createMockActivityModelData(sectionTitle: "April 20")))
        dayModels.append(DayModel(title: Date().add(days: 3), subtitle: "Volunteering", data: createMockActivityModelData(sectionTitle: "April 21")))
        dayModels.append(DayModel(title: Date().add(days: 4), subtitle: "Time to go back home", data: createMockActivityModelData(sectionTitle: "April 22")))
        return dayModels
    }
    static func createMockActivityModelData(sectionTitle: String) -> [ActivityModel] {
        var models = [ActivityModel]()
        switch sectionTitle {
        case "April 18":
            models.append(ActivityModel(title: "SLC", subtitle: "12:25 - 13:45", activityType: ActivityType.flight, photo: #imageLiteral(resourceName: "slc airport")))
            models.append(ActivityModel(title: "LAX", subtitle: "17:00 - 11:00", activityType: ActivityType.flight))
        case "April 19":
            models.append(ActivityModel(title: "DPS", subtitle: "", activityType: ActivityType.flight))
            models.append(ActivityModel(title: "Bintang Kuta Hotel Checkin", subtitle: "Confirmation: AX76Y2", activityType: ActivityType.hotel))
            models.append(ActivityModel(title: "Pick up rental", subtitle: "Confirmation: 996464", activityType: ActivityType.auto))
            models.append(ActivityModel(title: "Island Excusion", subtitle: "Touring the island", activityType: ActivityType.excursion))
            models.append(ActivityModel(title: "Dinner", subtitle: "at Warung Sanur Segar", activityType: ActivityType.food))
        case "April 20":
            models.append(ActivityModel(title: "Scuba Diving", subtitle: "Checking out the Reefs!", activityType: ActivityType.excursion))
            models.append(ActivityModel(title: "Dinner", subtitle: "at Malaika Secret Moksha", activityType: ActivityType.food))
        case "April 21":
            models.append(ActivityModel(title: "Travel", subtitle: "to Nusa Penida", activityType: ActivityType.flight))
            models.append(ActivityModel(title: "Volunteering", subtitle: "at Tanglad Village", activityType: ActivityType.excursion))
            models.append(ActivityModel(title: "Dinner", subtitle: "at Warung Made", activityType: ActivityType.food))
            models.append(ActivityModel(title: "Travel", subtitle: "back to Denpasar", activityType: ActivityType.flight))
        case "April 22":
            models.append(ActivityModel(title: "Hotel Checkout", subtitle: "from Bintang Kuta Hotel", activityType: ActivityType.hotel))
            models.append(ActivityModel(title: "DPS", subtitle: "Denpasar", activityType: ActivityType.flight))
            models.append(ActivityModel(title: "LAX", subtitle: "Los Angeles", activityType: ActivityType.flight))
            models.append(ActivityModel(title: "SLC", subtitle: "Salt Lake City", activityType: ActivityType.flight))
        default:
            models.append(ActivityModel(title: "", subtitle: "", activityType: ActivityType.excursion))
        }
        return models
    }
}
