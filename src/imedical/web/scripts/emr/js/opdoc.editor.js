var emrEditor = {
    newEmrPlugin: function () {
        if (!iEmrPlugin) {
            iEmrPlugin = new iEmrPluginEx(document.getElementById('editorFrame').contentWindow);
            // 2021/11/2 zhangxy 新增病历缩放功能
            slider = new Slider($(".scale-slider"), {
                start: 50,
                end: 200,
                initValue: envVar.OPScaling || 100,
                onChange: function (v) {
                      common.setOPScaling(v);
                      envVar.OPScaling = v
                      if(isShowScaleSliderBtn == "Y") iEmrPlugin.ZOOM_DOCUMENT(v);
                },
              });
        }
    },
    refreshKBFunc: undefined, //资源区刷新相关的知识库委托
    refreshSecHistoryFunc: undefined, //资源区刷新相关的知识库委托
    sectionResFunc: null, //刷新相关资源区委托
    SectionCode: '', //记录当前选中的章节的code，用户刷新相关的资源区知识库
    createAsLoad: false,
    resourceWindow: null,
    showResourceWindow: function () {
        emrEditor.resourceWindow = window.showModelessDialog('emr.opdoc.resource.window.csp', window, 'dialogHeight:500px;dialogWidth:800px;resizable:no;status:no');
    },
    closeResourceWindow: function () {
        if (emrEditor.resourceWindow && !emrEditor.resourceWindow.closed) {
            emrEditor.resourceWindow.close();
            emrEditor.resourceWindow = null;
        }
    },
    getModifyResult: function (InstanceID) {
        return iEmrPlugin.CHECK_DOCUMENT_MODIFY({
            InstanceID: InstanceID || '',
            isSync: true
        });
    },
    resetModify: function (InstanceID,State) {
    	return iEmrPlugin.RESET_MODIFY_STATE({
            InstanceID: InstanceID || "",
            State: State || false,
            isSync: true
        });
	},
    getDocContext: function (InstanceID) {
        //刷新权限
        iEmrPlugin.UPDATE_PRIVILEGE({
             InstanceID: InstanceID || '',
            isSync: true
        });
        
        envVar.docContext = iEmrPlugin.GET_DOCUMENT_CONTEXT({
                InstanceID: InstanceID || '',
                isSync: true
            });
        return envVar.docContext;
    },
    getDocWithoutPrivilege: function (InstanceID) {        
        envVar.docContext = iEmrPlugin.GET_DOCUMENT_CONTEXT({
                InstanceID: InstanceID || '',
                isSync: true
            });
        return envVar.docContext;
    },
    getInstanceID: function () {
        this.getDocWithoutPrivilege('');
        if (!envVar.docContext)
            return '';
        return (envVar.docContext.InstanceID || '');
    },
    //保存文档，正常执行返回true,
    //p1：编辑器文档信息  p2：回调函数，异步保存时传入    p3：是否同步保存，不传默认异步     p4：是否自动保存动作，默认不是
    saveDoc: function (documentContext, callback, isSync, isAutoSave) {
        isSync = isSync||false;
        isAutoSave = isAutoSave||false;
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;

        if (!isConsistent(documentContext)) {
            if ('function' === typeof callback) {
                callback({
                    result: false
                });
            }
            return;
        }
        
        if (!privilege.canSave(documentContext)) {
            if ('function' === typeof callback)
                callback({
                    result: false
                });
            return;
        }

        var modifyResult = this.getModifyResult(documentContext.InstanceID);
        /*if (this.createAsLoad && modifyResult.Modified != 'True') {
            iEmrPlugin.RESET_MODIFY_STATE({
                InstanceID: '',
                State: true
            });
            this.createAsLoad = false;
        }
        modifyResult = iEmrPlugin.CHECK_DOCUMENT_MODIFY({
                isSync: true
            });
        */
        if ('False' === modifyResult.Modified) {
            if(!isAutoSave)
                showEditorMsg({msg:'文档没有发生改变！', type:'info'});
            if (typeof callback === 'function') {
                callback({
                    result: false
                });
            }
            return;
        }
        
        var returnFlag = false ;
        if ((quality.requiredObject('Save')) && ('' !== sysOption.ReturnTemplateIDs)) {
            common.getTemplateIDByInsId(documentContext.InstanceID, function(tmpId) {
                if (sysOption.ReturnTemplateIDs.indexOf('^' + tmpId + '^') != '-1') {
                    returnFlag = true;    
                    if ('function' === typeof callback)
                        callback({result: false});                
                }
            });
            if (returnFlag) return;
        }
        
        var escapeRevokeSignDocIDArray = new Array(); 
        escapeRevokeSignDocIDArray = sysOption.escapeRevokeSignDocID.split("^");
        var flag = false;
        var instance = emrEditor.getDocContext();
        var _this = this;
        common.GetRecodeParamByInsIDSync(instance.InstanceID,function(param){
            if ($.inArray(param.emrDocId,escapeRevokeSignDocIDArray) == -1)
            {
                flag = _this.doRevokeSignedDocument(modifyResult);
            }
            if (!flag) {
                //editorEvt.evtAfterSave = callback;
                //调用平台方法，用途锁定头菜单
                setSysMenuDoingSth('病历保存中...');
                ///异步、同步保存病历
                if (!isSync) {
                    editorEvt.evtAfterSave = callback;
                    iEmrPlugin.SAVE_DOCUMENT();
                } else {
                    var saveResult = iEmrPlugin.SAVE_DOCUMENT({
                        isSync: true
                    });
                    if (saveResult.result === 'OK') {
                        setSysMenuDoingSth();
                        SaveDocumentAfter(documentContext.InstanceID);
                        var insId = documentContext.InstanceID;
                        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', insId);
                        ajaxGETSync(data, function (ret) {
                            if (ret !== "") {
                                common.GetSyncSavedFirstMultiRecord(ret, insId, function(insData) {
                                    //是否存在Tab签，是：选中Tab签，否：新增并选中Tab签
                                    var tabId = emrTemplate.getTabId(insData.templateId, insData.id);
                                    var isSelected = false;
                                    if ('1' == insData.isLeadframe) {
                                        isSelected = true;
                                    }
                                    //结核病历
                                    if (sysOption.PhthisisEpisodeIDs !== "") {
                                        if (-1 != $.inArray(ret, sysOption.PhthisisEpisodeIDs.split(","))) {
                                            insData["epsiodeId"] = ret;
                                            documentContext["insData"] = insData;
                                            //修改结核病历目录
                                            phthisisFun(documentContext,"modifyListRecord");
                                        }
                                    }
                                    if (!emrTemplate.selectTmplTab(tabId, isSelected)) {
                                        envVar.savedRecords.push(insData);
                                        emrTemplate.addTab(insData.templateId, insData.id, insData.text, true, '1' == insData.isLeadframe);
                                    }
                                });
                            }
                        }, function (ret) {
                            alert('保存时，getAdmByInstanceID error:' + ret);
                        });
                        if ('function' === typeof callback)
                        {
                            callback({result: false}); 
                        }
                    }
                }
                return;
            }
            return;
        });
    },
    //打印 ： printArg Print/PrintDirectly
    printDoc: function (printArg, documentContext) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;
        var printList = iEmrPlugin.GET_PRINT_DOC_INSTANCEID_LIST({isSync: true});
        var instanceIds = printList.items;
        var printFlag = false;
        for (var i = 0; i < instanceIds.length; i++) {
            var tmpInstanceID = instanceIds[i].InstanceID;
            var document = this.getDocContext(tmpInstanceID);
            if (!privilege.canPrint(document)) {
                printFlag = true;
                break;
            }
        }
        if (printFlag) {
            return;
        }

        var instanceId = emrEditor.getInstanceID();
        if (instanceId === '') return;
        var id = common.isPrinted(instanceId);
        if (id == '1') {
            var titleName = documentContext.Title.DisplayName;
            var text = '病历 "' + titleName + '" 已打印，是否再次打印';
            var dialogId = "printDialog";
            var iframeId = "opdocPrint";
            var src = "emr.opdoc.printPrompt.csp?prompt="+text+"&dialogId="+dialogId+"&printArg="+printArg+"&MWToken="+getMWToken();
            var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
            createModalDialog(dialogId,"打印提示框", 350, 130,iframeId,iframeCotent,printDocumentCheck);
        }else{
            printDocumentCheck(printArg);
        }
    },
    //删除
    deleteDoc: function (documentContext) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;

        if (!privilege.canDelete(documentContext)) {
            return;
        }
        var tipMsg = emrTrans('确定删除')+ '【' + emrTrans(documentContext.Title.DisplayName) + '】?'
        top.$.messager.confirm("操作提示", tipMsg, function (data) {
            if (data)
            {
                var creatorMessage = common.getCreatorMessage(documentContext.InstanceID);
                //判断是否要求验证密码
                if ((sysOption.isDeleteVerification == "Y")&&(creatorMessage.status != "UNSAVE"))
                {
                    if (creatorMessage != "")
                    {
                        if ((creatorMessage.creatorID != "")&&(creatorMessage.creatorName != ""))
                        {    
                            //定义回调函数
                            var deleteCallBacke = function(returnValue,arr){
                                if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
                                {
                                    return ;
                                }
                                else if(returnValue == "0")
                                {
                                    top.$.messager.alert("提示信息", "密码验证失败");
                                    return ;
                                }
                                iEmrPlugin.DELETE_DOCUMENT({
                                    InstanceID: arr.InstanceID
                                });
                            }
                            var arr = {"InstanceID":documentContext.InstanceID};
                            createModalDialog("deleteDialog","删除","265","250","iframeDelete","<iframe id='iframeDelete' scrolling='auto' frameborder='0' src='emr.ip.userverification.delete.csp?UserID="+creatorMessage.creatorID+"&UserName="+base64encode(utf16to8(encodeURI(creatorMessage.creatorName)))+"&MWToken="+getMWToken()+"' style='width:255px; height:210px; display:block;'></iframe>",deleteCallBacke,arr)
                        }
                    }
                }
                else
                {
                    iEmrPlugin.DELETE_DOCUMENT({
                        InstanceID: documentContext.InstanceID
                    });
                }
            }
            else 
            {   
                return ;
            }
        });
    },
    createDocMain: function (docParam) {
        if (typeof(docParam.TemplateType !== 'undefined'))
        {
            if (docParam.TemplateType == 'OpUserTemplate')
            {
                this.createByUserTempalte(docParam);
            }
            else
            {
                this.createDoc(docParam);
            }
        }
        else
        {
            this.createDoc(docParam);
        }
    },
    //新建文档
    createDoc: function (docParam) {
        param = docParam;
        if (docParam == null)
            return;
        _paramNow = docParam;
        sysOption.pluginType = docParam.pluginType;
        var isSetPlugin = emrEditor.setPlugin(docParam.chartItemType);
        if(!isSetPlugin)return;
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        var isMutex = (docParam.isMutex === '1') ? true : false;
        var isGuideBox = (docParam.isLeadframe === '1') ? true : false;
        //设置引导框
        iEmrPlugin.SET_DOCUMENT_TEMPLATE({
            DocID: docParam.emrDocId,
            IsMutex: isMutex,
            CreateGuideBox: isGuideBox
        });
        if ('Single' == docParam.chartItemType) {
            setSysMenuDoingSth('病历创建中...');
            iEmrPlugin.CREATE_DOCUMENT({
                DisplayName: docParam.text
            });
        }else {
            var defaultLoadId = common.getDefaultLoadId(docParam.emrDocId, patInfo.UserLocID);
            if (defaultLoadId == "") {
                if (!isGuideBox) {
                    setSysMenuDoingSth('病历创建中...');
                    iEmrPlugin.CREATE_DOCUMENT({
                        DisplayName: docParam.text
                    });
                } else {
                    iEmrPlugin.FOCUS_ELEMENT({
                        Path: '',
                        InstanceID: 'GuideDocument',
                        actionType: 'First'
                    });
                }
            }
            else {
                setSysMenuDoingSth('病历创建中...');
                iEmrPlugin.CREATE_DOCUMENT_BY_TITLE({
                    TitleCode: defaultLoadId
                });    
            }  
        }
        // Zhangxy 根据用户设置进行缩放
        if(isShowScaleSliderBtn == "Y") iEmrPlugin.ZOOM_DOCUMENT(envVar.OPScaling);  
        //自动记录病例操作日志
        hisLog.create('EMR.OP.CreateDoc',docParam);
    },
    //科室模板
    createByUserTempalte: function (docParam){
        if (docParam == null)
            return;
        sysOption.pluginType = docParam.pluginType;
        emrEditor.setPlugin(docParam.chartItemType);
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        var isMutex = (docParam.isMutex === '1') ? true : false;
        var isGuideBox = (docParam.isLeadframe === '1') ? true : false;
        //设置引导框
        iEmrPlugin.SET_DOCUMENT_TEMPLATE({
            DocID: docParam.emrDocId,
            IsMutex: isMutex,
            CreateGuideBox: isGuideBox
        });
        setSysMenuDoingSth('病历创建中...');
        iEmrPlugin.CREATE_DOCUMENT_BY_USERTEMPLATE({
            DisplayName: docParam.text,
            ExampleInstanceID:docParam.ExampleInstanceID
        }); 
        // Zhangxy 根据用户设置进行缩放
        if(isShowScaleSliderBtn == "Y") iEmrPlugin.ZOOM_DOCUMENT(envVar.OPScaling);   
        //自动记录病例操作日志
        hisLog.create('EMR.OP.CreateDoc',docParam);
    },
    //个人模板
    createByPersonalTempalte:function(docParam){
        if (docParam == null) return; 
        sysOption.pluginType = docParam.pluginType;
        emrEditor.setPlugin(docParam.chartItemType);
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        
        var isMutex = (docParam.isMutex === '1') ? true : false;
        var isGuideBox = (docParam.isLeadframe === '1') ? true : false;
        //设置引导框
        iEmrPlugin.SET_DOCUMENT_TEMPLATE({
            DocID: docParam.emrDocId,
            IsMutex: isMutex,
            CreateGuideBox: isGuideBox
        });
        setSysMenuDoingSth('病历创建中...');
        iEmrPlugin.CREATE_DOCUMENT_PERSONAL_TEMPLATE({
            DisplayName: docParam.text,
            ExampleInstanceID:docParam.ExampleInstanceID,
            TitleCode : docParam.TitleCode
        });
        //自动记录病例操作日志
        hisLog.create('EMR.OP.CreateDoc',docParam);
    },
    isOpened: function (docParam) {
        if (!iEmrPlugin.getPlugin()) {
            return false;
        }

        var documentContext = this.getDocWithoutPrivilege();
        if (!documentContext || 'ERROR' === documentContext.result) {
            return false;
        }

        if ('Single' == docParam.chartItemType || '1' != docParam.isLeadframe) {
            if (documentContext.InstanceID == docParam.id) {
                return true;
            }
        } else {
            if (documentContext.InstanceID.split('-')[0] == docParam.id.split('-')[0])
                return true;
        }
    },
    //加载文档
    loadDoc: function (docParam) {
        if (docParam == null)
            return;
        
        //加载pdf格式病历
        var pdfDocType = docParam.pdfDocType || "XML";
        var isReload = docParam.reLoad || "0";
        if (pdfDocType == "PDF") {
            this.loadPDFDoc(docParam);
            return;
        }
        
        //(1)引入范例病历之后，只能用实例id来判断；
        //(2)虽然加载的instanceID不变，但病历格式可能由PDF变更为编辑器xml，此时isReload为1，需要重新加载病历
        if (this.isOpened(docParam)&&(isReload == "0"))
            return;
        _paramNow = docParam;
        sysOption.pluginType = docParam.pluginType;
        var isSetPlugin = this.setPlugin(docParam.chartItemType);
        if(!isSetPlugin)return;
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        if (privilege.getViewPrivilege(docParam).canView == '0') {
            var message = '您没有权限查看此病历！' + privilege.getViewPrivilege(docParam).cantViewReason;
            showEditorMsg({msg:message,type:'alert'});
            setPnlBtnDisable(false);
            return;
        }
        setSysMenuDoingSth('病历加载中...');
        iEmrPlugin.LOAD_DOCUMENT({
            status: docParam.status,
            InstanceID: docParam.id,
            actionType: docParam.actionType
        });

        if (docParam.status === 'DELETE') {
            iEmrPlugin.SET_READONLY({
                ReadOnly: true,
                InstanceID: docParam.id
            });
        }        
    // Zhangxy 根据用户设置进行缩放
    if(isShowScaleSliderBtn == "Y") iEmrPlugin.ZOOM_DOCUMENT(envVar.OPScaling);
        //自动记录病例操作日志
        hisLog.operate('EMR.OP.LoadDoc',docParam);
        //加载病历调用CDSS
        cdssParam(docParam,"Save");
    },
    //加载文档
    loadPDFDoc: function (docParam) {
        if (docParam == null)
            return;
            
        var pdfDocType = docParam.pdfDocType || "XML";
        var isReload = docParam.reLoad || "0";
        
        //引入范例病历之后，只能用实例id来判断
        if (this.isOpened(docParam) && isReload == "0")
            return;
        _paramNow = docParam;
        
        sysOption.pluginType = docParam.pluginType;
        if (pdfDocType == "PDF") {
            sysOption.pluginType = "DOC";
        }
        var isSetPlugin = this.setPlugin(docParam.chartItemType);
        if(!isSetPlugin)return;
        
        iEmrPlugin.CLEAN_DOCUMENT();
        
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        if (privilege.getViewPrivilege(docParam).canView == '0') {
            var message = '您没有权限查看此病历！' + privilege.getViewPrivilege(docParam).cantViewReason;
            showEditorMsg({msg:message,type:'alert'});
            setPnlBtnDisable(false);
            return;
        }
        setSysMenuDoingSth('病历加载中...');
        iEmrPlugin.LOAD_DOCUMENT({
            status: docParam.status,
            InstanceID: docParam.id,
            actionType: docParam.actionType,
            LoadType: pdfDocType
        });

        if (docParam.status === 'DELETE') {
            iEmrPlugin.SET_READONLY({
                ReadOnly: true,
                InstanceID: docParam.id
            });
        }
        //自动记录病例操作日志
        hisLog.operate('EMR.OP.LoadDoc',docParam);
        //加载病历调用CDSS
        cdssParam(docParam,"Save");
    },
    cleanDoc: function () {
        iEmrPlugin.CLEAN_DOCUMENT();
    },
    // 失效病历的时候会同时向后台保存文档的，返回值影响后续保存操作
    // 执行了撤销或是出现异常的情况下，返回True 、其他情况返回False
    doRevokeSignedDocument: function (modifyResult,type) {
        // 参数配置是否开启签名失效，配置参数为N时不开启撤销签名
        if (sysOption.isRevokeSign === 'N')
            return false;
        // 系统参数 EscapeRevokeSignDocID系统启用签名失效后，有个别模板想屏蔽签名失效
        var insID = emrEditor.getInstanceID();
        if ((insID != '')&&(sysOption.escapeRevokeSignDocID != ''))
        {
            var emrDocId = "";
            common.GetRecodeParamByInsIDSync(insID, function(tempParam) {
                emrDocId = tempParam.emrDocId;
            });
            var escapeRevokeSignDocIDArray = new Array(); 
            escapeRevokeSignDocIDArray = sysOption.escapeRevokeSignDocID.split("^");
            if ($.inArray(emrDocId,escapeRevokeSignDocIDArray) > -1)
                return false;
        }
        var that = this;
        var result = false;
        var revokeSigned = false;
        var revokeStatus = privilege.GetRevokeStatus();
        for (var i = 0; i < modifyResult.InstanceID.length; i++) {
            var instanceId = modifyResult.InstanceID[i];
            var tmpDocContext = that.getDocContext(instanceId);
               if (!privilege.canSave(tmpDocContext))
                continue;
            
            var userLevel = common.getUserInfo().UserLevel;
            if (revokeStatus != 'Superior')
                userLevel = '';
            var revokeResult = iEmrPlugin.REVOKE_SIGNED_DOCUMENT({
                    SignatureLevel: userLevel,
                    InstanceID: instanceId,
                    isSync: true
                });
            if (revokeResult.result === 'ERROR') {
                showEditorMsg({msg:'撤销文档签名失败！', type:'error'});
                if (!result) {
                    result = true;
                    revokeSigned = false;
                }
                break;
            } else {
                if (typeof(revokeResult.Authenticator) === "undefined" || revokeResult.Authenticator.length <= 0) {
                    continue;
                }
                //showEditorMsg({msg:'文档签名已经被撤销！', type:'info'});
                
                if (tmpDocContext.result == 'ERROR' && !result) {
                    result = true;
                    revokeSigned = false;
                }else{
                    revokeSigned = true;
                }
                showEditorMsg({msg:'数据保存成功,签名已失效！', type:'success'});
                
                //保存后的操作
                SaveDocumentAfter(instanceId);
                common.getSavedRecords(function (ret) {
                    envVar.savedRecords = $.parseJSON(ret);
                    common.getTemplateIDByInsId(instanceId, function (tmpId) {
                        emrTemplate.loadTmplTabs(envVar.savedRecords, tmpId, instanceId);
                    });
                });
                //结核病历
                if (sysOption.PhthisisEpisodeIDs !== "") {
                    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', instanceId);
                    ajaxGETSync(data, function (ret) {
                        if (ret !== "") {
                            if (-1 != $.inArray(ret, sysOption.PhthisisEpisodeIDs.split(","))) {
                                common.GetSavedFirstMultiRecord(ret, instanceId, function(insData) {
                                    insData["epsiodeId"] = ret;
                                    tmpDocContext["insData"] = insData;
                                    //修改结核病历目录
                                    phthisisFun(documentContext,"modifyListRecord");
                                });
                            }
                        }
                    }, function (ret) {
                        alert('撤销签名时，getAdmByInstanceID error:' + ret);
                    });
                }
            }
        }
        if (revokeSigned && type != "switch"){
            if (sysOption.isPromptRevokeSigned === "Y"){
                var oldOk = $.messager.defaults.ok;
                var oldCancel = $.messager.defaults.cancel;
                $.messager.defaults.ok = "是";
                $.messager.defaults.cancel = "否";
                top.$.messager.confirm("提示", "签名已失效，是否重新签名？", function (r) {
                    if (r){
                        if (isExistFunc(parent.switchTabByEMR)){
                            parent.switchTabByEMR(menuName);
                        }
                        iEmrPlugin.FOCUS_ELEMENT({
                            Path: '',
                            InstanceID: insID,
                            actionType: 'Last'
                        });
                    } else {}
                    $.messager.defaults.ok = oldOk;
                    $.messager.defaults.cancel = oldCancel;
                });
            }
        }

        return result;
    },
    ///初始化页面
    initDocument: function (autoLoadTmp) {
        emrTemplate.closeAllTabs();
        if (envVar.versionID && (envVar.versionID != '3')){
            setPnlBtnDisable(true);
            setPnlBtnEditHide(true);
            setSysMenuDoingSth("");
            $.messager.alert("提示", "该患者已经书写"+envVar.versionID+"版病历，不能再书写3版病历", "info");
            return;
        }
        if (envVar.savedRecords.length > 0) {
            var docParam = envVar.savedRecords[0];
            if (docParam == null) setReadonly(true);
            if (CopyOeoris !== '')
            {
                pasteRefData(CopyOeoris);
            }else{
                this.loadDoc(docParam);
            }
            emrTemplate.loadTmplTabs(envVar.savedRecords, docParam.templateId, docParam.id);
        } else if (autoLoadTmp || true) {
            if (sysOption.isAutoSelectTemplate === 'Y' && patInfo.EpisodeID !== '') {
                showTemplateTree(true);
                return;
            }
            if ( envVar.firstTmpl == null) {
                if (patInfo.EpisodeID !== '')
                    alert('未找到默认病历模板！');
                //$.messager.alert('提示', '未找到默认病历模板！', 'info');
                setPnlBtnDisable(true);
                setPnlBtnEditHide(true);
                setSysMenuDoingSth();
                return;
            }
            if (CopyOeoris !== '')
            {
                pasteRefData(CopyOeoris);
            }else{
                this.createDocMain(envVar.firstTmpl);
            }
        }
    },
    ///初始化页面时默认弹出模板选择页面，用户直接关闭则创建默认模板
    showTemplateTreeAfter: function () {
        if ( envVar.firstTmpl == null) {
            if (patInfo.EpisodeID !== '')
                alert('未找到默认病历模板！');
            //$.messager.alert('提示', '未找到默认病历模板！', 'info');
            setPnlBtnDisable(true);
            setPnlBtnEditHide(true);
            setSysMenuDoingSth();
            return;
        }
        if (CopyOeoris !== '')
        {
            pasteRefData(CopyOeoris);
        }else{
            this.createDocMain(envVar.firstTmpl);
        }
    },
    reloadBinddata: function (insID) {
        //return;
        insID = insID || emrEditor.getInstanceID();
        //显示同步提示框
        iEmrPlugin.REFRESH_REFERENCEDATA({
            InstanceID: insID || '',
            AutoRefresh: true,
            SyncDialogVisible: true
        });
        common.GetRecodeParamByInsID(insID, function(tempParam) {
            //自动记录病例操作日志
            hisLog.operate('EMR.OP.BinddataReload',tempParam);
        });
        /*//获取是否显示同步提示框状态
        var data = ajaxDATA('String', 'EMRservice.BL.BLRefreshBindData', 'getBindDataSyncDialogVisible', insID);
        ajaxGET(data, function (ret) {
            if (ret !== '') {
                if (ret === 'True') {
                    //显示同步提示框
                    iEmrPlugin.REFRESH_REFERENCEDATA({
                        InstanceID: insID || '',
                        AutoRefresh: true,
                        SyncDialogVisible: true
                    });
                    common.GetRecodeParamByInsID(insID, function(tempParam) {
                        //自动记录病例操作日志
                        hisLog.operate('EMR.OP.BinddataReload',tempParam);
                    });
                } *** else if (ret === 'False') {
                    //不显示同步提示框
                    iEmrPlugin.REFRESH_REFERENCEDATA({
                        InstanceID: insID || '',
                        AutoRefresh: true,
                        SyncDialogVisible: false
                    });
                } ***
            }
        }, function (ret) {
            //$.messager.alert('发生错误', 'getBindDataSyncDialogVisible error:' + ret, 'error');
            alert('getBindDataSyncDialogVisible error:' + ret);
        });*/
    },
    setEditorReadonly: function (documentContext) {
        setPnlBtnDisable(false);
        
        var flag = isReadonly();
        if (flag) {
            iEmrPlugin.SET_READONLY({
                ReadOnly: true
            });
        } else {
            documentContext = documentContext || emrEditor.getDocContext();
            flag = !privilege.canSave(documentContext);
            iEmrPlugin.SET_READONLY({
                ReadOnly: flag
            });
        }
    },
    setEditorReadonlyByprivilege: function (documentContext) {
        documentContext = documentContext || emrEditor.getDocContext();
        flag = !privilege.canSave(documentContext);
        iEmrPlugin.SET_READONLY({
            ReadOnly: flag
        });
    },
    setPlugin: function (chartItemType) {
        if (sysOption.pluginType === 'DOC') {
            iEmrPlugin.showWord();
            var isSetPlugin = iEmrPlugin.attachWord(sysOption.pluginUrl, sysOption.pluginType, editorEvt.eventDispatch);
            if(!isSetPlugin) return isSetPlugin;
            var fontStyle = $.parseJSON("{" + sysOption.setDefaultFontStyle.replace(/\'/g, "\"") + "}");
            iEmrPlugin.SET_DEFAULT_FONTSTYLE({
                args: fontStyle
            });
            iEmrPlugin.setWorkEnvironment(chartItemType);
            //setCurrentRevisor(userID, userName, getIpAddress());
            iEmrPlugin.SET_CURRENT_REVISOR({
                Id: patInfo.UserID,
                Name: patInfo.UserName,
                IP: patInfo.IPAddress
            });
            setRunEMRParams();
            return true;
        } else {
            iEmrPlugin.showGrid();
            var isSetPlugin = iEmrPlugin.attachGrid(sysOption.pluginUrl, sysOption.pluginType, editorEvt.eventDispatch);
            setRunEMRParams();
            if(!isSetPlugin) return isSetPlugin;
            return true;
        }
    },
    /// 对外接口 异步执行
    cmdPlugin: function (action, argParams) {
        var fn = iEmrPlugin[action];
        if (typeof fn !== 'function')
            throw ('未实现方法：' + action);
        argParams = argParams || {};
        argParams['isSync'] = false;
        fn.apply(iEmrPlugin, argParams);
    },
    /// 对外接口 同步执行
    cmdPluginSync: function (action, argParams) {

        var fn = iEmrPlugin[action];
        if (typeof fn !== 'function')
            throw ('未实现方法：' + action);
        argParams = argParams || {};
        argParams['isSync'] = true;
        return fn.apply(iEmrPlugin, argParams);
    },
    /// 病历引用
    createDocFromInstance: function (insData) {
        var docID = common.getEmrDocId(insData.emrDocId);
        if (docID === '0') {
            top.$.messager.alert('警示', '无创建此病历模板权限，请检查模板权限配置！'+ insData.emrDocId, 'warning');
            //alert('无创建此病历模板权限，请检查模板权限配置！'+ insData.emrDocId);
            return;
        }
        
        var ret = common.IsAllowMuteCreate(insData.emrDocId);
        if (ret === '0')
        {
            top.$.messager.alert('警示', '已创建同类型模板，不允许继续创建！', 'warning');
            //alert('已创建同类型模板，不允许继续创建！');
            return;
        }
        
        var that = this;
        function createDocByInstance(insData) {
            var insID = insData.id
            var titleCode = insData.titleCode || '';
            sysOption.pluginType = insData.pluginType;
            that.setPlugin(insData.chartItemType);
            
            //逻辑变更为正常创建，通过绑定实现引用，传入要引用的历史实例ID  LastInsID
            var _patInfo = {};
            for (var key in patInfo) {
                _patInfo[key] = patInfo[key];
            }
            _patInfo['LastInsID'] = insID;
            iEmrPlugin.SET_PATIENT_INFO({
                args: _patInfo
            });
            iEmrPlugin.SET_CURRENT_REVISOR({
                Id: patInfo.UserID,
                Name: patInfo.UserName,
                IP: patInfo.IPAddress
            });
            var isMutex = (insData.isMutex === '1') ? true : false;
            var isGuideBox = (insData.isLeadframe === '1') ? true : false;
            //设置引导框
            iEmrPlugin.SET_DOCUMENT_TEMPLATE({
                DocID: insData.emrDocId,
                IsMutex: isMutex,
                CreateGuideBox: isGuideBox
            });
            
            if ('Single' == insData.chartItemType) {
                setSysMenuDoingSth('病历创建中...');
                iEmrPlugin.CREATE_DOCUMENT({
                    DisplayName: insData.text
                });
            } else {
                if (titleCode == "") {
                    var defaultLoadId = common.getDefaultLoadId(insData.emrDocId, patInfo.UserLocID);
                } else {
                    var defaultLoadId = titleCode;
                }
                
                if (defaultLoadId == "") {
                    if (!isGuideBox) {
                        setSysMenuDoingSth('病历创建中...');
                        iEmrPlugin.CREATE_DOCUMENT({
                            DisplayName: insData.text
                        });
                    } else {
                        iEmrPlugin.FOCUS_ELEMENT({
                            Path: '',
                            InstanceID: 'GuideDocument',
                            actionType: 'First'
                        });
                    }
                } else {
                    setSysMenuDoingSth('病历创建中...');
                    iEmrPlugin.CREATE_DOCUMENT_BY_TITLE({
                        TitleCode: defaultLoadId
                    });    
                }  
            } 
            
            //新建病历后取消实例页签的选中状态
            emrTemplate.unselectTmplTab();
            // Zhangxy 根据用户设置进行缩放
            if(isShowScaleSliderBtn == "Y") iEmrPlugin.ZOOM_DOCUMENT(envVar.OPScaling); 
            //自动记录病例操作日志
            hisLog.create('EMR.OP.AdmHistoryLst.CreateDoc',insData);
        }

        //如果无实例，则直接创建
        id = common.IsExistInstance(insData.emrDocId);
        if ("0" == id) {
            createDocByInstance(insData);
            return;
        }

        if ('Single' == insData.chartItemType) { // 唯一模板
            var tabId = emrTemplate.getTabId(insData.templateId, id);
            emrTemplate.selectTmplTab(tabId,false);
            top.$.messager.confirm("警示", "已经创建同类型的文档，确定删除【" + insData.text + "】并重新创建?", function (r) {
                if (r) {
                    var documentContext = that.getDocContext(id);
                    if (!documentContext)
                        return;
                    if (!privilege.canDelete(documentContext)) {
                        return;
                    }
                    var creatorMessage = common.getCreatorMessage(documentContext.InstanceID);
                    //判断是否要求验证密码
                    if ((sysOption.isDeleteVerification == "Y")&&(creatorMessage.status != "UNSAVE"))
                    {
                        if (creatorMessage != "")
                        {
                            if ((creatorMessage.creatorID != "")&&(creatorMessage.creatorName != ""))
                            {    
                                //定义回调函数
                                var deleteCallBacke = function(returnValue,arr){
                                    if ((returnValue == "")||(typeof(returnValue) == "undefined")) 
                                    {
                                        return ;
                                    }
                                    else if(returnValue == "0")
                                    {
                                        top.$.messager.alert("提示信息", "密码验证失败");
                                        return ;
                                    }
                                    var rtn = iEmrPlugin.DELETE_DOCUMENT({
                                        InstanceID: arr.InstanceID,
                                        isSync: true
                                    });
                                    
                                    if (rtn.result === 'OK') {
                                        //刷新历史就诊列表
                                        refreshAdmHistory();
                                        common.GetRecodeParamByInsID(rtn.InstanceID, function(tempParam) {
                                            //自动记录病例操作日志
                                            hisLog.operate('EMR.OP.Delete.OK',tempParam);
                                        });
                                        // 移除记录
                                        $.each(envVar.savedRecords, function(idx, item) {
                                            if (rtn.InstanceID === item.id) {
                                                envVar.savedRecords.splice(idx, 1);
                                                emrTemplate.closeCurTmplsTab();
                                                return false; //break
                                            }
                                        });
                                        createDocByInstance(arr.InsData);
                                    }
                                }
                                var arr = {"InstanceID":documentContext.InstanceID,"InsData":insData};
                                createModalDialog("deleteDialog","删除","265","250","iframeDelete","<iframe id='iframeDelete' scrolling='auto' frameborder='0' src='emr.ip.userverification.delete.csp?UserID="+creatorMessage.creatorID+"&UserName="+base64encode(utf16to8(encodeURI(creatorMessage.creatorName)))+"&MWToken="+getMWToken()+"' style='width:255px; height:210px; display:block;'></iframe>",deleteCallBacke,arr)
                            }
                        }
                    }
                    else
                    {
                        var rtn = iEmrPlugin.DELETE_DOCUMENT({
                            InstanceID: documentContext.InstanceID,
                            isSync: true
                        });
                        
                        if (rtn.result === 'OK') {
                            common.GetRecodeParamByInsID(rtn.InstanceID, function(tempParam) {
                                //自动记录病例操作日志
                                hisLog.operate('EMR.OP.Delete.OK',tempParam);
                            });
                            // 移除记录
                            $.each(envVar.savedRecords, function(idx, item) {
                                if (rtn.InstanceID === item.id) {
                                    envVar.savedRecords.splice(idx, 1);
                                    emrTemplate.closeCurTmplsTab();
                                    return false; //break
                                }
                            });
                            createDocByInstance(insData);
                        }
                    }
                } else {
                    return;
                }
            });
            return;
        } else if ('1' == insData.isLeadframe) { // 带引导框的可重复
            var isTitleUniqueCreate = common.isTitleUniqueCreate(insData.titleCode);
            var tabId = emrTemplate.getTabId(insData.templateId, id);
            if ((emrTemplate.selectTmplTab(tabId, true))&&(isTitleUniqueCreate == "1"))
            {
                showEditorMsg({msg:'此文档不允许重复创建，将切换到已保存的文档！',type:'alert'});
                //$.messager.alert('提示', '此文档不允许重复创建，将切换到已保存的文档！', 'info');  
                return;    
            }
            createDocByInstance(insData);
        } else { // 不带引导框的可重复
            createDocByInstance(insData);
        }
    },
    confirmAndSave: function (fnConfirm, isSync, documentContext) {
        setSysMenuDoingSth("");
        isSync = isSync || false;
        
        documentContext = documentContext || this.getDocContext();
        //设置默认打开模板选择页面时，编辑器未加载，此时调用相关命令返回undefined
        if (typeof documentContext == "undefined")
            return false;        
        
        //页面只读则不允许保存，无需提示保存
        if (getReadOnlyStatus().ReadOnly == "True")
            return false;
        
        var modifyResult = this.getModifyResult(documentContext.InstanceID);
        if (modifyResult.Modified !== 'True')
            return false;
        
        if (!privilege.canSave(documentContext))
            return false;

        var returnFlag = false ;
        if ((quality.requiredObject('Save')) && ('' !== sysOption.ReturnTemplateIDs)) {
            common.getTemplateIDByInsId(documentContext.InstanceID, function(tmpId) {
                if (sysOption.ReturnTemplateIDs.indexOf('^' + tmpId + '^') != '-1') {
                    returnFlag = true;              
                }
            });
            if (returnFlag) return;
        }
        
        if (typeof fnConfirm === 'function') {
            if (!fnConfirm(documentContext)) {
                iEmrPlugin.RESET_MODIFY_STATE({
                    InstanceID: documentContext.InstanceID,
                    State: false
                });
                
                //解锁
                unlockByIns(documentContext.InstanceID);
                
                return false;
            }
            
            if (!isConsistent(documentContext))
                return false;
            
            var flag = this.doRevokeSignedDocument(modifyResult);

            if (!flag) {
                if (!isSync) {
                    iEmrPlugin.SAVE_DOCUMENT();
                } else {
                    var saveResult = iEmrPlugin.SAVE_DOCUMENT({
                        isSync: true
                    });
                    if (saveResult.result === 'OK') {
                        SaveDocumentAfter(documentContext.InstanceID);
                        
                        var insId = documentContext.InstanceID;
                        //结核病历保存后调用方法
                        PhthisisSaveFunc(documentContext, insId);
                    }
                }
                return true;
            }
        }
        return false;
    },
    /// true：Save，false：Unsave
    saveConfirm: function (isSync, documentContext) {
        var ret = false;
        var fnSaveConfirm = function (documentContext) {
            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
            ret = confirm(msgText);
            return ret;
        };
        this.confirmAndSave(fnSaveConfirm, isSync, documentContext);
        return ret;
    },
    //增加方法 用于改造弹出的"有修改，是否保存？"提示为HISUI样式
    confirmAndSaveAsync: function (callback, arr) {
        setSysMenuDoingSth("");
        
        var documentContext = emrEditor.getDocContext();
        //设置默认打开模板选择页面时，编辑器未加载，此时调用相关命令返回undefined
        if (typeof documentContext == "undefined"){
            callback(arr);        
            return;
        }
        
        //页面只读则不允许保存，无需提示保存
        if (getReadOnlyStatus().ReadOnly == "True") {
            callback(arr);
            return;
        }
        
        var modifyResult = emrEditor.getModifyResult(documentContext.InstanceID);
        if (modifyResult.Modified !== 'True') {
            callback(arr);
            return;
        }
        
        if (!privilege.canSave(documentContext)) {
            callback(arr);
            return;
        }

        var returnFlag = false ;
        if ((quality.requiredObject('Save')) && ('' !== sysOption.ReturnTemplateIDs)) {
            common.getTemplateIDByInsId(documentContext.InstanceID, function(tmpId) {
                if (sysOption.ReturnTemplateIDs.indexOf('^' + tmpId + '^') != '-1') {
                    returnFlag = true;              
                }
            });
            if (returnFlag) {
                callback(arr);
                return;
            }
        }
        
        //提示保存
        top.$.messager.confirm("操作提示", "病历有修改，是否保存？", function (data) { 
            if(data) {
                if (!isConsistent(documentContext)) {
                    callback(arr);
                    return;
                }
                
                var flag = emrEditor.doRevokeSignedDocument(modifyResult,"switch");
                if (!flag) {
                    var saveResult = iEmrPlugin.SAVE_DOCUMENT({
                        isSync: true
                    });
                    if (saveResult.result === 'OK') {
                        SaveDocumentAfter(documentContext.InstanceID);
                        
                        var insId = documentContext.InstanceID;
                        //结核病历保存后调用方法
                        PhthisisSaveFunc(documentContext, insId);
                        callback(arr);
                        return;
                    }
                    callback(arr);
                }
            } else {
                iEmrPlugin.RESET_MODIFY_STATE({
                    InstanceID: documentContext.InstanceID,
                    State: false
                });
                
                //解锁
                unlockByIns(documentContext.InstanceID);
                callback(arr);
            }
        });
    },
    getHyperLinkPath: function (items, displayName) {
        if (typeof items === 'undefined')
            return '';
        for (var i = 0; i < items.length; i++) {
            if (items[i].DisplayName.indexOf(displayName) > -1 && items[i].Type === 'MILink') {
                return items[i].Code;
            }
            var ret = emrEditor.getHyperLinkPath(items[i].items, displayName);
            if (ret !== '') {
                return items[i].Code + '_' + ret;
            }
        }
        return '';
    },
    //插入牙位图
    insertTooth: function(toothImageType,returnValue)
    {
        if (getReadOnlyStatus().ReadOnly == "True") return;
        
        if (toothImageType == "new")
        {
            var strJson = {action:"INSERT_TEETH_IMAGE",args:returnValue};
            iEmrPlugin.INSERT_TEETH_IMAGE(strJson);
        }
        else if (toothImageType == "open")
        {
            var strJson = {action:"REPLACE_TEETH_IMAGE",args:returnValue};
            iEmrPlugin.REPLACE_TEETH_IMAGE(strJson);
        }
    },
    foo: function () {}
};

var editorEvt = {
    //设置链接串   20220914改为同步方式
    /*eventSetNetConnect: function (commandJson) {
        if (commandJson.args.result != 'OK')
            alert('设置链接失败！');
        //$.messager.alert('发生错误', '设置链接失败！', 'error');
    },*/
    //文档改变事件
    eventDocumentChanged: function (commandJson) {
        if ('' === commandJson.args.InstanceID)
            return;
        
        //只允许编辑一份文档，连续模式的切换文档需提示保存
        if ((envVar.lockedIns != "")&&(envVar.lockedIns != commandJson.args.InstanceID))
        {
            var documentContext = getDocumentContext(envVar.lockedIns);
            emrEditor.saveConfirm(envVar.lockedIns, true);
            unlockByIns(envVar.lockedIns);
            setLockMessage("");
        }
        
        var btnRevisionVisible = $('#btnRevisionVisible');
        if (btnRevisionVisible.length !== 0 && btnRevisionVisible.find("span").eq(1).text() === '隐藏痕迹') {
            btnRevisionVisible.find("span").eq(1).text('显示痕迹');
        }
        var btnPreview = $('#btnPreview');
        if (btnPreview.length !== 0 && btnPreview.find("span").eq(1).text() === '退出预览') {
            iEmrPlugin.PREVIEW_DOCUMENT({
                Preview: false
            });
            btnPreview.find("span").eq(1).text('预览');
        }
        if (commandJson.args.InstanceID !== 'GuideDocument') {
            var documentContext = emrEditor.getDocContext(commandJson.args.InstanceID);
            emrEditor.setEditorReadonly(documentContext);
        } else {
            //切换到引导框时需要关闭只读
            iEmrPlugin.SET_READONLY({
                ReadOnly: false
            }); 
        }
        //刷新资源区范例病历
        refreshModelRecord();
        //刷新资源区个人模板管理
        refreshPersonalTemplate(commandJson);
        //结核病历
        if (sysOption.PhthisisEpisodeIDs !== "") {
            //修改结核病历目录
            phthisisFun(commandJson.args.InstanceID,"setSelectRecordColor");
        }
    },
    //章节改变事件
    eventSectionChanged: function (commandJson) {
        emrEditor.SectionCode = commandJson.args.Code;
        if ('function' === typeof emrEditor.sectionResFunc)
            emrEditor.sectionResFunc();
        //刷新知识库
        var paramJson = {
            'action': 'refreshKBNode',
            'code': commandJson.args.Code,
            'bindKBBaseID': commandJson.args.BindKBBaseID,
            'titleCode': sysOption.titleCode,
            'templateId':param.templateId
        };
        refreshKBNode(paramJson);
        refreshSectionHistory(paramJson);
    },
    //保存事件监听
    evtAfterSave: null,
    eventSaveDocument: function (commandJson) {
        //调用平台方法，用途锁定头菜单
        setSysMenuDoingSth();
        if (commandJson.args.result === 'OK') {
            if (commandJson.args.params.result === 'OK') {
                showEditorMsg({msg:'数据保存成功！', type:'success'});
                var insId = commandJson.args.params.InstanceID;
                
                //启用病历信息订阅与发布-//自动记录病例操作日志-//保存调用CDSS-//种植牙打开病历保存后的操作
                SaveDocumentAfter(insId);
                editorEvt.raiseEvent('evtAfterSave', commandJson);
                
                var documentContext = emrEditor.getDocContext(insId);
                //结核病历保存后调用方法
                PhthisisSaveFunc(documentContext, insId);
            } else {
                //$.messager.alert('发生错误', '数据保存失败！', 'error');
                alert('数据保存失败!');
            }
        } else if (commandJson.args.result === 'ERROR') {
            //$.messager.alert('发生错误', '保存失败！', 'error');
            if ((typeof(commandJson.args.params.desc)!="undefined")&&(commandJson.args.params.desc!=""))
            {
                alert(commandJson.args.params.desc);
            }
            else
            {
                alert('保存失败！');
            }
        } else if (commandJson.args.result === 'NONE') {
            editorEvt.raiseEvent('evtAfterSave', false);
            //showEditorMsg('文档没有发生改变!', 'alert');
        }
    },
    //提示用户保存文档
    eventQuerySaveDocument: function (commandJson) {
        //$.messager.alert('警示', '新建文档保存后才可创建新文档！', 'warning');
        alert('新建文档保存后才可创建新文档！');
    },
    //获得文档大纲
    eventGetDocumentOutline: function (commandJson) {},
    //创建文档事件
    eventCreateDocument: function (commandJson) {
        //标志量是修改提示时，不要置空
        if (getSysMenuDoingSth() !== emrTrans('病历正在编辑，是否保存？'))
            setSysMenuDoingSth();
        if (commandJson.args.result === 'ERROR') {
            //$.messager.alert('发生错误', '创建失败！', 'error');
            //串病历时编辑器会返回创建失败，清空文档
            emrEditor.cleanDoc();
            alert('创建失败！');
            return;
        }
        //param.id = commandJson["args"]["InstanceID"];
        //医为浏览器会修改envVar.savedRecords全局变量
        var tempInsID = commandJson["args"]["InstanceID"];
        common.GetRecodeParamByInsID(tempInsID, function(tempParam) {
            param = tempParam;
        });
        emrEditor.setEditorReadonly();
    },
    //加载文档事件
    eventLoadDocument: function (commandJson) {
        setSysMenuDoingSth();
        if (commandJson.args.result === 'ERROR') {
            //$.messager.alert('发生错误', '加载失败！', 'error');
            emrEditor.cleanDoc();
            alert('加载失败！');
            return;
        }

        //加载完毕后判断是否存在串病历情形，如果存在给予提示并清空文档
        var documentContext = emrEditor.getDocWithoutPrivilege(commandJson.args.InstanceID);
        if (!isConsistent(documentContext))
        {
            emrEditor.cleanDoc();
            return;
        }
        var currentEpsiodeId = "";
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', commandJson.args.InstanceID);
        ajaxGETSync(data, function (ret) {
            if (ret !== "") {
                currentEpsiodeId = ret;
            }
        }, function (ret) {
            alert('加载时，getAdmByInstanceID error:' + ret);
        });
        //结核病历
        if ((currentEpsiodeId != patInfo.EpisodeID)&&(sysOption.PhthisisEpisodeIDs !== "")&&(-1 != $.inArray(currentEpsiodeId, sysOption.PhthisisEpisodeIDs.split(",")))) {
            var _patInfo = {};
            for (var key in patInfo) {
                _patInfo[key] = patInfo[key];
            }
            _patInfo['EpisodeID'] = currentEpsiodeId;
            iEmrPlugin.SET_PATIENT_INFO({
                args: _patInfo
            });
        }else {
            iEmrPlugin.SET_PATIENT_INFO({
                args: patInfo
            });
        }
        //设置引导框
        common.GetRecodeParamByInsIDSync(commandJson.args.InstanceID, function(tempParam) {
            var isMutex = (tempParam.isMutex === '1') ? true : false;
            var isGuideBox = (tempParam.isLeadframe === '1') ? true : false;
            iEmrPlugin.SET_DOCUMENT_TEMPLATE({
                DocID: tempParam.emrDocId,
                IsMutex: isMutex,
                CreateGuideBox: isGuideBox
            });
        });
        
        if ((getReadOnlyStatus().ReadOnly == "False")) {
            if (privilege.canSave(documentContext))
            {
                //静默刷新
                iEmrPlugin.SILENT_REFRESH_REFERENCEDATA({
                    InstanceID: commandJson.args.InstanceID,
                    isSync: true
                }); 
                emrEditor.reloadBinddata(commandJson.args.InstanceID);
            }
            privilege.setRevsion(documentContext);
            privilege.setViewRevise(documentContext, function() {
                var btn = $('#btnRevisionVisible');
                if (btn.length !== 0 && $('#btnRevisionVisible').find("span").eq(1).text() === '隐藏痕迹') {
                    $('#btnRevisionVisible').find("span").eq(1).text('显示痕迹');
                }
                return false;
            });
        }
        emrEditor.setEditorReadonly(documentContext);
    },
    //文档签名事件
    eventSaveSignedDocument: function (commandJson) {
        if ((commandJson.args.result == 'OK') && (commandJson.args.params.result == 'OK')) {
            var insId = commandJson.args.params.InstanceID;
            
            showEditorMsg({msg:'数据签名成功！', type:'success'});
            var insId = commandJson.args.params.InstanceID;
            common.GetRecodeParamByInsID(insId, function(tempParam) {
                //自动记录病例操作日志
                hisLog.operate('EMR.OP.Sign.OK',tempParam);
            });
            var documentContext = emrEditor.getDocWithoutPrivilege();
            privilege.setRevsion(documentContext);
            privilege.setViewRevise(documentContext, function () {
                var txt = $('#btnRevisionVisible').find("span").eq(1).text();
                return txt === '隐藏痕迹';
            });
            //结核病历
            if (sysOption.PhthisisEpisodeIDs !== "") {
                var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', insId);
                ajaxGETSync(data, function (ret) {
                    if (ret !== "") {
                        if (-1 != $.inArray(ret, sysOption.PhthisisEpisodeIDs.split(","))) {
                            common.GetSavedFirstMultiRecord(ret, insId, function(insData) {
                                insData["epsiodeId"] = ret;
                                documentContext["insData"] = insData;
                                //修改结核病历目录
                                phthisisFun(documentContext,"modifyListRecord");
                            });
                        }
                    }
                }, function (ret) {
                    alert('签名时，getAdmByInstanceID error:' + ret);
                });
            }
        } else {
            //$.messager.alert('发生错误', '保存签名数据失败！', 'error');
            alert('保存签名数据失败!');
            var ret = iEmrPlugin.UNSIGN_DOCUMENT({
                    isSync: true
                });
            if ('ERROR' === ret.result)
                alert('撤销最后一次签名失败！');
            //$.messager.alert('发生错误', '撤销最后一次签名失败！', 'error');
        }
    },
    //删除文档
    eventDeleteDocument: function(commandJson) {
        if (commandJson.args.result === 'OK') {
            try {
                var insId = commandJson.args.InstanceID;
                showEditorMsg({msg:'病历删除成功！',type:'success'});
                //刷新历史就诊列表
                refreshAdmHistory();
                common.GetRecodeParamByInsID(commandJson.args.InstanceID, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Delete.OK',tempParam);
                });
                if((typeof(_paramNow) !== 'undefined')&&(_paramNow.categoryId == plantToothTreatmentCategory))    //种植牙删除病历后的操作
                {
                    if(document.getElementById("dentalimplantsFrame"))
                    {
                        var tempFrame = document.getElementById("dentalimplantsFrame").contentWindow;
                        tempFrame.deleteRecordInstanceId(insId);
                    }
                }
                //结核病历
                if (sysOption.PhthisisEpisodeIDs !== "") {
                    //修改结核病历目录
                    phthisisFun(insId, "deleteListRecord");
                }
                
                var documentContext = emrEditor.getDocWithoutPrivilege();
                if (documentContext) {
                    if (documentContext.result === 'ERROR') {
                        // 移除记录
                        $.each(envVar.savedRecords, function(idx, item) {
                            if (commandJson.args.InstanceID === item.id) {
                                envVar.savedRecords.splice(idx, 1);
                                emrTemplate.closeCurTmplsTab();
                                return false; //break
                            }
                        });
                        var len = emrTemplate.tmplsTabs.tabs('tabs').length;
                        if (len === 0) {
                            emrEditor.createDocMain(envVar.firstTmpl);
                        } else {
                            var tab = emrTemplate.tmplsTabs.tabs('getSelected');
                            if (!tab)
                                return;
                            var idx = emrTemplate.tmplsTabs.tabs('getTabIndex', tab);
                            emrTemplate.tmplsTabs.tabs('select', idx);
                        }
                    } else if (documentContext.InstanceID === 'GuideDocument') { //可重复
                        var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getSavedFirstMultiRecord', patInfo.EpisodeID, commandJson.args.InstanceID);
                        ajaxGET(data, function(ret) {
                            if (ret === '') {
                                common.getTemplateIDByInsId(commandJson.args.InstanceID, function(tmpId) {
                                    $.each(envVar.savedRecords, function(idx, item) {
                                        if (tmpId === item.templateId) {
                                            envVar.savedRecords.splice(idx, 1);
                                            emrTemplate.closeCurTmplsTab();
                                            return false; //break
                                        }
                                    });

                                    var len = emrTemplate.tmplsTabs.tabs('tabs').length;
                                    if (len === 0) {
                                        emrEditor.createDocMain(envVar.firstTmpl);
                                    }
                                });
                            } else {
                                var tab = emrTemplate.tmplsTabs.tabs('getSelected');
                                if (!tab)
                                    return;
                                var idx = emrTemplate.tmplsTabs.tabs('getTabIndex', tab);
                                envVar.savedRecords[idx] = $.parseJSON(ret);
                            }
                        });
                    }
                }
                //删除病历调用CDSS
               common.GetRecodeParamByInsIDSync(insId,function(param){
                   cdssParam(param,"Delete"); 
                });
            } catch (err) {
                //$.messager.alert('发生错误', err.message || err, 'error');
                alert(err.message || err);
            } finally {
                editorEvt.raiseEvent('evtAfterDelete', commandJson);
            }
        }
        //当前病历未保存时，删除病历编辑器会返回ERROR
        else
        {
               var documentContext = emrEditor.getDocWithoutPrivilege();
            if (documentContext) {
                if (documentContext.result === 'ERROR') {
                    // 移除记录
                    $.each(envVar.savedRecords, function(idx, item) {
                        if (commandJson.args.InstanceID === item.id) {
                            envVar.savedRecords.splice(idx, 1);
                            emrTemplate.closeCurTmplsTab();
                            return false; //break
                        }
                    });
                    var len = emrTemplate.tmplsTabs.tabs('tabs').length;
                    if (len === 0) {
                        emrEditor.createDocMain(envVar.firstTmpl);
                    } else {
                        var tab = emrTemplate.tmplsTabs.tabs('getSelected');
                        if (!tab)
                            return;
                        var idx = emrTemplate.tmplsTabs.tabs('getTabIndex', tab);
                        emrTemplate.tmplsTabs.tabs('select', idx);
                    }
                } else if (documentContext.InstanceID === 'GuideDocument') { //可重复
                    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'getSavedFirstMultiRecord', patInfo.EpisodeID, commandJson.args.InstanceID);
                    ajaxGET(data, function(ret) {
                        if (ret === '') {
                            common.getTemplateIDByInsId(commandJson.args.InstanceID, function(tmpId) {
                                $.each(envVar.savedRecords, function(idx, item) {
                                    if (tmpId === item.templateId) {
                                        envVar.savedRecords.splice(idx, 1);
                                        emrTemplate.closeCurTmplsTab();
                                        return false; //break
                                    }
                                });

                                var len = emrTemplate.tmplsTabs.tabs('tabs').length;
                                if (len === 0) {
                                    emrEditor.createDocMain(envVar.firstTmpl);
                                }
                            });
                        } else {
                            var tab = emrTemplate.tmplsTabs.tabs('getSelected');
                            if (!tab)
                                return;
                            var idx = emrTemplate.tmplsTabs.tabs('getTabIndex', tab);
                            envVar.savedRecords[idx] = $.parseJSON(ret);
                        }
                    });
                }
            } 
        }
    },
    eventAppendComposite: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("appendComposite");
        }
    },
    eventAppendCompositeAdvanced: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("appendComposite");
        }
    },
    eventUpdateInstanceData: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("updataInsByEmr");
        }
    },
    eventInsertTextBlock: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("insertText");
        }
    },
    // 打开链接单元
    eventHyperLink: function (commandJson) {
        var operation = "";
        if (commandJson.args.Url.indexOf("{")>=0)
        {
            commandJson.args.Url = $.parseJSON(commandJson.args.Url);
            operation = commandJson.args.Url.name;
        }
        else
        {
            operation = commandJson.args.Url;
        }
        if ('' == operation) return;
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetUnitLink', operation);
        ajaxGET(data, function (ret) {
            ret = $.parseJSON(ret);
            if (ret && ret.Err) {
                //$.messager.alert('发生错误', '获取' + operation + '链接：' + ret.Err, 'error');
                alert('获取' + operation + '链接：' + ret.Err);
            } else {
                if (null != ret) {
                    if ('switchTabByEMR' === ret.Method) {
                        chartOnBlur();
                        var fn = parent.switchTabByEMR;
                        if ('function' === typeof fn)
                        {
                            setTimeout(function(){
                                fn(ret.Title);
                            },0);
                            
                        }
                        else
                            alert('switchTabByEMR未定义！');
                        //$.messager.alert('提示', 'switchTabByEMR未定义！', 'info');
                    } else if ('switchDataTab' === ret.Method) {
                        HisTools.dataTabs.switchDataTab(ret.Title);
                    } else {
                        HisTools.hislinkWindow.openUnitLink(ret, commandJson.args);
                    }
                } else {
                    //$.messager.alert('警示', '请检查链接单元【' + operation + '】配置！', 'warning');
                    alert('请检查链接单元【' + operation + '】配置！');
                }
            }
        }, function (ret) {
            //$.messager.alert('发生错误', '获取' + operation + '链接：' + ret, 'error');
            alert('获取' + operation + '链接：' + ret);
        });
    },
    //判断知识库是否替换成功
    eventReplaceComposite: function (commandJson) {
        if (commandJson.args.result === 'OK') {
            showEditorMsg({msg:'知识库替换成功！', type:'success'});
            eventSave("replaceComposite");
        } else {
            showEditorMsg({msg:'知识库替换失败！', type:'error'});
        }
    },
    //快捷热键的通知事件
    eventHotKey: function (commandJson) {
        if ('' == commandJson.args.KeyState && 'F2' == commandJson.args.Key && 'Y' == sysOption.useResWindowHotkey) {
            emrEditor.showResourceWindow();
        }
    },
    //在签名单元上触发的事件，由双击触发
    eventRequestSign: function (commandJson) {
        if ('1' === envVar.readonly) {
            return;
        }
        var documentContext = emrEditor.getDocContext();
        var instanceId = documentContext.InstanceID;
        var signProperty = commandJson.args;

        var fnAfterSave = function (commandJson) {
            if (commandJson) {
                if (commandJson.args && commandJson.args.result === 'ERROR')
                    return;
                //else if (commandJson.QCResult === false)
                    //return;
            }
            signProperty = (commandJson||{})['requestSign'] || signProperty;
            if (!commandJson){
                var signedInfo = iEmrPlugin.GET_SIGNED_INFO({
                    Path: signProperty.Path,
                    isSync: true
                });
                if (signedInfo.result == 'ERROR'){
                    setMessage("获取签名元素信息失败！", "error");
                    return;
                }
                signProperty = signedInfo.params;
            }
            var qualityResult = quality.signChecker(documentContext);
            if (!qualityResult) {
                return;
            }

            //患者手写签名
            if (('PATIENT' === signProperty.OriSignatureLevel.toUpperCase())||(signProperty.OriSignatureLevel.toUpperCase() == 'NOTATION')) { 
                if (typeof(handSign) == "undefined") {
                    var patCAoffMsg = "未开启患者签名功能，如需开启，请联系系统管理员";
                    if (typeof(patCAOffReason) != "undefined")
                        var patCAoffMsg = patCAOffReason + patCAoffMsg;    
                    setMessage(patCAoffMsg,'forbid');
                    return;
                }
                
                if ((!privilege.canPatCheck(documentContext))&&(signProperty.Authenticator.length == 0))
                    return ;
                else if ((!privilege.canPatReCheck(documentContext))&&(signProperty.Authenticator.length > 0))
                    return ;
           
                   var actionType = 'Append';
                if (signProperty.Authenticator.length>0) { actionType = 'Replace'; }
                
                var argEditor = {
                    signProps:{
                        patientID: patInfo.PatientID,
                        episodeID: patInfo.EpisodeID,
                        instanceID: instanceId,
                        signKeyWord: signProperty.Name,
                        actionType: actionType
                    },
                    instanceId: instanceId,
                    userId: patInfo.UserID,
                    actionType: actionType,
                    path: signProperty.Path,
                    signDocument: function(instanceId, type, signLevel, userId, userName, Image, actionType, description, headerImage, fingerImage, path, isZoom) {
                        return iEmrPlugin.SIGN_DOCUMENT({
                            InstanceID: instanceId,
                            Type: type,
                            SignatureLevel: signLevel,
                            actionType: actionType,
                            Id: userId,
                            Name: userName,
                            Image: Image,
                            HeaderImage: headerImage,
                            FingerImage: fingerImage,
                            Description: description,
                            Path: path,
                            IsZoom: isZoom,
                            isSync: true
                        });
                    },
                    saveSignedDocument: function (instanceId, signUserId, signLevel, signId, digest, type, path, actionType) {
                        iEmrPlugin.SAVE_SIGNED_DOCUMENT({
                            InstanceID: instanceId,
                            SignUserID: signUserId,
                            SignID: signId,
                            SignLevel: signLevel,
                            Digest: digest,
                            Type: type,
                            Path: path,
                            ActionType: actionType
                        })
                    },
                    episodeID:patInfo.EpisodeID,
                    unSignedDocument: function () {
                        iEmrPlugin.UNSIGN_DOCUMENT();
                    },
                    canDoPDFSign: canDoPDFSign,
                    getSignedPDF: getSignedPDF,
                    getPatSignKeyWord: getPatSignKeyWord,
                    createToSignPDFBase64: createToSignPDFBase64
                };
                
                if (signProperty.OriSignatureLevel.toUpperCase() == 'PATIENT') 
                {
                    handSign.sign(argEditor);
                }
                else //批注模式，目前暂时只有BJCA提供了
                {    
                    //获取单元描述用于患者抄写
                    var tarEl = getElementContext("MIElement");
                    var descContent = tarEl.Props.Description||"";
                    handSign.notationSign(argEditor,descContent); 
                }
            } else if ('1' === sysOption.CAServicvice) {
                if (!privilege.canCheck(documentContext))
                    return;
                    
                keySign.sign(signProperty.SignatureLevel, instanceId, signProperty, patInfo.UserID);                
            } else { 
                // 系统签名 sysSign
                if (!privilege.canCheck(documentContext))
                    return;
                
                if ('Y' !== sysOption.isDirectSignOP)
                {
                    var dialogId = "signDialog";
                    var iframeId = "opdocSign";
                    var canRevokCheck = "0";
                    if (sysOption.isAllRevokeSign.split("^")[0]=="Y")
                    {
                        var canRevokCheck = "1";
                    }
                    var signParam = {"cellName":signProperty.Name,"canRevokCheck":canRevokCheck};
                    signParam = base64encode(utf16to8(escape(JSON.stringify(signParam))));
                    var arg = {
                        "signProperty": signProperty,
                        "instanceId": instanceId
                    };
                    var src = "emr.opdoc.sign.csp?UserName="+patInfo.UserName+"&UserCode="+patInfo.UserCode+"&UserLocID="+patInfo.UserLocID+"&dialogId="+dialogId+"&signParam="+signParam+"&MWToken="+getMWToken();
                    var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
                    createModalDialog(dialogId,"身份验证", 360, 280,iframeId,iframeCotent,signDocumentCheck,arg);
                }
                else
                {
                    var userInfo = common.getUserInfo();
                    var arg = {
                        "signProperty": signProperty,
                        "instanceId": instanceId
                    };
                    signDocumentCheck(userInfo, arg);
                }
            }
        }
        emrEditor.saveDoc(documentContext, fnAfterSave, false ,true);
    },
    evtAfterGetMetaDataTree: null,
    eventGetMetaDataTree: function (commandJson) {
        editorEvt.raiseEvent('evtAfterGetMetaDataTree', commandJson);
    },
    eventUnSignDocument: function (commandJson) {
        if (commandJson.args.result === 'ERROR') {
            //$.messager.alert('发生错误', 'eventUnSignDocument:' + commandJson.args.result, 'error');
            alert('eventUnSignDocument:' + commandJson.args.result);
        }
    },
    eventRefreshReferenceData: function(commandJson) {
        if (commandJson.args.result != 'OK') return;

        var instanceId = emrEditor.getInstanceID();
        var data = ajaxDATA('String', 'EMRservice.BL.BLRefreshBindData', 'InputData', instanceId, commandJson.args.SyncDialogVisible);
        ajaxGET(data);
    },
    eventDiffentReferenceData: function(commandJson) {
           //if (!isSelectEMRTab()) return;
        if (commandJson.args.result != 'OK') return;
        //没有数据并且不是手动打开的不弹框；参数dataObjStr记录了是否手动，false是手动
        if ((commandJson.args.Items.length == 0)&&(dataObjStr == true)) return;
        var autoRefresh = dataObjStr;    //false:手动
        dataObjStr = {
            Items:[],
            total:0
        };
        dataObjNullStr={
            total:0
        }
        var InstanceID = emrEditor.getInstanceID();
        jQuery.ajax({
            type : "GET", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : false,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLRefreshDataHidden",
                    "Method":"GetAllCodeByInstanceID",    
                    "p1":InstanceID
                },
            success : function(d) {
                var Codes = d.split("^");
                var sameCodeCount = 0;    //用来存储插件返回的同步数据和勾选不需要显示的同步数据相同的条数
                for (var i=0;i<commandJson["args"]["Items"].length;i++)
                {
                    if((commandJson["args"]["Items"][i].OldValue == "-")&&(commandJson["args"]["Items"][i].NewValue == ""))
                    continue;
                    if(Codes.indexOf(commandJson["args"]["Items"][i].Code) !== -1)
                    {
                        sameCodeCount++;
                    }
                    dataObjStr.total++;
                    if (commandJson["args"]["Items"][i].NewValue == "")
                    {
                        dataObjNullStr.total++
                    }
                    dataObjStr.Items.push(commandJson["args"]["Items"][i]);
                }
                
                if ((sameCodeCount == dataObjStr.total)&&(autoRefresh == true)) return; //如果需要同步的数据都是不需要显示的数据，并且不是手动，则不显示
                 //配合默认显示非空同步数据改造，如果不同数据都是空值，不自动弹出。
                if ((dataObjStr.total == dataObjNullStr.total)&&(autoRefresh == true )) return;
                //dataObjStr = base64encode(utf16to8(escape(JSON.stringify(commandJson.args))));
				window.top.dataObjStr = dataObjStr;
                var tempFrame = "<iframe id='iframeSynData' scrolling='auto' frameborder='0' src='emr.ip.datasyn.csp?InstanceID="+InstanceID+"&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
                createModalDialogTop("dialogSynData","数据同步","600","550","iframeSynData",tempFrame,synDataCallback,"");
            }
        });    
    },
    
    //打印事件监听
    eventPrintDocument: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            //生成pdf的虚拟打印操作不记录打印日志，此时commandJson.args.result为OK，但commandJson.args.params为未定义
            if ((commandJson.args.params)&&(commandJson.args.params.result == "OK")) {
                showEditorMsg({msg:'病历打印成功！', type:'success'});
                //结核病历
                if (sysOption.PhthisisEpisodeIDs !== "") {
                    //修改结核病历目录
                    phthisisFun(commandJson.args.params.PrintInstanceIDs, "setListPrinted");
                }
                var insId = insId || emrEditor.getInstanceID();
                common.GetRecodeParamByInsID(insId, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Print.OK',tempParam);
                });
                emrTemplate.updateCurrentTitle();
            }
        }
    },
    //导出文档事件监听
    eventSaveLocalDocument: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            var insId = insId || emrEditor.getInstanceID();
            common.GetRecodeParamByInsID(insId, function(tempParam) {
                //自动记录病例操作日志
                hisLog.operate('EMR.OP.Export.Save',tempParam);
            });
        }
    },
    //请求编辑器中图片数据(base64)
    eventRequestImgData: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            if ('' == (commandJson.args.ImageData || '')) return;
            var argParams = {
                UserLocID: patInfo.UserLocID,
                UserID: patInfo.UserID,
                Image: commandJson.args.ImageData,
                Methods: '',
                EdtImgPath: commandJson.args.Path || '',
                FnEmrImg: function(imageType, imageData) {
                    iEmrPlugin.REPLACE_IMG({
                        ImageType: imageType,
                        ImageData: imageData
                    });
                },
                FnEmrEdtImg: function() {
                    iEmrPlugin.EDIT_IMG();
                }
            }
            externImage.get(argParams);
        }
    },
    // 异步命令回调
    callbackAfterEvt: null,
    raiseEvent: function (evtName, commandJson) {
        var evt = editorEvt[evtName];
        if (typeof evt === 'function') {
            try {
                evt(commandJson);
            } catch (ex) {
                //$.messager.alert('发生错误', 'evtName error:' + ex.message, 'error');
                alert('evtName error:' + ex.message);
            }
            finally {
                evt = null;
            }
        }
    },
    eventDispatch: function (commandJson) {
        var fnAction = editorEvt[commandJson.action];
        if (typeof fnAction === 'function') {
            fnAction(commandJson);
        } else
            eventDispatch(commandJson);
    },
    //插入牙位图
    eventInsertTeethImage: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            showEditorMsg({msg:'插入成功！', type:'success'});
        }
    },
    //双加牙位图打开编辑框，修改牙位信息后重新插入牙位图
    eventReplaceTeethImage: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            showEditorMsg({msg:'插入成功！', type:'success'});
        }
    },
    //双加牙位图打开编辑框
    eventRequestTeeth: function(commandJson) {
        openTooth(commandJson)
    },
    eventDocModify: function(commandJson)
    {
        if (commandJson["args"]["Modified"] == "True")
        {
            setLockMessage("");
            unlockByIns(envVar.lockedIns);
            
            var insID = emrEditor.getInstanceID();
            //加锁
            var rtn = lock(insID);
            if (rtn){
                //文档进入编辑状态，给平台发消息
                setSysMenuDoingSth(emrTrans('病历正在编辑，是否保存？'));
                //设置保存的回调函数供平台调用
                setDoingSthSureCallback(true);
            }
        }
        else
        {
            var insID = emrEditor.getInstanceID();
            //解锁
            unlockByIns(insID)
            //无正在编辑的病历，清空状态
            setSysMenuDoingSth("");
            setDoingSthSureCallback(false);
        }
    }
};

