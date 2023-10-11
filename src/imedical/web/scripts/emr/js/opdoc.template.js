/// 门诊病历模板相关操作
$(function () {
    emrTemplate.tmplsTabs = $('#tmplsTabs');
    emrTemplate.tmplsTabs.tabs({
        onSelect: function (title, index) {
            //$.messager.popover({msg: emrTemplate.isLoading, type:'alert',style:{top:10,right:5}});
            if (emrTemplate.isLoading)
                return;
            //切换模板时，隐藏锁提示栏
            setLockMessage("");
            
            var callback = function (arr) {
                var index = arr.index;
                
                var docParam = emrTemplate.getTabRecord(index);
                if (!emrEditor.isOpened(docParam)) {
                    emrEditor.loadDoc(docParam);
                }
                if (index != emrTemplate.tmplsTabs.tabs('getTabIndex',emrTemplate.tmplsTabs.tabs('getSelected'))){
                    emrTemplate.tmplsTabs.tabs("select", index);
                }
            }
            
            var arr = {
                index: index
            }
            emrEditor.confirmAndSaveAsync(callback,arr);
        }
    });
});

var emrTemplate = {
    /// $('#tmplsTabs')
    tmplsTabs: null,
    isLoading: false,
    /// tabID 命名
    getTabId: function (tmpltId, insId) {
        if (!tmpltId && !insId)
            return '';

        return insId.split('||')[0] + '-' + insId;
    },
    insertTab: function (tmpltId, insId, txt, isSelected) {
        this.isLoading = true;
        try {
            var tabId = this.getTabId(tmpltId, insId);
            for (var idx = this.tmplsTabs.tabs('tabs').length - 1; idx > -1; idx--) {
                if (this.tmplsTabs.tabs('getTab', idx).panel('options').id === tabId) {
                    return;
                }
            }

            this.addTab(tmpltId, insId, txt, isSelected);
        } catch (ex) {
            //$.messager.alert('发生错误', 'insertTab:' + (ex.message || ex), 'error');
            alert('insertTab:' + (ex.message || ex));
        }
        finally {
            this.isLoading = false;
        }
    },
    addTab: function (tmpltId, insId, txt, isSelected, isLeadframe) {
        isLeadframe = isLeadframe || false;

        var isExist = false;
        var id = this.getTabId(tmpltId, insId);
        var tabs = this.tmplsTabs.tabs('tabs');
        $.each(tabs, function (idx, tab) {
            var tabId = tab.panel('options').id;
            if (isLeadframe) {
                if (insId.split('||')[0] === tabId.split('-')[0]) {
                    isExist = true;
                    return false;
                }
            } else {
                if (id === tabId) {
                    isExist = true;
                    return false;
                }
            }
        });

        if (isExist)
            return;

        this.tmplsTabs.tabs('add', {
            id: id,
            title: txt,
            selected: isSelected || false
        });
    },
    selectTmplTab: function (id, isLeadframe) {
        var that = this;
        var tabs = this.tmplsTabs.tabs('tabs');
        var tab = this.tmplsTabs.tabs('getSelected');
        var selectIdx;
        var flag = false;
        if (tab) {
            selectIdx = this.tmplsTabs.tabs('getTabIndex', tab);
        }
        $.each(tabs, function (idx, tab) {
            if (isLeadframe) {
                flag  = id.split('-')[0] === tab.panel('options').id.split('-')[0];
            }
            else{
                flag = id === tab.panel('options').id;
            }
            if (flag) {
                if (selectIdx === idx){
                    return false;
                }
                that.tmplsTabs.tabs("select", idx);
                //如果双击打开病历为当前已经选中tab,tab展现的病历为其他新建病历，则重新加载病历
                //HISUI改造依据easyui版本较低,所以单独处理
                if (selectIdx === idx)
                {
                    if (emrTemplate.isLoading)
                    return;
                    //emrEditor.saveConfirm();
                    var docParam = emrTemplate.getTabRecord(idx);
                    if (!emrEditor.isOpened(docParam)) {
                        emrEditor.loadDoc(docParam);
                    }
                }
                return false;
            }
        });
        return flag;
    },
    unselectTmplTab: function () {
        var that = this;
        var tabs = this.tmplsTabs.tabs('tabs');
        var tab = this.tmplsTabs.tabs('getSelected');
        $.each(tabs, function (idx, tab) {
            that.tmplsTabs.tabs("unselect", idx);
        });
    },
    updateCurrentTitle: function() {
        var tab = this.tmplsTabs.tabs('getSelected'); 
        var printStatus = "（已打印）";
        var newTitle = tab.panel('options').title;
        if (newTitle.indexOf(printStatus) == '-1') {
            newTitle = newTitle + printStatus;
            $("#tmplsTabs").tabs('update', {
                tab: tab,
                options: {
                    title: newTitle
                }
            });
        }
    },
    getTabRecord: function (index) {
    
        var tab = $("#tmplsTabs").tabs('getTab', index);
        if (null == tab)
            return '';
        var tabID = tab.panel('options').id;
        var flag = false;
        for (var i = 0; i < envVar.savedRecords.length; i++) {
            if (envVar.savedRecords[i].isLeadframe === '1') {
                flag = tabID.split('-')[0] === envVar.savedRecords[i].id.split('||')[0];
            }
            else
            {
                flag = tabID === this.getTabId(envVar.savedRecords[i].templateId, envVar.savedRecords[i].id);                            
            }
            if (flag) {
                return envVar.savedRecords[i];
            }    
        }
        return '';
    },    
    getTabRecordByInstID: function (instanceID) {
    
        var flag = false;
        for (var i = 0; i < envVar.savedRecords.length; i++) {
            if (envVar.savedRecords[i].isLeadframe === '1') {
                flag = instanceID.split('||')[0] === envVar.savedRecords[i].id.split('||')[0];
            }
            else
            {
                flag = instanceID === envVar.savedRecords[i].id;                            
            }
            if (flag) {
                return envVar.savedRecords[i];
            }    
        }
        return '';
    }, 
    closeCurTmplsTab: function () {
        var tab = this.tmplsTabs.tabs('getSelected');
        if (!tab)
            return;
        var idx = this.tmplsTabs.tabs('getTabIndex', tab);
        this.tmplsTabs.tabs('close', idx);
    },
    //关闭指定的tab
    closeTmplsTab: function (tmpltId, insId) {
        var tabId = this.getTabId(tmpltId, insId);
        var len = this.tmplsTabs.tabs('tabs').length;
        for (var idx = len - 1; idx > -1; idx--) {
            if (this.tmplsTabs.tabs('getTab', idx).panel('options').id === tabId) {
                this.tmplsTabs.tabs('close', idx);
                return len - 1;
            }
        }
    },
    closeAllTabs: function () {
        this.isLoading = true;
        try {
            var len = this.tmplsTabs.tabs('tabs').length;
            for (var j = len - 1; j > -1; j--) {
                this.tmplsTabs.tabs('close', j);
            }
        }
        catch(ex){
            //$.messager.alert('发生错误', 'closeAllTabs:' + (ex.message || ex), 'error');
            alert('closeAllTabs:' + (ex.message || ex));
        }
        this.isLoading = false;
    },
    //加载模板Tab
    loadTmplTabs: function (savedRecords, tmpltId, insId) {
        this.isLoading = true;
        try {
            for (var idx = 0, max = savedRecords.length; idx < max; idx++) {
                var item = savedRecords[idx];
                var isSelected = false;
                ///"chartItemType":"Multiple"   "isLeadframe":"1"
                /*if (item.isLeadframe === '1') {

                }*/
                if (tmpltId && insId) {
                    if (item.isLeadframe === '1') {
                        isSelected = insId.split('||')[0] === item.id.split('||')[0];
                    } else {
                        isSelected = this.getTabId(tmpltId, insId) === this.getTabId(item.templateId, item.id);
                    }
                }
                this.addTab(item.templateId, item.id, item.text, isSelected, item.isLeadframe === '1');
            };
        } catch (ex) {
            //$.messager.alert('发生错误', ex.message || ex, 'error');
            alert(ex.message || ex);
        }
        finally {
            this.isLoading = false;
        }
    },
    /*如果已经存在，则切换到已经保存的病历上，然后重新加载模板内容；
    如果未存在则加载新病历*/
    LoadTemplate: function (emrTmplCateid) {
        var that = this;
        var callback = function (arr) {
            var that = arr.that;
            var emrTmplCateid = arr.emrTmplCateid;
            
            common.GetRecodeParam(emrTmplCateid, function (ret) {
                if (ret == null) {
                    $.messager.alert('提示', emrTmplCateid + '未找到病历模板！', 'info');
                    return;
                }
                id = common.IsExistInstance(ret.emrDocId);
                if ('Single' == ret.chartItemType && "0" != id) {
                    var tabId = that.getTabId(ret.templateId, id);
                    that.selectTmplTab(tabId,false);
                    var isHasValidSign = common.isHasValidSign(id);
                    if ("0" != isHasValidSign){
                        $.messager.alert('提示', '已经创建同类型的文档，且已签名，不允许重复创建！', 'info');
                        return;
                    }
                    createConfirm(ret, emrEditor.createDoc);
                    return;
                } else if ('1' == ret.isLeadframe) {
                    var tabId = that.getTabId(ret.templateId, id);
                    if (that.selectTmplTab(tabId, true))
                        return;
                }

                emrEditor.createDoc(ret);
                //新建病历后取消实例页签的选中状态
                emrTemplate.unselectTmplTab();
            });
        }
        
        var arr = {
            that: that,
            emrTmplCateid: emrTmplCateid
        }
        emrEditor.confirmAndSaveAsync(callback,arr);
    },
    CreateByUserTemplate: function(emrTmplCateid,userTemplateId,titlecode){
        titlecode = titlecode || "";
        var that = this;
        
        var callback = function (arr) {
            var that = arr.that;
            var emrTmplCateid = arr.emrTmplCateid;
            var userTemplateId = arr.userTemplateId;
            var titlecode = arr.titlecode;
            
            var isTitleUniqueCreate = common.isTitleUniqueCreate(titlecode);        
            common.GetRecodeParam(emrTmplCateid, function (ret) {
                if (ret == null) {
                    $.messager.alert('提示', emrTmplCateid + '未找到病历模板！', 'info');
                    return;
                }
                ret.ExampleInstanceID = userTemplateId;
                ret.TitleCode = titlecode;
                ret.IsTitleUniqueCreate = isTitleUniqueCreate;
                id = common.IsExistInstance(ret.emrDocId);
                if ('Single' == ret.chartItemType && "0" != id) {
                    var tabId = that.getTabId(ret.templateId, id);
                    that.selectTmplTab(tabId,false);
                    var isHasValidSign = common.isHasValidSign(id);
                    if ("0" != isHasValidSign){
                        $.messager.alert('提示', '已经创建同类型的文档，且已签名，不允许重复创建！', 'info');
                        return;
                    }
                    createConfirm(ret, emrEditor.createByUserTempalte);
                    return;
                } else if ('1' == ret.isLeadframe) {
                    var tabId = that.getTabId(ret.templateId, id);
                    if ((that.selectTmplTab(tabId, true))&&(isTitleUniqueCreate == "1")) 
                    {
                        showEditorMsg({msg:'此文档不允许重复创建，将切换到已保存的文档！',type:'alert'});
                        return;
                    }
                }
                emrEditor.createByUserTempalte(ret);
                //新建病历后取消实例页签的选中状态
                emrTemplate.unselectTmplTab();
            });
        }
        
        var arr = {
            that: that,
            emrTmplCateid: emrTmplCateid,
            userTemplateId: userTemplateId,
            titlecode: titlecode
        }
        emrEditor.confirmAndSaveAsync(callback,arr);
    },
    CreateByPersonalTempalte: function(emrTmplCateId,exampleId,titlecode){
        var that = this;
        titlecode = titlecode || "";
        
        var callback = function (arr) {
            var that = arr.that;
            var emrTmplCateId = arr.emrTmplCateId;
            var exampleId = arr.exampleId;
            var titlecode = arr.titlecode;
            
            var isTitleUniqueCreate = common.isTitleUniqueCreate(titlecode);
            common.GetRecodeParam(emrTmplCateId, function (ret) {
                if (ret == null) {
                    $.messager.alert('提示', emrTmplCateid + '未找到病历模板！', 'info');
                    return;
                }
                ret.ExampleInstanceID = exampleId;
                ret.TitleCode = titlecode;
                ret.IsTitleUniqueCreate = isTitleUniqueCreate;
                id = common.IsExistInstance(ret.emrDocId);
                if ('Single' == ret.chartItemType && "0" != id) {
                    var tabId = that.getTabId(ret.templateId, id);
                    that.selectTmplTab(tabId,false);
                    var isHasValidSign = common.isHasValidSign(id);
                    if ("0" != isHasValidSign){
                        $.messager.alert('提示', '已经创建同类型的文档，且已签名，不允许重复创建！', 'info');
                        return;
                    }
                    createConfirm(ret, emrEditor.createByPersonalTempalte);
                    return;
                } else if ('1' == ret.isLeadframe) {
                    var tabId = that.getTabId(ret.templateId, id);
                    if ((that.selectTmplTab(tabId, true))&&(isTitleUniqueCreate == "1"))
                    {
                        showEditorMsg({msg:'此文档不允许重复创建，将切换到已保存的文档！',type:'alert'});
                        return;
                    }
                }
                emrEditor.createByPersonalTempalte(ret);
                 //新建病历后取消实例页签的选中状态
                emrTemplate.unselectTmplTab();
            });
        }
        
        var arr = {
            that: that,
            emrTmplCateId: emrTmplCateId,
            exampleId: exampleId,
            titlecode: titlecode
        }
        emrEditor.confirmAndSaveAsync(callback,arr);
    }
}

