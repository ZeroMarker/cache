///UDHCJFSearch.js

var path;
var Guser, stdate, enddate, curdate, curTime, JKStTime, JKEndTime;
var gusername, gusercode;
var yjsum = 0, sxjsum = 0, sxjnum = 0, szpsum = 0, szpnum = 0, shpsum = 0, shpnum = 0, sxyksum = 0, sxyknum = 0;
var txjsum = 0, txjnum = 0, tzpsum = 0, tzpnum = 0, thpsum = 0, thpnum = 0, txyksum = 0, txyknum = 0, tzplynum = 0, thplynum = 0, txyklynum = 0, fpnum = 0, tqtnum = 0;
var xjsum, zpsum, hpsum, xyksum, patfee, payorshare, discount, patshare, ybsum = 0, gfsum = 0, sldsum = 0, tdeposit = 0, ybnum = 0;
var rcptrow = 0, invrow = 0;
var jsflag = "N";
var hospitalname;
var payorsharenum = 0;
var userjkno;
var nbsbnum, nbnbnum, nbsbsum, nbnbsum;
var balflag = "0", prtflag = 0;
var job, flag, findtype;

function BodyLoadHandler() {
	var encmeth = DHCWebD_GetObjValue('getcurrectjob');
	job = cspRunServerMethod(encmeth, '', '');
	DHCWebD_SetObjValueB("job", job);
	var obj = document.getElementById("Balance");
	if (!obj.disabled) {
		obj.onclick = Balance_click;
	}
	findtype = DHCWebD_GetObjValue('findtype');
	if (findtype == "1") {
		DHCWeb_DisBtn(obj);
	}
	var LookUserObj = document.getElementById("LookUser");
	//+2017-06-14 ZhYW
	var cLookUserObj = document.getElementById('cLookUser'); //操作员<label>
	var LookUserObj1;
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "LookUser";
		LookUserObj1 = document.getElementById(imgname);
	}
	if (findtype == "0") {
		LookUserObj1.style.display = "none";
		//+2017-06-14 ZhYW
		LookUserObj.style.display = "none";
		cLookUserObj.style.display = "none";
	}
	userjkno = "";
	Guser = session['LOGON.USERID'];
	gusername = session['LOGON.USERNAME'];
	gusercode = session['LOGON.USERCODE'];
	flag = DHCWebD_GetObjValue('flag');
	flag = "1";
	gethandin();
	var encmeth = DHCWebD_GetObjValue('gethospital');
	hospitalname = cspRunServerMethod(encmeth);
	var findobj = document.getElementById("Find");
	if (findobj) {
		findobj.onclick = Find_click;
	}
	var obj = document.getElementById("Balance");
	var cancelObj = document.getElementById("btncancel");
	if (cancelObj) {
		cancelObj.onclick = Cancel_click;
	}
	var prtObj = document.getElementById("Print");
	if (prtObj) {
		prtObj.onclick = Print_click;
	}
	var handinobj = document.getElementById("handin");
	if (handinobj) {
		handinobj.onclick = gethandin;
	}
	Find_click();   //要求默认显示当前日期的数据  add 17.12.27
}

function getcurTime() {
	var encmeth = DHCWebD_GetObjValue('getcurdate');
	var dateVal = cspRunServerMethod(encmeth);
	var myAry = dateVal.split(" ");
	curdate = myAry[0];
	curTime = myAry[1];
}

