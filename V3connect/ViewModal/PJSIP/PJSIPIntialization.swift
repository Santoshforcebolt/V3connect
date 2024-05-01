//
// __FILENAME__
// __PACKAGENAME__
//
// Created by Saurabh Pathak on __DATE__.
//
// FURTHER, IF ANY
//


import Foundation
import SwiftUI

var currentCallID: pjsua_call_id?
var acc_id = pjsua_acc_id()
var credentialStatus = pj_status_t()
var pjsipInitialized = 0

func startPjsipAndRegister(onServer domain:String, withUserName userName: String, andPassword password: String, shouldRegisterOnStartup: Bool, callback: @escaping((Int) -> Void)) -> Int{
    if ((pjsipInitialized) != 0){
        return 0;
    }
    var status: pj_status_t;
    status = pjsua_create();
    if (status != PJ_SUCCESS.rawValue) {
        NSLog("Failed creating pjsua");
    }
    /* Init configs */
    var cfg = pjsua_config();
    var log_cfg = pjsua_logging_config();
    var media_cfg = pjsua_media_config();
    pjsua_config_default(&cfg);
    pjsua_logging_config_default(&log_cfg);
    pjsua_media_config_default(&media_cfg);
    /* Initialize application callbacks */
    cfg.cb.on_call_state = on_call_state;
    cfg.cb.on_call_media_state = on_call_media_state;
    cfg.cb.on_incoming_call = on_incoming_call;
    cfg.cb.on_reg_state2 = on_reg_state;
    
    /* Init pjsua */
    status = pjsua_init(&cfg, &log_cfg, &media_cfg);
    
    /* Create transport */
    var transport_id = pjsua_transport_id();
    var tcp_cfg = pjsua_transport_config();
    pjsua_transport_config_default(&tcp_cfg);
    tcp_cfg.port = 5060;
    
    status = pjsua_transport_create(PJSIP_TRANSPORT_UDP,
                                    &tcp_cfg, &transport_id);
    status = pjsua_transport_create(PJSIP_TRANSPORT_TCP,
                                    &tcp_cfg, &transport_id);
    
//    codecIntialization()
    /* Start pjsua */
    status = pjsua_start();
    
    /* Init account config */
    let id = strdup("sip:\(userName)@\(domain)");
    let username = strdup(userName);
    let passwd = strdup(password);
    let realm = strdup("*");
    let registrar = strdup("sip:\(domain)");
    
    var acc_cfg = pjsua_acc_config();
    pjsua_acc_config_default(&acc_cfg);
    acc_cfg.id = pj_str(id);
    acc_cfg.cred_count = 1;
    acc_cfg.cred_info.0.username = pj_str(username);
    acc_cfg.cred_info.0.realm = pj_str(realm);
    acc_cfg.cred_info.0.data = pj_str(passwd);
    acc_cfg.reg_uri = pj_str(registrar);
    
    acc_cfg.vid_in_auto_show = pj_bool_t(PJ_TRUE.rawValue)
    acc_cfg.vid_out_auto_transmit = pj_bool_t(PJ_TRUE.rawValue)
    
    // Define the orientation value
//    var orient = pjmedia_orient(0)
//    orient = PJMEDIA_ORIENT_ROTATE_90DEG
//    pjsua_vid_dev_set_setting(PJMEDIA_VID_DEFAULT_CAPTURE_DEV.rawValue,
//                              PJMEDIA_VID_DEV_CAP_ORIENTATION,
//                              &orient, pj_bool_t(PJ_TRUE.rawValue))
    
    // MULTITASKING_SUPPORT
    pj_activesock_enable_iphone_os_bg(0)
    
    /* Add account */
    pjsua_acc_add(&acc_cfg, pj_bool_t(PJ_TRUE.rawValue), nil);
    
    if (status != PJ_SUCCESS.rawValue){
        callback(Int(status));
        pjsua_destroy();
    }
    else{
        if(!shouldRegisterOnStartup){
            pjsua_destroy();
            callback(Int(credentialStatus));
        }else{
            pjsipInitialized = 1;
        }
    }
    
    /* Free strings */
    free(id); free(username); free(passwd); free(realm);
    free(registrar);
    return 0;
}

