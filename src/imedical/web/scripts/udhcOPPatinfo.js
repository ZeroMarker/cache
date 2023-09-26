/// udhcOPPatinfo.js

var DOPInfo_ReadInfoType = 0;
var m_Version = "";
var m_CardNoLength = 0;
var m_SelectCardTypeDR = "";
var m_ReadCardFlag = 0;
var m_HospitalDr = session['LOGON.HOSPID'];
var BillByAdmSelected = true;
var m_CardAccountRelation = "";
var	m_CCMRowID = "";
var	m_ReadCardMode = "";

function BodyLoadHandler() {
	ValidateDocumentData();
	var obj = document.getElementById("PatientID");
	if (obj) {
		obj.onkeydown = PatientNoKeyDown;
		obj.style.imeMode = "disabled";
	}
	var obj = document.getElementById("BAdmQuery");
	if (obj) {
		obj.onclick = SelectOneAdm;
	}
	var obj = document.getElementById("CardQuery");
	if (obj) {
		obj.onclick = CardQuery_Click;
	}
	var obj = document.getElementById("RCardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = RCardNo_KeyDown;
		}
	}
	DHCWeb_DisBtnA("AccAddDeposit");

	var obj = document.getElementById("AdmDoc");
	if (obj) {
		obj.onkeydown = GetDocUserId;
	}
	var obj = document.getElementById("PAADMList");
	if (obj) {
		obj.onchange = SelectAdmFromList;
	}
	var obj = document.getElementById("InsTypeList");
	if (obj) {
		obj.onchange = SelectAdmInsList;
	}
	var ReloadFlag = document.getElementById("ReloadFlag");
	var SelectPatRowId = document.getElementById("SelectPatRowId");
	var SelectAdmRowId = document.getElementById("SelectAdmRowId");
	var obj = document.getElementById("ReadPCSC");
	if (obj) {
		//obj.onclick = ReadPCSC_Click;
		//obj.onclick = ReLoadDD;
		//obj.onclick = ReadMagCard_Click;
		obj.onclick = ReadHFMagCard_Click;
	}
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
	}
	var CardTypeobj = document.getElementById("CGetCardType");
	if (CardTypeobj) {
		CardTypeobj.style.visibility = "hidden";
	}
	var obj = document.getElementById('ld50536iCGetCardType');
	if (obj) {
		obj.style.visibility = "hidden";
	}
	// modify by tang 2006-08-05

	CardTypeDefine_OnChange();
	var obj = document.getElementById("PatClear");
	if (obj) {
		obj.onclick = PatClear_Click;
	}
	//
	DOPInfo_ReadInfoType = 0;
	var vReloadFlag = ReloadFlag.value;
	var vSelectPatRowId = SelectPatRowId.value;
	var vSelectAdmRowId = SelectAdmRowId.value;
	if (((vReloadFlag == "1") || (vReloadFlag == "3")) && (vSelectPatRowId != "") && (vSelectAdmRowId != "")) {
		SetDefCardType();   //+2018-06-12 ZhYW
		SetPatientDetail(vSelectPatRowId, vSelectAdmRowId);
		ReloadFlag.value = '0';
		SelectPatRowId.value = "";
		SelectAdmRowId.value = "";
	} else if ((vReloadFlag == '2')) {
		//LoadOPPayMode
		var obj = document.getElementById("BAdmQuery");
		//DHCWeb_DisBtn(obj);
		var obj = document.getElementById("ReadPCSC");
		DHCWeb_DisBtn(obj);
		var obj = document.getElementById("PatientID");
		DHCWeb_DisBtn(obj);
		var obj = document.getElementById("PatClear");
		DHCWeb_DisBtn(obj);
		DHCWeb_DisBtnA("CardQuery");
		ReadPatInfo();
	} else {
		DHCWeb_setfocus("RCardNo");
	}
	if (vReloadFlag == "3") {
		var obj = document.getElementById("BAdmQuery");
		//DHCWeb_DisBtn(obj);
		var obj = document.getElementById("ReadPCSC");
		DHCWeb_DisBtn(obj);
		var obj = document.getElementById("PatientID");
		DHCWeb_DisBtn(obj);
		var obj = document.getElementById("PatClear");
		DHCWeb_DisBtn(obj);
		DHCWeb_DisBtnA("CardQuery");
	}
	IntDocument();
	//document.onkeydown = document_OnKeyDown;
	document.onkeydown = DHCWeb_DocumentOnKeydown;
}

function document_OnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
}

function BodyUnLoadHandler() {
	var obj = document.getElementById("DelCalEncrypt");
	if (obj) {
		var myUser = session['LOGON.USERID'];
		var encmeth = obj.value;
		rtnvalue = (cspRunServerMethod(encmeth, myUser));
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
	var cookieCardTypeSelIndex = DHCBILL.getCookie("udhcOPPatinfo_CardTypeDefine_selectedIndex");
	if (cookieCardTypeSelIndex != "") {
		obj.selectedIndex = cookieCardTypeSelIndex;
	}
}

function IntDocument() {
	var sobj = document.getElementById("OrdItemStr");
	if (sobj) {
		sobj.value = "";
	}
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var obj = document.getElementById("AccAddDeposit");
	if ((obj) && (myAccRowID != "")) {
		DHCWeb_AvailabilityBtnA(obj, AccAddDeposit);
	}
}

function FootCalculate() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCashCal";
	var NewWin = open(lnk, "udhcOPCashCal", "scrollbars=no,resizable=no,top=200,left=150,width=530,height=460");
}

