/**
 * FileName: dhcbill.opbill.accpredeplist.js
 * Author: ZhYW
 * Date: 2022-05-22
 * Description: 预交金查询
 */

$(function () {
	initQueryMenu();
	initPreDepList();
});

function initQueryMenu () {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadPreDepList();
		}
	});

	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$HUI.linkbutton("#btn-print", {
		onClick: function () {
			printClick();
		}
	});
	
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	$("#preStatus").combobox({
		panelHeight: 'auto',
		valueField: 'value',
		textField: 'text',
		data:[{value: "P", text: $g("收")},
			  {value: "R", text: $g("退")}]
	});
	
	//收费员
	$("#user").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=O&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		onBeforeLoad: function (param) {
			param.desc = "";
		}
	});
	
	//押金类型
	$HUI.combobox("#depositType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryGrpDepType&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
		}
	});
	
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryPayMode&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("accMRowId", "");
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			var encmeth = getValueById("GetAccMInfoEncrypt");
			cspRunServerMethod(encmeth, "setAccMInfo", "", patientNo, "", "", "", "", "", PUBLIC_CONSTANT.SESSION.HOSPID);
		});
	}
}

function setAccMInfo(str) {
	var myAry = str.split("^");
	var patientId = myAry[1];
	setValueById("patientId", patientId);
	if (!patientId) {
		$.messager.popover({msg: "患者不存在", type: "info"});
		focusById("patientNo");
		return;
	}
	setValueById("patientNo", myAry[0]);
	loadPreDepList();
}

function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
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
	var accMRowId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		accMRowId = myAry[7];
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
	
	setValueById("patientId", patientId);
	setValueById("accMRowId", accMRowId);
	
	if (patientId != "") {
		loadPreDepList();
	}
}

function initPreDepList() {
	GV.PreDepList = $HUI.datagrid("#preDepList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCAccAddDeposit",
		queryName: "ReadPDDetails",
		frozenColumns: [[{title: '卡号', field: 'CardNo', width: 120},
						 {title: '登记号', field: 'PAPMINo', width: 120},
						 {title: '患者姓名', field: 'PatName', width: 100}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["CardNo", "PAPMINo", "PatName", "Tdate", "Tjkdate", "PDType"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "Ttime") {
					cm[i].formatter = function(value, row, index) {
						return row.Tdate + " " + value;
					}
				}
				if (cm[i].field == "Tjktime") {
					cm[i].formatter = function(value, row, index) {
						return row.Tjkdate + " " + value;
					}
				}
				if (cm[i].field == "Ttype") {
					cm[i].styler = function(value, row, index) {
						return 'font-weight: bold;color:' + ((row.Tamt >= 0) ? '#21ba45;' : '#f16e57;');
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Treceiptsno") {
						cm[i].width = 180;
					}
					if ($.inArray(cm[i].field, ["Ttime", "Tjktime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

function loadPreDepList() {
	var queryParams = {
		ClassName: "web.UDHCAccAddDeposit",
		QueryName: "ReadPDDetails",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		PatientId: getValueById("patientId"),
		AccMRowID: getValueById("accMRowId"),
		UserId: getValueById("user"),
		PDDFlag: getValueById("preStatus"),
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		PayMId: getValueById("paymode"),
		DepTypeId: getValueById("depositType")
	};
	loadDataGridStore("preDepList", queryParams);
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	setValueById("accMRowId", "");
	$(".combobox-f:not(#depositType)").combobox("clear");
	$("#depositType").combobox("reload");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.PreDepList.options().pageNumber = 1;   //跳转到第一页
	GV.PreDepList.loadData({total: 0, rows: []});
	focusById("CardNo");
}

function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var patientId = getValueById("patientId");
	var accMRowId = getValueById("accMRowId");
	var userId = getValueById("user");
	var preStatus = getValueById("preStatus");
	var depositType = getValueById("depositType");
	var paymode = getValueById("paymode");
	
	var fileName = "DHCBILL-OPBILL-PDDetail.rpx&StDate=" + stDate + "&EndDate=" + endDate + "&PatientId=" + patientId;
	fileName += "&AccMRowID=" + accMRowId + "&UserId=" + userId + "&PDDFlag=" + preStatus + "&HospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	fileName += "&DepTypeId=" + depositType + "&PayMId=" + paymode;
	var width = $(window).width() * 0.8;
	var height = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}