/// 对外接口 知识库等页面使用
function eventDispatch(commandJson) {
    if (commandJson.action == 'insertText') {
        iEmrPlugin.INSERT_TEXT_BLOCK({
            args: commandJson.text
        });
    } else if (commandJson.action == 'reflashKBNode') {
        refreshKBNode(commandJson);
    } else if (commandJson.action == 'refreshSectionHistory') {
        refreshSectionHistory(commandJson);
    } else if (commandJson.action == 'appendComposite') {
        if (commandJson.Type == "DP"){
            iEmrPlugin.APPEND_DPCOMPOSITE({
                KBNodeID: commandJson.KBNodeID,
                Type: "DP"
            });
        }else{
            //追加复合元素(知识库)
            iEmrPlugin.APPEND_COMPOSITE({
                KBNodeID: commandJson.NodeID
            });
        }
    } else if (commandJson.action == 'replaceComposite') {
        iEmrPlugin.REPLACE_COMPOSITE({
            KBNodeID: commandJson.NodeID
        });
    } else if (commandJson.action == 'INSERT_STYLE_TEXT_BLOCK') {
        iEmrPlugin.INSERT_STYLE_TEXT_BLOCK({
            args: commandJson.args
        });
    } else if (commandJson.action == 'CREATE_DOCUMENT_BY_INSTANCE') {
        LoadPersonRecord(commandJson.args);
    } else if (commandJson.action == 'SAVE_SECTION') {
        var rtn = iEmrPlugin.SAVE_SECTION(commandJson.args);
        return rtn;
    } else if (commandJson.action == 'GET_DOCUMENT_CONTEXT') {
        return getDocumentContext('');
    } else if (commandJson.action == 'INSERT_SECTION') {
         iEmrPlugin.invoke(commandJson);
    } else if (commandJson.action == 'CHECK_DOCUMENT_MODIFY') {
        return iEmrPlugin.CHECK_DOCUMENT_MODIFY(commandJson.args);
    } else if (commandJson.action == 'SAVE_PERSONAL_SECTION') {
        //保存个人模板-新
        return iEmrPlugin.SAVE_PERSONAL_SECTION(commandJson.args);
    }else if (commandJson.action == 'eventRequestKnowledgeBase')
    {
        //ctrl+k 快捷键
        eventRequestKnowledgeBase(commandJson);
    }else if(commandJson["action"] == "eventSearchCdssBase")
    {
        //查看知识库
        eventSearchCdssBase(commandJson);
    }else if(commandJson["action"] == "Event_EMR_HrartBeat_Status")
    {
        //根据编辑器活跃状态判断是否调用平台接口防止锁屏
        if (commandJson["args"]["Status"] == "Active") 
        {
            if ((typeof websys_getMenuWin != "undefined")&&(typeof websys_getMenuWin().lockScreenOpt != "undefined")&&(typeof websys_getMenuWin().lockScreenOpt.userOperation!="undefined"))
            {
                websys_getMenuWin().lockScreenOpt.userOperation();
            }
            //请求服务器查看是否掉线
            var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'requestCACHE');
            ajaxPOSTSync(data, function (ret) {
                if (ret !== "true") {
                    $.messager.alert("提示","页面系统失效，请重新登录！","info");
                }
            }, function (ret) {
                $.messager.alert("提示","页面系统失效，请重新登录！","error");
            });
        }
    }
    else if(commandJson["action"] == "eventDocModify")
    {
        //发送文档修改事件
        eventDocModify(commandJson);
    }
    else if (commandJson.action == 'INSERT_SECTION_BY_NAME') {
        insertSectionByName(commandJson.data);
	}
}
///跨页传json对象包含数组，会变换格式
function eventDispatchBroker(commandStr) {
    var commandJson = $.parseJSON(commandStr);
    editorEvt.eventDispatch(commandJson);
}

