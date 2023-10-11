///门诊病历
$(function () {
	//读配置，资源区放在左边还是右边
	var options = {border:true,split:true,overflow:'hidden',id:'resRegion',region:sysOption.ResourceLocation};
	$('#centerLayout').layout('add', options);
	$("#resRegion").append('<div id="dataTabs" class="hisui-tabs" data-options="fit:true,border:false"></div>')

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

    if (sysOption.ResTabPosition != 'top') {
        $('#dataTabs').tabs({tabPosition:sysOption.ResTabPosition,headerWidth:100});
    }
    
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

    initHisTools();
    initPnlButton();
    setSysMenuDoingSth('病历界面加载中...');

    $('#editorFrame').attr('src', 'emr.opdoc.editor.csp?MWToken='+getMWToken());
    
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
        if ((envVar.savedRecords.length == 0)&&(sysOption.TmplDocIDByLocID != "")) {
            var msgText = "是否生殖平台病人?"; // 华西二院个性化需求
            var ret = confirm(msgText);
            if (ret) {
                getFirstTmpl(ret);
            }
        }
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

function getFirstTmpl(rtnFlag) {
    rtnFlag = rtnFlag || false;
    var data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetFirstTmpl', patInfo.UserLocID, patInfo.SsgroupID, patInfo.EpisodeID, patInfo.UserID,envVar.emrDocId);
    if (rtnFlag) {
        data = ajaxDATA('String', 'EMRservice.Ajax.opInterface', 'GetFirstTmpl', patInfo.UserLocID, patInfo.SsgroupID, patInfo.EpisodeID, patInfo.UserID, sysOption.TmplDocIDByLocID);
    }
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

function getEMRVersionID() {
    var data = ajaxDATA('String', 'EMRservice.BL.BLScatterData', 'GetDataVersion', patInfo.EpisodeID);
    ajaxGETSync(data, function (ret) {
        if (ret !== '') {
            envVar.versionID = ret;
        }
    }, function (ret) {
        //$.messager.alert('发生错误', 'getEMRVersionID:' + ret, 'error');
        alert('发生错误', 'getEMRVersionID:' + ret);
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
    getSavedRecords();
    getEMRVersionID();
    if ((envVar.savedRecords.length == 0)&&(sysOption.TmplDocIDByLocID != "")) {
        var msgText = "是否生殖平台病人?"; // 华西二院个性化需求
        var ret = confirm(msgText);
        getFirstTmpl(ret);
    }else{
        getFirstTmpl();
    }
    
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
	if(typeof initCDSSData == "function" && typeof cdssLock != "undefined" && cdssLock==="Y"){
        //清空cdssSucess数组
        if (cdssSucess.length > 0) {
            cdssSucess = [];
        }
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
}
            
// 切换病人
function switchPatient(_patientID, _episodeID, _mradm) {

    if (_episodeID == patInfo.EpisodeID)
        return;
    // 检查病历修改
    emrEditor.saveConfirm(true);
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
    if (refreshArgs.adm == patInfo.EpisodeID){
        // 医生站"总览&打印"界面上，签名按钮传入InstanceID，跳转到指定病历实例
        if ('undefined' != typeof refreshArgs.InstanceID){
            var instanceID = refreshArgs.InstanceID;
            var isSelected = false;
            $.each(envVar.savedRecords, function(idx, item) {
                if (item.isLeadframe === '1') {
                    flag = instanceID.split('||')[0] === item.id.split('||')[0];
                    envVar.savedRecords[idx].id = instanceID;
                    isSelected = true;
                }else{
                    flag = instanceID === item.id;
                }
                if (flag) {
                    var tabId = emrTemplate.getTabId(item.templateId, item.id);
                    emrTemplate.selectTmplTab(tabId, isSelected);
                    return false;
                }
            });
        }
        return;
    }
    //20220826 去掉病历自身的提示有修改是否保存方法，改为由医生站在切换患者时通过头菜单上的DoingSthSureCallback和DoingSthCancelCallback进行判断，弹窗提示
    //emrEditor.saveConfirm(true);
	$("#dialogSynData").dialog("close");
    switchEMRContent(refreshArgs.papmi, refreshArgs.adm, refreshArgs.mradm);
}

// 诊疗TAB切换离开时
var chartOnBlur = function () {
    eventSave("switchTab","",true);
    document.getElementById('chartOnBlur').focus();
	return true;
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

///在头菜单上添加回调方法，供平台调用，用以实现病历有修改时离开页面，提示是否保存
function setDoingSthSureCallback(flag) {
	var win = websys_getMenuWin();
	//设置确定取消的回调方法
	if (flag)
	{
		//平台提示有修改是否保存，点击保存时调用
		win.DoingSthSureCallback = function(){
			//判断保存权限||串患者
			if (getReadOnlyStatus().ReadOnly == "False")
			{
				var documentContext = emrEditor.getDocContext();
	        	if ((isConsistent(documentContext))&&(privilege.canSave(documentContext)))
	 			{
		 			//失效签名
		 			var modifyResult = emrEditor.getModifyResult();
		 			var flag = emrEditor.doRevokeSignedDocument(modifyResult);

		            if (!flag) 
		            {
						var saveResult = iEmrPlugin.SAVE_DOCUMENT({
				            isSync: true
				        });
				        
				        // 保存成功后调用
				        if (saveResult.result === 'OK') {
				            SaveDocumentAfter(saveResult.params.InstanceID);
				        }
		 			}
	 			}
			}
	        var win = websys_getMenuWin()
			win.DoingSthSureCallback = "";
			win.DoingSthCancelCallback = "";
			setSysMenuDoingSth("");
		}
		//平台提示有修改是否保存，点击不保存时调用
		win.DoingSthCancelCallback = function(){
			var documentContext = emrEditor.getDocContext();
            //重置修改状态
			emrEditor.resetModify(documentContext.InstanceID,false);
			unlockByIns(documentContext.InstanceID);
			var win = websys_getMenuWin()
			win.DoingSthSureCallback = "";
			win.DoingSthCancelCallback = "";
			setSysMenuDoingSth("");
		};
	}
	else
	{
		win.DoingSthSureCallback = "";
		win.DoingSthCancelCallback = "";
	}
}

// 设置门诊页面只读与否 传入 true/false 默认为 false
function setReadonly(flag) {
    envVar.readonly = flag || false;
}

function isReadonly() {
    return envVar.readonly || getReadOnlyStatus().ReadOnly =="True";
}

//平台调用-将HISUI病历浏览页面浏览的门诊病历引用到门诊书写界面
function pasteRefData(insID)
{
    common.GetRecodeParamByInsIDSync(insID, createDocFromInstance);
}

//平台调用-关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
	emrEditor.saveConfirm(true);
	if (HisTools.checkOeordBeforeUnload())
	    return false;
	    
	HisTools.closeHislinkWindow();
	
	//急诊留观流水病历中取消保存时清空头菜单写入的信息。
	setSysMenuDoingSth("");
	
	return true;
}

//判断当前页面是否是病历页面，如果不是控制不弹出刷新绑定页面
function isSelectEMRTab() {
	if ('undefined' != typeof parent.GetCurframeObj) {
    	if ('undefined' != typeof parent.GetCurframeObj()) {
	    	var frame = parent.GetCurframeObj();
        	var frameDesc = frame.frameDesc || '';
        	var frameId = frame.frameId || '';
        	if ((frameId != "")&&(frameDesc != "")) {
	        	if ((frameDesc !== "门诊病历")&&(frameId !== "iemr.opdoc.main.csp"))
	        		return false;
	        }
    	}
	}
	return true;
}

//显示\隐藏锁信息
function setLockMessage(message)
{
	var messages = message.split("|");
	var span = $("<span></span>");
	if (messages.length>1)
	{
	   	$(span).html("该病历正被编辑:("+messages[1]+"|"+messages[6]+"|"+messages[5]+"|"+messages[3]+"|"+messages[2]+")");
	   	$(span).attr({"userCode":messages[0],"userName":messages[1],"ip":messages[3],"lockId":messages[4],"instaceID":messages[7].replace(/-/g, '||')});
		$("#lock").html(span);
		$("#lock").show();
	}
	else
	{
		$("#lock").html(span);
		$("#lock").hide();
	}
}

function unlockSetReadonly()
{
	//发送锁消息
	setLockMessage("");
	//判断权限是否只读
	emrEditor.setEditorReadonlyByprivilege();
}

function unlockByIns(insID)
{
	if ((envVar.lockedIns != "")&&(envVar.lockedIns == insID))
	{
		unLock(envVar.lockedID);
		envVar.lockedID = "";
		envVar.lockedIns = "";
	}
}
