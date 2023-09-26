// ajax从后台取权限 add bu zhuj on 2009-12-9
function getPower() {
	Ext.Ajax.request({
				url : '../web.eprajax.ajaxGetPower.cls',
				timeout : parent.parent.timedOut,
				params : {
					episodeID : episodeID,
					printTemplateDocId : printTemplateDocId,
					templateDocId : templateDocID,
					EPRNum : EPRNum,
					patientID : pateintID
				},
				success : function(response, opts) {
					var obj = eval('[{' + response.responseText + '}]');
					canView = obj[0].canView;
					canSave = obj[0].canSave;
					canCommit = obj[0].canCommit;
					canChiefCheck = obj[0].canChiefCheck;
					canAttendingCheck = obj[0].canAttendingCheck;
					canReference = obj[0].canReference;
					canSwitchTemplate = obj[0].canSwitchTemplate;
					canDelete = obj[0].canDelete;
					canCASign = obj[0].canCASign;
					canHandSign = obj[0].canHandSign;
					setPower();
				},
				failure : function(response, opts) {
					var obj = "获取权限列表错误,错误代码:" + response.status + ","
							+ "错误信息:" + response.statusText;
					alert(obj);
				}
			});
}

// Kumon on 2011-05-08
// 病历引用功能按钮事件
function reference() {
	// 具体的病历引用方法在main.js文件中；
	// 这样做的目的是为了使遮罩的范围扩大到最外层；
	// PatientID,AdmitType,EpisodeID,TemplateID,TemplateDocID,PrintTemplateID,PrintTemplateDocID
    parent.parent.refMultiple(pateintID, paAdmType, episodeID, templateID,
			templateDocID, bindPrnTemplateID, printTemplateDocId);
}

function save(isConfirm) {
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“保存”按钮是否可按
	// 修改原因：新增快捷键F7，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
	if (Ext.getCmp('btnSave').disabled == false) {
		// 保存操作
		var eprlisteditor = frames['eprlisteditordll'].document
				.getElementById('eprlistedit');
		eprlisteditor.PrnTemplateDocID = printTemplateDocId;
		eprlisteditor.EPRNum = EPRNum;

		if (isConfirm == '' || typeof(isConfirm)=="undefined") {
			var saveState = eprlisteditor.SaveClick();
		} else {
			var saveState = eprlisteditor.SaveClick(isConfirm);
		}

		if (saveState != true) {
			// alert('保存失败!');
			return;
		}

		// 提示是否保存的信息状态
		isSave = true;

		var obj = eprlisteditor.StatusAfterSaveNewFrameWork;

		// add by zhuj on 2009-12-21
		currState = obj.split('^')[4];
		divState.innerHTML = obj.split('^')[3];
		EPRNum = obj.split('^')[2];
		var instanceID = eprlisteditor.InstanceDataID;

		// 更新留痕状态
		var tmpRevisionStatus = getRevisionStatus(revision, revisionActiveStatus, currState);
		eprlisteditor.SetRevisionStatus(tmpRevisionStatus);

		// 打印类型
		var printType = '';
		for (var i = 0; i < eprlisteditor.childNodes.length; i++) {
			if (eprlisteditor.childNodes[i].name == 'ChartItemType') {
				printType = eprlisteditor.childNodes[i].value;
			}
		}

		// 获得logID
		var logID = obj.split('^')[1];
		eprLogsID = logID;
		var objEprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
		invokeMultiPreview(objEprform, EPRNum, pateintID, episodeID, logID,
				bindPrnTemplateID, "Multiple", instanceID, userID, printTemplateDocId);

		// 更新标题
		var title = eprlisteditor.EPRListTitle;
		if (title) {
			setTabInfo(title);
		}
		getPower(); // add by zhuj on 2009-12-9
	}
}

function setTabInfo(title) {
	var tabPanel = parent.Ext.getCmp('centerTabPanel');
	var curTab = tabPanel.getActiveTab();
	if (curTab) {
		curTab.setTitle(title);
	}
}

// 北京CA数据签名所需的参数
var signArgs;