//快捷键保存 对外接口
function eventSave(action,callback,isSync) {
    if ((sysOption.OPAutoSave == "")||((','+sysOption.OPAutoSave+',').indexOf(','+action+',') == "-1")){
        return;
    }
    emrEditor.saveDoc("",callback,isSync,true);
}

//刷新知识库
function refreshKBNode(commandParam) {
    if (!commandParam)
        return;

    emrEditor.kbtreeCmd = commandParam;
    if (document.getElementById('kbDataFrame')) {
        var kbDataFrame = document.getElementById('kbDataFrame').contentWindow;
        var fn = kbDataFrame.GetKBNodeByTreeID;
        if (typeof fn === 'function') {
            fn(commandParam);
        }
    } else if (typeof emrEditor.refreshKBFunc !== 'undefined' && emrEditor.refreshKBFunc !== null) {
        emrEditor.refreshKBFunc(commandParam);
    }
}

//刷新章节历史数据
function refreshSectionHistory(commandParam) {
    if (!commandParam)
        return;

    emrEditor.SecHistoryCmd = commandParam;
    if (document.getElementById('secHistoryFrame')) {
        var secHistoryFrame = document.getElementById('secHistoryFrame').contentWindow;
        var fn = secHistoryFrame.GetSectionHistory;
        if (typeof fn === 'function') {
            fn(commandParam);
        }
    } else if (typeof emrEditor.refreshSecHistoryFunc !== 'undefined' && emrEditor.refreshSecHistoryFunc !== null) {
        emrEditor.refreshSecHistoryFunc(commandParam);
    }
}