function SelectOneAdm() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPAdmFind&StDate=&DateTo=&PatientID=&PatName=&LocRowId=";
	var myPAPMINo = DHCWebD_GetObjValue("PatientID");
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPAdmFind&PatientID=" + myPAPMINo + "&CardNo=" + myCardNo;
	lnk += "&AccRowID=" + myAccRowID;
	var iHeight = 460;
	var iWidth = 1000;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置;
	var openObj = window;   //2018-05-29 ZhYW 解决在使用Modal Dialog的时候，弹出多个页面会导致页面新页面session丢失，需要重新login
	if (typeof(window.dialogArguments) == "object") {
		openObj = window.dialogArguments;
	}
	var NewWin = openObj.open(lnk, "udhcOPAdmFind", "status=yes,scrollbars=yes,resizable=yes,top=" + iTop + ",left=" + iLeft + ",width=" + iWidth + ",height=" + iHeight);
}

function GetPatientID() {
	var PatientID = document.getElementById('PatientID');
	if (PatientID) {
		return PatientID.value;
	} else {
		return "";
	}
}

function RCardNo_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13)) {
		var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
		switch (myDHCVersion) {
		case "7":
			var myTMPRCardNo = DHCWebD_GetObjValue("RCardNo");
			myTMPRCardNo = DHCWeb_replaceAll(myTMPRCardNo, ";", "");
			myTMPRCardNo = DHCWeb_replaceAll(myTMPRCardNo, "?", "");
			DHCWebD_SetObjValueB("RCardNo", myTMPRCardNo);
			break;
		}
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		//var myrtn=DHCACC_GetAccInfo();
		if((m_CardAccountRelation=="CA")||(m_CardAccountRelation=="CL")){
			var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "");
		}else{
			var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		}
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("AccRowID", myary[7]);
			var myAccRowID = DHCWebD_GetObjValue("AccRowID");
			if (myAccRowID != "") {
				var obj = document.getElementById("AccAddDeposit");
				if (obj) {
					DHCWeb_AvailabilityBtnA(obj, AccAddDeposit);
				}
			}
			DHCWebD_SetObjValueB("AccLeft", myary[3]);
			if (eval(myary[3]) > 0) {
				DHCWebD_SetObjValueC("CPPFlag", "CPP");
			}
			ReadPatInfo();
			//Account Can Pay
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			var myPAPMNo = myary[5];
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			ReadPatInfo();
			break;
		default:
			//alert("");
		}
		return;
	}
}

function PatCal_OnClick() {
	//Calculate the Payor
	FootCalculate();
	return;
}

function CardQuery_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
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
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		var obj = document.getElementById("CardNo");
		DHCWebD_SetListValueA(obj, myary[1]);
		SelectOneAdm();
		//ReadPatInfo();
		//Account Can Pay
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		alert(t["-200"]);
		SelectOneAdm();
		//ReadPatInfo();
		break;
	default:
		//alert("");
	}

}

function PatClear_Click() {
	//2015-08-25 Lid 清屏就诊记录解锁
	var unLockRtn = UnLockOPAdm("User.OEOrder");
	DHCWebD_IntFeeAll();
}

function ReadPCSC_Click() {
	var obj = document.getElementById("ClsPCSCard");
	if (obj) {
		var PCSNo = obj.ReadPCSVS();
	}
	if (PCSNo != "") {
		var myExpStr = "";
		var encmeth = DHCWebD_GetObjValue("ReadPatNo");
		var PatInfoStr = cspRunServerMethod(encmeth, PCSNo);
		var obj = document.getElementById("PatientID");
		obj.value = PatInfoStr;
		//event.keyCode = 13;
		//PatientNoKeyDown(event);
		DOPInfo_ReadInfoType = 1; //需要PCSC读取
		ReadPatInfo();
	} else {}
}

function ReadMagCard_Click() {
	var obj = document.getElementById("ClsHFCard");
	if (obj) {
		var rtn = obj.ReadMagCard("23");
	}
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	m_CCMRowID = myary[14];
	m_ReadCardMode = myary[16];
	m_CardAccountRelation= myary[24];
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("RCardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadPCSC");
	} else {
		var ReloadFlag = document.getElementById("ReloadFlag");
		var vReloadFlag = ReloadFlag.value;
		if ((vReloadFlag != "3") && (vReloadFlag != "2")) {
			var myobj = document.getElementById("RCardNo");
			if (myobj) {
				myobj.readOnly = true;
			}
			var obj = document.getElementById("ReadPCSC");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
			}
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("RCardNo");
	} else {
		DHCWeb_setfocus("ReadPCSC");
	}
	m_CardNoLength = myary[17];
	var selectedIndex = this.selectedIndex;
	DHCBILL.setCookie("udhcOPPatinfo_CardTypeDefine_selectedIndex", selectedIndex, 31);
}

function SetCardNOLength() {
	var obj = document.getElementById('RCardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
		var myCardobj = document.getElementById('CardNo');
		if (myCardobj) {
			myCardobj.value = obj.value;
		}
	}
}

function PatientNoKeyDown(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	//var PatientID = websys_getSrcElement(e);
	DOPInfo_ReadInfoType = 0;
	if (key == 13) {
		//Add Clear Scr
		ClrScr();
		var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
		switch (myDHCVersion) {
		case "4":
			//NB  IF
			GetPmino();
			break;
		default:
			ReadPatInfo();
		}
	}

}

