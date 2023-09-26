///DHCOPPatQFInfo.js

var SelectedRow = -1;
var PrtXMLName;
var m_SelectCardTypeDR;
var m_CardNoLength;
var RestoreList = new Array();
var m_YBConFlag = "0";
var Guloc;
var myUserID;
var LocID;
var InsuAdmTypeCode = "";
var InsuSYTypeCode = "";

function BodyLoadHandler() {
	ValidateDocumentData();
	PrtXMLName = "INVPrtFlag2007";
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
	IntDocument();
	var obj = document.getElementById("PayMode1");
	if (obj) {
		obj.multiple = false;
		obj.size = 1;
		obj.onchange = PayMode1_OnChange;
	}
	/*
	var obj = document.getElementById("PayMode2");
	if (obj){
		obj.multiple = false;
		obj.size = 1;
	}
	var obj = document.getElementById("PayMode3");
	if (obj){
		obj.multiple = false;
		obj.size = 1;
	}
	*/
	var obj = document.getElementById("RegNo");
	if (obj) {
		obj.onkeydown = PatientNoKeyDown;
	}
	var obj = document.getElementById("Restore");
	if (obj) {
		obj.onclick = Restore_OnClick;
	}
	var myobj = document.getElementById("AllSelect");
	if (myobj) {
		myobj.onclick = AllSelect_OnClick;
	}
	var obj = document.getElementById("PaySum1");
	if (obj) {
		obj.onkeydown = PaySumOnkeyDown;
		obj.onblur = PaySumOnChange;
	}
	var obj = document.getElementById("PaySum2");
	if (obj) {
		obj.onkeydown = PaySumOnkeyDown;
		obj.onblur = PaySumOnChange;
	}
	var obj = document.getElementById("PaySum3");
	if (obj) {
		obj.readOnly = true;
	}
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
	}
	var obj = document.getElementById("ReadPCSC");
	if (obj) {
		obj.onclick = ReadHFMagCard_Click;
	}
	var obj = document.getElementById("RCardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = RCardNo_KeyDown;
		}
	}
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.readOnly = true;
	}
	CardTypeDefine_OnChange();
	initForm();
	GetReceiptNo();
	var obj = document.getElementById("InsTypeList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = InsTypeList_OnChange;
	}
	document.onkeydown = document_OnKeyDown;
}

function PaySumOnChange() {
	var Paysum1 = document.getElementById("PaySum1").value;
	if ((isNaN(Paysum1)) || (Paysum1 == "")) {
		Paysum1 = 0;
	}
	var Paysum2 = document.getElementById("PaySum2").value;
	if ((isNaN(Paysum2)) || (Paysum2 == "")) {
		Paysum2 = 0;
	}
	var Tot = document.getElementById('Total').value;
	Tot = parseFloat(Tot);
	Paysum1 = parseFloat(Paysum1);
	Paysum2 = parseFloat(Paysum2);
	if (Paysum1 < 0) {
		document.getElementById("PaySum1").value == "";
		return;
	}
	if (Paysum2 < 0) {
		document.getElementById("PaySum2").value == "";
		return;
	}
	var remainsum = Tot - Paysum1 - Paysum2;
	remainsum = remainsum.toFixed(2);
	document.getElementById("PaySum3").value = remainsum;
}

function PaySumOnkeyDown() {
	var key = event.keyCode;
	if (key == 13) {
		PaySumOnChange();
	}
}

function initForm() {
	var TotalAmt = 0;
	var tabOPList = document.getElementById('tDHCOPPatQFInfo');
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var sSelect = document.getElementById('Tselectz' + row);
		var ResAmt = document.getElementById('Acountz' + row).innerText;
		if (sSelect.checked) {
			RestoreList[row] = 1;
			TotalAmt = TotalAmt + ResAmt;
		} else {
			RestoreList[row] = 0;
		}
	}
	var obj = document.getElementById('Total');
	if (obj) {
		obj.value = TotalAmt;
	}
	var obj = document.getElementById('PaySum3');
	if (obj) {
		obj.value = TotalAmt;
	}
	DHCWebD_ClearAllListA("PayMode1");
	//DHCWebD_ClearAllListA("PayMode2");
	//DHCWebD_ClearAllListA("PayMode3");
	var encmeth = DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc = session['LOGON.GROUPID'];
	//var myInsType = DHCWebD_GetObjValue("INSDR");
	var myInsType = "";
	var myExpStr = "";
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayMode1", mygLoc, myInsType, myExpStr);
		//var rtn = cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode2",mygLoc, myInsType, myExpStr);
		//var rtn = cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode3",mygLoc, myInsType, myExpStr);
	}

}

