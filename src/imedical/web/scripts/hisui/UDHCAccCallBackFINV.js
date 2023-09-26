/// UDHCAccCallBackFINV.js

var m_OverWriteFlag = "N";
var m_CCMRowID = "";
var m_SelectCardTypeRowID = "";
var m_CardNoLength = 0;
var m_ReadCardMode = "";

$(function() {
	ini_LayoutStyle();
	
	$HUI.linkbutton("#RActAccount", {
		onClick: function () {
			RActAccount_OnClick();
		}
	});
	
	$HUI.linkbutton("#Clear", {
		onClick: function () {
			Clear_OnClick();
		}
	});
	
	$HUI.linkbutton("#ReadCard", {
		onClick: function () {
			ReadMagCard_Click();
		}
	});
	$("#RActAccount").linkbutton('disable');
	
	$("#ReceipNO").keydown(function (e) {
		ReceipNO_OnKeyPress(e);
	});
	$("#CardNo").keydown(function (e) {
		CardNo_OnKeyPress(e);
	});

	$("#CardTypeDefine").combobox({
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function(newVal, oldVal){
			CardTypeDefine_OnChange();
		}
	});
	
	$("#RefundPayMode").combobox({
		panelHeight: 180,
		disabled: true,
		url: $URL + '?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array',
		valueField: 'CTPM_RowId',
		textField: 'CTPM_Desc',
	});
	
	focusById("ReceipNO");
});

function RActAccount_OnClick() {
	var myCardNo = getValueById("CardNo");
	if (myCardNo == "") {
		DHCWeb_HISUIalert(t["ReadCTip"]);
		return;
	}
	var myAccRowID = getValueById("AccRowID");
	if (myAccRowID == "") {
		DHCWeb_HISUIalert(t["SelAccINfo"]);
		return;
	}
	var mySecrityNo = "";
	var myCardRowID = getValueById("CardRowID");
	if (myCardRowID == "") {
		//Wrt Card
		var myrtn = WrtCard();
		var myary = myrtn.split("^");
		if (myary[0] != "0") {
			return;
		}
		var mySecrityNo = myary[1];
	}
	var myAccRowID = getValueById("AccRowID");
	var myUserDR = session['LOGON.USERID'];
	var myCardInfo = BuildCardInfo(mySecrityNo);
	var myExpStr = myCardRowID + "^" + m_SelectCardTypeRowID;
	var myEncrypt = getValueById("SaveAccBackEncrypt");
	if (myEncrypt != "") {
		var myrtn = cspRunServerMethod(myEncrypt, myAccRowID, myUserDR, myCardInfo, ClientIPAddress, myExpStr);
		var myary = myrtn.split(String.fromCharCode(2));
		if (myary[0] == "0") {
			$("#RActAccount").linkbutton('disable');
			DHCWeb_HISUIalert(t["AccBackSucc"]);
		} else {
			$("#RActAccount").linkbutton('disable');
			DHCWeb_HISUIalert(t["AccBackFail"] + myary[0]);
		}
	}
}

function BuildCardInfo(SecrityNo) {
	var myary = new Array();
	myary[myary.length] = getValueById("PatientID");
	myary[myary.length] = getValueById("PAPMIRowID");
	myary[myary.length] = "";
	myary[myary.length] = getValueById("CardNo");
	myary[myary.length] = SecrityNo;
	myary[myary.length] = "";
	myary[myary.length] = "";
	myary[myary.length] = session['LOGON.USERID'];
	myary[myary.length] = ClientIPAddress;
	myary[myary.length] = SecrityNo;

	var myoptval = getValueById("CardTypeDefine");
	var myCardTypeary = myoptval.split("^");
	var myCardTypeDR = myCardTypeary[0];
	myary[myary.length] = myCardTypeDR;
	var mystr = myary.join("^");
	return mystr;
}

function WrtCard() {
	//Read Secrity
	//ReadSecEnvrypt
	if (m_OverWriteFlag != "Y") {
		return "0^";
	}
	var mySecrityNo = "";
	window.status = t[2011];
	var myencmeth = getValueById("ReadSecEnvrypt");
	if (myencmeth != "") {
		var myPAPMINo = getValueById("PatientID");
		mySecrityNo = cspRunServerMethod(myencmeth, myPAPMINo);
	} else {
		DHCWeb_HISUIalert("Read Err!");
		return "-1^";
	}
	//Write Card First
	if (mySecrityNo != "") {
		var myCardNo = getValueById("CardNo");
		var rtn = DHCACC_WrtMagCard("23", myCardNo, mySecrityNo, m_CCMRowID);
		window.status = "";
		if (rtn != "0") {
			DHCWeb_HISUIalert(t[2014]);
			return "-1^";
		}
	} else {
		return "-1^";
	}
	return "0^" + mySecrityNo;
}

