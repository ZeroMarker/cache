//获取客户端IP地址
function getIpAddress() {
    var clientInfo = getClientInfo();   //调平台组接口获取客户端信息
    if (clientInfo) {
        return clientInfo.ipAddress;
    }else{
        try {
            var locator = new ActiveXObject("WbemScripting.SWbemLocator");
            var service = locator.ConnectServer(".");
            var properties = service.ExecQuery("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled =True");
            var e = new Enumerator(properties); {
                var p = e.item();
                var ip = p.IPAddress(0);
                return ip
            }
        } catch (err) {
            return "";
        }
    }
}

//调用平台组接口获取客户端信息
function getClientInfo()
{
    var rtn = "";
    var data = {
        action: "GET_CLIENTINFO",
        params: {
            loginID: loginID
        },
        product: envVar.product
    };
    ajaxGETCommon(data, function(ret){
        rtn = ret;
    }, function (error) {
        $.messager.alert("发生错误", "getClientInfo error:"+error, "error");
    }, false);
    return rtn;
}

/**
 * 前后台交互POST/GET方法
 * @creater Donglulu
 * @param data 命令数据json对象，例：{"action":"GET_TRANSPLANTJSON","params":{"ARTCycleID":"1"}}
 * @param onSuccess 成功后回调函数
 * @param onError 失败后回调函数
 * @param isAsync 异步true，同步false
 */
function ajaxPOSTCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "POST",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        contentType: "text/plain",
        processData: false,
        data: JSON.stringify(data),
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }
            }else{
                $.messager.alert("失败", "ajaxPOSTCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxPOSTCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

function ajaxGETCommon(data, onSuccess, onError, isAsync) {
    isAsync = isAsync || false;
    if ("undefined" != typeof data.params){
        data.params.langID = langID;
    }else{
        data.params = {
            langID: langID
        };
    }
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "../EMR.DOC.SRV.RequestCommon.cls?MWToken="+getMWToken(),
        async: isAsync,
        cache: false,
        data: {"paramdata":JSON.stringify(data)},
        success: function (ret) {
            if("true" === ret.success){
                if (!onSuccess) {}
                else {
                    if (ret.errorCode){
                        $.messager.alert("数据请求失败提示", ret.errorMessage, "info");
                        onSuccess("");
                    }else{
                        onSuccess(ret.data);
                    }
                }
            }else{
                $.messager.alert("失败", "ajaxGETCommon:请求失败", "error");
            }
        },
        error: function (ret) {
            if (!onError) {
                $.messager.alert("发生请求错误", "ajaxGETCommon error:"+JSON.stringify(ret), "error");
            }else {
                onError(ret);
            }
        }
    });
}

// 有实际含义的变量才执行方法，变量null，undefined和""空串都为false
// 初始promise 或 promise.then返回的
function isPromise(obj) {
  return !!obj && (typeof obj === "object" || typeof obj === "function") && typeof obj.then === "function";
}

//是否存在指定函数
function isExistFunc(funcName) {
    try {
        if (typeof(eval(funcName)) == "function") {
            return true;
        }
    } catch (e) {}
    return false;
}
//是否存在指定变量
function isExistVar(variableName) {
    try {
        if (typeof(variableName) == "undefined") {
            return false;
        } else {
            return true;
        }
    } catch (e) {
        return false;
    }
    return false;
}

// 提示消息
function showEditorMsg(obj) {
    if (isExistVar(obj.msg)) {
        var msgTimeOut = 3000;
        if (isExistVar(sysOption.infoMessage[obj.type])) {
            if (sysOption.infoMessage[obj.type] != "") {
                msgTimeOut = sysOption.infoMessage[obj.type];
            }
        }
        var msgStyle = {};
        if (isExistVar(sysOption.infoMessage.style)) {
            if (sysOption.infoMessage.style != "") {
                msgStyle = sysOption.infoMessage.style;
                if (isExistVar(sysOption.infoMessage.style.left)) {
                    if (sysOption.infoMessage.style.left == "center") {
                        msgStyle.left = document.documentElement.clientWidth/2; // 居中显示
                    }
                }
            }
        }
        $.messager.popover({
            msg: obj.msg,
            type: obj.type,
            timeout: msgTimeOut,
            style: msgStyle
        });
    }
}

