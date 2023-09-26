/// UDHCACFinBR.AccListQuery.js

var m_CardNoLength = 10;  //此界面没有卡类型选项，默认长度10;

$(function () {
	ini_LayoutStyle();
	$("#PAPMINo").keydown(function (e) {
		PatientNoKeyDown(e);
	});

	$("#CardNo").keydown(function (e) {
		CardNo_KeyPress(e);
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

function PatientNoKeyDown(e) {
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

function CardNo_KeyPress(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = getValueById("CardNo");
		if (!CardNo) {
			return;
		}
		CardNo = FormatCardNo();
		setValueById("CardNo", CardNo);
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPapmiByCardNO", CardNo);
		var myAry = rtn.split('^');
		if(myAry.length > 2){
			setValueById('PAPMINo', myAry[2]);
			var papmi = myAry[1];
			getPatInfo(papmi);
		}else {
			$.messager.alert('提示', '没有查询到有效患者', 'info');
			setValueById('PAPMINo', '');
			setValueById('CardNo', '');
			setValueById('PatNameA', '');
		}
	}
}

function FormatCardNo() {
	var CardNo = getValueById("CardNo");
	if (CardNo != '') {
		var CardNoLength = m_CardNoLength;
		if ((CardNo.length < CardNoLength) && (CardNoLength != 0)) {
			for (var i = (CardNoLength - CardNo.length - 1); i >= 0; i--) {
				CardNo = "0" + CardNo;
			}
		}
	}
	return CardNo;
}

function ini_LayoutStyle() {
	var defDate = getDefStDate(0);
	setValueById('StDate', defDate);
	setValueById('EndDate', defDate);
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
}

function Query_click(){
	$('#Query').click();	
}