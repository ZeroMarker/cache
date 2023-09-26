///udhcINVQuery.js

var myCombNameAry = new Array();
myCombNameAry[1] = "CardTypeDefine";
var myCombAry = new Array();
var m_CardNoLength = 12;
var m_UrlParameterStr = new Array();
var PrtList = new Array(); //add by zhl
var PrtSite = new Array();
PrtSite[0] = "Start";
var APIList = new Array();
var APISite = new Array();
APISite[0] = "Start";

//Load Handler
function BodyLoadHandler() {
	var myVersion = "";
	var obj = document.getElementById("DHCVersion");
	if (obj) {
		myVersion = obj.value;
	}
	var obj = document.getElementById("ChargeUser");
	if (obj) {
		if (myVersion == "1") {
			obj.readOnly = true;
		}
	}
	var obj = document.getElementById("INVPRTFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = INVPRTFlag_OnChange;
	}

	var obj = document.getElementById("INVFootFlagList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = INVFootFlag_OnChange;
	}
	var obj = document.getElementById("BClear");
	if (obj) {
		obj.onclick = BClear_Click;
	}
	var obj = document.getElementById("CardNo");
	if (obj) {
		obj.onkeydown = CardNo_OnKeyDown;
	}
	var obj = document.getElementById("PatientNO");
	if (obj) {
		obj.onkeydown = PatNo_OnKeyDown;
	}
	var Obj = document.getElementById('ReadCard');
	if (Obj) {
		Obj.onclick = ReadMagCard_Click;
	}
	
	document.onkeydown = Doc_OnKeyDown;
	IntDoc();
	
	var obj = document.getElementById("PayModeList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = PayModeList_OnChange;
	}

	var obj = document.getElementById("Export");
	if (obj) {
		obj.onclick = Export_Click;
	}
	var obj = document.getElementById("BPrint"); //add by zhl
	if (obj) {
		obj.onclick = PrintDetails_Click;
	}
	//add hujunbin 15.2.4 扩展串增加query参数
	var obj = document.getElementById("Find");
	if (obj) {
		obj.onclick = FindClick;
	}
	var obj = document.getElementById("StTime");
	if (obj) {
		obj.value = obj.value == "" ? "00:00:00" : obj.value;
		obj.onblur = setTime;
	}
	var obj = document.getElementById("EndTime");
	if (obj) {
		obj.value = obj.value == "" ? "23:59:59" : obj.value;
		obj.onblur = setTime;
	}
	//end
	var obj = document.getElementById("AllSelect");
	if (obj) {
		obj.onclick = AllSelect_OnClick;
	}
	var obj = websys_$("ChargeUser");
	if (obj){
		obj.onkeyup = ClearChargeUser;
	}
}

function AllSelect_OnClick() {
	var mycheck = DHCWebD_GetObjValue("AllSelect");
	SelectAll(mycheck);
}

function SelectAll(myCheck) {
	//var myRLStr="";
	var myRows = DHCWeb_GetTBRows("tudhcINVQuery");
	for (var i = 1; i <= myRows; i++) {
		var obj = document.getElementById("CheckPrintz" + i);
		//var mySelFlag = DHCWebD_GetCellValue(obj);
		var sSelect = document.getElementById('CheckPrintz' + i);
		if (!sSelect.disabled) {
			DHCWebD_SetListValueA(obj, myCheck);
		}
		var SelRowObj = document.getElementById('TAbortz' + i);
		var abortflag = SelRowObj.checked;
		var SelRowObj = document.getElementById('TRefundz' + i);
		var refundflag = SelRowObj.checked;
		var SelRowObj = document.getElementById('TINVRowidz' + i);
		var PrtId = SelRowObj.innerText;
		var SelRowObj = document.getElementById('TabFlagz' + i);
		var TabFlag = SelRowObj.innerText;
		var SelRowObj = document.getElementById('CheckPrintz' + i);
		if ((SelRowObj.checked == true) && ((abortflag == true) || (refundflag == true))) {
			SelRowObj.checked = false;
		}
		if (SelRowObj.checked == true) {
			if (TabFlag == "PRT") {
				if ((PrtList[PrtId] == "0") || (PrtList[PrtId] == "") || (PrtList[PrtId] == undefined)) {
					len = PrtSite.length;
					PrtList[PrtId] = len;
					PrtSite[len] = PrtId;
				}
			} else {
				if ((APIList[PrtId] == "0") || (APIList[PrtId] == "") || (APIList[PrtId] == undefined)) {
					len = APISite.length;
					APIList[PrtId] = len;
					APISite[len] = PrtId;
				}
			}
		} else {
			if (TabFlag == "PRT") {
				if ((PrtList[PrtId] != "0") && (PrtList[PrtId] != "") && (PrtList[PrtId] != undefined)) {
					sitecode = PrtList[PrtId];
					PrtList[PrtId] = "";
					len = PrtSite.length - 1;
					if (sitecode < len) {
						OldId = PrtSite[len];
						PrtSite[sitecode] = OldId;
						PrtList[OldId] = sitecode;
					}
					PrtSite.pop();
				}
			} else {
				if ((APIList[PrtId] != "0") && (APIList[PrtId] != "") && (APIList[PrtId] != undefined)) {
					sitecode = APIList[PrtId];
					APIList[PrtId] = "";
					len = APISite.length - 1;
					if (sitecode < len) {
						OldId = APISite[len];
						APISite[sitecode] = OldId;
						APIList[OldId] = sitecode;
					}
					APISite.pop();
				}
			}
		}
	}
}