private func codecIntialization(){
    // Get the video codec parameters for H.264
    let codec = strdup("H264, 4")
    var codec_id:pj_str_t = pj_str(codec);
    var param = pjmedia_vid_codec_param()
    pjsua_vid_codec_get_param(&codec_id, &param)
    
    // Set the desired height and width for encoding
    param.enc_fmt.det.vid.size.w = 320; //1280
    param.enc_fmt.det.vid.size.h = 240; //720

    param.dec_fmt.det.vid.size.w = 320; //1280
    param.dec_fmt.det.vid.size.h = 240; //720

    // Set the updated video codec parameters for H.264
    pjsua_vid_codec_set_param(&codec_id, &param)
}


private func on_reg_state(acc_id: pjsua_acc_id, info: UnsafeMutablePointer<pjsua_reg_info>?) {
    guard let info = info, let cbparam = info.pointee.cbparam else {
        NSLog("Invalid info or cbparam pointers.")
        return
    }
    
    let statusCode = Int(cbparam.pointee.code)
    
    if statusCode == PJSIP_SC_FORBIDDEN.rawValue || statusCode == PJSIP_SC_UNAUTHORIZED.rawValue {
        NSLog("Registration failed due to wrong credentials or SIP domain.")
    } else if statusCode == PJSIP_SC_OK.rawValue {
        NSLog("Registration successful.")
    } else {
        NSLog("Other registration status: %d", statusCode)
    }
    
    credentialStatus = pj_status_t(statusCode)
}