//国际化改造获取翻译
function emrTrans(value)
{
    if (typeof $g == "function") 
    {
        value = $g(value)
    }
    return value;
}

//封装基础平台websys_getMWToken()方法
function getMWToken()
{
    try{
        if (typeof(websys_getMWToken) != "undefined")
            return websys_getMWToken();
        return "";
    }catch(e) {
        return "";
    }
}

function replaceLinkParams(lnk) {
    var ret = lnk.replace(/@patientID/g, patInfo.patientID);
    ret = ret.replace(/@episodeID/g, patInfo.episodeID);
    ret = ret.replace(/@mradm/g, patInfo.mradm);
    ret = ret.replace(/@admType/g, patInfo.admType);
    ret = ret.replace(/@ssgroupID/g, patInfo.ssgroupID);
    ret = ret.replace(/@userID/g, patInfo.userID);
    ret = ret.replace(/@userCode/g, patInfo.userCode);
    ret = ret.replace(/@userName/g, patInfo.userName);
    ret = ret.replace(/@userLocID/g, patInfo.userLocID);
    ret = ret.replace(/@hospitalID/g, patInfo.hospitalID);
    ret = ret.replace(/@product/g, envVar.product);
    if (ret.indexOf('?') != -1) {
        ret = ret + '&MWToken='+getMWToken(); 
    } else {
        ret = ret + '?MWToken='+getMWToken();
    }
    return ret;
}

/// 创建HISUI-Dialog弹窗
function createModalDialog(dialogId, dialogTitle, width, height, iframeId, iframeContent,callback){
    $("body").append("<div id='"+dialogId+"'</div>");
    if (isNaN(width)) width = 800;
    if (isNaN(height)) height = 500;
    $HUI.dialog('#'+dialogId,{
        title: emrTrans(dialogTitle),
        width: width,
        height: height,
        cache: false,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        isTopZindex: true,
        content: iframeContent,
        onBeforeClose:function(){
            var tempFrame = $("#"+iframeId)[0].contentWindow;
            if (tempFrame && isExistVar(tempFrame.returnValue)){
                returnValue = tempFrame.returnValue;
                if (isExistFunc(callback)){
                    callback(returnValue);
                }
            }
        },
        onClose:function(){
            $("#"+dialogId).dialog("destroy");
        }
    });
}

//关闭dialog,子页面调用
function closeDialog(dialogId)
{
    $HUI.dialog("#"+dialogId).close();
}

function judgeIsIE() { //ie?
    if (!!window.ActiveXObject || "ActiveXObject" in window)
        return true;
    else
        return false;
}

// 锁定页面右键
document.oncontextmenu = function(e){
    return false;
}