///add hujunbin 15.2.4
function FindClick() {
	var StTime = "";
	var EndTime = "";
	var StTimeObj = document.getElementById("StTime");
	var EndTimeObj = document.getElementById("EndTime");
	if (StTimeObj) {
		StTime = StTimeObj.value;
		if (StTimeObj.value != "" && StTimeObj.className == 'clsInvalid') {
			alert("日期格式不正确");
			return;
		}
	}
	if (EndTimeObj) {
		EndTime = EndTimeObj.value;
		if (EndTimeObj.value != "" && EndTimeObj.className == 'clsInvalid') {
			alert("日期格式不正确");
			return;
		}
	}

	Find_click();
}

///add hujunbin 15.2.4
function setTime() {
	var regExp = /^\d{6}?$/;
	var val = this.value;
	if (regExp.test(val)) {
		this.className = 'clsvalid';
		this.value = val.substring(0, 2) + ":" + val.substring(2, 4) + ":" + val.substring(4, 6);
	}
	regExp = /^((20|21|22|23|[0-1]\d)\:[0-5][0-9])(\:[0-5][0-9])?$/;
	if (!regExp.test(this.value)) {
		this.className = 'clsInvalid';
	} else {
		this.className = 'clsvalid';
		return false;
	}

	return true;
}

function Doc_OnKeyDown() {
	var eSrc = window.event.srcElement;
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);

	if (key == 13) {
		websys_nexttab(eSrc.tabIndex);
	}

	///F7
	///F8
	///F9	120
	///F12  123
	///F8	119   查询
	///Alt+R
	switch (key) {
	case 119:
		//SetQueryUrl();
		Find_click();
		break;
	case 123:
		//SetQueryUrl();
		ReadMagCard_Click();
		break;
	}

	DHCWeb_EStopSpaceKey();
}

function SetQueryUrl() {
	var myAry = new Array();
	myAry[0] = "ChargeUser";
	myAry[1] = "ReceipNO";
	myAry[2] = "PatientNO";
	myAry[3] = "PatientName";
	myAry[4] = "StartDate";
	myAry[5] = "EndDate";
	myAry[6] = "sFlag";
	myAry[7] = "ChargeUserA";
	myAry[8] = "INVPRTFlag";
	myAry[9] = "INVFootFlagList";
	myAry[10] = "INVStatus";
	myAry[11] = "INVFootFlag";
	myAry[12] = "CardNo";
	myAry[13] = "";
	myAry[14] = "";
	myAry[15] = "";
	myAry[16] = "";
	myAry[17] = "";
	myAry[18] = "";
	var myUrl = "";
	for (var myIdx = 0; myIdx < myAry.length; myIdx++) {
		if (myAry[myIdx] != "") {
			myUrl += "&" + myAry[myIdx] + "=" + DHCWebD_GetObjValue(myAry[myIdx]);
		}
	}

	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcINVQuery" + myUrl;
	location.href = lnk;

}

