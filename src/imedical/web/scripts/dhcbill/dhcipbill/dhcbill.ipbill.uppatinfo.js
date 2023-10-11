/**
 * FileName: dhcbill.ipbill.uppatinfo.js
 * Author: ZhYW
 * Date: 2019-04-14
 * Description: 就诊信息修改查询
 */

$(function () {
	initQueryMenu();
	initUpdateList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadUpdateList();
		}
	});
	
	//登记号
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//操作员
	$("#guser").combobox({
		panelHeight: 150,
		method: 'GET',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QrySSUser&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
		}
	});
	
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		striped: true,
		idField: "admId",
		textField: "admNo",
		columns: [[{field: "admNo", title: "就诊号", width: 100},
				   {field: 'admDate', title: '就诊日期', width: 150,
						formatter: function (value, row, index) {
							if (value) {
								return value + " " + row.admTime;
							}
						}
					},
					{field: 'admDept', title: '就诊科室', width: 100},
					{field: 'admWard', title: '就诊病区', width: 120},
					{field: 'admBed', title: '床号', width: 60},
					{field: 'admStatus', title: '就诊状态', width: 80},
					{field: 'admId', title: '就诊ID', width: 80}
			]]
	});
}

function initUpdateList() {
	$HUI.datagrid("#updateList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCIPBillReg",
		queryName: "FindUpPatList",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tadmdate", "Tdischdate", "Tupdate", "Tadmward"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "Tadmdep") {
					cm[i].title = "科室病区";
					cm[i].width = 160;
					cm[i].showTip = true;
					cm[i].tipWidth = 200;
					cm[i].formatter = function (value, row, index) {
						return value + " " + row.Tadmward;
					}
				}
				if (cm[i].field == "Tadmtime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tadmdate + " " + value;
					}
				}
				if (cm[i].field == "Tdischtime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tdischdate + " " + value;
					}
				}
				if (cm[i].field == "Tuptime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tupdate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["Tadmtime", "Tdischtime", "Tuptime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillReg",
			QueryName: "FindUpPatList",
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			patientId: getValueById("PatientId"),
			episodeId: $("#admList").combogrid("getValue"),
			userId: getValueById("guser"),
			patientName: getValueById("patientName"),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = getValueById("patientNo");
		if (!patientNo) {
			return;
		}
		$(".combogrid-f").combogrid("clear").combogrid("grid").datagrid("loadData", {total: 0, rows: []});
		patientNo = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "regnocon", PAPMINo: patientNo}, false);
		setValueById("patientNo", patientNo);
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: ""
		}, function(patientId) {
			if (!patientId) {
				$.messager.popover({msg: "登记号输入错误", type: "info"});
			}
			setValueById("PatientId", patientId);
			var patientName = getPropValById("PA_PatMas", patientId, "PAPMI_Name");
			setValueById("patientName", patientName);
			loadAdmList();
		});
	}
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindAdmList",
		patientId: getValueById("PatientId"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("admList", queryParams);
}

function loadUpdateList() {
	var queryParams = {
		ClassName: "web.DHCIPBillReg",
		QueryName: "FindUpPatList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("PatientId"),
		episodeId: $("#admList").combogrid("getValue"),
		userId: getValueById("guser"),
		patientName: getValueById("patientName"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("updateList", queryParams);
}