function Find_click() {
	//+2017-06-15 ZhYW
	var rtn = CompareDateTime();
	if (!rtn) {
		return;
	}
	//
	var LookUserobj = document.getElementById("LookUser");
	var LookUseridobj = document.getElementById("LookUserid");
	if ((LookUserobj) && (!LookUserobj.value) && (LookUseridobj.value)) { //textbook为空 id不为空时 置Guser为当前登录用户
		var mywarn = window.confirm("查询当前登录用户?");
		if (!mywarn) {
			alert("请选择要查询的人员");
			return;
		}
		Guser = session['LOGON.USERID'];
		getnotjkdate();
	}
	var stdate = DHCWebD_GetObjValue('stdate');
	var enddate = DHCWebD_GetObjValue('enddate');
	var stTime = DHCWebD_GetObjValue('JKStTime');
	var endTime = DHCWebD_GetObjValue('JKEndTime');
	var handin = DHCWebD_GetObjValue('handin');
	if (stdate == "") {
		alert(t['01']);
		return;
	}
	if (enddate == "") {
		alert(t['02']);
		return;
	}
	if (handin == true) {
		handin = "Y";
	} else {
		handin = "N";
	}
	if (handin == "N") {
		parent.frames['UDHCJFDepositRpt'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate=" + stdate + "&enddate=" + enddate + "&handin=" + handin + "&Guser=" + Guser + "&jsflag=" + "N" + "&jkdr=" + "" + "&flag=" + flag + "&job=" + job + "&JKStTime=" + stTime + "&JKEndTime=" + endTime;
		parent.frames['UDHCJFdayInvRpt'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFdayInvRpt&stdate=" + stdate + "&enddate=" + enddate + "&handin=" + handin + "&Guser=" + Guser + "&jsflag=" + "N" + "&jkdr=" + "" + "&flag=" + flag + "&job=" + job + "&JKStTime=" + stTime + "&JKEndTime=" + endTime; ;
	}
	if (handin == "Y") {
		jsflag = "N";
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDayRptHis&stdate=' + stdate + '&enddate=' + enddate + '&guser=' + Guser + "&flag=" + flag + "&job=" + job;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0');
	}
}

function Balance_click() {
	//+2017-06-15 ZhYW
	var rtn = CompareDateTime();
	if (!rtn) {
		return;
	}
	//
	var LoadDepFlag = "N";
	var LoadInvFlag = "N";
	if (parent.frames['UDHCJFDepositRpt'].document.readyState == "complete") {
		LoadDepFlag = "Y";
	} else {
		alert("加载未完成.");
		return;
	}
	if (parent.frames['UDHCJFdayInvRpt'].document.readyState == "complete") {
		LoadInvFlag = "Y";
	} else {
		alert("加载未完成.");
		return;
	}
	if (LoadDepFlag == "N") {
		alert("押金未加载完成.");
		return;
	}
	if (LoadInvFlag == "N") {
		alert("发票未加载完成.");
		return;
	}
	var user = session['LOGON.USERID'];
	balflag = "1";
	userjkno = "";
	var handin = DHCWebD_GetObjValue('handin');
	if (handin == true) {
		alert(t['03']);
		return;
	}
	var stDate = DHCWebD_GetObjValue('stdate');
	var stTime = DHCWebD_GetObjValue('JKStTime');
	var endDate = DHCWebD_GetObjValue('enddate');
	var endTime = DHCWebD_GetObjValue('JKEndTime');
	var hospDR = session['LOGON.HOSPID'];
	var footInfo = stDate + '^' + stTime + '^' + endDate + '^' + endTime;
	
	var encmeth = DHCWebD_GetObjValue('btnbal');
	if (encmeth != "") {
		var rtn = (cspRunServerMethod(encmeth, user, hospDR, footInfo));
		var myAry = rtn.split('^');
		rtn = myAry[0];
		if (+rtn == 0) {
			alert(t['04']);
			jsflag = "Y";
			Print_click();
			window.location.reload();
		}else {
			alert(t['05']);
			return;
		}
	}else {
		alert('结算异常');
	}
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}

function gethandin() {
	var handin = DHCWebD_GetObjValue('handin');
	var stdateobj = document.getElementById('stdate');
	var enddateobj = document.getElementById('enddate');
	var stTimeObj = document.getElementById('JKStTime');
	var endTimeObj = document.getElementById('JKEndTime');
	getcurTime();
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "stdate";
		var stdateobj1 = document.getElementById(imgname);
		var imgname = "ld" + Myobj.value + "i" + "enddate";
		var enddateobj1 = document.getElementById(imgname);
	}
	if (handin) {
		DHCWebD_SetObjValueB('stdate', curdate);
		DHCWebD_SetObjValueB('enddate', curdate);
		DHCWebD_SetObjValueB('JKStTime', curTime);
		DHCWebD_SetObjValueB('JKEndTime', curTime);
		stdateobj.disabled = false;
		stTimeObj.disabled = false;
		stdateobj1.style.display = "";
		//stdateobj.readOnly = false;
		stdateobj.style.color = "black";
		enddateobj1.style.display = "";
		//enddateobj.readOnly = false;
	} else {
		getnotjkdate();
		if (stdateobj.value == "") {
			DHCWebD_SetObjValueB('stdate', curdate);
			DHCWebD_SetObjValueB('enddate', curdate);
			DHCWebD_SetObjValueB('JKStTime', curTime);
			DHCWebD_SetObjValueB('JKEndTime', curTime);
		}
		stdateobj1.style.display = "none";
		//stdateobj.readOnly = true;
		//stdateobj.style.color = "gray";
		stdateobj.disabled = true;
		stTimeObj.disabled = true;
		stTimeObj.onkeypress = function () {
			return false;
		}
	}
}

