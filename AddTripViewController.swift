import Photos
import UIKit
class AddTripViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tripTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var doneSaving: (() -> ())?
    var tripIndexToEdit: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        imageView.layer.cornerRadius = 10
        if let index = tripIndexToEdit {
            let trip = FakeData.tripModels[index]
            tripTextField.text = trip.title
            imageView.image = trip.image
            titleLabel.text = NSLocalizedString("Edit Trip", comment: "")
        }
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func save(_ sender: Any) {
        guard tripTextField.hasValue, let newTripName = tripTextField.text else { return }
        if let index = tripIndexToEdit {
            TripFunctions.updateTrip(at: index, title: newTripName, image: imageView.image)
        } else {
            TripFunctions.createTrip(tripModel: TripModel(title: newTripName, image: imageView.image))
        }
        if let doneSaving = doneSaving {
            doneSaving()
        }
        dismiss(animated: true)
    }
    fileprivate func presentPhotoPickerController() {
        let myPickerController = UIImagePickerController()
        myPickerController.allowsEditing = true
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        self.present(myPickerController, animated: true)
    }
    @IBAction func addPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    self.presentPhotoPickerController()
                case .notDetermined:
                    if status == PHAuthorizationStatus.authorized {
                        self.presentPhotoPickerController()
                    }
                case .restricted:
                    let alert = UIAlertController(title: "Photo Library Restricted", message: "Photo Library access is restricted and cannot be accessed.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                case .denied:
                    let alert = UIAlertController(title: NSLocalizedString("Photo Library Denied", comment: ""), message: NSLocalizedString("Photo Library was previously denied. Please update your settings if you wish to change this.", comment: ""), preferredStyle: .alert)
                    let goToSettingsAction = UIAlertAction(title: NSLocalizedString("Go to Settings", comment: ""), style: .default) { (action) in
                        DispatchQueue.main.async {
                            let url = URL(string: UIApplication.openSettingsURLString)!
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
                    alert.addAction(cancelAction)
                    alert.addAction(goToSettingsAction)
                    self.present(alert, animated: true)
                @unknown default:
                    print("It looks like Apple added new enum values to PHAuthorizationStatus")
                }
            }
        }
    }
}
extension AddTripViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.imageView.image = image
        } else if let image = info[.originalImage] as? UIImage {
            self.imageView.image = image
        }
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
