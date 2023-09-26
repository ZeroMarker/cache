//Copyright (c) 2005 DHC for DHC.Component.Custom2. ALL RIGHTS RESERVED.
// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//
// DHCOPOEOrdInput.js
// zhaocz----2005-07-26

session['InsType'] = "";
session['PatType'] = "";
session['PAAdmRowID'] = "";
session['OPComList'] = "";
session['OPComList'] += "OPOrdItemDesc" + "^";
session['OPComList'] += "OPOrdItemRowID" + "^";
session['OPComList'] += "OPOrdUnit" + "^";
session['OPComList'] += "OPOrdPrice" + "^";
session['OPComList'] += "OPOrdQty" + "^";
session['OPComList'] += "OPOrdBillSum" + "^";
session['OPComList'] += "OPOrdConFac" + "^";
session['OPComList'] += "OPOrdDiscPrice" + "^";
session['OPComList'] += "OPOrdInsPrice" + "^";
session['OPComList'] += "OPOrdPatPrice" + "^";
session['OPComList'] += "OPOrdItemRecLoc" + "^";
session['OPComList'] += "OPOrdItemRecLocRID" + "^";
session['OPComList'] += "OPOrdBillFlag" + "^";
session['OPComList'] += "OPOrdARCType" + "^";
session['OPComList'] += "OPOrdType" + "^";
session['OPComList'] += "OrdRowId" + "^";
session['OPComList'] += "OPOrdInsType" + "^";
session['OPComList'] += "OPOrdInsRowId" + "^";
session['OPComList'] += "OPOrdEnt" + "^";
session['OPComList'] += "OPOrdPrescNo" + "^";
session['OPComList'] += "DiscAmt" + "^";
session['OPComList'] += "PayorAmt" + "^";

var aryEName = new Array();
aryEName[0] = "OPOrdItemDesc";
aryEName[1] = "OPOrdItemRowID";
aryEName[2] = "OPOrdUnit";
aryEName[3] = "OPOrdPrice";
aryEName[4] = "OPOrdQty";
aryEName[5] = "OPOrdBillSum";
aryEName[6] = "OPOrdConFac";
aryEName[7] = "OPOrdDiscPrice";
aryEName[8] = "OPOrdInsPrice";
aryEName[9] = "OPOrdPatPrice";
aryEName[10] = "OPOrdItemRecLoc";
aryEName[11] = "OPOrdItemRecLocRID";
aryEName[12] = "OPOrdBillFlag";
aryEName[13] = "OPOrdARCType";
aryEName[14] = "OPOrdType";
aryEName[15] = "OrdRowId";
aryEName[16] = "OPOrdInsType";
aryEName[17] = "OPOrdInsRowId";
aryEName[18] = "OPOrdEnt";
aryEName[19] = "OPOrdPrescNo";
aryEName[20] = "DiscAmt";
aryEName[21] = "PayorAmt";

var CurInsType = "";

function BodyLoadHandler() {
	DHCP_GetXMLConfig("InvPrintEncrypt", "ZlyyHjPrePrint");
	var obj = document.getElementById("HjPrint");
	if (obj) {
		obj.onclick = HjPrint_Click;
	}
	var obj = document.getElementById("OPOrdAdd");
	if (obj) {
		obj.onclick = OPOrdAdd_Click;
	}

	var obj = document.getElementById("OPOrdCancle");
	if (obj) {
		obj.onclick = intdocument;
	}

	var obj = document.getElementById("OPOrdDel");
	if (obj) {
		obj.onclick = OPOrdDel_Click;
	}

	var obj = document.getElementById("OPOrdSave");
	if (obj) {
		obj.onclick = OPOrdSave_Click;
	}

	var obj = document.getElementById('OPOrdItemDesc');
	if (obj) {
		obj.onkeydown = OPOrdItemDesc_KeyDown;
		obj.onkeyup = OPOrdItemDesc_KeyUp;
		obj.style.imeMode = "disabled";
	}

	var OpOrdList = document.getElementById('OPOrdList');
	if (OpOrdList) {
		OpOrdList.onkeydown = OpOrdList_KeyDown;
	}

	var obj = document.getElementById("OPOrdUnit");
	if (obj) {
		obj.onkeydown = OPOrdUnit_KeyDown;
		obj.readOnly = true;
	}

	var obj = document.getElementById("OPOrdQty");
	if (obj) {
		obj.onkeyup = OPOrdQty_KeyUp;
		obj.onkeydown = OPOrdQty_KeyDown;
		obj.onkeypress = OPOrdQty_KeyPress;
		obj.style.imeMode = "disabled";
	}

	var obj = document.getElementById("OPOrdSingleQty");
	if (obj) {
		obj.onkeyup = OPOrdSingleQty_KeyUp;
		obj.onkeydown = OPOrdSingleQty_KeyDown;
		obj.onkeypress = OPOrdSingleQty_KeyPress;
		obj.style.imeMode = "disabled";
	}

	var obj = document.getElementById("OPOrdPrice");
	if (obj) {
		obj.onkeyup = OPOrdPrice_KeyUp;
		obj.onkeypress = OPOrdPrice_KeyPress;
		obj.style.imeMode = "disabled";
	}

	var obj = document.getElementById("OPOrdBillSum");
	if (obj) {
		obj.onkeypress = OPOrdBillSum_KeyPress;
		obj.readOnly = true;
	}

	var obj = document.getElementById("OPOrdItemRecLoc");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onkeypress = OPOrdItemRecLoc_KeyPress;
		obj.onchange = OPOrdItemRecLoc_Change;
	}

	var obj = document.getElementById("OPOrdEdit");
	if (obj) {
		obj.onclick = OPOrdEdit_Click;
		//DHCWeb_DisBtn(obj);
	}

	intdocument();
	CurInsType = "";

	var obj = document.getElementById("Test");
	if (obj) {
		obj.onclick = mytest;
	}
	//document.onkeydown = document_OnKeyDown;
	document.onkeydown = DHCWeb_DocumentOnKeydown;
}

