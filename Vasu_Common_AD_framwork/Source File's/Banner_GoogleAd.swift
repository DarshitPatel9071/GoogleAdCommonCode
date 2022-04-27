//
//  interstitial_GoogleAd.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import GoogleMobileAds

public class BannerAd_Common : UIView
{
    private var bannerAdView : GADBannerView = GADBannerView()
    private var tempBannerHeight : CGFloat = 0
    private var isHeightGet = false
    private var isNeedToShowBannerAd = true
    
    public override func layoutSubviews()
    {
        if !isHeightGet
        {
            tempBannerHeight = frame.size.height
            setupBannerAd()
            hideShowBannerView()
            loadBannerAd()
            isHeightGet = true
        }
    }
}

// load Interstitial Ad's
extension BannerAd_Common
{
    private func setupBannerAd()
    {
        isUserInteractionEnabled = true
        bannerAdView.isUserInteractionEnabled = true
        
        bannerAdView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: tempBannerHeight)
        
        bannerAdView.adUnitID = GoogleAd_IDs.allID.bannerID
        bannerAdView.rootViewController = UIApplication.getTopMostVC() ?? UIViewController()
        bannerAdView.delegate = self
        
        addSubview(bannerAdView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadBannerAd), name: NSNotification.Name("isRemoveAdStatusChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadBannerAd), name: NSNotification.Name("netStatusChangedForGoogleAd"), object: nil)
    }
    
    @objc private func loadBannerAd()
    {
        if !GoogleAd_IDs.shared.isRemoveAd
            && GoogleAd_IDs.shared.checkNetStatus()
            && isNeedToShowBannerAd
        {
            bannerAdView.load(GADRequest())
        }
        else
        {
            hideShowBannerView()
        }
    }
    
    @objc private func hideShowBannerView(_ isHide:Bool = true)
    {
        isHidden = isHide
        frame.size.height = isHide ? 0 : tempBannerHeight
        
        for con in constraints
        {
            if con.constant == (isHide ? tempBannerHeight : 0)
            {
                con.constant = isHide ? 0 : tempBannerHeight
            }
        }
    }
}

// MARK:- BannerView Delegate Method
extension BannerAd_Common : GADBannerViewDelegate
{
    public func bannerViewDidReceiveAd(_ bannerView: GADBannerView)
    {
        // banner ad ready for show
        print("Log :- BannerAd_Common -- Banner Ad Is Recive")
        hideShowBannerView(false)
    }
    
    public func bannerViewDidRecordClick(_ bannerView: GADBannerView)
    {
        
    }
    
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error)
    {
        let tempErr = error.localizedDescription
        print("Log :- BannerAd_Common -- Banner Ad Failed :- \(tempErr)")
        hideShowBannerView()
        
        if tempErr.lowercased().contains("Too many recently failed requests".lowercased())
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.loadBannerAd()
            }
        }
        else
        {
            loadBannerAd()
        }
    }
}
