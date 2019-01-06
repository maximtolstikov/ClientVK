//
//  ViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 26/12/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class AuthViewController: UIViewController {
    
    var apid = "6356430"
    let scope: [String] = [VK_PER_GROUPS, VK_PER_PHOTOS, VK_PER_FRIENDS]
    var isAuthorised = false
    var myToken: VKAccessToken? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let sdkInstance = VKSdk.initialize(withAppId: apid)
        
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        
        VKSdk.wakeUpSession(scope) { [unowned self] (state: VKAuthorizationState, error) in
            
            if state == VKAuthorizationState.authorized {
                self.myToken = VKSdk.accessToken()
                self.isAuthorised = true
                print("Authorized")
                
                self.goToTabBarController()
                
            } else {
                print("No authorized")
            }
        }
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        VKSdk.authorize(scope)
    }
    
    func logout() {
       
        guard let manager = RealmManager() else { return }
        
        manager.deleteAll()
        VKSdk.forceLogout()
    }
    
    private func goToTabBarController() {
        
        self.performSegue(withIdentifier: "TabBarController", sender: nil)
    }
    
}

extension AuthViewController: VKSdkDelegate, VKSdkUIDelegate {
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        
        if (result.token != nil) {
            print(VKSdk.accessToken().userId)
        } else {
            print("not token!")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: {
                print("hide current modal controller if presents")
                self.present(controller, animated: true, completion: {
                    print("SFSafariViewController opened to login through a browser")
                })
            })
        } else {
            self.present(controller, animated: true, completion: {
                print("SFSafariViewController opened to login through a browser")
            })
        }
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
        let vkCvC = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vkCvC?.present(in: self.navigationController?.topViewController)
    }
    
}
