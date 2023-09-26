///UDHCJFDepositByStrike.js

var MyPrtAry = new Array();
var MyAryIdx = 0;

function BodyLoadHandler() {
	var Guser = session['LOGON.USERID'];
	document.getElementById('Guser').value = "";
	var PrtObj = document.getElementById('BtnPrint');
	PrtObj.onclick = Print_Click;
	var PrtObj = document.getElementById('putout');
	PrtObj.onclick = putout_Click;
}

function LookUpUser(value) {
	var data = value.split('^');
	var Obj = document.getElementById('Guser');
	Obj.value = data[1];
}

function Print_Click() {
	var job = document.getElementById('TJobz' + 1).innerText;
	if (job == "") {
		return;
	}
	for (var idx = 0; idx <= MyAryIdx; idx = idx + 1) {
		MyPrtAry[idx] = "";
	}
	MyAryIdx = 0;
	PrintClickGetVal();
	PrintDepositstrike();
}

function putout_Click() {
	var job = document.getElementById('TJobz' + 1).innerText;
	if (job == "") {
		return;
	}
	for (var idx = 0; idx <= MyAryIdx; idx = idx + 1) {
		MyPrtAry[idx] = "";
	}
	MyAryIdx = 0;
	PrintClickGetVal();
	PrintDepositstrikeout();
}

function PrintClickGetVal() {
	var job = document.getElementById('TJobz' + 1).innerText;
	var obj = document.getElementById('getSendtoPrintinfo');
	if (obj) {
		var encmeth = obj.value;
	}
	var Printinfo = cspRunServerMethod(encmeth, "WrtExcle", job);
}

function WrtExcle(val) {
	MyPrtAry[MyAryIdx] = val;
	MyAryIdx = MyAryIdx + 1;
}

function PrintDepositstrikeout() {
	try {
		var GetPrescPath = document.getElementById("getpath");
		if (GetPrescPath) {
			var encmeth = GetPrescPath.value;
		} else {
			var encmeth = '';
		}
		if (encmeth != "") {
			var TemplatePath = cspRunServerMethod(encmeth);
		}
		var BeginDate;
		var EndDate;
		var myencmeth = "";
		var xlApp;
		var xlsheet;
		var xlBook;
		var Template = TemplatePath + "JF_DepositStrike.xls";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var xlsrow = 4;
		var xlsCurcol = 0;
		var Cash = 0,
		UnCash = 0;
		for (var Row = 0; Row < MyAryIdx; Row++) {
			xlsrow = xlsrow + 1;
			var ary = MyPrtAry[Row].split("^");
			xlsheet.cells(xlsrow, xlsCurcol + 1) = ary[0];
			xlsheet.cells(xlsrow, xlsCurcol + 2) = ary[1];
			xlsheet.cells(xlsrow, xlsCurcol + 3) = ary[2];
			xlsheet.cells(xlsrow, xlsCurcol + 4) = ary[3];
			xlsheet.cells(xlsrow, xlsCurcol + 5) = ary[4];
			xlsheet.cells(xlsrow, xlsCurcol + 6) = ary[5];
			xlsheet.cells(xlsrow, xlsCurcol + 7) = ary[6];
			xlsheet.cells(xlsrow, xlsCurcol + 8) = ary[7];
			xlsheet.cells(xlsrow, xlsCurcol + 9) = ary[8];

			if (ary[7].indexOf("现金") != -1) {
				//xlsheet.cells(xlsrow,xlsCurcol+7)=ary[6];
				//Cash=Cash+eval(ary[6]);
			} else {
				//xlsheet.cells(xlsrow,xlsCurcol+8)=ary[6];
				//UnCash=UnCash+eval(ary[6]);
			}
			//xlsheet.cells(xlsrow,xlsCurcol+9)=ary[8];
		}
		//xlsrow=xlsrow+1;
		//xlsheet.cells(xlsrow,xlsCurcol+1)="总计";
		//xlsheet.cells(xlsrow,xlsCurcol+7)=Cash;
		//xlsheet.cells(xlsrow,xlsCurcol+8)=UnCash;
		xlsrow = xlsrow + 1;
		xlsheet.cells(xlsrow, xlsCurcol + 2) = "制表人:" + " " + session['LOGON.USERNAME'];
		CellLine(xlsheet, 5, xlsrow - 1, 1, 10, 1);
		CellLine(xlsheet, 5, xlsrow - 1, 1, 9, 4);
		CellLine(xlsheet, 5, xlsrow - 1, 1, 9, 3)
		//xlsheet.printout;
		xlApp.visible = true;
		xlBook.Close;
		xlApp = null;
		xlsheet.Quit;
		xlsheet = null;
	} catch (e) {
		alert(e.message);
	}
}

