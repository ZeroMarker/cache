/// DHCOPGCF.GroupSet.js

function BodyLoadHandler() {
	var obj = document.getElementById("GPRowID");
	var obj = document.getElementById("LoadLocDR");
	if (obj) {
		obj.onchange = LoadLocDR_OnChange;
	}
	var obj = document.getElementById("Update");
	if (obj) {
		obj.onclick = Update_OnClick;
	}
	var obj = document.getElementById("UpdateRecLoc");
	if (obj) {
		obj.onclick = UpdateRecLoc_OnClick;
	}
	var obj = document.getElementById("RecLocFlag");
	if (obj) {
		obj.onclick = RecLocFlag_OnClick;
	}
	var obj = document.getElementById("Add");
	if (obj) {
		//obj.onclick = Add_Click;
	}
	var myobj = document.getElementById("UseINVType");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	var obj = document.getElementById("PrtListFlag");
	if (obj) {
		obj.onclick = PrtListFlag_OnClick;
	}
	DHCWeb_DisBtnA("btnPrtList");
	
	//+2018-03-08 ZhYW
	var obj = document.getElementById("SetGroupTabs");
	if (obj) {
		obj.onclick = SetGroupTabs_OnClick;
	}
	//
	//if not Row in DHC_OPGroupSettings insert into
	//and get GS_RowID
	IntDoc();
}

function IntDoc() {
	var obj = document.getElementById("LoadLocDR");
	if (obj) {
		obj.multiple = false;
	}

	DHCWebD_ClearAllListA("PayMode");
	DHCWebD_ClearAllListA("LoadLocDR");
	DHCWebD_ClearAllListA("RecLocDR");
	DHCWebD_ClearAllListA("UnSelLocList");

	var encmeth = DHCWebD_GetObjValue("ReadCTLocEncryt");
	//Add CT_Loc To ListBox
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToList", "LoadLocDR");
	}
	var obj = document.getElementById("RecLocDR");
	if (obj) {
		var nCount = obj.options.length;
	}
	var obj = document.getElementById("LoadLocDR");
	if (obj) {
		obj.selectedIndex = 0;
	}
	var myGRowID = DHCWebD_GetObjValue("GPRowID");
	//get the default Config
	var encmeth = DHCWebD_GetObjValue("ReadCFEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, myGRowID);
		var myary = rtn.split("^");
		if (myary[0] == 0) {
			//sucessed
			//set Form Control  rtn
			DHCWebD_SetObjValueA("OPGSRowID", parseInt(myary[1]));
			DHCWebD_SetObjValueA("FootFlag", parseInt(myary[2]));
			DHCWebD_SetObjValueA("RecLocFlag", parseInt(myary[3]));
			DHCWebD_SetObjValueA("PrtINVFlag", parseInt(myary[4]));
			//5   DateFrom
			//6   DateTo
			DHCWebD_SetObjValueA("AbortFlag", parseInt(myary[7]));
			DHCWebD_SetObjValueA("RefundFlag", parseInt(myary[8]));
			DHCWebD_SetObjValueA("GPDesc", myary[9]);
			DHCWebD_SetObjValueA("PrtXMLName", myary[10]);
			DHCWebD_SetObjValueA("ColPrtXMLName", myary[11]);
			DHCWeb_SetListDefaultValue("UseINVType", myary[12], "^", 0);
			if (myary[13] == "N") {
				DHCWebD_SetObjValueA("InputOrdFlag", 0);
			} else {
				DHCWebD_SetObjValueA("InputOrdFlag", 1);
			}
			if (myary[14] == "Y") {
				DHCWebD_SetObjValueA("PrtListFlag", 1);
				var myobj = document.getElementById("btnPrtList");
				if (myobj) {
					DHCWeb_AvailabilityBtnA(myobj, PrtList_OnClick);
				}
			} else {
				DHCWebD_SetObjValueA("PrtListFlag", 0);
				DHCWeb_DisBtnA("btnPrtList");
			}
			DHCWebD_SetObjValueA("CardPayModeFlag", parseInt(myary[19]));
			DHCWebD_SetObjValueA("ReceiveFlag", parseInt(myary[20]));       //+2018-05-18 ZhYW 日结汇总接收
			DHCWebD_SetObjValueA("RegBillFlag", parseInt(myary[21]));       //2018-05-31 ZhYW 挂号医嘱跟收费医嘱一起结算?
		}
	}
	//Get Configed PayMode
	var encmeth = DHCWebD_GetObjValue("ReadCTPMEncryt");
	if (encmeth != "") {
		var myGSRowID = DHCWebD_GetObjValue("OPGSRowID");
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayMode", myGSRowID);
	}
	LoadLocDR_OnChange();
	//var myRecFlag=DHCWebD_GetObjValue("RecLocFlag");
	RecLocFlag_OnClick();
}

