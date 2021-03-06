//
//  MemeCreateViewController.swift
//  MemeMe
//
//  Created by KAAN YILDIRIM on 24.11.2021.
//

import UIKit

final class MemeCreateViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak private var topTextField: UITextField!
    @IBOutlet weak private var bottomTextField: UITextField!
    @IBOutlet weak private var photoImageView: UIImageView!
    @IBOutlet weak private var cameraButton: UIBarButtonItem!
    @IBOutlet weak private var topToolbar: UIToolbar!
    @IBOutlet weak private var bottomToolbar: UIToolbar!
    private var keyboardAlreadyShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    private func prepareTextFields() {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -2.0
        ]
        setupTextField(textField: topTextField, text: "TOP", attributes: memeTextAttributes)
        setupTextField(textField: bottomTextField, text: "BOTTOM", attributes: memeTextAttributes)
    }

    private func setupTextField(textField: UITextField, text: String, attributes: [NSAttributedString.Key: Any]) {
        textField.defaultTextAttributes = attributes
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = self
    }

    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder && keyboardAlreadyShow == false {
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin.y -= self.getKeyboardHeight(notification)
                self.keyboardAlreadyShow = true
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            UIView.animate(withDuration: 0.5) {
                self.view.frame.origin.y = 0
                self.keyboardAlreadyShow = false
            }
        }
    }

    // Calculates keyboard height
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardSize = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
        return keyboardSize.cgRectValue.height
    }

    // Generates meme image
    private func generateMemedImage() -> UIImage {

        prepareBars(isHiddden: true)

        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        prepareBars(isHiddden: false)

        return memedImage
    }

    private func prepareBars(isHiddden: Bool) {
        topToolbar.isHidden = isHiddden
        bottomToolbar.isHidden = isHiddden
    }

    private func save() {
        let meme = Meme(top: topTextField.text, bottom: bottomTextField.text, originalImage: photoImageView.image, memeImage: generateMemedImage())
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memeList.append(meme)
    }

    private func pickImage(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }

    // MARK: Actions
    @IBAction private func pickButtonPressed(_ sender: Any) {
        pickImage(source: .photoLibrary)
    }

    @IBAction private func cameraButtonPressed(_ sender: Any) {
        pickImage(source: .camera)
    }

    @IBAction private func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func shareButtonPressed(_ sender: Any) {
        let shareImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.save()
                return
            }
        }
        present(activityVC, animated: true, completion: nil)
    }

    // MARK: ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
            picker.dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    // MARK: TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

}