//已经创建同类型的文档，先删除再重新创建
function createConfirm(docParam, confirmFun){
    top.$.messager.confirm("警示", "已经创建同类型的文档，确定删除【" + docParam.text + "】并重新创建?", function (r) {
        if (r) {
            var documentContext = emrEditor.getDocContext(id);
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
                                confirmFun(arr);
                                //新建病历后取消实例页签的选中状态
                                emrTemplate.unselectTmplTab();
                            }
                        }
                        docParam.InstanceID = documentContext.InstanceID;
                        createModalDialog("deleteDialog","删除","265","250","iframeDelete","<iframe id='iframeDelete' scrolling='auto' frameborder='0' src='emr.ip.userverification.delete.csp?UserID="+creatorMessage.creatorID+"&UserName="+base64encode(utf16to8(encodeURI(creatorMessage.creatorName)))+"&MWToken="+getMWToken()+"' style='width:255px; height:210px; display:block;'></iframe>",deleteCallBacke,docParam)
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
                    confirmFun(docParam);
                    //新建病历后取消实例页签的选中状态
                    emrTemplate.unselectTmplTab();
                }
            }
        } else {
            return;
        }
    });
}

/// 存为范例病历
function saveToModelInsData() {
    var newTitle = param.text + ' - ' + userName;

    //设置患者信息
    //var diseaseId = ''; //parent.$("#disease").find("option:selected").val();
    //var ipAddress = getIpAddress();
    var argParams = {
        SaveType: 'Model',
        newTitle: newTitle
    };

    //setPatientInfo(argParams);
    iEmrPlugin.SET_PATIENT_INFO({
        args: argParams
    });

    //saveDocumentAsSync();
    iEmrPlugin.SAVE_DOCUMENT_AS();
    //setPatInfo();

    var argParams = {
        'SaveType': '',
        'newTitle': ''
    };

    //setPatientInfo(argParams);
    iEmrPlugin.SET_PATIENT_INFO({
        args: {
            SaveType: '',
            newTitle: ''
        }
    });
}

