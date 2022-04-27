//
//  interstitial_GoogleAd.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import GoogleMobileAds

public class RewardAd_Common : NSObject
{
    static public var shared : RewardAd_Common = RewardAd_Common()
    public var rewardedAdDismiss : ((Bool) -> Void)?

    private var rewardedAd: GADRewardedAd!
    private var isEarnedReward = false
    private var isNeedToShowrewardedAd = true
}

// load Interstitial Ad's
extension RewardAd_Common
{
    func loadRewardAD()
    {
        if !GoogleAd_IDs.shared.isRemoveAd &&
            rewardedAd == nil &&
            GoogleAd_IDs.shared.checkNetStatus() &&
            isNeedToShowrewardedAd
        {
            GADRewardedAd.load(withAdUnitID: GoogleAd_IDs.allID.rewardedID, request: GADRequest()) {[self] (rewAD, error) in
                
                if let _ = error
                {
                    print("Log :- RewardAd_Common :- reward is not load :- \(error!.localizedDescription)")
                    rewardedAd = nil
                    loadRewardAD()
                    return
                }
                
                rewardedAd = rewAD!
                rewardedAd.fullScreenContentDelegate = self
                print("Log :- RewardAd_Common :- reward ad load success")
            }
        }
    }
    
    func presentRewardAD()
    {
        isEarnedReward = false
         
        if rewardedAd != nil && !GoogleAd_IDs.shared.isRemoveAd
        {
            rewardedAd.present(fromRootViewController: UIApplication.getTopMostVC()!) {
                
                // user earn reward
                self.isEarnedReward = true
            }
        }
        else
        {
            adSuccessOrFail()
        }
    }
    
    private func adSuccessOrFail()
    {
        rewardedAd = nil
        loadRewardAD()
        rewardedAdDismiss?(GoogleAd_IDs.shared.isRemoveAd ? true : isEarnedReward)
    }
}

extension RewardAd_Common : GADFullScreenContentDelegate
{
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd)
    {
        print("Log :- RewardAd_Common :- reward ad dismiss")
        adSuccessOrFail()
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error)
    {
        print("Log :- RewardAd_Common :- didFailToReceiveAdWithError :- ERROR :- \(error.localizedDescription)")
        adSuccessOrFail()
    }
}