function ReadPatInfo() {
	var PatientID = document.getElementById("PatientID");
	if ((PatientID) && (PatientID.value != "")) {
		var PatNo = PatientID.value;
		var myExpStr = "";
		var encmeth = DHCWebD_GetObjValue('GetPAPMI');
		var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
		if (PatDr == "") {
			alert(t['RegNoError']);
			PatientID.className = 'clsInvalid';
			websys_setfocus('PatientID');
			return websys_cancel();
		} else {
			PatientID.className = 'clsvalid';
		}
		//
		var AdmStr = "";
		SetPatientDetail(PatDr, AdmStr);
		var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
		switch (myDHCVersion) {
		case "3":
			DHCWeb_setfocus("AdmDoc");
			break;
		case "10":
			//zlyy
			DHCWeb_OtherDocsetfocus("DHCOPOEOrdInput", "OPOrdItemDesc");
			break;
		default:
			//DHCWeb_setfocus("ReadPCSC");
			break;
		}
	}
}

function ReadAccFNoCard() {
	//Control  Operate  by SX
	//zhaocz   2006-07-23
	m_Version = DHCWebD_GetObjValue("DHCVersion")
		switch (m_Version) {
		case "3":
			//SXDT Three Hospital
			var myPAPMINo = DHCWebD_GetObjValue("PatientID");
			var myrtn = DHCACC_GetAccInfoFNoCard(myPAPMINo, myPAPMINo);
			var myary = myrtn.split("^");
			var rtn = myary[0];
			switch (rtn) {
			case "0":
				var obj = document.getElementById("CardNo");
				DHCWebD_SetListValueA(obj, myary[1]);
				DHCWebD_SetObjValueC("CPPFlag", "CPP");
				break;
			default:
				DHCWebD_SetObjValueC("CPPFlag", "");
			}
			break;
		default:
		}
}

function ClrScr() {
	DHCWebD_SetObjValueA("CardNo", "");
	DHCWebD_SetObjValueA("AccLeft", "");
	DHCWebD_SetObjValueA("AccType", "");
	DHCWebD_SetObjValueA("RCardNo", "");
}

function SetPatientDetail(PatDr, AdmStr) {
	IntDocument();
	SetPatientInfo(PatDr);
	ReadAccFNoCard();
	var PatientID = document.getElementById('PatientID');
	if (AdmStr == "") {
		AdmStr = GetAdmStr(PatDr);
	}
	if (AdmStr == "") {
		alert(t['PatientNoEpisode']);
		PatientID.className = 'clsInvalid';
		InitOEList();
		InitOECharge();
		InitAdmList();
		InitInsTypeList();
		InitOPPatInfo();
		//websys_setfocus('PatientID');
		websys_setfocus('RCardNo');
		return websys_cancel();
	}
	AddPrescTypeToList(PatDr, AdmStr);
	SetAdmInfoToList(AdmStr);
	//Lid 2011-05-07 调用平台组接口插入试管信息
	var admStr = ReadAdmListStr();
	var myGroupDr = session['LOGON.GROUPID'];
	var curloc = session['LOGON.CTLOCID'];
	var myrtn = tkMakeServerCall("web.DHCOPAdmFind", "GetOeditemInfoByAdm", admStr, curloc);
	if (myrtn == "-1") {
		alert("请手工录入试管费!");
	}
	InitChargeInsuType(PatDr);
	//var AdmListIndex = 0;
	var AdmList = document.getElementById("PAADMList");
	var AdmListIndex = AdmList.selectedIndex;
	SelectFromAdmList(AdmListIndex);
	UpdateCharge();
	ShowAccDetails(); //yyx 2010-07-07
	ReadLimitOrdStr(AdmStr);
	//Read Account Info
	//var encmeth = DHCWebD_GetObjValue('GetSkinRtnFlag');
	//var SkinRtnFlag = cspRunServerMethod(encmeth,AdmStr);
	var SkinRtnFlag = tkMakeServerCall("web.DHCOPCashier", "GetSkinRtnFlag", AdmStr);
	if (SkinRtnFlag == "Y") {
		alert("此病人有未作皮试医嘱,请先做皮试");
	}
}

function ReadAdmListStr() {
	var myAdmStr = "";
	var myAry = new Array();
	var AdmList = document.getElementById("PAADMList");
	//var AdmIndex = AdmList.selectedIndex;
	var mylen = AdmList.options.length;
	for (var myIdx = 0; myIdx < mylen; myIdx++) {
		var AdmStrArry = AdmList.options[myIdx].value.split("^");
		myAry[myIdx] = AdmStrArry[0];
	}
	myAdmStr = myAry.join("^");
	return myAdmStr;
}

function ReadLimitOrdStr(AdmStr) {
	var encmeth = DHCWebD_GetObjValue("ReadLOrdItmEncrypt");
	var mygloc = session['LOGON.GROUPID'];
	var myULoadDR = session['LOGON.CTLOCID'];
	var InsList = document.getElementById("InsTypeList");
	var InsIndex = InsList.selectedIndex;
	var InsType = InsList.options[InsIndex].value;
	//alert(InsType);
	var myStr = cspRunServerMethod(encmeth, AdmStr, InsType, mygloc, myULoadDR);
	var myary = myStr.split(String.fromCharCode(3));
	DHCWebD_SetObjValueA("LimitOrdItmStr", myary[0]);
	DHCWebD_SetObjValueA("OrdItemStr", myary[1]);
	//alert(myStr);
	return;
}

