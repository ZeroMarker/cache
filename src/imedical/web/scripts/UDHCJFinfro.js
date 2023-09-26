///UDHCJFinfro.js

var stdateobj, enddateobj;
var admreason;
var myData1 = new Array();
var path;
var patnum;
var regnoobj, nameobj, warddescobj, wardidobj;
var Adm;
var Guser, GuserCode;

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERNAME"];
	stdateobj = websys_$("stdate");
	enddateobj = websys_$("enddate");
	admreason = websys_$('admreason');
	regnoobj = websys_$('regno');
	regnoobj.onkeydown = findno;
	nameobj = websys_$('name');
	if (nameobj) {
		nameobj.onkeydown = findclk;
	}
	warddescobj = websys_$('warddesc');
	wardidobj = websys_$('wardid');
	warddescobj.onkeydown = getward;
	var userobj = websys_$('username');
	userobj.onkeydown = finduser;
	//userobj.changed = getuser;
	//var user = userobj.value;
	if ((userobj.value == "") || (userobj.value == " ")) {
		//userobj.value = GuserCode;
		DHCWebD_SetObjValueB("userid", "");
	}
	var obj = websys_$('clear');
	if (obj) {
		obj.onclick = Clear_Click;
	}

	/*
	userobj.onkeyup = clearusername;
	warddescobj.onkeyup = clearwarddesc;
	wardidobj.onkeyup = clearwardid;
	admreason.onkeyup = clearadmreason;
	regnoobj.onkeyup = clearregno;
	nameobj.onkeyup = clearname;
	var obj = websys_$('flagin'); //yyx
	if (obj){
		obj.onclick = getinhosp;
	}
	var obj = websys_$('flagout');
	if (obj){
		obj.onclick = getouthosp;    //yyx 2009-06-16
	}
	if ((flagin.value == "") & (flagout.value == "")) {
		flagin.checked = true;
		flagin.value = "on";
		flagout.checked = false;
		flagout.value = "";
	}
	*/

	var print = websys_$('print');
	if (print)
		print.onclick = print_click;

	if ((stdateobj.value == "") || (enddateobj.value == "")) {
		gettoday1();
	}

	getpath();

	var prtobj = websys_$("outExp");
	if (prtobj) {
		prtobj.onclick = outExp_click;
	}
	var admreasonobj = websys_$("admreason");
	admreasonobj.onkeyup = clearadmreason;

	var obj = websys_$("CurAdmFlag");
	if (obj) {
		obj.onclick = CurAdmFlagOnClick;
	}
	var obj = websys_$("flagin");
	if (obj) {
		obj.onclick = FlagInOnClick;
	}
	var obj = websys_$("flagout");
	if (obj) {
		obj.onclick = FlagOutOnClick;
	}
	var obj = websys_$("PaidFlag");
	if (obj) {
		obj.onclick = PaidFlagOnClick;
	}
}

function CurAdmFlagOnClick() {
	var bool = this.checked;
	if (bool) {
		DHCWebD_SetObjValueB("flagin", !bool);
		DHCWebD_SetObjValueB("flagout", !bool);
		DHCWebD_SetObjValueB("PaidFlag", !bool);
	} else {
		DHCWebD_SetObjValueB("flagin", bool);
		DHCWebD_SetObjValueB("flagout", bool);
		DHCWebD_SetObjValueB("PaidFlag", bool);
	}
}
function FlagInOnClick() {
	var bool = this.checked;
	if (bool) {
		DHCWebD_SetObjValueB("CurAdmFlag", !bool);
		DHCWebD_SetObjValueB("flagout", !bool);
		DHCWebD_SetObjValueB("PaidFlag", !bool);
	} else {
		DHCWebD_SetObjValueB("CurAdmFlag", bool);
		DHCWebD_SetObjValueB("flagout", bool);
		DHCWebD_SetObjValueB("PaidFlag", bool);
	}
}

function FlagOutOnClick() {
	var bool = this.checked;
	if (bool) {
		DHCWebD_SetObjValueB("CurAdmFlag", !bool);
		DHCWebD_SetObjValueB("flagin", !bool);
		DHCWebD_SetObjValueB("PaidFlag", !bool);
	} else {
		DHCWebD_SetObjValueB("CurAdmFlag", bool);
		DHCWebD_SetObjValueB("flagin", bool);
		DHCWebD_SetObjValueB("PaidFlag", bool);
	}
}

