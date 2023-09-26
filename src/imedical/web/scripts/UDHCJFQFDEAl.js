/// UDHCJFQFDEAL.js

var papnoobj, nameobj, admobj;
var name, papno, guser, amount, paymode, path, returnval, gusercode;
var AbortRowid;
var SelectedRow = "-1";

function BodyLoadHandler() {
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFQFPrint");
	guser = session['LOGON.USERID'];
	gusercode = session['LOGON.USERCODE'];
	paymode = "";
	var obj = document.getElementById("flag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.options[1] = new Option("退回", "退回");
		obj.options[2] = new Option(t['02'], t['02']);
		obj.onchange = function() {
			document.getElementById("cReturnAmt").innerText = DHCWebD_GetObjValue("flag") + "金额";
		}
	}
	admobj = document.getElementById('EpisodeID');
	nameobj = document.getElementById("name");
	papno = document.getElementById("regno").value;
	papnoobj = document.getElementById("regno");
	papnoobj.onkeydown = findno;
	var obj = document.getElementById("btnsave");
	if (obj) {
		obj.onclick = Add_click;
	}
	var obj = document.getElementById("BtnAbort");
	if (obj) {
		obj.onclick = Abort_click;
	}
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
	var encmeth = DHCWebD_GetObjValue('GetCurrentNo');
	var CurNo = cspRunServerMethod(encmeth);
	document.getElementById("CurrentNo").value = CurNo;
	var obj = document.getElementById("BtnPrtDaily");
	if (obj) {
		obj.onclick = PrtDaily_click;
	}
	findno1();
}

function findno() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		findno1();
		var Findobj = document.getElementById('Find');
		Findobj.click();
	}
}

