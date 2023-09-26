///DHCOPBillDailySearch.js

var Guser;
var GuserName;
var GuserCode;
var flag;

function BodyLoadHandler() {
	var obj = websys_$("Find");
	if (obj) {
		obj.onclick = FindOnClickHandler;
	}
	var obj = websys_$("Handin");
	if (obj) {
		obj.onclick = GetHandin;
		GetHandin();
	}
	var BHandinobj = websys_$("BHandin");
	if (BHandinobj) {
		BHandinobj.onclick = BHandin;
	}
	var PrintDailyobj = document.getElementById("PrintDaily");
	if (PrintDailyobj) {
		PrintDailyobj.onclick = PrintDaily;
	}
	Guser = document.getElementById("Guser").value;
	if (Guser == "") {
		Guser = session['LOGON.USERID'];
	}
	flag = document.getElementById("flag").value;
	var puserobj = document.getElementById("PUser");
	var Myobj = websys_$('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "PUser";
		var puserobj1 = document.getElementById(imgname);
	}
	if (flag == "0") {
		puserobj.disabled = true;
		puserobj1.style.display = "none";
	}
	if (flag == "1") {
		DHCWeb_DisBtn(BHandinobj);
	}
}

function PrintDaily() {
	var job = websys_$V("job");
	//var Guser = session['LOGON.USERID'];
	var xlApp;
	var obook;
	var osheet;
	var xlsheet;
	var xlBook;
	path = getpath();
	Template = path + "DHCOPBill_DailySDSL.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var startDate = document.getElementById('StDate').value;
	var endDate = document.getElementById('EndDate').value;
	/*
	var str = stdate.split("/");
	var startDate = str[2] + '-' + str[1] + '-' + str[0];
	var str = enddate.split("/");
	var endDate = str[2] + '-' + str[1] + '-' + str[0];
	var GuserName = session['LOGON.USERNAME'];      //收费员姓名
	var GuserCode = session['LOGON.USERCODE'];      //收费员Code
	*/
	if (document.getElementById("PUser").value != "") {
		GuserName = document.getElementById("PUser").value;
	} else {
		GuserName = session['LOGON.USERNAME'];
	}
	xlsheet.cells(3, 3) = GuserName; //+"("+GuserCode+")";
	xlsheet.cells(3, 5) = endDate; //日期
	xlsheet.cells(14, 3) = session['LOGON.USERNAME'];      //GuserName; add  by wangjian
	xlsheet.cells(14, 5) = websys_$V("printDateTime");
	//获取打印数据
	var rtn = tkMakeServerCall("web.DHCOPBillDailyPrint", "GetOPDailyPrint", Guser, job);
	var CHR3 = String.fromCharCode(3);
	var depInfo = rtn.split(CHR3)[0];       //押金信息
	var invInfo = rtn.split(CHR3)[1];       //发票信息
	var totalInfo = rtn.split(CHR3)[2];     //合计信息
	var BLBNumInfo = rtn.split(CHR3)[3];    //病历本合计
	var currRow = 5;
	xlsheet.cells(currRow, 6) = "病历本个数:" + BLBNumInfo;
	//添加发票号段信息
	//allno_"^"_allnum_"^"_allsum_"^"_hcno_"^"_hcnum_"^"_hcsum_"^"_zfno_"^"_zfnum_"^"_zfsum_"^"_ybAmtSum_"^"_ybzfSum_"^"_grzfSum
	var tmpAry = invInfo.split("^");
	xlsheet.cells(currRow, 4) = tmpAry[0];
	xlsheet.cells(currRow, 5) = tmpAry[1];
	xlsheet.cells(currRow, 3) = tmpAry[2];
	currRow++;
	xlsheet.cells(currRow, 4) = tmpAry[6];
	xlsheet.cells(currRow, 5) = tmpAry[7];
	xlsheet.cells(currRow, 3) = tmpAry[8];
	currRow++;
	xlsheet.cells(currRow, 4) = tmpAry[3];
	xlsheet.cells(currRow, 5) = tmpAry[4];
	xlsheet.cells(currRow, 3) = tmpAry[5];

	currRow++;
	xlsheet.cells(currRow, 3) = tmpAry[9];
	currRow++;
	xlsheet.cells(currRow, 3) = tmpAry[10];
	currRow++;
	xlsheet.cells(currRow, 3) = tmpAry[11];

	currRow++;
	///押金信息
	///accSum_"^"_accNum_"^"_sDepNO_"^"_tAccSum_"^"_tAccNum_"^"_tDepNO_"^"_DepAllNO
	var tmpAry = depInfo.split("^");
	xlsheet.cells(currRow, 3) = tmpAry[0];
	xlsheet.cells(currRow, 4) = tmpAry[6];
	xlsheet.cells(currRow, 5) = eval(tmpAry[4]) + eval(tmpAry[1]);
	currRow++;
	xlsheet.cells(currRow, 3) = tmpAry[3];
	xlsheet.cells(currRow, 4) = "";          //tmpAry[5];
	xlsheet.cells(currRow, 5) = tmpAry[4];   //eval(tmpAry[4])+eval(tmpAry[1]);
	currRow++;
	//填充合计信息
	var tmpAry = totalInfo.split("^");
	xlsheet.cells(currRow, 3) = tmpAry[0];
	xlsheet.cells(currRow, 5) = tmpAry[1];

	if (this.id === "PrintDaily") {
		xlApp.Visible = true;
		xlsheet.PrintPreview();
	} else {
		xlsheet.printout;
	}
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
	var handin = document.getElementById("handin").checked;
	if (handin == false) {
		alert("请检查报表是否结算!");
	}
}

