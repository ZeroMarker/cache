/**
 * FileName: dhcbill.ipbill.checkadmfee.js
 * Anchor: ZhYW, yangchong
 * Date: 2018-06-30
 * Description: 住院费用核查
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
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

	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			findClick();
		}
	});
	
	$HUI.linkbutton("#btnOneKeyCheck", {
		onClick: function () {
			oneKeyCheckClick();
		}
	});
	
	$HUI.linkbutton("#btnAudit", {
		onClick: function () {
			auditClick();
		}
	});
	
	$HUI.linkbutton("#btnCancel", {
		onClick: function () {
			cancelClick();
		}
	});
	
	$HUI.linkbutton("#btnClear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$("#more-container").click(function () {
		var t = $(this);
		if (t.find(".arrows-w-text").text() == "更多") {
			t.find(".arrows-w-text").text("收起");
			t.find(".spread-w-down").removeClass("spread-w-down").addClass("retract-w-up");
			$("tr.display-more-td").slideDown("normal", setHeight(140));
		} else {
			t.find(".arrows-w-text").text("更多");
			t.find(".retract-w-up").removeClass("retract-w-up").addClass("spread-w-down");
			$("tr.display-more-td").slideUp("fast", setHeight(-140));
		}
	});
	
	$HUI.combobox("#dept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillCheckAdmCost&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function (rec) {
			var url = $URL + '?ClassName=web.DHCIPBillCheckAdmCost&QueryName=FindWard&ResultSetType=array';
			$('#ward').combobox('clear').combobox('reload', url);
		},
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				$('#ward').combobox('clear').combobox('loadData', []);
			}
		}
	});
	
	$("#ward").combobox({
		panelHeight: 150,
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.deptId = getValueById("dept");
		}
	});
	
	$("#admReason").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillCheckAdmCost&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	$HUI.combobox("#isAudit", {
		panelHeight: 'auto',
		editable: false,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		data: [{id: '', text: '全部'},
			   {id: 'Y', text: '已审核'},
			   {id: 'N', text: '未审核'}
		],
		onSelect: function (record) {
			var row = $("#patList").datagrid("getSelected");
			var adm = row ? row.id : "";
			loadPointList(adm);
			
			var row = $("#moniList").datagrid("getSelected");
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
	$HUI.datagrid("#patList", {
		fit: true,
		border: false,
		singleSelect: true,
		showHeader: false,
		rownumbers: false,
		loadMsg: '',
		pageSize: 999999999,
		columns: [[{field: 'patName', width: 100},
				   {field: 'patNO', width: 115}
			]],
		onLoadSuccess: function (data) {
			selectRowIndex = undefined;
			$("#patList").datagrid("getPanel").addClass("lines-bottom");
			$("#head-menu").layout("panel", "north").panel({
				title: "患者列表 ( " + data.rows.length + "人 )"
			});
			if ((data.rows.length == 1) && GV.EpisodeID) {
				GV.EpisodeID = "";
				$("#patList").datagrid("selectRow", 0); //设置选中第一行
			}
		},
		onSelect: function (index, row) {
			if (selectRowIndex == index) {
				return;
			}
			selectRowIndex = index;
			var adm = row.id;
			setTimeout(selectPatListRow(adm), 200);
		}
	});
	$("#patList").datagrid("getPanel").addClass("lines-no").find(".datagrid-view2 > .datagrid-header").removeClass("datagrid-header");
}

function initPointList() {
	$HUI.datagrid("#moniList", {
		fit: true,
		striped: true,
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		toolbar: '#pointToolBar',
		singleSelect: true,
		fitColumns: true,
		pagination: false,
		rownumbers: true,
		pageSize: 999999,
		columns: [[{title: 'TAdm', field: 'TAdm', hidden: true},
				   {title: 'TMPCRowID', field: 'TMPCRowID', hidden: true},
				   {title: 'TMPCCode', field: 'TMPCCode', hidden: true},
				   {title: '监控点描述', field: 'TMPCDesc', width: 200},
				   {title: '核查结果', field: 'TErrMsg', width: 300}
			]],
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
		job: GV.Job,
		isAudit: getValueById("isAudit"),
		rows: 999999
	};
	loadDataGridStore("moniList", queryParams);
}

function initDtlList() {
	$HUI.datagrid("#dtlList", {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		pageSize: 999999999,
		rownumbers: true,
		toolbar: [],
		columns: [[{field: 'ck', checkbox: true},
			       {title: 'TAdm', field: 'TAdm', hidden: true},
				   {title: 'TMPCRowID', field: 'TMPCRowID', hidden: true},
				   {title: '监控点描述', field: 'TMPCDesc', width: 410,
					styler: function (value, row, index) {
						if (row.TAuditFlag == "Y") {
							return {class: 'cell-audited'};
						} else {
							return {class: 'cell-unAudited'};
						}
					}
				   },
				   {title: '医嘱', field: 'TArcimDesc', width: 200},
				   {title: '医嘱子类', field: 'TItemCatDesc', width: 150},
				   {title: '医嘱大类', field: 'TOECCatDesc', width: 150},
				   {title: '要求执行时间', field: 'TOEEXDatTime', width: 150},
				   {title: '医嘱状态', field: 'TOrdStatDesc', width: 100},
				   {title: '执行记录状态', field: 'TOEEXStatDesc', width: 100},
				   {title: '计费状态', field: 'TBilledStatus', width: 100},
				   {title: '单价', field: 'TUnitPrice', align: 'right', width: 100},
				   {title: '数量', field: 'TTotalQty', width: 100},
				   {title: '金额', field: 'TTotalAmount', align: 'right', width: 100},
				   {title: '实际发药数量', field: 'TDspTotalQty', width: 150},
				   {title: '开医嘱医生', field: 'TOrdDocName', width: 100},
				   {title: '接收科室', field: 'TRecDeptDesc', width: 180},
				   {title: 'TAuditFlag', field: 'TAuditFlag', hidden: true},
				   {title: 'TTypeCode', field: 'TTypeCode', hidden: true},
				   {title: 'TTypeDR', field: 'TTypeDR', hidden: true}
			]],
		onLoadSuccess: function(data) {
			$("#dtlList").datagrid("clearChecked");
		}
	});
}

function loadDtlList(adm, MPCRowID) {
	var queryParams = {
		ClassName: "web.DHCIPBillCheckAdmCost",
		QueryName: "FindCheckFeeDtl",
		adm: adm,
		job: GV.Job,
		MPCRowID: MPCRowID,
		isAudit: getValueById("isAudit"),
		rows: 9999999
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
	$.m({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "GetPatientInfo",
		adm: GV.EpisodeID,
		patNo: patNo,
		medicare: medicare,
		sessionStr: getSessionStr()
	}, function (rtn) {
		if (rtn) {
			var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
			setValueById("patientNo", myAry[1]);
			setValueById("medicareNo", myAry[3]);
			GV.EpisodeID = myAry[4];
			loadPatList();
		}
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
	$.m({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "GetAdmInfo",
		adm: adm
	}, function (rtn) {
		if (rtn) {
			var myAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
			setValueById("patientNo", myAry[1]);
			$("#ban-Name").text(myAry[2]);
			$("#ban-patientNo").text(myAry[1]);
			$("#ban-medicareNo").text(myAry[3]);
			$("#ban-bed").text(myAry[4]);
			$("#ban-ward").text(myAry[7]);
			$("#ban-dept").text(myAry[12]);
			switch(myAry[11]) {
			case "男":
				$("#ban-sex").removeClass("unman man woman").addClass("man");
				break;
			case "女":
				$("#ban-sex").removeClass("unman man woman").addClass("woman");
				break;
			default:
				$("#ban-sex").removeClass("unman man woman").addClass("unman");
			}
			getIPBillCheckFee(adm);
		}
	});
}

function getIPBillCheckFee(adm) {
	$.m({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "GetIPBillCheckFeeData",
		adm: adm,
		job: GV.Job
	}, function (rtn) {
		loadPointList(adm);
		loadDtlList(adm, "");
	});
}

/**
* 查询
*/
function findClick() {
	if (getValueById("patientNo") != "") {
		setValueById("medicareNo", "");
		getPatInfo();
	} else if (getValueById("medicareNo") != "") {
		setValueById("patientNo", "");
		getPatInfo();
	}else {
		loadPatList();
	}
}

