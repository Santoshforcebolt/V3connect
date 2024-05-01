//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//


#import "pjsua.h"
#define PJ_AUTOCONF 1
#define PJMEDIA_HAS_VIDEO 1
#define PJ_CONFIG_IPHONE  1
#define PJMEDIA_AUDIO_DEV_HAS_PORTAUDIO 0
#define PJMEDIA_VIDEO_DEV_SDL_HAS_OPENGL 1



//typedef NS_ENUM(NSUInteger, RegistrationStatus) {
//    RegistrationStatusSuccess,
//    RegistrationStatusFailed,
//    RegistrationStatusHostResolutionFailed,
//    // ... add more error types if needed
//};
//
//typedef void(^RegisterCallBack)(int status);
//
//@interface CallKitWrapper : NSObject
//
////properties
//@property (nonatomic, copy) RegisterCallBack registerCallBack;
//
//// Method
//- (int)startPjsipAndRegisterOnServer:(char *)sipDomain
//                        withUserName:(char *)sipUser
//                         andPassword:(char *)password
//             shouldRegisterOnStartup:(bool)shouldRegisterOnStartup
//                            callback:(RegisterCallBack)callback;
//- (void) makeCallTo:(char*)destUri;
//-(void) make_video_call:(char*)destUri;
//void  on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata);
//- (void) endCall;
//- (void) unRegisterSIP;
//- (void) reRegisterSIP;
//- (void) pickUPCall;
//-(void) activateSipSoundDevices;
//-(void) deactivateSipSoundDevices;
//- (void)logout;
//void displayWindow(pjsua_vid_win_id wid);
//
//@end