function BHandin() {
	//+2015-3-4 hujunbin 刷新时间
	refreshTime();
	var LoadDepFlag = "N";
	var LoadInvFlag = "N";
	if (parent.frames['DHCOPInvDaily'].document.readyState == "complete") {
		LoadDepFlag = "Y";
	}
	if (parent.frames['DHCOPPreDepositDaily'].document.readyState == "complete") {
		LoadInvFlag = "Y";
	}
	if (LoadDepFlag == "N") {
		alert("发票信息未加载完成.");
		return;
	}
	if (LoadInvFlag == "N") {
		alert("预交金信息未加载完成.");
		return;
	}
	/*
	var returnvalue = JudgeCash();
	if (returnvalue == -1){
		return;
	}
	*/
	//modify hujunbin 14.12.3
	var returnvalue = JudgeCash();
	if (returnvalue > 0) {
		return;
	}
	var encmeth = DHCWebD_GetObjValue('HandinEncmeth');
	var myinfo = "";
	var myrtn = confirm(t["ISHandIn"]);
	if (myrtn == false) {
		return;
	}
	var stDate = websys_$V("StDate");
	var stTime = websys_$V("StTime");
	var endDate = websys_$V("EndDate");
	var endTime = websys_$V("EndTime");
	var guser = session['LOGON.USERID'];
	var hospDr = session['LOGON.HOSPID'];
	var myinfo = stDate + "^" + stTime + "^" + endDate + "^" + endTime;
	if (encmeth != "") {
		var rtn = (cspRunServerMethod(encmeth, guser, hospDr, myinfo));
	}
	var mytmpary = rtn.split("^");
	if (mytmpary[0] == "0") {
		alert("结算成功");
		var obj = document.getElementById("BHandin");
		DHCWeb_DisBtn(obj);
		FindOnClickHandler();
	} else if (mytmpary[0] == "Y") {
		alert("在系统配置时间已结账, 当天不能再次结账.");
		return;
	} else if (mytmpary[0] == "TPErr") {      //yyx 2012-09-04
		alert("你有以下" + mytmpary[2] + "\n" + mytmpary[1] + "条预结算记录");
		return;
	} else {
		alert("结算失败");
	}
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue('getpath');
	var path = cspRunServerMethod(encmeth, "", "");
	return path;
}