function AllSelect_OnClick() {
	var selflag = document.getElementById("AllSelect").checked;
	var tabOPList = document.getElementById('tDHCOPPatQFInfo');
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var sSelect = document.getElementById('Tselectz' + row);
		sSelect.checked = selflag;
		var ResAmt = document.getElementById('Acountz' + row).innerText;
		if (sSelect.checked) {
			RestoreList[row] = 1;
			TotalAmt = TotalAmt + ResAmt;
		} else {
			RestoreList[row] = 0;
		}
	}
	var obj = document.getElementById('Total');
	if (obj) {
		obj.value = TotalAmt;
	}
	var obj = document.getElementById('PaySum3');
	if (obj) {
		obj.value = TotalAmt;
	}
}

function Restore_OnClick() {
	if ($V('ReceiptNO') == "") {
		alert(t['NullReceiptNO']);
		return;
	}
	//var ResPrtStr = GetPrtStr();
	var PayMListStr = GetPayMList();
	/*
	if ((ResPrtStr == "") || (PayMList == ""))  {
		return;
	}
	*/
	var PayMListStr1 = PayMListStr.split(String.fromCharCode(2));
	var PayMList = PayMListStr1[0];
	var PayMSum = PayMListStr1[1];
	if ((PayMSum == " ") || (PayMSum == "")) {
		PayMSum = 0;
	}
	if (isNaN(PayMSum)) {
		PayMSum = 0;
	}
	var InvRowidobj = document.getElementById('InvRowid');
	var InvRowid = InvRowidobj.value;
	if ((InvRowid == " ") || (InvRowid == "")) {
		alert("请选择要补交的发票记录");
		return;
	}
	var Guloc = session['LOGON.GROUPID'];
	//var myUserID = session['LOGON.USERID'];
	var LocID = session['LOGON.CTLOCID'];
	var Tot = document.getElementById('Total').value;
	//取选中的新的费别,并且根据费别取admsource判断是否需要调用医保接口
	var InsList = document.getElementById("InsTypeList");
	var InsIndex = InsList.selectedIndex;
	NewInsType = InsList.options[InsIndex].value;
	var CurInsType = DHCWebD_GetObjValue("InsTypeDr");
	if ((CurInsType != NewInsType) && (NewInsType != "")) {
		var myrtn = window.confirm("重新收费的收费类别发生变化,是否确认退费?");
		if (!myrtn) {
			return myrtn;
		}
	}
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var AdmSource = cspRunServerMethod(encmeth, NewInsType);
	/*
	//+2017-06-14 ZhYW 标准版中医保就诊疗类别和生育类别先注释，项目上根据具体情况再放开，组件元素现为隐藏
	var GRZHSYBZobj = document.getElementById("GRZHSYBZ");
	if ((AdmSource != "") && (AdmSource != "0")) {
		var AKA130WHAobj = document.getElementById("AKA130WHA");
		if (AKA130WHAobj.value == "") {
			alert("医保就诊类别不能为空,请填写!");
			return;
		}
	}
	if (AdmSource == "3") {
		var INSUNHInfo = JudgeNHInfo();
		if ((INSUNHInfo == "") || (INSUNHInfo == " ")) {
			alert("农合病人请先读农合卡信息");
			return;
		}
	}
	*/
	var encmeth = DHCWebD_GetObjValue('Restoring');
	var rtnvalue = cspRunServerMethod(encmeth, InvRowid, PayMList, Tot, myUserID, LocID, Guloc, NewInsType);
	var rtn = rtnvalue.split("^");
	if (rtn[0] == "PayModeErr") {
		alert("不能选择欠费支付方式补回费用.");
		return;
	}
	if (rtn[0] == 0) {
		var myPLen = rtn.length;
		var mytmpary = new Array();
		for (var i = 1; i < myPLen; i++) {
			if (rtn[i] != "") {
				mytmpary[mytmpary.length] = rtn[i];
			}
		}
		var myPRTStr = mytmpary.join("^");
		//modifiy 2012-11-15 增加医保结算功能
		if ((m_YBConFlag == "1") && (AdmSource != "") && (AdmSource != "0")) {
			var myYBHand = "";
			var Guser = session['LOGON.USERID'];
			var myYBINS = AdmSource;
			var myCurrentInsType = CurInsType;
			if ((CurInsType != NewInsType) && (NewInsType != "")) {
				myCurrentInsType = NewInsType;       //按新费别调用医保接口
			}
			var StrikeFlag = "N";
			var GroupDR = session['LOGON.GROUPID'];
			var HospDR = session['LOGON.HOSPID'];
			var InsuNo = "";
			var CardType = "";
			var YLLB = "";
			var DicCode = "";
			var DicDesc = "";
			var DYLB = "";
			var LeftAmt = "";
			var ChargeSource = "01";
			var DBConStr = "";         //数据库连接串
			var MoneyType = "";
			var AccMRowId = "";
			var myCPPFlag = "";
			var SelPayMDR = "";
			var myExpStrYB = StrikeFlag + "^" + GroupDR + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
			myExpStrYB += "^" + LeftAmt + "^" + ChargeSource + "^" + DBConStr + "^" + DYLB + "^" + AccMRowId + "^" + HospDR + "^" + SelPayMDR  + "!" + LeftAmt + "^" + myMoneyType;
			var myYBrtn = DHCWebOPYB_DataUpdate(myYBHand, Guser, myPRTStr, myYBINS, myCurrentInsType, myExpStrYB, myCPPFlag);
			var myYBarry = myYBrtn.split("^");
			if (myYBarry[0] == "YBCancle") {
				//return;
			}
			if (myYBarry[0] == "HisCancleFailed") {
				alert("医保取消结算成功,但HIS系统取消结算失败,请和计算机室联系解决");
				//return;
			}
			window.status = "医保结算完成";
		}
		//2016-02-18 chenxi 增加确认完成功能
		//门诊收费确认完成
		var encmeth = DHCWebD_GetObjValue('CompleteChargeEncrypt');
		//对于退费重新的确认完成,扩展参数取不到时可以先传空,在类里取值。
		var gloc = session['LOGON.GROUPID'];
		var myUserLocID = session['LOGON.CTLOCID'];
		var TMPExpStr = gloc + "^" + myUserLocID + "^" + "" + "^" + "Y";
		var TMPExpStr = TMPExpStr + "^" + "";
		var TMPExpStr = TMPExpStr + "^" + "" + "^" + "" + "^" + "";
		var TMPExpStr = TMPExpStr + "^" + NewInsType;
		var rtn = cspRunServerMethod(encmeth, "3", myUserID, CurInsType, myPRTStr, "1", InvRowid, TMPExpStr);
		if (rtn != "0") {
			alert("确认完成失败.");
			return;
		}
		//alert("rtn="+rtn);
		alert("补交款成功,请注意打印发票.");
		BillPrintTaskListNew(rtnvalue);
		var Findobj = document.getElementById('Find');
		if (Findobj) {
			Findobj.click();
		}
	} else {
		alert(rtn[0] + "补交款失败,请重试.");
	}
}

