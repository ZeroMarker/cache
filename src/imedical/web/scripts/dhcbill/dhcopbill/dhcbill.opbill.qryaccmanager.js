/**
 * FileName: dhcbill.opbill.qryaccmanager.js
 * Author: ZhYW
 * Date: 2022-05-22
 * Description: 账户查询
 */

$(function () {
	//+upd gongxin 20230414 增加多院区 下拉框选择
	var hospComp = GenUserHospComp();
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row){
			loadConHospMenu();
		},
		onLoadSuccess: function(data){
			loadConHospMenu();
		}
	});
	
	initQueryMenu();
	initAccMList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadAccMList();
		}
	});

	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
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
	
	//开户人员
	$("#user").combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=O&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});
}

/**
* gonxin
* 加载跟医院有关的查询元素
*/
function loadConHospMenu() {
	var hospId = $HUI.combogrid("#_HospUserList").getValue();
	
	var url = $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryInvUser&ResultSetType=array&invType=O&hospId=' + hospId;
	$("#user").combobox("clear").combobox("reload", url);
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById("CardNo", "");
		setValueById("patName", "");
		var patientId = $.cm({ClassName: "web.DHCOPCashierIF", MethodName: "GetPAPMIByNo", PAPMINo: $(e.target).val(), ExpStr: ""}, false);
		if (!patientId) {
			$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
			focusById($(e.target));
			return;
		}
		$.cm({
			ClassName: "BILL.COM.PAPatMas",
			MethodName: "GetPatientInfo",
			patientId: patientId
		}, function (json) {
			setValueById("patientNo", json.PatientNo);
			setValueById("patName", json.PatName);
			loadAccMList();
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
		loadAccMList();
	}
}

function initAccMList() {
	GV.AccMList = $HUI.datagrid("#accMList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCAccManageCLS",
		queryName: "ReadAccMList",
		frozenColumns: [[{title: '登记号', field: 'PAPMINo', width: 120},
						 {title: '患者姓名', field: 'PatName', width: 100}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["PAPMINo", "PatName", "CDate", "WDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if (cm[i].field == "CTime") {
					cm[i].formatter = function(value, row, index) {
						return row.CDate + " " + value;
					}
				}
				if (cm[i].field == "WTime") {
					cm[i].formatter = function(value, row, index) {
						return row.WDate + " " + value;
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "Sex") {
						cm[i].width = 50;
					}
					if (cm[i].field == "CardNo") {
						cm[i].width = 150;
					}
					if (cm[i].field == "AccountNo") {
						cm[i].width = 150;
					}
				}
			}
		}
	});
}

function loadAccMList() {
	var queryParams = {
		ClassName: "web.UDHCAccManageCLS",
		QueryName: "ReadAccMList",
		AccNo: "",
		PAPMINo: getValueById("patientNo"),
		CUserId: getValueById("user"),
		CardNo: getValueById("CardNo"),
		AccStatus: "",
		AccType: "",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		PatName: getValueById("patName"),
		HospId : $HUI.combogrid("#_HospUserList").getValue()
	};
	loadDataGridStore("accMList", queryParams);
}

function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f").combobox("clear");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.AccMList.options().pageNumber = 1;   //跳转到第一页
	GV.AccMList.loadData({total: 0, rows: []});
	focusById("CardNo");
}