/**
 * FileName: dhcbill.ipbill.checkadmfee.js
 * Author: ZhYW, yangchong
 * Date: 2018-06-30
 * Description: 住院费用核查
 */

$(function () {
	initQueryMenu();
	initPatList();
	initPointList();
	initDtlList();
	if (GV.EpisodeID) {
		getPatInfo();
	}else {
		loadPatList();
	}
});

function initQueryMenu() {	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//病案号回车查询事件
	$("#medicareNo").keydown(function (e) {
		medicareNoKeydown(e);
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			findClick();
		}
	});
	
	$HUI.linkbutton("#btnOneKeyCheck", {
		onClick: function () {
			oneKeyCheckClick();
		}
	});
	
	$HUI.linkbutton("#btn-audit", {
		onClick: function () {
			auditClick();
		}
	});
	
	$HUI.linkbutton("#btn-cancel", {
		onClick: function () {
			cancelClick();
		}
	});
	
	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$("#more-container").click(function () {
		var t = $(this);
		var ui = (HISUIStyleCode == "lite") ? "b" : "w";  //+2022-07-08 ZhYW 根据HISUI风格显示上下箭头图标
		if (t.find(".arrows-" + ui + "-text").text() == $g("更多")) {
			t.find(".arrows-" + ui + "-text").text($g("收起"));
			t.find(".spread-" + ui + "-down").removeClass("spread-" + ui + "-down").addClass("retract-" + ui + "-up");
			$("tr.display-more-td").slideDown("normal", setHeight(140));
		} else {
			t.find(".arrows-" + ui + "-text").text($g("更多"));
			t.find(".retract-" + ui + "-up").removeClass("retract-" + ui + "-up").addClass("spread-" + ui + "-down");
			$("tr.display-more-td").slideUp("fast", setHeight(-140));
		}
	});
	
	$HUI.combobox("#dept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		disabled: (["L", "W"].indexOf(CV.ViewType) != -1),
		value: (CV.ViewType == "L") ? PUBLIC_CONSTANT.SESSION.CTLOCID : "",
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		},
		onChange: function (newValue, oldValue) {
			var url = $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QryLocLinkWard&ResultSetType=array&locId=" + (newValue || "");
			$("#ward").combobox("clear").combobox("reload", url);
		}
	});
	
	$("#ward").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'id',
		textField: 'text',
		disabled: (CV.ViewType == "W"),
		data: (CV.ViewType == "W") ? [{id: PUBLIC_CONSTANT.SESSION.WARDID, text: session['LOGON.CTLOCDESC'], selected: true}] : [],
	});
	
	$("#insType").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
	
	$HUI.combobox("#isAudit", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '', text: $g('全部')},
			   {value: 'Y', text: $g('已审核')},
			   {value: 'N', text: $g('未审核')}
		],
		onSelect: function (rec) {
			var row = GV.PatList.getSelected();
			var adm = row ? row.id : "";
			loadPointList(adm);
			
			var row = GV.MoniList.getSelected();
			adm = row ? row.TAdm : adm;
			var MPCRowID = row ? row.TMPCRowID : "";
			loadDtlList(adm, MPCRowID);
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("medicareNo", "");
		getPatInfo();
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("patientNo", "");
		getPatInfo();
	}
}

function initPatList() {
	var selectRowIndex = undefined;
	GV.PatList = $HUI.datagrid("#patList", {
		fit: true,
		border: false,
		singleSelect: true,
		showHeader: false,
		rownumbers: false,
		loadMsg: '',
		pageSize: 999999999,
		columns: [[{field: 'patName', width: 110},
				   {field: 'patNo', width: 110}
			]],
		onLoadSuccess: function (data) {
			selectRowIndex = undefined;
			GV.PatList.getPanel().addClass("lines-bottom");
			$(".layout:eq(0)").layout("panel", "west").panel({
				title: $g("患者列表 ") + "(" + data.rows.length + $g("人") + ")"
			});
			if ((data.rows.length == 1) && GV.EpisodeID) {
				GV.EpisodeID = "";
				GV.PatList.selectRow(0);   //设置选中第一行
			}
		},
		onSelect: function (index, row) {
			if (selectRowIndex == index) {
				return;
			}
			selectRowIndex = index;
			setTimeout(selectPatListRow(row.id), 200);
		}
	});
	GV.PatList.getPanel().addClass("lines-no").find(".datagrid-view2 > .datagrid-header").removeClass("datagrid-header");
}

