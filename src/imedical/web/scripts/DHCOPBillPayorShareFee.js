/// DHCOPBillPayorShareFee.js

var aryCatDesc = "";
var aryPMDesc = "";
var ver;

function checkIEVersion() {
	var ua = navigator.userAgent;
	var s = "MSIE";
	var i = ua.indexOf(s);
	if (i >= 0) {
		//获取IE版本号
		ver = parseFloat(ua.substr(i + s.length));
		//alert("你的浏览器是IE"+ver);
	} else {
		//其他情况，不是IE
		//alert("你的浏览器不是IE");
	}
}

function BodyLoadHandler() {
	checkIEVersion();
	var obj = document.getElementById("BFind");
	if (obj) {
		obj.onclick = BFind_Click;
	}

	var obj = document.getElementById("BPrint");
	if (obj) {
		obj.onclick = Print_Click;
	}
	var obj = document.getElementById("InsType");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}

	var obj = document.getElementById("StatFlag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}
	var obj = document.getElementById("test");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
	}

	InitDocument();
}

function DHCWebRep_ChangeListValue(ListName, val) {
	var obj = document.getElementById(ListName);
	for (var i = obj.options.length - 1; i >= 0; i--) {
		if (obj.options[i].value == val) {
			obj.selectedIndex = i;
		}
	}
}

function DHCWebRep_GetListTextValue(objName) {
	var myval = "";
	var obj = document.getElementById(objName);
	if (obj) {
		var myidx = obj.selectedIndex;
		if (myidx != -1) {
			myval = obj.options[myidx].text;
		}
	}
	return myval;
}

function InitOPCatIE8() {
	var obj = document.getElementById("StatFlagHidden");
	var encmeth = "";
	if (obj) {
		if (obj.value == "TAC") {
			encmeth = DHCWebD_GetObjValue("getTarACCat");
		} else {
			encmeth = DHCWebD_GetObjValue("getTarOCCat");
		}
	}
	var catinfo = cspRunServerMethod(encmeth);
	aryCatDesc = catinfo.split("^");
	var objtbl = document.getElementById("tDHCOPBillPayorShareFee");
	var Rows = objtbl.rows.length;

	var firstRow = objtbl.rows[0];
	var RowItems = firstRow.all;

	var cattmp = catinfo.split("^");
	var catnum = cattmp.length;
	if (RowItems.length < catnum) {
		alert("exceeded the max num!");
		return;
	}
	for (var i = 1; i <= catnum; i++) {
		var ColName = "cat" + i;
		for (var j = 0; j < RowItems.length; j++) {
			if ((RowItems[j].innerHTML == ColName + " ") & (RowItems[j].tagName == 'TH')) {
				RowItems[j].innerHTML = cattmp[i - 1];
			}
		}
	}

	for (var i = catnum + 1; i <= 27; i++) {
		HiddenTblColumnIE8(objtbl, "cat" + i, i);
	}
}

function InitDocument() {
	var obj = document.getElementById("StatFlagHidden");
	if (obj) {
		DHCWebRep_ChangeListValue("StatFlag", obj.value);
	}
	var obj = document.getElementById("InsTypeHidden")
	if (obj) {
		DHCWebRep_ChangeListValue("InsType", obj.value);
	}
	if (ver <= "8") {
		InitOPCatIE8();
	} else {
		InitOPCat();
	}
	//InitPMCat();

	var listobj = document.getElementById("TTMPJIDz" + 1);
	if (listobj) {
		var myval = DHCWebD_GetCellValue(listobj);
		var obj = document.getElementById("TMPJID");
		if (obj) {
			obj.value = myval;
		}
	}
}

