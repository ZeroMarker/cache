var audit;

$(function() {
    audit = new Audit();
});


function Audit() {
    // CA签名入口
    this.caSign = function(documentID, signProperty) {
        //开始执行
        var doSign = function(loginInfo,rtn) {
            //签名权限检查
            var checkresult = privilege.getCheckPrivilege(loginInfo, signProperty, "caSign");
            if (!checkresult) {
                return;
            }

            try {
                loginInfo.code = signProperty.code;
                var callBack = {
                    response: function(ret){
                        // 签名原文做哈希
                        var contentHash = HashData(ret.value);
                        // 获取病历信息传给CA展示
                        var recordInfo = common.getRecordInfo(documentID);
                        if (recordInfo != ""){
                            recordInfo = JSON.stringify(recordInfo);
                        }
                        // CA接口
                        var signValue = rtn.ca_key.SignedData(contentHash, rtn.ContainerName, patInfo.episodeID, recordInfo) || '';
                        if ("" === signValue){
                            $.messager.alert("发生错误", "签名数据为空！", "error");
                            return;
                        }
                        var signlevel = loginInfo.signLevel;
                        
                        if (('' === signlevel) && (signProperty.oriSignLevel !== "All")) {
                            showEditorMsg({msg:"请先维护用户级别！",type:"alert"});
                            return;
                        }
                        var saveResult = emrService.saveSignDocument({
                            id: loginInfo.id,
                            elementCode: ret.elementCode,
                            code: ret.code,
                            invalidCode: ret.invalidCode,
                            levelName: loginInfo.levelName,
                            roleLevel: loginInfo.roleLevel,
                            signLevel: signlevel,
                            hashData: contentHash,
                            signValue: signValue,
                            userCertCode: rtn.CAUserCertCode || "",
                            certNo: rtn.CACertNo || "",
                            documentID: documentID,
                            time: ret.time,
                            type: "CA"
                        },ret.value);
                        if ("fail" != saveResult.result){
                            showEditorMsg({msg:'数据签名成功!',type:'success'});
                            hisLog.operate("EMR.OP.Sign.OK",signProperty.documentID);
                            privilege.setRevsion(signProperty.documentID);
                            /*privilege.setViewRevise(signProperty.documentID, function() {
                                var txt = $('#btnRevisionVisible').find("span").eq(1).text();
                                return txt === emrTrans('隐藏痕迹');
                            });*/
                        }else{
                            $.messager.alert("发生错误", "签名数据保存失败！", "error");
                        }
                    },
                    reject: function(error){
                        $.messager.alert("发生错误", "签名失败！", "error");
                    }
                };
                emrService.signDocument(loginInfo, callBack);
            } catch (error) {
                $.messager.alert("发生错误", error.message || error, "error");
            }
        }
       
        function signCallback(rtn) {
            if (!rtn.IsSucc) {
                //alert("证书未登录,请重新登录证书!");
                showEditorMsg({msg:'证书未登录,请重新登录证书!',type:'info'});
                return;
            }
            
            if (rtn.ContainerName != "") { 
                //该科室需签名
                var loginInfo = common.GetCAUserInfo(rtn.UserID,rtn.UserName,rtn.CAUserCertCode,rtn.CACertNo);
                if (loginInfo != "") {
                    doSign(loginInfo,rtn);
                }
            }else{
                showEditorMsg({msg:'获取证书ContainerName失败', type:'info'});
            }
        }
        
        showEditorMsg({msg:'签名中，请耐心等待...', type:'info'});
        if (judgeIsIE()){
            var rtn = dhcsys_getcacert({modelCode:"OPEMR", isHeaderMenuOpen:true, SignUserCode:patInfo.userCode},undefined,undefined,undefined);
            signCallback(rtn);
        }else{
            dhcsys_getcacert({modelCode:"OPEMR", callback:signCallback, isHeaderMenuOpen:true, SignUserCode:patInfo.userCode},undefined,undefined,undefined);
        }
    }
    //this.caSign结束

    // 系统签名入口
    this.sysSign = function(returnValue){
        var signProperty = modalDialogArgs;
        var documentID = signProperty.documentID;
        modalDialogArgs = "";
        if (returnValue && isExistVar(signProperty)){
            var userInfo = returnValue.userInfo;
            if (userInfo.signLevel == ""){
                showEditorMsg({msg:"请先维护用户级别！",type:"alert"});
                return;
            }
            if (returnValue.action == "sign"){
                var checkResult = privilege.getCheckPrivilege(userInfo, signProperty, "checkSign");
                if (checkResult){
                    userInfo.code = signProperty.code;
                    var callBack = {
                        response: function(ret){
                            var saveResult = emrService.saveSignDocument({
                                id: userInfo.id,
                                elementCode: ret.elementCode,
                                code: ret.code,
                                invalidCode: ret.invalidCode,
                                levelName: userInfo.levelName,
                                roleLevel: userInfo.roleLevel,
                                signLevel: userInfo.signLevel,
                                documentID: documentID,
                                time: ret.time,
                                type: "SYS"
                            },ret.value);
                            if ("fail" != saveResult.result){
                                showEditorMsg({msg:'数据签名成功!',type:'success'});
                                hisLog.operate("EMR.OP.Sign.OK",documentID);
                                privilege.setRevsion(documentID);
                                /*privilege.setViewRevise(documentID, function() {
                                    var txt = $('#btnRevisionVisible').find("span").eq(1).text();
                                    return txt === emrTrans('隐藏痕迹');
                                });*/
                            }else{
                                $.messager.alert("发生错误", "签名数据保存失败！", "error");
                            }
                        },
                        reject: function(error){
                            console.log("reject:",error);
                            $.messager.alert("发生错误", "签名失败！", "error");
                        }
                    };
                    emrService.signDocument(userInfo, callBack);
                }
            }else if (returnValue.action == "revoke"){
                if (userInfo.id != signProperty.id){
                    showEditorMsg({msg:"非本人签名,不能撤销！",type:"forbid"});
                    return;
                }
                var ret = emrService.revokeSign(userInfo,signProperty);
                if ("fail" != ret.result){
                    showEditorMsg({msg:"撤销成功！",type:"alert"});
                }else{
                    showEditorMsg({msg:"撤销失败！",type:"error"});
                }
            }
        }
    }

}