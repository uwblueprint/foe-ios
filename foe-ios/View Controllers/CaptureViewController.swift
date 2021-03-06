//
//  CaptureViewController.swift
//  foe-ios
//
//  Created by Dinah Shi on 2018-01-18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import AVFoundation
import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    var sighting: Sighting?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?

    override func viewDidLoad() {
        super.viewDidLoad()

        let singleTapCapture = UITapGestureRecognizer(target: self, action: #selector(onTapTakePhoto(_:)))

        captureButtonImage.isUserInteractionEnabled = true
        captureButtonImage.addGestureRecognizer(singleTapCapture)

        let singleTapLibrary = UITapGestureRecognizer(target: self, action: #selector(openPhotoLibraryButton(_:)))

        photoLibraryButtonImage.isUserInteractionEnabled = true
        photoLibraryButtonImage.addGestureRecognizer(singleTapLibrary)

//        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .default, mediaType: AVMediaTypeVideo, position: .back)
        let captureDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)

            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true

            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait

        } catch {
            print(error)
        }

    }

    override func viewDidLayoutSubviews() {
        videoPreviewLayer?.frame = previewView.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
    }

    override func viewWillAppear(_ animated: Bool) {
        let navController = self.navigationController as! SubmissionNavigationController
        super.viewWillAppear(animated)
        navController.setStatusBartoLight()
        navController.navigationBar.barTintColor = UIColor.black
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor(red:0.12, green:0.75, blue:0.39, alpha:1.0)
        navController.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 14)!, NSForegroundColorAttributeName : UIColor.white ]
        self.navigationItem.title = "Step 1: Capture"
        
        UIApplication.shared.statusBarStyle = .lightContent

        let cancelButton =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(gotoPreviousScreen))
        self.navigationItem.leftBarButtonItem = cancelButton

        sighting = navController.getSighting()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let navController = self.navigationController as! SubmissionNavigationController
        navController.setSighting(sighting: sighting!)
        super.viewWillDisappear(animated)
        navController.setStatusBartoDefault()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Outlets

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var captureButtonImage: UIImageView!
    @IBOutlet weak var photoLibraryButtonImage: UIStackView!

    func onTapTakePhoto(_ sender: Any) {
        // Make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }

        // Get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()

        // Set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto

        // Call capturePhoto method by passing our photo settings and a
        // delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    func openPhotoLibraryButton(_ sender: Any) {
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
          fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        sighting?.setImage(image: selectedImage)
        dismiss(animated: true, completion: nil)
        goToNextScreen()
    }


    // MARK: - Navigation

    func goToNextScreen() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "speciesSelectionViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func gotoPreviousScreen() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropToPreviewLayer(originalImage: UIImage) -> UIImage {
        let outputRect = videoPreviewLayer!.metadataOutputRectOfInterest(for: videoPreviewLayer!.bounds)
        var cgImage = originalImage.cgImage!
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)
        
        cgImage = cgImage.cropping(to: cropRect)!
        let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)
        
        return croppedUIImage
    }

}

extension CaptureViewController : AVCapturePhotoCaptureDelegate {
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {

        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        // Initialise a UIImage with our image data
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        if let image = capturedImage {
            let croppedImage = cropToPreviewLayer(originalImage: image)
            // Save our captured image to photos album
            UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil)

            sighting?.setImage(image: croppedImage)
        }
        goToNextScreen()
    }
}