function BFind_Click() {
	var StDate = DHCWebD_GetObjValue("StDate");
	var StartTime = DHCWebD_GetObjValue("StartTime");
	var EndDate = DHCWebD_GetObjValue("EndDate");
	var EndTime = DHCWebD_GetObjValue("EndTime");
	var TMPJID = DHCWebD_GetObjValue("TMPJID");
	var UserRowId = "";
	var InsType = "";
	var StatFlag = "";
	var obj = document.getElementById("InsType");
	if (obj) {
		var myidx = obj.selectedIndex;
		if (myidx != -1) {
			InsType = obj.options[myidx].value;
		}
	}
	var obj = document.getElementById("StatFlag");
	if (obj) {
		var myidx = obj.selectedIndex;
		if (myidx != -1) {
			StatFlag = obj.options[myidx].value;
		}
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillPayorShareFee&TMPJID=" + TMPJID + "&EndDate=" + EndDate + "&StDate=" + StDate + "&StartTime=" + StartTime + "&EndTime=" + EndTime + "&StatFlag=" + StatFlag + "&PatTypeStat=" + InsType + "&UserRowId=" + UserRowId;
	document.location.href = lnk;
}

function InitPMCat() {
	var encmeth = DHCWebD_GetObjValue("getPMCat");
	var catinfo = cspRunServerMethod(encmeth);
	aryPMDesc = catinfo.split("^");
	var objtbl = document.getElementById("tDHCOPBillPayorShareFee");
	var Rows = objtbl.rows.length;

	var firstRow = objtbl.rows[0];
	var RowItems = firstRow.all;

	var cattmp = catinfo.split("^");
	var catnum = cattmp.length;
	if (RowItems.length < catnum) {
		alert("exceeded the max num!");
		return;
	}
	for (var i = 1; i <= catnum; i++) {
		var ColName = "pm" + i;
		for (var j = 0; j < RowItems.length; j++) {
			if ((RowItems[j].innerHTML == ColName + "\n") & (RowItems[j].tagName == 'TH')) {
				RowItems[j].innerHTML = cattmp[i - 1];
			}
		}
	}

	for (var i = 6; i <= 10; i++) {
		HiddenTblColumnA(objtbl, "pm" + i, i);
	}
}

function InitOPCat() {
	var obj = document.getElementById("StatFlagHidden");
	var encmeth = "";
	if (obj) {
		if (obj.value == "TAC") {
			encmeth = DHCWebD_GetObjValue("getTarACCat");
		} else {
			encmeth = DHCWebD_GetObjValue("getTarOCCat");
		}
	}
	var catinfo = cspRunServerMethod(encmeth);
	aryCatDesc = catinfo.split("^");
	var objtbl = document.getElementById("tDHCOPBillPayorShareFee");
	var Rows = objtbl.rows.length;

	var firstRow = objtbl.rows[0];
	//var RowItems = firstRow.all;
	var RowItems = firstRow.cells;
	var cattmp = catinfo.split("^");
	var catnum = cattmp.length;
	if (RowItems.length < catnum) {
		alert("exceeded the max num!");
		return;
	}
	for (var i = 1; i <= catnum; i++) {
		var ColName = "cat" + i;
		for (var j = 0; j < RowItems.length; j++) {
			if ((RowItems[j].innerHTML == ColName + "\n") && (RowItems[j].tagName == 'TH')) {
				RowItems[j].innerHTML = cattmp[i - 1];
			}
		}
	}

	for (var i = catnum + 1; i <= 27; i++) {
		HiddenTblColumn(objtbl, "cat" + i, i);
	}
}

function HiddenTblColumnA(tbl, ColName, ColIdx) {
	var row = tbl.rows.length;
	var firstRow = tbl.rows[0];
	//var RowItems = firstRow.all;
	var RowItems = firstRow.cells;
	for (var j = 0; j < RowItems.length; j++) {
		//if ((RowItems[j].innerHTML == ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML == ColName + "\n") & (RowItems[j].tagName == 'TH')) {
			RowItems[j].style.display = "none";
		} else {}
	}

	row = row - 1;
	for (var j = 1; j < row + 1; j++) {
		var sLable = document.getElementById("TPM" + ColIdx + 'z' + j);
		var sTD = sLable.parentElement;
		sTD.style.display = "none";
	}
}