// 提交
function commit() {
	//debugger;
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“提交”按钮是否可按
	// 修改原因：新增快捷键F8，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
	if (Ext.getCmp('btnCommit').disabled == false) {
		// 判断是否未完成
		if (currState == 'unfinished' || currState == '') {
			alert('当前病历尚未完成,不能进行提交操作!');
			return;
		}

		if (printTemplateDocId == '' || EPRNum == '-1') {
			alert('当前病历未完成,不能进行提交操作!');
			return;
		}

		// 判断是否已经提交
		if (currState == 'commited') {
			alert('当前病历已经提交,不需重复提交!');
			return;
		}
		// 判断是否已经审核
		if (currState == 'attendingChecked' || currState == 'chiefChecked') {
			alert('当前病历已经审核,不需重复提交!');
			return;
		}
		// 判断是否已经归档
		if (currState == 'archieved') {
			alert('当前病历已经归档交,不需重复提交!');
			return;
		}

		var eprform = frames['eprlisteditordll'].document
				.getElementById('eprlistedit');

		// add by zhuj on 2010-1-27 begin
		eprform.PrnTemplateDocID = printTemplateDocId;
		eprform.EPRNum = EPRNum;
		// end

		var instanceID = eprform.InstanceDataID;
		var state = false;
        //debugger;
		if (parent.parent.IsCAOn()) {
			if (!parent.parent.ExistKey())
				return;
			signArgs = new Object();
			signArgs["userID"] = userID;
			signArgs["episodeID"] = episodeID;
			signArgs["printDocID"] = printTemplateDocId;
			signArgs["instanceIDs"] = instanceID;
			var result = ShowCAForm()
			if (result != true)
				return;
			//debugger;	
			state = eprform.CACommitClick(episodeID, EPRNum,
					printTemplateDocId, signArgs["signValue"],
					signArgs["instanceIDs"], signArgs["contentHash"],
					signArgs["UsrCertCode"]);
		} else {
			if (confirm('您确定要提交病历吗?'))
				state = eprform.CommitClick(EPRNum, printTemplateDocId);
			else
				return;
		}
        //debugger;
		if (state == true) {
			// commitedLogList();
			// 设置病历当前状态
			// add by zhuj on 2010-1-27 begin
			var obj = eprform.StatusAfterSaveNewFrameWork;

			currState = obj.split('^')[4];
			divState.innerHTML = obj.split('^')[3];

			getPower();
			// end
			var logID = obj.split('^')[1];
			invokeMultiPreview(eprform, EPRNum, pateintID, episodeID, logID,
				bindPrnTemplateID, "Multiple", instanceID, userID, printTemplateDocId);
		}

	}
}

// add by zhuj on 2009-12-21
// 提交日志
function commitedLogList() {
	Ext.Ajax.request({
				url : '../web.eprajax.logs.commited.cls',
				timeout : parent.parent.timedOut,
				params : {
					EpisodeID : episodeID,
					EPRDocID : printTemplateDocId,
					EPRNum : EPRNum
				},
				success : function(response, opts) {
					var obj = response.responseText;
					if (obj.split('^')[0] == "success") {
						// 设置病历当前状态
						currState = obj.split('^')[2];

						divState.innerHTML = obj.split('^')[1];
						getPower();

					} else if (obj == "sessionTimedOut") {
						alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
					} else {
						alert("写入日志错误!错误原因:" + obj);
					}

				},
				failure : function(response, opts) {
					var obj = "写入日志错误,错误代码:" + response.status + "," + "错误信息:"
							+ response.statusText;
					alert(obj);
				}
			});
}

function update() {
	var eprform = frames['eprlisteditordll'].document
			.getElementById('eprlistedit');
	var printState = eprform.RefreshClick();
}

// 更新模板
function updateTemplate() {
	var eprform = frames['eprlisteditordll'].document
			.getElementById('eprlistedit');
	eprform.PrnTemplateDocID = printTemplateDocId;
	eprform.EPRNum = EPRNum;
	var printState = eprform.TemplateClick('refreshNecessary');
	var obj = eprform.StatusAfterSaveNewFrameWork;
	// add by zhuj on 2010-1-22 如果obj为undefinded,直接返回
	if (obj == undefined) {
		return;
	}
	if (obj != 'UnChanged') {
		// add by zhuj on 2009-12-21
		currState = obj.split('^')[4];

		divState.innerHTML = obj.split('^')[3];
		EPRNum = obj.split('^')[2];

		// 更新留痕状态
		var tmpRevisionStatus = getRevisionStatus(revision, revisionActiveStatus, currState);
		eprform.SetRevisionStatus(tmpRevisionStatus);
		
		getPower(); // add by zhuj on 2009-12-9
		
		var instanceID = eprform.InstanceDataID;
		var logID = obj.split('^')[1];
		invokeMultiPreview(eprform, EPRNum, pateintID, episodeID, logID,
			 	bindPrnTemplateID, "Multiple", instanceID, userID, printTemplateDocId, "refresh");
	}
}

