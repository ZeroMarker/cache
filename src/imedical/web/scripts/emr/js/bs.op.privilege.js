var privilege = {
    /// 病历操作权限：保存、删除、签名等
    getPrivilege: function(documentID){
        var command = EmrEditor.syncExecute({
            action: "GET_PRIVILEGE",
            params:{
                documentID: documentID
            },
            product: envVar.product
        });
        if ("fail" === command.result){
            showEditorMsg({msg:"权限脚本为空，请检查！",type:"info"});
            return false;
        }else{
            return command.params.privelege;
        }
    },
    /// 病历加载权限view
    getLoadPrivilege: function(documentID){
        var rtn = "";
        var data = {
            action: "LOAD_PRIVILEGE",
            params:{
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                ssgroupID: patInfo.ssgroupID,
                episodeID: patInfo.episodeID,
                patientID: patInfo.patientID,
                documentID: documentID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getLoadPrivilege error:"+error, "error");
        }, false);
        return rtn;
    },
    /// 模板创建权限new
    getCreatePrivilege: function(docParam){
        var rtn = "";
        var data = {
            action: "CREATE_PRIVILEGE",
            params:{
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                ssgroupID: patInfo.ssgroupID,
                episodeID: patInfo.episodeID,
                patientID: patInfo.patientID,
                documentID: docParam.documentID,
                templateID: docParam.templateID,
                docName: docParam.docName,
                docCode: docParam.docCode
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            rtn = ret;
        }, function (error) {
            $.messager.alert("发生错误", "getCreatePrivilege error:"+error, "error");
        }, false);
        return rtn;
    },
    /// 检查签名权限脚本
    getCheckPrivilege: function(userInfo, signProperty, checkType){
        var result = false;
        var userID = userInfo.id;
        var signLevel = userInfo.signLevel;
        var signUserID = signProperty.id;
        var signedLength = signProperty.authenticator.length;
        var allSignLevel = [];
        if (signedLength > 0){
            $.each(signProperty.authenticator, function(index, item) {
                if (isExistVar(item.signLevel) && ("" != item.signLevel)){
                    allSignLevel.push({signUserID:item.id,signLevel:item.signLevel});
                }
            });
        }
        var data = {
            action: "CHECK_PRIVILEGE",
            params:{
                userID: userID,
                signLevel: signLevel,
                signUserID: signUserID,
                signedLength: signedLength,
                allSignLevel: allSignLevel,
                oriSignatureLevel: signProperty.oriSignLevel,
                documentID: signProperty.documentID,
                elementCode: signProperty.sourceCode,
                logonUserID: patInfo.userID
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret){
                result = true;
            }else{
                //showEditorMsg({msg:"无权限签名",type:"alert"});
            }
        }, function (error) {
            $.messager.alert("发生错误", "getCheckPrivilege error:"+error, "error");
        }, false);
        
        //是否需要撤销签名
        if ((sysOption.isAllRevokeSign.split("^")[0] == "Y")&&(sysOption.isAllRevokeSign.split("^")[1] == "Y")&&(checkType != "checkSign")&&(userID == signUserID)){
            $.messager.confirm("操作提示", "是否需要撤销本人签名？", function (data){
                if (data){
                    var ret = emrService.revokeSign(userInfo,signProperty);
                    if ("fail" != ret.result){
                        showEditorMsg({msg:"撤销成功！",type:"alert"});
                    }else{
                        showEditorMsg({msg:"撤销失败！",type:"error"});
                    }
                }
            });
        }
        return result;
    },
    // 痕迹 完成签名事件，加载文档完成
    setRevsion: function(documentID){
        var checkresult = privilege.getPrivilege(documentID);
        if (checkresult){
            if ("-1" == checkresult.canRevise){
                var docStatus = emrService.getCurrentDocStatus(documentID);
                if (docStatus && (1 == docStatus.hasSigned)){
                    EmrEditor.syncExecute({action:"SET_PARAMETERS",params:{reviseOpen:"1"},product: envVar.product});
                }else{
                    EmrEditor.syncExecute({action:"SET_PARAMETERS",params:{reviseOpen:"0"},product: envVar.product});
                }
            }else{
                EmrEditor.syncExecute({action:"SET_PARAMETERS",params:{reviseOpen:checkresult.canRevise},product: envVar.product});
            }
        }
    },
    setViewRevise: function(documentID, fnBtnRevisionVisible){
        var checkresult = privilege.getPrivilege(documentID);
        if (checkresult){
            var canViewRevise = checkresult.canViewRevise;
            if ("1" == canViewRevise){
                if (isExistFunc(fnBtnRevisionVisible)){
                    if (!fnBtnRevisionVisible()){
                        canViewRevise = "0";
                    }
                }else{
                    canViewRevise = "0";
                }
            }
            var reviseValue = EmrEditor.syncExecute({action:"GET_PARAMETERS",params:{value:"revise"},product: envVar.product});
            if ("fail" === reviseValue.result){
                showEditorMsg({msg:"获取病历编辑器留痕显示参数失败，请检查！",type:"error"});
                return;
            }
            
            reviseValue.params.del.show = canViewRevise;
            reviseValue.params.add.show = canViewRevise;
            reviseValue.params.style.show = canViewRevise;
            EmrEditor.syncExecute({action:"SET_PARAMETERS",params:{revise: reviseValue.params},product: envVar.product});
        }
    }
};