function HiddenTblColumn(tbl, ColName, ColIdx) {
	var row = tbl.rows.length;
	var firstRow = tbl.rows[0];
	//var RowItems = firstRow.all;
	var RowItems = firstRow.cells;
	for (var j = 0; j < RowItems.length; j++) {
		//if ((RowItems[j].innerHTML == ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML == ColName + "\n") & (RowItems[j].tagName == 'TH')) {
			RowItems[j].style.display = "none";
		} else {
		}
	}

	row = row - 1;
	for (var j = 1; j < row + 1; j++) {
		var sLable = document.getElementById("TCAT" + ColIdx + 'z' + j);
		var sTD = sLable.parentElement;
		sTD.style.display = "none";
	}
}

function GetUserInfoByUserCode(value) {
	var str = value.split("^");
	var obj = document.getElementById("OperName");
	if (obj) {
		obj.value = str[0];
	}
	var obj = document.getElementById("UserRowId");
	if (obj) {
		obj.value = str[2];
	}
	var obj = document.getElementById("GroupName");
	if (obj) {
		obj.value = str[3];
	}
}

function Print_Click() {
	var StatFlag = "";
	var obj = document.getElementById("StatFlag");
	if (obj) {
		var myidx = obj.selectedIndex;
		if (myidx != -1) {
			StatFlag = obj.options[myidx].value;
		}

	}
	/*
	// i have no choice
	if (StatFlag == "TAC") {
		PrintClickHandler();
	} else {
		PrintClickHandler();
	}
	*/
	PrintClickHandler();
}

function PrintClickHandler() {
	try {
		var encmeth = DHCWebD_GetObjValue("GetRepPath");
		var TemplatePath = cspRunServerMethod(encmeth);
		var StDate = DHCWebD_GetObjValue("StDate");
		var EndDate = DHCWebD_GetObjValue("EndDate");
		var StartTime = DHCWebD_GetObjValue("StartTime");
		var EndTime = DHCWebD_GetObjValue("EndTime");
		var CurDate = DHCWebD_GetObjValue("CurDate");
		var RepDate = StDate + " " + StartTime + t["zhi"] + EndDate + " " + EndTime;
		var OperName = DHCWebD_GetObjValue("OperName");
		var ZBR = session['LOGON.USERNAME'];
		var Template = TemplatePath + "JFOP_BillPayorShareFeeTOC.xls";
		var jid = DHCWebD_GetObjValue('TMPJID');
		var encmeth = DHCWebD_GetObjValue('GetRowNum');
		if (jid == "") {
			return;
		}
		var Rows = parseInt(cspRunServerMethod(encmeth, jid));
		if (+Rows < 1) {
			alert("没有需要打印的数据");
			return;
		}
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var xlsheet = xlBook.ActiveSheet;
		var InsType = DHCWebRep_GetListTextValue("InsType");
		var StatFlag = DHCWebRep_GetListTextValue("StatFlag");
		if ((InsType == "") || (InsType == null) || (InsType == " ")) {
			xlsheet.cells(1, 2) = t['title'] + "(" + StatFlag + ")";
		} else {
			xlsheet.cells(1, 2) = t['title'] + "(" + StatFlag + ") ---" + InsType;
		}

		xlsheet.cells(2, 4) = RepDate;

		var xlsRow = 2;
		var xlsCol = 0;
		var i = 1;
		//CellMerge(xlsheet,xlsRow,xlsRow,xlsCol+9,xlsCol+aryCatDesc.length+8);
		for (var k = 0; k < aryCatDesc.length; k++) {
			xlsheet.cells(xlsRow + i, xlsCol + 4 + k) = aryCatDesc[k];
		}
		xlsheet.cells(xlsRow + i, xlsCol + 4 + k) = t["HJ"];
		//xlsheet.cells(xlsRow + i, xlsCol + 5 + k) = t["XJYL"];	k++;
		//xlsheet.cells(xlsRow + i, xlsCol + 5 + k) = t["HJ"];	 k++;

		var lineLength = aryCatDesc.length + 3;
		gridlist(xlsheet, xlsRow + 2, xlsRow + i, 2, lineLength + 1);
		i++;
		for (j = 1; j <= Rows; j++) {
			var encmeth = DHCWebD_GetObjValue('ReadPrtData');
			var RowStr = cspRunServerMethod(encmeth, jid, j - 1);
			var ary = RowStr.split("^");
			var Cols = ary.length;
			for (var k = 2; k < aryCatDesc.length + 4; k++) {
				xlsheet.cells(xlsRow + i, xlsCol + k) = ary[k];
			}
			xlsheet.cells(xlsRow + i, xlsCol + k) = ary[Cols - 1];
			i++;
		}

		gridlist(xlsheet, xlsRow + 2, xlsRow + i - 1, 2, lineLength + 1);

		i++;
		xlsheet.cells(2, 10) = t["ZBR"];
		xlsheet.cells(2, 11) = session['LOGON.USERNAME'];
		//xlsheet.cells(xlsRow+i,xlsCol+9) = t["shr"];
		xlsheet.cells(2, 12) = t["BT"];
		xlsheet.cells(2, 14) = CurDate;
		/*
		i++;
		xlsheet.cells(xlsRow + i, xlsCol + 1) = t["JKR"];
		xlsheet.cells(xlsRow + i, xlsCol + 6) = t["QZ"];
		i++;
		xlsheet.cells(xlsRow + i, xlsCol + 1) = t["SHR"];
		xlsheet.cells(xlsRow + i, xlsCol + 6) = t["KJS"];
		*/
		xlsheet.printout;
		xlBook.Close(savechanges = false);
		xlApp = null;
		xlsheet.Quit;
		xlsheet = null;
	} catch (e) {
		alert(e.message);
	}

}

