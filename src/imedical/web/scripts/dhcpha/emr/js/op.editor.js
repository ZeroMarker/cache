
var emrEditor = {
    newEmrPlugin: function () {
        if (!iEmrPlugin) {
            iEmrPlugin = new iEmrPluginEx(window.frames['editorFrame']);
        }
    },
    refreshKBFunc: undefined, //资源区刷新相关的知识库委托
    sectionResFunc: null, //刷新相关资源区委托
    SectionCode: '', //记录当前选中的章节的code，用户刷新相关的资源区知识库
    createAsLoad: false,
    resourceWindow: null,
    showResourceWindow: function () {
        emrEditor.resourceWindow = window.showModelessDialog('emr.op.resource.window.csp', window, 'dialogHeight:500px;dialogWidth:600px;resizable:no;status:no');        
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
    getDocContext: function (InstanceID) {
        envVar.docContext = iEmrPlugin.GET_DOCUMENT_CONTEXT({
                InstanceID: InstanceID || '',
                isSync: true
            });
        return envVar.docContext;
    },
    getInstanceID: function () {
        this.getDocContext('');
        if (!envVar.docContext)
            return '';
        return (envVar.docContext.InstanceID || '');
    },
    //保存文档，正常执行返回true,
    saveDoc: function (documentContext, callback) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;

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
            if (typeof callback === 'function') {
                callback();
            }
            return;
        }

        var flag = this.doRevokeSignedDocument(modifyResult);

        if (!flag) {
            editorEvt.evtAfterSave = callback;
            iEmrPlugin.SAVE_DOCUMENT();
            return;
        }

        return;
    },
    //打印 ： printArg Print/PrintDirectly
    printDoc: function (printArg, documentContext) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;
        if (!privilege.canPrint(documentContext)) {
            return;
        }

		var instanceId = emrEditor.getInstanceID();
        if (instanceId === '') return;
		var id = common.isPrinted(instanceId);
		if (id == '1')
		{
			var titleName = documentContext.Title.DisplayName;
			var text = '病历 "' + titleName + '" 已打印，是否再次打印';
			var returnValues = window.showModalDialog("emr.printprompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			if (returnValues == "cancel") return;
		}
		
        var fnAfterSave = function (commandJson) {
            if (commandJson && commandJson.args) {
                if (commandJson.args.result === 'ERROR')
                    return;
                else if (commandJson.QCResult === false)
                    return;
            }

            if (!quality.printChecker(documentContext))
                return;

            iEmrPlugin.PRINT_DOCUMENT({
                args: printArg || 'Print'
            });
        }

        this.saveDoc(documentContext, fnAfterSave);
    },
    //删除
    deleteDoc: function (documentContext) {
        documentContext = documentContext || this.getDocContext();
        if (!documentContext)
            return;

        if (!privilege.canDelete(documentContext)) {
            return;
        }
        if (confirm('确定删除【' + documentContext.Title.DisplayName + '】?')) {
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
        if (!isGuideBox) {
            this.createAsLoad = true;
            iEmrPlugin.CREATE_DOCUMENT({
                AsLoad: this.createAsLoad,
                DisplayName: docParam.text
            });
        }
		//自动记录病例操作日志
        hisLog.create('EMR.OP.CreateDoc',docParam);
    },
    isOpened: function (docParam) {

        if (!iEmrPlugin.getPlugin()) {
            return false;
        }

        var documentContext = this.getDocContext();
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
        } else {
            //设置引导框
            var isMutex = (docParam.isMutex === '1') ? true : false;
            var isGuideBox = (docParam.isLeadframe === '1') ? true : false;
            iEmrPlugin.SET_DOCUMENT_TEMPLATE({
                DocID: docParam.emrDocId,
                IsMutex: isMutex,
                CreateGuideBox: isGuideBox
            });
        }
		//自动记录病例操作日志
        hisLog.operate('EMR.OP.LoadDoc',docParam);
    },
    cleanDoc: function () {
        iEmrPlugin.CLEAN_DOCUMENT();
    },
    // 失效病历的时候会同时向后台保存文档的，返回值影响后续保存操作
    // 执行了撤销或是出现异常的情况下，返回True 、其他情况返回False
    doRevokeSignedDocument: function (modifyResult) {
        if (sysOption.isRevokeSign === 'N')
            return false;
        var that = this;
        var result = false;
        var revokeStatus = privilege.GetRevokeStatus();
        for (var i = 0; i < modifyResult.InstanceID.length; i++) {
            var instanceId = modifyResult.InstanceID[i];
            var userLevel = common.getUserInfo().UserLevel;

            if (revokeStatus != 'Superior')
                instanceId = '';
            var revokeResult = iEmrPlugin.REVOKE_SIGNED_DOCUMENT({
                    SignatureLevel: userLevel,
                    InstanceID: instanceId,
                    isSync: true
                });
            if (revokeResult.result === 'ERROR') {
                showEditorMsg('撤销文档签名失败!', 'warning');
                if (!result) {
                    result = true;
                }
                break;
            } else {
                if (typeof(revokeResult.Authenticator) === "undefined" || revokeResult.Authenticator.length <= 0) {
                    continue;
                }
                showEditorMsg('文档签名已经被撤销!', 'warning');
                result = true;
                var tmpDocContext = that.getDocContext(instanceId);
                if (tmpDocContext.result == 'ERROR' && !result) {
                    result = true;
                }
                showEditorMsg('数据保存成功,签名已失效!', 'warning');
                //质控
                quality.saveChecker(tmpDocContext);
            }
        }

        return result;
    },
    ///初始化页面
    initDocument: function (autoLoadTmp) {
        emrTemplate.closeAllTabs();
        if (envVar.savedRecords.length > 0) {
            var docParam = envVar.savedRecords[0];
            envVar.readonly = docParam == null ? '1' : '0';
            this.loadDoc(docParam);
            emrTemplate.loadTmplTabs(envVar.savedRecords, docParam.templateId, docParam.id);
        } else if (autoLoadTmp || true) {
            if (sysOption.isAutoSelectTemplate === 'Y' && patInfo.EpisodeID !== '') {
                if (showTemplateTree())
                    return;
            }
            if (envVar.firstTmpl == null) {
                if (patInfo.EpisodeID !== '')
                    alert('未找到默认病历模板！');
                envVar.readonly = '1';
                return;
            }
            envVar.readonly = '0';
            this.createDoc(envVar.firstTmpl);
        }
        //门诊病历打开时依据保存权限设定只读状态
        var documentContext = emrEditor.getDocContext();
        envVar.readonly = privilege.canSave(documentContext) ? 0 : 1 ;

        this.setEditorReadonly();
    },
    reloadBinddata: function (insID) {
        return;
        //获取是否显示同步提示框状态
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
                } else if (ret === 'False') {
                    //不显示同步提示框
                    iEmrPlugin.REFRESH_REFERENCEDATA({
                        InstanceID: insID || '',
                        AutoRefresh: true,
                        SyncDialogVisible: false
                    });
                }
            }
        }, function (ret) {
            alert('getBindDataSyncDialogVisible error:' + ret);
        });
    },
    setEditorReadonly: function () {
        /*if ('' == envVar.readonly)
        return;*/
        var flag = ('1' == envVar.readonly);
        if (typeof isOfficeAudit == 'undefined') {
            setPnlBtnDisable(flag);
        }
        iEmrPlugin.SET_READONLY({
            ReadOnly: flag
        });
    },
    setPlugin: function (chartItemType) {
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
		debugger;
		var ret = common.IsAllowMuteCreate(insData.emrDocId);
		if (ret === '0')
		{
			alert('已创建同类型模板，不允许继续创建！');
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
            alert('已经创建同类型的文档，不允许重复创建！');
            return;
        } else if ('1' == insData.isLeadframe) { // 带引导框的可重复
            var tabId = emrTemplate.getTabId(insData.templateId, id);
            emrTemplate.selectTmplTab(tabId);
            createDocByInstance(insData.id);
        } else { // 不带引导框的可重复
            createDocByInstance(insData.id);
        }
    },
    confirmAndSave: function (fnConfirm, isSync, documentContext) {

        isSync = isSync || false;
        documentContext = documentContext || this.getDocContext();

        if (!privilege.canSave(documentContext))
            return false;

        var modifyResult = this.getModifyResult();
        if (modifyResult.Modified !== 'True')
            return false;

        if (typeof fnConfirm === 'function') {
            if (!fnConfirm(documentContext))
                return false;
            var flag = this.doRevokeSignedDocument(modifyResult);

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
    savePrompt: function (isSync, documentContext) {
        var returnValues = '';
        var fnSavePrompt = function (documentContext) {
            var msgText = '【' + documentContext.Title.DisplayName + '】有修改，是否保存？';

            returnValues = window.showModalDialog('emr.prompt.csp', msgText, 'dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;');
            return returnValues === 'save';
        };
        this.confirmAndSave(fnSavePrompt, isSync, documentContext);
        return returnValues;
    },
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
    foo: function () {}
};

var editorEvt = {
    //设置链接串
    eventSetNetConnect: function (commandJson) {
        if (commandJson.args.result != 'OK')
            alert('设置链接失败！');
    },
    //文档改变事件
    eventDocumentChanged: function (commandJson) {
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
        emrEditor.getDocContext(commandJson.args.InstanceID);
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
            'titleCode': sysOption.titleCode
        };
        refreshKBNode(paramJson);
    },
    //保存事件监听
    evtAfterSave: null,
    eventSaveDocument: function (commandJson) {
        if (commandJson.args.result === 'OK') {
            if (commandJson.args.params.result === 'OK') {
                showEditorMsg('数据保存成功!', 'alert');
                emrEditor.createAsLoad = false;
                var insId = commandJson.args.params.InstanceID;
                common.GetRecodeParamByInsID(insId, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Save.OK',tempParam);
                })
                var documentContext = emrEditor.getDocContext(insId);
                commandJson['QCResult'] = quality.saveChecker(documentContext);
                common.getSavedRecords(function (ret) {
                    envVar.savedRecords = $.parseJSON(ret);
                    common.getTemplateIDByInsId(insId, function (tmpId) {
                        if ((quality.requiredObject(documentContext))&&(sysOption.ReturnTemplateIDs.indexOf('^'+tmpId+'^')!='-1')) return;
                        emrTemplate.loadTmplTabs(envVar.savedRecords, tmpId, insId);
                    });
                });
                editorEvt.raiseEvent('evtAfterSave', commandJson);
            } else {
                alert('数据保存失败!');
            }
        } else if (commandJson.args.result === 'ERROR') {
            alert('保存失败');
        } else if (commandJson.args.result === 'NONE') {
            //showEditorMsg('文档没有发生改变!', 'alert');
        }
    },
    //提示用户保存文档
    eventQuerySaveDocumentfunction: function (commandJson) {
        alert('新建文档保存后才可创建新文档');
    },
    //获得文档大纲
    eventGetDocumentOutline: function (commandJson) {},
    //创建文档事件
    eventCreateDocument: function (commandJson) {
        if (commandJson.args.result === 'ERROR') {
            alert('创建失败！');
            return;
        }
    },
    //加载文档事件
    eventLoadDocument: function (commandJson) {

        if (commandJson.args.result === 'ERROR') {
            alert('加载失败！');
            return;
        }
        privilege.setRevsion(emrEditor.getDocContext());
        privilege.setViewRevise(function () {
            var btn = $('#btnRevisionVisible');
            if (btn.length !== 0 && $('#btnRevisionVisible').text() === '隐藏痕迹') {
                $('#btnRevisionVisible').text('显示痕迹');
            }
            return false;
        });
        emrEditor.reloadBinddata(commandJson.args.InstanceID);
    },
    //文档签名事件
    eventSaveSignedDocument: function (commandJson) {
        if ((commandJson.args.result == 'OK') && (commandJson.args.params.result == 'OK')) {
            var insId = commandJson.args.params.InstanceID;
            
            showEditorMsg('数据签名成功!','alert');
            var insId = commandJson.args.params.InstanceID;
            common.GetRecodeParamByInsID(insId, function(tempParam) {
                //自动记录病例操作日志
                hisLog.operate('EMR.OP.Sign.OK',tempParam);
            });
            privilege.setRevsion(emrEditor.getDocContext());
            privilege.setViewRevise(function () {
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
                var insId = commandJson.args.InstanceID;
                showEditorMsg('病历删除成功！','alert');
                common.GetRecodeParamByInsID(commandJson.args.InstanceID, function(tempParam) {
                    //自动记录病例操作日志
                    hisLog.operate('EMR.OP.Delete.OK',tempParam);
                });
                
                var documentContext = emrEditor.getDocContext();
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
            } catch (err) {
                alert(err.message || err);
            } finally {
                editorEvt.raiseEvent('evtAfterDelete', commandJson);
            }
        }
    },
    eventAppendComposite: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            //eventSave();
            chartOnBlur();
        }
    },
    eventUpdateInstanceData: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            eventSave();
        }
    },
    eventInsertTextBlock: function (commandJson) {
        if (commandJson.args.result == 'OK') {
            //eventSave();
        }
    },
    // 打开链接单元
    eventHyperLink: function (commandJson) {
        var operation = commandJson.args.Url;
        var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetUnitLink', operation);
        ajaxGET(data, function (ret) {
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
                        HisTools.hislinkWindow.openUnitLink(ret, operation);
                    }
                } else {
                    alert('请检查链接单元【' + operation + '】配置！');
                }
            }
        }, function (ret) {
            alert('获取' + operation + '链接：' + ret);
        });
    },
    //判断知识库是否替换成功
    eventReplaceComposite: function (commandJson) {
        if (commandJson.args.result === 'OK') {
            showEditorMsg('知识库替换成功!', 'alert');
            //autoSaveEmrDoc();
        } else {
            showEditorMsg('知识库替换失败!', 'warning');
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
        var instanceId = documentContext.instanceId;
        var signProperty = commandJson.args;

        var fnAfterSave = function (commandJson) {
            if (commandJson) {
                if (commandJson.args && commandJson.args.result === 'ERROR')
                    return;
                else if (commandJson.QCResult === false)
                    return;
            }
            var qualityResult = quality.signChecker(documentContext);
            if (!qualityResult)
                return;

            if ('patient' === signProperty.SignatureLevel) { //手写签名
                var argEditor = {
                    instanceId: instanceId,
                    signDocument: function (instanceId, type, signLevel, userId, userName, Image, actionType, description) {
                        return iEmrPlugin.SIGN_DOCUMENT({
                            InstanceID: instanceId,
                            Type: type,
                            SignatureLevel: signLevel,
                            actionType: actionType,
                            Id: userId,
                            Name: userName,
                            Image: Image,
                            Description: description,
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
                    unSignedDocument: function () {
                        iEmrPlugin.UNSIGN_DOCUMENT();
                    }
                };
                handSign.sign(argEditor);
            } else if ('1' === sysOption.CAServicvice) {
                keySign.sign(signProperty.SignatureLevel, instanceId, signProperty);
            } else { // 系统签名 sysSign
                var userInfo = common.getUserInfo();
                //权限检查
                var checkresult = privilege.checkSign(userInfo, signProperty);
                if (!checkresult.flag)
                    return;
                //开始签名
                var signlevel = signProperty.SignatureLevel;
                var actionType = checkresult.ationtype;
                if (signProperty.OriSignatureLevel == 'Check' || signProperty.SignatureLevel == 'All') {
                    signlevel = userInfo.UserLevel;
                }
                if ('' === signlevel) {
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
        emrEditor.saveDoc(documentContext, fnAfterSave);
    },
    evtAfterGetMetaDataTree: null,
    eventGetMetaDataTree: function (commandJson) {
        editorEvt.raiseEvent('evtAfterGetMetaDataTree', commandJson);
    },
    eventUnSignDocument: function (commandJson) {
        alert(commandJson.args.result);
    },
    //打印事件监听
    eventPrintDocument: function(commandJson) {
        if (commandJson.args.result == 'OK') {
            if (commandJson.args.params.result == "OK") {
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
    // 异步命令回调
    callbackAfterEvt: null,
    raiseEvent: function (evtName, commandJson) {
        var evt = editorEvt[evtName];
        if (typeof evt === 'function') {
            try {
                evt(commandJson);
            } catch (ex) {
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
    }
};

// 系统参数时间间隔，如果为空则不启动下一次执行
function autoSaveEmrDoc() {
    if ('1' == envVar.readonly || 'Y' != sysOption.OPAutoSave) {
        return;
    }

    try {
        eventSave();
    } catch (e) {}

    if ('' != sysOption.OPAutoSaveInterval && sysOption.OPAutoSaveInterval > 0) {
        //setTimeout('autoSaveEmrDoc();', sysOption.OPAutoSaveInterval);
        setInterval('autoSaveEmrDoc();', sysOption.OPAutoSaveInterval);
    }
}

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
            $('#msgtd').css('background-color', '#ff0000');
			$('#msgtd').css('color', '#fff');
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
        //alert('//追加复合元素(知识库)');
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
    }
}

///跨页传json对象包含数组，会变换格式
function eventDispatchBroker(commandStr) {
    alert(commandStr);
    var commandJson = $.parseJSON(commandStr);
    editorEvt.eventDispatch(commandJson);
}

//快捷键保存 对外接口
function eventSave() {
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

    return iEmrPlugin.GET_READONLY();
}
