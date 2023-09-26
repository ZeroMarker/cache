//关闭窗口
function closeWindow() {
    window.opener = null;
    window.open('', '_self');
    window.close();
}

//  emr.op.editor.csp invoke
function initEditor() {
    emrEditor.newEmrPlugin();
    emrEditor.initDocument();
}

var emrEditor = {
    tempParam: '',
    newEmrPlugin: function() {
        if (!iEmrPlugin) {
            iEmrPlugin = new iEmrPluginEx(window.frames['editorFrame']);
        }
    },
    initDocument: function() {
        if ('CREATE' == this.tempParam.actionType) {
            this.createDoc(this.tempParam);
        } else if ('LOAD' == this.tempParam.actionType) {
            this.loadDoc(this.tempParam);
        }
    },
    //加载文档
    loadDoc: function(docParam) {
        if (docParam == null)
            return;

        sysOption.pluginType = docParam.pluginType;
        this.setPlugin(docParam.chartItemType);
        iEmrPlugin.SET_PATIENT_INFO({
            args: patInfo
        });
        iEmrPlugin.LOAD_DOCUMENT({
            status: docParam.status,
            InstanceID: docParam.id,
            actionType: docParam.actionType
        });
    },    
    createDoc: function(docParam) {
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
    getDocContext: function(InstanceID) {
        var docContext = iEmrPlugin.GET_DOCUMENT_CONTEXT({
            InstanceID: InstanceID || '',
            isSync: true
        });
        return docContext;
    }
}

function doAfterPrint() {
    if (typeof window.external !== 'undefined') {
        if (typeof window.external.FinishPrint === 'function') {
            window.external.FinishPrint();      
        }
    }
    setTimeout(function(){
        closeWindow();
    }, 1000);
}

function insertSelfPrintLog(doAfterReq) {
    var data = ajaxDATA('String', 'EMRservice.HISInterface.BOExternal', 'InsertCustomSelfPrintLog', envVar.instanceId, patInfo.IPAddress, patInfo.UserID);
    ajaxGET(data, function(ret) {
        if ('function' == typeof doAfterReq)
            doAfterReq();
    }, function(err) {
        alert('InsertCustomSelfPrintLog error:' + err);
    });    
}

function doPrint() {
    if (envVar.autoPrint === 'Y') {
        var prtResult = iEmrPlugin.PRINT_DOCUMENT({
            args: 'PrintDirectly',
            CopyCount: envVar.CopyCount,
            isSync: true
        });
        
        if ('OK' === prtResult.result) {
            if (typeof window.dialogArguments != "undefined") {
                window.dialogArguments.insertSelfPrintLog(envVar.instanceId);
            } else {
                insertSelfPrintLog(doAfterPrint);
            }
        }
        doAfterPrint();
    } else {
        bindBtnPrint();
    }    
}

var editorEvt = {
    eventCreateDocument: function(commandJson) {
        if (commandJson.args.result == "OK") {
            iEmrPlugin.REFRESH_REFERENCEDATA({
                InstanceID: '',
                AutoRefresh: true,
                SyncDialogVisible: false
            });
            iEmrPlugin.SET_READONLY({
                ReadOnly: true
            });
            doPrint();
        }
    },
    eventLoadDocument: function (commandJson) {
        if (commandJson.args.result == "OK") {
            iEmrPlugin.SET_READONLY({
                ReadOnly: true
            });
            doPrint();
        }
    },    
    eventDispatch: function(commandJson) {
        var fnAction = editorEvt[commandJson.action];
        if (typeof fnAction === 'function') {
            fnAction(commandJson);
        }
    }
};

function bindBtnPrint() {

    $('#btnPrint').live('click', function() {
        envVar.isPrinting = true;
        var prtResult = iEmrPlugin.PRINT_DOCUMENT({
            args: 'PrintDirectly',
            isSync: true
        });
        if ('OK' === prtResult.result) {
            closeWindow();
        }
    });
}

function createInstance() {
    if ('' === envVar.emrTemplate) {
        alert('未找到指定的打印模板！');
        closeWindow();
    }
    common.GetRecodeParam(envVar.emrTemplate, function(tempParam) {
        emrEditor.tempParam = tempParam;
        $('#editorFrame').attr('src', 'emr.op.editor.csp');
    });
}


$(function() {
    patInfo.IPAddress = getIpAddress();
    try {
        if (envVar.autoPrint === 'Y') {
            
            $('body').layout('panel','south').panel('resize',{height:1});
            $('body').layout('resize');
            $('body').layout('panel','center').panel('resize',{height:10,width:10});
                      
        }

        $('#btnClose').live('click', function() {
            if (envVar.isPrinting) return;
            closeWindow();
        });

        if ('N'==envVar.isWithTemplate){
            common.GetRecodeParamByInsID(envVar.instanceId, function(tempParam) {
                emrEditor.tempParam = tempParam;
                $('#editorFrame').attr('src', 'emr.op.editor.csp');
            });
        } else {
            if ('' === envVar.emrTemplate) {
                alert('未找到指定的打印模板！');
                closeWindow();
            }
            common.GetRecodeParam(envVar.emrTemplate, function(tempParam) {
                emrEditor.tempParam = tempParam;
                $('#editorFrame').attr('src', 'emr.op.editor.csp');
            });
        }
        //createInstance();
    } catch (e) {
        alert('发生错误：' + e.message);
        window.returnValue = false;
        closeWindow();
    }
});