/// 加载范例病历
function LoadPersonTmpl(emrTmplCateid, modelId) {
    if (emrTmplCateid.indexOf('&') !== '-1'){
        var tmpret = common.getEMRTemplateIDBymodelId(emrTmplCateid.substring(1));
    }else{
        var tmpret = common.getEMRTemplateIDBymodelId(emrTmplCateid);
    }
    var ret = common.IsAllowMuteCreate(tmpret);
    if (ret === '0') {
        $.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        return;
    }
    
    function LoadModelInsData(modelID) {
 
        // 是否可以不用复制
        var _patInfo = {};
        for (var key in patInfo) {
            _patInfo[key] = patInfo[key];
        }
        _patInfo['CreateMode'] = 'Model';
        _patInfo['ModelID'] = modelID;
        iEmrPlugin.SET_PATIENT_INFO({
            args: _patInfo
        });
    
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
    
        iEmrPlugin.CREATE_DOCUMENT_BY_INSTANCE({
            InstanceID: '11',
            TitleCode: '043'
        });
    
        iEmrPlugin.SET_PATIENT_INFO({
            args: {
                CreateMode: '',
                ModelID: ''
            }
        });
    }

    var documentContext = emrEditor.getDocContext();
    //如果已经有实例，
    //是唯一模板，则提示是否要重建
    //可重复模板，如果是引导框的继续创建
    //如果是无引导框的创建
    common.GetRecodeParam(emrTmplCateid, function (recordParam) {
        /*if (isReadonly()) {
            alert('当前不可创建病历！');
            return;
        }*/
        var returnValues;
        var id = common.IsExistInstance(emrTmplCateid);
        if ('Single' === recordParam.chartItemType) { // 唯一模板
            if ('0' === id) {
                common.getTemplateIDByInsId(documentContext.InstanceID, function (tmpId) {
                    if (tmpId == recordParam.templateId) {
                        if (confirm('原有数据会被覆盖，是否重建?'))  {
                            sysOption.pluginType = recordParam.pluginType;
                            emrEditor.setPlugin(recordParam.chartItemType);
                            LoadModelInsData(modelId);
                            //自动记录病例操作日志
                            hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                        }
                    } else {
                        var ret = emrEditor.confirmAndSave(function (_documentContext) {
                                var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
                                returnValues = confirm(msgText);
                                if (returnValues) {
                                //returnValues = window.showModalDialog('emr.opdoc.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
                                //if (returnValues === 'save') {
                                    editorEvt.evtAfterSave = function (commandJson) {
                                        sysOption.pluginType = recordParam.pluginType;
                                        emrEditor.setPlugin(recordParam.chartItemType);
                                        LoadModelInsData(modelId);
                                        //自动记录病例操作日志
                                        hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                                    };
                                    return true;
                                } else {
                                    return false;
                                }
                            }, false, documentContext);
                        if (!ret && returnValues !== 'cancel') {
                            sysOption.pluginType = recordParam.pluginType;
                            emrEditor.setPlugin(recordParam.chartItemType);
                            LoadModelInsData(modelId);
                            //自动记录病例操作日志
                            hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                        }
                    }
                });
            } else {
                $.messager.alert('提示', '已经创建同类型的文档，不允许重复创建！', 'info');
                return;
            }
        } else if ('1' == recordParam.isLeadframe) { // 带引导框的可重复
            var ret = emrEditor.confirmAndSave(function (_documentContext) {
                    var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
                    returnValues = confirm(msgText);
                    if (returnValues) {
                    //returnValues = window.showModalDialog('emr.opdoc.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
                    //if (returnValues === 'save') {
                        editorEvt.evtAfterSave = function (commandJson) {
                            var tabId = emrTemplate.getTabId(recordParam.templateId, id);
                            if (!emrTemplate.selectTmplTab(tabId, true)) {
                                sysOption.pluginType = recordParam.pluginType;
                                emrEditor.setPlugin(recordParam.chartItemType);
                            }
                            LoadModelInsData(modelId);
                            //自动记录病例操作日志
                            hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                        
                        };
                        return true;
                    } else {
                        return false;
                    }
                }, false, documentContext);
            if (!ret && returnValues !== 'cancel') {
                var tabId = emrTemplate.getTabId(recordParam.templateId, id);
                if (!emrTemplate.selectTmplTab(tabId, true)){
                    sysOption.pluginType = recordParam.pluginType;
                    emrEditor.setPlugin(recordParam.chartItemType);
                    iEmrPlugin.SET_PATIENT_INFO({
                        args: patInfo
                    });
                    var isMutex = (recordParam.isMutex === '1') ? true : false;
                    var isGuideBox = (recordParam.isLeadframe === '1') ? true : false;
                    iEmrPlugin.SET_DOCUMENT_TEMPLATE({
                        DocID: recordParam.emrDocId,
                        IsMutex: isMutex,
                        CreateGuideBox: isGuideBox
                    });
                }
                LoadModelInsData(modelId);
                //自动记录病例操作日志
                hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
            }
        } else { // 不带引导框的可重复
            var ret = emrEditor.confirmAndSave(function (_documentContext) {
                    var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
                    returnValues = confirm(msgText);
                    if (returnValues) {
                    //returnValues = window.showModalDialog('emr.opdoc.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
                    //if (returnValues === 'save') {
                        editorEvt.evtAfterSave = function (commandJson) {
                            sysOption.pluginType = recordParam.pluginType;
                            emrEditor.setPlugin(recordParam.chartItemType);
                            LoadModelInsData(modelId);
                            //自动记录病例操作日志
                            hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                        };
                        return true;
                    } else {
                        return false;
                    }
                }, false, documentContext);
             if (!ret && returnValues !== 'cancel') {
                 sysOption.pluginType = recordParam.pluginType;
                 emrEditor.setPlugin(recordParam.chartItemType);
                LoadModelInsData(modelId);
                //自动记录病例操作日志
                hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
             }
        }
    });

}