function PrtListFlag_OnClick() {
	var myFlag = DHCWebD_GetObjValue("PrtListFlag");
	if (myFlag) {
		var myobj = document.getElementById("btnPrtList");
		if (myobj) {
			DHCWeb_AvailabilityBtnA(myobj, PrtList_OnClick);
		}
	} else {
		DHCWeb_DisBtnA("btnPrtList");
	}
}

function PrtList_OnClick() {
	PrintListWindow("CP");
}

function PrintListWindow(myTaskType) {
	var myGSRowID = DHCWebD_GetObjValue("OPGSRowID");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPGCF.GroupPrintTask&TaskType=" + myTaskType + "&GSRowID=" + myGSRowID;
	var NewWin = open(lnk, "DHCOPGCF_GroupPrintTask", "scrollbars=yes,resizable=yes,top=200,left=150,width=730,height=460");
}

function Update_OnClick() {
	//update for DHC_OPGroupSettings  and DHC_OPGSPayMode
	var myGSRowID = DHCWebD_GetObjValue("OPGSRowID");
	var myGSInfo = BuildGSStr();
	var myPMInfo = BulidPMInfo();
	var myRLInfo = "";
	var encmeth = DHCWebD_GetObjValue("UpdateGSEncrypt");
	if (encmeth != "") {
		var updateRtn = cspRunServerMethod(encmeth, myGSRowID, myGSInfo, myPMInfo, myRLInfo);
		var myAry = updateRtn.split('^');
		var rtn = myAry[0];
		if (+rtn == 0) {
			alert(t["SaveOK"]);
			window.close();
		} else {
			alert('保存失败');
		}
	}
}

function UpdateRecLoc_OnClick() {
	var myRecStr = BuildRecStr();
	var myGSRowID = DHCWebD_GetObjValue("OPGSRowID");
	var obj = document.getElementById("LoadLocDR");
	if (obj) {
		var myIdx = obj.selectedIndex;
		var myLR = obj.options[myIdx].value;
	}
	var encmeth = DHCWebD_GetObjValue("UpdateRLEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, myGSRowID, myLR, myRecStr);
		if (rtn == "0") {
			alert(t["SaveOK"]);
		}
	}
}

function RecLocFlag_OnClick() {
	var myRecFlag = DHCWebD_GetObjValue("RecLocFlag");
	if (myRecFlag) {
		var obj = document.getElementById("UpdateRecLoc");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, UpdateRecLoc_OnClick);
		}
		var obj = document.getElementById("LoadLocDR");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, "");
		}
		var obj = document.getElementById("RecLocDR");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, "");
		}
		var obj = document.getElementById("UnSelLocList");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, "");
		}
		var obj = document.getElementById("Add");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Add_Click);
		}
		var obj = document.getElementById("Delete");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, Delete_Click);
		}
	} else {
		var obj = document.getElementById("UpdateRecLoc");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("LoadLocDR");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("RecLocDR");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("UnSelLocList");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("Add");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("Delete");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
	}
}

function Add_Click() {
	TransListData("UnSelLocList", "RecLocDR");
}

function Delete_Click() {
	TransListData("RecLocDR", "UnSelLocList");
}

