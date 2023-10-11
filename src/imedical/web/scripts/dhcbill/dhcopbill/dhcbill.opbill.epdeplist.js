/**
 * FileName: dhcbill.opbill.epdeplist.js
 * Author: ZhYW
 * Date: 2022-12-16
 * Description: 急诊留观押金查询
 */

$(function () {
	initQueryMenu();
	initEPDepList();
});

function initQueryMenu () {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadEPDepList();
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
		$.cm({
			ClassName: "web.DHCOPBillEPManageCLS",
			MethodName: "GetPatInfo",
			patientNo: $(e.target).val(),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		}, function (json) {
			if (!json.PatientId) {
				setValueById("patientId", "");
				$.messager.popover({msg: "患者不存在", type: "info"});
				focusById($(e.target));
				return;
			}
			setValueById("patientId", json.PatientId);
			setValueById("patientNo", json.PatientNo);
			loadEPDepList();
		});
	}
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
	setValueById("patientId", patientId);
	if (patientId != "") {
		loadEPDepList();
	}
}

function initEPDepList() {
	GV.EPDepList = $HUI.datagrid("#epDepList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.DHCOPBillEPAddDeposit",
		queryName: "QryEPDepList",
		frozenColumns: [[{title: '登记号', field: 'TPatientNo', width: 120},
						 {title: '患者姓名', field: 'TPatName', width: 100}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPatientNo", "TPatName", "TPrtDate", "TFootDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TPatientID", "TEpisodeID", "TInitPDDR", "TPreRowID"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TPrtTime") {
					cm[i].formatter = function(value, row, index) {
						return row.TPrtDate + " " + value;
					}
				}
				if (cm[i].field == "TFootTime") {
					cm[i].formatter = function(value, row, index) {
						return row.TFootDate + " " + value;
					}
				}
				if (cm[i].field == "TPreType") {
					cm[i].styler = function(value, row, index) {
						return 'font-weight: bold;color:' + ((row.TAmt >= 0) ? '#21ba45;' : '#f16e57;');
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TReceiptNo") {
						cm[i].width = 180;
					}
					if ($.inArray(cm[i].field, ["TPrtTime", "TFootTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		}
	});
}

function loadEPDepList() {
	var queryParams = {
		ClassName: "web.DHCOPBillEPAddDeposit",
		QueryName: "QryEPDepList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("patientId"),
		userId: getValueById("user"),
		depStatus: getValueById("preStatus"),
		paymId: getValueById("paymode"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("epDepList", queryParams);
}

function clearClick() {
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#user").combobox("clear");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.EPDepList.options().pageNumber = 1;   //跳转到第一页
	GV.EPDepList.loadData({total: 0, rows: []});
	focusById("CardNo");
}

function printClick() {
	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var patientId = getValueById("patientId");
	var userId = getValueById("user");
	var preStatus = getValueById("preStatus");
	var paymode = getValueById("paymode");
	
	var fileName = "DHCBILL-OPBILL-JZLGYJMX.rpx&stDate=" + stDate + "&endDate=" + endDate + "&patientId=" + patientId;
	fileName += "&userId=" + userId + "&depStatus=" + preStatus + "&paymId=" + paymode + "&hospId=" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var width = $(window).width() * 0.8;
	var height = $(window).height() * 0.8;
	DHCCPM_RQPrint(fileName, width, height);
}