function findno1() {
	if (papnoobj.value != "") {
		papno = papnoobj.value;
		var encmeth = DHCWebD_GetObjValue('getregno');
		var papnonew = cspRunServerMethod(encmeth, papno);
		papnoobj.value = papnonew;
		P1 = papnonew;
		var encmeth = DHCWebD_GetObjValue('getadm');
		var value = cspRunServerMethod(encmeth, P1);
		var val = value.split("^");
		nameobj.value = val[0];
		admobj.value = val[1];
		if (nameobj.value == "") {
			papnoobj.value = "";
			alert(t['05']);
			websys_setfocus('papno');
			return;
		} else {
			//var encmeth=DHCWebD_GetObjValue('getqfamount');
			//document.getElementById('payamount').value=cspRunServerMethod(encmeth,admobj.value)
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

function Add_click() {
	var QFFlagobj = document.getElementById('QFFlag');
	var InvPrtRowidobj = document.getElementById('InvPrtRowid');
	var InvPrtRowid = InvPrtRowidobj.value;
	var BillRowidobj = document.getElementById('BillRowid');
	var BillRowid = BillRowidobj.value;
	if (InvPrtRowid == " ") {
		InvPrtRowid = "";
	}
	if (BillRowid == " ") {
		BillRowid = "";
	}
	var QFFlag = QFFlagobj.value;
	if ((QFFlag == "B") || (QFFlag == "T")) {
		alert("您选择的不是欠费记录不能补交");
		return;
	}
	if (InvPrtRowid == "") {
		alert("请选择要补交的发票记录");
		return;
	}
	if (BillRowid == "") {
		alert("请选择要补交的发票记录");
		return;
	}
	//判断补交金额不能大于欠费金额
	var qfamt = document.getElementById('payamount').value;
	if (qfamt == " ") {
		qfamt = "";
	}
	if (isNaN(qfamt)) {
		qfamt = 0.00;
	}
	var bjamt = document.getElementById('ReturnAmt').value;
	if (bjamt == " ") {
		bjamt = "";
	}
	if (isNaN(bjamt)) {
		bjamt = 0.00;
	}
	if (bjamt == "") {
		alert("补交金额不能为空!");
		return;
	}
	qfamt = Math.abs(eval(qfamt));
	bjamt = Math.abs(eval(bjamt));
	if (eval(bjamt) > eval(qfamt)) {
		alert(t['19']);
		return;
	}
	var adm = admobj.value;
	if (adm == "") {
		alert(t['06']);
		return;
	}
	var BillRowidobj = document.getElementById('BillRowid');
	var BillRowid = BillRowidobj.value;
	var encmeth = DHCWebD_GetObjValue('getqfamount');
	var qfamount = cspRunServerMethod(encmeth, BillRowid);
	if (qfamount == 0) {
		alert(t['15']);
		return;
	}
	var flag = document.getElementById('flag').value;
	var comment = document.getElementById('Comment').value;
	var currentno = document.getElementById('CurrentNo').value;
	var encmeth = DHCWebD_GetObjValue('getqfrowid');
	var rowid = cspRunServerMethod(encmeth, adm);
	if ((rowid != "") && (flag == t['01'])) {
		alert(t['11']);
		return;
	}
	if (bjamt == "") {
		alert(t['10']);
		return;
	}
	if (bjamt == 0) {
		alert(t['12']);
		return;
	}
	if (flag == "") {
		alert(t['09']);
		return;
	}
	if (paymode == "") {
		alert(t['16']);
		return;
	}
	if (currentno == "") {
		alert(t['17']);
		return;
	}
	var insstr = adm + "^" + bjamt + "^" + flag + "^" + guser + "^" + paymode + "^" + comment + "^" + currentno + "^" + InvPrtRowid + "^" + BillRowid;
	var encmeth = DHCWebD_GetObjValue('Add');
	var returnstr = cspRunServerMethod(encmeth, insstr);
	if (returnstr == "InvNull") {
		alert("对应发票不存在!");
		return;
	}
	var returnstr = returnstr.split("^");
	var returncode = returnstr[0];
	var insrowid = returnstr[1];
	var encmeth = DHCWebD_GetObjValue('GetPrintInfo');
	returnval = cspRunServerMethod(encmeth, insrowid);
	printQF();
}

function test(insrowid) {
	var encmeth = DHCWebD_GetObjValue('GetPrintInfo');
	returnval = cspRunServerMethod(encmeth, insrowid);
	printQF();
}

function Abort_click() {
	if ((AbortRowid == " ") || (!AbortRowid)) {
		alert(t['18']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('GetAbort');
	var retval = cspRunServerMethod(encmeth, AbortRowid);
	if (retval == 0) {
		alert(t['03']);
		var Findobj = document.getElementById('Find');
		Findobj.click();
	} else if (retval == "-1") {
		alert("欠费或结存记录不能作废:" + retval);
	} else if (retval == "-2") {
		alert("已作废记录无需再作废:" + retval);
	}else {
		alert("作废记录失败:" + retval);
	}
}

function LookUpPayMode(str) {
	var tem = str.split("^");
	paymode = tem[1];
}

function printQF() {
	var patname, patno,	patdep,	payamt,	paymode, amtdx,	rcptno;
	var prtyear, prtmonth,	prtday,	prttime, username,	depttypedesc;
	var patbah;

	var tem = returnval.split("^");
	patname = tem[0];
	patno = tem[1];
	patbah = tem[8];
	patno = patno + " 病案号: " + patbah;
	patdep = tem[9];//病区
	payamt = tem[3];
	paymode = tem[4];
	amtdx = tem[5];
	rcptno = tem[14];
	var datestr = tem[18];
	var splitstr = datestr.split("-");
	prtyear = splitstr[0];
	prtmonth = splitstr[1];
	var day = splitstr[2];
	var time = day.split(" ");
	prtday = time[0];
	prttime = time[1];
	username = tem[19];
	var hospital = tkMakeServerCall("web.UDHCJFBaseCommon", "GetHospitalName", session['LOGON.HOSPID']);  //+2019-08-06 ZhYW 
	
	PrtQFInfo = "patname" + String.fromCharCode(2) + patname + "^" + "patno" + String.fromCharCode(2) + patno + "^" + "patdep" + String.fromCharCode(2) + patdep;
	PrtQFInfo = PrtQFInfo + "^" + "payamt" + String.fromCharCode(2) + payamt + "^" + "paymode" + String.fromCharCode(2) + paymode + "^" + "amtdx" + String.fromCharCode(2) + amtdx;
	PrtQFInfo = PrtQFInfo + "^" + "rcptno" + String.fromCharCode(2) + rcptno + "^" + "prtyear" + String.fromCharCode(2) + prtyear + "^" + "prtmonth" + String.fromCharCode(2) + prtmonth;
	PrtQFInfo = PrtQFInfo + "^" + "prtday" + String.fromCharCode(2) + prtday + "^" + "prttime" + String.fromCharCode(2) + prttime + "^" + "username" + String.fromCharCode(2) + username;
	PrtQFInfo = PrtQFInfo + "^" + "djh" + String.fromCharCode(2) + t['dtdjh'] + "^" + "n" + String.fromCharCode(2) + t['dtn'] + "^" + "y" + String.fromCharCode(2) + t['dty'] + "^" + "r" + String.fromCharCode(2) + t['dtr'];
	PrtQFInfo = PrtQFInfo + "^" + "no" + String.fromCharCode(2) + t['dt'] + "^" + "dtzsd" + String.fromCharCode(2) + t['dtzsd'] + "^" + "dtbfbr" + String.fromCharCode(2) + t['dtbfbr'] + "^" + "dtyjzyf" + String.fromCharCode(2) + t['dtyjzyf'];
	PrtQFInfo = PrtQFInfo + "^" + "dtrmb" + String.fromCharCode(2) + t['dtrmb'] + "^" + "dtd" + String.fromCharCode(2) + t['dtd'] + "^" + "dtjsr" + String.fromCharCode(2) + t['dtjsr'] + "^" + "dtz" + String.fromCharCode(2) + t['dtz'];
	PrtQFInfo = PrtQFInfo + "^" + "dtyjjbt" + String.fromCharCode(2) + t['dtyjjbt'] + "^" + "dtfbt" + String.fromCharCode(2) + hospital;
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, PrtQFInfo, "");
	
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function PrtDaily_click() {
	var xlApp,	obook,	osheet,	xlsheet, xlBook;
	Template = path + "JF_QFDaily.xls";
	Template = "d:\\JF_QFDaily.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	//patname+"^"+patno+"^"+patdep+"^"+amt+"^"+paymode+"^"+amtdx+"^"+patbed+"^"+pataddress+"^"+patbah+"^"+patward+"^"+deptcomp+"^"+bankname+"^"+cardno+"^"+curno;
	xlsheet = xlBook.ActiveSheet;
	var SelRowObj = document.getElementById('Tjobz' + 1);
	var job = SelRowObj.innerText;
	var encmeth = DHCWebD_GetObjValue('GetPrtNum');
	var gnum = cspRunServerMethod(encmeth, job);
	for (i = 1; i < gnum; i++) {
		var encmeth = DHCWebD_GetObjValue('GetPrtInfo');
		var prtinfo = cspRunServerMethod(encmeth, job, i);
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	Objtbl = document.getElementById('tUDHCJFQFDEAL');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var QFRowidobj = document.getElementById('QFRowid');
	var InvPrtRowidobj = document.getElementById('InvPrtRowid');
	var QFFlagobj = document.getElementById('QFFlag');
	var BillRowidobj = document.getElementById('BillRowid');
	if (selectrow != SelectedRow) {
		admobj.value = DHCWeb_GetColumnData('Tadmid', selectrow)
		InvPrtRowidobj.value = DHCWeb_GetColumnData('TInvRowid', selectrow);
		QFFlagobj.value = DHCWeb_GetColumnData('TQFFlag', selectrow);
		BillRowidobj.value = DHCWeb_GetColumnData('TBillRowid', selectrow);
		if (BillRowidobj.value == " ") {
			BillRowidobj.value = "";
		}
		AbortRowid = DHCWeb_GetColumnData('Trowid', selectrow);
		
		if (BillRowidobj.value != "") {
			var ReturnVal = tkMakeServerCall("web.UDHCJFQFDEAL", "getqfamountbill", BillRowidobj.value);
			if (ReturnVal == " ") {
				ReturnVal = "";
			}
			if (isNaN(ReturnVal)) {
				ReturnVal = 0;
			}
			document.getElementById('payamount').value = ReturnVal;
		}
		SelectedRow = selectrow;
	} else {
		admobj.value = "";
		InvPrtRowidobj.value = "";
		QFFlagobj.value = "";
		SelectedRow = "-1";
	}
}

document.body.onload = BodyLoadHandler;