function TransListData(SName, TName) {
	var sobj = document.getElementById(SName);
	var tobj = document.getElementById(TName);
	var myIdx = sobj.options.selectedIndex;
	if (myIdx >= 0) {
		var myoptobj = sobj.options[myIdx];
		var myListIdx = tobj.length;
		tobj.options[myListIdx] = new Option(myoptobj.text, myoptobj.value);
		sobj.options[myIdx] = null;
		if ((myIdx + 1) < sobj.options.length) {
			sobj.options[myIdx].selected = true;
		} else {
			sobj.options[myIdx - 1].selected = true;
		}
	}
}

function BuildRecStr() {
	var myRecStr = "";
	var obj = document.getElementById("RecLocDR");
	if (obj) {
		var nCount = obj.options.length;
		for (var i = 0; i < nCount; i++) {
			if (myRecStr == "") {
				myRecStr = obj.options[i].value;
			} else {
				myRecStr = myRecStr + String.fromCharCode(2) + obj.options[i].value;
			}
		}
	}
	return myRecStr;
}

function BuildRecStrOld() {
	var myRecStr = "";
	var obj = document.getElementById("RecLocDR");
	if (obj) {
		var nCount = obj.options.length;
		for (var i = 0; i < nCount; i++) {
			if (obj.options[i].selected) {
				if (myRecStr == "") {
					myRecStr = obj.options[i].value;
				} else {
					myRecStr = myRecStr + String.fromCharCode(2) + obj.options[i].value;
				}
			}
		}
	}
	return myRecStr;
}

function BuildGSStr() {
	var myGSStr = "";
	var myFootFlag = DHCWebD_GetObjValue("FootFlag");
	if (myFootFlag) {
		myFootFlag = 1;
	} else {
		myFootFlag = 0;
	}
	var myPrtINVFlag = DHCWebD_GetObjValue("PrtINVFlag");
	if (myPrtINVFlag) {
		myPrtINVFlag = 1;
	} else {
		myPrtINVFlag = 0;
	}
	var myRecLocFlag = DHCWebD_GetObjValue("RecLocFlag");
	if (myRecLocFlag) {
		myRecLocFlag = 1;
	} else {
		myRecLocFlag = 0;
	}
	var myAbortFlag = DHCWebD_GetObjValue("AbortFlag");
	if (myAbortFlag) {
		myAbortFlag = 1;
	} else {
		myAbortFlag = 0;
	}
	var myRefundFlag = DHCWebD_GetObjValue("RefundFlag");
	if (myRefundFlag) {
		myRefundFlag = 1;
	} else {
		myRefundFlag = 0;
	}
	var myOPGSRowID = DHCWebD_GetObjValue("GPRowID");
	var myPrtXMLName = DHCWebD_GetObjValue("PrtXMLName");
	var myColPrtXMLName = DHCWebD_GetObjValue("ColPrtXMLName");
	var myUseINVType = DHCWeb_GetListBoxValue("UseINVType");
	var myInputOrdFlag = DHCWebD_GetObjValue("InputOrdFlag");
	if (myInputOrdFlag) {
		myInputOrdFlag = "Y";
	} else {
		myInputOrdFlag = "N";
	}

	var myFlag = DHCWebD_GetObjValue("PrtListFlag");
	if (myFlag) {
		var myPrtListFlag = "Y";
	} else {
		var myPrtListFlag = "N";
	}
	var myColPrtListFlag = "N";

	var myCardPayModeFlag = DHCWebD_GetObjValue("CardPayModeFlag");
	if (myCardPayModeFlag) {
		myCardPayModeFlag = 1;
	} else {
		myCardPayModeFlag = 0;
	}
	//+2018-05-18 ZhYW 日结汇总接收
	var myReceiveFlag = DHCWebD_GetObjValue("ReceiveFlag");
	if (myReceiveFlag) {
		myReceiveFlag = 1;
	} else {
		myReceiveFlag = 0;
	}
	//+2018-05-31 ZhYW 挂号医嘱跟收费医嘱一起结算?
	var myRegBillFlag = DHCWebD_GetObjValue("RegBillFlag");
	if (myRegBillFlag) {
		myRegBillFlag = 1;
	} else {
		myRegBillFlag = 0;
	}

	myGSStr = myFootFlag + "^" + myRecLocFlag + "^" + myPrtINVFlag + "^^^";
	myGSStr = myGSStr + myAbortFlag + "^" + myRefundFlag + "^" + myOPGSRowID;
	myGSStr = myGSStr + "^" + myPrtXMLName + "^" + myColPrtXMLName + "^" + myUseINVType;
	myGSStr = myGSStr + "^" + myInputOrdFlag + "^" + myPrtListFlag + "^" + myColPrtListFlag;
	myGSStr = myGSStr + "^" + myCardPayModeFlag + "^" + myReceiveFlag + "^" + myRegBillFlag;

	return myGSStr;
}

