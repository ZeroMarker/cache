//// udhcOPInv.SingleINVQuery.js

var GUser;
var AllExecute;
var RebillFlag;
var PartRefFlag;
var PrtXMLName = "";
var MyAryIdx = 0;
var MyPrtAry = new Array();
var FramName = "udhcOPInv_SingleINVQuery";

function BodyLoadHandler() {
	var obj = document.getElementById("ReceipNO");
	if (obj) {
		obj.onkeydown = ReceipNO_KeyDown;
	}

	obj = document.getElementById("PrintDetails");
	if (obj) {
		obj.onclick = PrintDetails_Click;
	}
	
	obj = document.getElementById("RefClear");
	if (obj) {
		obj.onclick = RefundClear_Click;
	}

	obj = document.getElementById("BtnQuery");
	if (obj) {
		obj.onclick = INVQuery_Click;
	}
	
	var obj = document.getElementById("bPRTProve");
	if (obj) {
		obj.onclick = bPRTProve_OnClick;
	}

	var obj = document.getElementById("bReadCardQuery");
	if (obj) {
		obj.onclick = ReadCardQuery_OnClick;
	}

	var obj = document.getElementById("BINVPrint");
	if (obj) {
		obj.onclick = BINVPrint_OnClick;
	}
	var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
	switch (myDHCVersion) {
	case "0":
		DHCP_GetXMLConfig("InvPrintEncrypt", "PrtINVList");    //INVPrtFlag
		PrtXMLName = "PrtINVList"
		default:
			IntPRTDoc();
	}

	ReadINVInfo();

}

function IntPRTDoc() {
	///Load Base Config
	var mygLoc = session['LOGON.GROUPID'];
	var encmeth = DHCWebD_GetObjValue("GSCFEncrypt");
	if (encmeth != "") {
		var myrtn = cspRunServerMethod(encmeth, mygLoc);
	}
	var myary = myrtn.split("^");
	if (myary[0] == 0) {
		m_AbortPop = myary[7];
		m_RefundPop = myary[8];
		var myPrtXMLName = myary[10];
	}

	PrtXMLName = myPrtXMLName;
	DHCP_GetXMLConfig("InvPrintEncrypt", myPrtXMLName);
}

function bPRTProve_OnClick() {
	PrintClickHandlerINVRep();
}

function BINVPrint_OnClick() {
	//
}

function ReadCardQuery_OnClick() {
	var myrtn = DHCACC_GetAccInfo();
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		ReadCardQueryINV(myary[5]);
		//ReadPatInfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		alert(t["-201"]);
		//var obj=document.getElementById("PatientID");
		//obj.value=myary[5];
		//ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

function QueryInv() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=udhcOPInv.SingleINVQuery";
	var NewWin = open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function WrtExcle(val) {
	var ary = val.split("^");
	MyPrtAry[MyAryIdx] = val;
	MyAryIdx = MyAryIdx + 1;
}

function ReadCardQueryINV(PAPMNo) {
	var mygLocDR = session['LOGON.GROUPID'];
	var myULoadLocDR = session['LOGON.CTLOCID'];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPINV.Query";
	lnk += "&FramName=udhcOPInv_SingleINVQuery&PatientNO=" + PAPMNo;
	lnk += "&AuditFlag=&sFlag=ALL&INVStatus=N";
	lnk += "&gLocDR=" + mygLocDR + "&ULoadLocDR=" + myULoadLocDR;
	var NewWin = open(lnk, "udhcOPINV_Query", "scrollbars=yes,resizable=yes,top=100,left=50,width=930,height=460");
}

function INVQuery_Click() {
	ReadCardQueryINV("");
}

function RefundClear_Click() {
	IntRefMain();
	AddIDToOrder("");
}

function ReceipNO_KeyDown(e) {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj) && (obj.value != "") && (key == 13)) {
		var No = obj.value;
		var encmeth = DHCWebD_GetObjValue("getReceipID");
		if (cspRunServerMethod(encmeth, 'SetReceipID', '', No) == '-1') {
			alert(t["12"]);
			websys_setfocus('ReceipNO');
			return websys_cancel();
		} else {
			var ReceipID = DHCWebD_GetObjValue("ReceipID");
			var myTabFlag = DHCWebD_GetObjValue("TabFlag");
			var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
			if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID, myTabFlag) == '0') {
				var myTabFlag = DHCWebD_GetObjValue("TabFlag");
				var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCOPINV.OEOrder&invRowId=" + ReceipID;
				lnk += "&invType=" + myTabFlag;
				parent.frames['UDHCOPINV_OEOrder'].location.href = lnk;
			}
		}
	}
}

