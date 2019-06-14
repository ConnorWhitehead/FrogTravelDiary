import UIKit
class ActivitiesViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: AppUIButton!
    var tripId: UUID!
    var tripTitle = ""
    var tripModel: TripModel?
    var sectionHeaderHeight: CGFloat = 0.0
    fileprivate func updateTableViewWithTripData() {
        TripFunctions.readTrip(by: tripId) { [weak self] (model) in
            guard let self = self else { return }
            self.tripModel = model
            guard let model = model else { return }
            self.backgroundImageView.image = model.image
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tripTitle
        addButton.createFloatingActionButton()
        tableView.dataSource = self
        tableView.delegate = self
        updateTableViewWithTripData()
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)?.contentView.bounds.height ?? 0
    }
    @IBAction func back(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addAction(_ sender: AppUIButton) {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("Which would you liek to add?", comment: ""), preferredStyle: .actionSheet)
        let dayAction = UIAlertAction(title: NSLocalizedString("Day", comment: ""), style: .default, handler: handleAddDay)
        let activityAction = UIAlertAction(title: NSLocalizedString("Activity", comment: ""), style: .default, handler: handleAddActivity)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        activityAction.isEnabled = tripModel!.dayModels.count > 0
        alert.addAction(dayAction)
        alert.addAction(activityAction)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: -4, width: sender.bounds.width, height: sender.bounds.height)
        present(alert, animated: true)
    }
    fileprivate func getTripIndex() -> Int! {
        return FakeData.tripModels.firstIndex(where: { (tripModel) -> Bool in
            tripModel.id == tripId
        })
    }
    func handleAddActivity(action: UIAlertAction) {
        let vc = AddActivityViewController.getInstance() as! AddActivityViewController
        vc.tripModel = tripModel
        vc.tripIndex = getTripIndex()
        vc.doneSaving = { [weak self] dayIndex, activityModel in
            guard let self = self else { return }
            self.tripModel?.dayModels[dayIndex].activityModels.append(activityModel)
            let row = (self.tripModel?.dayModels[dayIndex].activityModels.count)! - 1
            let indexPath = IndexPath(row: row, section: dayIndex)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        present(vc, animated: true)
    }
    func handleAddDay(action: UIAlertAction) {
        let vc = AddDayViewController.getInstance() as! AddDayViewController
        vc.tripModel = tripModel
        vc.tripIndex = getTripIndex()
        vc.doneSaving = { [weak self] dayModel in
            guard let self = self else { return }
            self.tripModel?.dayModels.append(dayModel)
            let indexArray = [self.tripModel?.dayModels.firstIndex(of: dayModel) ?? 0]
            self.tableView.insertSections(IndexSet(indexArray), with: .automatic)
        }
        present(vc, animated: true)
    }
}
extension ActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tripModel?.dayModels.count ?? 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dayModel = tripModel?.dayModels[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as! HeaderTableViewCell
        cell.setup(model: dayModel!)
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripModel?.dayModels[section].activityModels.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = tripModel?.dayModels[indexPath.section].activityModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier) as! ActivityTableViewCell
        cell.setup(model: model!)
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: NSLocalizedString("Edit", comment: "")) {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let vc = AddActivityViewController.getInstance() as! AddActivityViewController
            vc.tripModel = self.tripModel
            vc.tripIndex = self.getTripIndex()
            vc.dayIndexToEdit = indexPath.section
            vc.activityModelToEdit = self.tripModel?.dayModels[indexPath.section].activityModels[indexPath.row]
            vc.doneUpdating = { [weak self] oldDayIndex, newDayIndex, activityModel in
                guard let self = self else { return }
                let oldActivityIndex = (self.tripModel?.dayModels[oldDayIndex].activityModels.firstIndex(of: activityModel))!
                if oldDayIndex == newDayIndex {
                self.tripModel?.dayModels[newDayIndex].activityModels[oldActivityIndex] = activityModel
                    let indexPath = IndexPath(row: oldActivityIndex, section: newDayIndex)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                self.tripModel?.dayModels[oldDayIndex].activityModels.remove(at: oldActivityIndex)
                    let lastIndex = (self.tripModel?.dayModels[newDayIndex].activityModels.count)!
                    self.tripModel?.dayModels[newDayIndex].activityModels.insert(activityModel, at: lastIndex)
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        let insertIndexPath = IndexPath(row: lastIndex, section: newDayIndex)
                        tableView.insertRows(at: [insertIndexPath], with: .automatic)
                    })
                }
            }
            self.present(vc, animated: true)
            actionPerformed(true)
        }
        edit.image = #imageLiteral(resourceName: "edit")
        edit.backgroundColor = UIColor(named: "EditColor")
        return UISwipeActionsConfiguration(actions: [edit])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let activityModel = tripModel!.dayModels[indexPath.section].activityModels[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: NSLocalizedString("Delete Activity", comment: ""), message: "\(NSLocalizedString("Are you sure you want to delete this activity", comment: "")): \(activityModel.title)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (alertAction) in
                ActivityFunctions.deleteActivity(at: self.getTripIndex(), for: indexPath.section, using: activityModel)
                self.tripModel!.dayModels[indexPath.section].activityModels.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                actionPerformed(true)
            }))
            self.present(alert, animated: true)
        }
        delete.image = #imageLiteral(resourceName: "delete")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
