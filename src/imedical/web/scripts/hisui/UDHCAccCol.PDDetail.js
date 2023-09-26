/// UDHCAccCol.PDDetail.js

var m_SelectCardTypeDR;

$(function () {
	ini_LayoutStyle();   // tangzf 2019-5-2
	
	$("#PDDFlag").combobox({
		panelHeight: 'auto',
		valueField: 'id',
		textField: 'text',
		data:[{id: "P", text: "收"},
			  {id: "R", text: "退"}]
	});
	
	$("#CardTypeDefine").combobox({
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function(newValue, oldValue) {
			CardTypeDefine_OnChange();
		}
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
		},
		onChange: function(newValue, oldValue) {
			setValueById("UserId", (newValue || ""));
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
	
	$("#AccCardNO").keydown(function(e) {
		AccCardNOKeydown(e);
	});
});

function ReadHFMagCard_Click() {
	var myCardTypeValue = getValueById("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myAry = myrtn.split("^");
	var rtn = myAry[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		setValueById("AccCardNO", myAry[1]);
		setValueById("PAPMNo", myAry[5]);
		//setValueById("AccRowID", myAry[7]);
		Query_click();
		break;
	case "-200":
		setTimeout(function () {
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("ReadCard");
			});
		}, 300);
		break;
	case "-201":
		setTimeout(function () {
			$.messager.alert("提示", "账户无效", "info", function () {
				focusById("ReadCard");
			});
		}, 300);
		break;
	default:
	}
}

function Query_click() {
	$("#tUDHCAccCol_PDDetail").datagrid("load", {
			queryParams: {
				ClassName: "web.UDHCAccAddDeposit",
				QueryName: "ReadPDDetails",
				AccCardNO: getValueById("AccCardNO"),
				PAPMNo: getValueById("PAPMNo"),
				StDate: getValueById("StDate"),
				EndDate: getValueById("EndDate"),
				UserId: getValueById("UserId"),
				PDDFlag: getValueById("PDDFlag"),
				HospId: getValueById("HospId")
			}
		}
	);
}

function PDPrint_Click() {
	var myAccCardNO = getValueById("AccCardNO");
	var myPAPMNo = getValueById("PAPMNo");
	var myStDate = getValueById("StDate");
	var myEndDate = getValueById("EndDate");
	var myUserId = getValueById("UserId");
	var myPDDFlag = getValueById("PDDFlag");
	var fileName = "DHCBILL-OPBILL-PDDetail.rpx&AccCardNO=" + myAccCardNO + "&PAPMNo=" + myPAPMNo + "&StDate=" + myStDate + "&EndDate=" + myEndDate;
	fileName += "&UserId=" + myUserId + "&PDDFlag=" + myPDDFlag + "&HospId=" + getValueById("HospId");
	DHCCPM_RQPrint(fileName, 1200, 750);
}

function CardTypeDefine_OnChange() {
	var myCardTypeValue = getValueById("CardTypeDefine")
	var myAry = myCardTypeValue.split("^");
	var myCardTypeDR = myAry[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myAry[16] == "Handle") {
		$("#AccCardNO").attr("readOnly", false);
		$("#ReadCard").linkbutton("disable");
		focusById("AccCardNO");
	} else {
		$("#AccCardNO").attr("readOnly", true);
		$("#ReadCard").linkbutton("enable");
		focusById("ReadCard");
	}
}

function PatientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var PAPMNo = getValueById("PAPMNo");
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: getValueById("PAPMNo")
		}, function(rtn) {
			setValueById("PAPMNo", rtn);
		});
	}
}

function AccCardNOKeydown(e){
	var key = websys_getKey(e);
	if (key == 13) {
		var myCardNo = getValueById("AccCardNO");
		if (myCardNo == "") {
			return;
		}
		var myCardTypeValue = getValueById("CardTypeDefine");
		myCardNo = formatCardNo(myCardTypeValue, myCardNo);
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "");
		var myAry = myrtn.split("^");
		var rtn = myAry[0];
		switch (rtn) {
			case "0":
				setValueById("AccCardNO", myAry[1]);
				setValueById("PAPMNo", myAry[5]);
				Query_click();
				break;
			case "-200":
				setTimeout(function () {
					$.messager.alert("提示", "卡无效", "info", function () {
						focusById("AccCardNO");
					});
				}, 300);
				break;
			case "-201":
				setTimeout(function () {
					$.messager.alert("提示", "账户无效", "info", function () {
						focusById("AccCardNO");
					});
				}, 300);
				break;
			default:
		}
	}		
}

function ini_LayoutStyle() {
	var defDate = getDefStDate(0);
	setValueById("StDate", defDate);
	setValueById("EndDate", defDate);
	$("td.i-tableborder>table").css("border-spacing", "0px 8px");
	$("#tUDHCAccCol_PDDetail").datagrid("options").fitColumns = false;
}