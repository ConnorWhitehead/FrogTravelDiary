import UIKit
class AddDayViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var subTitleTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    var doneSaving: ((DayModel) -> ())?
    var tripIndex: Int!
    var tripModel: TripModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowOffset = CGSize.zero
        titleLabel.layer.shadowRadius = 5
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func save(_ sender: Any) {
        if alreadyExists(datePicker.date) {
            let alert = UIAlertController(title: NSLocalizedString("Day Already Exists!", comment: ""), message: NSLocalizedString("Choose another date", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        let dayModel = DayModel(title: datePicker.date, subtitle: subTitleTextField.text ?? "", data: nil)
        DayFunctions.createDay(at: tripIndex, using: dayModel)
        if let doneSaving = doneSaving {
            doneSaving(dayModel)
        }
        dismiss(animated: true)
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    func alreadyExists(_ date: Date) -> Bool {
        if tripModel.dayModels.contains(where: { $0.title.mediumDate() == date.mediumDate()}) {
            return true
        }
        return false
    }
}