function GetPrtStr() {
	var TotalAmt = 0;
	var PrtStr = "";
	var tabOPList = document.getElementById('tDHCOPPatQFInfo');
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var sSelect = document.getElementById('Tselectz' + row);
		var PrtID = document.getElementById('TPrtIDz' + row).innerText;
		var ResAmt = document.getElementById('Acountz' + row).innerText;
		ResAmt = parseFloat(ResAmt);
		if (sSelect.checked) {
			if (PrtStr == "") {
				PrtStr = PrtID;
			} else {
				PrtStr = PrtStr + "^" + PrtID;
			}
			TotalAmt = parseFloat(TotalAmt);
			TotalAmt = TotalAmt + ResAmt;
		}
	}

	var Tot = document.getElementById('Total').value;
	//alert(Tot+"^"+TotalAmt);
	if (Tot != TotalAmt) {
		alert("选中的补交记录总金额和界面金额不一致,请重点查询,重新操作一次");
		PrtStr = "";
	}
	return PrtStr;
}

function GetPayMList() {
	var PayAllSum = 0;
	var PayMStr = "";
	var PaySum = new Array();
	var Tot = document.getElementById('Total').value;
	Tot = parseFloat(Tot);
	var obj = document.getElementById('PaySum1');
	if (obj) {
		PaySum[1] = obj.value;
		if ((isNaN(PaySum[1])) || (PaySum[1] == "")) {
			PaySum[1] = 0;
		}
		PaySum[1] = parseFloat(PaySum[1]);
		PayAllSum = PayAllSum + PaySum[1]
	}
	var obj = document.getElementById('PaySum2');
	if (obj) {
		PaySum[2] = obj.value;
		if ((isNaN(PaySum[2])) || (PaySum[2] == "")) {
			PaySum[2] = 0;
		}
		PaySum[2] = parseFloat(PaySum[2]);
		PayAllSum = PayAllSum + PaySum[2];
	}
	var obj = document.getElementById('PaySum3');
	if (obj) {
		PaySum[3] = obj.value;
	}
	PaySum[3] = parseFloat(PaySum[3]);
	PayAllSum = PayAllSum + PaySum[3];
	if (PaySum[3] < 0) {
		alert("补交支付方式金额不能为负数");
		return "";
	}
	if (parseFloat(PayAllSum - Tot) != 0) {
		alert("支付总额和需补交金额不等,请重新确认支付金额");
		return "";
	}
	PayAllSum = 0;
	for (var i = 1; i < 4; i++) {
		if ((PaySum[i] == "") || (PaySum[i] == 0)) {
			continue;
		}
		var obj = document.getElementById("PayMode" + i);
		if (obj) {
			var myIdx = obj.selectedIndex;
			if (myIdx < 0) {
				alert("请选择支付方式");
				return "";
			}
			paysumx = document.getElementById('PaySum' + i).value;
			paysumx = parseFloat(paysumx);
			PayAllSum = parseFloat(PayAllSum);
			PayAllSum = PayAllSum + paysumx;
			var mypvalue = obj.options[myIdx].value;
			var myary = mypvalue.split("^");
			if (PayMStr == "") {
				PayMStr = myary[0] + "!!" + PaySum[i];
			} else {
				PayMStr = PayMStr + "^" + myary[0] + "!!" + PaySum[i];
			}
		}
	}
	if (parseFloat(PayAllSum - Tot) != 0) {
		alert("支付总额和需补交金额不等,请重新确认支付金额");
		return "";
	}
	return PayMStr;
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	Objtbl = document.getElementById('tDHCOPPatQFInfo');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var PaySum1obj = document.getElementById('PaySum1');
	var AdmSourceobj = document.getElementById('AdmSource');
	var InsTypeobj = document.getElementById('InsType');
	var InsTypeDrobj = document.getElementById('InsTypeDr');
	var TInsTypeDrobj = document.getElementById('TInsTypeDrz' + selectrow);
	var TAdmSourceobj = document.getElementById('TAdmSourcez' + selectrow);
	var TInsTypeobj = document.getElementById('TInsTypez' + selectrow);
	var Acountobj = document.getElementById('Acountz' + selectrow);
	var InvRowidobj = document.getElementById('InvRowid');
	var TPrtIDobj = document.getElementById('TPrtIDz' + selectrow);
	var Totalobj = document.getElementById('Total');
	var PaySum1obj = document.getElementById('PaySum1');
	var InsTypeList = document.getElementById('InsTypeList');
	var GRZHSYBZobj = document.getElementById("GRZHSYBZ");
	var MyInsType = document.getElementById("MyInsType");
	var PAPERDRobj = document.getElementById('PaperID');
	// var PatDr = PAPERDRobj.value;
	var PatDr = document.getElementById('TPatDrz' + selectrow).value;
	if (selectrow != SelectedRow) {
		var TInsType = TInsTypeobj.innerText;
		if (TInsType == " ") {
			TInsType = "";
		}
		InsTypeobj.value = TInsType;
		var TInsTypeDr = TInsTypeDrobj.value;
		if (TInsTypeDr == " ") {
			TInsTypeDr = "";
		}
		InsTypeDrobj.value = TInsTypeDr;
		var TAdmSource = TAdmSourceobj.value;
		if (TAdmSource == " ") {
			TAdmSource = "";
		}
		AdmSourceobj.value = TAdmSource;
		if (TAdmSource == "1") {
			GRZHSYBZobj.checked = true;
		}
		var Acount = Acountobj.innerText;
		if (Acount == " ") {
			Acount = 0;
		}
		if (isNaN(Acount)) {
			Acount = 0;
		}
		PaySum1obj.value = Acount;
		Totalobj.value = Acount;
		var TPrtID = TPrtIDobj.innerText;
		if (TPrtID == " ") {
			TPrtID = "";
		}
		InvRowidobj.value = TPrtID;
		MyInsType.value = TInsTypeDr;
		AddPrescTypeToList(PatDr);
		SelectedRow = selectrow;
	} else {
		SelectedRow = "-1";
		PaySum1obj.value = "";
		AdmSourceobj.value = "";
		InsTypeobj.value = "";
		InsTypeDrobj.value = "";
		InvRowidobj.value = "";
		Totalobj.value = "";
		GRZHSYBZobj.checked = false;
		MyInsType.value = "";
		InsTypeList.options.selectedIndex = 0;
	}

}