function SelectFromAdmList(AdmListIndex) {
	var PAAdmList = document.getElementById('PAADMList');
	if (PAAdmList.options.length > 0) {
		PAAdmList.options[AdmListIndex].selected = true;
		var SelectedAdmStr = PAAdmList.options[AdmListIndex].value;
		var SelectAdm = SelectedAdmStr.split("^");
		var AdmLoc = document.getElementById('AdmLoc');
		var AdmDate = document.getElementById('AdmDate');
		var Adm = SelectAdm[0];
		var AdmReason = GetCurrentInsType();
		AdmLoc.value = PAAdmList.options[AdmListIndex].text;
		AdmDate.value = SelectAdm[2];
		var myAdmDocName = SelectAdm[4];
		var myAdmDocID = SelectAdm[5];
		SetDocUserId(myAdmDocName + "^" + myAdmDocID);
		AddOrdItemToTable(Adm, AdmReason);
		AddAdmListToInput(Adm, AdmReason);
	}
}

function GetCurrentInsType() {
	var CurrentInsType = "";
	var InsTypeList = document.getElementById('InsTypeList');
	for (i = 0; i < InsTypeList.options.length; i++) {
		if (InsTypeList.options[i].selected == true) {
			CurrentInsType = InsTypeList.options[i].value;
			break;
		}
	}
	if (CurrentInsType == "") {
		CurrentInsType = InsTypeList.options[0].value;
		InsTypeList.options[0].selected == true;
	}
	return CurrentInsType;
}

function AddPrescTypeToList(PatDr, AdmStr) {
	//PrescType_$C(2)_PrescType_$C(2)_....
	//PrescTypeName_"^"_PrescTypeIns
	//PrescType:
	//PrescType[0]		PrescTypeName
	//PrescType[1]		PrescTypeIns
	//PrescType[2]		PatInsType
	//
	var myExpStr = session['LOGON.GROUPID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.USERID'] + "^^"; //Lid 2010-11-22
	var encmeth = DHCWebD_GetObjValue('GetPatPresc');
	var PrescTypeStr = cspRunServerMethod(encmeth, PatDr, AdmStr, myExpStr);
	var PrescType = PrescTypeStr.split("\002");
	var InsTypeList = document.getElementById('InsTypeList');
	InsTypeList.options.length = 0;
	if (PrescType.length == 0) {
		return "";
	}
	var DefaultIndex = 0;
	for (i = 0; i < PrescType.length; i++) {
		PrescList = PrescType[i].split("^");
		var ListText = PrescList[0];
		var ListValue = PrescList[1];
		var PatInsType = PrescList[2];
		option = document.createElement("option");
		option.value = ListValue;
		option.text = ListText;
		InsTypeList.add(option);
		if (PatInsType == ListValue) {
			DefaultIndex = i;
		}
	}
	InsTypeList.options[DefaultIndex].selected = true;
}

function SetPatientInfo(PatDr) {
	var myExpStr = "";
	var encmeth = DHCWebD_GetObjValue('GetPatInfo');
	var PatInfoStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var PatInfo = PatInfoStr.split("^");
	//
	//PatInfo[0]		PAPMI_RowId
	//PatInfo[1]		PAPMI_NO
	//PatInfo[2]		PatientName
	//PatInfo[3]		PatientSex
	//PatInfo[4]		AgeDesc
	//PatInfo[5]		PatientBirthday
	//PatInfo[6]		Patient Social Status
	//PatInfo[7]		Patient Social Staus DR
	//PatInfo[8]		Patient Sex Dr
	//PatInfo[9]		PatientDOB
	//PatInfo[10]		PatientCompany
	//PatInfo[11]		AgeYear
	//PatInfo[12]		AgeMonth
	//PatInfo[13]		AgeDay
	//PatInfo[14]		Patient Company Address
	//PatInfo[15]		EmployeeNO
	//PatInfo[16]		PatientMarital
	//PatInfo[17]		PatCategoryRowId
	//PatInfo[18]		Medcare
	//
	var PatDetailinfo = document.getElementById('PatDetailinfo');
	var PARowid = document.getElementById('PARowid');
	var PatientID = document.getElementById('PatientID');
	var PatName = document.getElementById('PatName');
	var PatSex = document.getElementById('PatSex');
	var PatAge = document.getElementById('PatAge');
	//
	PatDetailinfo.value = PatInfoStr;
	PARowid.value = PatInfo[0];
	PatientID.value = PatInfo[1];
	PatName.value = PatInfo[2];
	PatSex.value = PatInfo[3];
	PatAge.value = PatInfo[4];
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.value = PatInfo[22];
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.value = PatInfo[23];
	}
	var QFTotal = PatInfo[21];    //add by zhl 20110704  门诊结算时提示病人欠费总额
	if (eval(QFTotal) != 0) {
		alert("此病人共欠费" + QFTotal + "元,请注意收款。");
		return;
	}
}

function GetAdmStr(PatDr) {
	var encmeth = DHCWebD_GetObjValue('GetAdmStr');
	var myExpStr = session['LOGON.CTLOCID'];
	var AdmStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	return AdmStr;
}

