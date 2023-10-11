var emrEditor = {
    newEmrPlugin: function() {
        if (!iEmrPlugin) {
            iEmrPlugin = new iEmrPluginEx(window.frames['editorFrame']);
        }
    },
    getDocContext: function(InstanceID) {
        envVar.docContext = iEmrPlugin.GET_DOCUMENT_CONTEXT({
            InstanceID: InstanceID || '',
            isSync: true
        });
        return envVar.docContext;
    },
    getInstanceID: function() {
        this.getDocContext('');
        if (!envVar.docContext)
            return '';
        return (envVar.docContext.InstanceID || '');
    },
    isOpened: function(docParam) {

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
    loadDoc: function(docParam) {
        if (docParam == null)
            return;
        
        if (this.isOpened(docParam))
            return;

        sysOption.pluginType = docParam.pluginType;
        this.setPlugin(docParam.chartItemType);
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        
        setSysMenuDoingSth('病历加载中...');
        iEmrPlugin.LOAD_DOCUMENT({
            status: docParam.status,
            InstanceID: docParam.id,
            actionType: docParam.actionType
        });

        iEmrPlugin.SET_READONLY({
            ReadOnly: true,
            InstanceID: docParam.id
        });
        //自动记录病例操作日志
        hisLog.operate('EMR.OP.LoadDoc',docParam);
    },
	//打印
    printDoc: function () {
        iEmrPlugin.PRINT_DOCUMENT({
            args: 'Print',
            printMode: ''
        });
    },
    cleanDoc: function() {
        iEmrPlugin.CLEAN_DOCUMENT();
    },
    ///初始化页面
    initDocument: function(autoLoadTmp) {
        if (autoLoadTmp) return;
        var docParam = envVar.savedRecords;
        this.loadDoc(docParam);
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
    foo: function() {}
};

var editorEvt = {
    //设置链接串
    eventSetNetConnect: function(commandJson) {
        if (commandJson.args.result != 'OK')
            alert('设置链接失败！');
    },
    //加载文档事件
    eventLoadDocument: function(commandJson) {
        setSysMenuDoingSth();
        if (commandJson.args.result === 'ERROR') {
            alert('加载失败！');
            return;
        }
    },
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
        //if(commandJson["action"] == "eventLoadDocument") debugger;
        if (typeof fnAction === 'function') {
            fnAction(commandJson);
        }
    }
};