private func on_call_state(call_id: pjsua_call_id, e: UnsafeMutablePointer<pjsip_event>?) {
    let callHistoryManager = CallHistoryManager.shared
    let receivedEndCall = ReceivedEndCall.shared
    var ci = pjsua_call_info();
    pjsua_call_get_info(call_id, &ci);
    if (ci.state == PJSIP_INV_STATE_DISCONNECTED) {
        switch (ci.state) {
        case PJSIP_INV_STATE_NULL:
            break;
        case PJSIP_INV_STATE_CALLING:
            // INVITE call is being sent.
            NSLog("INVITE call is being sent.");
            break;
        case PJSIP_INV_STATE_INCOMING:
            // INVITE call is incoming, you can send a response.
            NSLog("Incoming INVITE call.");
            break;
        case PJSIP_INV_STATE_EARLY:
            // Call is in early media state, handle responses.
            NSLog("Call in early media state.");
            break;
        case PJSIP_INV_STATE_CONNECTING:
            // Call is being connected.
            NSLog("Call is being connected.");
            NotificationCenter.default.post(name: Notification.Name("DidConnect"), object: "DidConnect")
            break;
        case PJSIP_INV_STATE_CONFIRMED:
            // Call is confirmed, media is active.
            NSLog("Call is confirmed, media is active.");
            
            break;
        case PJSIP_INV_STATE_DISCONNECTED:
            // Call is disconnected.
            if (ci.last_status ==  PJSIP_SC_NOT_FOUND) {
                NotificationCenter.default.post(name: Notification.Name("Disconnected"), object: "Address not found")
                DispatchQueue.main.async {
                    VidInfo.shared.vid_win = nil
                }
                NSLog("Address not found");
            }else{
                NotificationCenter.default.post(name: Notification.Name("Disconnected"), object: "Successfully call Disconnected")
                DispatchQueue.main.async {
                    VidInfo.shared.vid_win = nil
                }
                NSLog("Call failed with status code: \(ci.last_status)");
            }
            
//            var ci = pjsua_call_info();
//            pjsua_call_get_info(call_id, &ci);
////            pj_status_t status;
////            let status = pjsua_call_set_vid_strm(call_id, PJSUA_CALL_VID_STRM_REMOVE, nil);
//            let status = pjsua_call_set_vid_strm(call_id, PJSUA_CALL_VID_STRM_STOP_TRANSMIT, nil);
//            if (status != PJ_SUCCESS.rawValue) {
//                // Handle the error, e.g., log or report the error
//                print("You may also need to handle any necessary cleanup")
//            }
            DispatchQueue.main.async {
                CallManagerPJSIP.shared.isOutgoingcallHangup = false
                guard let callID = callHistoryManager.callID else{return}
                receivedEndCall.endCall(callID: callID)
            }
            break;
        default:
            break
        }
    }
}
private func tupleToArray<Tuple, Value>(tuple: Tuple) -> [Value] {
    let tupleMirror = Mirror(reflecting: tuple)
    return tupleMirror.children.compactMap { (child: Mirror.Child) -> Value? in
        return child.value as? Value
    }
}
private func on_call_media_state(call_id: pjsua_call_id) {
    var ci = pjsua_call_info();
    pjsua_call_get_info(call_id, &ci);
    for mi in 0...ci.media_cnt {
        let media: [pjsua_call_media_info] = tupleToArray(tuple: ci.media);
        if (media[Int(mi)].status == PJSUA_CALL_MEDIA_ACTIVE ||
            media[Int(mi)].status == PJSUA_CALL_MEDIA_REMOTE_HOLD)
        {
            switch (media[Int(mi)].type) {
                case PJMEDIA_TYPE_AUDIO:
                    var call_conf_slot: pjsua_conf_port_id;
                    call_conf_slot = media[Int(mi)].stream.aud.conf_slot;
                    pjsua_conf_connect(call_conf_slot, 0);
                    pjsua_conf_connect(0, call_conf_slot);
                    break;
                    
                case PJMEDIA_TYPE_VIDEO:
               // For incoming remote view
                let wid = media[Int(mi)].stream.vid.win_in;
                    var wi = pjsua_vid_win_info();
                    if (pjsua_vid_win_get_info(wid, &wi) == PJ_SUCCESS.rawValue) {
                        let vid_win:UIView =
                        Unmanaged<UIView>.fromOpaque(wi.hwnd.info.ios.window).takeUnretainedValue();
                        DispatchQueue.main.async {
                            vid_win.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2.0))
                            VidInfo.shared.vid_win = vid_win
                        }
                    }
                
                // For outgoing local view
                let localwid = media[Int(mi)].stream.vid.cap_dev;
                var parm = pjsua_vid_preview_param()
                pjsua_vid_preview_param_default(&parm)
                parm.rend_id = PJMEDIA_VID_DEFAULT_RENDER_DEV.rawValue
                parm.show = pj_bool_t(PJ_TRUE.rawValue)
                let status = pjsua_vid_preview_start(localwid, &parm)
                if status == PJ_SUCCESS.rawValue {
                    let wid = pjsua_vid_preview_get_win(localwid);
                    if (pjsua_vid_win_get_info(wid, &wi) == PJ_SUCCESS.rawValue) {
                        let vid_win:UIView =
                        Unmanaged<UIView>.fromOpaque(wi.hwnd.info.ios.window).takeUnretainedValue();
                        // Make sure it clips to bounds to ensure it doesn't exceed the frame size
                        DispatchQueue.main.async {
                            vid_win.clipsToBounds = true
                            VidInfo.shared.localvid_win = vid_win
                        }
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}


private func on_incoming_call(acc_id: pjsua_acc_id, call_id: pjsua_call_id, rdata: UnsafeMutablePointer<pjsip_rx_data>?) {
    let callManagerPJSIP = CallManagerPJSIP.shared
    DispatchQueue.main.async {
        callManagerPJSIP.isOutgoingcallHangup = true
    }
    var ci = pjsua_call_info()
    var opt = pjsua_call_setting()
    pjsua_call_setting_default(&opt)
    var p_param = pjsua_vid_preview_param()
    pjsua_vid_preview_param_default(&p_param)

    p_param.show = pj_bool_t(PJ_TRUE.rawValue)
    opt.aud_cnt = 1
    pjsua_call_get_info(call_id, &ci)

    print("Remote \(ci.rem_offerer) and video \(ci.rem_vid_cnt) and \(ci.setting.vid_cnt)")
    if (ci.rem_offerer != 0) && ci.rem_vid_cnt == 1{
        print("This is video call")
        opt.vid_cnt = 1
        DispatchQueue.main.async {
            callManagerPJSIP.isVideoCall = true
        }
    }else{
        opt.vid_cnt = 0
        DispatchQueue.main.async {
            callManagerPJSIP.isVideoCall = false
        }
        print("This is a audio call")
    }
    
    if ci.remote_contact.ptr != nil && ci.local_contact.ptr != nil{
        if let local = String(cString: ci.local_contact.ptr) as String?,let remote = String(cString: ci.remote_contact.ptr) as String? {
            let remoteCallName = getCallNumber(sipURI: remote)
            let localCallName  = getCallNumber(sipURI: local)
            if  remoteCallName == localCallName{
                pjsua_call_hangup_all()
            }else{
                NotificationCenter.default.post(name: Notification.Name("IncomingCall"), object: remote)
                currentCallID = call_id
            }
        }
    } else {
        print("Remote info pointer is NULL")
    }
    
    func getCallNumber(sipURI: String) -> String?{
        if let match = sipURI.range(of: "sip:(.*?)@", options: .regularExpression) {
            let startIndex = sipURI.index(match.lowerBound, offsetBy: 4) // Skip "sip:"
            let endIndex = sipURI.index(before: match.upperBound) // Exclude the "@" symbol
            let extractedString = sipURI[startIndex..<endIndex]
            return String(extractedString)
        } else {
            print("Pattern not found")
            return nil
        }
    }
}

class CallKitWrapper{
    static let shared = CallKitWrapper()

    func makeCall(dest: String,isVideoCall: Bool) {
        var status: pj_status_t;
        let dest_str = strdup(dest);
        var dest:pj_str_t = pj_str(dest_str);
        var call_id: pjsua_call_id = PJSUA_INVALID_ID.rawValue
        var opt = pjsua_call_setting();
        pjsua_call_setting_default(&opt);
        opt.aud_cnt = 1;        
        if isVideoCall{
            opt.vid_cnt = 1;
        }else{
            opt.flag = PJSUA_CALL_INCLUDE_DISABLED_MEDIA.rawValue;
            opt.vid_cnt = 0;
        }
        status = pjsua_call_make_call(0, &dest, &opt, nil, nil, &call_id);
        
        let phone = "1234567890"
        if let callUrl = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(callUrl) {
             UIApplication.shared.open(callUrl)
        }
        
        if (status != PJ_SUCCESS.rawValue) {
            NSLog("Error making call: \(status)");
        } else {
            NSLog("Call initiated to \(dest)");
        }
        free(dest_str);
    }
    
    func pickUPCall(){
        if (currentCallID != PJSUA_INVALID_ID.rawValue) {
            var status: pj_status_t;
            var opt = pjsua_call_setting()
            pjsua_call_setting_default(&opt)
            var p_param = pjsua_vid_preview_param()
            pjsua_vid_preview_param_default(&p_param)
            p_param.show = pj_bool_t(PJ_TRUE.rawValue)
            opt.aud_cnt = 1
            opt.vid_cnt = 1
            status = pjsua_call_answer2(currentCallID ?? 0, &opt, 200, nil, nil)
            if (status != PJ_SUCCESS.rawValue) {
                NSLog("Error making call: \(status)");
            } else {
                NSLog("Call initiated to \(status)");
            }
        }else{
            print("Error,\(String(describing: currentCallID))")
        }
    }
    
    func endCall() {
        if currentCallID != PJSUA_INVALID_ID.rawValue {
            var ci = pjsua_call_info()
            pjsua_call_get_info(currentCallID ?? 0, &ci)
            print("your call state",ci.state)
            if  ci.state == PJSIP_INV_STATE_CONFIRMED || ci.state.rawValue == 1{
                print(PJSIP_INV_STATE_CONFIRMED.rawValue)
                pjsua_call_hangup_all()
                currentCallID = PJSUA_INVALID_ID.rawValue
            }else {
                // Handle the call state accordingly (e.g., notify the user)
                pickUPCall()
                pjsua_call_hangup_all()
                currentCallID = PJSUA_INVALID_ID.rawValue
                NSLog("Call is not in the CONFIRMED state, cannot hang up.")
            }
        } else {
            // Handle the case when there is no ongoing call
            NSLog("No active call to hang up.")
            pjsua_call_hangup_all()
        }
    }

    func unRegisterSIP(){
        var accInfo = pjsua_acc_info()
        if (pjsua_acc_get_info(acc_id, &accInfo) == PJ_SUCCESS.rawValue) {
            // Unregister the account
            pjsua_acc_set_registration(acc_id, pj_bool_t(PJ_FALSE.rawValue));
        } else {
            NSLog("Failed to get account info for account ID: \(acc_id)");
        }
    }
    
    func reRegisterSIP(){
        var accInfo = pjsua_acc_info()
        if (pjsua_acc_get_info(acc_id, &accInfo) == PJ_SUCCESS.rawValue) {
            // register the account
            pjsua_acc_set_registration(acc_id, pj_bool_t(PJ_TRUE.rawValue));
        } else {
            NSLog("Failed to get account info for account ID: \(acc_id)");
        }
    }
    
    func logoutPJSIP(){
        if ((pjsipInitialized) != 0) {
            pjsua_destroy();
        }
    }
    
    // Activate SIP sound devices
    func activateSipSoundDevices() {
        _ = pjsua_set_snd_dev(0, 0)
        // Handle status as needed
    }
    
    // Deactivate SIP sound devices
    func deactivateSipSoundDevices() {
        _ = pjsua_set_null_snd_dev()
        var param = pjsua_call_vid_strm_op_param()
        pjsua_call_vid_strm_op_param_default(&param)
        let status = pjsua_call_set_vid_strm(0,PJSUA_CALL_VID_STRM_STOP_TRANSMIT, &param)
    }
    
    func flipCamera(isBackCamara: Bool){
        var param = pjsua_call_vid_strm_op_param()
        pjsua_call_vid_strm_op_param_default(&param)
        param.cap_dev = PJMEDIA_VID_DEFAULT_CAPTURE_DEV.rawValue
        let deviceCount = pjsua_vid_dev_count()
  
        // Iterate through the available video devices to find the back camera
        for i in 0..<deviceCount {
            var info = pjmedia_vid_dev_info()
        
            pjsua_vid_dev_get_info(pjmedia_vid_dev_index(i), &info)
            //            print("Device \(i): \(info.name), Direction: \(info.dir.rawValue)")
            
            // Check if the device is a capture device and its name indicates it's the back camera
            if let deviceName = String(bytesNoCopy: UnsafeMutableRawPointer(mutating: &info.name), length: MemoryLayout.size(ofValue: info.name), encoding: .utf8, freeWhenDone: false){
                
                if isBackCamara{
                    if info.dir == PJMEDIA_DIR_CAPTURE  && deviceName.contains("Back Camera"){
                        // Set the capture device to the Back camera
                        param.cap_dev = pjmedia_vid_dev_index(i)
                    }
                }else{
                    if info.dir == PJMEDIA_DIR_CAPTURE  && deviceName.contains("Front Camera"){
                        // Set the capture device to the Front camera
                        param.cap_dev = pjmedia_vid_dev_index(i)
                    }
                }
            }
            // Set the video stream operation to change the capture device
            let status = pjsua_call_set_vid_strm(currentCallID ?? 0, PJSUA_CALL_VID_STRM_CHANGE_CAP_DEV, &param)
            if status == PJ_SUCCESS.rawValue {
                NSLog("Camera toggled")
            } else {
                NSLog("Error toggling camera")
            }
        }
    }
    
    
    func callInitTonegen(callId: pjsua_call_id) -> MyCallData?{
        
        var pool: UnsafeMutablePointer<pj_pool_t>?
        
        pool = pjsua_pool_create("mycall", 512, 512)
        
        let cd = pj_pool_zalloc(pool, MemoryLayout<MyCallData>.size).assumingMemoryBound(to: MyCallData.self)
        cd.pointee.pool = pool
        
        pjmedia_tonegen_create(pool, 8000, 1, 160, 16, 0, &cd.pointee.tonegen)
        pjsua_conf_add_port(pool, cd.pointee.tonegen, &cd.pointee.toneslot)
        
        var ci = pjsua_call_info()
        pjsua_call_get_info(callId, &ci)
        pjsua_conf_connect(cd.pointee.toneslot, ci.conf_slot)
        
        pjsua_call_set_user_data(callId, UnsafeMutableRawPointer(cd))
        
        return cd.pointee
    }
    
    
//    func callPlayDigit(digits: String) {
//        var d = [pjmedia_tone_digit](repeating: pjmedia_tone_digit(), count: 16)
//        let count = digits.utf8.count
//        var cd: MyCallData?
//        let callId = currentCallID ?? 0
//        
//        if let userDataPtr = pjsua_call_get_user_data(callId) {
//            //            cd = Unmanaged<MyCallData>.fromOpaque(userDataPtr).takeUnretainedValue()
//            callDeinitTonegen(callId: callId)
//            return
//        } else {
//            cd = callInitTonegen(callId: callId)
//        }
//        
//        let digitArray = Array(digits.utf8)
//        for i in 0..<count {
//            d[i].digit = CChar(digitArray[i])
//            d[i].on_msec = 100
//            d[i].off_msec = 200
//            d[i].volume = 0
//        }
//        
//        pjmedia_tonegen_play_digits(cd?.tonegen, pj_uint32_t(count), &d, 0)
//    }
    
//    func callDeinitTonegen(callId: pjsua_call_id) {
//        if let callUserData = pjsua_call_get_user_data(callId) {
//            let callDataPointer = callUserData.assumingMemoryBound(to: MyCallData.self)
//            let cd = callDataPointer.pointee
//            pjsua_conf_remove_port(cd.toneslot)
//            pjmedia_port_destroy(cd.tonegen)
//            pj_pool_release(cd.pool)
//            
//            pjsua_call_set_user_data(callId, nil)
//        }
//    }
    
//    func sendDTMFDigits(digits: String){
//        var dtmf_digit: pj_str_t = pj_str(UnsafeMutablePointer<Int8>(mutating: (digits as NSString).utf8String))
//        let  status = pjsua_call_dial_dtmf(currentCallID ?? 0, &dtmf_digit)
//        if status != PJ_SUCCESS.rawValue {
//            print("DTMF Error:\(status)")
//            return
//        }else{
//            print("Successfully send DTMF to server:\(status)")
//        }
//    }
    
    func sendDTMFDigits(digits: String){
     
        let callId: pjsua_call_id = currentCallID ?? 0
        // Define the DTMF parameter
        var dtmfParam = pjsua_call_send_dtmf_param()
        dtmfParam.method = pjsua_dtmf_method(PJSUA_DTMF_METHOD_RFC2833.rawValue) // Specify the DTMF method, e.g., RFC2833
        dtmfParam.digits = pj_str(UnsafeMutablePointer<Int8>(mutating: (digits as NSString).utf8String)) // Specify the DTMF digit you want to send

        // Send DTMF digit
        let status = pjsua_call_send_dtmf(callId, &dtmfParam)

        if status != PJ_SUCCESS.rawValue {
            print("Error sending DTMF: \(status)")
        } else {
            print("DTMF sent successfully")
        }
    }
}

struct MyCallData {
    var pool: UnsafeMutablePointer<pj_pool_t>?
    var tonegen: UnsafeMutablePointer<pjmedia_port>?
    var toneslot: pjsua_conf_port_id = 0
}