function BillPrintTaskListNew(INVstr) {
	var myOldXmlName = PrtXMLName;
	var myTaskList = DHCWebD_GetObjValue("ReadPrtList");
	var myary = myTaskList.split(String.fromCharCode(1));
	if (myary[0] == "Y") {
		BillPrintTaskList(myary[1], INVstr);
		PrtXMLName = myOldXmlName;
		DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);  //INVPrtFlag
	} else {
		BillPrintNew(INVstr);
	}
	PrtXMLName = myOldXmlName;
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		//not alert to Print
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			//+2017-06-02 ZhYW 根据实际发票的收费类别查找模板名称
			var tmpPrtXMLName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPrtXMLName", INVtmp[invi], "O", PrtXMLName);
			DHCP_GetXMLConfig("InvPrintEncrypt", tmpPrtXMLName);    //此处只修改调用模板, 不需要修改PrtXMLName
			//
			var beforeprint = document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {
				var encmeth = beforeprint.value;
			} else {
				var encmeth = '';
			}
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myPreDep = "";
			var myCharge = "";
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);

		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function BillPrintTaskList(PrtTaskStr, INVstr) {
	var myTListAry = PrtTaskStr.split(String.fromCharCode(2));
	for (var i = 0; i < myTListAry.length; i++) {
		if (myTListAry[i] != "") {
			var myStrAry = myTListAry[i].split("^");
			//myXmlName_"^"_myClassName_"^"_myMethodName_"^"_myPrintMode_"^"_HardEquipDR
			var myPrtXMLName = myStrAry[0];
			PrtXMLName = myPrtXMLName;
			var myClassName = myStrAry[1];
			var myMethodName = myStrAry[2];
			var myPrintMode = myStrAry[3];
			var myPrintDeviceDR = myStrAry[4];
			if ((myStrAry[3] == "") || (myStrAry[3] == "XML")) {
				if (myPrtXMLName != "") {
					DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);
					CommBillPrintNew(INVstr, myClassName, myMethodName);
				}
			} else if ((myStrAry[3] == "BC")) {
				OtherPrintDevice(INVstr, myClassName, myMethodName, myPrintDeviceDR);
			}
		}
	}
}

