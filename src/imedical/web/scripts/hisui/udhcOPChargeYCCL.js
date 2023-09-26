/// udhcOPChargeYCCL.js

var m_PrtXMLName = "";
var m_YBConFlag = "0";
var listobj = parent.frames["udhcOPRefundyccl_Order"];

$(function() {
	init_Layout();
	
	$("#ReceipNO").keydown(function(e) {
		ReceipNO_KeyDown(e);
	});
	
	$HUI.linkbutton("#RefClear", {
		onClick: function () {
			RefundClear_Click();
		}
	});
	
	$HUI.linkbutton("#ReadPos", {
		onClick: function () {
			ReadPosQuery_OnClick();
		}
	});
	
	$HUI.linkbutton("#ReTrade", {
		onClick: function () {
			ReTrade_Click();
		}
	});
	
	$HUI.linkbutton("#RePrintAcert", {
		onClick: function () {
			RePrintAcert_OnClick();
		}
	});
	
	$HUI.combobox("#RefundPayMode", {
		disabled: true,
		url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'CTPMRowID',
		textField: 'CTPMDesc',
		onBeforeLoad: function(param) {
			param.GPRowID = session['LOGON.GROUPID'];
			param.HospID = session['LOGON.HOSPID'];
			param.TypeFlag = "FEE";
		}
	});
	
	IntDoc();
	
	var encmeth = getValueById("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.HOSPID']);
		var myary = myrtn.split("^");
		m_YBConFlag = myary[12];
	}
	
	focusById("ReceipNO");
});

function IntDoc() {
	//Load Base Config
	var encmeth = getValueById("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, session['LOGON.GROUPID'], session['LOGON.HOSPID']);
	}
	var myPrtXMLName = "";
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		myPrtXMLName = myary[10];
	}
	m_PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);
}

function ReadPosQuery_OnClick() {
	var myrtn = DHCACC_GetAccInfobyPos();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//setValueById("PatientID", myary[5]);
		ReadCardQueryINV(myary[5]);
		//ReadPatInfo();
		break;
	case "-200":
		listobj.NoHideAlert(t["-200"]);
		break;
	case "-201":
		listobj.NoHideAlert(t["-201"]);
		//setValueById("PatientID", myary[5]);
		//ReadPatInfo();
		break;
	default:
		//listobj.NoHideAlert("");
	}
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPINVYCCL.Query";
	lnk += "&FramName=udhcOPChargeYCCL&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=A&sFlag=PRT&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINVYCCL_Query", "status=yes,scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function RefundClear_Click() {
	IntRefMain();
	AddIDToOrder("");
}

function ReceipNO_KeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var ReceipNo = getValueById("ReceipNO");
		if (!ReceipNo) {
			return;
		}
		var encmeth = getValueById("getReceipID");
		var rtn = cspRunServerMethod(encmeth, 'SetReceipID', '', ReceipNo, "", session['LOGON.HOSPID']);
		var ReceipID = getValueById("ReceipID");
		if (ReceipID != "") {
			var encmeth = getValueById("getReceiptinfo");
			if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID, session['LOGON.HOSPID']) == '0') {
				enableById("ReTrade");
				parent.frames['udhcOPRefundyccl_Order'].location.href = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid=" + ReceipID;
			}
		} else {
			disableById("ReTrade");
			listobj.NoHideAlert(t['06']);
			focusById("ReceipNO");
			return websys_cancel();
		}
	}
}

