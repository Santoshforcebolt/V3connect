//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//

#import <Foundation/Foundation.h>
//#import "V3connect-Bridging-Header.h"
//#import "pjsua.h"
//#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
//#import "V3connect-Swift.h"
//#define PJMEDIA_HAS_VIDEO 1

//@implementation CallKitWrapper
//pjsua_acc_id acc_id;
//pjsua_call_id currentCallId;
//pj_status_t credentialStatus;
//static int pjsipInitialized = 0;
//- (int)startPjsipAndRegisterOnServer:(char *)sipDomain withUserName:(char *)sipUser andPassword:(char *)password shouldRegisterOnStartup:(bool)shouldRegisterOnStartup callback:(RegisterCallBack)callback
//{
//    
//    if (pjsipInitialized){
//        return 0;
//    }
//    pj_status_t status;
//    // Create pjsua first
//    status = pjsua_create();
//    if (status != PJ_SUCCESS) error_exit("Error in pjsua_create()", status);
//    
//    // Init pjsua
//    {
//        // Init the config structure
//        pjsua_config cfg;
//        pjsua_logging_config log_cfg;
//        pjsua_config_default (&cfg);
//        
//        //Media
//        pjsua_media_config media_cfg;
//        pjsua_media_config_default(&media_cfg);
//        
//        cfg.cb.on_call_media_state = &on_call_media_state;
//        cfg.cb.on_call_state = &on_call_state;
//        cfg.cb.on_reg_state2 = &on_reg_state;
//        cfg.cb.on_incoming_call = &on_incoming_call;
//        
//        // Init the logging config structure
//        pjsua_logging_config_default(&log_cfg);
//        log_cfg.console_level = 4;
//        
//        // Init the pjsua
//        status = pjsua_init(&cfg, &log_cfg, NULL);
//        if (status != PJ_SUCCESS) error_exit("Error in pjsua_init()", status);
//    }
//    
//    // Add UDP transport.
//    {
//        // Init transport config structure
//        pjsua_transport_config cfg;
//        pjsua_transport_config_default(&cfg);
//        cfg.port = 5060;
//        
//        // Add TCP transport.
//        status = pjsua_transport_create(PJSIP_TRANSPORT_UDP, &cfg, NULL);
//        if (status != PJ_SUCCESS) error_exit("Error creating transport", status);
//    }
//    
//    
//    // Add TCP transport.
//    {
//        // Init transport config structure
//        pjsua_transport_config cfg;
//        pjsua_transport_config_default(&cfg);
//        cfg.port = 5060;
//        
//        // Add TCP transport.
//        status = pjsua_transport_create(PJSIP_TRANSPORT_TCP, &cfg, NULL);
//        if (status != PJ_SUCCESS) error_exit("Error creating transport", status);
//    }
//    
//    // Initialization is done, now start pjsua
//    status = pjsua_start();
//    if (status != PJ_SUCCESS) error_exit("Error starting pjsua", status);
//    
//    // Register the account on local sip server/* Register to SIP server by creating SIP account. */
//    {
//        pjsua_acc_config cfg;
//        
//        pjsua_acc_config_default(&cfg);
//        
//        // Account ID
//        char sipId[100];
//        sprintf(sipId, "sip:%s@%s", sipUser, sipDomain);
//        cfg.id = pj_str(sipId);
//        
//        // Reg URI
//        char regUri[100];
//        sprintf(regUri, "sip:%s", sipDomain);
//        cfg.reg_uri = pj_str(regUri);
//        
//        // Account cred info
//        cfg.cred_count = 1;
//        cfg.cred_info[0].scheme = pj_str("digest");
//        cfg.cred_info[0].realm = pj_str("*");
//        cfg.cred_info[0].username = pj_str(sipUser);
//        cfg.cred_info[0].data_type = PJSIP_CRED_DATA_PLAIN_PASSWD;
//        cfg.cred_info[0].data = pj_str(password);
//        
//        
//        //Normal Video Setup For Account
//        cfg.vid_in_auto_show = PJ_TRUE;
//        cfg.vid_out_auto_transmit = PJ_TRUE;
//        cfg.vid_wnd_flags = PJMEDIA_VID_DEV_WND_BORDER | PJMEDIA_VID_DEV_WND_RESIZABLE;
//        cfg.vid_cap_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV;
//        cfg.vid_rend_dev = PJMEDIA_VID_DEFAULT_RENDER_DEV;
//        cfg.reg_retry_interval = 300;
//        cfg.reg_first_retry_interval = 30;
//        
//        status = pjsua_acc_add(&cfg, PJ_TRUE, &acc_id);
//        
//        if (status != PJ_SUCCESS){
//            callback(status);
//            pjsua_destroy();
//        }else{
//            if(!shouldRegisterOnStartup){
//                pjsua_destroy();
//                callback(credentialStatus);
//            }else{
//                pjsipInitialized = 1;
//            }
//        }
//    }
//    
//    return 0;
//}
//
//void on_reg_state(pjsua_acc_id acc_id, pjsua_reg_info *info) {
//    if (info && info->cbparam) {
//        if (info->cbparam->code == PJSIP_SC_FORBIDDEN || info->cbparam->code == PJSIP_SC_UNAUTHORIZED) {
//            NSLog(@"Registration failed due to wrong credentials or SIP domain.");
//            credentialStatus = info->cbparam->code;
//        } else if (info->cbparam->code == PJSIP_SC_OK) {
//            NSLog(@"Registration successful.");
//            credentialStatus = info->cbparam->code;
//        } else {
//            NSLog(@"Other registration status: %d", info->cbparam->code);
//            credentialStatus = info->cbparam->code;
//        }
//    } else {
//        NSLog(@"Invalid info or cbparam pointers.");
//    }
//}
//
//- (void)makeCallTo:(char*)destUri
//{
//    pj_status_t status;
//    //current register id _acc_id
//    pjsua_call_id p_call_id;
//    NSString *destinationString = [NSString stringWithFormat:@"sip:%s@12.152.71.226:5060", destUri];
//    const char *destinationCString = [destinationString UTF8String];
//    pj_str_t destinationPjStr = pj_str((char *)destinationCString);
//    status = pjsua_call_make_call(acc_id, &destinationPjStr, 0, NULL, NULL, &p_call_id);
//    if (status != PJ_SUCCESS) {
//        NSLog(@"Error making call: %d", status);
//    } else {
//        NSLog(@"Call initiated to %s", destUri);
//    }
//}
//
//-(void) make_video_call:(char*)destUri {
//    pj_status_t status;
//
//    // Create a call setting with video support
//    pjsua_call_setting call_setting;
//    pjsua_call_setting_default(&call_setting);
//    call_setting.aud_cnt = 1;
//    call_setting.vid_cnt = 1;
//    
//  
//    //current register id _acc_id
//    NSString *destinationString = [NSString stringWithFormat:@"sip:%s@12.152.71.226:5060", destUri];
//    const char *destinationCString = [destinationString UTF8String];
//    pj_str_t destinationPjStr = pj_str((char *)destinationCString);
//
//    pjsua_call_id call_id;
//    status = pjsua_call_make_call(acc_id, &destinationPjStr, &call_setting, NULL, NULL, &call_id);
//
//    if (status != PJ_SUCCESS) {
//        return;
//    }
//}
//
//
//// Callback function for handling incoming calls
//void on_incoming_call(pjsua_acc_id acc_id, pjsua_call_id call_id, pjsip_rx_data *rdata) {
//    pjsua_call_info ci;
//    pjsua_call_get_info(call_id, &ci); // Retrieve call information
//    
//    if (ci.remote_info.ptr != NULL) {
//        NSString *callerNumber = [NSString stringWithUTF8String:ci.remote_contact.ptr];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"IncomingCall" object:callerNumber];
//        currentCallId = call_id;
//    } else {
//        NSLog(@"Remote info pointer is NULL");
//    }
//}
//
//- (void)pickUPCall {
//    if (currentCallId != PJSUA_INVALID_ID) {
//        pjsua_call_answer(currentCallId, 200, NULL, NULL);
//    }else{
//        NSLog(@"Error %d",currentCallId);
//    }
//}
//
//- (void)startCameraCapture {
//    // Initialize AVCaptureSession and start the camera capture here
//    // This function should be called on a background thread
//    // Example:
//    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
//    // Configure and start the capture session
//    [captureSession startRunning];
//}
//
//
//- (void)endCall {
//    pjsua_call_hangup_all();
//}
//
//// Callback function for handling call media state changes
//void on_call_media_state(pjsua_call_id call_id) {
//    pjsua_call_info call_info;
//    pjsua_call_get_info(call_id, &call_info);
//    
//    if (call_info.media_status == PJSUA_CALL_MEDIA_ACTIVE) {
//        pjsua_conf_connect(call_info.conf_slot, 0);
//        pjsua_conf_connect(0, call_info.conf_slot);
//        
//        // Handle video stream connection
//        for (unsigned mi = 0; mi < call_info.media_cnt; ++mi) {
//            if (call_info.media[mi].type == PJMEDIA_TYPE_VIDEO && call_info.media[mi].dir & PJMEDIA_DIR_DECODING) {
//                NSLog(@"Video stream is active.");
//                    displayWindow(call_info.media[mi].stream.vid.win_in);
//              
//            }
//        }
//    }
//}
//
//-(void) activateSipSoundDevices {
//    pj_status_t status = pjsua_set_snd_dev(0, 0);
//}
//
//-(void) deactivateSipSoundDevices {
//    pj_status_t status = pjsua_set_null_snd_dev();
//}
//
//// Define your callback function to handle SIP events.
//static void on_call_state(pjsua_call_id call_id, pjsip_event *e) {
//    pjsua_call_info ci;
//    PJ_UNUSED_ARG(e);
//    pjsua_call_get_info(call_id, &ci);
//    switch (ci.state) {
//        case PJSIP_INV_STATE_NULL:
//            break;
//        case PJSIP_INV_STATE_CALLING:
//            // INVITE call is being sent.
//            NSLog(@"INVITE call is being sent.");
//            break;
//        case PJSIP_INV_STATE_INCOMING:
//            // INVITE call is incoming, you can send a response.
//            NSLog(@"Incoming INVITE call.");
//            break;
//        case PJSIP_INV_STATE_EARLY:
//            // Call is in early media state, handle responses.
//            NSLog(@"Call in early media state.");
//            // Handle different responses here.
//            break;
//        case PJSIP_INV_STATE_CONNECTING:
//            // Call is being connected.
//            NSLog(@"Call is being connected.");
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidConnect" object:@"Conncted"];
//            break;
//        case PJSIP_INV_STATE_CONFIRMED:
//            // Call is confirmed, media is active.
//            NSLog(@"Call is confirmed, media is active.");
//            
//            break;
//        case PJSIP_INV_STATE_DISCONNECTED:
//            // Call is disconnected.
//            if (ci.last_status ==  PJSIP_SC_NOT_FOUND) {
//                // Call failed, handle the error
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnected" object:@"Address not found"];
//                NSLog(@"Address not found");
//            }else{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnected" object:@"Disconnected"];
//                NSLog(@"Call failed with status code: %d", ci.last_status);
//            }
//            
//            break;
//    }
//}
//
//- (void)connectAudioToConference:(int)confSlot {
//    pj_status_t status;
//    // Connect call's audio to conference bridge
//    status = pjsua_conf_connect(confSlot, 0);
//    if (status != PJ_SUCCESS) {
//        NSLog(@"Error connecting call audio to conference: %d", status);
//        return;
//    }
//    
//    // Connect conference bridge audio to call
//    status = pjsua_conf_connect(0, confSlot);
//    if (status != PJ_SUCCESS) {
//        NSLog(@"Error connecting conference audio to call: %d", status);
//    }
//}
//
//// outgoing call ring
//void configureRingbackTone(void) {
//    pj_status_t status;
//    
//    // Create the ringback tone player
//    pjsua_player_id player_id;
//    
//    const char *ringbackTonePath = "/Users/getitrent/Downloads/PJSIPTesting/PJSIPTesting/Morni Banke.mp3";
//    pj_str_t ringbackPathPjStr = pj_str((char *)ringbackTonePath);
//    
//    status = pjsua_player_create(&ringbackPathPjStr, PJ_TRUE, &player_id);
//    if (status != PJ_SUCCESS) {
//        NSLog(@"Error creating ringback tone player: %d", status);
//        return;
//    }
//    
//    // Set the ringback tone player as the default
//    status = pjsua_conf_connect(player_id, 0);
//    if (status != PJ_SUCCESS) {
//        NSLog(@"Error connecting ringback tone player: %d", status);
//        return;
//    }
//}
//
//
//void error_exit(const char *message, pj_status_t status) {
//    NSLog(@"%s: %d", message, status);
//    exit(1);
//}
//
//
//-(void) unRegisterSIP{
//    pjsua_acc_info accInfo;
//    if (pjsua_acc_get_info(acc_id, &accInfo) == PJ_SUCCESS) {
//        // Unregister the account
//        pjsua_acc_set_registration(acc_id, PJ_FALSE);
//    } else {
//        NSLog(@"Failed to get account info for account ID: %d", acc_id);
//    }
//}
//
//-(void) reRegisterSIP{
//    pjsua_acc_info accInfo;
//    if (pjsua_acc_get_info(acc_id, &accInfo) == PJ_SUCCESS) {
//        // register the account
//        pjsua_acc_set_registration(acc_id, PJ_TRUE);
//    } else {
//        NSLog(@"Failed to get account info for account ID: %d", acc_id);
//    }
//}
//- (void)logout{
//    if (pjsipInitialized) {
//        pjsua_destroy();
//    }
//}
//
//void displayWindow(pjsua_vid_win_id wid)
//{
//#if PJSUA_HAS_VIDEO
//NSLog(@"windows id : %d",wid);
//int i, last;
//
//i = (wid == PJSUA_INVALID_ID) ? 0 : wid;
//last = (wid == PJSUA_INVALID_ID) ? PJSUA_MAX_VID_WINS : wid+1;
//if(wid == PJSUA_INVALID_ID){
//printf("MyLogger: displayWindow failed\n");
//}else{
//printf("MyLogger: displayWindow success\n");}
//for (;i < last; ++i) {
//    pjsua_vid_win_info wi;
//    pj_status_t myStatus;
//    myStatus = pjsua_vid_win_get_info(i, &wi);
//    
//    if (myStatus == PJ_SUCCESS) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /* Add the video window as subview */
//            VideoCallViewController *videoCallVC = [[VideoCallViewController alloc] init];
//            UIView *parent = videoCallVC.view;
//            UIView *view = (__bridge UIView *)wi.hwnd.info.ios.window;
//            if (parent) {
//                if (![view isDescendantOfView:parent]){
//                    [view addSubview:parent];
//                }
//                if (!wi.is_native) {
//                    /* Resize it to fit width */
//                    view.bounds = CGRectMake(0, 0, parent.bounds.size.width,
//                                             (parent.bounds.size.height *
//                                              1.0*parent.bounds.size.width/
//                                              view.bounds.size.width));
//                    /* Center it horizontally */
//                    view.center = CGPointMake(parent.bounds.size.width/2.0,
//                                              view.bounds.size.height/2.0);
//                } else {
//                    /* Preview window, move it to the bottom */
//                    view.center = CGPointMake(parent.bounds.size.width/2.0,
//                                              parent.bounds.size.height-
//                                              view.bounds.size.height/2.0);
//                }
//            }
//                
//            });
//        
//    }
//
//
//    NSLog(@"Windows ID: %d", wid);
//#else
//    NSLog(@"Video not supported.");
//
//#endif
//}
//    
//}
//
//@end
