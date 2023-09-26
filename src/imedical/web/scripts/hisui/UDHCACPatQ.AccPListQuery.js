/// UDHCACPatQ.AccPListQuery.js

var m_SelectCardTypeRowID = "";
var m_CardNoLength = 0;

$(function () {
	//账户明细表单 初始化
	ini_UDHCACPatAccDataGrid();

	$("#ReadCard").linkbutton({
		onClick: function() {
			ReadHFMagCard_Click();
		}
	});
		
	$("#Clear").linkbutton({
		onClick: function() {
			Clear_OnClick();
		}
	});
	
	$("#Print").linkbutton({
		onClick: function() {
			Print_OnClick();
		}
	});
	
	$("#CardNo").keydown(function(e) {
		CardNo_OnKeyDown(e);
	});

	$("#CardTypeDefine").combobox({
		panelHeight: 'auto',
		url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array",
		valueField: 'value',
		textField: 'caption',
		editable: false,
		onChange: function(newVal, oldVal) {
			CardTypeDefine_OnChange();
		}
	});
});

function Print_OnClick() {
}

function Query_OnClick() {
	loadAccPList();
}

function Clear_OnClick() {
	$("#CardTypeDefine").combobox("reload");
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f").combobox("clear");
	setValueById("AccRowID", "");
	setValueById("SecurityNo", "");
	loadAccPList();
}

function loadAccPList() {
	var queryParams = {
		ClassName: "web.UDHCAccManageCLS",
		QueryName: "ReadPatAccList",
		AccRowID: getValueById("AccRowID")
	};
	loadDataGridStore("tUDHCACPatQ_AccPListQuery", queryParams);
}

function ReadPatAccInfo() {
	var PAPMINo = getValueById("PAPMINo");
	var CardNo = getValueById("CardNo");
	var SecurityNo = getValueById("SecurityNo");
	if (!CardNo && !SecurityNo) {
		return;
	}
	var encmeth = getValueById("ReadPAInfoEncrypt");	
	var myrtn = cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo);
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		WrtPatAccInfo(myrtn);
	} else {
		DHCWeb_HISUIalert(t[myary[0]]);
	}
}


function ReadHFMagCard_Click() {
	var myoptval =getValueById("CardTypeDefine");
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myoptval);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		setValueById("CardNo", myary[1]);
		setValueById("SecurityNo", myary[2]);
		setValueById("PAPMINo", myary[5]);
		ReadPatAccInfo();
		Query_OnClick();
		//Account Can Pay
		break;
	case "-200":
		DHCWeb_HISUIalert(t["-200"]);
		break;
	case "-201":
		DHCWeb_HISUIalert(t[rtn]);
		break;
	default:
		//DHCWeb_HISUIalert("");
	}
}


function WrtPatAccInfo(myPAInfo) {
	//s myPAInfo = rtn_"^"_myPAPMINO_"^"_myPatName_"^"_mySexDesc_"^"_myPatBD
	//s myPAInfo = myPAInfo_"^"_myCredDesc_"^"_myCredNo_"^"_myLeft
	//s myPAInfo = myPAInfo_"^"_myASDesc_"^"_myAccNo_"^"_myCDT_"^"_BadPrice_"^"_DepPrice
	//s myPAInfo = myPAInfo_"^"_myAccRowID

	var myary = myPAInfo.split("^");
	setValueById("PAPMINo", myary[1]);
	setValueById("PAName", myary[2]);
	setValueById("PatSex", myary[3]);
	setValueById("PatAge", myary[4]);
	setValueById("CredType", myary[5]);	
	setValueById("CredNo", myary[6]);
	setValueById("AccStatus", myary[8]);
	setValueById("AccLeft", myary[7]);
	setValueById("AccNo", myary[9]);
	setValueById("AccOCDate", myary[10]);
	setValueById("AccDep", myary[7]);
	setValueById("AccRowID", myary[13]);
}

function CardNo_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = getValueById("CardNo");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeRowID, myCardNo, mySecurityNo, "");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
			case "0":
				setValueById("CardNo", myary[1]);
				setValueById("SecurityNo", myary[2]);
				setValueById("PAPMINo", myary[5]);
				ReadPatAccInfo();
				Query_OnClick();
				break;
			case "-200":
				DHCWeb_HISUIalert(t["-200"]);
				break;
			case "-201":
				DHCWeb_HISUIalert(t["-201"]);
				break;
			default:
				//DHCWeb_HISUIalert("");
		}
	}
}

///格式化卡号
function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

function CardTypeDefine_OnChange() {
	var myoptval = getValueById("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		$("#CardNo").attr("readOnly", false);
		disableById("ReadCard");
		focusById("CardNo");
	} else {
		$("#CardNo").attr("readOnly", true);
		enableById("ReadCard");
		focusById("ReadCard");
	}
	m_CardNoLength = myary[17];
}

/**
* 账户明细
*/
function ini_UDHCACPatAccDataGrid() {
	$('td.i-tableborder>table').css("border-spacing","0px 8px");
	var colAry = $("#tUDHCACPatQ_AccPListQuery").datagrid("options").columns;
	$.each(colAry[0], function(index, item) {
		if (item.field == "TDetails") {
			item.formatter = function (value, row, index) {
				if (row.Flag == "PL") {
					return "<a href='javascript:;' onclick=\"orderDetail(\'" + row.PRowID + "', '" + "PRT" + "\')\">" + "明细" + "</a>";
				}
			}
		}
	});
	$("#tUDHCACPatQ_AccPListQuery").datagrid("options").columns = colAry;
}

function orderDetail(prtRowId, invType) {
	var url = 'dhcbill.opbill.invoeitm.csp?&invRowId=' + prtRowId + '&invType=' + invType;
	websys_showModal({
		url: url,
		title: '医嘱明细',
		iconCls: 'icon-w-list'
	});
}
