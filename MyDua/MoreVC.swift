//
//  MoreVC.swift
//  MyDua
//
//  Created by iB Arts Pvt. Ltd. on 13/12/23.
//

import UIKit

class MoreVC: UIViewController {
    @IBOutlet var imgBack: [UIImageView]!
    @IBOutlet weak var viewSurah: UIView!
    @IBOutlet weak var viewMyFav: UIView!
    @IBOutlet weak var viewRadio: UIView!
    @IBOutlet weak var viewSettings: UIView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var viewSupport: UIView!
    @IBOutlet weak var viewWaqf: UIView!
    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var viewTimerUpdate: UIView!
    @IBOutlet weak var viewQuotes: UIView!
    @IBOutlet weak var viewSahifaSajjadia: UIView!
    @IBOutlet weak var azanView: UIView!
    @IBOutlet weak var aamaalAndNamazView: UIView!
    @IBOutlet weak var shareView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        designView()
        //setupImageColor()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modeCheck()
        var userID = UserDefaults.standard.value(forKey: "UserID") as? String ?? ""
        if userID.isEmpty{
            viewProfile.isHidden = true
            viewLogin.isHidden = false
        }else{
            viewProfile.isHidden = false
            viewLogin.isHidden = true
        }
//
    }
    
    func modeCheck(){
        if  SettingsVC.viewMode == "Dark" {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func tapSupport(_ sender: UIButton) {
        // "https://azadar.media"
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SupportVC") as! SupportVC
        self.navigationController?.pushViewController(vc, animated: true)
        
       /*
        if let url = URL(string: "https://mydua.online/our-supporter/") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Cannot open the URL")
                    // Handle the case where the URL cannot be opened, e.g., show an alert
                }
            }
        */
        
    }
    
    @IBAction func tapSahifaSajjadia(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SafhiaSajjadiaVC") as! SafhiaSajjadiaVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapQuotes(_ sender: UIButton) {
     
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QuotesVC") as! QuotesVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapWaqf(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WaqtVC") as! WaqfVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnFeedback(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FeedbackVC") as! FeedbackVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnTimerUpdate(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimerUpdateVC") as! TimerUpdateVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapSurah(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SurahVC") as! SurahVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapFav(_ sender: Any){
        let token = UserDefaults.standard.integer(forKey: "UserID")
        if token >= 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
            let validation = 1
            
            UserDefaults.standard.setValue(validation, forKey: "validation")
            
            let alert = UIAlertController(title: AppName, message: "Please login", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {_ in
            let signInStoryboard = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(signInStoryboard, animated: true)
            })
            alert.addAction(ok)
            present(alert, animated: true)
            
        }
    }
    
    @IBAction func tapRadio(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OurRadioVC") as! OurRadioVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapSettings(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapLogin(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func tapMyProfile(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileButtonVC") as! MyProfileButtonVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnTapAzan(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AzanVC") as! AzanVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnTapAamaalAndNamaz(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Aamaal_And_NamazVC") as! Aamaal_And_NamazVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func btnTapShare(_ sender: UIButton) {
        
        shareApp()

    }
    
    func shareApp(){
        
        guard let url = URL(string: "https://mydua.page.link/dua") else {
                    return
        }

        let imageToShare = UIImage(named: "MyDuaQR")

        guard let image = imageToShare else {
            return
        }
        
        let app = AppName
        let text = "Check out this link!"

        let items: [Any] = [app, text, url, image]
        

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail
        ]

        present(activityViewController, animated: true, completion: nil)
    }
    
}
extension MoreVC{
    private func designView(){
        viewSurah.layer.cornerRadius = 8.0
        viewSurah.layer.borderWidth = 1.0
        viewMyFav.layer.cornerRadius = 8.0
        viewMyFav.layer.borderWidth = 1.0
        viewRadio.layer.cornerRadius = 8.0
        viewRadio.layer.borderWidth = 1.0
        viewSettings.layer.cornerRadius = 8.0
        viewSettings.layer.borderWidth = 1.0
        viewLogin.layer.cornerRadius = 8.0
        viewLogin.layer.borderWidth = 1.0
        viewProfile.layer.cornerRadius = 8.0
        viewProfile.layer.borderWidth = 1.0
        viewSupport.layer.cornerRadius = 8.0
        viewSupport.layer.borderWidth = 1.0
        viewWaqf.layer.cornerRadius = 8.0
        viewWaqf.layer.borderWidth = 1.0
        viewFeedback.layer.cornerRadius = 8.0
        viewFeedback.layer.borderWidth = 1.0
        viewTimerUpdate.layer.cornerRadius = 8.0
        viewTimerUpdate.layer.borderWidth = 1.0
        viewQuotes.layer.cornerRadius = 8.0
        viewQuotes.layer.borderWidth = 1.0
        viewSahifaSajjadia.layer.cornerRadius = 8.0
        viewSahifaSajjadia.layer.borderWidth = 1.0
        azanView.layer.cornerRadius = 8.0
        azanView.layer.borderWidth = 1.0
        aamaalAndNamazView.layer.cornerRadius = 8.0
        aamaalAndNamazView.layer.borderWidth = 1.0
        shareView.layer.cornerRadius = 8.0
        shareView.layer.borderWidth = 1.0
    }
    private func setupImageColor(){
        imgBack.forEach{
            $0.image = UIImage(named: "right-arrow")
            $0.image?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
}
