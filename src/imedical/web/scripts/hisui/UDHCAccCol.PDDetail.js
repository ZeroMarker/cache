/// UDHCAccCol.PDDetail.js

$(function () {
	ini_LayoutStyle();   // tangzf 2019-5-2
	
	$("#PDDFlag").combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		data:[{id: "P", text: $g("收")},
			  {id: "R", text: $g("退")}]
	});

	$("#UserCode").combobox({
		panelHeight: 180,
		url: $URL + '?ClassName=web.UDHCAccAddDeposit&QueryName=FindOPCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function(param) {
			param.hospId = session['LOGON.HOSPID'];
			param.desc = "";
			param.langId = session['LOGON.LANGID']
		},
		onChange: function(newValue, oldValue) {
			setValueById("UserId", (newValue || ""));
		}
	});
	
	//押金类型
	$HUI.combobox("#DepositType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = session['LOGON.GROUPID'];
			param.hospId = session['LOGON.HOSPID'];
			param.langId = session['LOGON.LANGID'];
		},
		onChange: function(newValue, oldValue) {
			setValueById("DepTypeId", (newValue || ""));
		}
	});
	
	$HUI.linkbutton("#ReadCard", {
		onClick: function () {
			ReadHFMagCard_Click();
		}
	});
	
	$HUI.linkbutton("#PDPrint", {
		onClick: function () {
			PDPrint_Click();
		}
	});
	
	$("#PAPMNo").keydown(function(e) {
		PatientNoKeydown(e);
	});
	
	$("#AccCardNO").focus().keydown(function(e) {
		AccCardNOKeydown(e);
	});
});

function ReadHFMagCard_Click() {
	DHCACC_GetAccInfo7(magCardCallback);
}

function AccCardNOKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = getValueById("AccCardNO");
		if (CardNo == "") {
			return;
		}
		DHCACC_GetAccInfo("", CardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("AccCardNO", myAry[1]);
		setValueById("PAPMNo", myAry[5]);
		//setValueById("AccRowID", myAry[7]);
		setValueById("CardTypeRowId", myAry[8]);
		$("#Query").click();
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("AccCardNO");
		});
		break;
	case "-201":
		$.messager.alert("提示", "账户无效", "info", function () {
			focusById("AccCardNO");
		});
		break;
	default:
	}
}

function PDPrint_Click() {
	var myAccCardNO = getValueById("AccCardNO");
	var myPAPMNo = getValueById("PAPMNo");
	var myStDate = getValueById("StDate");
	var myEndDate = getValueById("EndDate");
	var myUserId = getValueById("UserId");
	var myPDDFlag = getValueById("PDDFlag");
	var myDepTypeId = getValueById("DepTypeId");
	var fileName = "DHCBILL-OPBILL-PDDetail.rpx&AccCardNO=" + myAccCardNO + "&PAPMNo=" + myPAPMNo + "&StDate=" + myStDate;
	fileName += "&EndDate=" + myEndDate + "&UserId=" + myUserId + "&PDDFlag=" + myPDDFlag + "&HospId=" + getValueById("HospId");
	fileName += "&DepTypeId=" + myDepTypeId;
	DHCCPM_RQPrint(fileName, 1200, 750);
}

function PatientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: getValueById("PAPMNo")
		}, function(rtn) {
			setValueById("PAPMNo", rtn);
		});
	}
}

function ini_LayoutStyle() {
	var defDate = getDefStDate(0);
	setValueById("StDate", defDate);
	setValueById("EndDate", defDate);
	$("td.i-tableborder>table").css("border-spacing", "0px 8px");
	$("#tUDHCAccCol_PDDetail").datagrid("options").fitColumns = false;
}