function loadPatList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCheckAdmCost",
		QueryName: "FindCurInPatient",
		episodeIDStr: GV.EpisodeID,
		deptID: getValueById("dept") || "",
		wardID: getValueById("ward") || "",
		admReasonID: getValueById("admReason") || "",
		oneKeyCheckFlag: getValueById("oneKeyCheck"),
		sessionStr: getSessionStr(),
		rows: 9999999
	};
	loadDataGridStore("patList", queryParams);
}

function clearClick() {
	GV.EpisodeID = "";
	$(".combobox-f:not(#isAudit)").combobox("clear");
	setValueById("isAudit", "");
	clearPatInfo();
	$("#moniList").datagrid("loadData", {
		total: 0,
		rows: []
	});
	$("#dtlList").datagrid("loadData", {
		total: 0,
		rows: []
	});
	loadPatList();
}

function auditClick() {
	var myAry = [];
	var tmpStr = "";
	$.each($("#dtlList").datagrid("getChecked"), function(index, row) {
		if (row.TAuditFlag == "Y") {
			return true;
		}
		tmpStr = row.TAdm + "^" + row.TMPCRowID + "^" + row.TTypeCode + "^" + row.TTypeDR;
		myAry.push(tmpStr);
	});
	if (myAry.length == 0) {
		$.messager.alert("提示", "请选择未审核的明细进行审核", "info");
		return;
	}
	
	$.m({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "Audit",
		auditList: myAry,
		guser: PUBLIC_CONSTANT.SESSION.USERID
	}, function (rtn) {
		if (rtn == "0") {
			$.messager.alert("提示", "审核成功", "success", function() {
				$("#dtlList").datagrid("reload");
			});
		} else {
			$.messager.alert("提示", "审核失败，错误代码：" + rtn, "error");
		}
	});
}

