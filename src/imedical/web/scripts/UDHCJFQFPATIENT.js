///UDHCJFQFPATIENT.js

var path;
var num, job, stdate, enddate, locdesc, today;
var admitobj, dischobj, admitvalobj, dischvalobj, locobj;
var qfobj, qfflagobj, jyflagobj, jyobj, zeroobj, zeroflagobj;
var hospital;
var Adm;
var ArrearsValueobj, ArrearsFlagobj;

function BodyLoadHandler() {
	admitobj = document.getElementById('Byadmit');
	admitvalobj = document.getElementById('Admitval');
	dischobj = document.getElementById('Bydischarged');
	dischvalobj = document.getElementById('Dischval');
	locobj = document.getElementById('Loc');
	locidobj = document.getElementById('Locid');
	//locobj = document.getElementById('Loc');
	var printobj = document.getElementById('Print');
	//locobj.onkeyup = clearlocid;
	admitobj.onclick = getadmitobjfun;
	dischobj.onclick = getdischobjfun;
	printobj.onclick = Print_Click;
	qfflagobj = document.getElementById('qfflag');
	qfobj = document.getElementById('qf');
	jyflagobj = document.getElementById('jyflag');
	jyobj = document.getElementById('jy');
	zeroflagobj = document.getElementById('zeroflag');
	zeroobj = document.getElementById('zero');
	qfflagobj.onclick = getqfflag;
	jyflagobj.onclick = getjyflag;
	zeroflagobj.onclick = getzeroflag;
	var UPQFFlagobj = document.getElementById('UPQFFlag');
	if (UPQFFlagobj) {
		UPQFFlagobj.onclick = UPQFFlag_click;
	}
	var UPCanQFFlagobj = document.getElementById('UPCanQFFlag');
	if (UPCanQFFlagobj) {
		UPCanQFFlagobj.onclick = UPCanQFFlag_click;
	}
	//
	if (admitvalobj.value == "1") {
		admitobj.checked = true;
	}
	if (dischvalobj.value == "1") {
		dischobj.checked = true;
	}
	if (jyobj.value == "1"){
		jyflagobj.checked = true;
	}
	if (qfobj.value == "1") {
		qfflagobj.checked = true;
	}
	//
	if (qfflagobj.checked == true) {
		qfobj.value = "1";
	} else {
		qfobj.value = "0";
	}
	if (jyflagobj.checked == true) {
		jyobj.value = "1";
	} else {
		jyobj.value = "0";
	}
	if (zeroflagobj.checked == true) {
		zeroobj.value = "1";
	} else {
		zeroobj.value = "0"
	}
	var ArrearsFlagobj = document.getElementById('ArrearsFlag');
	var ArrearsValueobj = document.getElementById('ArrearsValue');
	if (ArrearsFlagobj.checked == true) {
		ArrearsValueobj.value = "1";
	} else {
		ArrearsValueobj.value = "0";
	}
	ArrearsFlagobj.onclick = getArrearsFlag;
	//locobj.onkeydown = getloc;
	locobj.onkeyup = clearLoc;
	var wardobj = document.getElementById('ward');
	wardobj.onkeyup = clearward;
	getpath();
	gethospital();
	SetColor();
}

function gettoday() {
	var gettoday = document.getElementById('gettoday');
	if (gettoday) {
		var encmeth = gettoday.value;
	} else {
		var encmeth = '';
	}
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	today = value;
	var obj = document.getElementById('Stdate');
	obj.value = value;
	var obj = document.getElementById('Enddate');
	obj.value = value;
}

function getpath() {
	var getpath = document.getElementById('getpath');
	if (getpath) {
		var encmeth = getpath.value;
	} else {
		var encmeth = '';
	}
	path = cspRunServerMethod(encmeth, '', '');
}

function getadmitobjfun() {
	if (admitobj.checked == true) {
		admitvalobj.value = "1";
	} else {
		admitvalobj.value = "0"
	}
}

function getdischobjfun() {
	if (dischobj.checked == true) {
		dischvalobj.value = "1";
	} else {
		dischvalobj.value = "0"
	}
}

function clearlocid() {
	var locidobj = document.getElementById('Locid');
	locidobj.value = "";
}

function getqfflag() {
	if (qfflagobj.checked == true) {
		qfobj.value = "1";
		jyobj.value = "0";
		zeroobj.value = "0";
		jyflagobj.checked = false;
		zeroflagobj.checked = false;
	}
	/*
	else {
		qfobj.value = "0";
		jyobj.value = "1";
		zeroobj.value = "1";
		jyflagobj.checked = true;
		zeroflagobj.checked = true;
	}
	*/
}

function getzeroflag() {
	if (zeroflagobj.checked == true) {
		qfobj.value = "0";
		jyobj.value = "0";
		zeroobj.value = "1";
		jyflagobj.checked = false;
		qfflagobj.checked = false;
	}
	/*
	else {
		qfobj.value = "0";
		jyobj.value = "1";
		zeroobj.value = "1";
		jyflagobj.checked = true;
		zeroflagobj.checked = true;
	}
	*/
}
function getjyflag() {
	if (jyflagobj.checked == true) {
		jyobj.value = "1";
		qfobj.value = "0";
		zeroobj.value = "0";
		qfflagobj.checked = false;
		zeroflagobj.checked = false
	}
	/*else {
		jyobj.value = "0";
		qfobj.value = "1";
		zeroobj.value = "1";
		qfflagobj.checked = true;
		zeroflagobj.checked = true;
	}
	*/
}