function CardNo_OnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13)) {
		var myTMPRCardNo = DHCWebD_GetObjValue("CardNo");
		myTMPRCardNo = DHCWeb_replaceAll(myTMPRCardNo, ";", "");
		myTMPRCardNo = DHCWeb_replaceAll(myTMPRCardNo, "?", "");
		DHCWebD_SetObjValueB("CardNo", myTMPRCardNo);
		SetCardNOLength();
	}
}

function PatNo_OnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13)) {
		var PatientNO = DHCWebD_GetObjValue("PatientNO");
		PatientNO = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", PatientNO);
		DHCWebD_SetObjValueB("PatientNO", PatientNO)
	}
}

function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
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

function IntDoc() {
	DHCWebD_ClearAllListA("INVPRTFlag");
	var encmeth = DHCWebD_GetObjValue("ReadPRTFlagEncryp");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "INVPRTFlag");
	}
	var myINVStatus = DHCWebD_GetObjValue("INVStatus");
	if (myINVStatus != "") {
		DHCWeb_SetListDefaultValue("INVPRTFlag", myINVStatus, "^", 0)
	}
	INVPRTFlag_OnChange();

	DHCWebD_ClearAllListA("INVFootFlagList");
	var encmeth = DHCWebD_GetObjValue("ReadFootEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "INVFootFlagList");
	}

	var myINVStatus = DHCWebD_GetObjValue("INVFootFlag");
	if (myINVStatus != "") {
		DHCWeb_SetListDefaultValue("INVFootFlagList", myINVStatus, "^", 0)
	}
	INVFootFlag_OnChange();
	//var mySessionStr=DHCWeb_GetSessionPara();
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
	var obj = document.getElementById("CardTypeDefine");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = CardTypeDefine_OnChange;
	}
	CardTypeDefine_OnChange();

	DHCWebD_ClearAllListA("PayModeList");
	var encmeth = DHCWebD_GetObjValue("PayModeListEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PayModeList");
	}
	var myINVStatus = DHCWebD_GetObjValue("currentPayMode");
	if (myINVStatus != "") {
		DHCWeb_SetListDefaultValue("PayModeList", myINVStatus, "^", 0)
	}
	PayModeList_OnChange();
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
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("ReadCard");
	} else {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");
	} else {
		DHCWeb_setfocus("ReadCard");
	}

	m_CardNoLength = myary[17];

}

function INVPRTFlag_OnChange() {
	var myINVFlag = DHCWeb_GetListBoxValue("INVPRTFlag");
	var myary = myINVFlag.split("^");
	var obj = document.getElementById("INVStatus");
	if (obj) {
		obj.value = myary[0];
	}
}

function INVFootFlag_OnChange() {
	var myINVFlag = DHCWeb_GetListBoxValue("INVFootFlagList");
	var myary = myINVFlag.split("^");
	var obj = document.getElementById("INVFootFlag");
	if (obj) {
		obj.value = myary[0];
	}
}

function PayModeList_OnChange() {
	var myINVFlag = DHCWeb_GetListBoxValue("PayModeList");
	var myary = myINVFlag.split("^");
	var obj = document.getElementById("currentPayMode");
	if (obj) {
		obj.value = myary[0];
	}
}

function BClear_Click() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcINVQuery";
	location.href = lnk;
}