function SetAdmInfoToList(AdmStr) {
	//AdmDetail_$C(2)_AdmDetail_$C(2)_....
	//AdmDetail:
	//AdmDetail[0]		AdmDocDept
	//AdmDetail[1]		Adm
	//AdmDetail[2]		MRADM
	//AdmDetail[3]		AdmDateDesc
	//AdmDetail[4]		AdmDept
	//AdmDetail[5]		AdmDoc
	//AdmDetail[6]		AdmDocName
	//AdmDetail[7]		AdmReason
	//AdmDetail[8]		TotalShare
	//AdmDetail[9]		PatientShare

	//清屏就诊记录解锁
	var unLockRtn = UnLockOPAdm("User.OEOrder");
	var myExpStr = m_HospitalDr;
	var encmeth = DHCWebD_GetObjValue('GetAdmInfo');
	var AdmDetailStr = cspRunServerMethod(encmeth, AdmStr, myExpStr);
	var AdmDetail = AdmDetailStr.split("\002");
	var defaultSelectIndex = 0;
	var boolSelectFlag = false;
	var PAAdmList = document.getElementById('PAADMList');
	PAAdmList.options.length = 0;
	if (AdmDetail.length == 0) {
		return "";
	}
	for (i = 0; i < AdmDetail.length; i++) {
		AdmList = AdmDetail[i].split("^");
		var AdmListText = AdmList[0];
		var AdmListValue = AdmList[1] + "^" + AdmList[2] + "^" + AdmList[3];
		AdmListValue = AdmListValue + "^" + AdmList[4] + "^" + AdmList[5] + "^" + AdmList[6];
		AdmListValue = AdmListValue + "^" + AdmList[7] + "^" + AdmList[8] + "^" + AdmList[9];
		option = document.createElement("option");
		option.value = AdmListValue;
		option.text = AdmListText;
		if ((+AdmList[8] > 0) && (!boolSelectFlag)) {
			option.selected = true;
			defaultSelectIndex = i;
			boolSelectFlag = true;
		}
		PAAdmList.add(option);
	}
	if (!boolSelectFlag) {
		PAAdmList.selectedIndex = defaultSelectIndex;
	}
	dispalyPAAdmListColor();
	dispalyInsTypeColor();
}

function AddOrdItemToTable(Adm, AdmReason) {
	var sobj = document.getElementById('OrdItemStr');
	var myunbillstr = "";
	if (sobj) {
		//var myary = PAAdmList.selectedIndex;
		myunbillstr = "^" + sobj.value + "^";
		var myary = myunbillstr.split(String.fromCharCode(2));
		myunbillstr = myary.join("~");
	}
	var mygLoc = session['LOGON.GROUPID'];
	var myUloadDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEList&PAADMRowid=" + Adm + "&AdmInsType=" + AdmReason + "&unBillStr=" + myunbillstr + "&gLoc=" + mygLoc + "&UloadDR=" + myUloadDR;
	var OEList = parent.frames['DHCOPOEList'];
	OEList.location.href = lnk;
}

function AddAdmListToCharge(AdmListStr, PatNo, Total, PatShare, CurrentInsType, CurDeptTotal, CurDeptShare, ReadInfoType, myReloadFlag, myCardNo, myCPPFlag, myINSDR, DiscAmt, PayorAmt, CurDeptDiscAmt, CurDeptPayorAmt) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCharge&PaadmRowid=" + AdmListStr + "&PatientID=" + PatNo;
	lnk = lnk + "&Total=" + Total + "&PatShareSum=" + PatShare + "&CurrentInsType=" + CurrentInsType;
	lnk = lnk + "&CurDeptTotal=" + CurDeptTotal + "&CurDeptShare=" + CurDeptShare;
	lnk += "&ReadInfoType=" + ReadInfoType;
	lnk += "&ReloadFlag=" + myReloadFlag;
	lnk += "&CardNo=" + myCardNo;
	lnk += "&CPPFlag=" + myCPPFlag;
	lnk += "&INSDR=" + myINSDR;
	lnk += "&ReadCardFlag=" + m_ReadCardFlag;
	lnk += "&DiscAmt=" + DiscAmt;
	lnk += "&PayorAmt=" + PayorAmt;
	lnk += "&CurDeptDiscAmt=" + CurDeptDiscAmt;
	lnk += "&CurDeptPayorAmt=" + CurDeptPayorAmt;
	var AdmCharge = parent.frames['udhcOPCharge'];
	AdmCharge.location.href = lnk;
}

function AddAdmListToInput(Adm, BillType) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEOrdInput&Adm=" + Adm + "&AdmBillType=" + BillType;
	var DHCOPOEOrdInput = parent.frames['DHCOPOEOrdInput'];
	DHCOPOEOrdInput.location.href = lnk;
}

function InitOEList() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPOEList";
	var OEList = parent.frames['DHCOPOEList'];
	OEList.location.href = lnk;
}

function InitOECharge() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCharge";
	var AdmCharge = parent.frames['udhcOPCharge'];
	AdmCharge.location.href = lnk;
}

function InitAdmList() {
	var PAAdmList = document.getElementById('PAADMList');
	PAAdmList.options.length = 0;
}

function InitInsTypeList() {
	var InsTypeList = document.getElementById('InsTypeList');
	InsTypeList.options.length = 0;
}

function InitOPPatInfo() {
	document.getElementById('AdmDocUserId').value = "";
	document.getElementById('AdmLoc').value = "";
	document.getElementById('AdmDoc').value = "";
	document.getElementById('AdmDate').value = "";
	document.getElementById('AccLeft').value = "";
}