function BulidPMInfo() {
	//myPMInfo=PM_CTPM_DR^PM_RowID^PM_DefaultFlag^PM_INVPrtFlag^PM_RPFlag
	var myPMStr = "";
	var myrows = DHCWeb_GetTBRows("tDHCOPGCF_GroupSet");
	for (var i = 1; i <= myrows; i++) {
		var myobj = document.getElementById("PMSelectz" + i);
		var mysel = DHCWebD_GetCellValue(myobj);
		if (mysel) {
			var myobj = document.getElementById("CTPMRowID" + "z" + i);
			var myCTPMRowID = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMGSRowID" + "z" + i);
			var myPMGSRowID = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMDefault" + "z" + i);
			var myPMDefault = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMPrintFlag" + "z" + i);
			var myPMPrintFlag = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMRPFlag" + "z" + i);
			var myPMRPFlag = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMPDFlag" + "z" + i);
			var myPMPDFlag = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMOPCFlag" + "z" + i);
			var myPMOPCFlag = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMOPRegFlag" + "z" + i);
			var myPMOPRegFlag = DHCWebD_GetCellValue(myobj);
			var myobj = document.getElementById("PMOPRefundFlag" + "z" + i);
			var myPMOPRefundFlag = DHCWebD_GetCellValue(myobj);
			var myInfo = myCTPMRowID + "^" + myPMGSRowID + "^" + myPMDefault + "^" + myPMPrintFlag;
			var myInfo = myInfo + "^" + myPMRPFlag + "^" + myPMPDFlag + "^" + myPMOPCFlag;
			var myInfo = myInfo + "^" + myPMOPRegFlag + "^" + myPMOPRefundFlag;
			if (myPMStr == "") {
				myPMStr = myInfo;
			} else {
				myPMStr = myPMStr + String.fromCharCode(2) + myInfo;
			}
		}
	}
	return myPMStr;
}

function LoadLocDR_OnChange() {
	//Reload  RecCTLoc List  Box
	var obj = document.getElementById("LoadLocDR");
	if (obj) {
		var myIdx = obj.selectedIndex;
		var myLoadStr = obj.options[myIdx].value;
		var myary = myLoadStr.split("^");
		var myLoadRID = myary[0];
		DHCWebD_ClearAllListA("RecLocDR");
		DHCWebD_ClearAllListA("UnSelLocList");
		var myGRRowID = DHCWebD_GetObjValue("OPGSRowID");
		//Load CT_Loc LIST
		var encmeth = DHCWebD_GetObjValue("ReadRecListEncrypt");
		if (encmeth != "") {
			var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "RecLocDR", myGRRowID, myLoadRID);
		}
		var encmeth = DHCWebD_GetObjValue("ReadUnSelRecListEncrypt");
		if (encmeth != "") {
			var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "UnSelLocList", myGRRowID, myLoadRID);
		}
	}
}

function ClrSelect(ListName) {
	//Clear ListBox Selected
	var obj = document.getElementById(ListName);
	if (obj) {
		var nCount = obj.options.length;
		for (var i = 0; i < nCount; i++) {
			obj.options[i].selected = false;
		}
	}
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-09-30
 */
function SetGroupTabs_OnClick() {
	var GSRowId = DHCWebD_GetObjValue("OPGSRowID");
	if (GSRowId == "") {
		return;
	}
	var url = "dhcbill.grouptabsconfig.csp?GSRowId=" + GSRowId;
	websys_createWindow(url, "_blank", "width=450px,height=500px");
}

function BodyUnLoadHandler() {
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;