function ReadINVInfo() {
	var ReceipID = DHCWebD_GetObjValue("ReceipID");
	if (ReceipID == "") {
		return;
	}
	var myTabFlag = DHCWebD_GetObjValue("TabFlag");
	var encmeth = DHCWebD_GetObjValue("getReceiptinfo");
	if (cspRunServerMethod(encmeth, 'SetReceipInfo', '', ReceipID, myTabFlag) == '0') {
		var myTabFlag = DHCWebD_GetObjValue("TabFlag");
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCOPINV.OEOrder&invRowId=" + ReceipID;
		lnk += "&invType=" + myTabFlag;
		parent.frames['UDHCOPINV_OEOrder'].location.href = lnk;
	}
}

function PrintDetails_Click() {
	var myReceiptID = DHCWebD_GetObjValue("ReceipID");
	if (myReceiptID == "") {
		return;
	}
	mystr = "0^" + myReceiptID;
	BillPrintNew(mystr);
}

function BillPrintNew(INVstr) {
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = INVstr.split("^");
	for (var invi = 1; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var beforeprint = document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {
				var encmeth = beforeprint.value;
			} else {
				var encmeth = '';
			}

			var payobj = document.getElementById("PayMode");
			if (payobj) {
				var PayMode = payobj.value;
			}
			var PayMode = "";
				var Guser = session['LOGON.USERID'];
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], Guser, PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var beforeprint = document.getElementById('TestPrint');
	if (beforeprint) {
		var encmeth = beforeprint.value;
	} else {
		var encmeth = '';
	}
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function SetReceipID(value) {
	var myary = value.split("^");
	var IDobj = document.getElementById("ReceipID");
	IDobj.value = myary[0];
	var obj = document.getElementById("TabFlag");
	if (obj) {
		obj.value = myary[1];
	}
}

function SetReceipInfo(value) {
	var Split_Value = value.split("^");
	var Sumobj = document.getElementById("Sum");
	var sexobj = document.getElementById("PatientSex");
	var nameobj = document.getElementById("PatientName");
	var noobj = document.getElementById("PatientID");
	//var cobj=document.getElementById("Abort");
	//var robj=document.getElementById("Refund");

	GUser = session['LOGON.USERID'];
	noobj.value = Split_Value[0];
	nameobj.value = Split_Value[1];
	sexobj.value = Split_Value[2];
	Sumobj.value = Split_Value[3];
	//alert(Split_Value[8]);
	if (Split_Value[8] == "Y") {
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}

	if (Split_Value[4] == "A") {
		DHCWeb_DisBtnA("bPRTProve");
		DHCWeb_DisBtnA("PrintDetails");
		alert(t["11"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}

	if (Split_Value[4] == "S") {
		DHCWeb_DisBtnA("bPRTProve");
		DHCWeb_DisBtnA("PrintDetails");
		alert(t["12"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}

	if (Split_Value[5] == "1") {
		alert(t["06"]);
		websys_setfocus('ReceipNO');
		return websys_cancel();
	}

	var obj = document.getElementById("bPRTProve");
	if (obj) {
		obj.disenabled = false;
		obj.onclick = bPRTProve_OnClick;
	}

	var obj = document.getElementById("PrintDetails");
	if (obj) {
		obj.disenabled = false;
		obj.onclick = PrintDetails_Click;
	}

}

function AddIDToOrder(ReceipID) {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCOPINV.OEOrder&invRowId=" + ReceipID;
	var AdmCharge = parent.frames['UDHCOPINV_OEOrder'];
	AdmCharge.location.href = lnk;
}

function IntRefMain() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=udhcOPInv.SingleINVQuery";
	var AdmCharge = parent.frames['udhcOPInv_SingleINVQuery'];
	AdmCharge.location.href = lnk;

}

function PrintClickHandlerINVRep() {
	try {
		var GetPrescPath = document.getElementById("GetRepPath");
		if (GetPrescPath) {
			var encmeth = GetPrescPath.value;
		} else {
			var encmeth = '';
		}
		if (encmeth != "") {
			TemplatePath = cspRunServerMethod(encmeth);
		}
		var BeginDate,
		EndDate,
		TotalSum,
		PatPaySum,
		PayorSum;
		var ParkINVInfo,
		ParkSum,
		ParkNum;
		var RefundINVInfo,
		RefundSum,
		RefundNum,
		CheckSum,
		CheckNum;
		var INVInfo;
		var UserCode = "";
		var myTotlNum = 0;
		var CashNUM = 0;
		var myencmeth = "";

		var obj = document.getElementById("DateTrans");
		if (obj) {
			myencmeth = obj.value;
		}

		///  add by zl
		for (var idx = 0; idx <= MyAryIdx; idx = idx + 1) {
			MyPrtAry[idx] = "";
		}

		MyAryIdx = 0;
		var myPrtId = DHCWebD_GetObjValue("ReceipID");
		if (myPrtId == "") {
			return;
		}

		var beforeprint = document.getElementById('GetPrtFeeDetail');
		if (beforeprint) {
			var encmeth = beforeprint.value;
		} else {
			var encmeth = '';
		}

		var Printinfo1 = cspRunServerMethod(encmeth, "WrtExcle", myPrtId);

		var xlApp,
		xlsheet,
		xlBook
		var Template = TemplatePath + "HospOPPatPrt.xls";
		var UserCode = "";
			var obj = document.getElementById("sUser");
		if (obj) {
			var UserCode = obj.value;
		}

		//var obj=document.getElementById("HEDate");
		var obj = document.getElementById("CurDate");
		if (obj) {
			var PDate = obj.value;
		}

		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;

		var xlsCurcol = 0;

		var myData = "Begin";
		var myEncrypt = DHCWebD_GetObjValue("ReadPRTData");
		var myTabFlag = DHCWebD_GetObjValue("TabFlag");
		var myReceipID = DHCWebD_GetObjValue("ReceipID");

		myData = cspRunServerMethod(myEncrypt, "", myReceipID, "", "", myTabFlag);

		var myval = "";
		var myary = myData.split(String.fromCharCode(3));
		var myPatAry = myary[0].split("^");
		myval = myPatAry[0];
		xlsheet.cells(5, 4) = myval;
		myval = myPatAry[1];
		xlsheet.cells(5, 8) = myval;
		myval = myPatAry[2];
		xlsheet.cells(6, 5) = myval;

		var xlsrow = 6;
		var myLAry = myary[1].split("^");
		var mylen = myLAry.length;
		///if (myary[1]!="")
		for (var i = 0; i < mylen; i++) {
			var myFeeAry = myLAry[i].split(String.fromCharCode(2));
			///var myary=myData.split();
			///myIdx=myary[0];

			xlsrow = xlsrow + 1;
			myval = myFeeAry[0];
			xlsheet.cells(xlsrow, 4) = myval;

			myval = myFeeAry[1];
			xlsheet.cells(xlsrow, 6) = myval;
		}

		xlsrow = xlsrow + 3
			for (var Row = 0; Row < MyAryIdx; Row++) {
				xlsrow = xlsrow + 1;
				var ary = MyPrtAry[Row].split("^");

				xlsheet.cells(xlsrow, xlsCurcol + 1) = ary[0]; //idx
				xlsheet.cells(xlsrow, xlsCurcol + 2) = ary[1]; //ItemDesc
				xlsheet.cells(xlsrow, xlsCurcol + 5) = ary[2]; //ItemDesc
				xlsheet.cells(xlsrow, xlsCurcol + 6) = ary[3]; //ItmUPrice
				xlsheet.cells(xlsrow, xlsCurcol + 7) = ary[4]; //ItmQty
				xlsheet.cells(xlsrow, xlsCurcol + 8) = ary[5]; //UDesc
				xlsheet.cells(xlsrow, xlsCurcol + 9) = ary[6]; //ItmTotalAmount
			}

			xlsheet.Range(xlsheet.Cells(xlsrow + 3, 6), xlsheet.Cells(xlsrow + 3, 9)).MergeCells = 1;

		xlsheet.Range(xlsheet.Cells(xlsrow + 4, 7), xlsheet.Cells(xlsrow + 4, 8)).MergeCells = 1;
		xlsheet.cells(xlsrow + 3, 6) = t['hoscode'];

		xlsheet.cells(xlsrow + 4, 7) = t['depcode'];

		var myCurDate = DHCWebD_GetObjValue("CurDate");
		xlsheet.cells(xlsrow + 5, 7) = myCurDate;

		xlsheet.printout
		xlBook.Close(savechanges = false);

		xlApp = null;
		xlsheet.Quit;
		xlsheet = null;
	} catch (e) {
		//alert(e.message);
	}
}

document.body.onload = BodyLoadHandler;
