var emrService = {
    createAsLoad: false,
    sectionArgs: "", //记录当前选中的章节数据
    refreshKBFunc: null, //刷新知识库委托,
    pluginType: "", //记录当前病历编辑器类型
    initEmrEditor: function (args){
        EmrEditor.initEditor({
            rootID: "#bsEditor",
            product: envVar.product,
            patInfo: patInfo,
            parameters:{
                scale: sysOption.scale/100,
                status: "write",
                region: "content"
            },
            pluginType: emrService.pluginType,
            MWToken: getMWToken(),
            editorEvent: editorEvent,
            commandJson: args || ""
        });
    },
    loadDoc: function (docParam,isAsync){
        isAsync = isAsync || true;
        var rtn = privilege.getLoadPrivilege(docParam.documentID);
        if (!rtn){
            showEditorMsg({msg:"未获取到当前用户查看病历的权限！",type:"alert"});
            return false;
        }
        if ("1" != rtn.canView){
            showEditorMsg({msg:"权限控制：" + rtn.cantViewReason + ",您没有权限查看此病历！",type:"alert"});
            return false;
        }
        var args = {
            action: "LOAD_DOCUMENT",
            params: {
                documentID: docParam.documentID,
                pluginType: docParam.pluginType
            },
            type: {
                serial: docParam.serial,
                leadframe: docParam.isLeadframe
            },
            product: envVar.product
        };
        var switchPluginType = false;
        if (emrService.pluginType != docParam.pluginType){
            switchPluginType = true;
        }
        if (!document.getElementById("bsEditor").innerHTML || switchPluginType){
            emrService.pluginType = docParam.pluginType;
            emrService.initEmrEditor(args);
        }else{
            if (isAsync){
                EmrEditor.execute(args);
            }else{
                var commandJson = EmrEditor.syncExecute(args);
                editorEvent.eventloaddocument(commandJson);
            }
        }
        return true;
    },
    createDoc: function (docParam,isAsync){
        isAsync = isAsync || true;
        var rtn = privilege.getCreatePrivilege(docParam);
        if (!rtn){
            showEditorMsg({msg:"未获取到当前用户创建模板的权限！",type:"alert"});
            return;
        }
        if ("1" != rtn.canNew){
            showEditorMsg({msg:"权限控制：" + rtn.cantNewReason + ",您没有权限创建此模板！",type:"alert"});
            return;
        }
        var actionType = "";
        if (isExistVar(docParam.actionType)){
            actionType = docParam.actionType
        }
        var args = {
            action: "CREATE_DOCUMENT",
            params: {
                docName: docParam.docName,
                docCode: docParam.docCode,
                templateID: docParam.templateID,
                sourceID: docParam.sourceID,
                sourceType: docParam.sourceType,
                eventID: docParam.eventID,
                eventType: docParam.eventType,
                actionType: actionType
            },
            type: {
                serial: docParam.serial,
                leadframe: docParam.isLeadframe
            },
            product: envVar.product
        };
        var switchPluginType = false;
        if (emrService.pluginType != docParam.pluginType){
            switchPluginType = true;
        }
        if (!document.getElementById("bsEditor").innerHTML || switchPluginType){
            emrService.pluginType = docParam.pluginType;
            emrService.initEmrEditor(args);
        }else{
            if (isAsync){
                EmrEditor.execute(args);
            }else{
                var commandJson = EmrEditor.syncExecute(args);
                editorEvent.eventcreatedocument(commandJson);
            }
        }
    },
    // 关闭字典弹窗
    closeDictionary: function(){
        EmrEditor.syncExecute({action: "CLOSE_DICTIONARY", product: envVar.product});
    },
    cleanDoc: function(){
        document.getElementById("container").innerHTML = "<div id=\"bsEditor\" style=\"overflow:hidden;width:100%;height:100%;\"></div>";
        emrService.pluginType = "";
    },
    initDocument: function(){
        emrTemplate.closeAllTabs();
        if (envVar.versionID && (envVar.versionID != '4')){
            setPnlBtnDisable(true);
            setPnlBtnEditHide(true);
            setSysMenuDoingSth("");
            $.messager.alert("提示", "该患者已经书写"+envVar.versionID+"版病历，不能再书写4版病历", "info");
            return;
        }
        if (envVar.savedRecords.length > 0){
            var docParam = envVar.savedRecords[0];
            if (null == docParam){
                showEditorMsg({msg:"请检查病历数据！",type:"info"});
                return;
            }
            var rtn = emrService.loadDoc(docParam);
            if (rtn){
                emrTemplate.loadTmplTabs(envVar.savedRecords, docParam);
            }
        }else{
            if (null == envVar.firstTmpl){
                if ("" != patInfo.episodeID){
                    showEditorMsg({msg:"未找到默认病历模板！",type:"info"});
                    setPnlBtnDisable(true);
                    setPnlBtnEditHide(true);
                    setSysMenuDoingSth("");
                    return;
                }
            }else{
                emrService.createDoc(envVar.firstTmpl);
            }
        }
    },
    setReadonly: function(documentID,flag){
        var commandJson = EmrEditor.syncExecute({action:"SET_READONLY",params:{documentID:documentID,readOnly:flag},product: envVar.product});
        if (flag && (commandJson.result != "fail")){
            //只读后清除标记，不需要提示是否保存
            setSysMenuDoingSth("");
            setDoingSthSureCallback(false);
        }
    },
    getReadonly: function(documentID){
        var commandJson = EmrEditor.syncExecute({action:"GET_READONLY",params:{documentID:documentID},product: envVar.product});
        return commandJson.params.readOnly; // true:"只读"
    },
    reloadBindData: function(documentID,autoRefresh){
        EmrEditor.execute({
            action: "REFRESH_REFERENCEDATA",
            params: {
                documentID: documentID,
                autoRefresh: autoRefresh,
                syncDialogVisible: true,
                silentRefresh: false,
                displayNullValueItem: false
            },
            product: envVar.product
        });
    },
    saveDocCheck: function(docParams){
        var result = false;
        if (quality.requiredObject()){
            $.each(docParams, function(index, item) {
                if (sysOption.returnTemplateIDs.indexOf("^" + item.templateID + "^") != "-1"){
                    result = true;
                    return false;
                }
            });
        }
        return result;
    },
    saveDoc: function(documentIDs,isAsync){
        if (!isConsistent()){
            return;
        }
        isAsync = isAsync || true;
        var docParams = common.getTemplateDataByDocumentID(documentIDs);
        if (!docParams){
            showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
            return;
        }
        if (emrService.saveDocCheck(docParams)){
            return;
        }
        // 失效签名
        if ("Y" == sysOption.isRevokeSign){
            emrService.doRevokeSignedDocument(docParams);
        }else{
            setSysMenuDoingSth("病历保存中...");
            if (isAsync){
                EmrEditor.execute({action:"SAVE_DOCUMENT",product: envVar.product});
            }else{
                var commandJson = EmrEditor.syncExecute({action:"SAVE_DOCUMENT",product: envVar.product});
                editorEvent.eventsavedocument(commandJson);
            }
        }
    },
    saveConfirm: function(flag,documentIDs,args,callBack,isAsync){
        isAsync = isAsync || true;
        var message = "";
        // flag是否弹保存提示窗
        // instanceIDs 指定：["1||1","1||2",...]或者未指定：[]
        var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:documentIDs},product: envVar.product});
        if ("fail" === command.result){
            showEditorMsg({msg:"获取待保存病历集合失败！具体原因请查看F12输出",type:"error"});
            console.log(command);
        }else{
            if (command.params){
                var docIDFlag = false;
                if (0 == documentIDs.length){
                    docIDFlag = true;
                }
                for (var i=0;i<command.params.length;i++){
                    var rtn = privilege.getPrivilege(command.params[i].id);
                    if ("1" != rtn.canSave){
                        showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                        message = "";
                        return false;
                    }
                    if (message){
                        message = message + "、";
                    }
                    message = message + command.params[i].name.value;
                    if (docIDFlag){
                        documentIDs.push(command.params[i].id);
                    }
                }
                message = emrTrans("病历【"+message+"】的内容有修改,是否保存？");
            }else{
                //切换连续显示文档时，当前文档没有发生改变,且为连续文档的创建状态
                if (args && args.action && ("eventDocumentChanged" === args.action)){
                    var documentID = emrService.getCurrentDocumentID();
                    var docStatus = emrService.getCurrentDocStatus(documentID);
                    if (docStatus && (docStatus.curStatus === "created") && (docStatus.serial == '1')){
                        message = emrTrans("病历【"+docStatus.name+"】还未保存,请先保存,否则病历会丢失,是否保存？");
                        documentIDs = [documentID];
                        //documentIDs.push(documentID);
                    }
                }
            }
        }
        if (message){
            if (flag){
                var oldOk = $.messager.defaults.ok;
                var oldCancel = $.messager.defaults.cancel;
                $.messager.defaults.ok = emrTrans("保存");
                $.messager.defaults.cancel = emrTrans("不存");
                $.messager.confirm("保存操作提示", message, function (r) {
                    if (r){
                        if (isExistFunc(callBack)){
                            editorEvent.callbackAfterEvt = {fun:callBack, args:args};
                        }
                        emrService.saveDoc(documentIDs,isAsync);
                    } else {
                        if (args && args.action && ("eventDocumentChanged" === args.action)){
                            emrService.removeDocument(documentIDs[0]);
                        }else{
                            emrService.restoreArticle(documentIDs[0]);
                        }
                        if (envVar.lockedID){
                            common.unLock(envVar.lockedDocumentID);
                        }
                        if (isExistFunc(callBack)){
                            callBack(args);
                        }
                    }
                    $.messager.defaults.ok = oldOk;
                    $.messager.defaults.cancel = oldCancel;
                });
            }else{
                if (isExistFunc(callBack)){
                    editorEvent.callbackAfterEvt = {fun:callBack, args:args};
                }
                emrService.saveDoc(documentIDs,isAsync);
            }
        }else{
            if (isExistFunc(callBack)){
                callBack(args);
            }
        }
    },
    saveConfirm3: function(flag,documentIDs,args,callBack){
        var message = "";
        // flag是否弹保存提示窗
        // instanceIDs 指定：["1||1","1||2",...]或者未指定：[]
        var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:documentIDs},product: envVar.product});
        var documentID = "";
        if ("fail" === command.result){
            showEditorMsg({msg:"获取待保存病历集合失败！具体原因请查看F12输出",type:"error"});
            console.log(command);
        }else{
            if (command.params){
                var docIDFlag = false;
                if (0 == documentIDs.length){
                    docIDFlag = true;
                }
                for (var i=0;i<command.params.length;i++){
                    var rtn = privilege.getPrivilege(command.params[i].id);
                    if ("1" != rtn.canSave){
                        showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                        message = "";
                        return false;
                    }
                    if (message){
                        message = message + "、";
                    }
                    message = message + command.params[i].name.value;
                    if (docIDFlag){
                        documentIDs.push(command.params[i].id);
                    }
                }
            }else if (!flag){
                documentID = emrService.getCurrentDocumentID();
                var docStatus = emrService.getCurrentDocStatus(documentID);
                if (docStatus && (docStatus.curStatus === "created") && (docStatus.serial == '1')){
                    message = emrTrans("病历【"+docStatus.name+"】还未保存,请先保存,否则病历会丢失,是否保存？");
                }else{
                    documentID = "";
                }
            }
        }
        if (message){
            if (flag){
                var oldOk = $.messager.defaults.ok;
                var oldNo = $.messager.defaults.no;
                $.messager.defaults.ok = emrTrans("保存");
                $.messager.defaults.no = emrTrans("不存");
                var btns = $.messager.confirm3("保存操作提示", "病历【"+message+"】的内容有修改,是否保存？", function (r) {
                    if (true === r) {
                        if (isExistFunc(callBack)){
                            editorEvent.callbackAfterEvt = {fun:callBack, args:args};
                        }
                        emrService.saveDoc(documentIDs);
                    } else if (false === r){
                        if (documentID){
                            emrService.removeDocument(documentID);
                        }else{
                            emrService.restoreArticle(documentIDs[0]);
                        }
                        if (envVar.lockedID){
                            common.unLock(envVar.lockedDocumentID);
                        }
                        if (isExistFunc(callBack)){
                            callBack(args);
                        }
                    } else {
                        /*if (isExistFunc(callBack)){
                            callBack(args);
                        }*/
                    }
                    $.messager.defaults.ok = oldOk;
                    $.messager.defaults.no = oldNo;
                }).children("div.messager-button");
                btns.children("a:eq(0)").addClass('green');
                btns.children("a:eq(2)").focus();
            }else{
                if (isExistFunc(callBack)){
                    editorEvent.callbackAfterEvt = {fun:callBack, args:args};
                }
                emrService.saveDoc(documentIDs);
            }
        }else{
            if (isExistFunc(callBack)){
                callBack(args);
            }
        }
    },
    printDoc: function(silent){
        var confirmFlag = true;
        if ((sysOption.autoSave != "")&&((','+sysOption.autoSave+',').indexOf(',print,') != "-1")){
            confirmFlag = false;
        }
        var message = "";
        var documentIDs = [];
        var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:documentIDs},product: envVar.product});
        if ("fail" === command.result){
            showEditorMsg({msg:"获取待保存病历集合失败！",type:"error"});
            console.log(command);
        }else{
            if (command.params){
                for (var i=0;i<command.params.length;i++){
                    var rtn = privilege.getPrivilege(command.params[i].id);
                    if ("1" != rtn.canSave){
                        showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                        message = "";
                        return false;
                    }
                    if (message){
                        message = message + "、";
                    }
                    message = message + command.params[i].name.value;
                    documentIDs.push(command.params[i].id);
                }
                message = emrTrans("病历【"+message+"】的内容有修改,请保存后打印,是否保存？");
            }else{
                var documentID = emrService.getCurrentDocumentID();
                var docStatus = emrService.getCurrentDocStatus(documentID);
                if (docStatus && (docStatus.curStatus === "created")){
                    message = emrTrans("病历【"+docStatus.name+"】还未保存,请先保存后打印,是否保存？");
                    documentIDs.push(documentID);
                }
            }
        }
        if (message){
            //自动保存如未配置打印动作，进行提醒
            if (confirmFlag){
                var oldOk = $.messager.defaults.ok;
                var oldCancel = $.messager.defaults.cancel;
                $.messager.defaults.ok = emrTrans("保存");
                $.messager.defaults.cancel = emrTrans("不存");
                $.messager.confirm("保存操作提示", message, function (r) {
                    if (r){
                        editorEvent.callbackAfterEvt = {fun:emrService.printDocumentConfirm, args:silent};
                        emrService.saveDoc(documentIDs,false);
                    } else {
                    }
                    $.messager.defaults.ok = oldOk;
                    $.messager.defaults.cancel = oldCancel;
                });
            }else{
                editorEvent.callbackAfterEvt = {fun:emrService.printDocumentConfirm, args:silent};
                emrService.saveDoc(documentIDs,false);
            }
        }else{
            emrService.printDocumentConfirm(silent);
        }
    },
    printDocumentConfirm: function(silent, commandJson){
        var documentID = "";
        if (isExistVar(commandJson)){
            documentID = commandJson.params.currentDocumentID;
        }else{
            documentID = emrService.getCurrentDocumentID();
        }
        if ("" === documentID){
            return;
        }
        var docName = common.isHasAction("print",documentID);
        if (docName != "0"){
            var tipMessage = emrTrans('病历 "') + docName + emrTrans('" 已打印，是否再次打印？');
            var oldOk = $.messager.defaults.ok;
            var oldCancel = $.messager.defaults.cancel;
            $.messager.defaults.ok = emrTrans("是");
            $.messager.defaults.cancel = emrTrans("否");
            $.messager.confirm("打印操作提示", tipMessage, function (r) {
                if (r) {
                    emrService.printDocumentCheck(silent);
                } else {
                    return;
                }
                $.messager.defaults.ok = oldOk;
                $.messager.defaults.cancel = oldCancel;
            });
            return;
        }
        emrService.printDocumentCheck(silent);
    },
    printDocumentCheck: function(silent){
        var flag = true;
        var command = EmrEditor.syncExecute({action:"GET_DOCUMENTIDS_LIST",product: envVar.product});
        if ("fail" === command.result){
            showEditorMsg({msg:"获取病历集合失败！",type:"error"});
            console.log(command);
            flag = false;
        }else{
            var qualityResult = quality.printChecker(command.params);
            if (qualityResult){
                return;
            }
            for (var i=0;i<command.params.length;i++){
                var rtn = privilege.getPrivilege(command.params[i]);
                if ("1" != rtn.canPrint){
                    showEditorMsg({msg:"权限控制：不允许进行打印操作！" + rtn.cantPrintReason,type:"alert"});
                    flag = false;
                    return flag;
                }
            }
        }
        if (flag){
            var callBack = {
                response: function(commandJson){
                    console.log("print-response:", commandJson);
                    var type = commandJson.params.type;
                    if (type === "3"){
                        showEditorMsg({msg:"打印任务正在进行中... ...", type:"info"});
                    }
                    if (type == "4"){
                        var data = commandJson.params.data;
                        showEditorMsg({msg:"打印传参错误："+data, type:"info"});
                    }
                },
                reject: function(commandJson){
                    console.log("print-reject:",commandJson);
                    if ('undefined' != typeof commandJson.error.errorCode){
                        createModalDialog("Web-Print-PluginDialog","下载打印插件",600,600,"Web-Print-PluginFrame",'<iframe id="Web-Print-PluginFrame" scrolling="auto" frameborder="0" src="emr.bs.printplugin.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',"");
                    }else{
                        showEditorMsg({msg:"打印失败！",type:"error"});
                    }
                }
            };
            EmrEditor.syncExecute({
                action: "PRINT_DOCUMENT",
                params: {
                    printer: {
                        silent: silent
                    }
                },
                callBack: callBack,
                product: envVar.product
            });
        }
    },
    deleteDoc: function(id){
        var commandJson = emrService.getCurrentDocument();
        if (!commandJson){
            return;
        }
        var title = commandJson.title;
        id = id || title.id;
        if (!id){
            showEditorMsg({msg:"未指定要删除的病历文档，请检查！",type:"error"});
            return;
        }
        var rtn = privilege.getPrivilege(id);
        if ("1" != rtn.canDelete){
            showEditorMsg({msg:"权限控制：不允许进行删除操作！" + rtn.cantDeleteReason,type:"alert"});
            return;
        }
        var creatorInfo = common.getRecordCreatorInfo(id);
        var args = {action:"DELETE_DOCUMENT",params:{documentID:id},product: envVar.product};
        var tipMsg = emrTrans("确定删除【" + title.name.value +"】？");
        $.messager.confirm("删除操作提示", tipMsg, function (data) {
            if (data){
                if ("SAVE" === creatorInfo.documentStatus.toUpperCase()){
                    if ("Y" === sysOption.deleteVerification){
                        if ("1" === creatorInfo.passwordState){
                            if (creatorInfo.creatorCode && creatorInfo.creatorName){
                                modalDialogArgs = {args:args,creatorInfo:creatorInfo,dialogID:"deleteDialog"};
                                var deleteCallBack = function(returnValue){
                                    if (returnValue){
                                        var rtn = common.verifyUser(modalDialogArgs.creatorInfo.creatorCode,returnValue);
                                        if (rtn){
                                            EmrEditor.execute(modalDialogArgs.args);
                                        }else{
                                            showEditorMsg({msg:"密码验证失败！",type:"error"});
                                        }
                                    }
                                    modalDialogArgs = "";
                                };
                                createModalDialog(modalDialogArgs.dialogID,"删除病历密码验证","265","250","iframeDelete",'<iframe id="iframeDelete" scrolling="auto" frameborder="0" src="emr.bs.op.verifyuser.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>',deleteCallBack);
                            }
                        }else{
                            EmrEditor.execute(args);
                        }
                    }else{
                        EmrEditor.execute(args);
                    }
                }else{
                    var command = emrService.removeDocument(id);
                    if ("fail" === command.result){
                        $.messager.alert("提示", "当前病历创建后直接删除失败！", "error");
                    }else{
                        showEditorMsg({msg:"删除成功！",type:"success"});
                        if (command.params.deleteAllFlag){
                            var length = emrTemplate.tmplsTabs.tabs("tabs").length;
                            if (0 === length) {
                                emrService.createDoc(envVar.firstTmpl);
                            } else {
                                emrTemplate.tmplsTabs.tabs("select", 0);
                            }
                        }
                    }
                }
            }else{
                return;
            }
        });
    },
    updateLinkData: function(documentID, linkUrl, linksData){
        var commandJson = EmrEditor.syncExecute({action:"UPDATE_LINK_DATA",params:{documentID:documentID, linkUrl:linkUrl, linksData:linksData},product: envVar.product});
        return commandJson;
    },
    signDocument: function (params, callBack){
        EmrEditor.syncExecute({
            action: "SIGN_DOCUMENT",
            params: params,
            callBack: callBack,
            product: envVar.product
        });
    },
    saveSignDocument: function (params,data){
        return EmrEditor.syncExecute({
            action: "SAVE_SIGNED_DOCUMENT",
            params: params,
            documentData: data,
            product: envVar.product
        });
    },
    savePatSignDocument: function (params,data){
        return EmrEditor.syncExecute({
            action: "PATIENT_SIGNED_DOCUMENT",
            params: params,
            documentData: data,
            product: envVar.product
        });
    },
    getPatientSign: function (documentID){
        return EmrEditor.syncExecute({
            action: "GET_PATIENT_SIGN",
            params: {
                documentID: [documentID]
            },
            product: envVar.product
        });
    },
    getDoctortSign: function (documentID){
        return EmrEditor.syncExecute({
            action: "GET_DOCTOR_SIGN",
            params: {
                documentID: [documentID]
            },
            product: envVar.product
        });
    },
    getPDFBase64: function (params, callBack){
        return EmrEditor.syncExecute({
            action: "GET_PDFBASE64",
            params: params,
            callBack: callBack,
            product: envVar.product
        });
    },
    pushPDFBase64: function(params){
        return EmrEditor.syncExecute({
            action: "PDF_PUSH_SIGN",
            params: params,
            product: envVar.product
        });
    },
    doRevokeSignedDocument: function(docParams){
        var result = false;
        var noSign = false;
        var revokeResult = "";
        $.each(docParams, function(documentID, item) {
            var userInfo = common.getSignDocCharacter(documentID);
            if (!userInfo){
                return false;
            }
            revokeResult = EmrEditor.syncExecute({action:"REVOKE_SIGNED_DOCUMENT",params:{documentID:documentID,roleLevel:userInfo.roleLevel},product:envVar.product});
            if ("fail" === revokeResult.result){
                if (revokeResult.error.action == "REVOKE_SIGNED_DOCUMENT"){
                    showEditorMsg({msg:"失效文档签名失败！",type:"error"});
                }else{
                    showEditorMsg({msg:"保存文档失败！",type:"error"});
                }
                console.log(revokeResult);
                result = false;
                return false;
            }else{
                result = true;
                if ((revokeResult.params.action != "REVOKE_SIGNED_DOCUMENT")&&(documentID == revokeResult.params.currentDocumentID)){
                    noSign = true;
                    // 保存质控
                    quality.saveChecker([documentID]);
                    var docParam = common.getSavedRecordBydocumentID(documentID);
                    if (!docParam){
                        showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                        return;
                    }
                    var tabID = docParam.docCode + "-" + docParam.documentID;
                    var title = docParam.docName;
                    if ("1" === docParam.serial){
                        tabID = docParam.docCategoryCode;
                        title = docParam.docCategoryName;
                    }
                    emrTemplate.isLoading = true;
                    if (!emrTemplate.addTab(tabID,title,true)){
                        envVar.savedRecords.push(docParam);
                    }
                    emrTemplate.isLoading = false;
                    if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
                        cdsstool.getData(docParam,"Save");
                    }
                    hisLog.operate("EMR.OP.Save.OK",documentID);
                }
            }
        });
        if (result){
            if (noSign){
                showEditorMsg({msg:"保存成功！",type:"success"});
            }else{
                showEditorMsg({msg:"数据保存成功,签名已失效！",type:"success"});
            }
            editorEvent.raiseEvent("callbackAfterEvt",revokeResult);
        }
        return result;
    },
    revokeSign: function(userInfo,signProperty){
        var ret = {"result":"fail"};
        var userLevel = signProperty.signLevel;
        var isSuperiorSign = common.isSuperiorSign(userLevel,signProperty.documentID);
        if (isSuperiorSign == "1") {
            $.messager.popover({msg:'上级医师已签名，需上级医师撤销后才可撤销签名！', type:'info', style:{top:10,right:5}});
        }else {
            var signedLength = signProperty.authenticator.length;
            if (signedLength > 0){
                var code = signProperty.authenticator[0].code;
                ret = EmrEditor.syncExecute({
                    action: "REVOKE_SIGNED",
                    params: {
                        code: code
                    },
                    product: envVar.product
                });
            }
        }
        return ret;
    },
    getCurrentDocStatus: function(documentID){
        var docStatus = EmrEditor.syncExecute({
            action: "GET_CURRENT_STATUS",
            params:{
                documentID: documentID
            },
            product: envVar.product
        });
        if ("fail" === docStatus.result){
            console.log(docStatus);
            return false;
        }else{
            return docStatus.params.status;
        }
    },
    createDocByDocumentID: function(docParam){
        var createArgs = {
            action: "ISCAN_CREATE",
            params:{
                episodeID: patInfo.episodeID,
                templateID: docParam.templateID
            },
            product: envVar.product
        };
        var rtn = common.isCanCreate(createArgs);
        if ("1" != rtn.canCreate){
            showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
            return;
        }
        emrService.saveConfirm(true,[],docParam,function(docParam){
            if (docParam){
                var createArgs = {
                    action: "ISCAN_CREATE",
                    params:{
                        episodeID: patInfo.episodeID,
                        templateID: docParam.templateID
                    },
                    product: envVar.product
                };
                var rtn = common.isCanCreate(createArgs);
                if ("1" != rtn.canCreate){
                    showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
                    return;
                }
                rtn = "";
                if ("1" === docParam.serial){
                    $.each(envVar.savedRecords,function(index,item){
                        if ("1" != item.serial) {
                            return true;
                        }
                        if (docParam.docCategoryCode === item.docCategoryCode){
                            rtn = item;
                            return false;
                        }
                    });
                }
                var args = {
                    action: "CREATE_DOCUMENT",
                    params: {
                        docName: docParam.docName,
                        docCode: docParam.docCode,
                        templateID: docParam.templateID,
                        sourceID: docParam.documentID,
                        sourceType: docParam.sourceType,
                        eventID: docParam.eventID,
                        eventType: docParam.eventType
                    },
                    type: {
                        serial: docParam.serial,
                        leadframe: docParam.isLeadframe
                    },
                    product: envVar.product
                };
                if (rtn){
                    // 选中实例页签,追加创建
                    var isSelected = emrTemplate.selectTmplTab(rtn.docCategoryCode);
                    if (isSelected){
                        emrService.loadDoc(rtn, false);
                        args.params.actionType = "ADD_ARTICLE";
                        EmrEditor.execute(args);
                    }else{
                        showEditorMsg({msg:"未选中病历实例页签，请检查！",type:"error"});
                        return;
                    }
                }else{
                    EmrEditor.execute(args);
                    //新建病历后取消实例页签的选中状态
                    emrTemplate.unselectTmplTab();
                }
            }else{
                //;
            }
        },false);
    },
    createDocByRefTemplateID: function(docParam,refAdmID){
        var createArgs = {
            action: "ISCAN_CREATE",
            params:{
                episodeID: patInfo.episodeID,
                templateID: docParam.templateID
            },
            product: envVar.product
        };
        var rtn = common.isCanCreate(createArgs);
        if ("1" != rtn.canCreate){
            showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
            return;
        }
        emrService.saveConfirm(true,[],docParam,function(docParam){
            if (docParam){
                var createArgs = {
                    action: "ISCAN_CREATE",
                    params:{
                        episodeID: patInfo.episodeID,
                        templateID: docParam.templateID
                    },
                    product: envVar.product
                };
                var rtn = common.isCanCreate(createArgs);
                if ("1" != rtn.canCreate){
                    showEditorMsg({msg:rtn.reason + ",不能再创建！",type:"alert"});
                    return;
                }
                rtn = "";
                if ("1" === docParam.serial){
                    $.each(envVar.savedRecords,function(index,item){
                        if ("1" != item.serial) {
                            return true;
                        }
                        if (docParam.docCategoryCode === item.docCategoryCode){
                            rtn = item;
                            return false;
                        }
                    });
                }
                var args = {
                    action: "CREATE_DOCUMENT",
                    params: {
                        templateID: docParam.templateID,
                        sourceID: docParam.sourceID,
                        sourceType: docParam.sourceType,
                        refAdmID: refAdmID
                    },
                    type: {
                        serial: docParam.serial,
                        leadframe: docParam.isLeadframe
                    },
                    product: envVar.product
                };
                if (rtn){
                    // 选中实例页签,追加创建
                    var isSelected = emrTemplate.selectTmplTab(rtn.docCategoryCode);
                    if (isSelected){
                        emrService.loadDoc(rtn, false);
                        args.params.actionType = "ADD_ARTICLE";
                        EmrEditor.execute(args);
                    }else{
                        showEditorMsg({msg:"未选中病历实例页签，请检查！",type:"error"});
                        return;
                    }
                }else{
                    EmrEditor.execute(args);
                    //新建病历后取消实例页签的选中状态
                    emrTemplate.unselectTmplTab();
                }
            }else{
                //;
            }
        },false);
    },
    getCurrentDocumentID: function(){
        var commandJson = emrService.getCurrentDocument();
        if (commandJson){
            return commandJson.title.id;
        }
        return commandJson;
    },
    getCurrentDocument: function(id){
        var commandJson = EmrEditor.syncExecute({action:"GET_CURRENT_DOCUMENT",params:{documentID:id || ""},product: envVar.product});
        if ("fail" === commandJson.result){
            showEditorMsg({msg:"获取病历实例失败！",type:"error"});
            return "";
        }
        return commandJson.params;
    },
    insertTooth: function(data){
        if (data){
            EmrEditor.syncExecute({action:"COMMAND",params:{tooth: data},product: envVar.product});
        }
    },
    updateTooth: function(data){
        if (data){
            EmrEditor.syncExecute({action:"COMMAND",params:{updateTooth: data},product: envVar.product});
        }
        modalDialogArgs = "";
    },
    setLockMessage: function(lockMessage){
        var span = $("<span></span>");
        if (lockMessage){
            $(span).html(lockMessage);
            $("#lock").html(span);
            $("#lock").show();
        }else{
            $("#lock").html(span);
            $("#lock").hide();
        }
    },
    removeDocument: function(documentID){//移除编辑器内指定文档内容
        return EmrEditor.syncExecute({action:"REMOVE_DOCUMENT",params:{documentID:documentID},product: envVar.product});
    },
    restoreArticle: function(documentID){
        return EmrEditor.syncExecute({action:"RESTORE_ARTICLE",params:{documentID:documentID},product: envVar.product});
    }
};

