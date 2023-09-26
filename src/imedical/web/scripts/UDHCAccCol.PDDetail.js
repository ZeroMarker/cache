/// UDHCAccCol.PDDetail.js

var m_SelectCardTypeDR;
var m_CardNoLength;

function BodyLoadHandler() {
	//ValidateDocumentData();
	var myReadFlag = DHCWebD_GetObjValue("ReadOnly");
	var obj = document.getElementById("UserCode");
	if ((obj) && (myReadFlag != "N")) {
		//obj.readOnly = true;
	}
	var obj = document.getElementById("PDDFlag");
	if (obj) {
		$('#PDDFlag').combobox({
    		valueField:'id',
    		textField:'text',
    		data:[{
    			"id" : '',
    			"text":"全部"
    		},{
    			"id" : 'P',
    			"text":"收"	
    		},{
	    		"id" : 'R',
    			"text":"退"	
			}],
			onChange:function(newVal,oldVal){
				PDDFlagList_OnChange();
				},
		});
	}
	

	var obj = document.getElementById("ReadCard");
	if (obj) {
		obj.onclick = ReadHFMagCard_Click;
	}
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		$('#CardTypeDefine').combobox({
			valueField:'id',
    		textField:'text',
			onChange:function(newVal,oldVal){
				CardTypeDefine_OnChange();
				},
		});
		ReadCardType();
	}
	var prtobj = document.getElementById("PDPrint");
	if (prtobj) {
		prtobj.onclick = PDPrint_Click;
	}
	//补全登记号  add zli  17.8.24
	var obj = document.getElementById("PAPMNo");
	if (obj) {
		obj.onkeydown = PatientNoKeyDown;
	}
	var obj = document.getElementById("AccCardNO");
	if (obj) {
		obj.onkeydown = AccCardNO_OnKeyDown;
	}
	document.onkeydown = Doc_OnKeyDown;
	

	ini_LayoutStyle(); // tangzf 2019-5-2

	
}

function PDDFlagList_OnChange() {
	DHCWebD_SetObjValueB("currentPDDFlag", getValueById("PDDFlag"));
}

function ReadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToCombobox", "CardTypeDefine");
	}
}

function ReadHFMagCard_Click() {
	//ClsWinDoc();
	var myCardTypeValue = getValueById("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		DHCWebD_SetObjValueB("PAPMNo", myary[5]);
		DHCWebD_SetObjValueB("AccCardNO", myary[1]);
		Query_click()
		//DHCWebD_SetObjValueB("AccRowID",myary[7]);
		break;
	case "-200":
		DHCWeb_HISUIalert(t["-200"]);
		break;
	case "-201":
		DHCWeb_HISUIalert(t["-201"]);
		//var obj = document.getElementById("PAPMNo");
		//obj.value = myary[6];
		break;
	default:
		//DHCWeb_HISUIalert("");
	}
}
function Query_click() {
	var PAPMNo = getValueById("PAPMNo");
	var CardNo = getValueById("AccCardNO");
	var StartDate=getValueById("StDate");
	var EndDate=getValueById("EndDate");
	if (CardNo == "") {
		var CardNo = getValueById("CardNoA");
	}
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=UDHCAccCol.PDDetail&PAPMNo=" + PAPMNo;
	lnk = lnk + "&AccCardNO=" + CardNo + "&StDate=" + StartDate + "&EndDate=" + EndDate 
	window.location.href = lnk;
}
function userlok(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("UserCode", myAry[0]);
	DHCWebD_SetObjValueB("UserCodeA", myAry[1]);
}

function GetUserInfoByUserCode(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("UserCode", myAry[0]);
	DHCWebD_SetObjValueB("UserCodeA", myAry[1]);

}

function PDPrint_Click() {
	var myAccCardNO = DHCWebD_GetObjValue("AccCardNO");
	var myUserCode = DHCWebD_GetObjValue("UserCode");
	var myPAPMNo = DHCWebD_GetObjValue("PAPMNo");
	var myStDate = getValueById("StDate") //DHCWebD_GetObjValue("StDate");
	var myEndDate = getValueById("EndDate");
	var myUserCodeA = DHCWebD_GetObjValue("UserCodeA");
	var myPDDFlag = getValueById("PDDFlag")
	var fileName = "DHCIPBILLUDHCAccCol.PDDetail.raq&AccCardNO=" + myAccCardNO + "&UserCode=" + myUserCode + "&PAPMNo=" + myPAPMNo + "&StDate=" + myStDate + "&EndDate=" + myEndDate + "&UserCodeA=" + myUserCodeA + "&PDDFlag=" + myPDDFlag;
	DHCCPM_RQPrint(fileName);
}

function Doc_OnKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 115) {
		//F4 读卡
		var obj = document.getElementById("ReadCard");
		if ((obj)&&(!obj.disabled)) {
			ReadHFMagCard_Click();
		}
	}
	DHCWeb_EStopSpaceKey();
}

function ValidateDocumentData() {
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		//myobj.size = 1;
		//myobj.multiple = false;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function CardTypeDefine_OnChange() {
	//var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myoptval=getValueById("CardTypeDefine")
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("AccCardNO");
		if (myobj) {
			myobj.readOnly = false;
		}
		var obj = document.getElementById("ReadCard")
		obj.disabled=true;
		$("#ReadCard").linkbutton('disable');
		//DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	} else {
		var myobj = document.getElementById("AccCardNO");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			$("#ReadCard").linkbutton('enable');
			// DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("AccCardNO");
	} else {
		DHCWeb_setfocus("ReadCard");
	}
	m_CardNoLength = myary[17];
}

function PatientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var PAPMNoObj = document.getElementById("PAPMNo");
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", PAPMNoObj.value);
		PAPMNoObj.value = rtn;
	}
}

function AccCardNO_OnKeyDown(e){
	var key = websys_getKey(e);
	if (key == 13) {
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("AccCardNO");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
			case "0":
				var obj = document.getElementById("PAPMNo");
				obj.value = myary[5];
				var obj = document.getElementById("AccCardNO");
				DHCWebD_SetObjValueB("AccCardNO", myary[1]);
				Query_click();
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
	var obj = document.getElementById('AccCardNO');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}
function ini_LayoutStyle(){
		$('td.i-tableborder>table').css("border-spacing","0px 8px");
		$('#tUDHCAccCol_PDDetail').datagrid({
      	 	fitColumns:false
   		 })
   		$('#UserCode').lookup({
	   		panelWidth:220,
			displayMsg:"",
		})
	}
document.body.onload = BodyLoadHandler;