function PrintDepositstrike() {
	try {
		var GetPrescPath = document.getElementById("getpath");
		if (GetPrescPath) {
			var encmeth = GetPrescPath.value;
		} else {
			var encmeth = '';
		}
		if (encmeth != "") {
			var TemplatePath = cspRunServerMethod(encmeth);
		}
		var BeginDate;
		var EndDate;
		var myencmeth = "";
		var xlApp;
		var xlsheet;
		var xlBook;
		var Template = TemplatePath + "JF_DepositStrike.xls";
		xlApp = new ActiveXObject("Excel.Application");
		xlBook = xlApp.Workbooks.Add(Template);
		xlsheet = xlBook.ActiveSheet;
		var xlsrow = 4;
		var xlsCurcol = 0;
		var Cash = 0;
		var UnCash = 0;
		for (var Row = 0; Row < MyAryIdx; Row++) {
			xlsrow = xlsrow + 1;
			var ary = MyPrtAry[Row].split("^");
			xlsheet.cells(xlsrow, xlsCurcol + 1) = ary[0];
			xlsheet.cells(xlsrow, xlsCurcol + 2) = ary[1];
			xlsheet.cells(xlsrow, xlsCurcol + 3) = ary[2];
			xlsheet.cells(xlsrow, xlsCurcol + 4) = ary[3];
			xlsheet.cells(xlsrow, xlsCurcol + 5) = ary[4];
			xlsheet.cells(xlsrow, xlsCurcol + 6) = ary[5];
			xlsheet.cells(xlsrow, xlsCurcol + 7) = ary[6];
			xlsheet.cells(xlsrow, xlsCurcol + 8) = ary[7];
			xlsheet.cells(xlsrow, xlsCurcol + 9) = ary[8];
			if (ary[7].indexOf("现金") != -1) {
				//xlsheet.cells(xlsrow,xlsCurcol+7)=ary[6]
				Cash = Cash + eval(ary[6]);
			} else {
				//xlsheet.cells(xlsrow,xlsCurcol+8)=ary[6];
				UnCash = UnCash + eval(ary[6]);
			}
			//xlsheet.cells(xlsrow,xlsCurcol+9)=ary[8];
		}
		//xlsrow=xlsrow+1;
		//xlsheet.cells(xlsrow,xlsCurcol+1)="总计"
		//xlsheet.cells(xlsrow,xlsCurcol+7)=Cash;
		//xlsheet.cells(xlsrow,xlsCurcol+8)=UnCash;
		xlsrow = xlsrow + 1;
		xlsheet.cells(xlsrow, xlsCurcol + 2) = "制表人:" + " " + session['LOGON.USERNAME'];
		CellLine(xlsheet, 5, xlsrow - 1, 1, 10, 1);
		CellLine(xlsheet, 5, xlsrow - 1, 1, 9, 4);
		CellLine(xlsheet, 5, xlsrow - 1, 1, 9, 3);
		xlsheet.printout;
		xlBook.Close(savechanges = false);
		xlApp = null;
		xlsheet.Quit;
		xlsheet = null;
	} catch (e) {
		alert(e.message);
	}
}

function CellLine(objSheet, row1, row2, c1, c2, Style) {
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(Style).LineStyle = 1;
}

function UnloadHandler() {
	var SelRowObj = document.getElementById('TJobz' + 1);
	job = SelRowObj.innerText;
	if (job == "") {
		return;
	}
	var KillTMPPrtGlbobj = document.getElementById("KillTmp");
	if (KillTMPPrtGlbobj) {
		var encmeth = KillTMPPrtGlbobj.value;
	} else {
		var encmeth = '';
	}
	var mytmp = cspRunServerMethod(encmeth, "DepositByPaid", job);
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler;