function createDocFromInstance(insData) {
    emrEditor.saveConfirm(true);
    emrEditor.createDocFromInstance(insData);
}

function getDocumentContext(insID) {
    return emrEditor.getDocContext(insID);
}

//判断当前光标在文档中的位置
function getElementContext(position) {
    return iEmrPlugin.GET_ELEMENT_CONTEXT({
        Type: position,
        isSync: true
    });
}

///判断当前文档的只读状态
function getReadOnlyStatus() {
    return iEmrPlugin.GET_READONLY({isSync:true});
}

//打开牙位图
var selectedToothObj = "";
var lastrt = "";
//设置上次打开的牙位标识法
function setLastRepresentation(last){
	lastrt = last;
}
function getLastRepresentation(){
	return lastrt;	
}
function openTooth(commandJson)
{
    selectedToothObj = commandJson["args"];
    var selectedTeeth = "tooth";
    var dialogId = "toothDialog";
    var iframeId = "opdocTooth";
    var src = "emr.ip.tool.toothimg.csp?dialogId="+dialogId+"&selectedToothObjStr="+selectedTeeth+"&MWToken="+getMWToken();
    var iframeCotent = "<iframe id='"+iframeId+"' width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>";
    createModalDialog(dialogId,"牙位图", "1145","700",iframeId,iframeCotent,insertTooth);
}

