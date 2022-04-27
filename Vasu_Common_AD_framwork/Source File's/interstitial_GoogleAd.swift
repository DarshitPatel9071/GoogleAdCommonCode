//
//  interstitial_GoogleAd.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import GoogleMobileAds

public class InterstitialAd_Common : NSObject
{
    static public var shared : InterstitialAd_Common = InterstitialAd_Common()
    public var interstitialAdDismiss : (() -> Void)?

    private var interstitialAd : GADInterstitialAd!
    private var isNeedToShowinterstitialAd = true
}

// load Interstitial Ad's
extension InterstitialAd_Common
{
    func loadInterstitialAD()
    {
        if !GoogleAd_IDs.shared.isRemoveAd &&
            interstitialAd == nil &&
            GoogleAd_IDs.shared.checkNetStatus() &&
            isNeedToShowinterstitialAd
        {
            GADInterstitialAd.load(withAdUnitID: GoogleAd_IDs.allID.interstitialID, request: GADRequest()) { [self] (ad, error) in
                
                if let _ = error
                {
                    print("Log :- InterstitialAd_Common :- interstitial is not load :- \(error!.localizedDescription)")
                    interstitialAd = nil
                    loadInterstitialAD()
                    return
                }
                
                print("Log :- InterstitialAd_Common :- ad load success")
                
                interstitialAd = ad!
                interstitialAd.fullScreenContentDelegate = self
            }
        }
    }
    
    func presentInterstitialAD()
    {
        if interstitialAd != nil && !GoogleAd_IDs.shared.isRemoveAd
        {
            interstitialAd.present(fromRootViewController: UIApplication.getTopMostVC()!)
        }
        else
        {
            adSuccessOrFail()
        }
    }
    
    private func adSuccessOrFail()
    {
        interstitialAdDismiss?()
        interstitialAd = nil
        loadInterstitialAD()
    }
}

extension InterstitialAd_Common : GADFullScreenContentDelegate
{
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd)
    {
        print("Log :- InterstitialAd_Common :- interstitialDidDismissScreen")
        adSuccessOrFail()
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)
    {
        print("Log :- InterstitialAd_Common :- didFailToReceiveAdWithError :- ERROR :- \(error.localizedDescription)")
        adSuccessOrFail()
    }
}