var editorEvent = {
    eventCaretContext: function(commandJson){
        $("#formatButton a").each(function(index, element) {
            if (commandJson.args.hasOwnProperty(element.id)){
                if (element.id == "fontSize"){
                    var currentFontSize = commandJson.args.fontSize;
                    var fontSize = $("#fontSizeCom").combobox('getValue');
                    if (fontSize != currentFontSize){
                        $("#fontSizeCom").combobox("select",currentFontSize);
                    }
                }else{
                    element.setAttribute("style","background:#eaf2ff;color:#000;border:0 solid #b7d2ff;padding:0;");
                }
            }else{
                element.removeAttribute("style","background:#eaf2ff;color:#000;border:0 solid #b7d2ff;padding:0;");
            }
        });
    },
    eventDocumentChanged: function(commandJson){
        console.log("eventDocumentChanged",commandJson);
        if ("" != commandJson.args.id){
            EmrEditor.updateEditorStore({documentID: commandJson.args.id});
            emrService.saveConfirm(true,[],{action:"eventDocumentChanged",params:commandJson.args.id},function(args){
                /*var result = false;
                if (envVar.lockedID){
                    result = common.unLock(envVar.lockedDocumentID);
                }
                if (result){
                    return;
                }*/
                var documentID = args.params;
                var lockFlag = common.hasLocked(documentID);
                if (!lockFlag){
                    var rtn = privilege.getPrivilege(documentID);
                    if ("1" === rtn.canSave){
                        emrService.setReadonly(documentID,false);
                        //setPnlBtnDisable(false);
                        EmrEditor.syncExecute({action:"SET_POINT",params:{documentID:rtn.documentID,position:"start"},product: envVar.product});
                        //emrService.reloadBindData(rtn.documentID,true);
                        privilege.setRevsion(rtn.documentID);
                    }else{
                        showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                        setPnlBtnDisable(true);
                        emrService.setReadonly(documentID,true);
                    }
                }
            },false);
        }
    },
    eventSectionChanged: function(commandJson){
        console.log("eventSectionChanged",commandJson);
        /*{
            "action": "eventSectionChanged",
            "args": {
                "code": "S1664868565261",
                "name": "现病史",
                "label": "现病史",
                "description": "",
                "backgroundColor": "",
                "fontFamily": "",
                "color": "",
                "fontSize": "",
                "bindKBId": "",
                "bindKBName": "",
                "bindKBNodeId": "",
                "bindKBNodeName": "",
                "glossary": []
            }
        }*/
        emrService.sectionArgs = commandJson.args;
        if (isExistFunc(emrService.refreshKBFunc)){
            emrService.refreshKBFunc(commandJson.args);
        }else{
            if (document.getElementById('kbDataFrame')){ //刷新知识库
                var kbDataFrame = document.getElementById('kbDataFrame').contentWindow;
                var fn = kbDataFrame.getKBNodeByTreeID;
                if (isExistFunc(fn)){
                    fn(commandJson.args);
                }
            }
        }
    },
    eventRequestChangeTitle: function(commandJson){
        console.log("eventRequestChangeTitle",commandJson);
    },
    eventRequestTemplate: function(commandJson){
        console.log("eventRequestTemplate",commandJson);
    },
    eventHyperLink: function(commandJson){
        console.log("eventHyperLink",commandJson);
        var linkConfig = common.getLinkConfig(commandJson.args.url);
        if (linkConfig){
            if ("switchTabByEMR" === linkConfig.method){
                var fn = parent.switchTabByEMR;
                if (isExistFunc(fn)){
                    fn(linkConfig.title);
                }else{
                    showEditorMsg({msg:"switchTabByEMR方法未定义！",type:"info"});
                }
            }else if ("switchDataTab" === linkConfig.method) { // 切换资源区tab页签
                HisTools.dataTabs.switchDataTab(linkConfig.title);
            }else{ // 直接弹窗打开
                HisTools.hislinkWindow.openUnitLink(commandJson.args, linkConfig);
            }
        }else{
            showEditorMsg({msg:"请检查链接单元【"+commandJson.args.code+"】的配置！",type:"info"});
        }
    },
    eventRequestSign: function(commandJson){
        var documentID = commandJson.args.documentID;
        var signProperty = commandJson.args;
        var command = EmrEditor.syncExecute({action:"GET_MODIFIED",params:{documentID:[documentID]},product: envVar.product});
        if ("fail" === command.result){
            showEditorMsg({msg:"获取待保存病历集合失败！",type:"error"});
            console.log(command);
        }else{
            var docStatus = emrService.getCurrentDocStatus(documentID);
            if ((docStatus && (docStatus.curStatus === "created"))||command.params){
                var rtn = privilege.getPrivilege(documentID);
                if ("1" != rtn.canSave){
                    showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                    return;
                }else{
                    var docTempParam = common.getTemplateDataByDocumentID([documentID]);
                    if (!docTempParam){
                        showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                        return;
                    }
                    if (emrService.saveDocCheck(docTempParam)){
                        return;
                    }
                    // 失效签名
                    if ("Y" == sysOption.isRevokeSign){
                        var flag = emrService.doRevokeSignedDocument(docTempParam);
                        if (!flag){
                            return;
                        }
                    }else{
                        setSysMenuDoingSth("病历保存中...");
                        var saveResult = EmrEditor.syncExecute({action:"SAVE_DOCUMENT",product: envVar.product});
                        setSysMenuDoingSth("");
                        if ("fail" === saveResult.result){
                            showEditorMsg({msg:"保存失败！具体原因请查看F12输出",type:"error"});
                            console.log(saveResult);
                            return;
                        }
                        // 保存质控
                        quality.saveChecker([documentID]);
                        var docParam = common.getSavedRecordBydocumentID(documentID);
                        if (!docParam){
                            showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                            return;
                        }
                        var tabID = docParam.docCode + "-" + docParam.documentID;
                        var title = docParam.docName;
                        if ("1" === docParam.serial){
                            tabID = docParam.docCategoryCode;
                            title = docParam.docCategoryName;
                        }
                        emrTemplate.isLoading = true;
                        // 是否存在Tab签，是：选中Tab签，否：新增并选中Tab签
                        if (!emrTemplate.addTab(tabID,title,true)){
                            envVar.savedRecords.push(docParam);
                        }
                        emrTemplate.isLoading = false;
                        if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
                            cdsstool.getData(docParam,"Save");
                        }
                        hisLog.operate("EMR.OP.Save.OK",documentID);
                    }
                }
            }
            var qualityResult = quality.signChecker([documentID]);
            if (qualityResult){
                return;
            }
            signProperty.id = "";
            signProperty.signLevel = signProperty.oriSignLevel;
            var signedLength = signProperty.authenticator.length;
            if (signedLength > 0){
                signProperty.id = signProperty.authenticator[0].id;
                signProperty.signLevel = signProperty.authenticator[0].signLevel
            }
            var oriSignatureLevel = signProperty.oriSignLevel.toUpperCase();
            if (("PATIENT" === oriSignatureLevel)||("NOTATION" === oriSignatureLevel)) {
                if ("undefined" == typeof(handSign)) {
                    var patCAoffMsg = emrTrans("未开启患者签名功能，如需开启，请联系系统管理员");
                    if ("undefined" == typeof(patCAOffReason)){
                        patCAoffMsg = patCAOffReason + patCAoffMsg;
                    }
                    showEditorMsg({msg:patCAoffMsg, type:"forbid"});
                    return;
                }
                var rtn = privilege.getPrivilege(documentID);
                if (("1" != rtn.canPatCheck)&&(signedLength == 0)){
                    showEditorMsg({msg:"没有权限进行患者签名"+rtn.cantPatCheckReason, type:"forbid"});
                    return;
                }else if (("1" != rtn.canPatReCheck)&&(signedLength > 0)){
                    showEditorMsg({msg:"没有权限进行患者改签"+rtn.cantPatReCheckReason, type:"forbid"});
                    return;
                }
                // 患签、批注
                var argEditor = {
                    signProps:{
                        patientID: patInfo.patientID,
                        episodeID: patInfo.episodeID,
                        documentID: documentID,
                        signKeyWord: signProperty.cellName //患签单元名称
                    },
                    oriSignatureLevel: oriSignatureLevel,
                    documentID: documentID,
                    userID: patInfo.userID,
                    code: signProperty.code,
                    episodeID: patInfo.episodeID,
                    descContent: signProperty.tip,//患者批注内容
                    signDocument: emrService.signDocument,
                    savePatSignDocument: emrService.savePatSignDocument,
                    canDoPDFSign: common.canDoPDFSign,
                    getSignedPDF: common.getSignedPDF,
                    getPatSignKeyWord: function(documentID){
                        var patSignResult = emrService.getPatientSign(documentID);
                        var allKeyWord = "";
                        if ("fail" != patSignResult.result){
                            var patSignKeyWord = patSignResult.params;
                            for (var i=0;i<patSignKeyWord.length;i++){
                                if (allKeyWord == ""){
                                    allKeyWord = "["+patSignKeyWord[i].name+"]";
                                }else{
                                    allKeyWord += ",["+patSignKeyWord[i].name+"]";
                                }
                            }
                        }
                        return allKeyWord;
                    },
                    createToSignPDFBase64: emrService.getPDFBase64,
                    getPatientSignInfo: common.getPatientSignInfo,
                    getHandSignType: common.getHandSignType,
                    pushToSignPDF: emrService.pushPDFBase64,
                    getAnySignLocation: common.getAnySignLocation
                };
                if (signedLength == 0){
                    handSign.sign(argEditor);
                }else if(signedLength > 0){
                    var tipMsg = emrTrans("确定要改签？");
                    if ("NOTATION" === oriSignatureLevel){
                        tipMsg = emrTrans("确定要修改批注内容？");
                    }
                    $.messager.confirm("操作提示", tipMsg, function (data){
                        if (data){
                            handSign.sign(argEditor);
                        }
                    });
                }
            }else {
                var rtn = privilege.getPrivilege(documentID);
                if ("1" != rtn.canCheck){
                    showEditorMsg({msg:"权限控制：不允许进行签名操作！" + rtn.cantCheckReason,type:"alert"});
                    return;
                }
                signProperty.canRevokCheck = rtn.canRevokCheck;
                if (1 === sysOption.CAService){
                    audit.caSign(documentID, signProperty);
                }else{
                    modalDialogArgs = signProperty;
                    if (sysOption.isAllRevokeSign.split("^")[0]=="Y"){
                        modalDialogArgs.canRevokCheck = "1";
                    }
                    if ("Y" != sysOption.isDirectSign){
                        modalDialogArgs.dialogID = "signDialog";
                        var content = '<iframe id="signFrame" scrolling="auto" frameborder="0" src="emr.bs.op.sign.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>';
                        createModalDialog(modalDialogArgs.dialogID,"身份验证",385,295,"signFrame",content,audit.sysSign);
                    }else{
                        var userInfo = common.getUserInfo();
                        if (userInfo){
                            audit.sysSign({action:"sign",userInfo:userInfo});
                        }
                    }
                }
            }
        }
    },
    eventPrintDocument: function(commandJson){
        //记录打印日志
        var data = {
            action: "PRINT_DOCUMENT",
            params: {
                documentID: commandJson.args.documentID,
                userID: patInfo.userID,
                userLocID: patInfo.userLocID,
                printType: "EMR",
                pmdType: patInfo.pmdType,
                pmdCode: patInfo.pmdCode,
                ipAddress: patInfo.ipAddress
            },
            product: envVar.product
        };
        ajaxGETCommon(data, function(ret){
            if (ret != "1"){
                showEditorMsg({msg:"打印日志保存失败！",type:"error"});
            }
        }, function (error) {
            $.messager.alert("发生错误", "printDcoument error:"+error, "error");
        }, true);
        //hisLog.operate("EMR.OP.Print.OK",command.params);
    },
    eventDocModify: function(commandJson){
        console.log("eventDocModify",commandJson);
        if (commandJson.args) {
            //文档进入编辑状态，给平台发消息
            setSysMenuDoingSth(emrTrans('病历正在编辑，是否保存？'));
            //设置保存的回调函数供平台调用
            setDoingSthSureCallback(true);
        }else {
            //无正在编辑的病历，清空状态
            setSysMenuDoingSth("");
            setDoingSthSureCallback(false);
            if (envVar.lockedID){
                common.unLock(envVar.lockedDocumentID);
            }
        }
    },
    eventCopy: function(commandJson){
        //编辑器复制事件，返回复制的纯文本
        console.log("eventCopy",commandJson);
    },
    eventRequestTooth: function(commandJson){
        //牙位图事件
        console.log("eventRequestTooth",commandJson);
        if (isExistVar(commandJson.args.toothType)){
            modalDialogArgs = commandJson.args;
        }
        var width = window.screen.availWidth - 250;
        var height = window.screen.availHeight - 250;
        var dialogID = "toothDialog";
        var iframeId = "iframeTooth";
        var src = "emr.bs.op.tooth.csp?dialogID="+dialogID+"&MWToken="+getMWToken();
        var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
        createModalDialog(dialogID,"牙位图", width, height, iframeId,iframeCotent, emrService.updateTooth);
    },
    eventAutoSave: function(commandJson){
        console.log("eventAutoSave",commandJson);
    },
    eventEdit: function(commandJson){
        console.log("eventEdit",commandJson);
        if (sysOption.isLock != "Y"){
            return;
        }
        var documentID = commandJson.args.documentID;
        var isReadonly = commandJson.args.isReadonly;
        if (!isReadonly){
            var lockFlag = common.hasLocked(documentID);
            if (lockFlag){
                emrService.restoreArticle(documentID);
                return;
            }else{
                var docStatus = emrService.getCurrentDocStatus(documentID);
                var result = common.isRefreshDocument(documentID, docStatus.pOperateDateTime);
                if ("1" === result.locked){
                    return;
                }else if ("0" === result.locked){
                    var docParam = result.docData;
                    if (docParam){
                        if (docParam.status == "delete"){
                            $.messager.alert("提示", "请注意：当前病历已被其他人删除！", "alert");
                            //为空表示都被删除了，有documentID表示连续显示的文档需要刷新
                            if ("" != docParam.documentID){
                                emrService.loadDoc(docParam,false);
                            }else{
                                if (docStatus && (docStatus.curStatus != "created")){
                                    $.each(envVar.savedRecords, function(index, item) {
                                        var deleteIndex = false;
                                        if ("1" === docParam.serial){
                                            if ((docParam.docCategoryCode === item.docCategoryCode)&&(docParam.docCategoryName === item.docCategoryName)) {
                                                deleteIndex = true;
                                            }
                                        }else{
                                            deleteIndex = true;
                                        }
                                        if (deleteIndex) {
                                            envVar.savedRecords.splice(index, 1);
                                            emrTemplate.closeCurTmplsTab();
                                            return false;
                                        }
                                    });
                                }
                                var length = emrTemplate.tmplsTabs.tabs("tabs").length;
                                if (0 === length) {
                                    emrService.createDoc(envVar.firstTmpl);
                                } else {
                                    emrTemplate.tmplsTabs.tabs("select", 0);
                                }
                            }
                        }else if (docParam.status == "Save"){
                            $.messager.alert("提示", "请注意：当前病历已被修改，将重新加载最新病历内容！", "alert");
                            var loadResult = emrService.loadDoc(docParam,false);
                            if (loadResult){
                                var tabID = docParam.docCode + "-" + docParam.documentID;
                                var title = docParam.docName;
                                if ("1" === docParam.serial){
                                    tabID = docParam.docCategoryCode;
                                    title = docParam.docCategoryName;
                                }
                                emrTemplate.isLoading = true;
                                // 是否存在Tab签，是：选中Tab签，否：新增并选中Tab签
                                if (!emrTemplate.addTab(tabID,title,true)){
                                    envVar.savedRecords.push(docParam);
                                }
                                emrTemplate.isLoading = false;
                            }
                        }
                    }else{
                        common.lock(documentID);
                    }
                }else if ("-1" === result.locked){
                    common.lock(documentID);
                }
            }
        }
    },
    eventBeforeEdit: function(commandJson){
        console.log("eventBeforeEdit",commandJson);
        if (sysOption.isLock != "Y"){
            return;
        }
        var documentID = commandJson.args.documentID;
        var isReadonly = commandJson.args.isReadonly;
        if (isReadonly){
            var docStatus = emrService.getCurrentDocStatus(documentID);
            var result = common.isRefreshDocument(documentID, docStatus.pOperateDateTime);
            if ("1" === result.locked){
                return;
            }else if ("0" === result.locked){
                envVar.lockedDocumentID = "";
                envVar.lockedID = "";
                var rtn = privilege.getPrivilege(documentID);
                if ("1" === rtn.canSave){
                    emrService.setReadonly(documentID,false);
                    var docParam = result.docData;
                    if (docParam){
                        if (docParam.status == "delete"){
                            $.messager.alert("提示", "请注意：当前病历已被其他人删除！", "alert");
                            //为空表示都被删除了，有documentID表示连续显示的文档需要刷新
                            if ("" != docParam.documentID){
                                emrService.loadDoc(docParam,false);
                            }else{
                                if (docStatus && (docStatus.curStatus != "created")){
                                    $.each(envVar.savedRecords, function(index, item) {
                                        var deleteIndex = false;
                                        if ("1" === docParam.serial){
                                            if ((docParam.docCategoryCode === item.docCategoryCode)&&(docParam.docCategoryName === item.docCategoryName)) {
                                                deleteIndex = true;
                                            }
                                        }else{
                                            deleteIndex = true;
                                        }
                                        if (deleteIndex) {
                                            envVar.savedRecords.splice(index, 1);
                                            emrTemplate.closeCurTmplsTab();
                                            return false;
                                        }
                                    });
                                }
                                var length = emrTemplate.tmplsTabs.tabs("tabs").length;
                                if (0 === length) {
                                    emrService.createDoc(envVar.firstTmpl);
                                } else {
                                    emrTemplate.tmplsTabs.tabs("select", 0);
                                }
                            }
                        }else if (docParam.status == "Save"){
                            $.messager.alert("提示", "请注意：当前病历已被修改，将重新加载最新病历内容！", "alert");
                            var loadResult = emrService.loadDoc(docParam,false);
                            if (loadResult){
                                var tabID = docParam.docCode + "-" + docParam.documentID;
                                var title = docParam.docName;
                                if ("1" === docParam.serial){
                                    tabID = docParam.docCategoryCode;
                                    title = docParam.docCategoryName;
                                }
                                emrTemplate.isLoading = true;
                                // 是否存在Tab签，是：选中Tab签，否：新增并选中Tab签
                                if (!emrTemplate.addTab(tabID,title,true)){
                                    envVar.savedRecords.push(docParam);
                                }
                                emrTemplate.isLoading = false;
                            }
                        }
                    }else{
                        common.lock(documentID);
                    }
                }else{
                    showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                    setPnlBtnDisable(true);
                    emrService.setReadonly(documentID,true);
                }
            }else if ("-1" === result.locked){
                emrService.setLockMessage("");
                envVar.lockedDocumentID = "";
                envVar.lockedID = "";
                var rtn = privilege.getPrivilege(documentID);
                if ("1" === rtn.canSave){
                    emrService.setReadonly(documentID,false);
                    setPnlBtnDisable(false);
                }else{
                    showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                    setPnlBtnDisable(true);
                }
            }
        }
    },
    eventloadglobalparameters: function(commandJson){
        if ("fail" === commandJson.result){
            console.log(commandJson);
        }
    },
    eventcreatedocument: function(commandJson){
        setSysMenuDoingSth("");
        if ("fail" === commandJson.result){
            if (isExistVar(commandJson.error.errorMessage)){
                showEditorMsg({msg:commandJson.error.errorMessage,type:"alert"});
            }else{
                showEditorMsg({msg:"创建失败！",type:"error"});
                $("#bsEditor").css("display","none");
            }
            console.log(commandJson);
            return;
        }
        var display = $("#bsEditor").css("display");
        if ("none" === display){
            $("#bsEditor").css("display","block");
        }
        var documentID = commandJson.params.documentID;
        var lockFlag = common.hasLocked(documentID);
        if (lockFlag){
            return;
        }
        var rtn = privilege.getPrivilege(documentID);
        if ("1" === rtn.canSave){
            setPnlBtnDisable(false);
            EmrEditor.syncExecute({action:"SET_POINT",params:{documentID:documentID,position:"start"},product: envVar.product});
        }else{
            showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
            setPnlBtnDisable(true);
            emrService.setReadonly(documentID,true);
        }
        /*if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
            var docParam = common.getRecordBydocumentID(documentID);
            if (!docParam){
                showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                return;
            }
            cdsstool.getData(docParam,"create");
        }*/
        if ("REFREANCE" != commandJson.params.sourceType){
            hisLog.create("EMR.OP.CreateDoc",documentID);
        }else{
            hisLog.create('EMR.OP.AdmHistoryLst.CreateDoc',documentID);
        }
    },
    eventloaddocument: function(commandJson){
        setSysMenuDoingSth("");
        if ("fail" === commandJson.result){
            showEditorMsg({msg:"病历加载失败！",type:"error"});
            $("#bsEditor").css("display","none");
            console.log(commandJson);
            return;
        }
        if (!isConsistent()){
            $("#bsEditor").css("display","none");
            return;
        }
        var display = $("#bsEditor").css("display");
        if ("none" === display){
            $("#bsEditor").css("display","block");
        }
        var documentID = commandJson.params.currentDocumentID;
        if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
            var docParam = common.getRecordBydocumentID(documentID);
            if (!docParam){
                showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                return;
            }
            cdsstool.getData(docParam,"Save");
        }
        if (isExistVar(emrService.pluginType) && emrService.pluginType.toUpperCase() === "PDF"){
            return;
        }
        var lockFlag = common.hasLocked(documentID);
        if (lockFlag){
            return;
        }
        if (!emrService.getReadonly()){
            var rtn = privilege.getPrivilege(documentID);
            if ("1" === rtn.canSave){
                setPnlBtnDisable(false);
                EmrEditor.syncExecute({action:"SET_POINT",params:{documentID:rtn.documentID,position:"start"},product: envVar.product});
                emrService.reloadBindData(rtn.documentID,true);
                privilege.setRevsion(rtn.documentID);
                /*privilege.setViewRevise(rtn.documentID, function() {
                    var btn = $('#btnRevisionVisible');
                    if (btn.length !== 0 && $('#btnRevisionVisible').find("span").eq(1).text() === '隐藏痕迹') {
                        $('#btnRevisionVisible').find("span").eq(1).text('显示痕迹');
                    }
                    return false;
                });*/
            }else{
                showEditorMsg({msg:"权限控制：不允许进行保存操作！" + rtn.cantSaveReason,type:"alert"});
                setPnlBtnDisable(true);
                emrService.setReadonly(documentID,true);
            }
        }
        hisLog.operate("EMR.OP.LoadDoc",documentID);
    },
    eventrefreshreferencedata: function(commandJson){
        if ("fail" === commandJson.result){
            showEditorMsg({msg:"绑定数据未同步！",type:"error"});
            console.log(commandJson);
            return;
        }else{
            //EmrEditor.syncExecute({action:"SET_POINT",params:{documentID:commandJson.params.documentID,position:"end"},product: envVar.product});
        }
        hisLog.operate("EMR.OP.BinddataReload",commandJson.params.documentID);
    },
    eventsavedocument: function(commandJson){
        setSysMenuDoingSth("");
        if ("fail" === commandJson.result){
            showEditorMsg({msg:"病历保存失败！",type:"error"});
            console.log(commandJson);
        }else{
            showEditorMsg({msg:"病历保存成功！",type:"success"});
            if (commandJson.params.documentID){
                quality.saveChecker([commandJson.params.currentDocumentID]);
                var docParam = common.getSavedRecordBydocumentID(commandJson.params.currentDocumentID);
                if (!docParam){
                    showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                    return;
                }
                var tabID = docParam.docCode + "-" + docParam.documentID;
                var title = docParam.docName;
                if ("1" === docParam.serial){
                    tabID = docParam.docCategoryCode;
                    title = docParam.docCategoryName;
                }
                emrTemplate.isLoading = true;
                // 是否存在Tab签，是：选中Tab签，否：新增并选中Tab签
                if (!emrTemplate.addTab(tabID,title,true)){
                    envVar.savedRecords.push(docParam);
                }
                emrTemplate.isLoading = false;
                if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
                    cdsstool.getData(docParam,"Save");
                }
            }
        }
        editorEvent.raiseEvent("callbackAfterEvt",commandJson);
        hisLog.operate("EMR.OP.Save.OK",commandJson.params.documentID);
    },
    eventdeletedocument: function(commandJson){
        if ("fail" === commandJson.result){
            showEditorMsg({msg:"删除失败！未保存的病历无法删除",type:"error"});
            console.log(commandJson);
            return;
        }else{
            showEditorMsg({msg:"删除成功！",type:"success"});
            var tabIndex = "";
            if ("1" === commandJson.params.serial){
                if (commandJson.params.deleteAllFlag){
                    $.each(envVar.savedRecords, function(index, item) {
                        if ("1" != item.serial){
                            return true;
                        }
                        if ((commandJson.params.docCategoryCode === item.docCategoryCode)&&(commandJson.params.docCategoryName === item.docCategoryName)) {
                            envVar.savedRecords.splice(index, 1);
                            emrTemplate.closeCurTmplsTab();
                            tabIndex = index;
                            return false;
                        }
                    });
                }
            }else{
                $.each(envVar.savedRecords, function(index, item) {
                    if (commandJson.params.documentID === item.documentID) {
                        envVar.savedRecords.splice(index, 1);
                        emrTemplate.closeCurTmplsTab();
                        tabIndex = index;
                        return false;
                    }
                });
            }
            var length = emrTemplate.tmplsTabs.tabs("tabs").length;
            if (0 === length) {
                emrService.createDoc(envVar.firstTmpl);
            } else {
                var tab = emrTemplate.tmplsTabs.tabs("getSelected");
                if (!tab){
                    return;
                }
                var idx = emrTemplate.tmplsTabs.tabs("getTabIndex", tab);
                emrTemplate.tmplsTabs.tabs("select", idx);
            }
        }
        if ("undefined" != typeof cdsstool && isExistFunc(cdsstool.getData)){
            var docParam = common.getRecordBydocumentID(commandJson.params.documentID);
            if (!docParam){
                showEditorMsg({msg:"未获取到病历数据！",type:"alert"});
                return;
            }
            cdsstool.getData(docParam,"Delete");
        }
        hisLog.operate("EMR.OP.Delete.OK",commandJson.params.documentID);
    },
    eventAppendFragment: function(commandJson){
        if ("fail" != commandJson.result){
            eventSave("appendComposite","",false);
        }else{
            console.log(commandJson);
        }
    },
    eventReplaceFragment: function(commandJson){
        if ("fail" != commandJson.result){
            eventSave("replaceComposite","",false);
        }else{
            showEditorMsg({msg:'知识库替换失败！', type:'error'});
            console.log(commandJson);
        }
    },
    /// 异步命令回调
    callbackAfterEvt: null,
    raiseEvent: function (evtName,commandJson){
        var evt = editorEvent[evtName];
        if (evt && isExistFunc(evt.fun)){
            try {
                evt.fun(evt.args,commandJson);
            } catch(error){
                //$.messager.alert("发生错误",`${evtName} error: ${error.message || error}`,"error");
                $.messager.alert("发生错误",evtName + error.message || error,"error");
            } finally{
                editorEvent[evtName] = null;
            }
        }
    }
};

