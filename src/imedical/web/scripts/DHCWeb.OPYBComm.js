﻿/// DHCWeb.OPYBComm.js

///YB Info Interface for DHC_INVPRT Table

function DHCWebOPYB_InitForm() {
	var myVersionObj = document.getElementById("DHCVersion");
	var myVersion = "";
	if (myVersionObj) {
		myVersion = myVersionObj.value;
	}
	switch (myVersion) {
		case "3":
			//SXDT Three Hospital
			//YB InterFace
			iniForm();
			break;
		case "4":
			//Ningbo  Mingzhou Hosp IF
			break;
		default:
	}
}

function DHCWebOPYB_DataUpdate(YBHandler, Guser, PrtRowIDStr, AdmSource, AdmReason, ExpStr, CPPFlag) {
	var myYBPaySum = 0;
	var myExpAry = ExpStr.split("^");
	var myStrikeFlag = myExpAry[0];
	var myGroupDR = myExpAry[1];
	var myYBInfo = InsuOPDivide(YBHandler, Guser, PrtRowIDStr, AdmSource, AdmReason, ExpStr, CPPFlag);
	if (myYBInfo == -3) {
		return "YBCancle^0";    //医保取消结算
	}
	/*
	if (myYBInfo == -1) {
		$.messager.popover({msg: '医保结算错误(" + myYBInfo + ")，打印自费发票', type: 'info'});
		return "0^0";
	}
	*/
	if ((myStrikeFlag != "S") && (myYBInfo == -4)) { //医保程序溢出时返回-4
		$.messager.popover({msg: '医保结算已取消，取消结算', type: 'info'});
		var myrtn = DHCWebOPYB_DeleteHISData(PrtRowIDStr, ExpStr);
		if (myrtn == 0) {
			return "YBCancle^0";
		}
		return "HisCancleFailed^0";
	}
	
	//重新汇总医保信息
	var ybInfo = tkMakeServerCall("web.DHCBillCons11", "GetYBAmtSum", myYBInfo);
	var myary = ybInfo.split(String.fromCharCode(4));
	if (myary[0] != 0) {
		$.messager.popover({msg: '医保分解金额错误：' + myary[1], type: 'error'});
		return "HisCancleFailed^0";
	} else {
		$.messager.popover({msg: '医保结算成功', type: 'success'});
	}
	var myYBPaySum = myary[2];
	return 0 + "^" + myYBPaySum;
}

function DHCWebOPYB_GetRoundAmount(CashAmount, ExpStr) {
	var myrtn = CashAmount;
	var myEncryptObj = document.getElementById("OPCRoundEncrypt");
	var myEncrypt = "";
	if (myEncryptObj) {
		myEncrypt = myEncryptObj.value;
	}
	if (myEncrypt != "") {
		myrtn = cspRunServerMethod(myEncrypt, CashAmount, ExpStr);
	}
	return myrtn;
}

function DHCWebOPYB_UpdateHISData(YBInfo, ExpStr) {
	var myrtn = "";
	var myEncryptObj = document.getElementById("UpdateHISYBEncrypt");
	var myEncrypt = "";
	if (myEncryptObj) {
		myEncrypt = myEncryptObj.value;
	}
	if (myEncrypt != "") {
		myrtn = cspRunServerMethod(myEncrypt, YBInfo, ExpStr)
	}
	return myrtn;
}

// Delete HIS Data  DHC_INVPRT
function DHCWebOPYB_DeleteHISData(PRTINVStr, ExpStr) {
	var myrtn = "";
	var myExpAry = ExpStr.split("^");
	var myGroupDR = myExpAry[1] || session['LOGON.GROUPID'];
	var myUserDR = session['LOGON.USERID'];
	var myExpStr = myGroupDR + "^" + myUserDR;
	var myEncryptObj = document.getElementById("DeleteHISYBEncrypt");
	var myEncrypt = "";
	if (myEncryptObj) {
		myEncrypt = myEncryptObj.value;
	}
	if (myEncrypt != "") {
		myrtn = cspRunServerMethod(myEncrypt, PRTINVStr, myExpStr);
	}
	return myrtn;
}

function DHCWebOPYB_ParkINVFYB(YBHandler, Guser, INSDivDR, AdmSource, AdmReason, ExpStr, CPPFlag) {
	var rtn = 0;
	if (INSDivDR == "") {
		return rtn;
	}
	var myexpary = ExpStr.split("^");
	var myrebillflag = "";
	if (myexpary.length > 0) {
		myrebillflag = myexpary[0];
	}
	var myVersionObj = document.getElementById("DHCVersion");
	var myVersion = "";
	if (myVersionObj) {
		myVersion = myVersionObj.value;
	}
	switch (myVersion) {
		case "0":
			rtn = OPRevBJMzTbPark(INSDivDR);
			break;
		case "3":
			//YB InterFace
			rtn = Mzsfcxyb(INSDivDR, myrebillflag);
			//Update PRTINV YB Info
			break;
		default:
			rtn = InsuOPDivideStrike(YBHandler, Guser, INSDivDR, AdmSource, AdmReason, ExpStr, CPPFlag);
			break;
	}
	return rtn;
}

function DHCWebOPYB_ParkINVFYBConfirm(YBHandler, CPPFlag, INSDivDR, ExpStr) {
	var rtn = 0;
	if (INSDivDR == "") {
		return rtn;
	}
	var myexpary = ExpStr.split("^");
	if (myexpary.length > 0) {
		var myrebillflag = myexpary[0];
	}
	var myVersionObj = document.getElementById("DHCVersion");
	var myVersion = "";
	if (myVersionObj) {
		myVersion = myVersionObj.value;
	}
	switch (myVersion) {
		case "7":
			//YB InterFace
			rtn = CDMZOParkOK(INSDivDR);
			//Update PRTINV YB Info
			break;
		default:
	}
	return rtn;
}