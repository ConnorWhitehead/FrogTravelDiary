import UIKit
class TripFunctions {
    static func createTrip(tripModel: TripModel) {
        FakeData.tripModels.append(tripModel)
    }
    static func readTrips(competion: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if FakeData.tripModels.count == 0 {
                FakeData.tripModels = MockData.createMockTripModelData()
            }
            DispatchQueue.main.async {
                competion()
            }
        }
    }
    static func readTrip(by id: UUID, completion: @escaping (TripModel?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let trip = FakeData.tripModels.first(where: {$0.id == id})
            DispatchQueue.main.async {
                completion(trip)
            }
        }
    }
    static func updateTrip(at index: Int, title: String, image: UIImage? = nil) {
        FakeData.tripModels[index].title = title
        FakeData.tripModels[index].image = image
    }
    static func deleteTrip(index: Int) {
        FakeData.tripModels.remove(at: index)
    }
}
