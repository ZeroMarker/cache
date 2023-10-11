/**
 * FileName: dhcbill.opbill.qryaccplist.js
 * Author: ZhYW
 * Date: 2022-05-22
 * Description: 账户读卡查询
 */

$(function () {
	initQueryMenu();
	initAccPList();
});

function initQueryMenu () {
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
	if (patientId > 0) {
		getPatInfo();
	}
	if (accMRowId > 0) {
		getAccMInfo();
		loadAccPList();
	}
}

function getPatInfo() {
	$.cm({
		ClassName: "BILL.COM.PAPatMas",
		MethodName: "GetPatientInfo",
		patientId: getValueById("patientId")
	}, function(json) {
		setValueById("patientNo", json.PatientNo);
		setValueById("patName", json.PatName);
		setValueById("sex", json.Sex);
		setValueById("birthDate", json.BirthDate);
	});
}

function getAccMInfo() {
	$.cm({
		ClassName: "BILL.OP.COM.AccManager",
		MethodName: "GetAccMInfo",
		accMRowId: getValueById("accMRowId")
	}, function(json) {
		setValueById("accMLeft", json.Balance);
		setValueById("accountNo", json.AccountNo);
		setValueById("accMCDate", json.CreatDate);
		setValueById("accMDep", json.LeftAmt);
	});
}

function initAccPList() {
	GV.AccPList = $HUI.datagrid("#accpList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "web.UDHCAccManageCLS",
		queryName: "ReadPatAccList",
		frozenColumns: [[{title: '明细', field: 'Details', align: 'center', width: 50,
						  formatter: function (value, row, index) {
							if (row.Flag == "PL") {
								return "<a href='javascript:;' class='datagrid-cell-img' title='明细' onclick='openDtlView(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png'/></a>";
							}
						  }
						 }
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Flag", "PRowID", "InvType"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "APDate") {
						cm[i].width = 155;
					}
					if (cm[i].field == "ABillNo") {
						cm[i].width = 180;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function loadAccPList() {
	var queryParams = {
		ClassName: "web.UDHCAccManageCLS",
		QueryName: "ReadPatAccList",
		AccRowID: getValueById("accMRowId")
	};
	loadDataGridStore("accpList", queryParams);
}

function openDtlView(row) {
	var argObj = {
		invRowId: row.PRowID,
		invType: row.InvType
	};
	BILL_INF.showOPChgOrdItm(argObj);
}

function clearClick() {
	$(":text:not(.pagination-num)").val("");
	setValueById("accMRowId", "");
	setValueById("patientId", "");
	$(".numberbox-f").numberbox("clear");
	GV.AccPList.options().pageNumber = 1;   //跳转到第一页
	GV.AccPList.loadData({total: 0, rows: []});
	focusById("CardNo");
}