function CommBillPrintNew(INVstr, ClassName, MethodName) {
	var INVtmp = INVstr.split("^");
	//INVstr
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var beforeprint = document.getElementById('ReadCommOPDataEncrypt');
			if (beforeprint) {
				var encmeth = beforeprint.value;
			} else {
				var encmeth = '';
			}
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var myPreDep = "";
			var myCharge = "";
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = myPreDep + "^" + myCharge + "^" + myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", ClassName, MethodName, PrtXMLName, INVtmp[invi], sUserCode, PayMode, PrtXMLName);
		}
	}
}

function OtherPrintDevice(INVstr, ClassName, MethodName, PrintDeviceDR) {
	var myExpStr = "";
	var encmeth = DHCWebD_GetObjValue("ReadOPDataOtherDeviceEncrypt");
	if (encmeth != "") {
		var Printinfo = cspRunServerMethod(encmeth, "DHCWCOM_OtherPrintDeviceEquip", ClassName, MethodName, PrintDeviceDR, INVstr, myExpStr);
	}
}

function ValidateDocumentData() {
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split('^');
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		DHCWebD_SetObjValueB("RCardNo", myary[1]);
		DHCWebD_SetObjValueB("RegNo", myary[5]);
		ReadPatInfo();
		Find_click();
		break;
	case "-200":
		alert("此卡是无效卡");
		break;
	case "-201":
		DHCWebD_SetObjValueB("RCardNo", myary[1]);
		DHCWebD_SetObjValueB("RegNo", myary[5]);
		ReadPatInfo();
		Find_click();
		break;
	default:

	}
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	var myobj = websys_$("RCardNo");
	if (myary[16] == "Handle") {
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadPCSC");
	} else {
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = websys_$("ReadPCSC");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
	//Set Focu
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("RCardNo");
	} else {
		DHCWeb_setfocus("ReadPCSC");
	}
	m_CardNoLength = myary[17];
}