///Edit doctor
function GetDocUserId(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	var AdmDoc = websys_getSrcElement(e);
	if ((AdmDoc) && (key == 13)) {
		//&&(AdmDoc.value!="")
		var DocCode = AdmDoc.value;
		var encmeth = DHCWebD_GetObjValue('DocUserIdBroker');
		if (cspRunServerMethod(encmeth, 'SetDocUserId', '', DocCode) == '0') {
			AdmDoc.className = 'clsInvalid';
			//websys_setfocus('AdmDoc');
			return websys_cancel();
		} else {
			AdmDoc.className = 'clsvalid';
		}
	}
}

function SetDocUserId(value) {
	var AdmDoc = document.getElementById('AdmDoc');
	var AdmDocUserId = document.getElementById('AdmDocUserId');
	var DocStr = value.split("^");
	AdmDoc.value = DocStr[1];
	AdmDocUserId.value = DocStr[0];
	//
	var DHCOPOEOrdInput = parent.frames['DHCOPOEOrdInput'].document;
	var DocUserId = DHCOPOEOrdInput.getElementById('DocUserId');
	if (DocUserId) {
		DocUserId.value = DocStr[0];
	}
}

function SelectAdmFromList() {
	//zhaocz 在更换ADM时要先保存医嘱
	var rtn = DHCWebD_SaveOrder();
	if (!rtn) {
		return;
	}
	//
	var AdmList = document.getElementById("PAADMList");
	var AdmIndex = AdmList.selectedIndex;
	SelectFromAdmList(AdmIndex);
	UpdateCharge()
	dispalyInsTypeColor()
	DHCWeb_OtherDocsetfocus("DHCOPOEOrdInput", "OPOrdItemDesc")
}

function GetAdmStrBillSum() {
	var TotalSum = 0;
	var PatShare = 0;
	var PayorShare = 0; //Lid 2012-11-14 添加记账金额，折扣金额
	var DiscAmount = 0;
	var CurDeptTotal = 0;
	var CurDeptShare = 0;
	var InsType = GetCurrentInsType();
	var encmeth = DHCWebD_GetObjValue('GetAdmInsCost');
	var AdmList = document.getElementById('PAADMList');
	for (var i = 0; i < AdmList.options.length; i++) {
		AdmStrArry = AdmList.options[i].value.split("^");
		var Adm = AdmStrArry[0];
		var OrdItemStr = document.getElementById('OrdItemStr');
		var myordstr = OrdItemStr.value;
		var mygLoc = session['LOGON.GROUPID'];
		var myRecDepDR = session['LOGON.CTLOCID'];
		var myExpStr = mygLoc + "^" + myRecDepDR;
		var myCostStr = cspRunServerMethod(encmeth, Adm, InsType, myordstr, myExpStr);
		var Cost = myCostStr.split("^");
		TotalSum = TotalSum + eval(Cost[0]); //总金额
		PatShare = PatShare + eval(Cost[3]); //自付金额
		DiscAmount = DiscAmount + eval(Cost[1]); //折扣金额
		PayorShare = PayorShare + eval(Cost[2]); //记账金额
		//Update AdmList
		AdmStrArry[7] = Cost[0];
		AdmStrArry[8] = Cost[3];
		AdmStrArry[9] = Cost[1];
		AdmStrArry[10] = Cost[2];
		AdmList.options[i].value = AdmStrArry.join("^");
		if (AdmList.options[i].selected == true) {
			CurDeptTotal = Cost[0];
			CurDeptShare = Cost[3];
			CurDeptDisc = Cost[1];
			CurDeptPayor = Cost[2];
		}
	}
	return TotalSum + "^" + PatShare + "^" + CurDeptTotal + "^" + CurDeptShare + "^" + DiscAmount + "^" + PayorShare + "^" + CurDeptDisc + "^" + CurDeptPayor;
}

function SelectAdmInsList() {
	IntDocument();
	//zhaocz
	/*
	var rtn = DHCWebD_SaveOrder();
	if (!rtn){
		return;
	}
	*/
	var InsList = document.getElementById("InsTypeList");
	var InsIndex = InsList.selectedIndex;
	var AdmList = document.getElementById("PAADMList");
	var AdmIndex = AdmList.selectedIndex;
	var AdmStrArry = AdmList.options[AdmIndex].value.split("^");
	var Adm = AdmStrArry[0];
	var InsType = InsList.options[InsIndex].value;
	AddOrdItemToTable(Adm, InsType);
	AddAdmListToInput(Adm, InsType)
	InitChargeInsuType("");
	UpdateCharge()
	//
	var myAdmStr = ReadAdmListStr();
	ReadLimitOrdStr(myAdmStr);
	//设置焦点到"项目名称"
	DHCWeb_OtherDocsetfocus("DHCOPOEOrdInput", "OPOrdItemDesc")
}

function InitChargeInsuType(PatDr) {
	var obj = document.getElementById("ChargeInsuType");
	if (obj) {
		obj.onchange = SelectChargeInsuType;
		obj.size = 1;
		obj.multiple = false;
		var CurrInsType = GetCurrentInsType();
		if (PatDr != "") {
			DHCWebD_ClearAllListA("ChargeInsuType");
			var myExpStr = ""
				var encmeth = DHCWebD_GetObjValue("ChargeInsuTypeEncrypt");
			if (encmeth != "") {
				//alert(PatDr+"%"+CurrInsType);
				var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "ChargeInsuType", PatDr, CurrInsType, myExpStr);
			}
		} else {
			var len = obj.length;
			for (var i = 0; i < len; i++) {
				var value = obj.options[i].value;
				//alert(value+"%"+CurrInsType);
				if (value == CurrInsType) {
					obj.options[i].selected = true;
					break;
				}
			}
		}
	}
}