function ReadMagCard_Click() {
	var myVersion = getValueById("DHCVersion");
	if (myVersion == "12") {
		M1Card_InitPassWord();
	}
	window.status = t[2007];
	var rtn = DHCACC_ReadMagCard(m_CCMRowID);
	var myary = rtn.split("^");
	if (myary[0] == '-5') {
		window.status = t[2008];
		return;
	}
	window.status = "";
	if (myary[0] == "0") {
		//Add Check Card No DHCACC_GetPAPMINo
		var myVersion = getValueById("DHCVersion");
		if (myVersion == "12") {
			var myCardStat = DHCACC_GetAccInfoFNoCard(myary[1], myary[2]);
			var myStatAry = myCardStat.split("^");
			if (myStatAry[0] == "0") {
				DHCWeb_HISUIalert(t["EntCardtip"]);
				DHCWeb_DisBtnA("RActAccount");
				return;
			} else {
				$("#RActAccount").linkbutton('enable');
			}
		}
		setValueById("CardNo", myary[1]);
		setValueById("SecurityNo", myary[2]);
	}
}

function Clear_OnClick() {
	$(":text:not(.pagination-num)").val("");
	$(".numberbox-f").numberbox("clear");
	$("#RefundPayMode").combobox("clear");
	$("#CardTypeDefine").combobox("reload");
}

function ReceipNO_OnKeyPress(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var myReceipNO = getValueById("ReceipNO");
		if (myReceipNO != "") {
			var encmeth = getValueById("ReadINVByNoEncrypt");
			var myrtn = cspRunServerMethod(encmeth, myReceipNO, session['LOGON.USERID'], session['LOGON.HOSPID']);
			var rtn = myrtn.split("^")[0];
			if (rtn != "0") {
				DHCWeb_HISUIalert(t['06']);
				focusById('ReceipNO');
				return websys_cancel();
			} else {
				WrtRefundMain(myrtn);
				var myAPIRowID = getValueById("OldAccPayINVRowID");
				return websys_cancel();
			}
		}
	}
}

function WrtRefundMain(AccINVInfo) {
	// Write Info For Main For
	var myary = AccINVInfo.split("^");
	setValueById("ReceipNO", myary[1]);
	setValueById("PatientID", myary[2]);
	setValueById("PatientName", myary[3]);
	setValueById("PatientSex", myary[4]);
	setValueById("INVSum", myary[5]);
	setValueById("AccNo", myary[7]);
	setValueById("AccLeft", myary[8]);
	setValueById("AccRowID", myary[9]);
	setValueById("AccStatus", myary[10]);
	setValueById("RefundPayMode", myary[11]);
	setValueById("YBPaySum", myary[12]);
	setValueById("AccStatDesc", myary[13]);
	setValueById("OldAccPayINVRowID", myary[14]);
	setValueById("PatSelfPay", myary[16]);
	setValueById("INSDivDR", myary[17]);
	setValueById("PAPMIRowID", myary[19]);
	$("#RActAccount").linkbutton('disable');
	if (myary[15] != "N") {
		DHCWeb_HISUIalert(t[myary[15] + "01"]);
		return;
	}
	//Check Account Status
	if (myary[10] != "F") {
		$("#RActAccount").linkbutton('disable');
		DHCWeb_HISUIalert(t["AccNoFootTip"]);
		return;
	}
	//check
	if (myary[18] == "N") {
		$("#RActAccount").linkbutton('disable');
		DHCWeb_HISUIalert(t["AccConfTip"]);
		return;
	}
	var myoptval = getValueById("CardTypeDefine");
	var myCardTypeary = myoptval.split("^");
	var myReadCardMode = myCardTypeary[16];
	if (myary[20] == "Y") {
		var data = $("#CardTypeDefine").combobox("getData");
		for (i in data) {
		    if (data[i].value.split("^")[0] == myary[21]) {
				myReadCardMode = data[i].value.split("^")[16];
			    setValueById("CardTypeDefine", data[i].value);
			    break;
			}
		}
		setValueById("CardRowID", myary[22]);
		setValueById("CardNo", myary[23]);
		DHCWeb_HISUIalert("患者有卡,直接办理帐户激活,不用重新分配卡,如果卡丢失请办理补卡后,再激活账户");
	} else {
		if (myReadCardMode == "Handle") {
			focusById("CardNo");
		} else {
			$("#ReadCard").linkbutton('enable');
		}
	}
	$("#RActAccount").linkbutton('enable');
}

function M1Card_InitPassWord() {
	try {
		var myobj = document.getElementById("ClsM1Card");
		if (!myobj) {
			return;
		}
		var rtn = myobj.M1Card_Init();
	} catch (e) {
	}
}

function CardNo_OnKeyPress(e) {
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
			focusById("RActAccount");
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
	var myoptval= getValueById("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeRowID = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	m_OverWriteFlag = myary[23];
	m_CCMRowID = myary[14];
	m_ReadCardMode = myary[16];
	m_CardNoLength = myary[17];  //该卡类型定义的卡号长度

	//Read Card Mode
	if (myary[16] == "Handle") {
		$("#CardNo").attr('readOnly', false);
		$("#ReadCard").linkbutton('disable');
		focusById("CardNo");
	} else {
		setValueById("CardNo", '');
		$("#CardNo").attr('readOnly', true);
		$("#ReadCard").linkbutton('enable');
		focusById("ReadCard");
	}
	m_CardNoLength = myary[17];
}

function ini_LayoutStyle() {
	$('td.i-tableborder>table').css("border-spacing", "0px 8px");
	$('td.i-tableborder').css("margin-bottom", "10px");
}