function Export_Click() {
	var xlApp, obook, osheet, xlsheet,xlBook, i, j;
	var encmeth = DHCWebD_GetObjValue('getpath');
	var path = cspRunServerMethod(encmeth);
	var Template = path + "JF_OPInvprtSearch.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	xlApp.visible = true;

	var job = document.getElementById('Tjobz' + 1);
	var Tjob = job.innerText;
	var encmeth = DHCWebD_GetObjValue('GetInvprtNum');
	var GetInvprtNum = cspRunServerMethod(encmeth, Tjob);
	for (i = 0; i <= GetInvprtNum; i++) {
		var encmeth = DHCWebD_GetObjValue('GetInvDetail');
		var GetInvDetail = cspRunServerMethod(encmeth, Tjob, i);
		var GetInvDetail = GetInvDetail.split("^");
		var ColLength = GetInvDetail.length;
		for (j = 1; j < ColLength; j++) {
			xlsheet.cells(4 + i, j).value = GetInvDetail[j - 1];
		}
	}
	var Colnum = i;
	xlsheet.Range(xlsheet.Cells(1, 1), xlsheet.Cells(1, ColLength - 1)).MergeCells = true;
	//获取tableitem名称
	var objtb = document.getElementById("tudhcINVQUERY");
	var Rows = objtb.rows.length;
	var firstRow = objtb.rows[0];
	var RowItems = firstRow.all;
	var TableItemLength = RowItems.length;
	for (i = 1; i < TableItemLength - 2; i++) {
		//xlsheet.cells(4,i).value = RowItems[i].innerHTML;
	}
	var obj = document.getElementById("StartDate");
	if (obj) {
		var StDate = obj.value;
	}
	StDate = StDate.split("/");
	StDate = StDate[2] + "-" + StDate[1] + "-" + StDate[0];
	var obj = document.getElementById("EndDate");
	if (obj) {
		var EndDate = obj.value;
	}
	EndDate = EndDate.split("/");
	EndDate = EndDate[2] + "-" + EndDate[1] + "-" + EndDate[0];
	var date = new Date();
	var TodayDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
	var TodayTime = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	var ColNum = parseInt(ColLength / 3);
	xlsheet.cells(3, 1).value = "查询日期:" + StDate + " -- " + EndDate;
	xlsheet.cells(3, 4).value = "打印日期:" + TodayDate + " " + TodayTime;
	xlsheet.cells(3, 7).value = "打印人:" + session['LOGON.USERNAME'];

	AddGrid(xlsheet, 5, 2, 4 + Colnum, ColLength, 4, 1);
	//xlsheet.printout;
	//xlsheet.PrintPreview();
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

function AddGrid(objSheet, fRow, fCol, tRow, tCol, xlsTop, xlsLeft) {
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle = 1;
}

///unload
function BodyUnLoadHandler() {
	
}

function PrintDetails_Click() {
	var Prtstr = PrtSite.join("^");
	var APIStr = APISite.join("^");
	var INVstr = Prtstr + "#" + APIStr;
	var encmeth = DHCWebD_GetObjValue('getSendtoPrintinfo');
	var Printinfo = cspRunServerMethod(encmeth, INVstr);
	if (Printinfo == "") {
		alert("请选择数据进行打印!");
		return;
	}
	Printinfo = Printinfo.split(String.fromCharCode(3));
	var encmeth = DHCWebD_GetObjValue('getpath');
	var path = cspRunServerMethod(encmeth, '', '');
	var xlApp, obook, osheet, xlsheet, xlBook;
	var temp;
	var str;
	var i;
	var j;
	var Template;
	var rows = 3;
	for (var i = 0; i <= Printinfo.length - 1; i++) {
		Template = path + "mzfpmx.xls";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var data = Printinfo[i].split(String.fromCharCode(2));
		for (var j = 2; j <= data.length - 1; j++) {
			var str = data[j].split("^");
			xlsheet.cells(rows + j, 2).value = str[0];
			xlsheet.cells(rows + j, 3).value = str[1];
			xlsheet.cells(rows + j, 4).value = str[2];
			xlsheet.cells(rows + j, 5).value = str[3];
			xlsheet.cells(rows + j, 6).value = str[4];
			xlsheet.cells(rows + j, 7).value = str[5];
		}
		var str1 = data[0].split("^");
		xlsheet.cells(2, 2).value = "姓名:";
		xlsheet.cells(2, 3).value = str1[0];
		xlsheet.cells(2, 4).value = "性别:";
		xlsheet.cells(2, 5).value = str1[1];
		xlsheet.cells(2, 6).value = "登记号:";
		xlsheet.cells(2, 7).value = str1[2];
		var str2 = data[1].split("^");
		xlsheet.cells(3, 2).value = str2[0];
		xlsheet.cells(3, 3).value = str2[1];
		xlsheet.cells(3, 6).value = "打印时间:";
		xlsheet.cells(3, 7).value = str2[5];

		var GuserID = session['LOGON.USERID'];
		var HospitalName = tkMakeServerCall("web.UDHCHospitalGroup", "GetHospitalDescByUserID", GuserID);

		xlsheet.cells(1, 1).value = HospitalName + "发票明细清单";
		AddGrid(xlsheet, 4, 2, 2 + j, 7, 4, 2);

		xlsheet.printout;
		xlBook.Close(savechanges = false);
		xlApp = null;
		xlsheet = null;
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	var selectrow = rowobj.rowIndex;
	if (!selectrow) {
		return;
	}
	var SelRowObj = document.getElementById('TAbortz' + selectrow);
	var abortflag = SelRowObj.checked;
	var SelRowObj = document.getElementById('TRefundz' + selectrow);
	var refundflag = SelRowObj.checked;
	var SelRowObj = document.getElementById('TINVRowidz' + selectrow);
	var PrtId = SelRowObj.innerText;
	var SelRowObj = document.getElementById('TabFlagz' + selectrow);
	var TabFlag = SelRowObj.innerText;
	var SelRowObj = document.getElementById('CheckPrintz' + selectrow);
	if ((SelRowObj.checked == true) && ((abortflag == true) || (refundflag == true))) {
		alert("退票不允许打清单！");
		SelRowObj.checked = false;
		return;
	}
	if (SelRowObj.checked == true) {
		if (TabFlag == "PRT") {
			if ((PrtList[PrtId] == "0") || (PrtList[PrtId] == "") || (PrtList[PrtId] == undefined)) {
				len = PrtSite.length;
				PrtList[PrtId] = len;
				PrtSite[len] = PrtId;
			}
		} else {
			if ((APIList[PrtId] == "0") || (APIList[PrtId] == "") || (APIList[PrtId] == undefined)) {
				len = APISite.length;
				APIList[PrtId] = len;
				APISite[len] = PrtId;
			}
		}
	} else {
		if (TabFlag == "PRT") {
			if ((PrtList[PrtId] != "0") && (PrtList[PrtId] != "") && (PrtList[PrtId] != undefined)) {
				sitecode = PrtList[PrtId];
				PrtList[PrtId] = "";
				len = PrtSite.length - 1;
				if (sitecode < len) {
					OldId = PrtSite[len];
					PrtSite[sitecode] = OldId;
					PrtList[OldId] = sitecode;
				}
				PrtSite.pop();
			}
		} else {
			if ((APIList[PrtId] != "0") && (APIList[PrtId] != "") && (APIList[PrtId] != undefined)) {
				sitecode = APIList[PrtId];
				APIList[PrtId] = "";
				len = APISite.length - 1;
				if (sitecode < len) {
					OldId = APISite[len];
					APISite[sitecode] = OldId;
					APIList[OldId] = sitecode;
				}
				APISite.pop();
			}
		}
	}

}

function ReadMagCard_Click() {
	//m_CCMRowID  == HardType
	//var rtn = DHCACC_ReadMagCard(m_CCMRowID, "R", "23","","");
	var myCCMRowID = "";
	var myval = DHCWeb_GetListBoxValue("CardTypeDefine");
	//var myval=myCombAry["CardTypeDefine"].getSelectedValue();
	myCCMRowID = myval.split("^")[14];
	if ((myCCMRowID == "") || (myCCMRowID == null)) {
		return;
	}
	var rtn = DHCACC_ReadMagCard(myCCMRowID);
	var myary = rtn.split("^");
	if (myary[0] == '0') {
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		//CardVerify=myary[2];
		//m_CardValidateCode=myary[2];
		//m_CardSecrityNo=myary[2];
		//GetValidatePatbyCard();
		Find_click();
	}
}

function CheckPrint_OnChange() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	var selectrow = rowobj.rowIndex;
	if (!selectrow) {
		return;
	}

}

/**
* Creator: ZhYW
* CreatDate: 2018-01-03
*/
function GetUserID(value) {
	var myAry = value.split("^");
	userName = myAry[0];
	userID = myAry[1];
	DHCWebD_SetObjValueB("ChargeUser", userName);
	DHCWebD_SetObjValueB("userID", userID);
}	

/**
* Creator: ZhYW
* CreatDate: 2018-01-03
*/
function ClearChargeUser() {
	var userName = websys_$V('ChargeUser');
	if (userName == "") {
		DHCWebD_SetObjValueB("userID", "");
	}
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;