function ReTrade_Click() {
	var InsType = getValueById("InsType");
	var ReceipRowid = InsType = getValueById("ReceipID");
	if (ReceipRowid != "") {
		var encmeth = getValueById("GetOriginalTradeRowID");
		if (encmeth) {
			var rtn = cspRunServerMethod(encmeth, ReceipRowid);
			if (rtn != "") {
				listobj.NoHideAlert("此发票已使用POS交易,无需再交易!");
				return;
			}
		}
	} else {
		listobj.NoHideAlert("发票不存在!");
		return;
	}
	//add tangtao 2011-11-06   软POS
	var mystr = getValueById("RefundPayMode");
	var myary1 = mystr.split("^");
	var myPayModeDR = myary1[0];
	var myPayModeCode = myary1[1];
	var expstr = "DLL" + "^INV^" + myPayModeDR + "^" + session['LOGON.GROUPID'];
	var encmeth = getValueById("GetPayModeHardComm");
	if (encmeth) {
		var handDR = cspRunServerMethod(encmeth, "OP", myPayModeDR);
		if (handDR != "") {
			var Status = handDR.split("^")[1];
			if (Status == "DLL") {
				var encmeth = getValueById("OrderInvPrt");
				if (encmeth) {
					var InvPrtStr = cspRunServerMethod(encmeth, "C", ReceipRowid, "");
					if (InvPrtStr != "-1") {
						InvPrtStr = InvPrtStr + "#" + "";
						var InvPrtStr1 = InvPrtStr;
						invAmt = InvPrtStr1.split("#")[1];
						var rtnValue = CallDLLFun("OP", "C", ReceipRowid, expstr, ReceipRowid, InvPrtStr, "", "");
						tmpAry = rtnValue;
						if (tmpAry == "0") {
							listobj.NoHideAlert("补交易成功!");
						} else {
							listobj.NoHideAlert("补交易失败!");
						}
					} else {
						listobj.NoHideAlert("获取传送信息失败,请重新尝试补交易!");
					}
				}
			} else {
				var BankCardNO = GetCardNo();
				if (BankCardNO == "-1") {
					return;
				}
				//BankCardNO,ReloadFlag,YBConFlag,AdmSource,BankTradeType,ClientType,PrtRowIDStr
				//增加医保以后要考虑YBConFlag , AdmSource
				var retn = BMCOPPay(BankCardNO, "", "", "", "C", "26", ReceipRowid);
				if (retn == "DelHisSuccess") {
					return;
				} else if (retn == "0") {
					listobj.NoHideAlert("补交易成功");
				}
			}
		} else {
			listobj.NoHideAlert("支付方式不是软POS或者银医卡,不能进行补交易!");
		}
	}
}

function BillPrintNew(INVstr) {
	if (m_PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	DHCP_GetXMLConfig("InvPrintEncrypt", m_PrtXMLName);
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = getValueById("getSendtoPrintinfo");
			var PayMode = getValueById("PayMode");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session["LOGON.USERCODE"];
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", m_PrtXMLName, INVtmp[invi], sUserCode, PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_XMLPrint(myobj, TxtInfo, ListInfo);
}

function SetReceipID(value) {
	try {
		var myAry = value.split('^');
		var ReceipID = myAry[0];
		var sFlag = myAry[1];
		if (sFlag == 'PRT') {
			setValueById("ReceipID", ReceipID);
		}
	} catch(e) {
	}
}

function SetReceipInfo(value) {
	var myAry = value.split("^");

	setValueById("PatientID", myAry[0]);
	setValueById("PatientName", myAry[1]);
	setValueById("PatientSex", myAry[2]);
	setValueById("Sum", parseFloat(myAry[3]).toFixed(2));

	setValueById("INSDivDR", myAry[13]);
	setValueById("InsType", myAry[17]);
	
	disableById("Abort");
	disableById("Refund");
	setValueById("RefundPayMode", myAry[9]);
}

function AddIDToOrder(ReceipID) {
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPRefundyccl.Order&ReceipRowid=" + ReceipID;
	var AdmCharge = parent.frames['udhcOPRefundyccl_Order'];
	AdmCharge.location.href = lnk;
}

function IntRefMain() {
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=udhcOPChargeYCCL";
	var AdmCharge = parent.frames['udhcOPChargeYCCL'];
	AdmCharge.location.href = lnk;
}

function RePrintAcert_OnClick() {
	var UserName = session['LOGON.USERNAME'];
	var lnk = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCOPBillFindBankTrade";
	lnk += "&FramName=udhcOPChargeYCCL";
	lnk += "&UserName=" + UserName;
	var NewWin = open(lnk, "DHCOPBillFindBankTrade", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function GetCardNo() {
	listobj.NoHideAlert("请刷银行卡");
	var myrtn = DHCACC_GetAccInfobyPos();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	if (rtn == "-200") {
		listobj.NoHideAlert(t["-200"]);
		return "-1";
	}
	if (rtn == "-201") {
		listobj.NoHideAlert(t["-201"]);
		return "-1";
	}
	if (rtn == "0") {
		return myary[1];
	} else {
		listobj.NoHideAlert("卡无效");
		return "-1";
	}
}

function init_Layout(){
	$('#cReceipNO').parent().parent().css("width", "57px");
	DHCWeb_ComponentLayout();
}