function initPointList() {
	GV.MoniList = $HUI.datagrid("#moniList", {
		fit: true,
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		toolbar: '#pointToolBar',
		singleSelect: true,
		fitColumns: true,
		pagination: false,
		rownumbers: true,
		pageSize: 999999,
		className: "web.DHCIPBillCheckAdmCost",
		queryName: "FindCheckFee",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TAdm", "TMPCRowID", "TMPCCode"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 200;
				}
			}
		},
		onSelect: function (index, row) {
			loadDtlList(row.TAdm, row.TMPCRowID);
		}
	});
}

function loadPointList(adm) {
	var queryParams = {
		ClassName: "web.DHCIPBillCheckAdmCost",
		QueryName: "FindCheckFee",
		adm: adm,
		pid: CV.PID,
		isAudit: getValueById("isAudit"),
		roleLevel: CV.RoleLevel,
		rows: 999999
	};
	loadDataGridStore("moniList", queryParams);
}

function initDtlList() {
	GV.DtlList = $HUI.datagrid("#dtlList", {
		fit: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		titleNoWrap: false,
		view: scrollview,  //滚动加载
		pageSize: 500,
		rownumbers: true,
		toolbar: [],
		frozenColumns: [[{field: 'ck', checkbox: true},
						 {title: '监控点描述', field: 'TMPCDesc', width: 300,
						 	formatter: function (value, row, index) {
								if (row.TMPCReviewed != "Y") {
									return "<a onmouseover='showCantReviewReason(this, " + JSON.stringify(row) + ")' style='text-decoration:none;color:#000000;'>" + value + "</a>";
								}
								return value;
						  	},
							styler: function (value, row, index) {
								return {class: ((row.TAuditId) ? 'cell-audited' : 'cell-unAudited')};
							}
				   		 }
			]],
		className: "web.DHCIPBillCheckAdmCost",
		queryName: "FindCheckFeeDtl",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TMPCDesc", "TAuditDate", "TMPCReviewed", "TReviewDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TAdm", "TMPCRowID", "TAuditId", "TAuditLevel", "TTypeCode", "TTypeDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				//配置的是一级审核时，不显示二级审核人、时间
				if (CV.AuditLevelCfg == 1) {
					if ($.inArray(cm[i].field, ["TReviewUser", "TReviewTime"]) != -1) {
						cm.splice(i, 1);
						continue;
					}
				}else {
					if ($.inArray(cm[i].field, ["TAuditUser", "TAuditTime"]) != -1) {
						cm[i].title = "一级" + cm[i].title;
					}
				}
				if (cm[i].field == "TAuditTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.TAuditDate + " " + value;
					};
				}
				if (cm[i].field == "TReviewTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.TReviewDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TArcimDesc") {
						cm[i].width = 200;
					}
					if ($.inArray(cm[i].field, ["TAuditTime", "TReviewTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		onLoadSuccess: function(data) {
			GV.DtlList.clearChecked();
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if (row.TMPCReviewed != "Y") {
					hasDisabledRow = true;
					GV.DtlList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
				}
			});
			//有disabled行时，表头也disabled
			GV.DtlList.getPanel().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		}
	});
}

function loadDtlList(adm, MPCRowID) {
	var queryParams = {
		ClassName: "web.DHCIPBillCheckAdmCost",
		QueryName: "FindCheckFeeDtl",
		adm: adm,
		pid: CV.PID,
		MPCRowID: MPCRowID,
		isAudit: getValueById("isAudit"),
		roleLevel: CV.RoleLevel
	};
	loadDataGridStore("dtlList", queryParams);
}