/// 加载新范例模板
function LoadPersonRecord(recordParam) {
    var ret = common.IsAllowMuteCreate(recordParam.emrDocId);
    if (ret === '0')
    {
        $.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        return;
    }
    
    function LoadModelInsData(param) {
        // 是否可以不用复制
        var _patInfo = {};
        for (var key in patInfo) {
            _patInfo[key] = patInfo[key];
        }
        _patInfo['CreateMode'] = 'Model';
        _patInfo['ModelID'] = param.exampleId;
        iEmrPlugin.SET_PATIENT_INFO({
            args: _patInfo
        });
    
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });
        iEmrPlugin.CREATE_DOCUMENT_BY_INSTANCE(param);
        iEmrPlugin.SET_PATIENT_INFO({
            args: {
                CreateMode: '',
                ModelID: ''
            }
        });
    }
    var documentContext = emrEditor.getDocContext();
    /*if (isReadonly()) {
        alert('当前不可创建病历！');
        return;
    }*/
    var returnValues;
    var id = common.IsExistInstance(recordParam.emrDocId);
    if ('Single' === recordParam.chartItemType) { // 唯一模板
        if ('0' === id) {
            common.getTemplateIDByInsId(documentContext.InstanceID, function (tmpId) {
                if (tmpId == recordParam.templateId) {
                    if (confirm('原有数据会被覆盖，是否重建?'))  {
                        sysOption.pluginType = recordParam.pluginType;
                        emrEditor.setPlugin(recordParam.chartItemType);
                        LoadModelInsData(recordParam);
                        //自动记录病例操作日志
                        hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                    }
                } else {
                    var ret = emrEditor.confirmAndSave(function (_documentContext) {
                            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
                            returnValues = confirm(msgText);
                            if (returnValues) {
                            //returnValues = window.showModalDialog('emr.opdoc.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
                            //if (returnValues === 'save') {
                                editorEvt.evtAfterSave = function (commandJson) {
                                    sysOption.pluginType = recordParam.pluginType;
                                    emrEditor.setPlugin(recordParam.chartItemType);
                                    LoadModelInsData(recordParam);
                                    //自动记录病例操作日志
                                    hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                                };
                                return true;
                            } else {
                                return false;
                            }
                        }, false, documentContext);
                    if (!ret && returnValues !== 'cancel') {
                        sysOption.pluginType = recordParam.pluginType;
                        emrEditor.setPlugin(recordParam.chartItemType);
                        LoadModelInsData(recordParam);
                        //自动记录病例操作日志
                        hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                    }
                }
            });
        } else {
            $.messager.alert('提示', '已经创建同类型的文档，不允许重复创建！', 'info');
            return;
        }
    } else if ('1' == recordParam.isLeadframe) { // 带引导框的可重复
        var ret = emrEditor.confirmAndSave(function (_documentContext) {
            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';

            returnValues = confirm(msgText);
            if (returnValues) {
            //returnValues = window.showModalDialog('emr.opdoc.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
            //if (returnValues === 'save') {
                editorEvt.evtAfterSave = function (commandJson) {
                    var tabId = emrTemplate.getTabId(recordParam.templateId, id);
                    if (!emrTemplate.selectTmplTab(tabId, true)) {
                        sysOption.pluginType = recordParam.pluginType;
                        emrEditor.setPlugin(recordParam.chartItemType);
                    }
                    LoadModelInsData(recordParam);
                    //自动记录病例操作日志
                    hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                };
                return true;
            } else {
                return false;
            }
        }, false, documentContext);
        if (!ret && returnValues !== 'cancel') {
            var tabId = emrTemplate.getTabId(recordParam.templateId, id);
            if (!emrTemplate.selectTmplTab(tabId, true)){
                sysOption.pluginType = recordParam.pluginType;
                emrEditor.setPlugin(recordParam.chartItemType);
                var isMutex = (recordParam.isMutex === '1') ? true : false;
                var isGuideBox = (recordParam.isLeadframe === '1') ? true : false;
                iEmrPlugin.SET_DOCUMENT_TEMPLATE({
                    DocID: recordParam.emrDocId,
                    IsMutex: isMutex,
                    CreateGuideBox: isGuideBox
                });
            }
            LoadModelInsData(recordParam);
            //自动记录病例操作日志
            hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
        }
    } else { // 不带引导框的可重复
        var ret = emrEditor.confirmAndSave(function (_documentContext) {
            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';
            returnValues = confirm(msgText);
            if (returnValues) {
            //returnValues = window.showModalDialog('emr.opdoc.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
            //if (returnValues === 'save') {
                editorEvt.evtAfterSave = function (commandJson) {
                    sysOption.pluginType = recordParam.pluginType;
                    emrEditor.setPlugin(recordParam.chartItemType);
                    LoadModelInsData(recordParam);
                    //自动记录病例操作日志
                    hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
                };
                return true;
            } else {
                return false;
            }
        }, false, documentContext);
        if (!ret && returnValues !== 'cancel') {
            sysOption.pluginType = recordParam.pluginType;
            emrEditor.setPlugin(recordParam.chartItemType);
            LoadModelInsData(recordParam);
            //自动记录病例操作日志
            hisLog.create('EMR.OP.ModelInstance.CreateDoc',recordParam);
        }
    }
}