function getArrearsFlag() {
	ArrearsFlagobj = document.getElementById('ArrearsFlag');
	ArrearsValueobj = document.getElementById('ArrearsValue');
	if (ArrearsFlagobj.checked == true) {
		ArrearsValueobj.value = "1";
	} else {
		ArrearsValueobj.value = "0";
	}
}

function gethospital() {
	var gethospital = document.getElementById('gethospital');
	if (gethospital) {
		var encmeth = gethospital.value;
	} else {
		var encmeth = '';
	}
	hospital = cspRunServerMethod(encmeth);
}

function getlocid(value) {
	var val = value.split("^");
	var obj = document.getElementById('Locid');
	obj.value = val[1];
}

function GetNum() {
	var Objtbl = document.getElementById('tUDHCJFQFPATIENT');
	var SelRowObj = document.getElementById('Tjobz' + 1);
	//job = SelRowObj.innerText;
	job = SelRowObj.value;
	var getnum = document.getElementById('getnum');
	if (getnum) {
		var encmeth = getnum.value;
	} else {
		var encmeth = '';
	}
	var str;
	str = cspRunServerMethod(encmeth, '', '', job);
	str = str.split("^");
	num = str[0];
}

function Print_Click() {
	GetNum();
	locdesc = locobj.value;
	var obj = document.getElementById('Stdate');
	stdate = obj.value;
	var obj = document.getElementById('Enddate');
	enddate = obj.value;
	printQFPATIENT();
}

function ListPrt(gnum) {
	var list = document.getElementById('list');
	if (list) {
		var encmeth = list.value;
	} else {
		var encmeth = '';
	}
	var str = cspRunServerMethod(encmeth, '', '', job, gnum);
	return str;
}

function getloc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Loc_lookuphandler();
	}
}

function gettypeid(value) {
	var val = value.split("^");
	var obj = document.getElementById('admreason');
	obj.value = val[1];
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tUDHCJFQFPATIENT');
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var SelRowObj = document.getElementById('Tadmrowidz' + selectrow);
	Adm = SelRowObj.innerText;
}

function UPQFFlag_click() {
	if (Adm == "") {
		alert(t['Arrears00']);
		return;
	}
	var userid = session['LOGON.USERID'];
	var flag = "1";
	var AdmArrearsinfro = Adm + "^" + userid + "^" + flag;
	var getUPQFFlagobj = document.getElementById('getUPQFFlag');
	if (getUPQFFlagobj) {
		var encmeth = getUPQFFlagobj.value;
	} else {
		var encmeth = '';
	}
	var retcode = cspRunServerMethod(encmeth, AdmArrearsinfro);
	if (retcode == '0') {
		alert(t['Arrears01']);
	} else if (retcode == '1') {
		alert(t['Arrears05']);
	} else {
		alert(t['Arrears03']);
	}
}

function UPCanQFFlag_click() {
	if (Adm == "") {
		alert(t['Arrears00']);
		return;
	}
	var userid = session['LOGON.USERID'];
	var flag = "0";
	var AdmArrearsinfro = Adm + "^" + userid + "^" + flag;
	var getUPQFFlagobj = document.getElementById('getUPQFFlag');
	if (getUPQFFlagobj) {
		var encmeth = getUPQFFlagobj.value;
	} else {
		var encmeth = '';
	}
	var retcode = cspRunServerMethod(encmeth, AdmArrearsinfro);
	if (retcode == '0') {
		alert(t['Arrears03']);
	} else if (retcode == '1') {
		alert(t['Arrears06']);
	} else {
		alert(t['Arrears04']);
	}
}

function getwardid(value) {
	var val = value.split("^");
	var obj = document.getElementById('wardid');
	obj.value = val[1];
}

function SetColor() {
	var Objtbl = document.getElementById('tUDHCJFQFPATIENT');
	var Rows = Objtbl.rows.length;
	for (i = 1; i <= Rows - 2; i++) {
		var SelRowObj = document.getElementById('TRemainSelfz' + i);
		var RemainSelf = SelRowObj.innerText;
		if (eval(RemainSelf) < 0) {  
			//Objtb.rows[i].style.background = 'red';  //设置背景色
			SelRowObj.style.color = 'red';             //设置前景色
		}
		var SelRowObj = document.getElementById('Tbalancez' + i);
		var Remain = SelRowObj.innerText;
		if (eval(Remain) < 0) { 
			//Objtb.rows[i].style.background = 'red'; //设置背景色
			SelRowObj.style.color = 'red';            //设置前景色
		}
	}

}

function clearLoc() {
	var Locobj = document.getElementById('Loc');
	if (Locobj.value == "") {
		document.getElementById('Locid').value = "";
	}
}

function clearward() {
	var wardobj = document.getElementById('ward');
	if (wardobj.value == "") {
		document.getElementById('wardid').value = "";
	}
}

document.body.onload = BodyLoadHandler;