function getPatInfo() {
	var patNo = getValueById("patientNo");
	var medicare = getValueById("medicareNo");
	if (!patNo && !medicare && !GV.EpisodeID) {
		return;
	}
	clearPatInfo();
	$.cm({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "GetPatientInfo",
		adm: GV.EpisodeID,
		patientNo: patNo,
		medicareNo: medicare,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (json) {
		if (!json) {
			return;
		}
		setValueById("patientNo", json.patientNo);
		setValueById("medicareNo", json.medicareNo);
		GV.EpisodeID = json.episodeId;
		loadPatList();
	});
}

function clearPatInfo() {
	setValueById("patientNo", "");
	setValueById("medicareNo", "");
	//清除患者就诊信息banner
	$("#ban-sex").removeClass();
	$(".patientInfo span[id]").text("");
}

function selectPatListRow(adm) {
	$.cm({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "GetAdmInfo",
		adm: adm
	}, function (json) {
		if (!json) {
			return;
		}
		setValueById("patientNo", json.patientNo);
		$("#ban-Name").text(json.patName);
		$("#ban-patientNo").text(json.patientNo);
		$("#ban-medicareNo").text(json.medicareNo);
		$("#ban-bed").text(json.bed);
		$("#ban-ward").text(json.ward);
		$("#ban-dept").text(json.dept);
		$("#ban-sex").removeClass("unman man woman").addClass(json.sexIconCls);
		
		getIPBillCheckFee(adm);
	});
}

function getIPBillCheckFee(adm) {
	$.m({ClassName: "web.DHCIPBillCheckAdmCost", MethodName: "GetIPBillCheckFeeData", wantreturnval: 0, adm: adm, pid: CV.PID}, false);
	loadPointList(adm);
	loadDtlList(adm, "");
}

/**
* 查询
*/
function findClick() {
	if (getValueById("patientNo") != "") {
		setValueById("medicareNo", "");
		getPatInfo();
		return;
	}
	
	if (getValueById("medicareNo") != "") {
		setValueById("patientNo", "");
		getPatInfo();
		return;
	}

	loadPatList();
}

function loadPatList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCheckAdmCost",
		QueryName: "FindCurInPatient",
		episodeIDStr: GV.EpisodeID,
		deptId: getValueById("dept") || "",
		wardId: getValueById("ward") || "",
		insTypeId: getValueById("insType") || "",
		oneKeyCheckFlag: getValueById("oneKeyCheck"),
		roleLevel: CV.RoleLevel,
		sessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("patList", queryParams);
}

