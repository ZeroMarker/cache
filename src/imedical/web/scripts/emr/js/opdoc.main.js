///门诊病历
$(function () {
    //门诊HisUI页面风格改造-特殊字符页面 add by niucaicai 2018-06-19
    $HUI.dialog('#HisUISpecharsWin').close();
    //门诊HisUI页面风格改造-模板选择页面 add by niucaicai 2018-06-20
    $HUI.dialog('#HisUITempClassifyWin').close();
    //门诊HisUI页面风格改造-操作日志页面 add by niucaicai 2018-06-20
    $HUI.dialog('#HisUILogdetailWin').close();
	//门诊HisUI管理个人模板页面
	$HUI.dialog('#HisUIManagePersonalWin').close();
    patInfo.IPAddress = getIpAddress();
    
    var OPDisplay = isNaN(envVar.OPDisplay)?((screen.availWidth) * 0.382):((envVar.OPDisplay>1)?(envVar.OPDisplay):(($('#main').width()) * envVar.OPDisplay));
    $('#resRegion').panel('resize', {
        width: OPDisplay
    });
    $('body').layout('resize');
    
    if ('' === patInfo.EpisodeID) {
        var frm = top.document.forms['fEPRMENU'];
        patInfo.EpisodeID = frm.EpisodeID.value;
        patInfo.PatientID = frm.PatientID.value;
        patInfo.MRadm = frm.mradm.value;
        reacquireParams();
    }

    //禁止后退键
    document.onkeypress = forbidBackSpace;
    document.onkeydown = forbidBackSpace;

    window.onbeforeunload = function () {
        if ('cancel' === emrEditor.savePrompt(true))
            return '点击【取消】留在当前页面上';
        if (HisTools.checkOeordBeforeUnload())
            return '点击【取消】留在当前页面上';
        
        HisTools.closeHislinkWindow();
    };

    initHisTools();
    initPnlButton();
    setSysMenuDoingSth('病历界面加载中...');

    $('#editorFrame').attr('src', 'emr.opdoc.editor.csp');
    
    if (!hisLog) {
        hisLog = new HisLogEx(sysOption.IsSetToLog, patInfo);
    }
    //自动记录病例操作日志
    hisLog.login();
    //初始化文字大小修改(正常项目不开放)
    //setFontSizeData();
});

//  emr.opdoc.editor.csp invoke
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
        alert(err.message || err);
    }
}

function getFirstTmpl() {
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetFirstTmpl', patInfo.UserLocID, patInfo.SsgroupID, patInfo.EpisodeID, patInfo.UserID);
    ajaxGETSync(data, function (ret) {
        if (ret !== '') {
            envVar.firstTmpl = $.parseJSON(ret);
        }
    }, function (ret) {
        //$.messager.alert('发生错误', 'GetFirstTmpl:' + ret, 'error');
        alert('发生错误', 'GetFirstTmpl:' + ret);
    });
}

function getSavedRecords() {
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'getSavedRecords', patInfo.EpisodeID, patInfo.UserLocID, patInfo.SsgroupID);
    ajaxGETSync(data, function (ret) {
        if (ret !== '') {
            envVar.savedRecords = $.parseJSON(ret);
        }
    }, function (ret) {
        //$.messager.alert('发生错误', 'savedRecords:' + ret, 'error');
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
    //$.messager.alert('提示', alertInfo, 'info');
}

//
function reacquireParams() {
    getFirstTmpl();
    getSavedRecords();
    
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
    var sthmsg = '病历正在初始化...';
    setSysMenuDoingSth(sthmsg);  
	//刷新惠每
	if(typeof initCDSSData == "function" && typeof cdssLock != "undefined" && cdssLock=="Y"){
		initCDSSData(_episodeID,_patientID);
	}		
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
}
            
// 切换病人
function switchPatient(_patientID, _episodeID, _mradm) {

    if (_episodeID == patInfo.EpisodeID)
        return;
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
    if (('undefined' != typeof refreshArgs.copyOeoris)&&('' !=refreshArgs.copyOeoris)) {
        pasteRefData(refreshArgs.copyOeoris);
        return;
    }
    if (refreshArgs.adm == patInfo.EpisodeID)
        return;
    //检查病历修改
    emrEditor.savePrompt(true);
    switchEMRContent(refreshArgs.papmi, refreshArgs.adm, refreshArgs.mradm);
}

// 诊疗TAB切换离开时
var chartOnBlur = function () {
    eventSave("switchTab"); 
    
    document.getElementById('chartOnBlur').focus();
    return '' === getSysMenuDoingSth();
}

// 诊疗TAB切换进入时
var chartOnFocus = function () {
    return true;
}

// 平台调用，检查病历是否发生变化
var checkModifiedBeforeUnload = function () {
    var result = false;
    try {
        result = iEmrPlugin.CHECK_DOCUMENT_MODIFY({
                isSync: true
            }).Modified == 'True';
    } catch (e) {}
    return result;
}

function setSysMenuDoingSth(sthmsg) {
	var checkType = sysOption.SwitchCheckDoingSth || 'BASE';
	if (checkType == 'BASE') {
	    if ('undefined' != typeof dhcsys_getmenuform) {
	        if ('undefined' != typeof dhcsys_getmenuform()) {
	            var DoingSth = dhcsys_getmenuform().DoingSth || '';
	            if ('' != DoingSth)
	                DoingSth.value = sthmsg || '';
	        }
	    }
	} else if (checkType == "DOC") {
    	if (!parent) return;
    	var t = parent.document.getElementById("DoingSth") || '';
    	if (t == '') return;
    	t.value = sthmsg || '';
	}
}

function getSysMenuDoingSth() {
	var checkType = sysOption.SwitchCheckDoingSth || 'BASE';
	if (checkType == 'BASE') {
    	if ('undefined' != typeof dhcsys_getmenuform) {
        	if ('undefined' != typeof dhcsys_getmenuform()) {
            	var DoingSth = dhcsys_getmenuform().DoingSth || '';
            	if ('' != DoingSth)
                	return DoingSth.value || '';
        	}
    	}
    	return '';
	} else if (checkType == "DOC") {
    	if (!parent) return '';
    	var t = parent.document.getElementById("DoingSth") || '';
    	if (t == "") return '';
    	return t.value || '';
	}
	
	return '';
}

// 设置门诊页面只读与否 传入 true/false 默认为 false
function setReadonly(flag) {
    envVar.readonly = flag || false;
}

function isReadonly() {
    return envVar.readonly;
}

//平台调用-将HISUI病历浏览页面浏览的门诊病历引用到门诊书写界面
function pasteRefData(insID)
{
    common.GetRecodeParamByInsIDSync(insID, createDocFromInstance);
}

//平台调用-关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
	if ('cancel' === emrEditor.savePrompt(true))
	    return false;
	if (HisTools.checkOeordBeforeUnload())
	    return false;
	    
	HisTools.closeHislinkWindow();
	return true;
}