function SelectChargeInsuType() {
	var AdmCharge = parent.frames['udhcOPCharge'];
	AdmCharge.document.getElementById('NewInsType').value = this.value;
}

function InitAll() {
	
}

function UpdateCharge() {
	var PatientID = document.getElementById('PatientID');
	var PatNo = PatientID.value;
	var InsType = GetCurrentInsType();
	var CostStr = GetAdmStrBillSum();
	var Cost = CostStr.split("^");
	var Total = Cost[0];
	var PatShare = Cost[1];
	var CurDeptTotal = Cost[2];
	var CurDeptShare = Cost[3];
	var DiscAmt = Cost[4];
	var PayorAmt = Cost[5];
	var CurDeptDiscAmt = Cost[6];
	var CurDeptPayorAmt = Cost[7];
	//
	var AdmStr = "";
	var AdmList = document.getElementById('PAADMList');
	for (var i = 0; i < AdmList.options.length; i++) {
		AdmStrArry = AdmList.options[i].value.split("^");
		var Adm = AdmStrArry[0];
		if (AdmStr == "") {
			AdmStr = Adm;
		} else {
			AdmStr = AdmStr + "^" + Adm;
		}
	}
	var myReloadFlag = DHCWebD_GetObjValue("ReloadFlag");
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	var myCPPFlag = DHCWebD_GetObjValue("CPPFlag");
	var myValue = DHCWeb_GetListBoxValue("InsTypeList");
	var myary = myValue.split("^");
	var myINSDR = myary[0];
	AddAdmListToCharge(AdmStr, PatNo, Total, PatShare, InsType, CurDeptTotal, CurDeptShare, DOPInfo_ReadInfoType, myReloadFlag, myCardNo, myCPPFlag, myINSDR, DiscAmt, PayorAmt, CurDeptDiscAmt, CurDeptPayorAmt);
}

function GetAdmOrdItemStr(Adm) {
	var udhcOPPatinfo = parent.frames['udhcOPPatinfo'];
	var OrdItemStr = udhcOPPatinfo.document.getElementById('OrdItemStr');
}

function LoadOPPayMode() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPCPayMode&PAmt=";
	var NewWin = open(lnk, "OPPayMode", "scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");
}