var common = {
    setUserConfig: function (configType,configData){
        var data = {
            action: "SET_USER_CONFIG",
            params:{
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                configType: configType,
                configData: configData
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (!ret){
                console.log("保存用户配置数据失败！");
            }
        }, function (error) {
            $.messager.alert("发生错误", "setUserConfig error:"+error, "error");
        }, true);
    },
    getUserConfig: function (configType){
        var rtn = "";
        var data = {
            action: "GET_USER_CONFIG",
            params:{
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                configType: configType
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                rtn = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getUserConfig error:"+error, "error");
        }, false);
        return rtn;
    },
    getSavedRecords: function (){
        var data = {
            action: "GET_SAVEDRECORDS",
            params:{
                episodeID: patInfo.episodeID,
                userLocID: patInfo.userLocID,
                ssgroupID: patInfo.ssgroupID,
                docCategoryCode: envVar.docCategoryCode
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            envVar.savedRecords = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getSavedRecords error:"+error, "error");
        }, false);
    },
    getFirstTmpl: function (){
        var data = {
            action: "GET_DEFAULTTEMPLATE",
            params:{
                episodeID: patInfo.episodeID,
                userLocID: patInfo.userLocID,
                ssgroupID: patInfo.ssgroupID,
                userID: patInfo.userID,
                docCode: envVar.docCode,
                docCategoryCode: envVar.docCategoryCode
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                envVar.firstTmpl = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getFirstTmpl error:"+error, "error");
        }, false);
    },
    getSavedRecordBydocumentID: function(documentID){
        var rtn = "";
        var data = {
            action: "GET_SAVEDRECORDBYDOCUMENTID",
            params:{
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getSavedRecordBydocumentID error:"+error, "error");
        }, false);
        return rtn;
    },
    getRecordBydocumentID: function(documentID){
        var rtn = "";
        var data = {
            action: "GET_RECORDBYDOCUMENTID",
            params:{
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getRecordBydocumentID error:"+error, "error");
        }, false);
        return rtn;
    },
    getRecordCreatorInfo: function(documentID){
        var rtn = "";
        var data = {
            action: "GET_RECORDCREATORINFO",
            params:{
                documentID: documentID,
                userID: patInfo.userID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getRecordCreatorInfo error:"+error, "error");
        }, false);
        return rtn;
    },
    verifyUser: function(creatorCode, password){
        var rtn = "";
        var data = {
            action: "VERIFY_USER",
            params:{
                creatorCode: creatorCode,
                password: password,
                hospitalID: patInfo.hospitalID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "verifyUser error:"+error, "error");
        }, false);
        return rtn;
    },
    getLinkConfig: function (url){
        var rtn = "";
        var data = {
            action: "GET_LINK",
            params:{
                url: url
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                rtn = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getLinkConfig error:"+error, "error");
        }, false);
        return rtn;
    },
    getLinkData: function (data){
        var rtn = "";
        ajaxGETCommon(data, function(ret){
            if (ret){
                rtn = JSON.stringify(ret);
            }
        }, function (error) {
            $.messager.alert("发生错误", "getLinkData error:"+error, "error");
        }, false);
        return rtn;
    },
    isCanCreate: function (data){
        var rtn = "";
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "isCanCreate error:"+error, "error");
        }, false);
        return rtn;
    },
    getTemplateDataByDocumentID: function (documentID){
        var rtn = "";
        var data = {
            action: "GET_TEMPLATEDATABYDOCUMENTID",
            params:{
                documentIDs: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getTemplateDataByDocumentID error:"+error, "error");
        }, false);
        return rtn;
    },
    isSuperiorSign: function (userLevel,documentID){
        var rtn = "";
        var data = {
            action: "IS_SUPERIORSIGN",
            params:{
                userLevel: userLevel,
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "isSuperiorSign error:"+error, "error");
        }, false);
        return rtn;
    },
    getAdmByDocumentID: function (documentID){
        var rtn = "";
        var data = {
            action: "GET_ADMBYDOCUMENTID",
            params:{
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getAdmByDocumentID error:"+error, "error");
        }, false);
        return rtn;
    },
    getUserInfo: function(){
        var rtn = "";
        var data = {
            action: "GET_USERINFO",
            params:{
                userCode: patInfo.userCode,
                userLocID: patInfo.userLocID,
                episodeID: patInfo.episodeID,
                hospitalID: patInfo.hospitalID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getUserInfo error:"+error, "error");
        }, false);
        return rtn;
    },
    GetCAUserInfo: function(userID, userCode, userCertCode, certNo) {
        var loginInfo = "";
        if ("" === userCode){
            return "";
        }
        var data = {
            action: "GET_CAUSERINFO",
            params:{
                userID: userID,
                userCode: userCode,
                userCertCode: userCertCode,
                certNo: certNo,
                episodeID: patInfo.episodeID,
                hospitalID: patInfo.hospitalID,
                userLocID: patInfo.userLocID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                loginInfo = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "GetCAUserInfo error:"+error, "error");
        }, false);
        return loginInfo;
    },
    getPatientSignInfo: function(oriSignLevel) {
        var patientSignInfo = "";
        var data = {
            action: "GET_PATIENTSIGNINFO",
            params:{
                oriSignatureLevel: oriSignLevel
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                patientSignInfo = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getPatientSignInfo error:"+error, "error");
        }, false);
        return patientSignInfo;
    },
    getRecordInfo: function(documentID) {
        var recordInfo = "";
        if ("" === documentID){
            return "";
        }
        var data = {
            action: "GET_RECORDINFO",
            params:{
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                recordInfo = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getRecordInfo error:"+error, "error");
        }, false);
        return recordInfo;
    },
    getSignDocCharacter: function(documentID){
        var rtn = "";
        var data = {
            action: "GET_SIGN_DOCCHARACTER",
            params:{
                documentID: documentID,
                userCode: patInfo.userCode,
                userLocID: patInfo.userLocID,
                episodeID: patInfo.episodeID,
                hospitalID: patInfo.hospitalID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                rtn = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getSignDocCharacter error:"+error, "error");
        }, false);
        return rtn;
    },
    getHandSignType: function(params){
        var rtn = "";
        var data = {
            action: "GET_HANDSIGN_TYPE",
            params: params,
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getHandSignType error:"+error, "error");
        }, false);
        return rtn;
    },
    canDoPDFSign: function(documentID){
        var rtn = "";
        var data = {
            action: "CAN_DOPDF_SIGN",
            params: {
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                rtn = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "canDoPDFSign error:"+error, "error");
        }, false);
        return rtn;
    },
    getSignedPDF: function(params){
        var rtn = "";
        var data = {
            action: "GET_PDF_BASE64",
            params: params,
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret){
                rtn = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "getSignedPDF error:"+error, "error");
        }, false);
        return rtn;
    },
    getAnySignLocation: function(){
        var rtn = "";
        var data = {
            action: "GET_ANYSIGN_LOCATION",
            params: {},
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getAnySignLocation error:"+error, "error");
        }, false);
        return rtn;
    },
    getPatPushSignQR: function(documentID, func){
        var data = {
            action: "GET_PATPUSHSIGNID",
            params: {
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            func(ret);
        }, function (error) {
            $.messager.alert("发生错误", "getPatPushSignQR error:"+error, "error");
        }, false);
    },
    fetchPatPushSignResult: function(documentID, docParam){
        var data = {
            action: "FETCH_SIGNRESULT",
            params: {
                documentID: documentID,
                userID: patInfo.userID
            },
            product: envVar.product
        };
        ajaxPOSTCommon(data, function(ret){
            if (ret.split("^")[0] == "1") {
                if (emrService.pluginType != docParam.pluginType){
                    emrService.loadDoc(docParam);
                    emrTemplate.updateTabRecordByDocParam(docParam);
                    showEditorMsg({msg:ret.split("^")[1],type:"success"});
                }
            }else if(ret.split("^")[0] === "0"){
                var loadFlag = false;
                if (emrService.pluginType != docParam.pluginType){
                    loadFlag = emrService.loadDoc(docParam);
                    emrTemplate.updateTabRecordByDocParam(docParam);
                }
                if (!loadFlag){
                    showEditorMsg({msg:ret.split("^")[1],type:"alert"});
                }
            }else{
                alert(ret);
            }
        }, function (error) {
            $.messager.alert("发生错误", "fetchPatPushSignResult error:"+error, "error");
        }, false);
    },
    invalidPatSignedPDF: function(documentID, docParam){
        var data = {
            action: "INVALID_SIGNEDPDF",
            params: {
                documentID: documentID,
                userID: patInfo.userID,
                ipAddress: patInfo.ipAddress
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret.split("^")[0] == "1") {
                if (emrService.pluginType != docParam.pluginType){
                    emrService.loadDoc(docParam);
                    emrTemplate.updateTabRecordByDocParam(docParam);
                    showEditorMsg({msg:ret.split("^")[1],type:"success"});
                }
            }else if(ret.split("^")[0] === "0"){
                var loadFlag = false;
                if (emrService.pluginType != docParam.pluginType){
                    loadFlag = emrService.loadDoc(docParam);
                    emrTemplate.updateTabRecordByDocParam(docParam);
                }
                if (!loadFlag){
                    showEditorMsg({msg:ret.split("^")[1],type:"alert"});
                }
            }else{
                alert(ret);
            }
        }, function (error) {
            $.messager.alert("发生错误", "invalidPatSignedPDF error:"+error, "error");
        }, false);
    },
    patSignPDF: function (fun){
        var documentID = emrService.getCurrentDocumentID();
        if (documentID){
            var docParam = common.getSavedRecordBydocumentID(documentID);
            if (!docParam){
                showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                return;
            }
            fun(documentID, docParam);
        }
    },
    verifySignedData: function(documentID){
        var data = {
            action: "VERIFY_SIGNED_DATA",
            params: {
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                var flag = ret.split("^")[0];
                var result = ret.split("^")[1];
                if (flag == "1"){
                    $.messager.alert("提示信息", result, "info");
                }else{
                    $.messager.alert("提示信息",result, "error");
                }
            }
        }, function (error) {
            $.messager.alert("发生错误", "verifySignedData error:"+error, "error");
        }, false);
    },
    getEMRVersionID: function(){
        var data = {
            action: "GET_VERSIONID",
            params: {
                episodeID: patInfo.episodeID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            envVar.versionID = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getEMRVersionID error:"+error, "error");
        }, false);
    },
    isHasAction: function(hasAction, documentID){
        var result = "0";
        var data = {
            action: "GET_DOCHASACTION",
            params: {
                action: hasAction,
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            result = ret;
        }, function (error) {
            $.messager.alert("发生错误", "isHasAction error:"+error, "error");
        }, false);
        return result;
    },
    hasLocked: function(documentID){
        var result = false;
        if (sysOption.isLock != "Y"){
            return result;
        }
        var data = {
            action: "HAS_LOCKED",
            params: {
                documentID: documentID,
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                ipAddress: patInfo.ipAddress,
                sessionID: patInfo.sessionID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                if (ret.hasLocked == "true"){
                    envVar.lockedDocumentID = ret.documentID;
                    emrService.setReadonly(documentID,true);
                    setPnlBtnDisable(true,["btnTemplateclassify","btnLogFlagInfo"]);
                    result = true;
                }else{
                    envVar.lockedDocumentID = "";
                    envVar.lockedID = "";
                }
                emrService.setLockMessage(ret.lockMessage);
            }
        }, function (error) {
            $.messager.alert("发生错误", "hasLocked error:"+error, "error");
        }, false);
        return result;
    },
    isRefreshDocument: function(documentID, pOperateDateTime){
        var result = false;
        var data = {
            action: "ISREFRESH_DOCUMENT",
            params: {
                documentID: documentID,
                pOperateDateTime: pOperateDateTime
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                result = ret;
            }
        }, function (error) {
            $.messager.alert("发生错误", "isRefreshDocument error:"+error, "error");
        }, false);
        return result;
    },
    unLock: function(lockedDocumentID){
        var result = false;
        if (lockedDocumentID){
            var data = {
                action: "UN_LOCK",
                params: {
                    documentID: lockedDocumentID,
                    sessionID: patInfo.sessionID
                },
                product: envVar.product
            };
            ajaxGETCommon(data, function(ret){
                if (ret == "1"){
                    emrService.setLockMessage("");
                    envVar.lockedDocumentID = "";
                    envVar.lockedID = "";
                }else{
                    result = true;
                    $.messager.alert("简单提示", "解锁失败！", "error");
                }
            }, function (error) {
                $.messager.alert("发生错误", "unLock error:"+error, "error");
            }, false);
        }
        return result;
    },
    lock: function(documentID){
        var result = false;
        if (sysOption.isLock != "Y"){
            return result;
        }
        var data = {
            action: "DOC_LOCK",
            params: {
                documentID: documentID,
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                ipAddress: patInfo.ipAddress,
                sessionID: patInfo.sessionID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                envVar.lockedID = ret;
                envVar.lockedDocumentID = documentID;
            }else{
                result = true;
                $.messager.alert("简单提示", "加锁失败！", "error");
            }
        }, function (error) {
            $.messager.alert("发生错误", "lock error:"+error, "error");
        }, false);
        return result;
    }
};