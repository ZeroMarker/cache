///门诊病历
$(function() {
    patInfo.IPAddress = getIpAddress();

    if ($('#pnlwest').length > 0) {
        $('#pnlwest').panel('resize', {
            width: screen.availWidth * 0.382
        });

        $('#emrEditor').panel('resize', {
            height: (screen.availHeight - 50) * 0.382
        });
        $('body').layout('resize');
    } else {
        var OPDisplay = isNaN(envVar.OPDisplay) ? ((screen.availWidth) * 0.618) : ((envVar.OPDisplay > 1) ? (envVar.OPDisplay) : ((screen.availWidth) * envVar.OPDisplay));
        $('#emrEditor').panel('resize', {
            width: OPDisplay
        });
        $('#pnlButton').panel('resize', {
            height: envVar.OPHeight 
        });
        $('body').layout('resize');
    }

    if (sysOption.ResTabPosition != 'top') {
        $('#dataTabs').tabs({tabPosition:sysOption.ResTabPosition});
    }
    
    if ('' === patInfo.EpisodeID) {
        var frm = top.document.forms['fEPRMENU'];
        patInfo.EpisodeID = frm.EpisodeID.value;
        patInfo.PatientID = frm.PatientID.value;
        patInfo.MRadm = frm.mradm.value;
        reacquireParams();
    } else {
        loadingwinshow();
        //病种
        if (typeof(disease) !== 'undefined')
            disease.initDiseaseZTree();
    }

    if (isExistVar(sysOption.isShowPatInfo) && 'Y' == sysOption.isShowPatInfo) {
        setOutPatientInfoBar(envVar.patInfoBar);
    }

    if ($('#kbCollapsePnl').length > 0) {
        $('#kbDataFrame').attr('src', 'emr.resource.kbtree.csp?flagFirst=0');
    }
    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;

    window.onbeforeunload = function() {
        /*var n = window.event.screenX - window.screenLeft;
        var b = n > document.documentElement.scrollWidth - 20;
        if (event.keyCode == 0 && window.screenLeft != 10008) {
            if ('cancel' === emrEditor.savePrompt(true))
                return '点击【取消】留在当前页面上';
            if (HisTools.checkOeordBeforeUnload())
                return '点击【取消】留在当前页面上';
        }*/
        if ($.browser.version == '11.0') {
	        if ('cancel' === emrEditor.savePrompt(true))
                return '点击【取消】留在当前页面上';
            if (HisTools.checkOeordBeforeUnload())
                return '点击【取消】留在当前页面上';
	    } else if (event.keyCode == 0 && window.screenLeft != 10008) {
            if ('cancel' === emrEditor.savePrompt(true))
                return '点击【取消】留在当前页面上';
            if (HisTools.checkOeordBeforeUnload())
                return '点击【取消】留在当前页面上';
        }

        HisTools.closeHislinkWindow();
        //window.close();
    };

    initHisTools();
    initPnlButton();
    if ('' != envVar.lockWarning) {
        alert(envVar.lockWarning);
    }
    setSysMenuDoingSth('病历界面加载中...');
    $('#editorFrame').attr('src', 'emr.op.editor.csp');
    
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
    //自动记录病例操作日志
    hisLog.login();
});

//  emr.op.editor.csp invoke
function initEditor() {
    var sthmsg = '病历正在初始化...';
    setSysMenuDoingSth(sthmsg);    
    try {
        emrEditor.newEmrPlugin();
        emrEditor.initDocument();
        if (sthmsg == getSysMenuDoingSth()) {
            setSysMenuDoingSth();
        }            
    } catch (err) {
        setSysMenuDoingSth();
        hideLoadingWinFun();
        alert(err.message || err);
    }
}

// 患者信息
function GetOutPatientInfoBar(pID, eID) {
    if (isExistVar(sysOption.isShowPatInfo) && 'Y' == sysOption.isShowPatInfo) {
        var data = ajaxDATA('String', 'EMRservice.BL.opInterface',
            'GetPatientInfo', pID, eID);
        ajaxGET(data, function(ret) {
            setOutPatientInfoBar(ret);
        }, function(ret) {
            alert('发生错误', 'GetPatientInfo:' + ret);
        });
    }
}

function getFirstTmpl() {
    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'GetFirstTmpl', patInfo.UserLocID, patInfo.SsgroupID, patInfo.EpisodeID, patInfo.UserID);
    ajaxGETSync(data, function(ret) {
        if (ret !== '') {
            envVar.firstTmpl = $.parseJSON(ret);
        }
    }, function(ret) {
        alert('发生错误', 'GetFirstTmpl:' + ret);
    });
}

function getSavedRecords() {
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getSavedRecords', patInfo.EpisodeID, patInfo.UserLocID, patInfo.SsgroupID);
    ajaxGETSync(data, function (ret) {
        if (ret !== '') {
            envVar.savedRecords = $.parseJSON(ret);
        }
    }, function(ret) {
        alert('发生错误', 'savedRecords:' + ret);
    });
}

function setOutPatientInfoBar(outPatInfoBar) {
    if (outPatInfoBar === '')
        return;
    if (30 > $('#patientInfo').height()) {
        $('#patientInfo').panel('resize', {
            height: 30
        });
    }
    $('#patientInfo').html('');
    $('#patientInfo').append(outPatInfoBar);
    $('#patientInfo').css('display', 'inline-block');
    $('body').layout('resize');

    // 南方医院提示患者黑名单
    var alertInfo = $('#alertInfo').attr('value');
    if (alertInfo)
        alert(alertInfo);
}