function insertTooth(returnValue){
    emrEditor.insertTooth("open",returnValue);
}

//双击已有牙位图时，获取牙位图数据信息，由子页面牙位图编辑页面调用
function getSelectedToothObj(){
    return selectedToothObj;
}
//刷新范例病历
function refreshModelRecord()
{
    var tab = $('#dataTabs').tabs('getSelected');
    var id = tab[0].id;
    if ((id != "modelInstance")&&(id != "exampleinstance")) return;
    if (document.getElementById('modelFrame'))
    {
        document.getElementById('modelFrame').contentWindow.initInstanceTree();
    }
    if (document.getElementById('exampleFrame'))
    {
        document.getElementById('exampleFrame').contentWindow.initInstanceTree();
    }
}

//刷新个人模板管理页面
function refreshPersonalTemplate(commandParam) {
    if ((!commandParam)||(!commandParam.args.InstanceID))
        return;

    if (document.getElementById('personalTemplateFrame')) {
        var personalTemplateFrame = document.getElementById('personalTemplateFrame').contentWindow;
        var fn = personalTemplateFrame.initTreeByInsID;
        if (typeof fn === 'function') {
            fn(commandParam.args.InstanceID);
        }
    }
}

function getImageZoomRatio(userId)
{
    var result = "";
    var data = ajaxDATA('String', 'EMRservice.BL.BLEMRSign', 'GetDoctorSignImageRatio', userId);
    ajaxGETSync(data, function (ret) {
        //result = ret;
        result = [eval("("+ret+")")];
        result = result[0].op;
    }, function (ret) {
        alert('getImageZoomRatio error:' + ret);
    });
    return result;
}

