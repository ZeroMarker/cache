/// 门诊病历模板相关操作
$(function () {
    emrTemplate.tmplsTabs = $('#tmplsTabs');
    emrTemplate.tmplsTabs.tabs({
        onSelect: function (title, index) {
            //$.messager.popover({msg: emrTemplate.isLoading, type:'alert',style:{top:10,right:5}});
            if (emrTemplate.isLoading)
                return;
            emrEditor.saveConfirm(true);
            var docParam = emrTemplate.getTabRecord(index);
            if (!emrEditor.isOpened(docParam)) {
                emrEditor.loadDoc(docParam);
            }
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

        return tmpltId + '-' + insId;
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
                if (tmpltId === tabId.split('-')[0]) {
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
                if (selectIdx === id)
                    return;
                that.tmplsTabs.tabs("select", idx);
                //如果双击打开病历为当前已经选中tab,tab展现的病历为其他新建病历，则重新加载病历
                //HISUI改造依据easyui版本较低,所以单独处理
                if (selectIdx === idx)
                {
	                if (emrTemplate.isLoading)
	                return;
		            emrEditor.saveConfirm(true);
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
    getTabRecord: function (index) {
    
        var tab = $("#tmplsTabs").tabs('getTab', index);
        if (null == tab)
            return '';
        var tabID = tab.panel('options').id;
        var flag = false;
        for (var i = 0; i < envVar.savedRecords.length; i++) {
            if (envVar.savedRecords[i].isLeadframe === '1') {
                flag = tabID.split('-')[0] === envVar.savedRecords[i].templateId;
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
                        isSelected = tmpltId === item.templateId;
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
        common.GetRecodeParam(emrTmplCateid, function (ret) {
            if (ret == null) {
                //$.messager.alert('提示', emrTmplCateid + '未找到病历模板！', 'info');
                alert( emrTmplCateid + '未找到病历模板！');
                return;
            }
            
            id = common.IsExistInstance(ret.emrDocId);
            if ('Single' == ret.chartItemType && "0" != id) {
                var tabId = that.getTabId(ret.templateId, id);
                that.selectTmplTab(tabId);
                $.messager.alert('提示', '已经创建同类型的文档，不允许重复创建！', 'info');
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
    },
    CreateByUserTemplate: function(emrTmplCateid,userTemplateId){
	    var that = this;
        emrEditor.saveConfirm(true);
        common.GetRecodeParam(emrTmplCateid, function (ret) {
            if (ret == null) {
                alert( emrTmplCateid + '未找到病历模板！');
                return;
            }
            
            id = common.IsExistInstance(ret.emrDocId);
            if ('Single' == ret.chartItemType && "0" != id) {
                var tabId = that.getTabId(ret.templateId, id);
                that.selectTmplTab(tabId);
                $.messager.alert('提示', '已经创建同类型的文档，不允许重复创建！', 'info');
                return;
            } else if ('1' == ret.isLeadframe) {
                var tabId = that.getTabId(ret.templateId, id);
                if (that.selectTmplTab(tabId, true))
                    return;
            }
            ret.ExampleInstanceID = userTemplateId;
			emrEditor.createByUserTempalte(ret);
			//新建病历后取消实例页签的选中状态
            emrTemplate.unselectTmplTab();
    	});
	},
	CreateByPersonalTempalte: function(emrTmplCateId,exampleId){
	    var that = this;
        emrEditor.saveConfirm(true);
        common.GetRecodeParam(emrTmplCateId, function (ret) {
            if (ret == null) {
                alert( emrTmplCateid + '未找到病历模板！');
                return;
            }
            
            id = common.IsExistInstance(ret.emrDocId);
            if ('Single' == ret.chartItemType && "0" != id) {
                var tabId = that.getTabId(ret.templateId, id);
                that.selectTmplTab(tabId);
                $.messager.alert('提示', '已经创建同类型的文档，不允许重复创建！', 'info');
                return;
            } else if ('1' == ret.isLeadframe) {
                var tabId = that.getTabId(ret.templateId, id);
                if (that.selectTmplTab(tabId, true))
                    return;
            }
            ret.ExampleInstanceID = exampleId;
			emrEditor.createByPersonalTempalte(ret);	
 			//新建病历后取消实例页签的选中状态
            emrTemplate.unselectTmplTab();
    	});
	}
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
        //$.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        alert('已创建同类型模板，不允许继续创建！');
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
    
        emrEditor.createAsLoad = true;
        iEmrPlugin.CREATE_DOCUMENT_BY_INSTANCE({
            InstanceID: '11',
            TitleCode: '043',
            AsLoad: emrEditor.createAsLoad
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
        alert('已创建同类型模板，不允许继续创建！');
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
        emrEditor.createAsLoad = true;
        iEmrPlugin.CREATE_DOCUMENT_BY_INSTANCE(param);
        iEmrPlugin.SET_PATIENT_INFO({
            args: {
                CreateMode: '',
                ModelID: ''
            }
        });
    }
    var documentContext = emrEditor.getDocContext();
    if (isReadonly()) {
        alert('当前不可创建病历！');
        return;
    }
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
        //$.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        alert('已创建同类型模板，不允许继续创建！');
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
            emrEditor.createAsLoad = true;
            setSysMenuDoingSth('病历创建中...');
            iEmrPlugin.CREATE_DOCUMENT({
                AsLoad: emrEditor.createAsLoad,
                DisplayName: docParam.text
            });
        } else {
            var defaultLoadId = common.getDefaultLoadId(docParam.emrDocId, patInfo.UserLocID);
            if (defaultLoadId == "") {
                if (!isGuideBox) {
                    emrEditor.createAsLoad = true;
                    setSysMenuDoingSth('病历创建中...');
                    iEmrPlugin.CREATE_DOCUMENT({
                        AsLoad: emrEditor.createAsLoad,
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
function showTemplateTree() {
    //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
    /* $('#TempClassifyWin').attr('src','emr.opdoc.templateclassify.csp');
    $HUI.dialog('#HisUITempClassifyWin').open(); */
    
    var content = '<iframe id="tempClassifyWinFrame" scrolling="auto" frameborder="0" src="emr.opdoc.templateclassify.csp" style="width:100%;height:100%;display:block;"></iframe>';
	createModalDialog('tempClassifyWin','选择模板',300,480,"tempClassifyWinFrame",content,TempClassifyBtnClick,"");
}
//门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
function TempClassifyBtnClick(node)
{
	var param = "";
    if ('cancel' !== node) {
        if (node.attributes.nodeType == "template")
		{
			param = {emrTmplCateid:node.id,type:"Template"}
		}
		else if (node.attributes.nodeType == "leaf")
		{
			param = {emrTmplCateid:node.attributes.DocID,userTemplateId:node.attributes.Code,type:"OpUserTemplate"}
		}
		else if (node.attributes.nodeType == "personal")
		{
			param = {emrTmplCateid:node.attributes.emrdocId,personalTemplateId:node.id,type:"OpPersonalTemplate"}
		}
		if (param == "") 
		{
			alert('判断模板类型出错，请联系系统管理员!');
			return;
		}
		if (IsCreated(param.emrTmplCateid))
		{
			if (param.type == "OpUserTemplate")
			{
				 emrTemplate.CreateByUserTemplate(param.emrTmplCateid,param.userTemplateId)
			}
			else if (param.type == "OpPersonalTemplate")
			{
				 emrTemplate.CreateByPersonalTempalte(param.emrTmplCateid,param.personalTemplateId)	        
			}
			else
			{
				emrTemplate.LoadTemplate(param.emrTmplCateid);
			}	
		}
    }
}

// 判断是否已经创建过唯一模板
function IsCreated(emrTmplCateid) {
    var ret = common.IsAllowMuteCreate(emrTmplCateid);
    if (ret === '0') {
        //$.messager.alert('提示', '已创建同类型模板，不允许继续创建！', 'info');
        alert('已创建同类型模板，不允许继续创建！');
        return false;
    }
    return true;
}