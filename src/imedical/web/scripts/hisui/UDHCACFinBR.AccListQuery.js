/// UDHCACFinBR.AccListQuery.js

$(function () {
	ini_LayoutStyle();
	
	$("#PAPMINo").keydown(function (e) {
		PatientNoKeydown(e);
	});

	$("#CardNo").focus().keydown(function (e) {
		CardNoKeydown(e);
	});
	
	$('#BUserCode').combobox({
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFReceipt&QueryName=FindCashier&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.type = 'O';
			param.hospId = session['LOGON.HOSPID'];
		}
	});
});

function PatientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var PAPMINo = getValueById("PAPMINo");
		if (!PAPMINo) {
			return;
		}
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetCardNOByPAPMI", PAPMINo, "", "");
		var myAry = rtn.split('^');
		if (myAry.length > 2) {
			setValueById("PAPMINo", myAry[2]);
			var papmi = myAry[1];
			getPatInfo(papmi);
		}else{
			$.messager.alert('提示', '没有查询到有效患者', 'info');	
			setValueById('PAPMINo', '');
			setValueById('CardNo', '');
			setValueById('PatNameA', '');
		}
	}
}

function getPatInfo(papmi) {
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: session['LOGON.HOSPID']
	}, function(rtn) {
		var myAry = rtn.split("^");
		setValueById('PatNameA', myAry[2]);
		Query_click();
	});
}

function CardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = getValueById("CardNo");
		if (!CardNo) {
			return;
		}
		DHCACC_GetAccInfo("", CardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("PAPMINo", myAry[5]);
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
		setValueById("PAPMINo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		$.messager.alert("提示", "账户无效", "info", function () {
			focusById("CardNo");
		});
		break;
	default:
	}
	
	if (patientId != "") {
		getPatInfo(patientId);
	}
}

function ini_LayoutStyle() {
	var defDate = getDefStDate(0);
	setValueById('StDate', defDate);
	setValueById('EndDate', defDate);
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
}

function Query_click() {
	$('#Query').click();
}