function cancelClick() {
	var myAry = [];
	var tmpStr = "";
	$.each($("#dtlList").datagrid("getChecked"), function(index, row) {
		if (row.TAuditFlag != "Y") {
			return true;
		}
		tmpStr = row.TAdm + "^" + row.TMPCRowID + "^" + row.TTypeCode + "^" + row.TTypeDR;
		myAry.push(tmpStr);
	});
	if (myAry.length == 0) {
		$.messager.alert("提示", "请选择需要撤销审核的明细", "info");
		return;
	}

	$.m({
		ClassName: "web.DHCIPBillCheckAdmCost",
		MethodName: "CancelAudit",
		cancelList: myAry,
		guser: PUBLIC_CONSTANT.SESSION.USERID
	}, function (rtn) {
		if (rtn == "0") {
			$.messager.alert("提示", "撤销成功", "success", function() {
				$("#dtlList").datagrid("reload");
			});
		} else {
			$.messager.alert("提示", "撤销失败，错误代码：" + rtn, "error");
		}		
	});
}

/**
 * 一键核查
 */
function oneKeyCheckClick() {
	$(".combobox-f:not(#isAudit)").combobox("clear").combobox("reload");
	setValueById("isAudit", "");
	setValueById("oneKeyCheck", "Y");
	clearPatInfo();
	$("#moniList").datagrid("loadData", {
		total: 0,
		rows: []
	});
	$("#dtlList").datagrid("loadData", {
		total: 0,
		rows: []
	});
	loadPatList();
}

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} val
 * @author ZhYW
 */
function setHeight(num) {
	var l = $("#head-menu");
	var n = l.layout("panel", "north");
	var nh = parseInt(n.panel("panel").outerHeight()) + parseInt(num);
	n.panel("resize", {
		height: nh
	});
	if (+num > 0) {
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