function getnotjkdate() {
	var user = session['LOGON.USERID'];
	var encmeth = DHCWebD_GetObjValue('getstdate');
	var date = cspRunServerMethod(encmeth, user);
	var dateAry = date.split('^');
	DHCWebD_SetObjValueB('stdate', dateAry[1]);
	DHCWebD_SetObjValueB('JKStTime', dateAry[2]);
	DHCWebD_SetObjValueB('enddate', dateAry[3]);
	DHCWebD_SetObjValueB('JKEndTime', dateAry[4]);
}

/**
* 撤销结算
*/
function Cancel_click() {
	var user = session['LOGON.USERID'];
	var rtn = tkMakeServerCall("web.DHCIPBillDailyHandin", "GetLastJKInfo", user);
	var myAry = rtn.split('^');
	var jkDR = myAry[0];
	var lastDate = myAry[1];
	var lastTime = myAry[2];
	var tmp = t['jst03'] + lastDate + t['jst04'];
	var confirm = window.confirm(tmp);
	if (!confirm) {
		return;
	}
	if (jkDR == ""){
		alert('没有结算记录！');
		return;
	}
	var rtn = tkMakeServerCall("web.DHCIPBillDailyHandin", "cancel", jkDR);
	if (rtn == 0) {
		alert(t['jst05']);
		balflag = "0";
		window.location.reload();
		return;
	} else {
		alert(t['jst06']);
	}
}