function PatientNoKeyDown() {
	var key = event.keyCode;
	if (key == 13) {
		ReadPatInfo();
		//AddPrescTypeToList(PAPERInfo1[2]);
		Find_click();
	}
}

function SetCardNOLengthForm() {
	var obj = document.getElementById('RCardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

function RCardNo_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13)) {
		SetCardNOLengthForm();
		var myCardNo = DHCWebD_GetObjValue("RCardNo");
		if (myCardNo == ""){
			return;
		}
		var mySecurityNo = "";
		//var myrtn = DHCACC_GetAccInfo();
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			DHCWebD_SetObjValueB("RCardNo", myary[1]);
			DHCWebD_SetObjValueB("RegNo", myary[5]);
			ReadPatInfo();
			Find_click();
			break;
		case "-200":
			alert("此卡是无效卡");
			break;
		case "-201":
			DHCWebD_SetObjValueB("RCardNo", myary[1]);
			DHCWebD_SetObjValueB("RegNo", myary[5]);
			ReadPatInfo();
			Find_click();
			break;
		default:
		}
		return;
	}
}

function GetReceiptNo() {
	var obj = document.getElementById('ReceiptNO');
	if (!obj) {
		return;
	}
	var Guser = session['LOGON.USERID'];
	var myPINVFlag = "Y";
	var myGroupDR = session['LOGON.GROUPID'];
	var myExpStr = Guser + "^" + myPINVFlag + "^" + myGroupDR;
	var encmeth = DHCWebD_GetObjValue('GetreceipNO');
	if (cspRunServerMethod(encmeth, "SetReceipNO", "", myExpStr) != '0') {
		//alert(t['05']);
		return;
	}
}

function SetReceipNO(value) {
	var myAry = value.split("^");
	var currNo = myAry[0];
	var leftNum = myAry[2];
	var title = myAry[4];
	var tipFlag = myAry[5];
	var receiptNo = title + currNo;
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.value = receiptNo;
	}
	//change the Txt Color
	if (tipFlag != "0") {
		obj.className = 'clsInvalid';
	}
	DHCWebD_SetObjValueA("INVLeftNum", leftNum);
}

function document_OnKeyDown() {
	DHCWeb_EStopSpaceKey();
	var keycode;
	var e = event ? event : (window.event ? window.event : null);
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if (keycode == 115) {    //F4
		/*
		var myOPPatinfo = parent.frames["udhcOPPatinfo"];
		if (myOPPatinfo) {
			myOPPatinfo.ReadHFMagCard_Click();
		}
		 */
		var ReadCard = document.getElementById("ReadPCSC");
		if (ReadCard) {
			ReadHFMagCard_Click();
		}
	}
}

