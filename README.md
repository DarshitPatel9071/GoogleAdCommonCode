# Vasu_Common_AD

Use Common Code For All Type Of Google Ad's (Interstitial Ad || Banner Ad || Rewarded Ad || Native Ad || Banner Ad)

For use google ad common code in app first follow below  steps.

(1) Add Your Google App id In info.plist of your project.

ex:- 
<key>GADApplicationIdentifier</key> 
<string>ca-app-pub-****************~**********</string>

(2) in Appdelegate file

import Vasu_Common_AD

GoogleAd_IDs.shared.setupPurchaseFlag(purchaseFlag) // for set your app purchaseflag.

// for use live ad need to set your live app id 
GoogleAd_IDs.shared.initAdID() // set all live add id here

GoogleAd_IDs.shared.initialLoadAllAds() // for load all apps // comment code of unwanted ad's.


(3) For use of interstitial ad 

// if don't need of open add then set isNeedToShowinterstitialAd = false in interstitial_GoogleAd.swift file

// on button click

let tempObject = InterstitialAd_Common.shared

tempObject.interstitialAdDismiss = 
{
     print("Log :- PASS TO NEXT VIEW")    
    // do additional code here
}

tempObject.presentInterstitialAD()


(4) For use of Open ad 

// not need to any additional code for use open ad 
// if don't need of open add then set isNeedToShowOpenAd = false in Open_GoogleAd.swift file

(5) For use of Reward ad 

// if don't need of open add then set isNeedToShowrewardedAd = false in Reward_GoogleAd.swift file

// on button click

let tempObject = RewardAd_Common.shared
tempObject.rewardedAdDismiss = 
{
     (isReward_Earned) in
     
     print("Log :- Reward Earned :- \(isReward_Earned)")
     
      ///
      do additional code here
      ///
}

tempObject.presentInterstitialAD()

(6) For use of Banner ad 

// not need to any additional code for use Banner ad 
// Assign BannerAd_Common to your UIView for use banner ad
// if don't need of open add then set isNeedToShowBannerAd = false in Banner_GoogleAd.swift file
