function Print_click() {
	getpath();
	var Template = path + "JF_DepInvDayDetail.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	xlApp.visible = true;
	var encmeth = DHCWebD_GetObjValue('getcurdate');
	var curdate = cspRunServerMethod(encmeth);
	//var date = new Date();
	//var TodayDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
	//var TodayTime = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	var DepInvCYJAmtStr;
	var stdate = DHCWebD_GetObjValue('stdate');
	var enddate = DHCWebD_GetObjValue('enddate');
	var JKStTime = DHCWebD_GetObjValue('JKStTime');
	var JKEndTime = DHCWebD_GetObjValue('JKEndTime');

	encmeth = DHCWebD_GetObjValue('GetDailyPrintInfo');
	var DailyPrintInfo1 = cspRunServerMethod(encmeth, Guser, job);

	var DailyPrintNoInfo = DailyPrintInfo1.split("&&")[1];
	var DailyPrintInfo = DailyPrintInfo1.split("&&")[0];
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
	xlsheet.cells(9, 2).value = DailyPrintNoInfo.split("#")[0];
	xlsheet.cells(10, 2).value = DailyPrintNoInfo.split("#")[1];
	xlsheet.cells(11, 2).value = DailyPrintNoInfo.split("#")[2];
	xlsheet.cells(12, 2).value = DailyPrintNoInfo.split("#")[3];
	xlsheet.cells(13, 2).value = DailyPrintNoInfo.split("#")[4];
	xlsheet.cells(14, 2).value = DailyPrintNoInfo.split("#")[5];

	encmeth = DHCWebD_GetObjValue('GetInsuPatInfo');
	var InsuPatInfo = cspRunServerMethod(encmeth, Guser, job);
	var InsuPatInfo = InsuPatInfo.split("#");
	var InsuLen = eval(InsuPatInfo.length);
	for (i = 0; i < InsuLen; i++) {
		var PatInfo = InsuPatInfo[i];
		var PatInfo = PatInfo.split("^");
		var PatInfolen = eval(PatInfo.length);
		for (j = 0; j < PatInfolen; j++) {
			xlsheet.cells(i + 15, j * 2 + 2).value = PatInfo[j]
		}
	}
	var stdate = tkMakeServerCall("web.UDHCJFBaseCommon", "FormDateTime", stdate, JKStTime);
	var enddate = tkMakeServerCall("web.UDHCJFBaseCommon", "FormDateTime", enddate, JKEndTime);
	var currdate = tkMakeServerCall("web.UDHCJFBaseCommon", "FormDateTime", "", "");
	xlsheet.cells(i + 15, 1).value = "报表日期";
	xlsheet.cells(i + 15, 2).value = stdate + "至" + enddate;
	xlsheet.cells(i + 16, 1).value = "制表日期";
	xlsheet.cells(i + 16, 2).value = currdate;
	xlsheet.cells(i + 16, 5).value = "制表人: " + gusername;
	//xlsheet.visable = true;
	xlsheet.PrintPreview();
	//xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
	var handin = DHCWebD_GetObjValue('handin');
	if (!handin) {
		alert("请检查报表是否结算!");
	}
}

function UnloadHandler() {
	var encmeth = DHCWebD_GetObjValue('KillTmp');
	var mytmp = cspRunServerMethod(encmeth, Guser, job);
}

function AddGrid(objSheet, fRow, fCol, tRow, tCol, xlsTop, xlsLeft) {
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(xlsTop + tRow - fRow, xlsLeft + tCol - fCol)).Borders(4).LineStyle = 1;
}

function getlookuserid(value) {
	var str = value.split("^");
	DHCWebD_SetObjValueB('LookUser', str[0]);
	DHCWebD_SetObjValueB('LookUserid', str[1]);
	Guser = DHCWebD_GetObjValue('LookUserid');
	var myhandin = DHCWebD_GetObjValue('handin');
	if (!myhandin) {
		//查询未结算时得到 开始时间
		var CurUser = DHCWebD_GetObjValue('LookUserid');
		var p1 = CurUser;
		var encmeth = DHCWebD_GetObjValue('getstdate');
		var date = cspRunServerMethod(encmeth, p1);
		date = date.split("^");
		DHCWebD_SetObjValueB('stdate', date[1]);
	}
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-06-15
 * Description: 比较结束时间是否大于开始时间或当前时间
 *              false: 大于开始时间或当前时间
 */
function CompareDateTime() {
	var stDate = DHCWebD_GetObjValue('stdate');
	var stTime = DHCWebD_GetObjValue('JKStTime');
	var endDate = DHCWebD_GetObjValue('enddate');
	var endTime = DHCWebD_GetObjValue('JKEndTime');
	var rtn = DateTimeStringCompare(stDate, stTime, endDate, endTime);
	if (rtn == 1) {
		alert('结束日期时间不能小于开始日期时间！');
		return false;
	}
	rtn = DateTimeStringCompareToday(endDate, endTime);
	if (rtn == 1) {
		alert('结束日期时间不能大于当前日期时间！');
		return false;
	}
	return true;
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler;