// 设置权限
function setPower() {
	if (canView != '1') {
		Ext.getCmp('btnUpdateData').disable();
	}

	if (canSave == '1' && canView == '1') {
		Ext.getCmp('btnSave').enable();
	} else {
		Ext.getCmp('btnSave').disable();
	}

	// add by zhuj on 2009-12-21 begin
	if (canCommit == '1' && canView == '1') {
		Ext.getCmp('btnCommit').enable();
	} else {
		Ext.getCmp('btnCommit').disable();
	}
	// end
	if (canView == "1" && canChiefCheck == "1") {
		Ext.getCmp('btnOnRecChiefCheck').enable()
	} else {
		Ext.getCmp('btnOnRecChiefCheck').disable()
	}

	if (canView == "1" && canAttendingCheck == "1") {
		Ext.getCmp('btnOnRecAttendingCheck').enable()
	} else {
		Ext.getCmp('btnOnRecAttendingCheck').disable()
	}
	
	if (canSwitchTemplate == '1' && canView == '1') {
		Ext.getCmp('btnUpdateTemplate').enable();
	} else {
		Ext.getCmp('btnUpdateTemplate').disable();
	}

	if (canReference == "1") {
		Ext.getCmp('btnReference').enable();
	} else {
		Ext.getCmp('btnReference').disable();
	}
	
	if (parent.parent.IsRecyclerOn() && canDelete == "1") {
		Ext.getCmp('btnDel').enable();
	} else if(parent.parent.IsRecyclerOn()){
		Ext.getCmp('btnDel').disable();
	}

	/*
	var flag = ('commited' == currState || 'attendingChecked' == currState
				|| 'chiefChecked' == currState);
	*/			
	// 签名按钮
	if (null != Ext.getCmp('btnSigniture')) {	
		if (canCASign == "1") {
			Ext.getCmp('btnSigniture').enable();
		} else {
			Ext.getCmp('btnSigniture').disable();
		}		     
	
		if (null != Ext.getCmp('btnHandSign')) {	
			if (canHandSign == "1") {
				Ext.getCmp('btnHandSign').enable();
			} else {
				Ext.getCmp('btnHandSign').disable();
			}		     
		}
   	}
}

// 自动保存
function eprAutoSave() {
	if (canView == 'False') {
		return;
	}
	save('True');
}

// 关闭计时器
function closeInterval() {
	clearInterval(interval);
}

function setSaveTime() {
	if (isNaN(autoSaveTime)) {
		autoSaveTime = -1;
	}

	if (autoSaveTime < 1) {
		autoSaveTime = -1;
	}

	if (autoSaveTime > 0 && autoSaveTime < 60) {
		autoSaveTime = 60;
	}
	if (autoSaveTime > 0) {
		interval = setInterval(eprAutoSave, autoSaveTime * 1000);
	}
}

// delete by loo on 2010-4-16
/*
 * //病人信息 function setPatientInfo() { var divInfo =
 * document.getElementById('divInfo'); divInfo.innerHTML = '&nbsp<span
 * class="spanColorLeft">登记号:</span> <span class="spanColor">' +
 * pInfo[0].papmiNo + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">床号:</span> <span class="spanColor">' + pInfo[0].disBed + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">姓名:</span> <span class="spanColor">' + pInfo[0].name + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">性别:</span> <span class="spanColor">' + pInfo[0].gender + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">年龄:</span> <span class="spanColor">' + pInfo[0].age + '</span>&nbsp&nbsp|&nbsp&nbsp' + '<span
 * class="spanColorLeft">诊断:</span> <span class="spanColor">' +
 * pInfo[0].mainDiagnos +'</span>&nbsp&nbsp|&nbsp&nbsp' + '<span
 * class="spanColorLeft">付费方式:</span> <span class="spanColor">' +
 * pInfo[0].payType +'</span>'; if (fontSize == "pt") { fontSize = "9pt" }
 * $(".spanColorLeft").css("fontSize", fontSize);
 * $(".spanColor").css("fontSize", fontSize); }
 */

// 病历状态
function setEprState() {
	var divState = document.getElementById('divState');
	divState.innerHTML = divStateServer;
}

// 显示历史日志信息
function showLog() {
	if (parent.parent.frames['centerTab'].frames['centerTabDetial']) {
		parent.parent.frames['centerTab'].frames['centerTabDetial'].frames['epreditordll']
				.setVisibility('hidden');
	}
	if (parent.parent.frames['centerTab'].frames['centerTabListDetial']) {
		parent.parent.frames['centerTab'].frames['centerTabListDetial'].frames['eprlisteditordll']
				.setVisibility('hidden');
	}
	parent.parent.showLogDetail(episodeID, printTemplateDocId, EPRNum);
}

