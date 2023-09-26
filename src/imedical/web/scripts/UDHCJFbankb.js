/// UDHCJFbankb.js

var stdate, enddate, note, bankrowid, rowid, flag, updateuser;
var today, time;
var guser;
var selectRow = "-1";
var cardnoobj, paymodeobj, fptypeobj, payflagobj;
var cardno, paymode, fptype, payflag;
var stdateobj, enddateobj, stdate1obj, enddate1obj;
var curdate, PrtStatus;

function BodyLoadHandler() {
	stdateobj = websys_$("stdate");
	enddateobj = websys_$("enddate");
	stdate = websys_$V('stdate');
	enddate = websys_$V('enddate');
	cardnoobj = websys_$('cardno');
	paymodeobj = websys_$('paymode');
	fptypeobj = websys_$('fptype');
	payflagobj = websys_$('payflag');
	cardno = websys_$V('cardno');
	paymode = websys_$V('paymode');
	fptype = websys_$V('fptype');
	payflag = websys_$V('payflag');
	var objPayFlag = websys_$('payflag');
	objPayFlag.onkeydown = function () {
		return false;
	}
	note = websys_$V('note');
	var insert = websys_$('insert');
	insert.onclick = insert_click;
	var update = websys_$('update');
	update.onclick = update_click;
	guser = session['LOGON.USERID'];
	gettime();
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tUDHCJFbankb');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	bankrowid = DHCWeb_GetColumnData('Tbankbrowid', selectrow);
	rowid = DHCWeb_GetColumnData('Trowid', selectrow);
	payflagobj.value = DHCWeb_GetColumnData('Tflag', selectrow);
	flag = DHCWeb_GetColumnData('Tflag', selectrow);
	
	cardnoobj.value = DHCWeb_GetColumnData('Tcardno', selectrow);
	fptypeobj.value = DHCWeb_GetColumnData('Tfptype', selectrow);
	
	updateuser = DHCWeb_GetColumnData('Tupdateuser', selectrow);
	var noteObj = document.getElementById('note');
	noteObj.value = DHCWeb_GetColumnData('Tnote', selectrow);
	paymodeobj.value = DHCWeb_GetColumnData('Tpaymode', selectrow);
	PrtStatus = DHCWeb_GetColumnData('Tstatus', selectrow);
	//+2018-06-12 ZhYW
	var flagId = DHCWeb_GetColumnData('TFlagId', selectrow);
	DHCWebD_SetObjValueB('bflagid', flagId);
}


function gettime() {
	var encmeth = DHCWebD_GetObjValue('time');
	var str = cspRunServerMethod(encmeth, '', '');
	str = str.split("^");
	time = str[1];
	today = str[0];
}

function insert_click() {
	var Objtbl = document.getElementById('tUDHCJFbankb');
	var Rows = Objtbl.rows.length;
	if (Rows < 2){
		return;
	}
		
	var flagid = document.getElementById('bflagid').value;
	var note = document.getElementById('note').value;
	payflag = document.getElementById('payflag').value;
	fptype = document.getElementById('fptype').value;
	var row = 1;
	if ((rowid == "") || (rowid == " ")) {
		alert("请选择支票信息!!");
		return;
	}
	if ((bankrowid != "") && (bankrowid != " ")) {
		alert("已经有支票到账信息不能增加!!");
		return;
	}
	if ((payflag == "") || (payflag == " ")) {
		alert("到账标志不能为空!!");
		websys_setfocus('payflag');
		return;
	}
	if (fptype == "押金") {
		if (PrtStatus != "正常"){
			alert("非正常押金不能到账.");
			return;
		}
		var yjrowid = rowid;
		var str = yjrowid + "^^" + flagid + "^" + guser + "^" + today + "^" + time + "^^^^" + note;
	} else {
		var fprowid = rowid;
		var str = "^" + fprowid + "^" + flagid + "^" + guser + "^" + today + "^" + time + "^^^^" + note;
	}
	var p2 = str;
	var encmeth = DHCWebD_GetObjValue('doadd');
	if (cspRunServerMethod(encmeth, 'show1', '', p2) == '1') {
	}
}

function update_click() {
	var Objtbl = document.getElementById('tUDHCJFbankb');
	var Rows = Objtbl.rows.length;
	if (Rows < 2) {
		return;
	}
	var flagid = document.getElementById('bflagid').value;
	payflag = document.getElementById('payflag').value;
	fptype = document.getElementById('fptype').value;
	if ((bankrowid == "") && (bankrowid == " ")) {
		alert("没有支票到账信息不能修改!!");
		return;
	}
	var updateuser = session['LOGON.USERID'];
	if (updateuser == "") {
		alert("操作员不能为空.");
		return;
	}
	var note = document.getElementById('note').value;
	if (fptype == "押金") {
		var yjrowid = rowid;
		var str = yjrowid + "^^" + flagid + "^^^^" + guser + "^" + today + "^" + time + "^" + note + "^" + bankrowid;
	} else {
		var fprowid = rowid;
		var str = "^" + fprowid + "^" + flagid + "^^^^" + guser + "^" + today + "^" + time + "^" + note + "^" + bankrowid;
	}
	var p3 = str;
	var encmeth = DHCWebD_GetObjValue('doupdate');
	if (cspRunServerMethod(encmeth, 'show', '', p3) == '1') {
	}
}

function show(value) {
	if (value == 0) {
		alert("修改成功.");
		find_click();
	}
}

function show1(value) {
	if (value == 0) {
		alert("到账成功.");
		find_click();
	}
}

function setflag(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('bflagid', myAry[1]);
}

document.body.onload = BodyLoadHandler