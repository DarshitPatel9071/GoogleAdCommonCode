//
//  interstitial_GoogleAd.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import GoogleMobileAds

public class OpenAd_Common : NSObject
{
    static public var shared : OpenAd_Common = OpenAd_Common()
    private var openAppAd :  GADAppOpenAd!
    private var isAppMoveToBackground = false
    private var isNeedToShowOpenAd = true
}

// load Open Ad's
extension OpenAd_Common
{
    private func loadOpenAD()
    {
        if !GoogleAd_IDs.shared.isRemoveAd &&
            openAppAd == nil &&
            GoogleAd_IDs.shared.checkNetStatus() &&
            isNeedToShowOpenAd
        {
            GADAppOpenAd.load(withAdUnitID: GoogleAd_IDs.allID.openAppID, request: GADRequest(), orientation: .portrait) { [self] (ad, err) in
                if let ads = ad
                {
                    print("Log :- OpenAd_Common :- ad load success")
                    openAppAd = ads
                }
                else
                {
                    print("Log :- OpenAd_Common :- open_ad_load_error :- \(err!.localizedDescription)")
                    openAppAd = nil
                    loadOpenAD()
                }
            }
        }
    }
    
    private func presentOpenAD()
    {
        if openAppAd != nil && !GoogleAd_IDs.shared.isRemoveAd
        {
            openAppAd.fullScreenContentDelegate = self
            
            if let topVC = UIApplication.getTopMostVC()
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                {
                    [self] in
                    if !checkTopVCForOpenAd(topVC)
                    {
                        topVC.modalPresentationStyle = .overFullScreen
                        openAppAd.present(fromRootViewController: topVC)
                        print("Log :- OpenAd_Common :- open ad present success")
                    }
                }
            }
        }
        else
        {
            openAppAd = nil
            loadOpenAD()
        }
    }
    
    private func checkTopVCForOpenAd(_ topVC : UIViewController) -> Bool
    {
        if topVC is UIAlertController
        {
            return true
        }
        else
        {
            return false
        }
    }
}

// notification for check app in background or in foreground
extension OpenAd_Common
{
    func addNotificationObserver()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMoveToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        loadOpenAD()
    }
    
    @objc private func appMoveToBackground()
    {
        isAppMoveToBackground = true
    }
    
    @objc private func appDidBecomeActive()
    {
        if isAppMoveToBackground
        {
            isAppMoveToBackground = false
            presentOpenAD()
        }
    }
}

extension OpenAd_Common : GADFullScreenContentDelegate
{
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd)
    {
        print("Log :- OpenAd_Common :- open add dismiss")
        openAppAd = nil
        loadOpenAD()
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)
    {
        print("Log :- OpenAd_Common :- didFailToReceiveAdWithError :- ERROR :- \(error.localizedDescription)")
        openAppAd = nil
        loadOpenAD()
    }
}