function IntDocument() {
	Guloc = session['LOGON.GROUPID'];
	myUserID = session['LOGON.USERID'];
	LocID = session['LOGON.CTLOCID'];
	var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth);
		var myary = myrtn.split("^");
		m_YBConFlag = myary[12];
	}
}

function InsTypeList_OnChange() {
	//取选中的新的费别,并且根据费别取admsource判断是否需要调用医保接口
	var InsList = document.getElementById("InsTypeList");
	var InsIndex = InsList.selectedIndex;
	NewInsType = InsList.options[InsIndex].value;
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var AdmSource = cspRunServerMethod(encmeth, NewInsType);
	var GRZHSYBZobj = document.getElementById("GRZHSYBZ");
	if (AdmSource == "1") {
		GRZHSYBZobj.checked = true;
	}
	var MyInsType = document.getElementById("MyInsType"); //tangtao 2011-09-16
	MyInsType.value = NewInsType;
}

function ReadINSUNH_Click() {
	var myCurrentInsType = document.getElementById("MyInsType").value;
	if ((myCurrentInsType == "") || (myCurrentInsType == " ")) {
		alert("新农合病人收费类别不能为空!!");
		return;
	}
	var ReaCode = tkMakeServerCall("web.DHCBillCons11", "GetReaCode", myCurrentInsType);
	if ((ReaCode == "") || (ReaCode == " ")) {
		alert("新农合病人行政区号不能为空!!");
		return;
	}
	var NHReaCodeobj = document.getElementById("NHReaCode");
	NHReaCodeobj.value = ReaCode;
	var MzNhBXGSobj = document.getElementById("MzNhBXGS");
	MzNhBXGSobj.value = tkMakeServerCall("web.DHCINSUPort", "RtnDicCodeStrByDicBill1", "MzNhBXGS", ReaCode);
	ReaCode = ReaCode + "^";
	AsOrganID = ReaCode;
	var PapmiName3 = document.getElementById("PapmiName3").value;
	InsuId = PapmiName3;
	var NHINSUInfo = InsuReadCard(myCurrentInsType);
	if ((NHINSUInfo == "") || (NHINSUInfo == " ")) {
		alert("读农合卡返回失败!!");
		return;
	}
	var NHINSUInfo1 = NHINSUInfo.split("|");
	if (NHINSUInfo1[0] != "0") {
		alert("读农合卡返回失败!!");
		return;
	} else {
		var NHINSUInfo2 = NHINSUInfo1[1].split("^");
		var NHPersonNoobj = document.getElementById("NHPersonNo");
		NHPersonNoobj.value = NHINSUInfo2[0];
	}
}

function JudgeNHInfo() {
	var myCurrentInsType = document.getElementById("MyInsType").value;
	if ((myCurrentInsType == "") || (myCurrentInsType == " ")) {
		alert("病人收费类别不能为空!!");
		return "";
	}
	var PapmiName3 = document.getElementById("PapmiName3").value;
	var PatName = document.getElementById("PatientName").value;
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var admsource = cspRunServerMethod(encmeth, myCurrentInsType);
	var NHReaCode = document.getElementById("NHReaCode").value;
	var NHPersonNo = document.getElementById("NHPersonNo").value;
	var MzNhBXGS = document.getElementById("MzNhBXGS").value;
	if (admsource == "3") {
		if ((PapmiName3 == "") || (PapmiName3 == " ")) {
			alert("新农合病人农合证号不能为空!!");
			return "";
		}
		if ((PatName == "") || (PatName == " ")) {
			alert("新农合病人姓名不能为空!!");
			return "";
		}
		if ((NHReaCode == "") || (NHReaCode == " ")) {
			alert("新农合病人行政区划分不能为空!!");
			return "";
		}
		if ((NHPersonNo == "") || (NHPersonNo == " ")) {
			alert("新农合病人个人序号不能为空!!");
			return "";
		}
		if ((MzNhBXGS == "") || (MzNhBXGS == " ")) {
			alert("新农合报销公式ID不能为空!!");
			return "";
		}
		var Guloc = session['LOGON.GROUPID'];
		return NHReaCode + "^" + PapmiName3 + "^" + MzNhBXGS + "^" + PatName + "^" + NHPersonNo + "^" + "z49.101|肾透析" + "^" + "" + "^" + "00^21^^^N^" + Guloc;
	}
}

