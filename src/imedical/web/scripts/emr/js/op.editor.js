var emrEditor = {
    newEmrPlugin: function() {
        if (!iEmrPlugin) {
            iEmrPlugin = new iEmrPluginEx(window.frames['editorFrame']);
        }
    },
    refreshKBFunc: undefined, //资源区刷新相关的知识库委托
    sectionResFunc: null, //刷新相关资源区委托
    SectionCode: '', //记录当前选中的章节的code，用户刷新相关的资源区知识库
    createAsLoad: false,
    createByInsAsLoad:false,
    resourceWindow: null,
    showResourceWindow: function() {
        emrEditor.resourceWindow = window.showModelessDialog('emr.op.resource.window.csp', window, 'dialogHeight:500px;dialogWidth:600px;resizable:no;status:no');
    },
    closeResourceWindow: function() {
        if (emrEditor.resourceWindow && !emrEditor.resourceWindow.closed) {
            emrEditor.resourceWindow.close();
            emrEditor.resourceWindow = null;
        }
    },
    getModifyResult: function(InstanceID) {
        return iEmrPlugin.CHECK_DOCUMENT_MODIFY({
            InstanceID: InstanceID || '',
            isSync: true
        });
    },
    getDocContext: function(InstanceID) {
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
    getInstanceID: function() {
        this.getDocWithoutPrivilege('');
        if (!envVar.docContext)
            return '';
        return (envVar.docContext.InstanceID || '');
    },
    //保存文档，正常执行返回true,
    saveDoc: function(documentContext, callback, extraArgs) {
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

        var modifyResult = this.getModifyResult();
        if (this.createAsLoad && modifyResult.Modified != 'True') {
            iEmrPlugin.RESET_MODIFY_STATE({
                InstanceID: '',
                State: true
            });
            this.createAsLoad = false;
        }
        modifyResult = iEmrPlugin.CHECK_DOCUMENT_MODIFY({
            isSync: true
        });

        if ('False' === modifyResult.Modified) {
            showEditorMsg('文档没有发生改变!', 'alert');
            if ('function' === typeof callback) {
                callback();
            }
            return;
        }

        var returnFlag = false ;
        if ((quality.requiredObject(documentContext)) && ('' !== sysOption.ReturnTemplateIDs)) {
            common.getTemplateIDByInsId(documentContext.InstanceID, function(tmpId) {
                if (sysOption.ReturnTemplateIDs.indexOf('^' + tmpId + '^') != '-1') {
                    returnFlag = true;    
                    if ('function' === typeof callback)
                        callback({
                            result: false
                    });                
                }
            });
            if (returnFlag) return;
        }
        

        var escapeRevokeSignDocIDArray = new Array(); 
        escapeRevokeSignDocIDArray = sysOption.escapeRevokeSignDocID.split("^");
        var result = {result:false,requestSign:""}
        var instance = emrEditor.getDocWithoutPrivilege();
        common.GetRecodeParamByInsIDSync(instance.InstanceID,function(param){
            if ($.inArray(param.emrDocId,escapeRevokeSignDocIDArray) == -1)
            {
                 var result = emrEditor.doRevokeSignedDocument(modifyResult, (extraArgs || {})['signElementPath']);
            }
            flag = result.result;
            if (!flag) {
                editorEvt.evtAfterSave = function (commandJson) {
                    commandJson.requestSign = result.requestSign;
                    if ('function' === typeof callback) {
                            callback(commandJson);
                    }
                };
                //调用平台方法，用途锁定头菜单
                setSysMenuDoingSth('病历保存中...');
                iEmrPlugin.SAVE_DOCUMENT();
            }else {
                if ('function' === typeof callback) {
                    callback({requestSign: result.requestSign});
                }
            }
            return;
        });
    },
    //打印 ： printArg Print/PrintDirectly
    printDoc: function(printArg, documentContext) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;
        if (!privilege.canPrint(documentContext)) {
            return;
        }
     
        var instanceId = emrEditor.getInstanceID();
        if (instanceId === '') return;
        var id = common.isPrinted(instanceId);
        if (id == '1') {
            var titleName = documentContext.Title.DisplayName;
            var text = '病历 "' + titleName + '" 已打印，是否再次打印';
            var returnValues = window.showModalDialog("emr.printprompt.csp", text, "dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
            if (returnValues == "cancel") return;
        }
        
        //自动保存如未配置打印动作，进行提醒
        var modifyResult = emrEditor.getModifyResult();
        if (modifyResult.Modified == 'True')&&((','+sysOption.OPAutoSave+',').indexOf(',print,') == "-1")
        {
            var text = '文档正在编辑，请保存后打印，是否保存？';
            //判断客户端浏览器IE及其版本
            if ($.browser.msie && $.browser.version == '6.0')
            {
                returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
            }
            else
            {
                returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
            }
            if (returnValues !== "save")
            {
                return;
            }
        }
        
        var fnAfterSave = function(commandJson) {
            if (commandJson && commandJson.args) {
                if (commandJson.args.result === 'ERROR')
                    return;
                //else if (commandJson.QCResult === false)
                //    return;
            }

            if (!quality.printChecker(documentContext))
                return;

            setSysMenuDoingSth('病历打印中...');
            iEmrPlugin.PRINT_DOCUMENT({
                args: printArg || 'Print'
            });
        }

        this.saveDoc(documentContext, fnAfterSave);
    },
    //删除
    deleteDoc: function(documentContext) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;

        if (!privilege.canDelete(documentContext)) {
            return;
        }

        if (confirm('确定删除【' + documentContext.Title.DisplayName + '】?')) {
            //判断是否要求验证密码
            var creatorMessage = common.getCreatorMessage(documentContext.InstanceID);
            if ((sysOption.isDeleteVerification == "Y")&&(creatorMessage.status != "UNSAVE"))
            {
                if (creatorMessage != "")
                {
                    if ((creatorMessage.creatorID != "")&&(creatorMessage.creatorName != ""))
                    {	
                        var result = window.showModalDialog("emr.userverification.delete.csp?UserID="+creatorMessage.creatorID+"&UserName="+creatorMessage.creatorName,"","dialogHeight:200px;dialogWidth:180px;resizable:no;status:no");
                        if ((result == "")||(typeof(result) == "undefined")) 
                        {
                            return;
                        }
                        else if(result == "0")
                        {
                            alert("密码验证失败");
                            return;
                        }
                    }
                }
            }
            iEmrPlugin.DELETE_DOCUMENT({
                InstanceID: documentContext.InstanceID
            });
        }
    },
    //新建文档
    createDoc: function (docParam) {
        if (docParam == null)
            return;
        sysOption.pluginType = docParam.pluginType;
        this.setPlugin(docParam.chartItemType);
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
            this.createAsLoad = true;
            setSysMenuDoingSth('病历创建中...');
            iEmrPlugin.CREATE_DOCUMENT({
                AsLoad: this.createAsLoad,
                DisplayName: docParam.text
            });
        } else {
            var defaultLoadId = common.getDefaultLoadId(docParam.emrDocId, patInfo.UserLocID,docParam.templateId);
            if (defaultLoadId == "") {
                if (!isGuideBox) {
                    this.createAsLoad = true;
                    setSysMenuDoingSth('病历创建中...');
                    iEmrPlugin.CREATE_DOCUMENT({
                        AsLoad: this.createAsLoad,
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
        //自动记录病例操作日志
        hisLog.create('EMR.OP.CreateDoc',docParam);
        //创建病历 调用CDSS
        var instance = emrEditor.getDocWithoutPrivilege();
        docParam.id=instance.InstanceID;
       	cdssParam(docParam,'create');
    },
    isOpened: function(docParam) {

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
    loadDoc: function(docParam) {
        if (docParam == null)
            return;
        //引入范例病历之后，只能用实例id来判断
        if (this.isOpened(docParam))
            return;

        sysOption.pluginType = docParam.pluginType;
        this.setPlugin(docParam.chartItemType);
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        if (privilege.getViewPrivilege(docParam).canView == '0') {
            showEditorMsg('您没有权限查看此病历！', 'forbid');
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
        //自动记录病例操作日志
        hisLog.operate('EMR.OP.LoadDoc',docParam);
        //加载病历调用CDSS
		cdssParam(docParam,"Save");
    },
    cleanDoc: function() {
        iEmrPlugin.CLEAN_DOCUMENT();
    },
    // 失效病历的时候会同时向后台保存文档的，返回值影响后续保存操作
    // 执行了撤销或是出现异常的情况下，返回True 、其他情况返回False
    doRevokeSignedDocument: function(modifyResult, signElementPath) {
        // 参数配置是否开启签名失效，配置参数为N时不开启撤销签名
        if (sysOption.isRevokeSign === 'N')
            return { result: false};
        var that = this;
        var result = false;
        var requestSign;
        var revokeStatus = privilege.GetRevokeStatus();
        for (var i = 0; i < modifyResult.InstanceID.length; i++) {
            var instanceId = modifyResult.InstanceID[i];
            var tmpDocContext = that.getDocContext(instanceId);
       		if (!privilege.canSave(tmpDocContext))
	            continue;
            
            var userLevel = common.getUserInfo().UserLevel;
            if (revokeStatus != 'Superior')
                userLevel = '';
            /*var revokeInfo = iEmrPlugin.GET_REVOKE_SIGNER_INFO({
                SignatureLevel: userLevel,
                InstanceID: instanceId,
                isSync: true
            });
            if (revokeInfo.result == "ERROR"){
                showEditorMsg('失效文档信息获取失败!','warning');
                result = true;
                break;
            }else{
                if((typeof(revokeInfo.Authenticator) != "undefined")&&(revokeInfo.Authenticator.length>0))
                {
                    // 有失效签名时给予提示
                    var text = '本次保存会使 "' +revokeInfo.HappenDateTime+' '+revokeInfo.Title+ '" 的';
                    var name = ""
                    $.each(revokeInfo.Authenticator, function(idx, val){
                        if (name == ""){
                            name = val.Name;
                        }else{
                            name += "、"+val.Name;
                        }
                    });
                    text += name+'签名失效，是否确认保存修改?'
                    if(!confirm(text)) {
                        result = true;
                        break;
                    }
                }
            }*/
            
            var revokeResult = iEmrPlugin.REVOKE_SIGNED_DOCUMENT({
                SignatureLevel: userLevel,
                InstanceID: instanceId,
                SignElementPath: signElementPath || '',
                isSync: true
            });
            if (revokeResult.result === 'ERROR') {
                showEditorMsg('撤销文档签名失败!', 'warning');
                if (!result) {
                    result = true;
                }
                break;
            } else {
                requestSign = revokeResult.RequestSign;
                //没有要撤销签名的数据,直接保存就可以了
                if (typeof(revokeResult.Authenticator) === "undefined" || revokeResult.Authenticator.length <= 0) {
                    continue;
                }
                showEditorMsg('文档签名已经被撤销!', 'warning');
                result = true;
                if (tmpDocContext.result == 'ERROR' && !result) {
                    result = true;
                }
                showEditorMsg('数据保存成功,签名已失效!', 'warning');
                
                //启用病历信息订阅与发布
                if (sysOption.Observer.split("^")[0] == "Y")
                {
                    if (sysOption.Observer.split("^")[1] == "Y")
                    {
                        common.getTemplateIDByInsId(instanceId, AutoUpdateObserverData);
                    }else{
                        common.getTemplateIDByInsId(instanceId, GetObserverData);
                    }
                }
                //质控
                quality.saveChecker(tmpDocContext);
                
                common.GetRecodeParamByInsID(instanceId, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Save.OK',tempParam);
                });
            }
        }

        return { result: result, requestSign: requestSign};
    },
    ///初始化页面
    initDocument: function(autoLoadTmp) {
        emrTemplate.closeAllTabs();
        if (envVar.savedRecords.length > 0) {
            var docParam = envVar.savedRecords[0];
            if (docParam == null) setReadonly(true);
            this.loadDoc(docParam);
            emrTemplate.loadTmplTabs(envVar.savedRecords, docParam.templateId, docParam.id);
        } else if (autoLoadTmp || true) {
            if (sysOption.isAutoSelectTemplate === 'Y' && patInfo.EpisodeID !== '') {
                hideLoadingWinFun();
                if (showTemplateTree())
                    return;
            }
            if (envVar.firstTmpl == null) {
                if (patInfo.EpisodeID !== '')
                    showEditorMsg('未找到默认病历模板！', 'forbid');
                setPnlBtnDisable(true);
                hideLoadingWinFun();
                //setReadonly(true);
                return;
            }
            this.createDoc(envVar.firstTmpl);
        }
        //this.setEditorReadonly();
    },
    reloadBinddata: function(insID) {
        insID = insID || emrEditor.getInstanceID();
        //获取是否显示同步提示框状态
        var data = ajaxDATA('String', 'EMRservice.BL.BLRefreshBindData', 'getBindDataSyncDialogVisible', insID);
        ajaxGET(data, function(ret) {
            if (ret !== 'False') {
                //显示同步提示框
                iEmrPlugin.REFRESH_REFERENCEDATA({
                    InstanceID: insID || '',
                    AutoRefresh: true,
                    SyncDialogVisible: true,
                    SilentRefresh: false
                });
                common.GetRecodeParamByInsID(insID, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.BinddataReload',tempParam);
                });
            }
        }, function(ret) {
            alert('getBindDataSyncDialogVisible error:' + ret);
        });
    },
    setEditorReadonly: function(documentContext) {
        var flag = isReadonly();
        setPnlBtnDisable(false);

        //审核页面只读病历
        if (typeof envVar.isOfficeAudit !== 'undefined') {
        	if (envVar.isOfficeAudit) {
	        	flag = true;
	        }
        }
        
        //补打页面只读病历
        if (typeof envVar.isPrintSearch !== 'undefined') {
        	if (envVar.isPrintSearch) {
	        	flag = true;
	        }
        }
        
        if (flag) {
            iEmrPlugin.SET_READONLY({
                ReadOnly: true
            });
        } else {
            documentContext = documentContext || this.getDocContext();
            flag = !privilege.canSave(documentContext);
            iEmrPlugin.SET_READONLY({
                ReadOnly: flag
            });
        } 
    },
    setPlugin: function(chartItemType) {
        if (sysOption.pluginType === 'DOC') {
            iEmrPlugin.showWord();
            iEmrPlugin.attachWord(sysOption.pluginUrl, sysOption.pluginType, sysOption.argConnect, editorEvt.eventDispatch);

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

        } else {
            iEmrPlugin.showGrid();
            iEmrPlugin.attachGrid(sysOption.pluginUrl, sysOption.pluginType, sysOption.argConnect, editorEvt.eventDispatch);

        }
    },
    /// 对外接口 异步执行
    cmdPlugin: function(action, argParams) {
        var fn = iEmrPlugin[action];
        if (typeof fn !== 'function')
            throw ('未实现方法：' + action);
        argParams = argParams || {};
        argParams['isSync'] = false;
        fn.apply(iEmrPlugin, argParams);
    },
    /// 对外接口 同步执行
    cmdPluginSync: function(action, argParams) {

        var fn = iEmrPlugin[action];
        if (typeof fn !== 'function')
            throw ('未实现方法：' + action);
        argParams = argParams || {};
        argParams['isSync'] = true;
        return fn.apply(iEmrPlugin, argParams);
    },
    /// 病历引用
    createDocFromInstance: function(insData) {
        var ret = common.IsAllowMuteCreate(insData.emrDocId);
        if (ret === '0') {
            alert('已创建同类型模板，不允许继续创建！');
            return;
        }
        
        var DocID = common.getEmrDocId(insData.emrDocId);
        if (DocID === '0') {
            alert('未创建此病历模板权限，请检查模板权限配置！'+ insData.emrDocId);
            return;
        }
        
        var that = this;

        function createDocByInstance(insID) {
            sysOption.pluginType = insData.pluginType;
            that.setPlugin(insData.chartItemType);
            iEmrPlugin.SET_PATIENT_INFO({
                args: patInfo
            });
            iEmrPlugin.SET_CURRENT_REVISOR({
                Id: patInfo.UserID,
                Name: patInfo.UserName,
                IP: patInfo.IPAddress
            });
            that.createAsLoad = true;
            that.createByInsAsLoad = true;
            iEmrPlugin.CREATE_DOCUMENT_BY_INSTANCE({
                InstanceID: insID,
                TitleCode: '',
                AsLoad: that.createAsLoad
            });
            //自动记录病例操作日志
            hisLog.create('EMR.OP.AdmHistoryLst.CreateDoc',insData);
        }

        //如果无实例，则直接创建
        id = common.IsExistInstance(insData.emrDocId);
        if ("0" == id) {
            createDocByInstance(insData.id);
            return;
        }

        if ('Single' == insData.chartItemType) { // 唯一模板
            var tabId = emrTemplate.getTabId(insData.templateId, id);
            emrTemplate.selectTmplTab(tabId);
            if (confirm('已经创建同类型的文档，确定删除【' + insData.text + '】并重新创建?')) {
                var documentContext = that.getDocContext(id);
                if (!documentContext)
                    return;
                if (!privilege.canDelete(documentContext)) {
                    return;
                }
                var creatorMessage = common.getCreatorMessage(documentContext.InstanceID);
                if ((sysOption.isDeleteVerification == "Y")&&(creatorMessage.status != "UNSAVE"))
                {
                    if (creatorMessage != "")
                    {
                        if ((creatorMessage.creatorID != "")&&(creatorMessage.creatorName != ""))
                        {	
                            var result = window.showModalDialog("emr.userverification.delete.csp?UserID="+creatorMessage.creatorID+"&UserName="+creatorMessage.creatorName,"","dialogHeight:200px;dialogWidth:180px;resizable:no;status:no");
                            if ((result == "")||(typeof(result) == "undefined")) 
                            {
                                return;
                            }
                            else if(result == "0")
                            {
                                alert("密码验证失败");
                                return;
                            }
                        }
                    }
                }
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
                    createDocByInstance(insData.id);
                }
            } else {
                return;
            }
        } else if ('1' == insData.isLeadframe) { // 带引导框的可重复
            var tabId = emrTemplate.getTabId(insData.templateId, id);
            emrTemplate.selectTmplTab(tabId);
            createDocByInstance(insData.id);
        } else { // 不带引导框的可重复
            createDocByInstance(insData.id);
        }
    },
    confirmAndSave: function(fnConfirm, isSync, documentContext) {

        isSync = isSync || false;
        documentContext = documentContext || this.getDocContext();
        
        if (!documentContext)
            return false;
        
		var modifyResult = this.getModifyResult();
        if (modifyResult.Modified !== 'True')
            return false;
		
        if (!privilege.canSave(documentContext))
            return false;

        var returnFlag = false ;
        if ((quality.requiredObject(documentContext)) && ('' !== sysOption.ReturnTemplateIDs)) {
            common.getTemplateIDByInsId(documentContext.InstanceID, function(tmpId) {
                if (sysOption.ReturnTemplateIDs.indexOf('^' + tmpId + '^') != '-1') {
                    returnFlag = true;    
                    if ('function' === typeof callback)
                        callback({
                            result: false
                    });                
                }
            });
            if (returnFlag) return;
        }
        
        if (typeof fnConfirm === 'function') {
            if (!fnConfirm(documentContext))
                return false;
            
            if (!isConsistent(documentContext))
                return false;
            
            var flag = (this.doRevokeSignedDocument(modifyResult)).result;

            if (!flag) {
                /*iEmrPlugin.SAVE_DOCUMENT({
                    isSync: isSync
                });*/
                iEmrPlugin.SAVE_DOCUMENT();
                return true;
            }
        }

        return false;
    },
    /// save / unsave / cancel
    savePrompt: function(isSync, documentContext) {
        var returnValues = '';
        var fnSavePrompt = function(documentContext) {
            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';

            returnValues = window.showModalDialog('emr.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
            return returnValues === 'save';
        };
        this.confirmAndSave(fnSavePrompt, isSync, documentContext);
        return returnValues;
    },
    saveConfirm: function(isSync, documentContext) {
        var ret = false;
        var fnSaveConfirm = function(documentContext) {
            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
            ret = confirm(msgText);
            return ret;
        };
        this.confirmAndSave(fnSaveConfirm, isSync, documentContext);
        return ret;
    },
    getHyperLinkPath: function(items, displayName) {
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
        //var strJson = eval("("+returnValue+")");
        //var strJson = $.parseJSON(returnValue);
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
        /*
        var strJson = {
            action:"INSERT_TEETH_IMAGE",
            args:{
                "InstanceID":"",
                "ShowMode":"恒牙",
                "UpLeftAreaTeeth":[
                    {"ToothCode":"AUL.1","ToothValue":"1","ToothSurfaceValue":"P,L","ToothSurfaceItems":
                        [
                            {"Code":"AUL.1.P","Value":"上颌左侧中切牙腭侧","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.1.L","Value":"上颌左侧中切牙舌侧","ScriptMode":"SuperScript/SubScript"}
                        ]
                    },
                    {"ToothCode":"AUL.2","ToothValue":"2","ToothSurfaceValue":"P,L,B,D,O,M,I,R,T","ToothSurfaceItems":
                        [
                            {"Code":"AUL.2.P","Value":"上颌左侧侧切牙腭侧","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.L","Value":"上颌左侧侧切牙舌侧","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.B","Value":"上颌左侧侧切牙颊侧","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.D","Value":"上颌左侧侧切牙远中面","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.O","Value":"上颌左侧侧切牙牙合面","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.M","Value":"上颌左侧侧切牙近中面","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.I","Value":"上颌左侧侧切牙切缘","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.R","Value":"上颌左侧侧切牙根","ScriptMode":"SuperScript/SubScript"},
                            {"Code":"AUL.2.T","Value":"上颌左侧侧切牙冠","ScriptMode":"SuperScript/SubScript"}
                        ]
                    }
                ],
                "UpRightAreaTeeth":"",
                "DownLeftAreaTeeth":"",
                "DownRightAreaTeeth":""
            }
        };
        //alert(strJson);
        */
        //iEmrPlugin.INSERT_TEETH_IMAGE(strJson);
    },
    foo: function() {}
};

var editorEvt = {
    //设置链接串
    eventSetNetConnect: function(commandJson) {
        if (commandJson.args.result != 'OK')
            alert('设置链接失败！');
    },
    //文档改变事件
    eventDocumentChanged: function(commandJson) {
        if ('' === commandJson.args.InstanceID)
            return;
        var btnRevisionVisible = $('#btnRevisionVisible');
        if (btnRevisionVisible.length !== 0 && btnRevisionVisible.text() === '隐藏痕迹') {
            btnRevisionVisible.text('显示痕迹');
        }
        var btnPreview = $('#btnPreview');
        if (btnPreview.length !== 0 && btnPreview.text() === '退出预览') {
            iEmrPlugin.PREVIEW_DOCUMENT({
                Preview: false
            });
            btnPreview.text('预览');
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
        refreshModelRecord();
    },
    //章节改变事件
    eventSectionChanged: function(commandJson) {
        emrEditor.SectionCode = commandJson.args.Code;
        if ('function' === typeof emrEditor.sectionResFunc)
            emrEditor.sectionResFunc();
        //刷新知识库
        var paramJson = {
            'action': 'refreshKBNode',
            'code': commandJson.args.Code,
            'bindKBBaseID': commandJson.args.BindKBBaseID,
            'titleCode': sysOption.titleCode
        };
        refreshKBNode(paramJson);
    },
    //保存事件监听
    eventSaveDocument: function(commandJson) {
        //调用平台方法，用途锁定头菜单
        setSysMenuDoingSth();
        if (commandJson.args.result === 'ERROR') {
            envVar.groupTempParam.length = 0;
            alert('保存失败');
            return;
        } else if (commandJson.args.result === 'OK') {
            if (commandJson.args.params.result === 'OK') {
                showEditorMsg('数据保存成功!', 'alert');
                emrEditor.createAsLoad = false;
                var insId = commandJson.args.params.InstanceID;
                //启用病历信息订阅与发布
                if (sysOption.Observer.split("^")[0] == "Y")
                {
                    if (sysOption.Observer.split("^")[1] == "Y")
                    {
                        common.getTemplateIDByInsId(insId, AutoUpdateObserverData);
                    }else{
                        common.getTemplateIDByInsId(insId, GetObserverData);
                    }
                }
                common.GetRecodeParamByInsID(insId, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Save.OK',tempParam);
                });
                var documentContext = emrEditor.getDocWithoutPrivilege(insId);
                //commandJson['QCResult'] = quality.saveChecker(documentContext);
                common.getSavedRecords(function(ret) {
                    envVar.savedRecords = $.parseJSON(ret);
                    common.getTemplateIDByInsId(insId, function(tmpId) {
                        emrTemplate.loadTmplTabs(envVar.savedRecords, tmpId, insId);
                        if (envVar.groupTempParam.length > 0) {
                            if (!emrTemplate.LoadGroupTemplate(envVar.groupTempParam[0])) {
                                envVar.groupTempParam.length = 0;
                            }
                        }
                    });
                });
		//保存调用CDSS
                common.GetRecodeParamByInsIDSync(insId,function(param){
	               cdssParam(param,"Save"); 
	            });
            } else {
                alert('数据保存失败!');
            }
        } else if (commandJson.args.result === 'NONE') {
            showEditorMsg('文档没有发生改变!', 'alert');
        }
        editorEvt.raiseEvent('evtAfterSave', commandJson);
    },
    //提示用户保存文档
    eventQuerySaveDocumentfunction: function(commandJson) {
        alert('新建文档保存后才可创建新文档');
    },
    //获得文档大纲
    eventGetDocumentOutline: function(commandJson) {},
    //创建文档事件
    eventCreateDocument: function(commandJson) {
        setSysMenuDoingSth();
        hideLoadingWinFun();
        //通过实例创建文档，把文档修改状态改为True
        var modifyResult = emrEditor.getModifyResult();
        if (emrEditor.createByInsAsLoad && modifyResult.Modified != 'True') {
            iEmrPlugin.RESET_MODIFY_STATE({
                InstanceID: '',
                State: true
            });
            emrEditor.createByInsAsLoad = false;
        }
        
        if (commandJson.args.result === 'ERROR') {
            envVar.groupTempParam.length = 0;
            //串病历时编辑器会返回创建失败，清空文档
            emrEditor.cleanDoc();
            alert('创建失败！');
            return;
        }
        emrEditor.setEditorReadonly();
        // 批量创建
        if (envVar.groupTempParam.length > 0) {
            envVar.groupTempParam.splice(0,1);
            emrEditor.saveDoc();
        }
    },
    //加载文档事件
    eventLoadDocument: function(commandJson) {
        setSysMenuDoingSth();
        hideLoadingWinFun();
        if (commandJson.args.result === 'ERROR') {
            emrEditor.cleanDoc();
            alert('加载失败！');
            return;
        }
        //加载文档后修改createAsLoad状态，处理切换患者后不修改病历也会保存导致签名失效的问题
        emrEditor.createAsLoad = false;
        
        //加载完毕后判断是否存在串病历情形，如果存在给予提示并清空文档
        var documentContext = emrEditor.getDocContext(commandJson.args.InstanceID);
		if (!isConsistent(documentContext))
		{
			emrEditor.cleanDoc();
			return;
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
        
        if (!isReadonly()) {
            if (privilege.canSave(documentContext))
	        {
                emrEditor.reloadBinddata(commandJson.args.InstanceID);
		    }
            emrEditor.reloadBinddata(commandJson.args.InstanceID);
            privilege.setRevsion(documentContext);
            privilege.setViewRevise(documentContext, function() {
                var btn = $('#btnRevisionVisible');
                if (btn.length !== 0 && $('#btnRevisionVisible').text() === '隐藏痕迹') {
                    $('#btnRevisionVisible').text('显示痕迹');
                }
                return false;
            });
        }
        emrEditor.setEditorReadonly(documentContext);
    },
    //文档签名事件
    eventSaveSignedDocument: function(commandJson) {
        if ((commandJson.args.result == 'OK') && (commandJson.args.params.result == 'OK')) {
            showEditorMsg('数据签名成功!');
            var insId = commandJson.args.params.InstanceID;
            common.GetRecodeParamByInsID(insId, function(tempParam) {
                //自动记录病例操作日志
                hisLog.operate('EMR.OP.Sign.OK',tempParam);
            });
            var documentContext = emrEditor.getDocContext();
            privilege.setRevsion(documentContext);
            privilege.setViewRevise(documentContext, function() {
                var txt = $('#btnRevisionVisible').text();
                return txt === '隐藏痕迹';
            });
        } else {
            alert('保存签名数据失败!');
            var ret = iEmrPlugin.UNSIGN_DOCUMENT({
                isSync: true
            });
            if ('ERROR' === ret.result)
                alert('撤销最后一次签名失败！');
        }
    },
    //删除文档
    eventDeleteDocument: function(commandJson) {
        if (commandJson.args.result === 'OK') {
            try {
                showEditorMsg('病历删除成功！');
                common.GetRecodeParamByInsID(commandJson.args.InstanceID, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Delete.OK',tempParam);
                });
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
                            emrEditor.createDoc(envVar.firstTmpl);
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
                                        emrEditor.createDoc(envVar.firstTmpl);
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
               common.GetRecodeParamByInsIDSync(commandJson.args.InstanceID,function(param){
	               cdssParam(param,"Delete"); 
	            });
            } catch (err) {
                alert(err.message || err);
            } finally {
                editorEvt.raiseEvent('evtAfterDelete', commandJson);
            }
        }
    },
    eventAppendComposite: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("appendComposite");
            //chartOnBlur();
        }
    },
    eventUpdateInstanceData: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("updateInsByEmr");
        }
    },
    eventInsertTextBlock: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave("insertText");
        }
    },
    // 打开链接单元
    eventHyperLink: function(commandJson) {
        var operation = commandJson.args.Url;
        if ('' == operation) return;
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetUnitLink', operation);
        ajaxGET(data, function(ret) {
            ret = $.parseJSON(ret);
            if (ret && ret.Err) {
                alert('获取' + operation + '链接：' + ret.Err);
            } else {
                if (null != ret) {
                    if ('switchTabByEMR' === ret.Method) {
                        var fn = parent.switchTabByEMR;
                        if ('function' === typeof fn)
                            fn(ret.Title);
                        else
                            alert('switchTabByEMR未定义！')
                    } else if ('switchDataTab' === ret.Method) {
                        HisTools.dataTabs.switchDataTab(ret.Title);
                    } else {
                        HisTools.hislinkWindow.openUnitLink(ret, commandJson.args);
                    }
                } else {
                    alert('请检查链接单元【' + operation + '】配置！');
                }
            }
        }, function(ret) {
            alert('获取' + operation + '链接：' + ret);
        });
    },
    //判断知识库是否替换成功
    eventReplaceComposite: function(commandJson) {
        if (commandJson.args.result === 'OK') {
            showEditorMsg('知识库替换成功!', 'alert');
            eventSave("replaceComposite");
        } else {
            showEditorMsg('知识库替换失败!', 'warning');
        }
    },
    //快捷热键的通知事件
    eventHotKey: function(commandJson) {
        if ('' == commandJson.args.KeyState && 'F2' == commandJson.args.Key && 'Y' == sysOption.useResWindowHotkey) {
            emrEditor.showResourceWindow();
        }
    },
    //在签名单元上触发的事件，由双击触发
    eventRequestSign: function(commandJson) {
        if (isReadonly()) return;
        var documentContext = emrEditor.getDocContext();
        var instanceId = documentContext.InstanceID;
        var signProperty = commandJson.args;

        var fnAfterSave = function(commandJson) {
            if (commandJson) {
                if (commandJson.args && commandJson.args.result === 'ERROR')
                    return;
                //else if (commandJson.QCResult === false)
                //    return;
            }
            signProperty = (commandJson||{})['requestSign'] || signProperty;
            var qualityResult = quality.signChecker(documentContext);
            if (!qualityResult) {
                return;
            }
            
            //患者手写签名
            if ('PATIENT' == signProperty.OriSignatureLevel.toUpperCase()) { 
                if ((!privilege.canPatCheck(documentContext))&&(signProperty.Authenticator.length == 0))
            		return ;
            	else if ((!privilege.canPatReCheck(documentContext))&&(signProperty.Authenticator.length > 0))
            		return ;
            
                var argEditor = {
                    instanceId: instanceId,
                    userId: patInfo.UserID,
                    signDocument: function(instanceId, type, signLevel, userId, userName, Image, actionType, description, headerImage, fingerImage) {
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
                            isSync: true
                        });
                    },
                    saveSignedDocument: function(instanceId, signUserId, signLevel, signId, digest, type, path, actionType) {
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
                    unSignedDocument: function() {
                        iEmrPlugin.UNSIGN_DOCUMENT();
                    },
                    episodeID:patInfo.EpisodeID,
                    actionType: (function () {
                        if (signProperty.Authenticator.length>0) {
                            return 'Replace';
                        }
                        else {
                            return 'Append';
                        }
                    })()
                };
                handSign.sign(argEditor);
            } else if ('1' === sysOption.CAServicvice) {
                if (!privilege.canCheck(documentContext))
                    return;
                
                keySign.sign(signProperty.SignatureLevel, instanceId, signProperty ,patInfo.UserID);
            } else { 
                // 系统签名 sysSign
                if (!privilege.canCheck(documentContext))
                    return;
                
                if ('Y' !== sysOption.isDirectSignOP)
                {
                    var signParam = {"cellName":signProperty.Name};
                    var returnValues = window.showModalDialog("emr.op.sign.csp?UserName="+patInfo.UserName+"&UserCode="+patInfo.UserCode+"&UserLocID="+patInfo.UserLocID,signParam,"dialogHeight:220px;dialogWidth:300px;resizable:yes;status:no");
                    if ((returnValues == "")||(returnValues == undefined))
                        return;
                    var userInfo = $.parseJSON(returnValues.replace(/\'/g, "\""));
                }
                else
                {
                    var userInfo = common.getUserInfo();
                }
                //权限检查
                var checkresult = privilege.checkSign(userInfo, signProperty);
                if (!checkresult.flag)
                    return;
                //开始签名
                var actionType = checkresult.ationtype;

                //如果是三级医师审核时，传入签名级别为医师级别
                var signlevel = signProperty.SignatureLevel;
                if (signProperty.OriSignatureLevel == 'Check') {
                    signlevel = userInfo.UserLevel;
                }
                if (('' === signlevel) && (signProperty.OriSignatureLevel !== "All")) {
                    showEditorMsg('用户签名级别为空！', 'warning');
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
                    showEditorMsg('签名失败', 'warning');
                }

            }
        }
        emrEditor.saveDoc(documentContext, fnAfterSave, {signElementPath: signProperty.Path});
    },
    eventGetMetaDataTree: function(commandJson) {
        editorEvt.raiseEvent('evtAfterGetMetaDataTree', commandJson);
    },
    eventUnSignDocument: function(commandJson) {
        alert(commandJson.args.result);
    },
    eventRefreshReferenceData: function(commandJson) {
        if (commandJson.args.result != 'OK') return;

        var instanceId = emrEditor.getInstanceID();
        var data = ajaxDATA('String', 'EMRservice.BL.BLRefreshBindData', 'InputData', instanceId, commandJson.args.SyncDialogVisible);
        ajaxGET(data);
        //showEditorMsg('绑定数据已同步！');
    },
    //打印事件监听
    eventPrintDocument: function(commandJson) {
        setSysMenuDoingSth();
        if (commandJson.args.result == 'OK') {
            if (commandJson.args.params.result == "OK") {
                showEditorMsg('病历打印成功!', 'alert');
                var insId = insId || emrEditor.getInstanceID();
                common.GetRecodeParamByInsID(insId, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Print.OK',tempParam);
                });
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
    eventRequestImgData: function(commandJson) {//debugger;
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
    //插入牙位图
    eventInsertTeethImage: function(commandJson) {//debugger;
        if (commandJson.args.result == 'OK') {
            showEditorMsg('插入成功!', 'alert');
        }
    },
    //双加牙位图打开编辑框，修改牙位信息后重新插入牙位图
    eventReplaceTeethImage: function(commandJson) {//debugger;
        if (commandJson.args.result == 'OK') {
            showEditorMsg('插入成功!', 'alert');
        }
    },
    //双加牙位图打开编辑框
    eventRequestTeeth: function(commandJson) {//debugger;
        openTooth(commandJson)
    },
    
    // 异步命令回调
    callbackAfterEvt: null,
    evtAfterSave: null,
    evtAfterGetMetaDataTree: null,
    evtAfterDelete: null,
    raiseEvent: function(evtName, commandJson) {
        var evt = editorEvt[evtName];
        if (typeof evt === 'function') {
            try {
                evt(commandJson);
            } catch (ex) {
                alert('evtName error:' + ex.message);
            } finally {
                evt = null;
            }
        }
    },
    eventDispatch: function(commandJson) {
        var fnAction = editorEvt[commandJson.action];
        if (typeof fnAction === 'function') {
            fnAction(commandJson);
        } else
            eventDispatch(commandJson);
    }
};

var intervalidHideMsg;
function showEditorMsg(msg, msgType) {
    if (isExistVar(msg)) {
        clearInterval(intervalidHideMsg);
        var millisec = 3000;
        if (isExistVar(msgType)) {
            millisec = sysOption.messageScheme[msgType];
        }

        $('#msgtd').html('');
        if (msgType === 'alert') {
            $('#msgtd').css('background-color', '#E7F0FF');
        } else if (msgType === 'warning') {
            $('#msgtd').css('background-color', '##008B8B');
        } else if (msgType === 'forbid') {
            $('#msgtd').css('background-color', 'red');
        } else {
            $('#msgtd').css('background-color', '#E7F0FF');
        }
        $('#msgtd').append(msg);
        $('#msgTable').show();
        intervalidHideMsg = setInterval("$('#msgTable').hide();", millisec);
    }
}

/// 对外接口 知识库等页面使用
function eventDispatch(commandJson) {
    if (commandJson.action == 'insertText') {
        iEmrPlugin.INSERT_TEXT_BLOCK({
            args: commandJson.text
        });
    } else if (commandJson.action == 'reflashKBNode') {
        refreshKBNode(commandJson);
    } else if (commandJson.action == 'appendComposite') {
        iEmrPlugin.APPEND_COMPOSITE({
            KBNodeID: commandJson.NodeID
        });
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
    }else if (commandJson.action == 'eventRequestKnowledgeBase') {
	    //ctrl+k 快捷键
        eventRequestKnowledgeBase(commandJson);
    }else if(commandJson["action"] == "eventSearchCdssBase")
	{
		//查看知识库
		eventSearchCdssBase(commandJson);
	}	
}
///跨页传json对象包含数组，会变换格式
function eventDispatchBroker(commandStr) {
    alert(commandStr);
    var commandJson = $.parseJSON(commandStr);
    editorEvt.eventDispatch(commandJson);
}

//快捷键保存 对外接口
function eventSave(action) {
    if ((action == '')||(typeof(action) == 'undefined'))
        return;
    
    if ((sysOption.OPAutoSave == "")||((','+sysOption.OPAutoSave+',').indexOf(','+action+',') == "-1"))
        return;
    
    emrEditor.saveDoc();
}

//刷新知识库
function refreshKBNode(commandParam) {
    if (!commandParam)
        return;

    emrEditor.kbtreeCmd = commandParam;
    var kbDataFrame = window.frames['kbDataFrame'];
    if (kbDataFrame) {
        var fn = kbDataFrame.GetKBNodeByTreeID;
        if (typeof fn === 'function') {
            fn(commandParam);
        }
    } else if (typeof emrEditor.refreshKBFunc !== 'undefined' && emrEditor.refreshKBFunc !== null) {
        emrEditor.refreshKBFunc(commandParam);
    }
}

function createDocFromInstance(insData) {
    if (isReadonly()) {
        alert('当前不可创建病历！');
        return;
    }
    emrEditor.createDocFromInstance(insData);
}

function getDocumentContext(insID) {
    return emrEditor.getDocWithoutPrivilege(insID);
}

//判断当前光标在文档中的位置
function getElementContext(position) {
    return iEmrPlugin.GET_ELEMENT_CONTEXT({
        Type: position,
        isSync: true
    });
}

//打开牙位图
function openTooth(commandJson)
{
    var selectedToothObj = commandJson["args"];
    var returnValue = window.showModalDialog("emr.record.tooth.csp",selectedToothObj,"dialogWidth=940px;dialogheight=420px;status:no;center:yes;minimize:yes;");	
    
    if (returnValue !== "")
    {
        emrEditor.insertTooth("open",returnValue);
    }
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
//文本数据插入到病历
function insertText(text){
	iEmrPlugin.INSERT_TEXT_BLOCK({
            args:text
        });
}

///保存时调用判断是否串患者
function isConsistent(documentContext)
{
	documentContext = documentContext || emrEditor.getDocWithoutPrivilege();
	
	if (documentContext.result === "ERROR") {
		showEditorMsg('请注意：当前保存病历可能不属于当前患者，保存失败，请重新打开病历页面进行编辑保存！', 'forbid');
        return false;
	}
	
	var isError = false;
	var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getAdmByInstanceID', documentContext.InstanceID);
	ajaxGETSync(data, function (ret) {
		if (ret !== "") {
			if (ret !== patInfo.EpisodeID){
				isError = true;
			}
		}
	}, function (ret) {
		alert('getAdmByInstanceID error:' + ret);
	});
		
	if (isError){
		alert('请注意：当前保存病历可能不属于当前患者，保存失败，请重新打开病历页面进行编辑保存！');
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
    //获取电子病历信息同步选项卡数据
    $.ajax({ 
        type: "post",
        dataType: "text", 
        url: "../EMRservice.Ajax.common.cls",
        async : false,
        data:{
            "OutputType":"Stream",
            "Class":"EMRservice.Observer.BOUpdateData",
            "Method":"ObserverUpData",
            "p1":patInfo.EpisodeID,
            "p2":patInfo.PatientID,
            "p3":patInfo.UserID,
            "p4":templateId,
            "p5":"SAVE"
        }, 
        error: function(d)
        {
            $.messager.alert("简单提示", "同步信息获取失败!");
        }, 
        success: function (d)
        {
            if (d != "")
            {
                var data = eval("["+d+"]");
                $.each(data, function(index, item){
                    if (item.Type == "PaPatMas")
                    {
                        var array = {
                            "data":item.children,
                            "patientID":patInfo.PatientID,
                            "userID":patInfo.UserID
                        };
                        returnValues = window.showModalDialog("emr.observerdata.csp",array,"dialogWidth:625px;dialogHeight:320px;resizable:yes;center:yes;status:no;");
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
        } 
    });
    if (returnValues)
    {
        showEditorMsg('同步数据项数据保存成功!', 'alert');
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
        alert(arrReportInfection[1]);
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
            window.showModalDialog(arrReportInfectionUrl[i],"","dialogHeight:800px;dialogWidth:800px;resizable:yes;center:yes;status:no;");
        }catch(e){
            alert(e.message);
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
            showEditorMsg("自动同步患者基本信息失败！", "warning");
        }else {
            showEditorMsg("自动同步患者基本信息成功！", "alert");
        }
    }, function (ret) {
        showEditorMsg("自动同步患者基本信息失败！", "warning");
    });
}

//ctrl+K 快捷键事件
function eventRequestKnowledgeBase(commandJson){
 	//快捷键请求CDSS
	var instance = emrEditor.getDocWithoutPrivilege();
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
	var tool = typeof cdssTool != "undefined" ? cdssTool : parent.cdssTool;
	var lock = typeof cdssLock != "undefined" ? cdssLock : parent.cdssLock;
	if(tool != undefined && lock != undefined && lock === "Y"){
		tool.getData(tempParam,type);	
	}	
}
