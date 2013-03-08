//
//  TongQuConfig.h
//  PrettyRich
//
//  Created by lianyu zhang on 3/5/2013.
//
//

#ifndef QuizConfig_h
#define QuizConfig_h

#define IsEnvironmentProd NO //isEnvProd = YES to use prod,NO to use stage.

#endif
//description for key in Userdefauls
/*
key: appKey = appName + appVersion 
value: NO means app has not initialized for the first time ; YES means app data has already initialized.
*/

/*
key: @"LZSoundOn" 
value: YES means app sound on ; NO means app sound off.
*/

/*
key: @"LZAdsOff"  
value: YES means not show ads; NO means show ads.
*/

/*
key: productIdentifier (for the non-cunsumble product in store)
 @"com.lingzhi.QuizAwsome.removeads",
 @"com.lingzhi.QuizAwsome.unlockallpackages",
 @"com.lingzhi.QuizAwsome.unlockfortune",
 @"com.lingzhi.QuizAwsome.unlockhealth",
 @"com.lingzhi.QuizAwsome.unlockelectronic",
 @"com.lingzhi.QuizAwsome.unlocksportsclub",
 @"com.lingzhi.QuizAwsome.unlockfooddrink",
 
value: YES means user has already purchased this product; NO means user has not purchased this product or has not restore this product.
*/

/*
key: @"LZFacebookBonus"
value: YES means user got bonus already ; NO means user did not get bonus yet.

*/

/*
 key: @"LZTwitterBonus"
 value: YES means user got bonus already ; NO means user did not get bonus yet.
 
 */

/*
 key: @"LZReviewAppBonus"
 value: YES means user got bonus already ; NO means user did not get bonus yet.
 
 */