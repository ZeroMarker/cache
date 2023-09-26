// 是否可以打印
function setBtnPrintEnabled() {
	// 如果不能打印,返回
	if (canPrint != '1') {
		return;
	}

	// 如果没有开启,返回
	if (printAfterCommit != '1') {
		return;
	}

	if (currState == 'unfinished' || currState == 'finished' || currState == '') {
		Ext.getCmp('btnPrint').disable();
	} else {
		Ext.getCmp('btnPrint').enable();
	}
}

// ajax从后台取权限 add bu zhuj on 2009-12-4
function getPower() {
	// debugger;
	Ext.Ajax.request({
				url : '../web.eprajax.ajaxGetPower.cls',
				timeout : parent.parent.timedOut,
				params : {
					episodeID : episodeID,
					printTemplateDocId : printTemplateDocId,
					templateDocId : templateDocId,
					EPRNum : EPRNum,
					patientID : pateintID
				},
				success : function(response, opts) {
					var obj = eval('[{' + response.responseText + '}]');
					canView = obj[0].canView;
					canSave = obj[0].canSave;
					canPrint = obj[0].canPrint;
					canCommit = obj[0].canCommit;
					canSwitch = obj[0].canSwitch;
					canReference = obj[0].canReference;
					canSwitchTemplate = obj[0].canSwitchTemplate;
					canChiefCheck = obj[0].canChiefCheck;
					canAttendingCheck = obj[0].canAttendingCheck;
					printAfterCommit = obj[0].printAfterCommit;
					canExport = obj[0].canExport;
					setPower();
				},
				failure : function(response, opts) {
					var obj = "获取权限列表错误,错误代码:" + response.status + ","
							+ "错误信息:" + response.statusText;
					alert(obj);
				}
			});
}

// 预览
function preview() {
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	eprform.PrnTemplateDocID = printTemplateDocId;
	eprform.TemplateDocID = templateDocId;
	eprform.PreviewClick(bindPrnTemplateID, printTemplateDocId);
}

// 预览
function exportRecord() {
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	eprform.PrnTemplateDocID = printTemplateDocId;
	eprform.TemplateDocID = templateDocId;
	eprform.ExportRecordClick(bindPrnTemplateID, printTemplateDocId);
}

// 保存
function save(isConfirm) {
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“保存”按钮是否可按
	// 修改原因：新增快捷键F7，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
	if (Ext.getCmp('btnSave').disabled == false) {
		// 保存操作
		var eprform = frames['epreditordll'].document.getElementById('eprform');
		eprform.PrnTemplateDocID = printTemplateDocId;
		eprform.TemplateDocID = templateDocId;

		if (isConfirm == '') {
			var saveState = eprform.SaveClick();
		} else {
			var saveState = eprform.SaveClick(isConfirm);
		}

		if (saveState != true) {
			alert('保存失败!');
			return;
		}

		// 提示是否保存的信息状态
		isSave = true;

		// 设置tree的图标 add by zhuj on 2009-12-15
		parent.parent.selectTreeNode.getUI().getIconEl().src = '../scripts/epr/Pics/saveSingle.gif';
		parent.parent.selectTreeNode.getUI().removeClass('tree-unsave');
		parent.parent.selectTreeNode.getUI().addClass('tree-save');

		var obj = eprform.StatusAfterSaveNewFrameWork;

		// 设置病历当前状态
		currState = obj.split('^')[3];

		// 修改状态
		divState.innerHTML = obj.split('^')[1];

		// 打印类型
		var printType = '';

		for (var i = 0; i < eprform.childNodes.length; i++) {
			if (eprform.childNodes[i].name == 'ChartItemType') {
				printType = eprform.childNodes[i].value;
			}
		}

		// 获得logID
		var logID = obj.split('^')[2];
		eprLogsID = logID;
		if (EPRNum == '1') {
			var objEprform = frames['epreditordll'].document
					.getElementById('eprform');
			objEprform.InvokePreviewService(pateintID, episodeID, logID,
					bindPrnTemplateID, printType, "", userID,
					printTemplateDocId);
		}
		// setBtnPrintEnabled(); //add by zhuj on 2009-11-17
		// 重新取得权限并设置
		getPower();
		return(saveState);
	}
}

// 上一页
function prev(e) {
	parent.parent.selectPrev(e);
}

