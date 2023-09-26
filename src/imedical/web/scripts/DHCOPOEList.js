///DHCOPOEList.js

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
session['OPComList'] += "OPLabPlacerCode" + "^";

//OrdItem Foot Limited Flag
//Default OPOrdPrescNo
var m_OPOrdFootLimitFlag = "1";

function BodyLoadHandler() {
	var obj = document.getElementById("tDHCOPOEList");
	if (obj) {
		obj.ondblclick = tDHCOPOEList_DblClick;
	}
	IntDoument();
	//LoadCLSID();
	//document.onkeydown = document_OnKeyDown;
	document.onkeydown = DHCWeb_DocumentOnKeydown;
	var obj = document.getElementById("AllSelect");
	if (obj) {
		obj.onclick = AllSelect_OnClick;
	}
	var obj = document.getElementById("OPMultNum");
	if (obj) {
		obj.onkeypress = OPMultNum_OnKeyPress;
		obj.onfocus = OPMultNum_OnFocus;
		obj.onblur = OPMultNum_OnBlur;
		obj.onchange = OPMultNum_OnChange;
		DHCWebD_SetObjValueC("OPMultNum", 1);
		obj.style.imeMode = "disabled";
	}
	m_OPOrdFootLimitFlag = DHCWebD_GetObjValue("OEORDLimitFootFlagEncypt");

	DHCWebTabCSS_InitTab();

	//setTimeout("DHCWebD_CalAdm()", 1);
	DHCWebD_CalAdm();
}

function document_OnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();
}

function IntDoument() {
	var obj = document.getElementById("cPrompt");
	if (obj) {
		obj.innerText = "";
	}
	var tabOPList = document.getElementById("tDHCOPOEList");
	var rows = tabOPList.rows.length;
	DHCWebD_SetObjValueB("AllSelect", true);
	for (var row = 1; row < rows - 1; row++) {
		var obj = document.getElementById('LimitFlagz' + row);
		var sExcute = DHCWebD_GetCellValue(obj);
		var sSelect = document.getElementById('OPOrdBillFlagz' + row);
		if ((sExcute == "Y")) {
			var obj = document.getElementById("cPrompt"); //如果有皮试不收费医嘱?做提示
			if (obj && obj.innerText == "") {
				obj.innerText = "皮试医嘱";
				obj.style.color = "red";
			}
			//2011-12-12
			sSelect.disabled = true;   //Lid 2010-03-04
		} else {
			//2011-12-12
			sSelect.disabled = false;
		}
		//Set AllSelect
		var myBillFlagobj = document.getElementById("OPOrdBillFlagz" + row);
		var mySelFlag = DHCWebD_GetCellValue(myBillFlagobj);
		if ((!mySelFlag) && (sExcute != "Y")) {
			DHCWebD_SetObjValueB("AllSelect", mySelFlag);
		}
		var OPLabPlacerCodeobj = document.getElementById('OPLabPlacerCodez' + row);
		if (OPLabPlacerCodeobj) {
			var TRobj = OPLabPlacerCodeobj.parentElement;
			var LabPlacerCode = OPLabPlacerCodeobj.innerText;
			switch (LabPlacerCode) {
			case "A":
				TRobj.className = "Purple";
				break;
			case "C":
				TRobj.className = "Gray";
				break;
			case "R":
				TRobj.className = "Red";
				break;
			case "P":
				TRobj.className = "Fuchsia";
				break;
			case "Y":
				TRobj.className = "Yellow";
				break;
			case "G":
				TRobj.className = "Green";
				break;
			case "H":
				TRobj.className = "Black";
				break;
			case "B":
				TRobj.className = "Blue";
				break;
			case "W":
				TRobj.className = "White";
				break;
			case "O":
				TRobj.className = "Maroon";
				break;
			default:
			}
		}
	}
}

function OPMultNum_OnKeyPress() {
	if (event.keyCode == 13) {
		//Set focus
		event.keyCode = 0;
		DHCWeb_OtherDocsetfocus("DHCOPOEOrdInput", "OPOrdItemDesc");
		return false;
	}
	DHCWeb_SetLimitNum();
}

function OPMultNum_OnBlur() {
	//Set Default Number for Order
	var myOPMultNum = DHCWebD_GetObjValue("OPMultNum");
	if ((isNaN(myOPMultNum)) || (myOPMultNum == "")) {
		DHCWebD_SetObjValueC("OPMultNum", 1);
		return;
	}
}

