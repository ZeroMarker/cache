/// UDHCJFZYFTZD.js

var BillNo;
var Adm;
var admobj, billnoobj;
var path;
var billstr, patinfo;
var regno, name;
var regnoobj, nameobj;
var curday, curmon, curyear;

function BodyLoadHandler() {
	billnoobj = document.getElementById('BillNo');
	BillNo = billnoobj.value;
	gusername = session['LOGON.USERNAME'];
	admobj = document.getElementById('Adm');
	Adm = admobj.value;
	if (Adm != "") {
		getinfo();
	}
	regnoobj = document.getElementById('regno');
	if (regnoobj) {
		regnoobj.onkeydown = regNoKeydown;
	}
	var Find = document.getElementById('Find');
	getpath();
	var prt = document.getElementById("print");
	if (prt) {
		prt.onclick = Print_click;
	}
	//增加调用押金明细界面
	var LinkFindDepoistobj = document.getElementById('LinkFindDepoist');
	if (LinkFindDepoistobj) {
		LinkFindDepoistobj.onclick = LinkFindDepoist;
	}
	//增加关闭界面功能
	var Closeobj = document.getElementById('Close');
	if (Closeobj) {
		Closeobj.onclick = Close_click;
	}
}

function setbill(value) {
	var str = value.split("^");
	var billobj = document.getElementById("BillNo");
	var admObj = document.getElementById('Adm');
	if (billobj) {
		billobj.value = str[0];
	}
	if (admObj) {
		admObj.value = str[3];
	}
	getinfo();
	Find_click();
}

function getinfo() {
	var billobj = document.getElementById("BillNo");
	var admObj = document.getElementById('Adm');
	var Adm = "";
	var BillNo = "";
	if (billobj) {
		BillNo = billobj.value;
	}
	if (admObj) {
		Adm = admObj.value;
	}
	if (Adm == "") {
		return;
	}
	var getpatinfo = document.getElementById("getpatinfo");
	if (getpatinfo) {
		var encmeth = getpatinfo.value;
	} else {
		var encmeth = '';
	}
	patinfo = cspRunServerMethod(encmeth, '', '', Adm, BillNo);

	str = patinfo.split("^");
	regnoobj = document.getElementById('regno');
	regnoobj.value = str[6];
	nameobj = document.getElementById('name');
	nameobj.value = str[5];
	var obj = document.getElementById('bed');
	obj.value = str[4];
	var obj = document.getElementById('depname');
	obj.value = str[2];
	var obj = document.getElementById('ybflag');
	obj.value = str[7];
	var obj = document.getElementById('admdate');
	obj.value = str[0];
	var obj = document.getElementById('discdate');
	obj.value = str[1];
	var obj = document.getElementById('days');
	obj.value = str[8];
	var obj = document.getElementById('TotalAmount');
	obj.value = str[9];
}

function Print_click() {
	Prt_FYQingDan();
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

function gettoday() {
	var getdateobj = document.getElementById('gettoday');
	if (getdateobj) {
		var encmeth = getdateobj.value;
	} else {
		var encmeth = '';
	}
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {}
}

function setdate_val(value) {
	var curdate = value.split("/");
	curday = curdate[0];
	curmon = curdate[1];
	curyear = curdate[2];
}

function LinkFindDepoist() {
	if ((Adm == "") || (BillNo == "")) {
		return;
	}
	var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&Adm=' + Adm; //+'&BillNo='+BillNo
	window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=600,left=0,top=60')
}

function Close_click() {
	window.close();
	window.opener.location.reload();
}

function regNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var regNo = DHCWebD_GetObjValue('regno');
		regNo = tkMakeServerCall('web.UDHCJFBaseCommon', 'regnocon', regNo); 
		DHCWebD_SetObjValueB('regno', regNo);
	}
}

document.body.onload = BodyLoadHandler;
