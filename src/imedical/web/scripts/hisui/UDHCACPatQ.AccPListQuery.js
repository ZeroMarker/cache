/// UDHCACPatQ.AccPListQuery.js

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
	
	$("#CardNo").focus().keydown(function(e) {
		CardNo_OnKeyDown(e);
	});
});

function Print_OnClick() {
}

function Clear_OnClick() {
	focusById("CardNo");
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
		AccRowID: getValueById("AccRowID"),
		langId: getValueById("langId")
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
	var myrtn = cspRunServerMethod(encmeth, PAPMINo, CardNo, SecurityNo, getValueById("langId"));
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		WrtPatAccInfo(myrtn);
	} else {
		DHCWeb_HISUIalert(t[myary[0]]);
	}
}

function ReadHFMagCard_Click() {
	DHCACC_GetAccInfo7(magCardCallback);
}

function CardNo_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var CardNo = getValueById("CardNo");
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
		setValueById("CardNo", myAry[1]);
		setValueById("SecurityNo", myAry[2]);
		setValueById("PAPMINo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		ReadPatAccInfo();
		loadAccPList();
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		$.messager.alert("提示", "账户无效", "info", function () {
			focusById("CardNo");
		});
		break;
	default:
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
					return "<a href='javascript:;' onclick=\"orderDetail(\'" + row.PRowID + "', '" + row.InvType + "\')\">" + $g("明细") + "</a>";
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
		title: $g('医嘱明细'),
		iconCls: 'icon-w-list'
	});
}