/// 引用为复诊病历
function createEmrLastDocFromInstance(emrDocId, admID) {
    var ret = common.IsAllowMuteCreate(emrDocId);
    if (ret === '0') {
        $.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        return;
    }
    emrEditor.saveConfirm(true);
    function createDocByAdmID(docParam) {
        if (docParam == null)
            return;
        sysOption.pluginType = docParam.pluginType;
        emrEditor.setPlugin(docParam.chartItemType);
        var _patInfo = {};
        for (var key in patInfo) {
            _patInfo[key] = patInfo[key];
        }
        _patInfo['LastAdm'] = admID;
        iEmrPlugin.SET_PATIENT_INFO({
            args: _patInfo
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
        } else {
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
        iEmrPlugin.SET_PATIENT_INFO({
            args: {
                LastAdm: ''
            }
        });
        //自动记录病例操作日志
        hisLog.create('EMR.OP.CreateDoc',docParam);
    }
    common.GetRecodeParam(emrDocId, function (ret) {
        if (ret == null) {
            $.messager.alert('提示', emrDocId + '未找到病历模板！', 'info');
            return;
        }
        
        var id = common.IsExistInstance(ret.emrDocId);
        if ('Single' == ret.chartItemType && "0" != id) {
            var tabId = emrTemplate.getTabId(ret.templateId, id);
            emrTemplate.selectTmplTab(tabId);
            $.messager.alert('提示', '已经创建同类型的文档，不允许重复创建！', 'info');
            return;
        } else if ('1' == ret.isLeadframe) {
            var tabId = emrTemplate.getTabId(ret.templateId, id);
            if (emrTemplate.selectTmplTab(tabId, true))
                return;
        }
        createDocByAdmID(ret);
        //新建病历后取消实例页签的选中状态
        emrTemplate.unselectTmplTab();
    });
    
}

// 打开模板选择页面
function showTemplateTree(autoSelectFlag) {
	autoSelectFlag = autoSelectFlag || false;
	if (autoSelectFlag) {
		var callback = function(returnValue,arr){
            if (returnValue == "-1") 
            {
                emrEditor.showTemplateTreeAfter();
            }
        }
	} else {
		var callback = "";
	}
	
    //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
    /* $('#TempClassifyWin').attr('src','emr.opdoc.templateclassify.csp');
    $HUI.dialog('#HisUITempClassifyWin').open(); */
    var width = 300;
    var height = 480;
    if (sysOption.isShowTmpBrowse == "Y" ) {
        width = 1000;
        height = 600;
    }
    var content = '<iframe id="tempClassifyWinFrame" scrolling="auto" frameborder="0" src="emr.opdoc.templateclassify.csp?MWToken='+getMWToken()+'" style="width:100%;height:100%;display:block;"></iframe>';
    createModalDialog('tempClassifyWin','选择模板',width,height,"tempClassifyWinFrame",content,callback,"");
}
//门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
function TempClassifyBtnClick(node)
{
    var param = "";
    if ('' !== node) {
        if (node.attributes.nodeType == "template")
        {
            param = {emrTmplCateid:node.id,type:"Template",templateId:node.attributes.TemplateID}
        }
        else if (node.attributes.nodeType == "leaf")
        {
            param = {emrTmplCateid:node.attributes.DocID,userTemplateId:node.attributes.Code,titleCode:node.attributes.TitleCode,type:"OpUserTemplate",templateId:node.attributes.TemplateID}
        }
        else if (node.attributes.nodeType == "personal")
        {
            param = {emrTmplCateid:node.attributes.emrdocId,personalTemplateId:node.id,titleCode:node.attributes.titleCode,type:"OpPersonalTemplate",templateId:node.attributes.templateId}
        }
        else if (node.attributes.nodeType == "flod")
        {
            showEditorMsg({msg:'您选择的是目录文件夹，不是实际的模板节点，请重新选择！',type:'alert'});
            return;
        }
        
        if (param == "") 
        {
            $.messager.alert('提示', '判断模板类型出错，请联系系统管理员!', 'info');
            return;
        }
        if (!IsAllowOEPCreateConfig(node, param.emrTmplCateid))
        {
            return;
        }
        if (IsCreated(param.emrTmplCateid))
        {
            var createByTemplateType = function(param){
                if (param.type == "OpUserTemplate")
                {
                     emrTemplate.CreateByUserTemplate(param.emrTmplCateid,param.userTemplateId,param.titleCode);
                
                }
                else if (param.type == "OpPersonalTemplate")
                { 
                     emrTemplate.CreateByPersonalTempalte(param.emrTmplCateid,param.personalTemplateId,param.titleCode);
                }
                else
                {
                    emrTemplate.LoadTemplate(param.emrTmplCateid);
                }
            };
            if ('Single' === node.attributes.chartItemType){
                var id = common.IsExistInstance(param.emrTmplCateid);
                if ('0' === id){
                    var documentContext = emrEditor.getDocContext();
                    common.getTemplateIDByInsId(documentContext.InstanceID, function (tmpId) {
                        if (tmpId == param.templateId) {
                            top.$.messager.confirm("操作提示", "原有数据会被覆盖，是否重建?", function (data) { 
                                if(data) {
                                    common.GetRecodeParam(param.emrTmplCateid, function (ret) {
                                        if (ret == null) {
                                            $.messager.alert('提示', param.emrTmplCateid + '未找到病历模板！', 'info');
                                            return;
                                        }
                                        if (param.type == "template") {
                                            emrEditor.createDoc(ret);
                                        }else {
                                            ret.TitleCode = param.titleCode;
                                            var isTitleUniqueCreate = common.isTitleUniqueCreate(param.titleCode);
                                            ret.IsTitleUniqueCreate = isTitleUniqueCreate;
                                            if (param.type == "OpUserTemplate") {
                                                ret.ExampleInstanceID = param.userTemplateId;
                                                emrEditor.createByUserTempalte(ret);
                                            }else if (param.type == "OpPersonalTemplate") {
                                                ret.ExampleInstanceID = param.personalTemplateId;
                                                emrEditor.createByPersonalTempalte(ret);
                                            }
                                        }
                                    });
                                } else {
                                }
                            });
                        }else{
                            createByTemplateType(param);
                        }
                    });
                }else{
                    createByTemplateType(param);
                }
            }else{
                createByTemplateType(param);
            }
        }
    }
    closeDialog('tempClassifyWin');
}

// 判断是否已经创建过唯一模板
function IsCreated(emrTmplCateid) {
    var ret = common.IsAllowMuteCreate(emrTmplCateid);
    if (ret === '0') {
        $.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        return false;
    }
    return true;
}

//根据系统参数OEPCreateConfig配置判断是否可创建
function IsAllowOEPCreateConfig(node, docId) {
    if ("" != sysOption.OEPCreateConfig)
    {
        var isAllowCreate = sysOption.OEPCreateConfig.split("|");
        if (-1 != $.inArray(docId, isAllowCreate[0].split("^")))
        {
            var ret = common.IsAllowOEPCreateConfig(isAllowCreate[1]);
            if (ret === '0') {
                $.messager.alert('提示', '不能创建'+node.text+'，请先创建初诊病历！', 'info');
                return false;
            }
        }
    }
    return true;
}

//打开结核病历
function LoadPhthsisRecords(insData)
{
    //是否存在Tab签，是：选中Tab签，否：新增Tab签
    var tabId = emrTemplate.getTabId(insData.templateId, insData.id);
    var isSelected = false;
    if ('1' == insData.isLeadframe) {
        isSelected = true;
    }
    if (!emrTemplate.selectTmplTab(tabId, isSelected)) {
        envVar.savedRecords.push(insData);
        emrTemplate.addTab(insData.templateId, insData.id, insData.categoryName, true, '1' == insData.isLeadframe);
    }else {
        var instanceId = emrEditor.getInstanceID();
        if (instanceId != insData.id)
        {
            iEmrPlugin.FOCUS_ELEMENT({
                Path: '',
                InstanceID: insData.id,
                actionType: 'First'
            });
        }
    }
}
