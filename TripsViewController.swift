import UIKit
class TripsViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var helpView: UIVisualEffectView!
    var tripIndexToEdit: Int?
    var seenHelpView = "seenHelpView"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = Theme.backgroundColor
        addButton.createFloatingActionButton()
        let radians = CGFloat(200 * Double.pi/180)
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
            self.logoImageView.alpha = 0
            self.logoImageView.transform = CGAffineTransform(rotationAngle: radians)
                .scaledBy(x: 3, y: 3)
            let yRotation = CATransform3DMakeRotation(radians, 0, radians, 0)
            self.logoImageView.layer.transform = CATransform3DConcat(self.logoImageView.layer.transform, yRotation)
        }) { (success) in
            self.getTripData()
        }
    }
    fileprivate func getTripData() {
        TripFunctions.readTrips (competion: { [unowned self] in
            self.tableView.reloadData()
            if FakeData.tripModels.count > 0 {
                if UserDefaults.standard.bool(forKey: self.seenHelpView) == false {
                    self.view.addSubview(self.helpView)
                    self.helpView.frame = self.view.bounds
                }
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddTripSegue" {
            let popup = segue.destination as! AddTripViewController
            popup.tripIndexToEdit = self.tripIndexToEdit
            popup.doneSaving = { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            tripIndexToEdit = nil
        }
    }
    @IBAction func closeHelpView(_ sender: AppUIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.helpView.alpha = 0
        }) { (success) in
            self.helpView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: self.seenHelpView)
        }
    }
}
extension TripsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FakeData.tripModels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TripsTableViewCell.identifier) as! TripsTableViewCell
        cell.setup(tripModel: FakeData.tripModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tripName = FakeData.tripModels[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: @escaping (Bool) -> Void) in
            let alert = UIAlertController(title: NSLocalizedString("Delete Trip", comment: ""), message: "\(NSLocalizedString("Are you sure you want to delete", comment: "")) \(tripName.title)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (alertAction) in
                TripFunctions.deleteTrip(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                actionPerformed(true)
            }))
            self.present(alert, animated: true)
        }
        delete.image = #imageLiteral(resourceName: "delete")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: NSLocalizedString("Edit", comment: "")) { (contextualAction, view, actionPerformed: (Bool) -> Void) in
            self.tripIndexToEdit = indexPath.row
            self.performSegue(withIdentifier: "toAddTripSegue", sender: nil)
            actionPerformed(true)
        }
        edit.image = #imageLiteral(resourceName: "edit")
        edit.backgroundColor = UIColor(named: "EditColor")
        return UISwipeActionsConfiguration(actions: [edit])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = FakeData.tripModels[indexPath.row]
        let vc = ActivitiesViewController.getInstance() as! ActivitiesViewController
        vc.tripId = trip.id
        vc.tripTitle = trip.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
