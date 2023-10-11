﻿/**
 * FileName: dhcbill.opbill.outpatlist.js
 * Author: ZhYW
 * Date: 2019-06-13
 * Description: 门诊患者查询
 */

$(function () {
	initQueryMenu();
	initPatList();
});

function initQueryMenu() {
	setValueById("stDate", CV.StDate);
	setValueById("endDate", CV.EndDate);
	
	//读卡
	$("#btn-readCard").linkbutton({
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$("#btn-find").linkbutton({
		onClick: function () {
			loadPatList();
		}
	});

	$("#btn-clear").linkbutton({
		onClick: function () {
			clearClick();
		}
	});
	
	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});
	
	//科室
	$("#admDept").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPCashier&QueryName=FindOPAdmLoc&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.sessionStr = getSessionStr();
		}
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key != 13) {
		setValueById("PatientId", "");
		return;
	}
	if (!$(e.target).val()) {
		return;
	}
	var patientId = getPAPMIByRegNo($(e.target).val());
	setValueById("PatientId", patientId);
	if (!patientId) {
		$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
		focusById("patientNo");
		return;
	}
	setPatientInfo(patientId);
}

/**
* 根据登记号查询患者主索引
*/
function getPAPMIByRegNo(patientNo) {
	return (patientNo != "") ? $.m({ClassName: "web.DHCOPCashierIF", MethodName: "GetPAPMIByNo", PAPMINo: patientNo, ExpStr: ""}, false) : "";
}
			
/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	
	setValueById("PatientId", patientId);
	if (patientId != "") {
		setPatientInfo(patientId);
	}
}

function initPatList() {
	GV.AdmList = $HUI.datagrid("#admList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		className: "web.DHCOPAdmFind",
		queryName: "AdmQuery",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TAdmDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TPatientId", "TAdm"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TAdmTime") {
					cm[i].formatter = function(value, row, index) {
					   	return row.TAdmDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["TAdmTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		onDblClickRow: function (index, row) {
			if (window.parent.frames && window.parent.frames.switchPatient) {
				window.parent.frames.switchPatient(row.TPatientId, row.TAdm);
				window.parent.frames.hidePatListWin();
			}
		}
	});
}

function setPatientInfo(patientId) {
	$.cm({
		ClassName: "BILL.COM.PAPatMas",
		MethodName: "GetPatientInfo",
		patientId: patientId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(json) {
		setValueById("patientNo", json.PatientNo);
		setValueById("patName", json.PatName);
		loadPatList();
	});
}

function loadPatList() {
	var isPayAfterTreat = getValueById("isPayAfterTreat") ? 1 : 0;
	var queryParams = {
		ClassName: "web.DHCOPAdmFind",
		QueryName: "AdmQuery",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("PatientId"),
		patientName: getValueById("patName"),
		admDeptId: getValueById("admDept"),
		sessionStr: getSessionStr(),
		expStr: isPayAfterTreat
	};
	loadDataGridStore("admList", queryParams);
}

/**
 * 清屏
 */
function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".combobox-f").combobox("clear").combobox("reload");
	$("#isPayAfterTreat").checkbox("uncheck");
	setValueById("PatientId", "");
	setValueById("stDate", CV.StDate);
	setValueById("endDate", CV.EndDate);
	GV.AdmList.options().pageNumber = 1;   //跳转到第一页
	GV.AdmList.loadData({total: 0, rows: []});
}