//快捷键保存 对外接口
function eventSave(action,callBack,isAsync) {
    if ((sysOption.autoSave == "")||((','+sysOption.autoSave+',').indexOf(','+action+',') == "-1")){
        return;
    }
    emrService.saveConfirm(false,[],"",callBack,isAsync);
}

///保存时调用判断是否串患者
function isConsistent(){
    var documentContext = emrService.getCurrentDocument();
    if (!documentContext) {
        showEditorMsg({msg:'请注意：当前保存病历可能不属于当前患者，保存失败，请重新打开病历页面进行编辑保存！', type:'error'});
        return false;
    }
    
    var isError = false;
    // 连接数据库标识
    var cacheFlag = "";
    var ret = common.getAdmByDocumentID(documentContext.title.id);
    if (ret.indexOf('<html>') != "0") {
        if (ret !== "") {
            if (ret !== patInfo.episodeID)
            {
                isError = true;
            }
        }
    }else {
        cacheFlag = ret;
    }
    
    if (cacheFlag !== "") {
        $.messager.alert('提示','病历保存时，页面系统失效，请重新登录!','info');
        return false;
    }
        
    if (isError){
        $.messager.alert('提示','请注意：当前保存病历可能不属于当前患者，保存失败，请重新打开病历页面进行编辑保存！','info');
        return false;
    }
    return true;
}

//插入文本数据到病历
function insertText(textData){
    if (textData){
        EmrEditor.syncExecute({
            action:"COMMAND",
            params:{
                text: textData
            },
            product: envVar.product
        });
    }
}