function verify() {
	//debugger;
	signArgs = new Object();
	var eprform = frames['eprlisteditordll'].document
			.getElementById('eprlistedit');

	var instanceID = eprform.InstanceDataID;
	signArgs["episodeID"] = episodeID;
	signArgs["printDocID"] = printTemplateDocId;
	signArgs["eprNum"] = EPRNum;
	signArgs["instanceIDs"] = instanceID;
	parent.parent.verify(signArgs); // main.js
}

var IsShowUserPos="0";//数字签名按钮选择用户身份
function signiture() {
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey())
			return;
		signArgs = new Object();
		var eprform = frames['eprlisteditordll'].document
				.getElementById('eprlistedit');

		var instanceID = eprform.InstanceDataID;
		signArgs["userID"] = userID;
		signArgs["episodeID"] = episodeID;
		signArgs["printDocID"] = printTemplateDocId;
		signArgs["eprNum"] = EPRNum;
		signArgs["instanceIDs"] = instanceID;
		signArgs["action"] = "sign";
		if ("1" == IsSignByUserPos)
		{
			IsShowUserPos = "1"; 
		}		
		var result = ShowCAForm(IsShowUserPos);
		if (result)
		{
			var eprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
			var instanceID = eprform.InstanceDataID;
			invokeMultiPreview(eprform, EPRNum, pateintID, episodeID, eprLogsID,
			 	bindPrnTemplateID, "Multiple", instanceID, userID, printTemplateDocId);
		}
	}
}

function anySign()
{
	if (currState == 'unfinished' || currState == ''|| currState == 'created')
	{
		alert('当前病历尚未完成,不能进行签名操作!');
		return;
	}
	
	var eprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
	var instanceID = eprform.InstanceDataID;
	
	signArgs = new Object();
	signArgs["userID"] = userID;
	signArgs["episodeID"] = episodeID;
	signArgs["printDocID"] = printTemplateDocId;
	signArgs["instanceIDs"] = instanceID;
	signArgs["eprNum"] = EPRNum;
	signArgs["currState"] = currState;
	signArgs["action"] = "getAnySignItems";
	
	window.showModelessDialog("../csp/epr.newfw.anysign.csp?",self,
						"dialogWidth:330px;dialogHeight:260px;toolbar=no;menubar:no;location:no;status:no;help:no;fullscreen=no");
	
	return;
}

function anySignVerify()
{
	signArgs = new Object();
	signArgs["userID"] = userID;
	signArgs["episodeID"] = episodeID;
	signArgs["printDocID"] = printTemplateDocId;
	signArgs["instanceIDs"] = "";
	signArgs["eprNum"] = EPRNum;
	signArgs["currState"] = currState;
	signArgs["action"] = "getVerifyItems";
	
	window.showModelessDialog("../csp/epr.newfw.anysign.csp?",self,
						"dialogWidth:330px;dialogHeight:260px;toolbar=no;menubar:no;location:no;status:no;help:no;fullscreen=no");
	//preview();
	
    return;
}

function handWrittenSign()
{
	/*
    if (divState.innerHTML.indexOf('签名有效')<0)
    {
        alert('请先签名！');
        return;
    }
	*/
    var eprform = frames['eprlisteditordll'].document.getElementById('eprlistedit');
    var instanceID = eprform.InstanceDataID;
    var succ = eprform.HandwrittenMultiple(pateintID, episodeID, EPRNum, eprLogsID, userID, printTemplateDocId, instanceID);
    if (succ)
    {

        divState.innerHTML = divState.innerHTML.split('/')[0] + '/患者已签名';
    }
}

var signArgs;

// 主任审核
function onRecChiefCheck() {
	// debugger;
	var docEprNumList = printTemplateDocId+"^"+EPRNum;
	
	if (currState != 'commited'&& currState != 'attendingChecked') {
				alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
				return;
	}
	
	var UsrLevel = "Chief";
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey()) {
			return;
		}
		signArgs = new Object();
		signArgs["episodeID"] = episodeID;
		signArgs["printDocID"] = printTemplateDocId;
		signArgs["instanceIDs"] = instanceDataID;
		signArgs["EPRDocIDs"] =  docEprNumList;
		signArgs["EPRNum"] = "";
		signArgs["userLevel"] = UsrLevel;
		signArgs["action"] = "updateMultiple";
		var result = ShowCAForm()
		
		if (result) {
			invokeMultiPreviewList(pateintID, episodeID, userID,
					docEprNumList);
		}
	} else {
		eprAudit(UsrLevel, docEprNumList);
	}
}

