/*
 * Creater:chenwenjun CreatDate:090505 Desc:历次列表的操作函数
 */
// ajax从后台取权限 add bu zhuj on 2009-12-4
function getPower() {
	Ext.Ajax.request({
				url : '../web.eprajax.ajaxGetPower.cls',
				timeout : parent.parent.timedOut,
				params : {
					episodeID : _EpisodeID,
					printTemplateDocId : _PrtTemplateDocID,
					templateDocId : _TemplateDocID,
					EPRNum : "",
					patientID : _PatientID
				},
				success : function(response, opts) {
					var obj = eval('[{' + response.responseText + '}]');
					canView = obj[0].canView;
					canSave = obj[0].canSave;
					canPrint = obj[0].canPrint;
					canCommit = obj[0].canCommit;
					canSwitch = obj[0].canSwitch;
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

function PrintClickHandler() {
	/*
	 * if (GetChkSelectAllChecked()) { alert('只有 显示全部 时方可打印！\n\n如要打印，请先将左上角 只显示<...>
	 * 的对勾去掉！') return false; }
	 */
	var objUCPrint = document.getElementById('UCPrint');
 
	if (objUCPrint) {
		var handSignedCount = 0; // 包含手写签名记录
		var unHandSignedCount = 0; // 包含未手写签名记录
		var strInstances = "";
	    var strEpisodeIDs = "";
	    
		var ckbPrintList = document.getElementById('EPRList').all['ckbPrint'];
		var instanceList = document.getElementById('EPRList').all['valueTr'];
		if (ckbPrintList == null) {
			alert("历次列表无记录!");
			return false;
		}

		if (ckbPrintList.length == undefined) {
			// 表示只有一条记录
			if (ckbPrintList.checked) {
				// 判断是否是未完成的病历 add by zhuj on 2009-11-25
				if (ckbPrintList.statusCode == "unfinished") {
					alert('未"完成"的病历不能打印!');
					return false;
				}
				strInstances = instanceList.instanceid + ",";
				strEpisodeIDs = instanceList.episodeid + ",";

				if (isHandSigned(0)) {
					handSignedCount += 1;
				} else {
					unHandSignedCount += 1;
				}
			}
		} else {
			// add by zhuj on 2009-9-12
			var firstCkbPrintDocID = '-1';
			var ckbPrintListLength = ckbPrintList.length;
			for (var i = 0; i < ckbPrintListLength; i++) {
				var curCkbPrint = ckbPrintList[i];
				if (curCkbPrint.checked) {
					// 判断是否是未完成的病历 add by zhuj on 2009-11-25
					if (curCkbPrint.statusCode == "unfinished") {
						alert('未"完成"的病历不能打印!');
						return false;
					}
					if (firstCkbPrintDocID == '-1') {
						firstCkbPrintDocID = curCkbPrint.logDocID;
					}

					else if (firstCkbPrintDocID != curCkbPrint.logDocID) {
						alert('每次打印只能选择同一模板的数据!');
						return false;
					}

					if (isHandSigned(i)) {
						handSignedCount += 1;
					} else {
						unHandSignedCount += 1;
					}
				} else {
					continue;
				}
			}

			var ckbPrintListLength = ckbPrintList.length;
			for (var i = 0; i < ckbPrintListLength; i++) {
				var curCkbPrint = ckbPrintList[i];
				if (curCkbPrint.checked) {
					var curInstanceID = instanceList[i].instanceid;
					if (curInstanceID) {
						strInstances += curInstanceID + ",";
						strEpisodeIDs += instanceList[i].episodeid + ",";
					}
				} else {
					continue;
				}
			}

		}

		if (!(strInstances == "")) {

			if (handSignedCount > 0 && unHandSignedCount > 0) {
				alert("不能同时选择患者已签名的记录和未签名的记录！");
				return false
			}

			var strResult = strInstances.substr(0, strInstances.length - 1);
			var strEpisodeList = strEpisodeIDs.substr(0, strEpisodeIDs.length - 1);

			if (unHandSignedCount > 0) {
				var result = objUCPrint.PrintMultiple(_PatientID, _EpisodeID,
						strResult, _UserID, _PrtTemplateDocID, strEpisodeList, privacyLevel);
				return result;
			} else {
				var result = objUCPrint.PrintPDFMultiple(_EpisodeID,
						_PrtTemplateDocID);
				return result;
			}
		} else {
			alert("请选择需要打印的条目");
			return false
		}
	
	}
}

// 打开历次中的某一次
function OpenRecordClickHandler(episodeid, categoryid, profileid, instanceid,
		eprNum, chartID, patientID, logRowID, templateDocID, prtDocID,
		lstTitle, happenDate) {
	parent.OpenRecordClickHandler(episodeid, categoryid, profileid, instanceid,
			eprNum, chartID, patientID, logRowID, templateDocID, prtDocID,
			lstTitle, happenDate);
	// parent.showTab("multiple", "epr.newfw.epreditor.csp?EpisodeID=" +
	// episodeid + "&CategoryID=" + categoryid + "&ProfileID=" + profileid +
	// "&InstanceDataID=" + instanceid, 'epredit');
}

// 判断是否选中了“只显示”
function GetChkSelectAllChecked() {
	return Ext.getCmp('chkSelectAll').checked;
}

// 新建
function newList() {
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“新建”按钮是否可按
	// 修改原因：新增快捷键F2，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。
	if (Ext.getCmp('btnNew').disabled == false) {
	    toLastPage="true";
		// debugger;
		var eprListNo = 1;
		var list = document.getElementById('EPRList').all['ckbPrint'];
		if (list) {
			eprListNo = list.length + 1;
		}
		parent.createEprListEdit(_PatientID, _EpisodeID, _CategoryID,
				_CategoryType, _ProfileID, _ProfileID, _TemplateID,
				_TemplateName, _TemplateDocID, eprListNo)
	}
}

// 预览
function preview() {
	//debugger;
	if (Ext.getCmp('btnPreview').disabled == false) {
		var handSignedCount = 0; // 包含手写签名记录
		var unHandSignedCount = 0; // 包含未手写签名记录
		var list = document.getElementById('EPRList').all['ckbPrint'];
		if (list == undefined || list == "" || list.length == 0)
			return;
		var docEprNumList = "";

		if (list.length == undefined) {
			if (list.checked) {
				docEprNumList = docEprNumList + list.logDocID + "^"
						+ list.EPRNum + "#";
				if (isHandSigned(0)) {
					handSignedCount += 1;
				} else {
					unHandSignedCount += 1;
				}
			}
		}
		var listLength = list.length;
		for (var i = 0; i < listLength; i++) {
			if (list[i].checked) {
				docEprNumList = docEprNumList + list[i].logDocID + "^"
						+ list[i].EPRNum + "#";
				if (isHandSigned(i)) {
					handSignedCount += 1;
				} else {
					unHandSignedCount += 1;
				}
			}
		}
		// 选中列表
		docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

		if (docEprNumList == "") {
			alert('请先选中要操作的病历!');
			return;
		}
		var objUCPrint = document.getElementById('UCPrint');
		objUCPrint.EPRDocIDs = docEprNumList;
		objUCPrint.IsNewFramework = 'True';

		if (objUCPrint) {
			var strInstances = "";
			var strEpisodeIDs = "";

			var ckbPrintList = document.getElementById('EPRList').all['ckbPrint'];
			var instanceList = document.getElementById('EPRList').all['valueTr'];
			if (ckbPrintList == null) {
				alert("历次列表无记录!");
				return false;
			}
			if (ckbPrintList.length == undefined) {
				// 表示只有一条记录
				if (ckbPrintList.checked) {
					strInstances = instanceList.instanceid + ",";
					strEpisodeIDs = instanceList.episodeid + ",";
				}
			} else {
				// add by zhuj on 2009-9-12
				var firstCkbPrintDocID = '-1';
				var ckbPrintListLength = ckbPrintList.length;
				for (var i = 0; i < ckbPrintListLength; i++) {
					var curCkbPrint = ckbPrintList[i];
					if (curCkbPrint.checked) {
						if (firstCkbPrintDocID == '-1') {
							firstCkbPrintDocID = curCkbPrint.logDocID;
						}

						else if (firstCkbPrintDocID != curCkbPrint.logDocID) {
							alert('每次预览只能选择同一模板的数据!');
							return false;
						}
					} else {
						continue;
					}
				}

				var ckbPrintListLength = ckbPrintList.length;
				for (var i = 0; i < ckbPrintListLength; i++) {
					var curCkbPrint = ckbPrintList[i];
					if (curCkbPrint.checked) {
						var curInstanceID = instanceList[i].instanceid;
						if (curInstanceID) {
							strInstances += curInstanceID + ",";
							strEpisodeIDs += instanceList[i].episodeid + ",";
						}
					} else {
						continue;
					}
				}

			}

			if (!(strInstances == "")) {
				var strResult = strInstances.substr(0, strInstances.length - 1);
				var strEpisodeList = strEpisodeIDs.substr(0, strEpisodeIDs.length - 1);

				if (handSignedCount > 0 && unHandSignedCount > 0) {
					alert("不能同时选择患者已签名的记录和未签名的记录！");
					return false
				}

				if (unHandSignedCount > 0) {
					return objUCPrint.PreviewMultiple(_PatientID, _EpisodeID,
							strResult, _UserID, _PrtTemplateDocID, strEpisodeList, privacyLevel);
				} else {
					return objUCPrint.PreviewPDFMultiple(_EpisodeID,
							_PrtTemplateDocID, docEprNumList);
				}
			} else {
				alert("请选择需要预览的条目");
				return false
			}
		}
	}
}

// 预览
function exportRecord() {
	if (Ext.getCmp('btnExport').disabled == false) {
		var list = document.getElementById('EPRList').all['ckbPrint'];
		var docEprNumList = "";

		if (list.length == undefined) {
			if (list.checked) {
				docEprNumList = docEprNumList + list.logDocID + "^"
						+ list.EPRNum + "#"
			}
		}
		var listLength = list.length;
		for (var i = 0; i < listLength; i++) {
			if (list[i].checked) {
				docEprNumList = docEprNumList + list[i].logDocID + "^"
						+ list[i].EPRNum + "#"
			}
		}
		// 选中列表
		docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

		if (docEprNumList == "") {
			alert('请先选中要操作的病历!');
			return;
		}
		var objUCPrint = document.getElementById('UCPrint');
		objUCPrint.EPRDocIDs = docEprNumList;
		objUCPrint.IsNewFramework = 'True';

		if (objUCPrint) {
			var strInstances = "";
			var ckbPrintList = document.getElementById('EPRList').all['ckbPrint'];
			var instanceList = document.getElementById('EPRList').all['valueTr'];
			if (ckbPrintList == null) {
				alert("历次列表无记录!");
				return false;
			}
			if (ckbPrintList.length == undefined) {
				// 表示只有一条记录
				if (ckbPrintList.checked) {
					strInstances = instanceList.instanceid + ",";
				}
			} else {
				// add by zhuj on 2009-9-12
				var firstCkbPrintDocID = '-1';
				var ckbPrintListLength = ckbPrintList.length;
				for (var i = 0; i < ckbPrintListLength; i++) {
					var curCkbPrint = ckbPrintList[i];
					if (curCkbPrint.checked) {
						if (firstCkbPrintDocID == '-1') {
							firstCkbPrintDocID = curCkbPrint.logDocID;
						}

						else if (firstCkbPrintDocID != curCkbPrint.logDocID) {
							alert('每次预览只能选择同一模板的数据!');
							return false;
						}
					} else {
						continue;
					}
				}

				var ckbPrintListLength = ckbPrintList.length;
				for (var i = 0; i < ckbPrintListLength; i++) {
					var curCkbPrint = ckbPrintList[i];
					if (curCkbPrint.checked) {
						var curInstanceID = instanceList[i].instanceid;
						if (curInstanceID) {
							strInstances += curInstanceID + ",";
						}
					} else {
						continue;
					}
				}

			}

			if (!(strInstances == "")) {
				var strResult = strInstances.substr(0, strInstances.length - 1);

				var result = objUCPrint.ExportRecordMultiple(_PatientID,
						_EpisodeID, strResult, _UserID, _PrtTemplateDocID, privacyLevel);
				return result
			} else {
				alert("请选择需要预览的条目");
				return false
			}
		}

	}

}

// 打印
function print() {
	// edit by loo on 2010-7-28
	// 修改内容：增加了一个判断“打印”按钮是否可按
	// 修改原因：新增快捷键F9，为了不重新走一遍权限，直接增加按钮是否可按来代替权限判断。这个修改不影响原先电子病历程序
	if (Ext.getCmp('btnPrint').disabled == false) {
		var list = document.getElementById('EPRList').all['ckbPrint'];
		var docEprNumList = "";

		if (list.length == undefined) {
			if (list.checked) {
				docEprNumList = docEprNumList + list.logDocID + "^"
						+ list.EPRNum + "#"
			}
		}
		var listLength = list.length;
		for (var i = 0; i < listLength; i++) {
			if (list[i].checked) {
				docEprNumList = docEprNumList + list[i].logDocID + "^"
						+ list[i].EPRNum + "#"
			}
		}
		// 选中列表
		docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

		if (docEprNumList == "") {
			alert('请先选中要操作的病历!');
			return;
		}
		var objUCPrint = document.getElementById('UCPrint');
		objUCPrint.EPRDocIDs = docEprNumList;
		objUCPrint.IsNewFramework = 'True';
		var hasPrinted = PrintClickHandler();
		//刷新病历列表
		if (hasPrinted)
		{
			refresh();	
		} 

		// printLog(docEprNumList);
	}

}

var toLastPage="true";
// 刷新
function refresh() {
	ajaxAction();
}

// 选择模板
function sltTemplate() {
	var selectNode = parent.parent.selectParentNode;
	parent.parent.templateSelect(selectNode, _EpisodeID);
}

// 北京CA数字签名参数
var signArgs;

// 主任审核
function chiefCheck() {
	// debugger;
	var list = document.getElementById('EPRList').all['ckbPrint'];

	var docEprNumList = "";
	var instanceList = document.getElementById('EPRList').all['valueTr'];
	var curInstanceID = "";

	if (null == list) {
		alert("历次列表无记录!");
		return;
	}
	if (list.length == undefined) {
		if (list.checked) {
			if (list.statusCode != 'commited'
					&& list.statusCode != 'attendingChecked') {
				alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
				return;
			}
			docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum
					+ "#";
			curInstanceID = instanceList.instanceid;
		}
	}
	var listLength = list.length;
	for (var i = 0; i < listLength; i++) {
		if (list[i].checked) {
			if (list[i].statusCode != 'commited'
					&& list[i].statusCode != 'attendingChecked') {
				alert('只能审核当前状态为"提交"或"主治医生审核"的病历!');
				return;
			}
		}
	}

	for (var i = 0; i < listLength; i++) {
		if (list[i].checked) {
			docEprNumList = docEprNumList + list[i].logDocID + "^"
					+ list[i].EPRNum + "#";
			curInstanceID = instanceList[i].instanceid;
		}
	}

	// 选中列表
	docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

	if (docEprNumList == "") {
		alert('请先选中要操作的病历!');
		return;
	}
	var UsrLevel = "Chief";
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey())
			return;
		/*if (docEprNumList.split("#").length > 1) {
			alert("每次只能审核一条记录!");
			return;
		}*/
		signArgs = new Object();
		signArgs["episodeID"] = _EpisodeID;
		signArgs["printDocID"] = _PrtTemplateDocID;
		signArgs["instanceIDs"] = curInstanceID;
		signArgs["EPRDocIDs"] = docEprNumList;
		signArgs["EPRNum"] = "";
		signArgs["userLevel"] = UsrLevel;
		signArgs["action"] = "updateMultiple";
		var result = ShowCAForm()

		if (result) {
			invokeMultiPreviewList(_PatientID, _EpisodeID, _UserID,
					docEprNumList);
		}
	} else {
		eprAudit(UsrLevel, docEprNumList);
	}

}

// 主治审核
function attendingCheck() {
	// debugger;
	var list = document.getElementById('EPRList').all['ckbPrint'];

	var docEprNumList = "";
	var instanceList = document.getElementById('EPRList').all['valueTr'];
	var curInstanceID = "";

	if (null == list) {
		alert("历次列表无记录!");
		return;
	}
	if (list.length == undefined) {
		if (list.checked) {
			if (list.statusCode != 'commited') {
				alert('只能审核当前状态为"提交"的病历!');
				return;
			}
			docEprNumList = docEprNumList + list.logDocID + "^" + list.EPRNum
					+ "#";
			curInstanceID = instanceList.instanceid;
		}
	}

	var listLength = list.length;
	for (var i = 0; i < listLength; i++) {
		if (list[i].checked) {
			if (list[i].statusCode != 'commited') {
				alert('只能审核当前状态为"提交"的病历!');
				return;
			}
		}
	}

	for (var i = 0; i < listLength; i++) {
		if (list[i].checked) {
			docEprNumList = docEprNumList + list[i].logDocID + "^"
					+ list[i].EPRNum + "#";
			curInstanceID = instanceList[i].instanceid;
		}
	}

	// 选中列表
	docEprNumList = docEprNumList.substring(0, docEprNumList.length - 1);

	if (docEprNumList == "") {
		alert('请先选中要操作的病历!');
		return;
	}
	var UsrLevel = 'Attending';
	if (parent.parent.IsCAOn()) {
		if (!parent.parent.ExistKey())
			return;
		/*if (docEprNumList.split("#").length > 1) {
			alert("每次只能审核一条记录!");
			return;
		}*/
		signArgs = new Object();
		signArgs["episodeID"] = _EpisodeID;
		signArgs["printDocID"] = _PrtTemplateDocID;
		signArgs["instanceIDs"] = curInstanceID;
		signArgs["EPRDocIDs"] = docEprNumList;
		signArgs["EPRNum"] = "";
		signArgs["userLevel"] = UsrLevel;
		signArgs["action"] = "updateMultiple";
		var result = ShowCAForm()

		if (result) {
			invokeMultiPreviewList(_PatientID, _EpisodeID, _UserID,
					docEprNumList);
		}
	} else {
		eprAudit(UsrLevel, docEprNumList);
	}
}

// 日志记录部分--------------------------------------
// /add by zhuj on 2009-7-28
// /打印
function printLog(docEprNumList) {
	Ext.Ajax.request({
				url : '../web.eprajax.logs.updateMultiple.cls',
				timeout : parent.parent.timedOut,
				params : {
					EpisodeID : _EpisodeID,
					EPRDocIDs : docEprNumList,
					action : 'print'
				},
				success : function(response, opts) {
					var obj = response.responseText;
					if (obj == "success") {
						refresh();
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

function setPower() {
	initPower(); // add by zhuj on 2009-12-9

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

	/*
	 * if(canView == "1" && canCommit == "1") {
	 * Ext.getCmp('btnCommit').enable()} else {
	 * Ext.getCmp('btnCommit').disable()}
	 */

	if (canView == "1" && canSwitch == "1") {
		Ext.getCmp('btnSlttemplate').enable()
	} else {
		Ext.getCmp('btnSlttemplate').disable()
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

	if (canNew == "1") {
		Ext.getCmp('btnNew').enable()
	} else {
		Ext.getCmp('btnNew').disable()
	}
	// test
	// Ext.getCmp('btnChiefCheck').enable()
	// Ext.getCmp('btnAttendingCheck').enable()
}

function ShowCAForm() {
	return window
			.showModalDialog(
					"../csp/dhc.epr.ca.audit.csp",
					self,
					"dialogWidth:250px;dialogHeight:160px;toolbar=no;menubar:no;scrollbars:no;resizable:no;location:no;status:no;help:no;fullscreen=no");
}

// 生成病历预览图片 -- add on 2012-12-11 by houj
function invokeMultiPreviewList(pateintID, episodeID, userID,
		eprDocIDAndEPRNumList) {
	var objUCPrint = document.getElementById('UCPrint');
	if (objUCPrint) {
		objUCPrint.InvokeMultiPreviewService(pateintID, episodeID, userID,
				eprDocIDAndEPRNumList);
	}
}

// 分页和页面操作部分-----------------
// add by yang 2012-3-27
// 首页
function firstPage() {
	var currentPageDom = Ext.getCmp('inputPage');
	currentPageDom.setValue(1);
	ajaxAction("false");
}

// 上一页
function previousPage() {
	var currentPageDom = Ext.getCmp('inputPage');
	var currentPage = currentPageDom.getValue();
	var lastPageDom = Ext.getCmp('lblTotalPages');
	var lastPage = lastPageDom.getText();

	if (typeof(currentPage) == 'undefined' || currentPage == null) {
		currentPageDom.setValue(1);
	} else if (currentPage == 1 || currentPage == 2) {
		currentPageDom.setValue(1);
	} else if (currentPage <= lastPage && currentPage > 2) {
		currentPageDom.setValue(currentPage - 1);
	} else {
		currentPageDom.setValue(lastPage);
	}
	ajaxAction("false");
}

// 页面跳转输入框
function redirectPage() {
	var currentPageDom = Ext.getCmp('inputPage');
	var currentPage = currentPageDom.getValue();
	var lastPageDom = Ext.getCmp('lblTotalPages');
	var lastPage = lastPageDom.getText();
	if (currentPage == 1) {
		currentPageDom.setValue(1);
	} else if (currentPage < lastPage && currentPage > 1) {
		currentPageDom.setValue(currentPage);
	} else if (currentPage >= lastPage) {
		currentPageDom.setValue(lastPage);
	} else {
		currentPageDom.setValue(lastPage);
	}
	ajaxAction("false");
}

// 下一页
function nextPage() {
	var currentPageDom = Ext.getCmp('inputPage');
	var currentPage = currentPageDom.getValue();
	var lastPageDom = Ext.getCmp('lblTotalPages');
	var lastPage = lastPageDom.getText();
	var currentPageDom = Ext.getCmp('inputPage');
	if (currentPage == 1) {
		if (Ext.getCmp('lblTotalPages').getText() > 1) {
			currentPageDom.setValue(2);
		} else {
			currentPageDom.setValue(1);
		}
	} else if (currentPage < (lastPage - 1) && currentPage > 1) {
		currentPageDom.setValue(currentPage + 1);
	} else if (currentPage == (lastPage - 1)) {
		currentPageDom.setValue(lastPage);
	} else {
		currentPageDom.setValue(lastPage);
	}
	ajaxAction("false");
}

// 末页
function lastPage() {
	var lastPageDom = Ext.getCmp('lblTotalPages');
	var lastPage = lastPageDom.getText();
	var currentPageDom = Ext.getCmp('inputPage');

	currentPageDom.setValue(lastPage);
	ajaxAction("false");
}

function isHandSigned(idx) {
	try {
	//debugger;
	    if (document.getElementById('Signer' + idx) == null) return false;
		return "患者" == document.getElementById('Signer' + idx).innerHTML
				.split('/')[1];
	} catch (e) {
		alert(e.message);
		return false;
	}
}
