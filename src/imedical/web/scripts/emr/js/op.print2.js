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
    saveConfirm: function(){},
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
    newEmrPlugin: function() {
        if (!iEmrPlugin) {
            iEmrPlugin = new iEmrPluginEx(window.frames['editorFrame']);
        }
    },
    initDocument: function() {
        emrTemplate.closeAllTabs();
        if (envVar.savedRecords.length > 0) {
            var docParam = envVar.savedRecords[0];
            if (docParam == null) alert('加载文档失败');
            this.loadDoc(docParam);
            emrTemplate.loadTmplTabs(envVar.savedRecords, docParam.templateId, docParam.id);
        }
        else {
            alert('当次就诊下无保存病历');    
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
        iEmrPlugin.SET_CURRENT_REVISOR({
            Id: patInfo.UserID,
            Name: patInfo.UserName,
            IP: patInfo.IPAddress
        });

        iEmrPlugin.LOAD_DOCUMENT({
            status: 'BROWSE',
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
    },
    setPlugin: function(chartItemType) {
        if (sysOption.pluginType === 'DOC') {
            iEmrPlugin.showWord();
            iEmrPlugin.attachWord(sysOption.pluginUrl, sysOption.pluginType, sysOption.argConnect, editorEvt.eventDispatch);

            var fontStyle = $.parseJSON("{" + sysOption.setDefaultFontStyle.replace(/\'/g, "\"") + "}");
            iEmrPlugin.SET_DEFAULT_FONTSTYLE({
                args: fontStyle
            });
        
            //iEmrPlugin.setWorkEnvironment(chartItemType);
        
            iEmrPlugin.CLEAN_DOCUMENT();
            iEmrPlugin.SET_WORKSPACE_CONTEXT({
                args: chartItemType
            });
            iEmrPlugin.SET_NOTE_STATE({
                args: 'Edit'
            });
               iEmrPlugin.SET_READONLY_COLOR({
                args: '0000ff'
            });
            
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
    getDocContext: function(InstanceID) {
        var docContext = iEmrPlugin.GET_DOCUMENT_CONTEXT({
            InstanceID: InstanceID || '',
            isSync: true
        });
        return docContext;
    }
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

var editorEvt = {
    eventLoadDocument: function (commandJson) {
        $('#btnPnl').show();
        if (commandJson.args.result == "OK") {
            iEmrPlugin.SET_READONLY({
                ReadOnly: true,
                InstanceID: commandJson.args.InstanceID
            });
        }
    }, 
    eventDispatch: function(commandJson) {
        var fnAction = editorEvt[commandJson.action];
        if (typeof fnAction === 'function') {
            fnAction(commandJson);
        }
    },
    //打印事件监听
    eventPrintDocument: function(commandJson) {
        envVar.isPrinting = false;
        if (commandJson.args.result == 'OK') {
            if (commandJson.args.params.result == "OK") {
                showEditorMsg('病历打印成功!');
            }
        }
        iEmrPlugin.SET_READONLY({
            ReadOnly: true
        });
    }
};

function showEditorMsg(msg , type) {
    $('#msgtd').html('');
    $('#msgtd').css('background-color','red');

    $('#msgtd').append(msg);
    $('#msgTable').show();
    intervalidHideMsg = setInterval("$('#msgTable').hide();", 5000);    
}

$(function() {
    patInfo.IPAddress = getIpAddress();
    $('#btnClose').live('click', function() {
        if (envVar.isPrinting) return;
            closeWindow();
    });
    
    $('#btnPrint').live('click', function() {
        
        var documentContext = emrEditor.getDocContext();
        
        if (!documentContext)
            return;
        
        if (!privilege.canPrint(documentContext)) {
            return;
        }
        if (!quality.printChecker(documentContext))
            return;

        envVar.isPrinting = true;
        iEmrPlugin.PRINT_DOCUMENT({
            args: 'PrintDirectly'
        });
    });
    $('#btnPnl').hide();
    $('#editorFrame').attr('src', 'emr.op.editor.csp');
});