function signDocumentCheck(userInfo, arg)
{
    //userInfo类型为object不支持replace方法。兼容保留原有json字符串代码逻辑
    var userInfo = typeof userInfo=="object"?userInfo:$.parseJSON(userInfo.replace(/\'/g, "\""));
    var signProperty = arg.signProperty;
    var instanceId = arg.instanceId;
    if (userInfo.action == "revoke")
    {
        userInfo = userInfo.userInfo;
        if (userInfo.UserID != signProperty.Id)
        {
            setMessage('非本人签名,不能撤销','forbid');
            return;
        }
        if (sysOption.pluginType === 'DOC')
        {
            var ret = revokeWordSign(userInfo,signProperty,instanceId);
        }
        else
        {
            //grid型暂不支持，无测试环境所以暂未加
        }
    }
    else
    {
        var checkSignCallBack = function (checkresult,arr) {
            var userInfo = arr.userInfo;
            var arg = arr.arg;
            
            var instanceId = arg.instanceId;
            if (!checkresult.flag)
                return;

            //开始签名
            var signlevel = signProperty.SignatureLevel;
            var actionType = checkresult.ationtype;
            if (signProperty.OriSignatureLevel == 'Check') {
                signlevel = userInfo.UserLevel;
            }
            if (('' === signlevel) && (signProperty.OriSignatureLevel !== "All")) {
                showEditorMsg({msg:'用户签名级别为空！', type:'alert'});
                return;
            }

            var signInfo = iEmrPlugin.SIGN_DOCUMENT({
                    InstanceID: instanceId,
                    Type: userInfo.Type,
                    SignatureLevel: signlevel,
                    actionType: actionType,
                    Id: userInfo.UserID,
                    Name: userInfo.UserName,
                    Image: userInfo.Image,
                    Description: userInfo.LevelDesc,
                    Path: signProperty.Path || '', 
                    isSync: true
                });

            if (signInfo.result == 'OK') {
                //saveSignedDocument(instanceId, userInfo.UserID, signlevel, '', '', 'SYS', signInfo.Path, actionType);
                iEmrPlugin.SAVE_SIGNED_DOCUMENT({
                    InstanceID: instanceId,
                    SignUserID: userInfo.UserID,
                    SignID: '',
                    SignLevel: signlevel,
                    Digest: '',
                    Type: 'SYS',
                    Path: signInfo.Path,
                    ActionType: actionType
                });
            } else {
                showEditorMsg({msg:'签名失败！', type:'error'});
            }
        
        }
	//userInfo类型为object不支持replace方法。兼容保留原有json字符串代码逻辑
    	var userInfo = typeof userInfo=="object"?userInfo:$.parseJSON(userInfo.replace(/\'/g, "\""));
    	var signProperty = arg.signProperty;
        
        var arr = {
            userInfo: userInfo, 
            arg: arg    
        }
        
        //权限检查
        var documentContext = emrEditor.getDocContext();
        privilege.checkSign(userInfo, signProperty, documentContext, checkSignCallBack, arr);
    }
}
function printDocumentCheck(printArg)
{
    var PrintMode = '';
    var fnAfterSave = function (commandJson) {
        if (commandJson && commandJson.args) {
            if (commandJson.args.result === 'ERROR')
                return;
            else if (commandJson.QCResult === false)
                return;
        }
        
        var documentContext = emrEditor.getDocContext();
        if (!privilege.canPrint(documentContext))
            return;
        
        if (!quality.printChecker(documentContext))
            return;

        if (printArg == "PrintDocInsertHalfpage")
        {
            printArg = 'PrintDirectly';
            PrintMode = 'AddHalfPagePrint';
        }
        
        iEmrPlugin.PRINT_DOCUMENT({
            args: printArg || 'Print',
            printMode: PrintMode
        });
    }
    
    var documentContext = emrEditor.getDocContext();
    //自动保存如未配置打印动作，进行提醒
    var modifyResult = emrEditor.getModifyResult();
    if ((modifyResult.Modified == 'True')&&((','+sysOption.OPAutoSave+',').indexOf(',print,') == "-1"))
    {
        var displayName = documentContext.Title.NewDisplayName;
        if (displayName == "") {displayName = "文档"}
        var text = displayName + '正在编辑，请保存后打印，是否保存？';
        top.$.messager.confirm("操作提示", text, function (data) { 
            if(data) {
                emrEditor.saveDoc(documentContext, fnAfterSave);
            }
        });
    }
    else
    {
        emrEditor.saveDoc(documentContext, fnAfterSave, false, true);
    }
}
//插入文本数据到病历
function insertText(text){
    iEmrPlugin.INSERT_TEXT_BLOCK({
            args:text
        });
}

var dataObjStr = true;    //此参数在“dataObjStr = commandJson.args;”之前用作记录是否手动打开；之后用作插件返回的数据。
//数据同步回调
function  synDataCallback(returnValue,arr) {
    if (returnValue.updataStr !== undefined)
    {
        var instanceId = emrEditor.getInstanceID();
        iEmrPlugin.UPDATE_INSTANCE_DATA({
            actionType: "Replace",
            InstanceID: instanceId,
            Path: "",
            Value: "",
            Other: returnValue.updataStr
        });
        //updateInstanceData("Replace",instanceID,"","",returnValue.updataStr);
    }
    /*if (returnValue.checkStatu !== undefined)
    {
        var instanceId = emrEditor.getInstanceID();
        var data = ajaxDATA('String', 'EMRservice.BL.BLRefreshBindData', 'InputData', instanceId, returnValue.checkStatu);
        ajaxGET(data);
    }*/
}

///保存时调用判断是否串患者
function isConsistent(documentContext)
{
    if ((typeof(documentContext) == "undefined") || (documentContext.result === "ERROR"))
    {
        documentContext = emrEditor.getDocWithoutPrivilege();
    }
    if (documentContext.result === "ERROR") {
        showEditorMsg({msg:'请注意：当前保存病历可能不属于当前患者，保存失败，请重新打开病历页面进行编辑保存！', type:'error'});
        return false;
    }
    
    var isError = false;
    // 连接数据库标识
    var cacheFlag = "";
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', documentContext.InstanceID);
    ajaxGETSync(data, function (ret) {
        if (ret.indexOf('<html>') != "0") {
            if (ret !== "") {
                if (ret !== patInfo.EpisodeID)
                {
                    isError = true;
                }
            if (isError){
                //结核病历
                if (sysOption.PhthisisEpisodeIDs !== "") {
                    if (-1 != $.inArray(ret, sysOption.PhthisisEpisodeIDs.split(","))) {
                        isError = false;
                    }
                }
            }
            }
        }else {
            cacheFlag = ret;
        }
    }, function (ret) {
        alert('getAdmByInstanceID error:' + ret);
    });
    
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
//设置电子病历运行环境参数
function setRunEMRParams()
{
    $.ajax({
        type: 'GET',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLSysOption",
            "Method":"GetRunEMRParams",
            "p1":"",
            "p2":"OP"
        },
        success: function (ret) {
            if (ret != "") {
                result = eval("("+ret+")");
                iEmrPlugin.SET_RUNEMR_PARAMS(result);
            }
        },
        error: function (ret) {
            alert('setRunEMRParams error');
        }
    });
}

//同步患者基本信息选项卡列表
function GetObserverData(templateId)
{
    var returnValues = "";
    var data = ajaxDATA('Stream', 'EMRservice.Observer.BOUpdateData', 'ObserverUpData', patInfo.EpisodeID,patInfo.PatientID,patInfo.UserID,templateId,"SAVE");
    ajaxPOSTSync(data, function (ret) {
        if (ret != "")
        {
            var data = eval("["+ret+"]");
            $.each(data, function(index, item){
                if (item.Type == "PaPatMas")
                {
                    var array = {
                        "data":item.children,
                        "patientID":patInfo.PatientID,
                        "userID":patInfo.UserID
                    };
                    var arrayStr = base64encode(utf16to8(escape(JSON.stringify(array))));
                    createModalDialog("observerDialog","同步患者基本信息","617","323","iframeObserver","<iframe id='iframeObserver' scrolling='auto' frameborder='0' src='emr.observerdata.csp?ArrayStr="+arrayStr+"&openWay=editor&MWToken="+getMWToken()+"' style='width:607px; height:313px; display:block;'></iframe>",observerCallBack,"")
                }else if (item.Type == "WMRInfection")
                {
                    $.each(item.children, function(childindex, childitem){
                        //传染病上报
                        ReportWMRInfection(childitem.ActionInfo);
                    });
                }else if (item.Type == "NosocomialInfection")
                {
                    $.each(item.children, function(childindex, childitem){
                        //院内感染
                        ReportWMRInfection(childitem.ActionInfo);
                    });
                }
            });
        }
    }, function (ret) {
        $.messager.alert("简单提示", "同步信息获取失败！", "error");
    });
}

//同步患者基本信息模态框
function observerCallBack(returnValue,arr)
{
    if (returnValue)
    {
        showEditorMsg({msg:"同步数据项数据保存成功！", type:"info"});
    }
}

// 传染病上报,院内感染界面
function ReportWMRInfection(reportInfectionUrl)
{
    if (reportInfectionUrl == "") return;
    
    var c1 = String.fromCharCode(1);
    var arrReportInfection = reportInfectionUrl.split(c1);
    if (arrReportInfection[0] == "0")
    {
        top.$.messager.alert("提示信息", arrReportInfection[1]);
    }
    else if (arrReportInfection[0] == "1")
    {
        if (!window.confirm(arrReportInfection[1])) return;
        var c2 = String.fromCharCode(2);
        var arrReportInfectionUrl = arrReportInfection[2].split(c2);
        for (var i=0; i<arrReportInfectionUrl.length; i++)
        {
            if (arrReportInfectionUrl[i] == "") continue;
            try{
                var tmpUrl = arrReportInfectionUrl[i]
                if (tmpUrl.indexOf('?') != -1) {
                    tmpUrl = ret + '&MWToken='+getMWToken(); 
                } else {
                    tmpUrl = ret + '?MWToken='+getMWToken();
                }
                createModalDialog("infectionDialog","传染病上报","810","810","iframeInfection","<iframe id='iframeInfection' scrolling='auto' frameborder='0' src='"+tmpUrl+"' style='width:800px; height:800px; display:block;'></iframe>","","");
            }catch(e){
                top.$.messager.alert("提示信息", e.message);
            }
        }
    }
}

//自动同步患者基本信息
function AutoUpdateObserverData(templateId)
{
    var data = ajaxDATA('String', 'EMRservice.Observer', 'BLAutoUpdateData', patInfo.PatientID, patInfo.EpisodeID, patInfo.UserID, patInfo.IPAddress, templateId, "SAVE");
    ajaxGETSync(data, function (ret) {
        if (ret == "") return;
        if (ret != "1")
        {
            $.messager.alert("简单提示", "自动同步患者基本信息失败！", "error");
        }else {
            showEditorMsg({msg:"自动同步患者基本信息成功！", type:"info"});
        }
    }, function (ret) {
        $.messager.alert("简单提示","自动同步患者基本信息失败！", "error");
    });
}

//ctrl+K 快捷键事件
function eventRequestKnowledgeBase(commandJson){
    var instance = emrEditor.getDocContext();
    common.GetRecodeParamByInsIDSync(instance.InstanceID,function(param){
        cdssParam(param,"Save"); 
    });
}
//查看知识库
function eventSearchCdssBase(commandJson){
    if(commandJson.args.Value!=""){
        cdssParam(commandJson.args.Value);
    }
}
//调用第三方CDSS
function cdssParam(tempParam,type){
    var tool = typeof cdsstool != "undefined" ? cdsstool : parent.cdsstool;
	if (typeof tool != "undefined" )
	{
		tool.getData(tempParam,type)
	}  
}

function SaveDocumentAfter(insId){
    //保存后解锁
    unlockByIns(insId);
    if (sysOption.Observer.split("^")[0] == "Y")
    {
        if (sysOption.Observer.split("^")[1] == "Y")
        {
            common.getTemplateIDByInsId(insId, AutoUpdateObserverData);
        }else{
            common.getTemplateIDByInsId(insId, GetObserverData);
        }
    }
    //刷新历史就诊列表
    refreshAdmHistory();
    common.GetRecodeParamByInsIDSync(insId, function(tempParam) {
        //自动记录病例操作日志
        hisLog.operate('EMR.OP.Save.OK',tempParam);
        //保存调用CDSS
        cdssParam(tempParam,"Save"); 
    });
    
    //质控
    quality.saveChecker(insId);
    if ((typeof(_paramNow) !== 'undefined')&&(_paramNow.categoryId == plantToothTreatmentCategory))    //种植牙打开病历保存后的操作
    {
        if(document.getElementById("dentalimplantsFrame"))
        {
            var tempFrame = document.getElementById("dentalimplantsFrame").contentWindow;
            tempFrame.UpdateRecord(insId);
        }
    }
}

//将图库中选定图片插入到病历内
function imageCallBack(returnValue)
{
    if (getReadOnlyStatus().ReadOnly == "True") return;
    
    if (!returnValue || ("" === returnValue.ImageId)) return;
    iEmrPlugin.INSERT_IMG({
        ImageType: returnValue.ImageType,
        ImageId: returnValue.ImageId
    });
}

//修改结核病历目录
//选中当前结核病历的目录setSelectRecordColor
//删除当前结核病历的目录deleteListRecord
//修改结核病历目录打印setListPrinted
function phthisisFun(arg, fun)
{
    var tab = $('#dataTabs').tabs('getSelected');
    var id = tab.find('iframe')[0].id;
    if (id != "phthisisFrame") return;
    if (document.getElementById('phthisisFrame'))
    {
        var phthisisFrame = document.getElementById('phthisisFrame').contentWindow;
        var fn = phthisisFrame[fun];
        if (typeof fn === 'function') {
            fn(arg);
        }
    }
}

function dhcsys_getcacert_callback(returnValue)
{
    return returnValue;
}

//刷新历史就诊列表
function refreshAdmHistory()
{
    var tab = $('#dataTabs').tabs('getSelected');
    var id = tab.find('iframe')[0].id;
    if (id != "admHistoryFrame") return;
    if (document.getElementById('admHistoryFrame'))
    {
        var admHistoryFrame = document.getElementById('admHistoryFrame').contentWindow;
        var fn = admHistoryFrame.refreshAdmHistoryList;
        if (typeof fn === 'function') {
            fn();
        }
    }
}


///Desc:[取消pdf送签/获取签名后的PDF]操作后，编辑器需要由显示xml数据变为PDF数据或者由显示PDF数据变为显示xml数据，编辑器重新加载病历
function reLoadDocument(instanceID, pdfDocType) {
    
    var hasRealod = false;
    
    pdfDocType = pdfDocType || "XML";
    
    if (instanceID == "") 
    {
        instanceID = emrEditor.getInstanceID();
        if (instanceID == "") return hasRealod;
    }
    
    jQuery.ajax({
        type: "get",
        dataType: "json",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetParamByInstanceID",
            "p1":instanceID
        },
        success: function(d) {
            if (pdfDocType != d.pdfDocType) {
                hasRealod = true;
                d.actionType = "LOAD";
                d.reLoad = 1;
                emrEditor.loadDoc(d);
                modifyInstanceTabPDF(instanceID, d.pdfDocType);
            }
        },
        error: function(d) { 
            alert("getInstnaceparam error");
        }
    });
    
    return hasRealod;
}

function modifyInstanceTabPDF(instanceID, pdfDocType) {
    var record = emrTemplate.getTabRecordByInstID(instanceID);
    if (record != "") {
        record.pdfDocType = pdfDocType;
    }
    return;
}

/// 是否可以做患者端PDF签名
function canDoPDFSign(episodeID, instanceID) {
     var canDo = false;
    
     var argsData = {
            Action: 'CanDoPDFSign',
            episodeId: episodeID,
            instanceId: instanceID
        };
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
                if (ret == "1") {
                      canDo = true;
                } else {
                    alert(ret);
                }
            },
            error: function (err) {
                throw { message : 'CanDoPDFSign error:' + err };
            }
        });
        
     return canDo;
}