function PaidFlagOnClick() {
	var bool = this.checked;
	if (bool) {
		DHCWebD_SetObjValueB("CurAdmFlag", !bool);
		DHCWebD_SetObjValueB("flagin", !bool);
		DHCWebD_SetObjValueB("flagout", !bool);
	} else {
		DHCWebD_SetObjValueB("CurAdmFlag", bool);
		DHCWebD_SetObjValueB("flagin", bool);
		DHCWebD_SetObjValueB("flagout", bool);
	}

}

function clearup() {
	stdate = websys_$V("stdate");
	enddate = websys_$V("enddate");
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFinfro&stdate=" + stdate + "&enddate=" + enddate;
	var findobj = websys_$('find');
	findobj.click();
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}

function setcolor() {
	var flagout = websys_$('flagout');
	if (flagout.checked == false) {
		return;
	}
	var Rows = DHCWeb_GetTBRows('tUDHCJFinfro');
	if (Rows == 0) {
		return;
	}
	for (i = 1; i < Rows; i++) {
		Objtbl.rows[i].style.bgColor = "#ffff80";
	}
}

function getuser() {
	var userName = websys_$V('username');
	if (userName == "") {
		DHCWebD_SetObjValueB("userid", "");
	}
}

function finduser() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		username_lookuphandler();
		var userName = websys_$V('username');
		if (userName == "") {
			DHCWebD_SetObjValueB("userid", "");
		}
	}
}

function getadmreasonid(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("admreasonid", myAry[1]);
}

function getinhosp() {
	var flaginobj = websys_$('flagin');
	var flagoutobj = websys_$('flagout');
	if (flaginobj.checked == true) {
		flaginobj.value = "on";
		flagoutobj.checked = false;
		flagoutobj.value = "";
	} else {
		flaginobj.value = "";
		flagoutobj.checked = true;
		flagoutobj.value = "on";
	}
}

function getouthosp() {
	var flaginobj = websys_$('flagin');
	var flagoutobj = websys_$('flagout');
	if (flagoutobj.checked == true) {
		flagoutobj.value = "on";
		flaginobj.checked = false;
		flaginobj.value = "";
	} else {
		flagoutobj.value = "";
		flaginobj.checked = true;
		flaginobj.value = "on";
	}
}

function LookUpUser(str) {
	var myAry = str.split("^");
	if (eval(myAry[1]) == 0) {
		myAry[1] = "";
	}
	DHCWebD_SetObjValueB("userid", myAry[1]);
}

function lookupward(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("wardid", myAry[1]);
}

function getward() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		warddesc_lookuphandler();
		var wardname = websys_$('warddesc');
		if (wardname == "") {
			DHCWebD_SetObjValueB("wardid", myAry[1]);
		}
	}
}

function findno() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		if (regnoobj.value != "") {
			papno = regnoobj.value;
			if (checkno(papno)) {
				papno = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", papno);
				regnoobj.value = papno;
				var encmeth = DHCWebD_GetObjValue('getadm');
				if (cspRunServerMethod(encmeth, 'setpat_val', '', papno) == 1) {}
			}
		}
		var findobj = websys_$('find');
		findobj.click();
	}
}

function findclk() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var find = websys_$('find');
		if (find) {
			find.click();
		}
	}
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0) {
			return false;
		}
	}
	return true;
}

function setpat_val(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB("name", myAry[0]);
	if (myAry[0] == "") {
		regnoobj.value = "";
		alert("没有就诊记录！");
		websys_setfocus('regno');
		return;
	}
	DHCWebD_SetObjValueB("warddesc", myAry[1]);
	DHCWebD_SetObjValueB("wardid", myAry[9]);
	DHCWebD_SetObjValueB("admreason", myAry[4]);
	DHCWebD_SetObjValueB("admreasonid", myAry[10]);
}

function gettoday1() {
	var encmeth = DHCWebD_GetObjValue("gettoday");
	var stdatetime = cspRunServerMethod(encmeth);
	if (stdatetime != "") {
		var myAry = stdatetime.split("^");
		stdateobj.value = myAry[0];
		enddateobj.value = myAry[0];
	}
}

function SelectRowHandler() {
	var SelectedRow = 0;
	var Rows = DHCWeb_GetTBRows("tUDHCJFinfro");
	var selectrow = DHCWeb_GetRowIdx(window);
	if (!selectrow) {
		return;
	}
	if (selectrow != SelectedRow) {
		Adm = DHCWeb_GetColumnData('Tadmid', selectrow);
	}
}