// 下一页
function next(e) {
	parent.parent.selectNext(e);
}

// 更新
function update() {
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	var printState = eprform.RefreshClick();
}

// 打印
function print() {
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“打印”按钮是否可按
	// 修改原因：新增快捷键F9，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
	if (Ext.getCmp('btnPrint').disabled == false) {
		if (currState == 'unfinished' || currState == '') {
			alert('未"完成"的病历不能打印!');
			return;
		}

		// 判断ID是否为空,若为空,则直接返回
		if (bindPrnTemplateID == "") {
			Ext.getCmp('btnPrint').disable();
			alert("打印模板ID为空,不能进行打印操作!");
			return;
		}

		/*
		 * //如果打印时需要运行质控，则首先弹出一个提示框 if (printQuality == "1") { var eprform =
		 * frames['epreditordll']; eprform.setVisibility('hidden');
		 * 
		 * //弹出一个提示框，质控检测中 eprform.setVisibility('visible'); }
		 */

		var eprform = frames['epreditordll'].document.getElementById('eprform');

		// add by zhuj on 2010-1-27 begin
		eprform.PrnTemplateDocID = printTemplateDocId;
		eprform.TemplateDocID = templateDocId;
		// end

		var printState = eprform.PrintClick(bindPrnTemplateID,
				printTemplateDocId);

		// 判断打印是否成功
		if (printState != true) {
			return;
		}
		// 写日志
		// printLog();
		// add by zhuj on 2010-1-27 begin
		var obj = eprform.StatusAfterSaveNewFrameWork;
		divState.innerHTML = obj.split('^')[1];
		getPower(); // add by zhuj on 2009-12-4
		// end
	}
}

// 为北京CA数字签名使用
// userID, episodeID, printTemplateDocId, IDs, signValue, contentHash, EPRNum
var signArgs;// new Array(7);

var msg = "";
// 提交
function commit() {
	// debugger;
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“提交”按钮是否可按
	// 修改原因：新增快捷键F8，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
	if (Ext.getCmp('btnCommit').disabled == false) {
		// 判断是否未完成
		if (currState == 'unfinished' || currState == '') {
			alert('当前病历尚未完成,不能进行提交操作!');
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
		/*
		 * if (currState != 'finished') { alert('只能提交当前状态为"完成"的病历!'); return; }
		 */

		var eprform = frames['epreditordll'].document.getElementById('eprform');
		// add by zhuj on 2010-1-27 begin
		eprform.PrnTemplateDocID = printTemplateDocId;
		eprform.TemplateDocID = templateDocId;
		// end

		var state = false;
		// 数字签名
		if (parent.parent.IsCAOn()) {
			if (!parent.parent.ExistKey())
				return;
			signArgs = new Object();
			signArgs["userID"] = userID;
			signArgs["episodeID"] = episodeID;
			signArgs["printDocID"] = printTemplateDocId;
			signArgs["instanceIDs"] = "";
			var result = ShowCAForm()
			if (result != true)
				return;
			state = eprform.CACommitClick(episodeID, templateDocId,
					printTemplateDocId, signArgs["signValue"],
					signArgs["instanceIDs"], signArgs["contentHash"],
					signArgs["UsrCertCode"]);
		} else {
			if (confirm('您确定要提交病历吗?'))
				state = eprform.CommitClick(templateDocId, printTemplateDocId);
			else
				return;
		}
		// debugger;
		if (state == true) {
			// 设置病历当前状态
			// commitedLog();

			// add by zhuj on 2010-1-27 begin
			// 设置tree的图标
			if (EPRNum == "1") {
				parent.parent.selectParentNode.getUI()
						.removeClass('tree-uncommit');
				parent.parent.selectParentNode.getUI().addClass('tree-commit');
				// var nodeText = parent.parent.selectParentNode.text;
				// parent.parent.selectParentNode.setText(nodeText +
				// "(已提交)");
			}
			var obj = eprform.StatusAfterSaveNewFrameWork;
			currState = obj.split('^')[3];
			// 修改状态
			divState.innerHTML = obj.split('^')[1];
			getPower(); // add by zhuj on 2009-12-4
			
			//生成病历预览图片
			invokeSinglePreview(eprform,EPRNum, pateintID, episodeID, eprLogsID,
					bindPrnTemplateID, printTemplateType, "", userID, printTemplateDocId);
			// end
		}
	}
}

// 选择病历
function sltTemplate() {
	// debugger;
	var eprform = frames['epreditordll'];
	eprform.setVisibility('hidden');

	var selectNode = parent.parent.selectParentNode;
	parent.parent.templateSelect(selectNode, episodeID);
}

// 主任医生审核
function chiefCheck() {
	if (currState != 'commited' && currState != 'attendingChecked') {
		alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
		return;
	}

	// 数字签名
	var UsrLevel = 'Chief';
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey())
			return;
		signArgs = new Object();
		signArgs["episodeID"] = episodeID;
		signArgs["EPRDocID"] = printTemplateDocId;
		signArgs["printDocID"] = printTemplateDocId;
		signArgs["instanceIDs"] = "";
		signArgs["eprNum"] = EPRNum;
		signArgs["userLevel"] = UsrLevel;
		signArgs["action"] = "check";
		// 弹出输入框 登录成功
		var result = ShowCAForm()
		if (result)
		{
			//getPower();
			//生成病历预览图片
			invokeSinglePreview(eprform,EPRNum, pateintID, episodeID, eprLogsID,
					bindPrnTemplateID, printTemplateType, "", userID, printTemplateDocId);
		}
	} else {
		eprAudit(UsrLevel);
	}
}