/// 获取可以续签的PDF数据
function getSignedPDF(episodeID, instanceID) {
     var tpdfBase64 = "";
    
     var argsData = {
            Action: 'getPDFBase64',
            episodeId: episodeID,
            instanceId: instanceID
        };
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
                  tpdfBase64 = ret
            },
            error: function (err) {
                throw { message : 'getPDFBase64 error:' + err };
            }
        });
        
        return tpdfBase64;
}

/// 获取患者签名关键字
function getPatSignKeyWord(insId, updateFlag) {
    var allKeyWord = '';
    updateFlag = updateFlag || false;
    
    var tname = "";
    var argsData = {
        Action: 'GetBatchSignInfo',
        //patientID: patientID,
        //episodeID: episodeID,
        instanceId: insId
    };
    $.ajax({
        type: 'POST',
        dataType: 'text',
        url: '../EMRservice.Ajax.anySign.cls',
        async: false,
        cache: false,
        data: argsData,
        success: function (ret) {
            //ret = $.parseJSON(ret);
            ret = eval("("+ret+")")
            if(ret.MIString.length) {
                for(var i=0;i<ret.MIString.length;i++) {
                    //更新编辑器示例数据
                    if (updateFlag) {
                        tname = "(" + ret.MIString[i].displayName+')';
                        updateInstanceData("Replace","",ret.MIString[i].path,tname);
                        if (allKeyWord == "")
                        {    allKeyWord = tname; }
                        else
                        {    allKeyWord = allKeyWord + "," + tname; }
                    } else {
                        tname = "[" + ret.MIString[i].displayName+']';
                        if (allKeyWord == "")
                        {    allKeyWord = tname; }
                        else
                        {    allKeyWord = allKeyWord + "," + tname; }
                    }
                }
                if (updateFlag) {
                    cmdsaveDocument();
                }
            }
        }
    });
    
    return allKeyWord;
}

