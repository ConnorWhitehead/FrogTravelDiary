import Foundation
class ActivityFunctions {
    static func createActivity(at tripIndex: Int, for dayIndex: Int, using activityModel: ActivityModel) {
        FakeData.tripModels[tripIndex].dayModels[dayIndex].activityModels.append(activityModel)
    }
    static func deleteActivity(at tripIndex: Int, for dayIndex: Int, using activityModel: ActivityModel) {
        let dayModel = FakeData.tripModels[tripIndex].dayModels[dayIndex]
        if let index = dayModel.activityModels.firstIndex(of: activityModel) {
            FakeData.tripModels[tripIndex].dayModels[dayIndex].activityModels.remove(at: index)
        }
    }
    static func updateActivity(at tripIndex: Int, oldDayIndex: Int, newDayIndex: Int,using activityModel: ActivityModel) {
        if oldDayIndex != newDayIndex {
            let lastIndex = FakeData.tripModels[tripIndex].dayModels[newDayIndex].activityModels.count
            reorderActivity(at: tripIndex, oldDayIndex: oldDayIndex, newDayIndex: newDayIndex, newActivityIndex: lastIndex, activityModel: activityModel)
        } else {
            let dayModel = FakeData.tripModels[tripIndex].dayModels[oldDayIndex]
            let activityIndex = (dayModel.activityModels.firstIndex(of: activityModel))!
            FakeData.tripModels[tripIndex].dayModels[newDayIndex].activityModels[activityIndex] = activityModel
        }
    }
    static func reorderActivity(at tripIndex: Int, oldDayIndex: Int, newDayIndex: Int, newActivityIndex: Int, activityModel: ActivityModel) {
        let dayModel = FakeData.tripModels[tripIndex].dayModels[oldDayIndex]
        let oldActivityIndex = (dayModel.activityModels.firstIndex(of: activityModel))!
        FakeData.tripModels[tripIndex].dayModels[oldDayIndex].activityModels.remove(at: oldActivityIndex)
        FakeData.tripModels[tripIndex].dayModels[newDayIndex].activityModels.insert(activityModel, at: newActivityIndex)
    }
}