function OPMultNum_OnFocus() {
	OldOPMultNum = this.value;
}

function OPMultNum_OnChange() {
	/*
	var myrtn = window.confirm("付数改变,是否修改医嘱数量?");
	if (!myrtn){
		return;
	}
	*/
	var tabOPList = document.getElementById("tDHCOPOEList");
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows - 1; row++) {
		var oeitmobj = document.getElementById("OrdRowIdz" + row);
		var oeitmrid = DHCWebD_GetCellValue(oeitmobj);
		var arcimobj = document.getElementById("OPOrdItemRowIDz" + row);
		var arcimrid = DHCWebD_GetCellValue(arcimobj);
		var arcimobj = document.getElementById("OPOrdItemRowIDz" + row);
		var arcimrid = DHCWebD_GetCellValue(arcimobj);
		var FCHerbFlag = tkMakeServerCall("web.UDHCJFBaseCommon", "CheckFCHerb", arcimrid);
		if ((oeitmrid != "") || (FCHerbFlag == "0")) {
			//1.医嘱保存后不能修改数量
			//2.非草药费，不能修改"付数"来改变数量
		} else {
			ModifyOrderNum(row);
		}
	}
	DHCWebD_CalAdm();
}

function AllSelect_OnClick() {
	var mycheck = DHCWebD_GetObjValue("AllSelect");
	SelectAll(mycheck);
}

function SelectAll(myCheck) {
	var myRows = DHCWeb_GetTBRows("tDHCOPOEList");
	for (var i = 1; i < myRows; i++) {
		var obj = document.getElementById("OPOrdBillFlagz" + i);
		var sSelect = document.getElementById('OPOrdBillFlagz' + i);
		if (!sSelect.disabled) {
			DHCWebD_SetListValueA(obj, myCheck);
		}
	}
	if (myRows > 1) {
		//SelectRowHandler();
		DHCWebD_CalAdm();
	}
}

function tDHCOPOEList_DblClick() {
	var myobj = parent.frames["DHCOPOEList"].window;
	var tabOPList = document.getElementById('tDHCOPOEList');
	var rows = tabOPList.rows.length;
	var lastrowindex = rows - 1;
	var selectrow = DHCWeb_GetRowIdx(myobj);
	if (lastrowindex == selectrow) {
		return;
	}
	//Write List Data to Text;
	var myobjlist = parent.frames["DHCOPOEList"];
	var myobjdoc = parent.frames["DHCOPOEOrdInput"];
	DHCWebD_WrtItemInfo(myobjlist, myobjdoc, session['OPComList'], (selectrow));
	var descobj = myobjdoc.document.getElementById("OPOrdItemRecLoc");
	var ridobj = myobjdoc.document.getElementById("OPOrdItemRecLocRID");
	//receive depart RowID
	var locrid = "";
	if ((descobj) && (ridobj)) {
		descobj.options[0].value = ridobj.value;
		var locrid = ridobj.value;
	}
	//set the Price Element Write Or ReadOnly
	var ordobj = myobjdoc.document.getElementById("OPOrdType");
	var priceobj = myobjdoc.document.getElementById("OPOrdPrice");
	if (ordobj.value == "P") {
		priceobj.readOnly = false;
	} else {
		priceobj.readOnly = true;
	}
	//send current to OPInput component;
	var obj = myobjdoc.document.getElementById("OPOrdSelectIdx");
	if (obj) {
		obj.value = selectrow;
	}
	//Contral Delete Button;
	var inwin = myobjdoc.window;

	var obj = myobjdoc.document.getElementById("OPOrdAdd");
	DHCWeb_DisBtn(obj);

	var obj = myobjdoc.document.getElementById("OPOrdDel");
	if (obj) {
		DHCWeb_AvailabilityBtnA(obj, inwin.OPOrdDel_Click);
	}

	var editobj = myobjdoc.document.getElementById("OPOrdEdit");
	var admobj = myobjdoc.document.getElementById("Adm");
	var admrid = DHCWebD_GetCellValue(admobj);
	var oeitmrid = DHCWeb_GetColumnData("OrdRowId", selectrow);
	var arcimrid = DHCWeb_GetColumnData("OPOrdItemRowID", selectrow);
	if (oeitmrid == "") {
		DHCWeb_AvailabilityBtnA(editobj, inwin.OPOrdEdit_Click);
	} else {
		DHCWeb_DisBtn(editobj);
	}
	
	var encobj = myobjdoc.document.getElementById("OPRecLocEncrypt");
	if (encobj) {
		var encmeth = encobj.value;
		inwin.SetRecLocList(encmeth, "OPOrdItemRecLoc", admrid, arcimrid, locrid);
	}
}