/// 生成待签名PDF
function createToSignPDFBase64(insId, isCleanAllItem) {
     if ((typeof(ca_pdfcreator) == 'undefined')||(ca_pdfcreator == '')) {
        alert("虚拟打印机对象ca_pdfcreator不存在！");
        return "";
     }
     
     isCleanAllItem = isCleanAllItem || false;
     var argJson = {"action":"PRINT_DOCUMENT", "args":{"actionType":"PrintDirectly","InstanceID":insId,"IsSavePrintLog":"false","IsCleanAll":"False","SignLevel":[{"Level":"patient"}]}};
     if (isCleanAllItem) {
         argJson = {"action":"PRINT_DOCUMENT", "args":{"actionType":"PrintDirectly","InstanceID":insId,"IsSavePrintLog":"false"}};
     }
     return ca_pdfcreator.genPDFBase64("","",function(){
                cmdDoExecute(argJson);    
     });
}

//异步执行execute
function cmdDoExecute(argJson){
    iEmrPlugin.getPlugin().execute(JSON.stringify(argJson));
}

/// 患者端CA签名: 患者签名二维码
function getPatPushSignQR() {
    var instanceID = emrEditor.getInstanceID();
    
    var argsData = {
            Action: 'getPatPushSignID',
            InstanceID: instanceID
        };
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../EMRservice.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
                if (ret.split("^")[0] == "1") {
                    var patPushSignID = ret.split("^")[1];
                    if (patPushSignID == "") {
                        setMessage("没有已推送的待签PDF文档",'alert');
                    } else {
                        window.showModalDialog("../csp/dhc.certauth.patsign.tosignqr.csp?EpisodeID="+episodeID+"&PatPushSignID="+patPushSignID,"","dialogWidth:450px;dialogHeight:450px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
                    }
                } else if (ret == "0^") {
                    setMessage("没有已推送的待签PDF文档",'alert');
                } else {
                    alert(ret);
                }
            },
            error: function (err) {
                throw { message : 'getPatPushSignID error:' + err };
            }
        });
    
    
}

/// 患者端CA签名: 取消患者签名（停用，使用患者重签代替）
function cancelPatPushSign() {
    //alert("取消患者推送签名测试");
    
    var instanceID = emrEditor.getInstanceID();
    var userID = patInfo.UserID;
    
    jQuery.ajax({
            type : "GET", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : false,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLPDFAuditSignLog",
                    "Method":"CancelPatPushSign",            
                    "p1":instanceID,
                    "p2":userID
                },
            success: function(d) {
                    if (d.split("^")[0] == "1"){
                        setMessage(d.split("^")[1],'success');
                    } else if (d.split("^")[0] == "0") {
                        setMessage(d.split("^")[1],'alert');
                    } else {
                        alert(d);
                    }
            },
            error : function(d) { 
                alert("EMRservice.BL.BLEMRPushSign error");
                result = "0^EMRservice.BL.BLEMRPushSign.CancelPushSign服务异常\r\n" + d;
            }
        });        
}

/// 患者端CA签名: 获取推送签名结果
function fetchPatPushSignResult() {
    
    var instanceID = emrEditor.getInstanceID();
    var userID = patInfo.UserID;
    var pdfDocType = "XML";
    var record = emrTemplate.getTabRecordByInstID(instanceID);
    if (record != "") {
        pdfDocType = record.pdfDocType || "XML";
    }
    
    jQuery.ajax({
            type : "POST", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : false,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLPDFAuditSignLog",
                    "Method":"FetchSignResult",            
                    "p1":instanceID,
                    "p2":userID
                },
            success: function(d) {
                    if (d.split("^")[0] == "1"){
                        reLoadDocument(instanceID,pdfDocType);
                        setMessage(d.split("^")[1],'success');
                    } else if ((d.split("^")[0] == "0")) {
                        var reload = reLoadDocument(instanceID,pdfDocType);
                        if (!reload) {
                            setMessage(d.split("^")[1],'alert');
                        }
                    } else {
                        alert(d);
                    }
            },
            error : function(d) { 
                alert("EMRservice.BL.BLPDFAuditSignLog.FetchSignResult error");
                result = "0^EMRservice.BL.BLPDFAuditSignLog.FetchSignResult 服务异常\r\n" + d;
            }
        });        
}

/// 患者端CA签名: 患者重签
function invalidPatSignedPDF() {
    
    var instanceID = emrEditor.getInstanceID();
    var userID = patInfo.UserID;
    var pdfDocType = "XML";
    var record = emrTemplate.getTabRecordByInstID(instanceID);
    if (record != "") {
        pdfDocType = record.pdfDocType || "XML";
    }
    
    jQuery.ajax({
            type : "GET", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : false,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLPDFAuditSignLog",
                    "Method":"InvalidSignedPDF",            
                    "p1":instanceID,
                    "p2":userID,
                    "p3":patInfo.IPAddress
                },
            success: function(d) {
                    if (d.split("^")[0] == "1"){
                        reLoadDocument(instanceID,pdfDocType);
                        setMessage(d.split("^")[1],'success');
                    } else if (d.split("^")[0] == "0") {
                        var reload = reLoadDocument(instanceID,pdfDocType);
                        if (!reload) {
                            setMessage(d.split("^")[1],'alert');
                        }
                    } else {
                        alert(d);
                    }
            },
            error : function(d) { 
                alert("EMRservice.BL.BLPDFAuditSignLog error");
                result = "0^EMRservice.BL.BLPDFAuditSignLog.InvalidSignedPDF服务异常\r\n" + d;
            }
        });        
}

function setMessage(msg, type) {
    showEditorMsg({msg:msg,type:type})
}

//Word撤销签名
function revokeWordSign(userInfo,signProperty,instanceId)
{
    var ret = {"result":"ERROR"};
    var userLevel = signProperty.SignatureLevel;
    var isSuperiorSign = IsSuperiorSign(userLevel,instanceId);
    if (isSuperiorSign == "1")
    {
        $.messager.popover({msg:'上级医师已签名，需上级医师撤销后才可撤销签名！', type:'info', style:{top:10,right:5}});
    }
    else
    {
        ret = iEmrPlugin.REVOKE_SIGNED_DOCUMENT({
                SignatureLevel: userLevel,
                InstanceID: instanceId,
                isSync: true
            });
    }
    return ret;
}

//判断
function IsSuperiorSign(userLevel,instanceId)
{
    var result = "0";
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLEMRSign",
            "Method":"IsSuperiorSign",
            "p1":userLevel,
            "p2":instanceId
        },
        success: function(ret) {
            result = ret;

        },
        error: function(ret) {alert(ret);}
    });
    return result;    
}

//结核病历保存后调用方法
function PhthisisSaveFunc(documentContext,insId)
{
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', insId);
    ajaxGETSync(data, function (ret) {
        if (ret !== "") {
            common.GetSyncSavedFirstMultiRecord(ret, insId, function(insData) {
                //是否存在Tab签，是：选中Tab签，否：新增并选中Tab签
                var tabId = emrTemplate.getTabId(insData.templateId, insData.id);
                var isSelected = false;
                if ('1' == insData.isLeadframe) {
                    isSelected = true;
                }
                //结核病历
                if (sysOption.PhthisisEpisodeIDs !== "") {
                    if (-1 != $.inArray(ret, sysOption.PhthisisEpisodeIDs.split(","))) {
                        insData["epsiodeId"] = ret;
                        documentContext["insData"] = insData;
                        //修改结核病历目录
                        phthisisFun(documentContext,"modifyListRecord");
                    }
                }
                if (!emrTemplate.selectTmplTab(tabId, isSelected)) {
                    envVar.savedRecords.push(insData);
                    emrTemplate.addTab(insData.templateId, insData.id, insData.text, true, '1' == insData.isLeadframe);
                }
                
            });
        }
    }, function (ret) {
        alert('保存时，getAdmByInstanceID error:' + ret);
    });
}

//章节内插入文本数据
function insertSectionByName(data) {
	var arrData = data;
	for (var i = 0; i < arrData.length; i++) {
        var item = arrData[i];
        var name = item.SectionName;
        var text = item.SectionText;
        if (name == "") continue;
        name = name.replace(/\s/g,"");
        
        if (focusElementLastByName(name)) {
			iEmrPlugin.INSERT_TEXT_BLOCK({
				args: text
			});
        }
    }	
}

///按照章节名定位光标
function focusElementLastByName(sectionName) {
	if (sectionName == "") return false;
	var metaTree = iEmrPlugin.GET_METADATA_TREE({
		isSync: true
	});
	for (var i = 0; i < metaTree.items.length; i++) {
        var item = metaTree.items[i];
        if (item.Code == "Header") continue;
        if (item.Code == "Footer") continue;
        var displayName = item.DisplayName;
        displayName = displayName.replace(/\s/g,"")
        if (displayName.indexOf(sectionName) >= 0) {
        	iEmrPlugin.FOCUS_ELEMENT({
      			Path: item.Code,
      			actionType : 'Last'
   			});
   			return true;
        }
    }
    return false;
}