///医保就诊类别
function LookAKAWHA(Value) {
	var TmpValue = Value.split("^");
	InsuAdmTypeCode = TmpValue[1];
}

///医保组接口医保生育类别
function LookBearingTypeWHA(Value) {
	var TmpValue = Value.split("^");
	InsuSYTypeCode = TmpValue[1];
}

///Creator:yyx
///CreateDate:2009-09-16
///Function:  显示病人的费别
function AddPrescTypeToList(PatDr) {
	//PrescType_$C(2)_PrescType_$C(2)_....
	//PrescTypeName_"^"_PrescTypeIns
	//PrescType:
	//PrescType[0]		PrescTypeName
	//PrescType[1]		PrescTypeIns
	//PrescType[2]		PatInsType
	var CurInsType = DHCWebD_GetObjValue("InsTypeDr");
	var myExpStr = "";
	var encmeth = DHCWebD_GetObjValue('GetPatPresc');
	var PrescTypeStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var PrescType = PrescTypeStr.split("\002");
	var InsTypeList = document.getElementById('InsTypeList');
	InsTypeList.size = 1;
	InsTypeList.multiple = false;
	if (PrescType.length == 0) {
		return "";
	}
	var DefaultIndex = 0;
	for (i = 0; i < PrescType.length; i++) {
		PrescList = PrescType[i].split("^");
		var ListText = PrescList[0];
		var ListValue = PrescList[1];
		var PatInsType = PrescList[2];
		InsTypeList.options[i] = new Option(ListText, ListValue);
		if (CurInsType == ListValue) {
			DefaultIndex = i;
		}
	}
	InsTypeList.options[DefaultIndex].selected = true;
	var InsIndex = InsTypeList.selectedIndex;
	NewInsType = InsTypeList.options[InsIndex].value;
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var AdmSource = cspRunServerMethod(encmeth, NewInsType);
	var GRZHSYBZobj = document.getElementById("GRZHSYBZ");
	if (AdmSource == "1") {
		GRZHSYBZobj.checked = true;
	}
	var MyInsType = document.getElementById("MyInsType");     //tangtao 2011-09-16
	MyInsType.value = NewInsType;
}

function PayMode1_OnChange() {
	var obj = document.getElementById("PayMode1");
	if (obj) {
		if (obj.options.length == 0) {
			return;
		}
		var myIdx = obj.options.selectedIndex;
		if (myIdx == -1) {
			return;
		}
		var myary = obj.options[myIdx].value.split("^");
		if (myary[2] == "CPP") {
			alert("欠费补回不能使用预交金!");
			obj.options.selectedIndex = 0;
		} else if (myary[2] == "QF") {
			alert("欠费补回不能使用欠费!");
			obj.options.selectedIndex = 0;
		}
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-09-08
*/
function ReadPatInfo() {
	var RegNOObj = websys_$('RegNo');
	if ((RegNOObj) && (websys_trim(RegNOObj.value) != "")) {
		var encmeth = DHCWebD_GetObjValue('GetPAPERName');
		var PAPERInfo = cspRunServerMethod(encmeth, RegNOObj.value);
		if (PAPERInfo == "") {
			return;
		} else if (PAPERInfo == "PAPMINoNull") {
			alert("登记号不能为空.");
			return;
		} else if (PAPERInfo == "PAPMINull") {
			alert("未找到病人.");
			return;
		} else {
			var myAry = PAPERInfo.split('^');
			DHCWebD_SetObjValueB('RegNo', myAry[0]);
			DHCWebD_SetObjValueB('PatName', myAry[1]);
			DHCWebD_SetObjValueB('PaperID', myAry[2]);
			DHCWebD_SetObjValueB('PapmiName3', myAry[3]);
		}
	}
}

document.body.onload = BodyLoadHandler;