function linkprtadminfo() {
	if (Adm == "") {
		alert(t['04']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('printadminfo');
	var str = cspRunServerMethod(encmeth, '', '', Adm);
	if (str == "100") {
		alert(t['04']);
		return;
	} else {
		if (str != "") {
			Printadminfo(str);
		}
	}
}

function Clear_Click() {
	var userName = websys_$V("username");
	var userID = websys_$V("userid");
	var linkFlag = websys_$V("linkFlag");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFinfro";
	//+2018-01-26 ZhYW 住院登记界面链接进来的,清屏时收费员不清空
	if (linkFlag == "Y"){
		lnk += "=&username=" + userName + "&userid=" + userID + "&linkFlag=" + linkFlag;
	}
	location.href = lnk;
}

function clearusername() {
	DHCWebD_SetObjValueB("username1", "");
}

function clearwarddesc() {
	DHCWebD_SetObjValueB("warddesc", "");
}

function clearwardid() {
	DHCWebD_SetObjValueB("wardid", "");
}

function clearadmreason() {
	DHCWebD_SetObjValueB("admreason", "");
}

function clearregno() {
	DHCWebD_SetObjValueB("regno", "");
}

function clearname() {
	DHCWebD_SetObjValueB("name", "");
}

function print_click() {
	var Rows = DHCWeb_GetTBRows('tUDHCJFinfro');
	if (Rows == 0 ) {
		alert("没有要打印的数据！");
		return;
	}
	if (Guser == "") {
		return;
	}
	var job = DHCWeb_GetColumnData('Tjob', 1);
	if (job == "") {
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getnum');
	patnum = cspRunServerMethod(encmeth, Guser, job);
	var xlApp;
	var obook;
	var osheet;
	var xlBook;
	var Template = path + "JF_PATInfo.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	for (i = 1; i <= patnum; i++) {
		var encmeth = DHCWebD_GetObjValue('getdata');
		var str = cspRunServerMethod(encmeth, i, Guser, job);
		myData1 = str.split("^");
		for (j = 0; j < myData1.length; j++) {
			xlsheet.cells(i + 3, j + 2) = myData1[j];
		}
		addgrid(xlsheet, 0, 2, 1, 13, i + 2, 2);
	}
	var stDate = websys_$V("stdate");
	var endDate = websys_$V("enddate");
	xlsheet.cells(2, 4) = stDate + "至" + endDate;
	xlsheet.cells(2, 11) = session['LOGON.USERCODE'];
	xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

function outExp_click() {
	//和打印统一，没有点查询不导出数据  add zhli  17.8.28
	var Rows = DHCWeb_GetTBRows('tUDHCJFinfro');
	if (Rows == 0) {
		alert("没有要导出的数据！");
		return;
	}
	var stdate = websys_$V("stdate");
	var enddate = websys_$V("enddate");
	var admreasonid = websys_$V("admreasonid");
	var userid = websys_$V("userid");
	var flagin = websys_$("flagin");
	if (flagin.checked == true) {
		flagin = "on";
	} else {
		flagin = "";
	}
	var flagout = websys_$("flagout");
	if (flagout.checked == true) {
		flagout = "on";
	} else {
		flagout = "";
	}
	var wardid = websys_$V("wardid");
	var pxflag = websys_$V("pxflag");
	var PaidFlag = websys_$("PaidFlag");
	if (PaidFlag.checked == true) {
		PaidFlag = "on";
	} else {
		PaidFlag = "";
	}
	var Guser = websys_$V("Guser");
	var warddesc = websys_$V("warddesc");
	var CurAdmFlag = websys_$("CurAdmFlag");
	if (CurAdmFlag.checked == true) {
		CurAdmFlag = "on";
	} else {
		CurAdmFlag = "";
	}
	var name = websys_$V("name");
	var regno = websys_$V("regno");
	var username = websys_$V("username");
	
	var fileName = "DHCBill_住院病人一览表.raq&stdate=" + stdate + "&enddate=" + enddate + "&admreasonid=" + admreasonid;
	fileName += "&userid=" + userid + "&flagin=" + flagin + "&flagout=" + flagout + "&regno=" + regno + "&name=" + name;
	fileName += "&wardid=" + wardid + "&pxflag=" + pxflag + "&PaidFlag=" + PaidFlag + "&Guser=" + Guser + "&warddesc=" + warddesc;
	fileName += "&CurAdmFlag=" + CurAdmFlag + "&username=" + username;

	DHCCPM_RQPrint(fileName, 800, 500);
}

function clearadmreason() {
	var admreason = websys_$V("admreason");
	if (admreason == "") {
		DHCWebD_SetObjValueB("admreasonid", "");
	}
}

document.body.onload = BodyLoadHandler;