// 主治医生审核
function attendingCheck() {
	if (currState != 'commited') {
		alert('只能审核当前状态为"提交"的病历!');
		return;
	}

	// 数字签名
	var UsrLevel = 'Attending';
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey())
			return;
		signArgs = new Object();
		signArgs["episodeID"] = episodeID;
		signArgs["EPRDocID"] = printTemplateDocId;
		signArgs["printDocID"] = printTemplateDocId;
		signArgs["instanceIDs"] = "";
		signArgs["eprNum"] = EPRNum;
		signArgs["userLevel"] = UsrLevel;
		signArgs["action"] = "check";
		var result = ShowCAForm()
		if (result)
		{
			//getPower();
			//生成病历预览图片
			invokeSinglePreview(eprform,EPRNum, pateintID, episodeID, eprLogsID,
					bindPrnTemplateID, printTemplateType, "", userID, printTemplateDocId);
		}
	} else {
		eprAudit(UsrLevel);
	}
}

// 更新模板
function updateTemplate() {
	// debugger;
	if (necessaryTemplate == "-1") {
		alert('获取是否是必填模板失败.');
		return;
	}

	var eprform = frames['epreditordll'].document.getElementById('eprform');
	eprform.PrnTemplateDocID = printTemplateDocId;
	eprform.TemplateDocID = templateDocId;

	if (necessaryTemplate == "1") {
		var printState = eprform.TemplateClick('refreshNecessary');
	} else if (necessaryTemplate == "0") {
		var printState = eprform.TemplateClick('refreshUnnecessary');
	}

	var obj = eprform.StatusAfterSaveNewFrameWork;
	if (obj != 'UnChanged') {
		// 设置tree的图标 add by zhuj on 2009-12-15
		parent.parent.selectTreeNode.getUI().getIconEl().src = '../scripts/epr/Pics/unSaveSingle.gif';
		parent.parent.selectTreeNode.getUI().removeClass('tree-save');
		parent.parent.selectTreeNode.getUI().addClass('tree-unsave');
		if (necessaryTemplate == "1") {
			// parent.parent.selectParentNode.getUI().getIconEl().src =
			// '../scripts/epr/Pics/unSaveSingle.gif';
			parent.parent.selectParentNode.getUI().removeClass('tree-commit');
			parent.parent.selectParentNode.getUI().addClass('tree-uncommit');
		}
		// debugger;
		// 设置病历当前状态
		currState = obj.split('^')[3];
		// 修改状态
		divState.innerHTML = obj.split('^')[1];
		// 执行打印按钮权限
		getPower(); // add by zhuj on 2009-12-4
		
		//生成病历预览图片
		invokeSinglePreview(eprform,EPRNum, pateintID, episodeID, eprLogsID,
			bindPrnTemplateID, printTemplateType, "", userID, printTemplateDocId, "refresh");
	}
}