function document_OnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
}

function Test_Click() {
	var Adm = document.getElementById("Adm");
	var DocUserId = document.getElementById("DocUserId");
}

function SetCurFocus() {
	websys_setfocus("OPOrdItemDesc");
}

function intdocument() {
	mylstr = session['OPComList'].split("^");
	for (var i = 0; i < mylstr.length; i++) {
		var obj = document.getElementById(mylstr[i]);
		if (obj) {
			obj.value = "";
		}
		if ((mylstr[i] == aryEName[2]) && (obj)) {
			obj.readOnly = false;
		}
		if ((mylstr[i] == aryEName[12]) && (obj)) {
			obj.checked = true;
		}
		if ((mylstr[i] == aryEName[10]) && (obj)) {
			ClearAllList(obj);
		}
	}
	var obj = document.getElementById("OPOrdSelectIdx");
	if (obj) {
		obj.value = "";
	}
	//
	TransInsType();

	var obj = document.getElementById("OPOrdAdd");
	DHCWeb_AvailabilityBtnA(obj, OPOrdAdd_Click);
	var obj = document.getElementById("OPOrdEdit");
	DHCWeb_DisBtn(obj);

	var obj = document.getElementById("OPOrdDel");
	DHCWeb_DisBtn(obj);

	//+2018-03-01 ZhYW
	DHCWeb_DisBtnA("OPOrdSave");

	DHCWebD_SetObjValueC("OPOrdSingleQty", "");
	websys_setfocus(mylstr[0]);
}

function TransInsType() {
	try {
		var billobj = document.getElementById("AdmBillType");
		var obj = document.getElementById(aryEName[17]); //OPOrdInsRowId
		if ((obj) && (billobj)) {
			obj.value = billobj.value; // insobj.options[vIdx].value;
		}
	} catch (e) {
		alert(e.message);
	}
}

function AddInsTypeOld() {
	var insobj = document.getElementById("OPOrdInsType");
	var ListName = "OPOrdInsType";
	var encobj = document.getElementById("OPOrdInsTypeEncrypt");
	if ((insobj) && (encobj)) {
		DHCWebD_ClearAllList(insobj);
		var encmeth = encobj.value;
		if (cspRunServerMethod(encmeth, 'AddToList', ListName) == '0') {}
		try {
			var vIdx = 0;
			var billobj = document.getElementById("AdmBillType");
			if (billobj) {
				var billflag = "";
				if (CurInsType == "") {
					billflag = billobj.value;
				} else {
					billflag = CurInsType;
				}
				for (var i = 0; i < insobj.options.length; i++) {
					if (insobj.options[i].value == billflag) {
						vIdx = i;
						break;
					}
				}
			}
			insobj.selectedIndex = vIdx;
			var obj = document.getElementById(aryEName[17]); //OPOrdInsRowId
			if (obj) {
				obj.value = insobj.options[vIdx].value;
			}
		} catch (e) {
			alert(e.message);
		}
	}
}

function OPOrdSave_Click() {
	DHCWeb_DisBtnA("OPOrdSave");
	// save the Order to Cache;
	var tablistOPOE = parent.frames["DHCOPOEList"].document.getElementById("tDHCOPOEList");
	var admrowid = "";
	var admobj = document.getElementById("Adm");
	if (admobj) {
		admrowid = admobj.value;
	}
	var mydocuserid = "";
	var docobj = document.getElementById("DocUserId");
	if (docobj) {
		var udhcOPPatinfo = parent.frames['udhcOPPatinfo'].document;
		var AdmDocUserId = udhcOPPatinfo.getElementById('AdmDocUserId');
		if ((AdmDocUserId.value != "") && (docobj.value == "")) {
			docobj.value = AdmDocUserId.value;
		}
		mydocuserid = docobj.value;
	}
	var encobj = document.getElementById("OPOrdSaveEncrypt");
	var encpreobj = document.getElementById("OPOrdPresNoEncrypt");
	if ((encobj) && (encpreobj)) {
		var encmeth = encobj.value;
		var presencmeth = encpreobj.value;
		var rtn = DHCWebD_SaveOrdToServer(encmeth, tablistOPOE, aryEName, admrowid, session['LOGON.USERID'], session['LOGON.CTLOCID'], mydocuserid, presencmeth);
	}
	if (rtn) {
		alert(t['02']); //"医嘱保存成功!"
		RefreshOrderList();
	} else {
		var obj = document.getElementById("OPOrdSave");
		DHCWeb_AvailabilityBtnA(obj, OPOrdSave_Click);
		alert(t['01']); //"医嘱保存失败!"
	}
}

function OPOrdAdd_Click() {
	var obj = document.getElementById("OPOrdAdd");
	if (obj && (obj.disabled)) {
		return;
	}
	var patframe = parent.frames["udhcOPPatinfo"];
	var patdoc = patframe.document;
	var obj_PAADMList = patdoc.getElementById('PAADMList');

	if (obj_PAADMList) {
		var selectidx = obj_PAADMList.selectedIndex;
		if (selectidx < 0) {
			return;
		}
	}
	var rtn = checkAddData();
	if (!rtn) {
		return;
	}
	var billobj = document.getElementById("AdmBillType");
	var obj = document.getElementById(aryEName[17]); //OPOrdInsRowId
	if ((obj) && (billobj)) {
		obj.value = billobj.value; //insobj.options[vIdx].value;
	}
	var myobjlist = parent.frames["DHCOPOEList"];
	var myobjdoc = parent.frames["DHCOPOEOrdInput"];
	var rtn = DHCWebD_WrtItmList(myobjlist, myobjdoc, session['OPComList'], "");
	intdocument();

	var obj = document.getElementById("OPOrdSave");
	DHCWeb_AvailabilityBtnA(obj, OPOrdSave_Click);

	//var DHCOPOEOrdInput = parent.frames['udhcOPCharge'].document;
	//var Total = DHCOPOEOrdInput.getElementById('Total');
	//Total.value = eval(Total.value)+100;
}