function clearClick() {
	GV.EpisodeID = "";
	$(".combobox-f:not(#isAudit)").combobox("clear");
	setValueById("isAudit", "");
	if (CV.ViewType == "L") {
		$("#dept").combobox("setValue", PUBLIC_CONSTANT.SESSION.CTLOCID);
	}
	if (CV.ViewType == "W") {
		var text = $.m({ClassName: "User.CTLoc", MethodName: "GetTranByDesc", Prop: "CTLOCDesc", Desc: session['LOGON.CTLOCDESC'], LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
		var data = [{id: PUBLIC_CONSTANT.SESSION.WARDID, text: text, selected: true}];
		$("#ward").combobox("loadData", data);
	}
	clearPatInfo();
	GV.MoniList.loadData({total: 0,	rows: []});
	//GV.DtlList.loadData({total: 0, rows: []});
	loadDtlList("", "");
	loadPatList();
}

function auditClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var rows = GV.DtlList.getChecked();
			auditAry = rows.filter(function(row) {
				return (CV.RoleLevel == (+row.TAuditLevel + 1));
			}).map(function(row) {
				return row.TAdm + "^" + row.TMPCRowID + "^" + row.TTypeCode + "^" + row.TTypeDR + "^" + row.TAuditId + "^" + CV.RoleLevel;
			});
			if (auditAry.length == 0) {
				var msg = "请选择待审核的明细进行审核";
				if (CV.RoleLevel > 1) {
					if ((rows.length > 0) && (+CV.RoleLevel > +rows[0].TAuditLevel)) {
						msg = "请先让一级审核人审核";
					}
				}
				$.messager.popover({msg: msg, type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认审核？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _audit = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCIPBillCheckAdmCost",
				MethodName: "Audit",
				auditList: auditAry,
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "审核成功", type: "success"});					
					return resolve();
				}
				$.messager.popover({msg: "审核失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		GV.DtlList.reload();
	};
	
	if ($("#btn-audit").linkbutton("options").disabled) {
		return;
	}
	$("#btn-audit").linkbutton("disable");
	
	var auditAry = [];
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_audit)
		.then(function() {
			_success();
			$("#btn-audit").linkbutton("enable");
		}, function() {
			$("#btn-audit").linkbutton("enable");
		});
}

function cancelClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var rows = GV.DtlList.getChecked();
			auditAry = rows.filter(function(row) {
				return (CV.RoleLevel == row.TAuditLevel);
			}).map(function(row) {
				return row.TAuditId + "^" + CV.RoleLevel;
			});
			if (auditAry.length == 0) {
				$.messager.popover({msg: "请选择需要撤销审核的明细", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销审核？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.DHCIPBillCheckAdmCost",
				MethodName: "CancelAudit",
				auditList: auditAry,
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "撤销成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "撤销失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		GV.DtlList.reload();
	};
	
	if ($("#btn-cancel").linkbutton("options").disabled) {
		return;
	}
	$("#btn-cancel").linkbutton("disable");

	var auditAry = [];
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$("#btn-cancel").linkbutton("enable");
		}, function() {
			$("#btn-cancel").linkbutton("enable");
		});
}

/**
 * 一键核查
 */
function oneKeyCheckClick() {
	if (["L", "W"].indexOf(CV.ViewType) == -1) {
		$(".combobox-f:not(#isAudit)").combobox("clear").combobox("reload");
	}
	setValueById("isAudit", "");
	setValueById("oneKeyCheck", "Y");
	clearPatInfo();
	GV.MoniList.loadData({total: 0,	rows: []});
	GV.DtlList.loadData({total: 0, rows: []});
	loadPatList();
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} val
 * @author ZhYW
 */
function setHeight(num) {
	var l = $(".layout:eq(1)");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.panel("panel").outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (num > 0) {
		$("tr.display-more-td").show();
	} else {
		$("tr.display-more-td").hide();
	}
	var c = l.layout("panel", "center");
	var ch = parseInt(c.panel("panel").outerHeight()) - parseInt(num);
	c.panel("resize", {
		height: ch,
		top: nh
	});
}

/**
* 泡芙提示不可审核原因
*/
function showCantReviewReason($this, row) {
	if (row.TAuditId > 0) {
		return;
	}
	if (row.TMPCReviewed == "Y") {
		return;   //做了直接退费审核的不显示不可退费原因
	}
	$($this).popover({
		trigger: 'hover',
		content: $g("监控点") + "<font color=\"#FF0000\">" + row.TMPCDesc + "</font>" + "配置不能审核"
	}).popover("show");
}

/**
* 离开页面时清除临时global
*/
$(window).unload(function() {
	//调用ajax请求会被取消或不成功，改为如下方式HTTP POST
	delSvrTMP4Beacon();
});

/**
* 离开页面时清除临时global
* 新的chrome下，用visibilitychange事件替换unload事件
*/
document.addEventListener("visibilitychange", function() {
	if (document.hidden) {
		//调用ajax请求会被取消或不成功，改为如下方式HTTP POST
		delSvrTMP4Beacon();
	}
});

/**
* 清除临时global
*/
function delSvrTMP4Beacon() {
	$.cm({ClassName: "web.DHCIPBillCheckAdmCost", MethodName: "KillTMP", type: "BEACON", pid: CV.PID, wantreturnval: 0});
}