// /add by zhuj on 2009-7-28
// /打印
function printLog() {
	Ext.Ajax.request({
				url : '../web.eprajax.logs.print.cls',
				timeout : parent.parent.timedOut,
				params : {
					EpisodeID : episodeID,
					EPRDocID : printTemplateDocId,
					templateDocId : templateDocId,
					EPRNum : EPRNum
				},
				success : function(response, opts) {
					var obj = response.responseText;
					if (obj.split('^')[0] == "success") {
						divState.innerHTML = obj.split('^')[1];
						getPower(); // add by zhuj on 2009-12-4
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

// /add by zhuj on 2009-7-28
// /提交
function commitedLog() {
	Ext.Ajax.request({
				url : '../web.eprajax.logs.commited.cls',
				timeout : parent.parent.timedOut,
				params : {
					EpisodeID : episodeID,
					EPRDocID : printTemplateDocId,
					templateDocId : templateDocId,
					EPRNum : EPRNum
				},
				success : function(response, opts) {
					var obj = response.responseText;
					if (obj.split('^')[0] == "success") {
						// 设置tree的图标 add by zhuj on 2009-12-15
						if (EPRNum == "1") {
							parent.parent.selectParentNode.getUI()
									.removeClass('tree-uncommit');
							parent.parent.selectParentNode.getUI()
									.addClass('tree-commit');
							// var nodeText =
							// parent.parent.selectParentNode.text;
							// parent.parent.selectParentNode.setText(nodeText +
							// "(已提交)");
						}

						// 设置病历当前状态
						currState = obj.split('^')[2];

						// 修改状态
						divState.innerHTML = obj.split('^')[1];
						// setBtnPrintEnabled(); //add by zhuj on 2009-11-17
						getPower(); // add by zhuj on 2009-12-4

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

// 自动保存
function eprAutoSave() {
	if (!(canView == "1" && canSave == "1")) {
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

/*
 * //病人信息 function setPatientInfo() { var divInfo =
 * document.getElementById('divInfo'); divInfo.innerHTML = '&nbsp<span
 * class="spanColorLeft">登记号:</span> <span class="spanColor">' +
 * pInfo[0].papmiNo + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">床号:</span> <span class="spanColor">' + pInfo[0].disBed + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">姓名:</span> <span class="spanColor">' + pInfo[0].name + '</span>&nbsp&nbsp|&nbsp&nbsp<span
 * class="spanColorLeft">性别:</span> <span class="spanColor">' + pInfo[0].gender + '</span>&nbsp&nbsp|&nbsp&nbsp' + '<span
 * class="spanColorLeft">年龄:</span> <span class="spanColor">' + pInfo[0].age + '</span>&nbsp&nbsp|&nbsp&nbsp' + '<span
 * class="spanColorLeft">诊断:</span> <span class="spanColor">' +
 * pInfo[0].mainDiagnos +'</span>' + '</span>&nbsp&nbsp|&nbsp&nbsp' + '<span
 * class="spanColorLeft">付费方式:</span> <span class="spanColor">' +
 * pInfo[0].payType +'</span>'; if (fontSize == "pt") { fontSize = "9pt" }
 * $(".spanColorLeft").css("fontSize", fontSize);
 * $(".spanColor").css("fontSize", fontSize); }
 */

// 病历状态
function setEprState() {
	// debugger;
	var divState = document.getElementById('divState');
	divState.innerHTML = divStateServer;
}

function refresh(episodeID, patientID, templateDocID, prtTemplateDocID) {
	var iframeID = String.format("iframe{0}And{1}", templateDocID,
			prtTemplateDocID);
	Ext.Ajax.request({
		url : '../web.eprajax.ajaxCreateEprEdit.cls',
		timeout : parent.parent.timedOut,
		params : {
			episodeID : episodeID,
			patientID : patientID,
			templateDocId : templateDocID,
			printTemplateDocId : prtTemplateDocID
		},
		success : function(response, opts) {
			// debugger;
			if (response.responseText == 'sessionTimedOut') {
				document.getElementById(iframeID).src = 'epr.newfw.sessiontimedout.csp';
				return;
			}

			// 设置页面上的相关变量的值
			var obj = eval("[{" + response.responseText + "}]");

			canView = obj[0].canView;
			canSave = obj[0].canSave;
			canPrint = obj[0].canPrint;
			canCommit = obj[0].canCommit;
			canSwitch = obj[0].canSwitch;
			canReference = obj[0].canReference;
			canSwitchTemplate = obj[0].canSwitchTemplate;
			canChiefCheck = obj[0].canChiefCheck;
			canAttendingCheck = obj[0].canAttendingCheck;
			canExport = obj[0].canExport;
			setPower();

			templateID = obj[0].bindTemplateID;
			printTemplateDocId = prtTemplateDocID;
			templateDocId = templateDocID;
			bindPrnTemplateID = obj[0].bindPrintTemplateID;
			currState = obj[0].currState;
			pInfo = obj;
			divStateServer = obj[0].divStateServer;
			necessaryTemplate = obj[0].necessaryTemplate;

			setEprState(obj[0].divStateServer);
			EPRNum = obj[0].EPRNum;
			printAfterCommit = obj[0].printAfterCommit;

			// 设置dll值
			var eprEditDll = frames['epreditordll'].document
					.getElementById("eprform");
			eprEditDll.ChartItemID = templateDocID;
			eprEditDll.ProfileID = templateDocID;
			if (obj[0].canView == "1") {
				eprEditDll.Browsable = "True";
			} else {
				eprEditDll.Browsable = "False";
			}

			if (revision == 'Y') {
				if (obj[0].currState != "commited"
						&& obj[0].currState != "attendingChecked"
						&& obj[0].currState != "chiefChecked") {
					eprEditDll.Revisionable = "False";
				} else {
					eprEditDll.Revisionable = "True";
				}
			} else {
				eprEditDll.Revisionable = "False";
			}
		},
		failure : function(response, opts) {
			var obj = "数据加载失败,请稍后在试,错误代码:" + response.status + "," + "错误信息:"
					+ response.statusText;
			alert(obj);
		}
	});
}

function setPower() {
	if (canView == "1" && canSave == "1") {
		Ext.getCmp('btnSave').enable()
	} else {
		Ext.getCmp('btnSave').disable()
	}

	if (canView == "1") {
		Ext.getCmp('btnPreview').enable()
	} else {
		Ext.getCmp('btnPreview').disable()
	}

	if (canView == "1" && canPrint == "1") {
		Ext.getCmp('btnPrint').enable()
	} else {
		Ext.getCmp('btnPrint').disable()
	}

	if (canView == "1" && canCommit == "1") {
		Ext.getCmp('btnCommit').enable()
	} else {
		Ext.getCmp('btnCommit').disable()
	}

	if (canView == "1" && canSwitch == "1") {
		Ext.getCmp('btnSltTemplate').enable()
	} else {
		Ext.getCmp('btnSltTemplate').disable()
	}

	if (canView == "1" && canSwitchTemplate == "1") {
		Ext.getCmp('btnUpdateTemplate').enable()
	} else {
		Ext.getCmp('btnUpdateTemplate').disable()
	}

	if (canView == "1" && canChiefCheck == "1") {
		Ext.getCmp('btnChiefCheck').enable()
	} else {
		Ext.getCmp('btnChiefCheck').disable()
	}

	if (canView == "1" && canAttendingCheck == "1") {
		Ext.getCmp('btnAttendingCheck').enable()
	} else {
		Ext.getCmp('btnAttendingCheck').disable()
	}

	if (canView == "1" && canExport == "1") {
		Ext.getCmp('btnExport').enable()
	} else {
		Ext.getCmp('btnExport').disable()
	}

	if (canView == "1") {
		Ext.getCmp('btnUpdateData').enable()
	} else {
		Ext.getCmp('btnUpdateData').disable()
	}

	if (canReference == "1") {
		Ext.getCmp('btnReference').enable();
	} else {
		Ext.getCmp('btnReference').disable();
	}

	if (window.parent.isCategoryChapterLocked) {
		setBtnDisable();
	}

	// test
	// Ext.getCmp('btnChiefCheck').enable()
	// Ext.getCmp('btnAttendingCheck').enable()

	// 签名按钮
	if (null != Ext.getCmp('btnSigniture')) {
	    var flag = false;
		if ('commited' == currState || 'attendingChecked' == currState
				|| 'chiefChecked' == currState) {
			flag = canSave == "1";
		}  
		if (flag) {
			Ext.getCmp('btnSigniture').enable();
		} else {
			Ext.getCmp('btnSigniture').disable();
		}	
	}
}

// 由于病历已经被锁，所以需将一些button置成disable
// LingChen
function setBtnDisable() {
	Ext.getCmp('btnSave').disable();
	Ext.getCmp('btnUpdateData').disable();
	Ext.getCmp('btnUpdateTemplate').disable();
	Ext.getCmp('btnPrint').disable();
	Ext.getCmp('btnCommit').disable();
	Ext.getCmp('btnReference').disable();
	Ext.getCmp('btnSltTemplate').disable();
	Ext.getCmp('btnChiefCheck').disable();
	Ext.getCmp('btnAttendingCheck').disable();
	Ext.getCmp('btnExport').disable();
	Ext.getCmp('btnSigniture').disable();	
}

// 显示历史日志信息
function showLog() {
	parent.parent.setDllVisibility("hidden");
	parent.parent.showLogDetail(episodeID, printTemplateDocId, EPRNum);
}

// Kumon on 2011-05-08
// 病历引用功能按钮事件
function reference() {
	// 具体的病历引用方法在main.js文件中；
	// 这样做的目的是为了使遮罩的范围扩大到最外层；
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	if (eprform) {
		var instanceID = eprform.CurInstanceDataID;
		parent.parent.refSingle(pateintID, paAdmType, episodeID, instanceID,
				templateID, templateDocId, bindPrnTemplateID,
				printTemplateDocId);
	}
}

//作者：YHY
//功能：同步患者基本信息选项卡
// 具体的实现方法在main.js文件中；
// 这样做的目的是为了使遮罩的范围扩大到最外层；
function GetUpData(){
	var action='SAVE';
	var eprform = frames['epreditordll'].document.getElementById('eprform');
	if (eprform) {
		parent.parent.GetObserverUpData(pateintID, action, episodeID, userID,
				templateID);
	}
}

// 禁用上一页和下一页按钮，此按钮可能会导致tab选项卡页面刷新异常
function setPreAndNextPage() {
	if (disablePreAndNextPage == "Y") {
		Ext.getCmp('btnPrev').disable();
		Ext.getCmp('btnNext').disable();
	}
}

function verify() {
	if (currState == 'unfinished' || currState == '') {
		alert('当前病历尚未完成,不能进行操作!');
		return;
	}
	signArgs = new Object();
	signArgs["userID"] = userID;
	signArgs["episodeID"] = episodeID;
	signArgs["printDocID"] = printTemplateDocId;
	signArgs["instanceIDs"] = "";
	signArgs["eprNum"] = EPRNum;
	parent.parent.verify(signArgs); // main.js
}

var IsShowUserPos="0";//大同三院需要在点击数字签名按钮时能选择用户身份
function signiture() {
	// 数字签名
	if (currState == 'unfinished' || currState == '') {
		alert('当前病历尚未完成,不能进行操作!');
		return;
	}
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey())
			return;
		signArgs = new Object();
		signArgs["userID"] = userID;
		signArgs["episodeID"] = episodeID;
		signArgs["printDocID"] = printTemplateDocId;
		signArgs["instanceIDs"] = "";
		signArgs["eprNum"] = EPRNum;
		signArgs["action"] = "sign";
		if ("1" == IsSignByUserPos)
		{
			IsShowUserPos = "1"; 
		}			    
		try
		{
            var result = ShowCAForm(IsShowUserPos);
		    if (result)
			{
			    //getPower();
				//生成病历预览图片
				var eprform = frames['epreditordll'].document.getElementById('eprform');
				invokeSinglePreview(eprform,EPRNum, pateintID, episodeID, eprLogsID,
						bindPrnTemplateID, printTemplateType, "", userID, printTemplateDocId);
			}
		}
		catch(e)
		{
			alert(e.message);
		}
		finally
		{
			IsShowUserPos = "0";
		}
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
function invokeSinglePreview(objEPRForm, EPRNum, pateintID, episodeID, eprLogsID, printTemplateID, printType, instanceDataID, userID,printTemplateDocId, actDesc) {
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

	if (EPRNum != '1')
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

// 生成病历预览图片 -- add on 2012-12-11 by houj
function invokeSinglePreviewBySltTpl(bindPrnTemplateID, printTemplateDocId) {
	var eprformdll = frames['epreditordll'].document.getElementById('eprform');
	invokeSinglePreview(eprformdll, EPRNum, pateintID, episodeID, eprLogsID,
					bindPrnTemplateID, printTemplateType, "", userID, printTemplateDocId, "switch");
}
