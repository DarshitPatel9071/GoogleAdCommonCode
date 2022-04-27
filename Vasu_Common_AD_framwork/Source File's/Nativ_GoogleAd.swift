//
//  interstitial_GoogleAd.swift
//  VV Google Ad Common Code
//
//  Created by iOS on 26/03/22.
//

import Foundation
import GoogleMobileAds

public class NativAd_Common : UIView
{
    private var tempNativHeight : CGFloat = 0
    private var isHeightGet = false
    private var isNeedToShowNativeAd = true
    
    private var nativ_Ad : GADNativeAd!
    private var nativeAd_Loader: GADAdLoader!
    
    public override func layoutSubviews()
    {
        if !isHeightGet
        {
            tempNativHeight = frame.size.height
            setupNativAd()
            hideShowNativView()
            load_NativAd()
            isHeightGet = true
        }
    }
}

// load Interstitial Ad's
extension NativAd_Common
{
    private func setupNativAd()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(load_NativAd), name: NSNotification.Name("isRemoveAdStatusChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(load_NativAd), name: NSNotification.Name("netStatusChangedForGoogleAd"), object: nil)
    }
    
    @objc private func load_NativAd()
    {
        if !GoogleAd_IDs.shared.isRemoveAd &&
            nativ_Ad == nil &&
            GoogleAd_IDs.shared.checkNetStatus() &&
            isNeedToShowNativeAd
        {
            let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
            multipleAdsOptions.numberOfAds = 1
            
            nativeAd_Loader = GADAdLoader(adUnitID: GoogleAd_IDs.allID.native_AdvancedID,
                                          rootViewController: UIViewController(),
                                          adTypes: [GADAdLoaderAdType.native],
                                          options: [multipleAdsOptions])
            
            nativeAd_Loader.delegate = self
            nativeAd_Loader.load(GADRequest())
        }
        else
        {
            hideShowNativView()
        }
    }
    
    private func loadNativAdXIB()
    {
        guard let nibObjects = Bundle.main.loadNibNamed("NativAd", owner: nil, options: nil),
              let adView = nibObjects.first as? GADNativeAdView else
        {
            return
        }
        
        subviews.forEach({if $0 is GADNativeAdView{$0.removeFromSuperview()}})
        addSubview(adView)
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDictionary = ["_nativeAdView": adView]
        
        superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        superview!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        
        // add title
        (adView.headlineView as? UILabel)?.text = nativ_Ad.headline
        
        // ad media
        adView.mediaView?.mediaContent = nativ_Ad.mediaContent
        
        // ad body (Ad description)
        (adView.bodyView as? UILabel)?.text = nativ_Ad.body
        adView.bodyView?.isHidden = nativ_Ad.body == nil
        
        // ad action button
        (adView.callToActionView as? UIButton)?.setTitle(nativ_Ad.callToAction?.uppercased(), for: .normal)
        adView.callToActionView?.isHidden = nativ_Ad.callToAction == nil
        
        // advertiser text
        let findexOfSubTitleView = adView.subviews.firstIndex(where: {$0.tag == 10203050}) ?? -1
        let findexOfStarView = adView.subviews.firstIndex(where: {$0.tag == 8456325}) ?? -1
        if let advertiserValue = nativ_Ad.advertiser
        {
            (adView.subviews[findexOfSubTitleView] as? UILabel)?.text = advertiserValue
            (adView.subviews[findexOfSubTitleView] as? UILabel)?.isHidden = false
            (adView.subviews[findexOfStarView] as? UIImageView)?.isHidden = true
        }
        else
        {
//            (adView.subviews[findexOfStarView] as? UIImageView)?.image = getStarImgForAd(from: nativ_Ad.starRating ?? 0)
            (adView.subviews[findexOfSubTitleView] as? UILabel)?.isHidden = true
            (adView.subviews[findexOfStarView] as? UIImageView)?.isHidden = false
        }
        
        
        setAdIcon_NativAD((adView.iconView as! UIImageView),nativ_Ad.icon)
        
        adView.callToActionView?.isUserInteractionEnabled = false
        
        adView.nativeAd = nativ_Ad
        
        print("&*&*&*&* 1 :- \(adView.frame.size.height)")
        print("&*&*&*&* 2 :- \(adView.layer.presentation()?.frame.size.height)")
        tempNativHeight = adView.frame.size.height
        hideShowNativView(false)
    }
    
    @objc private func hideShowNativView(_ isHide:Bool = true)
    {
        isHidden = isHide
        frame.size.height = isHide ? 0 : tempNativHeight
        
        for con in constraints
        {
            if con.constant == (isHide ? tempNativHeight : 0)
            {
                con.constant = isHide ? 0 : tempNativHeight
            }
        }
    }
    
    private func setAdIcon_NativAD(_ view : UIView,_ adImg : GADNativeAdImage? = nil)
    {
        if adImg == nil
        {
            if let fIndex = view.constraints.firstIndex(where: {$0.identifier == "imgWidth"})
            {
                view.constraints[fIndex].constant = 0
            }
            
            if let fIndex = view.superview!.constraints.firstIndex(where: {$0.identifier == "trailingImg"})
            {
                view.superview!.constraints[fIndex].constant = 0
            }
        }
        else
        {
            (view as? UIImageView)?.image = adImg?.image
        }
    }
    
    private func getStarImgForAd(from starRating: NSDecimalNumber?) -> UIImage?
    {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
        
        if rating >= 5
        {
            return UIImage(named: "ad_star_5")
        }
        else if rating >= 4.5
        {
            return UIImage(named: "ad_star_4_5")
        }
        else if rating >= 4
        {
            return UIImage(named: "ad_star_4")
        }
        else if rating >= 3.5
        {
            return UIImage(named: "ad_star_3_5")
        }
        else if rating >= 3
        {
            return UIImage(named: "ad_star_3")
        }
        else if rating >= 2.5
        {
            return UIImage(named: "ad_star_2_5")
        }
        else if rating >= 2
        {
            return UIImage(named: "ad_star_2")
        }
        else if rating >= 1.5
        {
            return UIImage(named: "ad_star_1_5")
        }
        else
        {
            return UIImage(named: "ad_star_1")
        }
    }
}

// MARK:- BannerView Delegate Method
extension NativAd_Common : GADNativeAdLoaderDelegate,GADNativeAdDelegate
{
    public func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error)
    {
        print("Log :- NativAd_Common :- Fail ad load :- \(error.localizedDescription)")
        hideShowNativView()
        nativ_Ad = nil
        load_NativAd()
    }
    
    public func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd)
    {
        print("Log :- NativAd_Common :- Nativ Ad Load Success")
        nativ_Ad = nativeAd
        nativ_Ad.delegate = self
        loadNativAdXIB()
    }
    
    public func nativeAdDidRecordClick(_ nativeAd: GADNativeAd)
    {
        hideShowNativView()
        nativ_Ad = nil
        load_NativAd()
    }
}
