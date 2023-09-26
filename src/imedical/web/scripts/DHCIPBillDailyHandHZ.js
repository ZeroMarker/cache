/// DHCIPBillDailyHandHZ.js

var UserStr;
var Userobj;
var Useridobj;
var job;
var Guser;

function BodyLoadHandler() {
	getcurrectjob();
	gethospital();
	var Guser = session['LOGON.USERID'];
	Userobj = document.getElementById("User");
	Useridobj = document.getElementById("Userid");

	FindObj = document.getElementById("Find");
	if (FindObj) {
		FindObj.onclick = Find_Click;
	}
	prtObj = document.getElementById("Print");
	if (prtObj) {
		prtObj.onclick = Print_click;
	}

	prtObj = document.getElementById("PrintWorkLoad");
	if (prtObj) {
		prtObj.onclick = PrintWorkLoad_click;
	}

	//CurUserobj.onkeydown = getuser;
}

function getcurrectjob() {
	var encmeth = DHCWebD_GetObjValue("getcurrectjob");
	job = cspRunServerMethod(encmeth, '', '');
}

function gethospital() {
	var encmeth = DHCWebD_GetObjValue("gethospital");
	var str = cspRunServerMethod(encmeth);
	var str1 = str.split("^");
	hosptialname = str1[1];
}

function Find_Click() {
	var stDate = DHCWebD_GetObjValue("StDate");
	var endDate = DHCWebD_GetObjValue("EndDate");
	var CurUser = session['LOGON.USERID'];
	var Guser = Useridobj.value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillDailyHandHZ&StDate=" + stDate + "&EndDate=" + endDate + "&CurUser=" + CurUser + "&Guser=" + Guser;
	document.location.href = lnk;
}

function Print_click() {
	getpath();
	var Guser = session['LOGON.USERID'];
	var gusername = session['LOGON.USERNAME'];
	var job = DHCWeb_GetColumnData("Tjob", 1);
	var Template = path + "JF_DepInvDayDetailHZ.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	xlApp.visible = true;
	var DepInvCYJAmtStr;
	xlsheet.cells(1, 2).value = "住院日报汇总表";
	var encmeth = DHCWebD_GetObjValue("GetDailyPrintInfo");
	var DailyPrintInfo = cspRunServerMethod(encmeth, Guser, job);
	alert(DailyPrintInfo);
	var DailyPrintInfo = DailyPrintInfo.split("#");
	var DailyLen = eval(DailyPrintInfo.length);
	for (i = 0; i < DailyLen; i++) {
		var Daily = DailyPrintInfo[i];
		var Daily = Daily.split("^");
		var Len = eval(Daily.length);
		for (j = 0; j < Len; j++) {
			xlsheet.cells(i + 3, j + 2).value = Daily[j];
		}
	}
	/*
	var encmeth = DHCWebD_GetObjValue("GetInsuPatInfo");
	var InsuPatInfo = cspRunServerMethod(encmeth, job);
	var InsuPatInfo = InsuPatInfo.split("#");
	var InsuLen = eval(InsuPatInfo.length);
	for (i = 0; i < InsuLen; i++) {
		var PatInfo = InsuPatInfo[i];
		var PatInfo = PatInfo.split("^");
		var PatInfolen = eval(PatInfo.length);
		for (j = 0; j < PatInfolen; j++) {
			xlsheet.cells(i + 11, j * 2 + 2).value = PatInfo[j];
		}
	}
	*/
	var prtDate = DHCWebD_GetObjValue("PrintDate");
	var stDate = DHCWebD_GetObjValue("StDate");
	var endDate = DHCWebD_GetObjValue("EndDate");
	xlsheet.cells(9, 1).value = "汇总时间段:";
	xlsheet.cells(9, 2).value = stDate + "至" + endDate;
	xlsheet.cells(10, 1).value = "制表日期:";
	xlsheet.cells(10, 2).value = prtDate;
	xlsheet.cells(10, 5).value = "制表人: " + gusername;

	//xlsheet.visable = true;
	xlsheet.PrintPreview();
	//xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

function getuserid(value) {
	var str = value.split("^");
	Userobj.value = str[0];
	Useridobj.value = str[1];
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue("getpath");
	path = cspRunServerMethod(encmeth, '', '');
}

function PrintWorkLoad_click() {
	getpath();
	var job = DHCWeb_GetColumnData("Tjob", 1);
	var Template = path + "JF_PWorkload.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	xlApp.visible = true;
	var date = new Date();
	var TodayDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
	var DepInvCYJAmtStr;

	var encmeth = DHCWebD_GetObjValue("GetDailyPrintInfoWorkLoad");
	var WorkLoadInfo = cspRunServerMethod(encmeth, Guser, job);
	var WorkLoadStr = WorkLoadInfo.split("#");

	var WorkLoadlen = eval(WorkLoadStr.length);
	for (i = 0; i < WorkLoadlen; i++) {
		var WorkLoad = WorkLoadStr[i];
		var Work = WorkLoad.split("^");
		var Len = eval(WorkLoad.length);
		for (j = 0; j < Len; j++) {
			xlsheet.cells(i + 4, j + 5).value = Work[j];
		}
	}

	var PerNum = WorkLoadStr[WorkLoadlen - 1].split("^");

	xlsheet.cells(26, 2).value = "入院  " + PerNum[0] + "  人次" + "    " + "出院  " + PerNum[1] + "  人次";

	var prtDate = DHCWebD_GetObjValue("PrintDate");
	var stDate = DHCWebD_GetObjValue("StDate");
	var endDate = DHCWebD_GetObjValue("EndDate");
	var gusername = session['LOGON.USERNAME'];
	xlsheet.cells(27, 2).value = "统计截止日期:";
	xlsheet.cells(27, 3).value = stDate + " 至 " + endDate;
	xlsheet.cells(28, 3).value = prtDate;
	xlsheet.cells(28, 6).value = gusername;

	//xlsheet.visable = true;
	xlsheet.PrintPreview();
	//xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

document.body.onload = BodyLoadHandler;