function SetInputRecLoc() {
	var encobj = myobjdoc.document.getElementById("OPRecLocEncrypt");
	if (encobj) {
		var encmeth = encobj.value;
		inwin.SetRecLocList(encmeth, "OPOrdItemRecLoc", admrid, arcimrid, locrid);
	}
}

function SelectRowHandler() {
	PrescLink();
	DHCWebD_CalAdm();
}

function PrescLink() {
	var tabOPList = document.getElementById('tDHCOPOEList');
	var rows = tabOPList.rows.length;
	var lastrowindex = rows - 1;
	var selectrow = DHCWeb_GetRowIdx(window);
	if (lastrowindex == selectrow) {
		return;
	}
	if (m_OPOrdFootLimitFlag == "0") {
		return;
	}
	var myFiledName = "OPOrdPrescNo";
	switch (m_OPOrdFootLimitFlag) {
	case "0":
		break;
	case "1":
		myFiledName = "OPOrdPrescNo";
		break;
	case "2":
		myFiledName = "OEOrdDoctorDR";
		break;
	case "3":
		myFiledName = "OPOrdItemRecLocRID";
		break;
	case "4":
		break;
	default:
		myFiledName = "OPOrdPrescNo";
		break;
	}
	var myFiledName = "TPreOeoriPrescno"; //与皮试医嘱关联的医嘱同样遵循皮是医嘱限制
	var myPrescNo = DHCWeb_GetColumnData(myFiledName, selectrow);
	if (myPrescNo == "") {
		return;
	}
	var myOrdType = DHCWeb_GetColumnData("OPOrdType", selectrow);
	if (myOrdType != "R") {
		//return;
	}
	var myCheck = DHCWeb_GetColumnData("OPOrdBillFlag", selectrow);
	for (var i = 1; i < rows; i++) {
		if (selectrow != i) {
			var myCurPrescNo = DHCWeb_GetColumnData(myFiledName, i);
			if (myCurPrescNo == myPrescNo) {
				//the Same PrescNo
				var obj = document.getElementById("OPOrdBillFlagz" + i);
				var sSelect = document.getElementById('OPOrdBillFlagz' + i);
				if (!sSelect.disabled) {
					DHCWebD_SetListValueA(obj, myCheck);
				}
			}
		}
	}
}

function LoadCLSID() {
	var mywin = parent.window.open("dd.html", "", "width=1,height=1");
	var mydoc = mywin.document;
	var mybody = mywin.body;
	mydoc.write("<body onload='setTimeout('self.close()',1000)'>")
	mydoc.write("<object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,0' VIEWASTEXT>");
	mydoc.write("</object>");
	mydoc.write("</body>")
	var teststr = "E:\config.xml";
	var mystr = "PatName" + String.fromCharCode(2) + "Check^";
	mystr += "FeeSum" + String.fromCharCode(2) + "100^";
	mystr += "FeeCapSum" + String.fromCharCode(2) + "1000^";
	//var myobj = mydoc.getElementById("ClsBillPrint");
	//setTimeout("self.close()", 1000);
	mywin.opener = null;
	mywin.close();
}

///Lid
///2011-12-14
///付数发生改变时，修改医嘱数量(注:医嘱保存后，不能修改数量)
function ModifyOrderNum(SelectRowIndex) {
	//DHCWebD_OrdNumConv();
	var NewMultNum = DHCWebD_GetObjValue("OPMultNum");
	var Price = DHCWeb_GetColumnData("OPOrdPrice", SelectRowIndex);
	var OrdQty = DHCWeb_GetColumnData("OPOrdQty", SelectRowIndex);
	var InitQty = DHCWeb_CalobjA(OldOPMultNum, OrdQty, "%");
	var NewOrdQty = DHCWeb_CalobjA(InitQty, NewMultNum, "*");
	DHCWeb_SetColumnData("OPOrdQty", SelectRowIndex, NewOrdQty);
	var NewOrdBillSum = DHCWeb_CalobjA(NewOrdQty, Price, "*");
	DHCWeb_SetColumnData("OPOrdBillSum", SelectRowIndex,  NewOrdBillSum);
}

document.body.onload = BodyLoadHandler;