function gridlist(objSheet, row1, row2, c1, c2) {
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(4).LineStyle = 1;
}

function UnloadHandler() {
	var myEncrypt = DHCWebD_GetObjValue("DELPRTTMPDATA");
	var myTMPGID = DHCWebD_GetObjValue("TMPJID");
	if (myEncrypt != "") {
		var mytmp = cspRunServerMethod(myEncrypt, myTMPGID);
	}
}

function CellMerge(objSheet, r1, r2, c1, c2) {
	var range = objSheet.Range(objSheet.Cells(r1, c1), objSheet.Cells(r2, c2))
		range.MergeCells = "True"
}

function CellLine(objSheet, row1, row2, c1, c2, Style) {
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(Style).LineStyle = 1;
}

function HiddenTblColumnAIE8(tbl, ColName, ColIdx) {
	var row = tbl.rows.length;
	var firstRow = tbl.rows[0];
	var RowItems = firstRow.all;
	for (var j = 0; j < RowItems.length; j++) {
		//if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML == ColName + " ") & (RowItems[j].tagName == 'TH')) {
			RowItems[j].style.display = "none";
		} else {
		}
	}

	row = row - 1;
	for (var j = 1; j < row + 1; j++) {
		var sLable = document.getElementById("TPM" + ColIdx + 'z' + j);
		var sTD = sLable.parentElement;
		sTD.style.display = "none";
	}
}

function HiddenTblColumnIE8(tbl, ColName, ColIdx) {
	var row = tbl.rows.length;
	var firstRow = tbl.rows[0];
	var RowItems = firstRow.all;
	for (var j = 0; j < RowItems.length; j++) {
		//if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
		if ((RowItems[j].innerHTML == ColName + " ") & (RowItems[j].tagName == 'TH')) {
			RowItems[j].style.display = "none";
		} else {
		}
	}
	row = row - 1;
	for (var j = 1; j < row + 1; j++) {
		var sLable = document.getElementById("TCAT" + ColIdx + 'z' + j);
		var sTD = sLable.parentElement;
		sTD.style.display = "none";
	}
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler
