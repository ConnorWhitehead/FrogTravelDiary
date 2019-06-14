import Foundation
class DayFunctions {
    static func createDay(at tripIndex: Int, using dayModel: DayModel) {
        FakeData.tripModels[tripIndex].dayModels.append(dayModel)
    }
}