function checkAddData() {
	var rtn = true;
	var obj = document.getElementById(aryEName[10]);
	if (obj) {
		if (obj.value == "") {
			websys_setfocus(aryEName[10]);
			rtn = false;
			return rtn;
		}
	}

	var obj = document.getElementById(aryEName[11]);
	if (obj) {
		if (obj.value == "") {
			websys_setfocus(aryEName[10]);
			rtn = false;
			return rtn;
		}
	}
	//aryEName[4] = "OPOrdQty";
	var obj = document.getElementById(aryEName[4]);
	if (obj) {
		if ((obj.value == "") || (isNaN(obj.value)) || (obj.value == 0)) {
			websys_setfocus(aryEName[4]);
			rtn = false;
			return rtn;
		}
	}
	//aryEName[0] = "OPOrdItemDesc";
	//aryEName[3] = "OPOrdPrice";
	//aryEName[4] = "OPOrdQty";

	var myOrdDesc = DHCWebD_GetObjValue(aryEName[0]);
	var myOrdPrice = DHCWebD_GetObjValue(aryEName[3]);
	var myOrdQty = DHCWebD_GetObjValue(aryEName[4]);
	if (isNaN(myOrdPrice)) {
		myOrdPrice = 0;
	}
	if (isNaN(myOrdQty)) {
		myOrdQty = 0;
	}

	if ((myOrdQty == 0) || (myOrdPrice == 0)) {
		rtn = false;
		alert(myOrdDesc + t["05"]);
		return rtn;
	}
	var myArcimId = DHCWebD_GetObjValue(aryEName[1]);
	var myQty = DHCWebD_GetObjValue(aryEName[4]);
	var myMaxQty = CheckARCIMMaxQty(myArcimId, myQty);
	if (myMaxQty != "0") {
		rtn = false;
		alert(myOrdDesc + t["ARCIMMaxQty"] + myMaxQty);
		websys_setfocus(aryEName[4]);
		return rtn;
	}

	return rtn;
}

function CheckARCIMMaxQty(ArcimId, Qty) {
	var rtnval = "0";
	var obj = document.getElementById("GetARCIMMaxQty");
	if (obj) {
		encmeth = obj.value;
		var MaxQty = cspRunServerMethod(encmeth, ArcimId);
		if (parseFloat(MaxQty) > 0) {
			if (parseFloat(Qty) > parseFloat(MaxQty)) {
				rtnval = MaxQty;
			}
		}
	}
	return rtnval;
}

//delete the row and stop the OrdItem;
function OPOrdDel_Click() {
	var rtnvalue = window.confirm(t['06']);
	if (rtnvalue == false) {
		return;
	}
	var wobj = parent.frames["DHCOPOEList"];
	var obj = document.getElementById("OPOrdSelectIdx");
	if (obj) {
		var myIdx = obj.value;
		myIdx = parseInt(myIdx, 10);
		if (isNaN(myIdx) || (myIdx == "")) {
			return;
		}
		//aryEName[15]="OrdRowId"
		var ItmRID = DHCWebD_GetObjValue(aryEName[15]);
		var SOrdInfo = session['LOGON.USERID'] + "^"; //oper URD
		SOrdInfo += "" + "^"; //CareProviderRowid
		SOrdInfo += "" + "^"; //CareProviderName
		//yyx
		var encmeth = DHCWebD_GetObjValue('GetOrdUser');
		var OldUser = cspRunServerMethod(encmeth, ItmRID, session['LOGON.USERID']);
		if (OldUser != session['LOGON.USERID']) {
			alert("不是本人开的医嘱不允许删除.");
			return;
		}
		DHCWebD_DelSelTabRow(wobj, myIdx, ItmRID, SOrdInfo);
		intdocument();

		var obj = document.getElementById("OPOrdSave");
		DHCWeb_AvailabilityBtnA(obj, OPOrdSave_Click);
	}
}

///edit the Row and Update the Order
function OPOrdEdit_Click() {
	var obj = document.getElementById("OPOrdEdit");
	if (obj && (obj.disabled)) {
		return;
	}
	var rtn = checkAddData();
	if (!rtn) {
		return;
	}
	var billobj = document.getElementById("AdmBillType");
	var obj = document.getElementById(aryEName[17]); //OPOrdInsRowId
	if ((obj) && (billobj)) {
		obj.value = billobj.value;  //insobj.options[vIdx].value;
	}
	var myobjlist = parent.frames["DHCOPOEList"];
	var myobjdoc = parent.frames["DHCOPOEOrdInput"];
	var obj = document.getElementById("OPOrdSelectIdx");
	if (obj) {
		vSelIdx = obj.value;
	}
	var rtn = DHCWebD_WrtItmList(myobjlist, myobjdoc, session['OPComList'], vSelIdx);
	intdocument();
	
	var obj = document.getElementById("OPOrdSave");
	DHCWeb_AvailabilityBtnA(obj, OPOrdSave_Click);
}

function OPOrdItemRecLoc_KeyPress() {
	var key = window.event.keyCode;
	if (key == 13) {
		websys_setfocus("OPOrdAdd");
	} //DHCWeb_nextfocus(aryEName[11]);}
}

function SetItemRecLocIdx(locrid) {
	var listobj = document.getElementById(aryEName[10]);
	if (listobj.options.length == 0) {
		alert(t["03"]); //没有接收科室
		return;
	}

	var txtobj = document.getElementById(aryEName[11]);
	if ((txtobj) && (listobj)) {
		listobj.selectedIndex = vIdx;
		var selidx = listobj.selectedIndex;
		txtobj.value = listobj.options[selidx].value;
	}
}

function OPOrdItemRecLoc_Change() {
	var listobj = document.getElementById(aryEName[10]);
	if (listobj.options.length == 0) {
		alert(t['03']);
		return;
	}
	var txtobj = document.getElementById(aryEName[11]);
	if ((txtobj) && (listobj)) {
		var selidx = listobj.selectedIndex;
		txtobj.value = listobj.options[selidx].value;
	}

	var ordobj = document.getElementById("OPOrdType");
	if (ordobj) {
		if (ordobj.value != "R") {
			return;
		}
	}
	var obj = document.getElementById("OPOrdAdd");
	obj.disabled = false;
	var rtn = CheckStock();
	if (rtn) {
		obj.disabled = true;
		alert(t['04']);
		return;
	}
}

function OPOrdInsType_Change() {
	//get the patient payment;
	//aryEName[16] = "OPOrdInsType";
	//aryEName[17] = "OPOrdInsRowId";
	//var arcimrid = DHCWebD_GetObjValue(aryEName[1]);
	var insobj = document.getElementById("OPOrdInsType");
	var txtobj = document.getElementById(aryEName[17]); //"OPOrdInsRowId"
	if ((insobj) && (txtobj)) {
		var myidx = insobj.selectedIndex;
		var myinsrid = insobj.options[myidx].value;
		txtobj.value = myinsrid;
		CurInsType = myinsrid;
	}
	SetOEInfo();
}

function OPOrdBillSum_KeyPress() {
	var key = window.event.keyCode;
	if (key == 13) {
		DHCWeb_nextfocus(aryEName[5]);
	}
}

function OPOrdQty_KeyUp() {
	var obj = document.getElementById("OPOrdPatPrice");
	var objb = document.getElementById("OPOrdQty");
	var Resobj = document.getElementById("OPOrdBillSum");
	var obja1 = document.getElementById("OPOrdPrice");
	var objb1 = document.getElementById("OPOrdDiscPrice");
	var objc1 = document.getElementById("OPOrdInsPrice");
	DHCWeb_CalobjNew(obja1, objb1, objc1, objb, Resobj)
	//DHCWeb_Calobj(obj, objb, Resobj, "*");

	var objb = document.getElementById("OPOrdQty");
	var myOrdQty = DHCWebD_GetObjValue("OPOrdQty");

	var myMultNum = DHCWebD_GetObjValue("OPMultNum");
	if ((isNaN(myMultNum)) || (myMultNum == 0) || (myMultNum == "")) {
		myMultNum = 1;
	}
	myMultNum = parseInt(myMultNum);
	var myRtn = DHCWeb_CalobjA(obj.value, objb.value * myMultNum, "*");
}

function OPOrdSingleQty_KeyUp() {
	DHCWebD_OrdNumConv();
	var obj = document.getElementById("OPMultNum");
	var objb = document.getElementById("OPOrdSingleQty");
	var Resobj = document.getElementById("OPOrdQty");

	var typobj = document.getElementById("OPOrdARCType");
	if (typobj.value == "ARCIM") {
		var arcimrid = DHCWebD_GetObjValue("OPOrdItemRowID");
		var FCHerbFlag = tkMakeServerCall("web.UDHCJFBaseCommon", "CheckFCHerb", arcimrid);
		if (FCHerbFlag == "0") {
			DHCWebD_SetObjValueC("OPMultNum", 1);  //Lid 2011-12-14 "付数"只对草药起作用
		}
	}

	DHCWeb_Calobj(obj, objb, Resobj, "*");

	OPOrdQty_KeyUp();
}

function OPOrdQty_KeyDown() {
	var key = window.event.keyCode;
	if (key == 13) {
		var ordobj = document.getElementById("OPOrdType");
		var myordtype = "";
		if (ordobj) {
			myordtype = ordobj.value;
		}
		var obj = document.getElementById("OPOrdAdd");
		obj.disabled = false;
		if (myordtype == "R") {
			var rtn = CheckStock();
			if (rtn) {
				obj.disabled = true;
				alert(t['04']); //"库存不够!"
				return;
			}
		}
		DHCWeb_nextfocus(aryEName[4]);
	}
}

function OPOrdSingleQty_KeyDown() {
	var key = window.event.keyCode;
	if (key == 13) {
		var ordobj = document.getElementById("OPOrdType");
		var myordtype = "";
		if (ordobj) {
			myordtype = ordobj.value;
		}
		var obj = document.getElementById("OPOrdAdd");
		obj.disabled = false;
		if (myordtype == "R") {
			var rtn = CheckStock();
			if (rtn) {
				obj.disabled = true;
				alert(t['04']); //"库存不够!"
				return;
			}
		}
		DHCWeb_nextfocus("OPOrdSingleQty");
	}
}

function OPOrdQty_KeyPress() {
	var ordobj = document.getElementById("OPOrdType");
	var myordtype = "";
	if (ordobj) {
		myordtype = ordobj.value;
	}
	if (myordtype == "R") {
		DHCWeb_SetLimitNum();
		//DHCWeb_SetLimitFloat();
	} else {
		DHCWeb_SetLimitFloat();
	}
}

function OPOrdSingleQty_KeyPress() {
	OPOrdQty_KeyPress();
}

function OPOrdPrice_KeyUp() {
	//first set PatPrice?second set OrdItem sum?
	SetOEInfo();
	//var obj = document.getElementById("OPOrdPrice");
	//var obj = document.getElementById("OPOrdPatPrice");
	//var objb = document.getElementById("OPOrdQty");
	//var Resobj = document.getElementById("OPOrdBillSum");
	//DHCWeb_Calobj(obj,objb,Resobj);
}

function OPOrdPrice_KeyPress() {
	var key = window.event.keyCode;
	DHCWeb_SetLimitFloat();
	if (key == 13) {
		DHCWeb_nextfocus(aryEName[3]);
		//DHCWeb_NextfocusA();
	}
}

function OPOrdUnit_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_nextfocus(aryEName[2]);
	}
}

function OpOrdList_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var mydata = "";
		var OrdObj = document.getElementById('OPOrdItemDesc');
		var OrdList = document.getElementById('OPOrdList');
		var myRow = OrdList.selectedIndex;
		var mylen = OrdList.length;
		if ((mylen > 0) && (myRow > -1)) {
			//OrdObj.value=OrdList.options[myRow].text;
			mydata = OrdList.options[myRow].value;
			var arydata = mydata.split(String.fromCharCode(2));
			///Lid 2011-12-14 控制皮试医嘱
			/*
			var SkinFlag=tkMakeServerCall("web.UDHCJFBaseCommon","CheckSkinFlag",arydata[1]);
			if(SkinFlag=="Y"){
				var myrtn = window.confirm("该医嘱需要皮试,是否继续收费?");
				if (!myrtn){
					websys_setfocus('OPOrdItemDesc');
					DHCWeb_ResetStyle(OrdList);
					ClearAllList(OrdList);
					return;
				}
			}
			*/
			SetOrdItem(mydata);
			var obj = document.getElementById("OPOrdAdd");
			obj.disabled = false;
			var rtn = CheckStock();
			if (rtn) {
				obj.disabled = true;
				alert(t['04']);
				intdocument();
				return;
			}
		} else {
			OrdObj.value = "";
		}
		DHCWeb_ResetStyle(OrdList);
		ClearAllList(OrdList);
		if (mydata != "") {
			DHCWeb_nextfocus(aryEName[0]);
			//DHCWeb_NextfocusA();
		} else {
			websys_setfocus('OPOrdItemDesc');
		}
	} else if (key == 27) {    //Esc
		var OrdList = document.getElementById('OPOrdList');
		DHCWeb_ResetStyle(OrdList);
		ClearAllList(OrdList);
		var OrdObj = document.getElementById('OPOrdItemDesc');
		OrdObj.value = "";
		websys_setfocus('OPOrdItemDesc');
	}
}

function OpOrdList_Click() {
	var OrdObj = document.getElementById('OPOrdItemDesc');
	var OrdList = document.getElementById('OPOrdList');
	var myRow = OrdList.selectedIndex;
	var mylen = OrdList.length;
	if ((mylen > 0) && (myRow > -1)) {
		OrdObj.value = OrdList.options[myRow].text;
	} else {
		OrdObj.value = "";
	}
	DHCWeb_ResetStyle(OrdList);
	ClearAllList(OrdList);
	DHCWeb_nextfocus(aryEName[0]);
}

function OPOrdItemDesc_KeyDown(e) {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var admrid = DHCWebD_GetObjValue("Adm");
		if (admrid == "") {
			return;
		}
		var OrdObj = document.getElementById('OPOrdItemDesc'); //OPOrdItemDesc
		if (OrdObj) {
			if (OrdObj.value == "") {
				return;
			}
		}
		//alert("OPOrdItemDesc="+OrdObj.value);
		var GetCodeList = document.getElementById('GetCodeList');
		var OrdList = document.getElementById('OPOrdList');
		DHCWeb_SetListStyle(OrdObj, OrdList);
		var HospID = session['LOGON.HOSPID'];
		if (GetCodeList) {
			var encmeth = GetCodeList.value;
			SetListValue(encmeth, 'OPOrdList', OrdObj.value, HospID, admrid);
		}

		websys_setfocus('OPOrdList');
	}
}

function OPOrdItemDesc_KeyUp(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if (key == 32) { //space
		DHCWeb_OtherDocsetfocus2("udhcOPCharge", "Actualmoney");
	}
}

function SetOrdItem(itminfo) {
	//itminfo:
	//ARCIMastDesc:%String,ARCIMastRowID:%String,ARCSubCat:%String,
	//subcatordtype:%String,phuomdesc:%String,ItemPrice:%Float
	//phFreqCode:%String,ARCType:%String
	var arydata = itminfo.split(String.fromCharCode(2));

	var obj = document.getElementById("OPOrdAdd");
	obj.disabled = false;
	var OrdObj = document.getElementById('OPOrdItemDesc');
	if (OrdObj) {
		OrdObj.value = arydata[0];
	}
	var obj = document.getElementById("OPOrdItemRowID");
	if (obj) {
		obj.value = arydata[1];
	}
	var ordobj = document.getElementById("OPOrdType");
	if (ordobj) {
		ordobj.value = arydata[3];
	}
	var unitobj = document.getElementById("OPOrdUnit");
	if (unitobj) {
		unitobj.readOnly = true;
		unitobj.value = arydata[4];
	}
	//alert(ordobj.value + arydata[4]);
	var priceobj = document.getElementById("OPOrdPrice");
	if (priceobj) {
		//&&((arydata[5]!="") && (parseFloat(arydata[5])!=0))
		if ((arydata[3] == "P")) {
			priceobj.readOnly = false;
		} else {
			priceobj.readOnly = true;
		}
		priceobj.value = arydata[5];
	}

	var qtyobj = document.getElementById("OPOrdQty");
	if (qtyobj) {
		qtyobj.value = 1;
	}
	var sqtyobj = document.getElementById("OPOrdSingleQty");
	if (sqtyobj) {
		sqtyobj.value = 1;
		OPOrdSingleQty_KeyUp();
	}
	//ARCOS或ARCIM
	var typobj = document.getElementById("OPOrdARCType");
	if (typobj) {
		typobj.value = arydata[7];
	}
	//var Resobj = document.getElementById("OPOrdBillSum");

	switch (arydata[7]) {
	case "ARCIM":
		SetOEInfo();
		var admrid = "";
		var admobj = document.getElementById("Adm");
		if (admobj) {
			admrid = admobj.value;
		}
		//OPRecLocEncrypt
		var LocRowID = session['LOGON.CTLOCID'];
		var tmpListObj = document.getElementById(aryEName[10]);
		ClearAllList(tmpListObj);
		var encobj = document.getElementById("OPRecLocEncrypt");
		if (encobj) {
			var encmeth = encobj.value;
			SetRecLocList(encmeth, aryEName[10], admrid, arydata[1], "", LocRowID);
			OPOrdItemRecLoc_Change();
		}
		break;
	case "ARCOS":
		var OSRowid = arydata[1];
		var ItemDesc = "";
		var OrdRowIdString = "";
		var obj = document.getElementById("OPOrdAdd");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		OSItemListOpen(OSRowid, ItemDesc, "YES", "", OrdRowIdString);
		break;
	default:

	}
}

function SetOEInfo() {
	//myPARID,myPatType,myInsType
	//set OE_OrdItem info设置这个与其他信息?Pattype,InsType?相关的医嘱信息?
	//是一个独立的函数可以在一定条件下独立运行?
	//录入医嘱和改变此医嘱的费用类型时需要?
	//JSFunName As %String,bPAAdmRowID As %String,bItmMastRowid As %String,bPatType As %String
	//bInsType As %String,bOrderType As %String,bOEPrice As %Float, bARCType As %String
	var myadmrowid = "";
	var myimrowid = "";
	var myOEPrice = "";
	var myarctype = "";
	var myordtype = "";
	var myinstype = "";
	var obj = document.getElementById("Adm");
	if (obj) {
		myadmrowid = obj.value;
	}
	var obj = document.getElementById(aryEName[17]);  //"OPOrdInsRowId"
	if (obj) {
		myinstype = obj.value;
	}
	var imobj = document.getElementById("OPOrdItemRowID");
	if (imobj) {
		myimrowid = imobj.value;
	}
	var priceobj = document.getElementById("OPOrdPrice");
	if (priceobj) {
		if (!priceobj.readOnly) {
			myOEPrice = parseFloat(priceobj.value);
			if (isNaN(myOEPrice)) {
				myOEPrice = "";
			}
		}
	}
	var typobj = document.getElementById("OPOrdARCType");
	if (typobj) {
		myarctype = typobj.value;
	}
	var ordobj = document.getElementById("OPOrdType");
	if (ordobj) {
		myordtype = ordobj.value;
	}

	var encobj = document.getElementById("OPOEInfoEncrypt");
	if (obj) {
		//alert(myinstype+"::::"+myordtype+"::::"+myOEPrice+"::::"+myarctype);
		var encmeth = encobj.value;
		var HospID = session['LOGON.HOSPID'];
		if (cspRunServerMethod(encmeth, "WrtOEOtherInfo", myadmrowid, myimrowid, "", myinstype, myordtype, myOEPrice, myarctype, HospID) == '0') {}
	}
	var obj = document.getElementById("OPOrdPatPrice");
	var objb = document.getElementById("OPOrdQty");
	var Resobj = document.getElementById("OPOrdBillSum");
	var obja1 = document.getElementById("OPOrdPrice");
	var objb1 = document.getElementById("OPOrdDiscPrice");
	var objc1 = document.getElementById("OPOrdInsPrice");
	DHCWeb_CalobjNew(obja1, objb1, objc1, objb, Resobj)
	//DHCWeb_Calobj(obj, objb, Resobj);
}

function WrtOEOtherInfo(OELInfo) {
	var aryinfo = OELInfo.split(String.fromCharCode(2));
	var discobj = document.getElementById("OPOrdDiscPrice");
	if (discobj) {
		discobj.value = aryinfo[1];
	}
	var inscobj = document.getElementById("OPOrdInsPrice");
	if (inscobj) {
		inscobj.value = aryinfo[2];
	}
	var patobj = document.getElementById("OPOrdPatPrice");
	if (patobj) {
		patobj.value = aryinfo[3];
	}
}

function SetRecLocList(encmeth, ListName, paAdmRowid, acrIMRowid, DefRlrid, LocRowID) {
	var ListObj = document.getElementById(ListName);
	if (cspRunServerMethod(encmeth, 'AddToList', ListName, paAdmRowid, acrIMRowid, LocRowID) == '0') {}
	//var txtobj = documnet.getElementById();
	if (ListObj.options.length > 0) {
		var fnflag = 0;
		for (var i = 0; i < ListObj.options.length; i++) {
			var listvalue = ListObj.options[i].value;
			var aryopt = listvalue.split(String.fromCharCode(2));
			if (DefRlrid == "") {
				if (aryopt[1] == "1") {
					fnflag = 1;
					ListObj.selectedIndex = i;
				}
			} else {
				if (aryopt[0] == DefRlrid) {
					fnflag = 1;
					ListObj.selectedIndex = i;
				}
			}
			ListObj.options[i].value = aryopt[0];
		}
		if (fnflag == 0) {
			ListObj.selectedIndex = 0;
		}
	}
}

function SetListValue(encmeth, ListName, OrdCode, HospID, adm) {
	var ListObj = document.getElementById(ListName);
	ClearAllList(ListObj);
	if (cspRunServerMethod(encmeth, 'AddToList', ListName, "", OrdCode, session['LOGON.GROUPID'], HospID, adm) == '0') {}
	ListObj.selectedIndex = 0;
}

function AddToList(ListName, txtdesc, valdesc, ListIdx) {
	var ListObj = document.getElementById(ListName);
	var aryitmdes = txtdesc; //.split("^");
	var aryitminfo = valdesc; //.split("^");
	if (aryitmdes.length > 0) {
		ListObj.options[ListIdx] = new Option(aryitmdes, aryitminfo); //,aryval[i]
	}
}

function CheckStock() {
	//arcim,PackQty,RecLoc  OPOrdItemRowID
	//aryEName[1] = "OPOrdItemRowID";
	//aryEName[4] = "OPOrdQty";
	//aryEName[11] = "OPOrdItemRecLocRID";
	var arcimrid = DHCWebD_GetObjValue(aryEName[1]);
	var PackQty = DHCWebD_GetObjValue(aryEName[4]);
	var RecLocrid = DHCWebD_GetObjValue(aryEName[11]);
	var encmeth = DHCWebD_GetObjValue("OPOrdCheckStockEncrypt");
	try {
		//alert(arcimrid+":"+PackQty+":"+RecLocrid);
		var rtn = cspRunServerMethod(encmeth, arcimrid, PackQty, RecLocrid);
		if (rtn <= 0) {
			return true;
		} else {
			return false;
		}
	} catch (e) {
		alert(e.message);
		return false;
	}
}

function ClearAllList(obj) {
	for (var i = obj.options.length - 1; i >= 0; i--) {
		obj.options[i] = null;
	}
}

function mytest() {
	var OSRowid = "1";
	var ItemDesc = "";
	var OrdRowIdString = "";
	OSItemListOpen(OSRowid, ItemDesc, "YES", "", OrdRowIdString);
}

