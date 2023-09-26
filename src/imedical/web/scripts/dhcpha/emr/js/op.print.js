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
        this.createDoc(this.tempParam);
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
            /*//setCurrentRevisor(userID, userName, getIpAddress());
            iEmrPlugin.SET_CURRENT_REVISOR({
                Id: patInfo.UserID,
                Name: patInfo.UserName,
                IP: patInfo.IPAddress
            });*/

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
            if (envVar.autoPrint === 'Y') {
                iEmrPlugin.PRINT_DOCUMENT({
                    args: 'PrintDirectly',
                    isSync: true
                });
                if (typeof window.external.FinishPrint === 'function')
                    window.external.FinishPrint();
                closeWindow();
            } else {
                bindBtnPrint();
            }
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
        isPrinting = true;
        var prtResult = iEmrPlugin.PRINT_DOCUMENT({
            args: 'PrintDirectly',
            isSync: true
        });
        if ('OK' === prtResult.result) {
            closeWindow();
        }
    });

    /*
    $('#btnPrint').live('click', function () {
        var data = ajaxDATA('String', 'EMRservice.BL.BLEMRCustomLogs', 'GetOPprintLog', patInfo.EpisodeID, envVar.emrTemplate);
        ajaxGET(data, function (ret) {
            ret = $.parseJSON(ret);
            if (ret.length > 0) {
                var msg = '已打印' + ret.length + '次：\r\n';
                for (var idx = 0; idx < ret.length; idx++) {
                    msg += '      ' + ret[idx].name + '  打印日期：' + ret[idx].datetime + '\r\n';
                }
                alert(msg);
            }
            var prtResult = iEmrPlugin.PRINT_DOCUMENT({
                    args: 'PrintDirectly',
                    isSync: true
                });
            if ('OK' === prtResult.result) {
                var insDataId = emrEditor.getDocContext().InstanceID;
                var data = ajaxDATA('String', 'EMRservice.BL.BLEMRCustomLogs', 'InsertOPprintLog', patInfo.EpisodeID, envVar.emrTemplate, insDataId, patInfo.UserID);
                ajaxGET(data, function (insDataId) {
					closeWindow();
				}, function (ret) {
                    alert('InsertOPprintLog error:' + ret);
                });
            }
        },
            function (err) {
            alert('GetOPprintLog error:' + err);
        });
    });*/
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
var isPrinting = false;
$(function() {
    try {
        if (envVar.autoPrint === 'Y') {
            $('#btnPnl').panel('resize', {
                height: 1
            });
            $('body').layout('resize');
        }

        $('#btnClose').live('click', function() {
            if (isPrinting) return;
            closeWindow();
        });

        createInstance();
    } catch (e) {
        alert('发生错误：' + e.message);
        window.returnValue = false;
        closeWindow();
    }
});