function onRecAttendingCheck() {
	// debugger;
	var docEprNumList = printTemplateDocId+"^"+EPRNum;
	
	if (currState != 'commited'&& currState != 'attendingChecked') {
				alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
				return;
	}
	
	var UsrLevel = "Attending";
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey()) {
			return;
		}
		signArgs = new Object();
		signArgs["episodeID"] = episodeID;
		signArgs["printDocID"] = printTemplateDocId;
		signArgs["instanceIDs"] = instanceDataID;
		signArgs["EPRDocIDs"] =  docEprNumList;
		signArgs["EPRNum"] = "";
		signArgs["userLevel"] = UsrLevel;
		signArgs["action"] = "updateMultiple";
		var result = ShowCAForm()
		
		if (result) {
			invokeMultiPreviewList(pateintID, episodeID, userID,
					docEprNumList);
		}
	} else {
		eprAudit(UsrLevel, docEprNumList);
	}

}

function ShowCAForm(IsSignByUserPos) {
	//debugger;
	if ("0" == IsSignByUserPos) {
		return window
				.showModalDialog(
						"../csp/dhc.epr.ca.audit.csp",
						self,
						"dialogWidth:250px;dialogHeight:160px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
	} else {
		return window
				.showModalDialog(
						"../csp/dhc.epr.ca.audit.csp",
						self,
						"dialogWidth:250px;dialogHeight:190px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
	}
}

//生成病历预览图片 -- add on 2012-12-11 by houj
function invokeMultiPreview(objEPRForm, EPRNum, pateintID, episodeID, eprLogsID, printTemplateID, printType, instanceDataID, userID, printTemplateDocId, actDesc) {
	// 使用系统参数控制某些操作不触发生成病历图片动作
	if ((actionDisableImage!="")&&(actionDisableImage!="NULL")&&(actDesc != undefined)&&(actDesc != ""))
	{
		var tmpActionDiableImage = "^" + actionDisableImage + "^";
		if (tmpActionDiableImage.indexOf(actDesc)>=0)
		{
			//alert("不触发病历生成操作！");
			return;
		}
	}
	
	if (EPRNum < 1)
	{
		return;
	}
	if (printTemplateID == "")
	{
		return;
	}
	if (eprLogsID == "")
	{
		//alert("EPRLogsID为空,无法正常生成病历预览!");
		return;
	}
	objEPRForm.InvokePreviewService(pateintID, episodeID, eprLogsID,
			printTemplateID, printType, instanceDataID, userID, printTemplateDocId);
}

// 删除病历 Add by YaoLin
// Modify by Liangweixi
function delChart(){
	Ext.Ajax.request({
				url : '../web.eprajax.deleteChart.cls',
				timeout : parent.parent.timedOut,
				params : {
					EpisodeID : episodeID,
					EPRDocID : printTemplateDocId,
					EPRNum : EPRNum,
					BindTemplateID: templateID,
					ListChartItemID : ListChartItemID,
					Action : "DumpData"
				},
				success : function(response, opts) {
					var obj = response.responseText;
					if (obj.split('^')[0] == "success") {
						alert("删除成功!");
						parent.removeEprListEdit(templateDocID, printTemplateDocId, EPRNum)
					}
					else  {
						alert("删除失败!");
					} 

				},
				failure : function(response, opts) {
					var obj = "执行错误,错误代码:" + response.status + "," + "错误信息:"
							+ response.statusText;
					alert(obj);
				}
			
			});
	}

// 获取病历留痕状态
// isRevisionOn 是否开启留痕功能； resivisonActiveStatus 当前病历开始留痕的病历状态；eprStatus 当前病历状态
function getRevisionStatus(isRevisionOn, resivisonActiveStatus, eprStatus) {

    if (isRevisionOn != "Y") return "False";

    if (resivisonActiveStatus == "") {
        //未对此模板做特殊配置，使用默认留痕规则
        if ((eprStatus == "commited") || (eprStatus == "attendingChecked") || (eprStatus == "chiefChecked")) {
            return "True";
        } else {
            return "False";
        }
    }
    else {
        //做了特殊配置，使用配置留痕规则
        var resivisonActiveStatusArray = resivisonActiveStatus.split("|");
        for (var i = 0; i < resivisonActiveStatusArray.length; i++) {
            if (eprStatus.toUpperCase() == resivisonActiveStatusArray[i]) {
                return "True";
            }
        }
        return "False";
    }
}