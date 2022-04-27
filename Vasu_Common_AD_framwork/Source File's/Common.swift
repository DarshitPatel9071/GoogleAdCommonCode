//
//  CommonClass.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import Reachability
import UIKit 

public class GoogleAd_IDs : NSObject
{
    static public var shared : GoogleAd_IDs = GoogleAd_IDs()
    
    var isRemoveAd : Bool = false
    
    // all goggle ad's id
    struct allID
    {
        static var openAppID = "ca-app-pub-3940256099942544/5662855259"
        
        static var bannerID = "ca-app-pub-3940256099942544/2934735716"
        
        static var interstitialID = "ca-app-pub-3940256099942544/4411468910"
//        static var interstitial_VideoID = "ca-app-pub-3940256099942544/5135589807"
        
        static var rewardedID = "ca-app-pub-3940256099942544/1712485313"
//        static var rewarded_InterstitialID = "ca-app-pub-3940256099942544/6978759866"
        
        static var native_AdvancedID = "ca-app-pub-3940256099942544/3986624511"
//        static var native_Advance_VideoID = "ca-app-pub-3940256099942544/2521693316"
    }
    
    private var reachability : Reachability = try! Reachability()
}

extension GoogleAd_IDs
{
    /*public func initAdID(openApp:String?,
                         banner:String?,
                         interstitial:String?,
                         interstitial_Video:String?,
                         rewardedID:String?,
                         rewarded_Interstitial:String?,
                         native_Advanced:String?,
                         native_Advance_Video:String?)
    {
        allID.openAppID = openApp ?? "ca-app-pub-3940256099942544/5662855259"
        
        allID.bannerID = banner ?? "ca-app-pub-3940256099942544/2934735716"
        
        allID.interstitialID = interstitial ?? "ca-app-pub-3940256099942544/4411468910"
        //        allID.interstitial_VideoID = interstitial_Video ?? "ca-app-pub-3940256099942544/5135589807"
        
        allID.rewardedID = rewardedID ?? "ca-app-pub-3940256099942544/1712485313"
        //        allID.rewarded_InterstitialID = rewarded_Interstitial ?? "ca-app-pub-3940256099942544/6978759866"
        
        allID.native_AdvancedID = native_Advanced ?? "ca-app-pub-3940256099942544/3986624511"
//        allID.native_Advance_VideoID = native_Advance_Video ?? "ca-app-pub-3940256099942544/2521693316"
    }*/
    
    public func initAdID(openApp:String?,
                         banner:String?,
                         interstitial:String?,
                         rewardedID:String?,
                         native_Advanced:String?)
    {
        allID.openAppID = openApp ?? "ca-app-pub-3940256099942544/5662855259"
        allID.bannerID = banner ?? "ca-app-pub-3940256099942544/2934735716"
        allID.interstitialID = interstitial ?? "ca-app-pub-3940256099942544/4411468910"
        allID.rewardedID = rewardedID ?? "ca-app-pub-3940256099942544/1712485313"
        allID.native_AdvancedID = native_Advanced ?? "ca-app-pub-3940256099942544/3986624511"
    }
}

extension GoogleAd_IDs
{
    public func initialLoadAllAds()
    {
        do
        {
            NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChanged), name: Notification.Name("reachabilityChanged"), object: nil)
            try reachability.startNotifier()
        }
        catch
        {
            print("Log :- Unable to start notifier")
        }
    }
    
    @objc private func networkStatusChanged()
    {
        if reachability.connection != .unavailable
        {
            loadAllCommonAd()
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("netStatusChangedForGoogleAd"), object: nil)
    }
}

extension GoogleAd_IDs
{
    public func setupPurchaseFlag(_ isPurchase : Bool = false)
    {
        isRemoveAd = isPurchase
        NotificationCenter.default.post(name: NSNotification.Name("isRemoveAdStatusChanged"), object: nil)
    }
    
    private func loadAllCommonAd()
    {
        InterstitialAd_Common.shared.loadInterstitialAD()
        OpenAd_Common.shared.addNotificationObserver()
        RewardAd_Common.shared.loadRewardAD()
    }
}

extension GoogleAd_IDs
{
    func checkNetStatus() -> Bool
    {
        do
        {
            let reachability = try? Reachability()
            
            if reachability?.connection != .unavailable
            {
                return true
            }
        }
        
        return false
    }
}

// MARK:- Add Appi id key value in info plist for use google ads
/*extension GoogleAd_IDs
{
    private func checkAppKeyAddedOrNot()
    {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        {
            if let _ = NSDictionary(contentsOfFile: path)?.value(forKey: "GADApplicationIdentifier")
            {
                return true
            }
            else
            {
                print("Log ERROR :- Please Enter Google app id in info plist usong key GADApplicationIdentifier EX:- <key>GADApplicationIdentifier</key> <string>ca-app-pub-7238432815417079~8394843741</string>")
            }
         }
    }
}*/