//知识库收缩
function collapse(flag, reload) {
    if ('N' == (envVar.kbTreeAutoExpand || 'N'))
        return;

    if ($('#kbCollapsePnl').length === 0) return;

    if (flag) {
        if (!$('#kbCollapsePnl').panel('options').collapsed)
            $('#FuncArea').layout('collapse', 'west');
    } else {
        if ($('#kbCollapsePnl').panel('options').collapsed)
            $('#FuncArea').layout('expand', 'west');
    }

    if (reload) {
        $('#kbDataFrame').attr('src', 'emr.resource.kbtree.csp?flagFirst=1');
    }
}

// value : 'Y', 'N'
function setKBTreeAutoExpand(value) {
    envVar.kbTreeAutoExpand= value
}

//
function reacquireParams() {
    //刷新患者信息栏
    GetOutPatientInfoBar(patInfo.PatientID, patInfo.EpisodeID);

    var data = ajaxDATA('String', 'EMRservice.BL.opInterface', 'emrEntryLock', patInfo.EpisodeID);
    ajaxGETSync(data, function(ret) {
        envVar.lockWarning = ret;
        if ('' != envVar.lockWarning) {
            alert(envVar.lockWarning);
        }
    }, function(err) {
        alert('发生错误', 'emrEntryLock:' + err.message || err);
    });

    getFirstTmpl();
    getSavedRecords();
    //病症--病种
    if (typeof(disease) !== 'undefined')
        disease.initDiseaseZTree();
    if (typeof(hisLog) !== 'undefined') {
        //自动记录病例操作日志
        hisLog.login();
    }
}

// 更新病历页面内容
function switchEMRContent(_patientID, _episodeID, _mradm) {
    //全局参数替换
    patInfo.PatientID = _patientID;
    patInfo.EpisodeID = _episodeID;
    patInfo.MRadm = _mradm;
    //关闭弹出的资源区
    emrEditor.closeResourceWindow();
    reacquireParams();
	//刷新CDSS
	if(typeof initCDSSData == "function" && typeof cdssLock != "undefined" && cdssLock=="Y"){
		initCDSSData(_episodeID,_patientID);
	}   
    var sthmsg = '病历正在初始化...';
    setSysMenuDoingSth(sthmsg); 
    try {
        //刷新编辑器
        emrEditor.initDocument();
        if (sthmsg == getSysMenuDoingSth()) {
            setSysMenuDoingSth();
        }            
    } catch (err) {
        setSysMenuDoingSth();
        alert(err.message || err);
    }
    // 刷新资源区
    HisTools.refreshResFrame();
    //收缩知识库
    collapse(true, true);
}

// 切换病人
function switchPatient(_patientID, _episodeID, _mradm) {

    if (_episodeID == patInfo.EpisodeID) {
        if (!(typeof (iEmrPlugin.getPlugin()) === 'undefined')) return;
    }
    // 检查病历修改
    if ('cancel' === emrEditor.savePrompt(true)) {
        return;
    }
    // 检查医嘱是否审核
    if (HisTools.checkOeordBeforeUnload())
        return;
    //刷新HIS参数
    var frm = top.document.forms['fEPRMENU'];
    var frmEpisodeID = frm.EpisodeID;
    var frmPatientID = frm.PatientID;
    var frmmradm = frm.mradm;
    frmPatientID.value = _patientID;
    frmEpisodeID.value = _episodeID;
    frmmradm.value = _mradm;

    switchEMRContent(_patientID, _episodeID, _mradm);
}

///  外部接口
// 平台刷新
function xhrRefresh(refreshArgs) {
    //if ((refreshArgs.adm == patInfo.EpisodeID)||(!(typeof (iEmrPlugin.getPlugin()) === 'undefined'))) {
    //去掉检查，否则会重复提示创建病历两遍或者不刷新患者信息
    if (refreshArgs.adm == patInfo.EpisodeID) {
        return;
    }
    loadingwinshow();
    //检查病历修改
    emrEditor.savePrompt(true);
    switchEMRContent(refreshArgs.papmi, refreshArgs.adm, refreshArgs.mradm);
}

// 诊疗TAB切换离开时
var chartOnBlur = function() {
    eventSave("switchTab"); 
    
    document.getElementById('chartOnBlur').focus();
    return '' === getSysMenuDoingSth();
}

// 诊疗TAB切换进入时
var chartOnFocus = function() {
    return true;
}

// 平台调用，检查病历是否发生变化
var checkModifiedBeforeUnload = function() {
    var result = false;
    try {
        result = iEmrPlugin.CHECK_DOCUMENT_MODIFY({
            isSync: true
        }).Modified == 'True';
    } catch (e) {}
    return result;
}

// 设置门诊页面只读与否 传入 true/false 默认为 false
function setReadonly(flag) {
    envVar.readonly = flag || false;
}

function isReadonly() {
    if ('' != envVar.lockWarning) return true;
    return envVar.readonly;
}

// 知识库界面使用，获取病历只读状态，只读病历，禁止引用知识库内容（并控制不能替换知识库）
function getReadOnlyStatus() {
    return isReadonly();
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                DoingSth.value = sthmsg || '';
        }
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                return DoingSth.value || '';
        }
    }
    return '';
}

//隐藏进度条
function hideLoadingWinFun() {
	if (top==window){
  		return;
	}else{
		if ('undefined' != typeof parent.hideLoadingWinFun) {
	  		if ('undefined' != typeof parent.hideLoadingWinFun()) {
	       		parent.hideLoadingWinFun();
	   		}
   		}
	}
}

//显示进度条
function loadingwinshow() {
	if (top==window){
  		return;
	}else{
		if ('undefined' != typeof parent.loadingwin) {
		    if ('undefined' != typeof parent.loadingwin.show) {
			    if ('undefined' != typeof parent.loadingwin.show()) {
			        parent.loadingwin.show();
			    }
		    }
	    }
	}
}