function OSItemListOpen(id, OSdesc, del, itemtext, OrdRowIdString) {
	//alert("in OSItemListOpen OrdRowIdString="+OrdRowIdString);
	//
	//id:  ordsets RowID
	//OSdesc:
	//del:Yes
	//itemtext:  =""
	//OrdRowIdString=""

	if (!OrdRowIdString) {
		OrdRowIdString = "";
	}
	var obj = document.getElementById("DefaultData");
	///Pa_PatMas->RowID
	var patobj = document.getElementById("PatientID");
	//alert("Itemtext:"+itemtext+"\n OrdRowIdString:"+OrdRowIdString);
	var Patient = "";
	if (patobj) {
		Patient = patobj.value;
	}
	var EpisodeID = "";
	///var objEpisodeID = document.getElementById("EpisodeID")
	var myInsType = "";
	myInsType = DHCWebD_GetObjValue("OPOrdInsType");
	var myInsTypeRid = DHCWebD_GetObjValue("OPOrdInsRowId");
	///alert("myInsType:"+myInsType+"******"+myInsTypeRid);
	var objEpisodeID = document.getElementById("Adm");
	if (objEpisodeID) {
		EpisodeID = objEpisodeID.value;
	}
	if (itemtext != "") {
		itemtext = escape(itemtext);
		var url = "DHCOPOEOSItemList.csp?TEVENT=d128iHideButton" + "&HiddenDelete=" + del + "&itemtext=" + itemtext + "&PatientID=" + Patient + "&EpisodeID=" + EpisodeID + "&OSOrderRowIDs=" + escape(OrdRowIdString) + "&ORDInsType=" + myInsType + "&InsRowID=" + myInsTypeRid + "&OSRID=" + id + "&OrderWindow=" + window.name;
	} else {
		var LabOrderWithoutExternalCode = "";
		var url = "DHCOPOEOSItemList.csp?TEVENT=d128iHideButton" + "&HiddenDelete=" + del + "&ORDERSETID=" + id + "&ARCIMDesc=" + OSdesc + "&PatientID=" + Patient + "&EpisodeID=" + EpisodeID + "&OSOrderRowIDs=" + escape(OrdRowIdString) + "&ORDInsType=" + myInsType + "&InsRowID=" + myInsTypeRid + "&OSRID=" + id + "&OrderWindow=" + window.name;
	}
	//Adds default data to the url - log 22982
	if (obj) {
		var defdata = "";
		url = url + "&DefaultData=" + escape(defdata);
	}
	//alert("url"+url);
	//websys_createWindow(url,"frmOSList","toolbar=no,location=no,directories=yes,status=no,menubar=no,scrollbars=yes,resizable=yes")
	websys_createWindow(url, "DHCOPOEOrdSets", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes")
}

function DHCWeb_CalobjNew(obja1, objb1, objc1, obj2, resobj) {
	if ((obja1) && (objb1) && (objc1) && (obj2)) { //+-*%
		var mynuma1 = parseFloat(obja1.value);
		if (isNaN(mynuma1)) {
			var mynuma1 = 0;
		}
		var mynumb1 = parseFloat(objb1.value);
		if (isNaN(mynumb1)) {
			var mynumb1 = 0;
		}
		var mynumc1 = parseFloat(objc1.value);
		if (isNaN(mynumc1)) {
			var mynumc1 = 0;
		}
		var mynum2 = parseFloat(obj2.value);
		if (isNaN(mynum2)) {
			mynum2 = 0;
		}
		var a1 = mynuma1 * mynum2 + 0.0000001;
		var b1 = mynumb1 * mynum2 + 0.0000001;
		var c1 = mynumc1 * mynum2 + 0.0000001;
		a1 = a1.toFixed(2);
		b1 = b1.toFixed(2);
		c1 = c1.toFixed(2);
		var aa1 = a1 - b1;
		aa1 = aa1.toFixed(2);
		var myres = aa1 - c1;
		resobj.value = myres.toFixed(2).toString();

		//Lid 2015-01-09 计算折扣、记账金额
		var DiscAmtObj = document.getElementById("DiscAmt");
		if (DiscAmtObj) {
			DiscAmtObj.value = b1.toFixed(2);
		}
		var PayorAmtObj = document.getElementById("PayorAmt");
		if (PayorAmtObj) {
			PayorAmtObj.value = c1.toFixed(2);
		}
		return myres.toFixed(2);
	}
}

function HjPrint_Click() {
	var udhcOPPatinfo = parent.frames['udhcOPPatinfo'].document;
	var PatNo = udhcOPPatinfo.getElementById('PatientID').value;
	var PatMrNo = udhcOPPatinfo.getElementById('PatMrNo').value;
	var PatName = udhcOPPatinfo.getElementById('PatName').value;
	var PatSex = udhcOPPatinfo.getElementById('PatSex').value;
	var PatAdmLoc = udhcOPPatinfo.getElementById('AdmLoc').value;
	var AdmDate = udhcOPPatinfo.getElementById('AdmDate').value;
	var AdmDoc = udhcOPPatinfo.getElementById('AdmDocUserId').value;
	var PreScriptNo = "PreScript";
	var HjPrtDate = DateDemo();
	var TxtInfo = "";
	TxtInfo = "PatNo" + String.fromCharCode(2) + PatNo + "^PatMrNo" + String.fromCharCode(2) + PatMrNo;
	TxtInfo += "^PatName" + String.fromCharCode(2) + PatName + "^PatSex" + String.fromCharCode(2) + PatSex;
	TxtInfo += "^AdmDate" + String.fromCharCode(2) + AdmDate + "^PatAdmLoc" + String.fromCharCode(2) + PatAdmLoc;
	TxtInfo += "^AdmDoc" + String.fromCharCode(2) + AdmDoc + "^UserCode" + String.fromCharCode(2) + session['LOGON.USERCODE'];
	TxtInfo += "^PrtDate" + String.fromCharCode(2) + HjPrtDate;
	var objdoc = parent.frames('DHCOPOEList').document;
	var objtbl = objdoc.getElementById('tDHCOPOEList');
	var rows = objtbl.rows.length;
	var MyList = "";
	var MyList1 = "";
	var row = "1";
	var j = 0;
	var PayTotal = 0.00;
	MyList = "序号^项目名称^单价^数量^合计^序号^项目名称^单价^数量^合计";
	for (var i = 1; i < rows; i++) {
		row = i;
		var OPOrdBillFlag = objdoc.getElementById("OPOrdBillFlagz" + row);
		if (OPOrdBillFlag.checked) {
			j = j + 1;
			MyList1 = "";
			var OrdItemName = objdoc.getElementById("OPOrdItemDescz" + row).innerText;
			var Price = objdoc.getElementById("OPOrdPricez" + row).innerText;
			var Qty = objdoc.getElementById("OPOrdQtyz" + row).innerText;
			var PaySum = objdoc.getElementById("OPOrdBillSumz" + row).innerText;
			var OrdItemHjRowid = objdoc.getElementById("OrdRowIdz" + row).value;
			var OrdItemHjType = objdoc.getElementById("OPOrdTypez" + row).value;
			var OrdXh = objdoc.getElementById("OPOrdNoz" + row).innerText;
			//alert(row+"dddd"+OrdItemHjRowid+"ccc"+OrdItemHjType);
			if (OrdItemHjRowid != "") {
				if (OrdItemHjType != "R") {
					OrdItemName = OrdItemName.substr(0, 16);
					Price = parseFloat(Price) + 0.0000001;
					Price = Price.toFixed(2);
					PayTotal = PayTotal + parseFloat(PaySum);
					PayTotal = PayTotal + 0.0000001;
					PayTotal = PayTotal.toFixed(2);
					MyList1 = OrdXh + "^" + OrdItemName + "^" + Price + "^" + Qty + "^" + PaySum;
					//MyList1= OrdXh+"^"+OrdItemName +"^"+ Price +"^"+ Qty +"^"+PaySum+"^^^^^";
					//alert("before"+MyList);
					if (j / 8 > 1) {
						MyList = MyList.replace("^^^^^", "^" + MyList1);
					} else {
						MyList = MyList + String.fromCharCode(2) + MyList1 + "^^^^^";
					}
					//alert("after"+MyList);
					/*
					if (j % 2 == 0) { 
						MyList = MyList + "^" + MyList1;
					} else {
						MyList = MyList + String.fromCharCode(2) + MyList1;
					}
					*/
				}
			}
		}
	}
	TxtInfo += "^PayTotal" + String.fromCharCode(2) + PayTotal;
	//if (j%2==1) MyList=MyList+"^^^^^";
	//alert(TxtInfo);
	//alert(MyList);
	InvPrintNew(TxtInfo, MyList);
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function DateDemo() {
	var d;
	var s; // 声明变量?
	d = new Date(); // 创建 Date 对象?
	s = d.getYear() + "-";
	s += (d.getMonth() + 1) + "-"; // 获取月份?
	s += d.getDate(); // 获取日?
	// 获取年份?
	return (s); // 返回日期?
}

document.body.onload = BodyLoadHandler;