function ReLoadDD() {
	var lnk = "udhcopbillif.csp?PatientIDNo=2";
	var NewWin = open(lnk, "udhcopbillif", "scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
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
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		var obj = document.getElementById("CardNo");
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		DHCWebD_SetObjValueB("RCardNo", myary[1]);
		DHCWebD_SetObjValueB("AccRowID", myary[7]);
		var myAccRowID = DHCWebD_GetObjValue("AccRowID");
		if (myAccRowID != "") {
			var obj = document.getElementById("AccAddDeposit");
			if (obj) {
				DHCWeb_AvailabilityBtnA(obj, AccAddDeposit);
			}
		}
		//DHCWebD_SetListValueA(obj,myary[1]);
		DHCWebD_SetObjValueB("AccLeft", myary[3]);
		if (eval(myary[3]) > 0) {
			DHCWebD_SetObjValueC("CPPFlag", "CPP");
		}
		//Wrt AccType Descripe
		ReadPatInfo();
		//Account Can Pay
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		var obj = document.getElementById("PatientID");
		obj.value = myary[5];
		ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function ShowAccDetails() {
	//Show Acc Detais
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	var myPAPMINo = DHCWebD_GetObjValue("PatientID");
	if ((myCardNo == "") || (myPAPMINo == "")) {
		return;
	}
	var myencrypt = DHCWebD_GetObjValue("ReadAccInfoByCardNoEncrypt");
	var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
	var myAccInfo = "";
	var myExpStr = "";
	switch (myDHCVersion) {
	case "0":
		myExpStr = ReadAdmListStr();
		break;
	}
	if (myencrypt != "") {
		myAccInfo = cspRunServerMethod(myencrypt, myCardNo, myPAPMINo, myExpStr);
		var myary = myAccInfo.split("^");
		if (myary.length > 2) {
			DHCWebD_SetObjValueB("AccLeft", myary[1]);
			DHCWebD_SetObjValueB("AccType", myary[2]);
		}
	}
}

function AccAddDeposit() {
	//CardNo
	//AccRowID
	var myAccRowID = DHCWebD_GetObjValue("AccRowID");
	var PatShare = 0;
	var chargedoc = parent.frames["udhcOPCharge"].document;
	if (chargedoc) {
		if (!BillByAdmSelected) {
			var obj = chargedoc.getElementById("Actualmoney");
			var objb = chargedoc.getElementById("PatShareSum");
			if ((!objb) || (objb.type == "hidden")) {
				objb = chargedoc.getElementById("PatRoundSum");
			}
		} else {
			var objb = chargedoc.getElementById("CurDeptShare"); //Lid 2010-12-06
			if ((!objb) || (objb.type == "hidden")) {
				objb = chargedoc.getElementById("CurDepRoundShare");
			}
		}
		if (objb) {
			var myPatSum = objb.value;
			var PatShare = myPatSum;
		}
	}
	var myPatOrdSum = PatShare;
	var myAccDepFlag = 1;
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	var myPaPMINo = DHCWebD_GetObjValue("PatientID");
	var myPatName = DHCWebD_GetObjValue("PatName");
	//'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID='+AccountIDobj.value
	//+'&CardNo='+CardNoobj.value+'&RegNo='+RegNoobj.value+'&PatName='+ escape(PatNameobj.value);
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCAccAddDeposit&AccountID=' + myAccRowID;
	lnk += '&CardNo=' + myCardNo + '&RegNo=' + myPaPMINo + '&PatName=' + DHCWeb_CharTransAsc(myPatName) + "&AccDepFlag=" + myAccDepFlag;
	lnk += "&PatFactPaySum=" + myPatOrdSum;
	var NewWin = open(lnk, "UDHCAccAddDeposit", "scrollbars=yes,resizable=yes,top=20,left=20,width=1200,height=660");
}

function transINVStr(myINVStr) {
	alert(myINVStr);
	alert("DD");
}

//add by wanghuicai 2009-7-19 InsTypeList中的有医嘱的费别字体变色
function dispalyInsTypeColor() {
	var mygloc = session['LOGON.GROUPID'];
	var myULoadDR = session['LOGON.CTLOCID'];
	var myExpstr = mygloc + "^" + myULoadDR;
	var PAAdmList = document.getElementById('PAADMList');
	var admSelectIndex = PAAdmList.selectedIndex;
	var AdmListValue = PAAdmList.options[admSelectIndex].value.split("^");
	var admRowid = AdmListValue[0];
	var encmeth = DHCWebD_GetObjValue('getInsTypeOfHaveOrd');
	var insTypeStr = cspRunServerMethod(encmeth, admRowid, "ALL", myExpstr);
	var InsTypeList = document.getElementById('InsTypeList');
	var len = InsTypeList.length;
	for (var i = 0; i < len; i++) {
		var ListText = InsTypeList.options[i].text;
		var reg = new RegExp(ListText, "g");
		if (insTypeStr.match(reg) == ListText) {
			InsTypeList.options[i].style.color = "red";
		} else {
			InsTypeList.options[i].style.color = "black";
		}
	}
}

//add by wanghuicai 2009-7-19 paadmList中的有医嘱的费别字体变色
function dispalyPAAdmListColor() {
	var mygloc = session['LOGON.GROUPID'];
	var myULoadDR = session['LOGON.CTLOCID'];
	var myExpstr = mygloc + "^" + myULoadDR;
	var PatientID = document.getElementById("PatientID");
	if ((PatientID) && (PatientID.value != "")) {
		var PatNo = PatientID.value;
		var myExpStr = "";
		var encmeth = DHCWebD_GetObjValue('GetPAPMI');
		var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
		if (PatDr == "") {
			alert(t['RegNoError']);
			PatientID.className = 'clsInvalid';
			websys_setfocus('PatientID');
			return websys_cancel();
		} else {
			PatientID.className = 'clsvalid';
		}
	}
	var PAAdmList = document.getElementById('PAADMList');
	var len = PAAdmList.length;
	var encmeth = DHCWebD_GetObjValue('getInsTypeOfHaveOrd');
	for (var i = 0; i < len; i++) {
		var admValueList = PAAdmList.options[i].value.split("^");
		var admRowid = admValueList[0];
		var insTypeStr = cspRunServerMethod(encmeth, admRowid, "FIRST", myExpstr);
		if (insTypeStr != "") {
			PAAdmList.options[i].style.color = "red";
		} else {
			PAAdmList.options[i].style.color = "black";
		}
	}
}

function GetBillAdmStr() {
	var patdoc = parent.frames["udhcOPPatinfo"].document;
	var paadmlist = patdoc.getElementById("PAADMList");
	var myAdmstr = "";
	var AllAdmStr = "";
	var AdmStr = "";
	if (paadmlist) {
		for (var i = 0; i < paadmlist.length; i++) {
			var myAdmValue = paadmlist.options[i].value;
			var myAdmAry = myAdmValue.split("^");
			AllAdmStr = AllAdmStr + myAdmAry[0] + "^";
			if (BillByAdmSelected) {
				if (!paadmlist.options[i].selected){
					continue;
				}				
			}
			myAdmstr = myAdmstr + myAdmAry[0] + "^";
		}
	}
	if (BillByAdmSelected) {
		AdmStr = myAdmstr;
	} else {
		AdmStr = AllAdmStr;
	}
	return AdmStr;
}

//var unLockRtn=UnLockOPAdm("User.OEOrder");
function UnLockOPAdm(flag) {
	if (flag == "") {
		flag = "User.OEOrder";
	}
	var currAdmStr = GetBillAdmStr();
	var lockAdmRtn = 0;
	var lockAdmRtn = tkMakeServerCall("web.DHCBillLockAdm", "UnLockOPAdm", currAdmStr, flag);
	return lockAdmRtn;
}

/**
 * 用于科室卡消费时,默认卡类型为录医嘱界面患者的卡类型
 * @method SetDefCardType()
 * @author ZhYW
 */
function SetDefCardType() {
	var CardTypeRowId = DHCWebD_GetObjValue("CardTypeRowId");
	if (CardTypeRowId != "") {
		m_SelectCardTypeDR = CardTypeRowId;
		DHCWeb_SetListDefaultValue("CardTypeDefine", CardTypeRowId, "^", 0);
	}
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = BodyUnLoadHandler;