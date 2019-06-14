import UIKit
class AddActivityViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet var activityTypeButtons: [UIButton]!
    var doneSaving: ((Int, ActivityModel) -> ())?
    var tripIndex: Int! 
    var tripModel: TripModel! 
    var dayIndexToEdit: Int?
    var activityModelToEdit: ActivityModel!
    var doneUpdating: ((Int, Int, ActivityModel) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        dayPickerView.dataSource = self
        dayPickerView.delegate = self
        if let dayIndex = dayIndexToEdit, let activityModel = activityModelToEdit {
            titleLabel.text = NSLocalizedString("Edit Activity", comment: "")
            dayPickerView.selectRow(dayIndex, inComponent: 0, animated: true)
            activityTypeSelected(activityTypeButtons[activityModel.activityType.rawValue])
            titleTextField.text = activityModel.title
            subtitleTextField.text = activityModel.subtitle
        } else {
            activityTypeSelected(activityTypeButtons[ActivityType.excursion.rawValue])
        }
    }
    @IBAction func activityTypeSelected(_ sender: UIButton) {
        activityTypeButtons.forEach({ $0.tintColor = Theme.accent})
        sender.tintColor = Theme.tintColor
    }
    @IBAction func cancel(_ sender: AppUIButton) {
        dismiss(animated: true)
    }
    @IBAction func save(_ sender: AppUIButton) {
        guard titleTextField.hasValue, let newTitle = titleTextField.text else { return }
        let activityType: ActivityType = getSelectedActivityType()
        let newDayIndex = dayPickerView.selectedRow(inComponent: 0)
        if activityModelToEdit != nil {
            activityModelToEdit.activityType = activityType
            activityModelToEdit.title = newTitle
            activityModelToEdit.subtitle = subtitleTextField.text ?? ""
            ActivityFunctions.updateActivity(at: tripIndex, oldDayIndex: dayIndexToEdit!, newDayIndex: newDayIndex, using: activityModelToEdit)
            if let doneUpdating = doneUpdating, let oldDayIndex = dayIndexToEdit {
                doneUpdating(oldDayIndex, newDayIndex, activityModelToEdit)
            }
        } else {
            let activityModel = ActivityModel(title: newTitle, subtitle: subtitleTextField.text ?? "", activityType: activityType)
            ActivityFunctions.createActivity(at: tripIndex, for: newDayIndex, using: activityModel)
            if let doneSaving = doneSaving {
                doneSaving(newDayIndex, activityModel)
            }
        }
        dismiss(animated: true)
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    func getSelectedActivityType() -> ActivityType {
        for (index, button) in activityTypeButtons.enumerated() {
            if button.tintColor == Theme.tintColor {
                return ActivityType(rawValue: index) ?? .excursion
            }
        }
        return .excursion
    }
}
extension AddActivityViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tripModel.dayModels.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tripModel.dayModels[row].title.mediumDate()
    }
}