function FindOnClickHandler() {
	//+2015-3-4 hujunbin 刷新时间
	refreshTime();
	//add by wangjian
	var PUserobj = document.getElementById('PUser');
	var Guserobj = document.getElementById('Guser');
	if (Guserobj.value) {
		Guser = Guserobj.value;
	} else {
		Guser = session['LOGON.USERID'];
	}
	if ((PUserobj) && (!PUserobj.value) && (Guserobj.value) && (!PUserobj.disabled)) {     //textbook为空 id不为空时 置Guser为当前登录用户
		var mywarn = window.confirm("查询当前登录用户.");
		if (!mywarn) {
			alert("请选择要查询的人员");
			return;
		}
		Guser = session['LOGON.USERID'];
	}
	//end
	var stDate = websys_$V("StDate");
	var stTime = websys_$V("StTime");
	var endDate = websys_$V("EndDate");
	var endTime = websys_$V("EndTime");
	var handin = websys_$("Handin").checked;
	//var guser = session['LOGON.USERID'];
	var guser = Guser;
	var group = session['LOGON.GROUPID'];
	var ctLoc = session['LOGON.CTLOCID'];
	var hospDr = session['LOGON.HOSPID'];
	var job = websys_$V("job");
	var expStr = guser + "^" + group + "^" + ctLoc + "^^^^^";
	if (handin) {
		var stdate = websys_$V("StDate");
		var enddate = websys_$V("EndDate");
		//var guser = session["LOGON.USERID"];
		var hospDr = session['LOGON.HOSPID'];
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOPDayRptHis&stdate=' + stdate + '&enddate=' + enddate + '&Guser=' + guser + '&findflag=' + "" + "&job=" + job;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
	} else {
		parent.frames['DHCOPInvDaily'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPInvDaily&stDate=" + stDate + "&stTime=" + stTime + "&endDate=" + endDate + "&endTime=" + endTime + "&handin=" + handin + "&job=" + job + "&jkDr=" + "" + "&guser=" + guser + "&hospDr=" + hospDr;
		parent.frames['DHCOPPreDepositDaily'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPPreDepositDaily&stDate=" + stDate + "&stTime=" + stTime + "&endDate=" + endDate + "&endTime=" + endTime + "&handin=" + handin + "&job=" + job + "&jkDr=" + "" + "&guser=" + guser + "&hospDr=" + hospDr;
	}
}

///获取开始时间
function getnotjkdate() {
	var user = session["LOGON.USERID"];
	var hospDr = session['LOGON.HOSPID'];
	var enddate = document.getElementById("EndDate").value;
	var encmeth = DHCWebD_GetObjValue('getstdate');
	var datestr = cspRunServerMethod(encmeth, user, enddate, hospDr);
	datestr = datestr.split("^");
	websys_$("StDate").value = datestr[0];
	websys_$("StTime").value = datestr[1];
	websys_$("EndDate").value = datestr[2];
	websys_$("EndTime").value = datestr[3];
}

function GetHandin() {
	var handinobj = websys_$("Handin");
	var handin = handinobj.checked;
	var stdateobj = websys_$('StDate');
	var sttimeobj = websys_$('StTime');
	var enddateobj = websys_$('EndDate');
	var endtimeobj = websys_$('EndTime');
	var Myobj = websys_$('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "StDate";
		var stdateobj1 = document.getElementById(imgname);
		var imgname = "ld" + Myobj.value + "i" + "EndDate";
		var enddateobj1 = document.getElementById(imgname);
	}
	if (handin == true) {
		stdateobj.value = websys_$V("GetcurDate");
		enddateobj.value = websys_$V("GetcurDate");
		sttimeobj.value = websys_$V("GetcurTime");
		endtimeobj.value = websys_$V("GetcurTime");
		stdateobj1.style.display = "";
		stdateobj.readOnly = false;
		enddateobj1.style.display = "";
		enddateobj.readOnly = false;
		var obj = document.getElementById("BHandin");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
	}
	if (handin == false) {
		getnotjkdate();
		if (websys_$V('StDate') == "") {
			stdateobj.value = websys_$V("GetcurDate");
			sttimeobj.value = websys_$V('GetcurTime');
			enddateobj.value = websys_$V("GetcurDate");
			endtimeobj.value = websys_$V('GetcurTime');
		}
		stdateobj1.style.display = "none";
		stdateobj.readOnly = true;
		stdateobj.disabled = true;
		sttimeobj.disabled = true;
		enddateobj1.style.display = "none";
		enddateobj.readOnly = true;
		enddateobj.disabled = true;
		endtimeobj.disabled = true;
		var obj = document.getElementById("BHandin");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, BHandin);
		}
	}
	var obj = document.getElementById("BHandin");
	if (flag == "1") {
		DHCWeb_DisBtn(obj);
	}
}

function getuserid(value) {
	var user = value.split("^");
	websys_$('Guser').value = user[1];
	var myhandin = document.getElementById("Handin").checked;
	if (myhandin == false) {
		var user = user[1];    //session["LOGON.USERID"];
		var hospDr = session['LOGON.HOSPID'];
		var enddate = DHCWebD_GetObjValue('EndDate');
		var encmeth = DHCWebD_GetObjValue('getstdate');
		var datestr = cspRunServerMethod(encmeth, user, enddate, hospDr);
		datestr = datestr.split("^");
		websys_$("StDate").value = datestr[0];
		websys_$("StTime").value = datestr[1];
		websys_$("EndDate").value = datestr[2];
		websys_$("EndTime").value = datestr[3];
	}
}

//add hujunbin 14.12.3
//用于判断发票表金额、账单表金额是否相等
function JudgeCash() {
	var job = websys_$V("job");
	var rtn = tkMakeServerCall("web.DHCOPBillDailyHandin", "JudgeCash", job, Guser);
	var rtnArr = rtn.split("@");
	var ErrNum = parseInt(rtnArr[0]);
	if (ErrNum > 0) {
		alert("以下发票的账目不对，请重新核实： " + rtnArr[1]);
	}
	return ErrNum;
}

//+2015-3-4 hujunbin 点击查询和结算时更新时间点
function refreshTime() {
	var obj = websys_$('Handin');
	if (obj) {
		if ((obj.checked != "checked") && (obj.checked != true)) {
			GetHandin();
		}
	}
}

document.body.onload = BodyLoadHandler;
