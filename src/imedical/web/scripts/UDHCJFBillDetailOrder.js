/// UDHCJFBillDetailOrder.js

var Guser, BillNo;
var printobj, job;
var path, tmpstr, num, pross;
var hospital;
var valuepainfo, nameobj, panoobj, mednoobj, sexobj, ctlocobj, patareaobj;
var paname, pano, medno, sex, ctloc, patarea;
var job;
var MyPrtAry = new Array();
var MyAryIdx = 0;

function BodyLoadHandler() {
	nameobj = document.getElementById('Name');
	panoobj = document.getElementById('pano');
	mednoobj = document.getElementById('medno');
	sexobj = document.getElementById('sex');
	ctlocobj = document.getElementById('ctloc');
	patareaobj = document.getElementById('patarea');
	Guser = session['LOGON.USERID'];
	var billnoobj = document.getElementById('BillNo');
	BillNo = billnoobj.value;
	printobj = document.getElementById('Print');
	if (printobj) {
		printobj.onclick = print_click;
	}
	var ConfirmObj = document.getElementById('BtnConfirm');
	if (ConfirmObj) {
		ConfirmObj.onclick = Confirm_click;
	}
	var CancConfirmObj = document.getElementById('BtnCancConfirm');
	if (CancConfirmObj) {
		CancConfirmObj.onclick = CanCConfirm_click;
	}
	var doclocObj = document.getElementById('docloc');
	doclocObj.onkeyup = cleardocloc;

	GetNum();
	getpath();
	gethospital();
	getpatinfo();
	InitConfirmFlag();
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

function getpath() {
	var getpath = document.getElementById('getpath');
	if (getpath) {
		var encmeth = getpath.value;
	} else {
		var encmeth = '';
	}
	path = cspRunServerMethod(encmeth, '', '');
}

function getpatinfo() {
	var AdmDate;
	var AdmTime;
	var p1 = BillNo;
	var getpatinfoobj = document.getElementById('getpatinfo');
	if (getpatinfoobj) {
		var encmeth = getpatinfoobj.value;
	} else {
		var encmeth = '';
	}
	tmpstr = cspRunServerMethod(encmeth, '', '', p1);
	var valuepainfo1 = tmpstr.split("#")[0];
	var valuepainfo = valuepainfo1.split("^");
	pano = valuepainfo[0];
	paname = valuepainfo[1];
	medno = valuepainfo[2];
	sex = valuepainfo[4];
	var valueadminfo1 = tmpstr.split("#")[1]
	var valueadminfo = valueadminfo1.split("^");
	AdmDate = valueadminfo[7];
	AdmTime = valueadminfo[8];
	AdmDay = valueadminfo[6];
	ctloc = valueadminfo[3];
	patarea = valueadminfo[4];
	panoobj.innerText = pano;
	nameobj.innerText = paname;
	mednoobj.innerText = medno;
	sexobj.innerText = sex;
	ctlocobj.innerText = ctloc;
	patareaobj.innerText = patarea;
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.innerText = valuepainfo[12];
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.innerText = valuepainfo[13];
	}
	var PrtLevelObj = document.getElementById('PrtLevel');
	if (PrtLevelObj) {
		PrtLevelObj.value = valuepainfo[14];
	}
	
	document.getElementById("AdmDate").value = AdmDate + " " + AdmTime;
	document.getElementById("AdmDay").value = AdmDay;
}

function GetNum() {
	var Objtbl = document.getElementById('tUDHCJFBillDetail');
	var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	var getnum = document.getElementById('getnum');
	if (getnum) {
		var encmeth = getnum.value;
	} else {
		var encmeth = '';
	}
	var str;
	str = cspRunServerMethod(encmeth, '', '', BillNo, job);
	str = str.split("^");
	num = str[0];
}

function ListPrt(gnum) {
	var list = document.getElementById('list');
	if (list) {
		var encmeth = list.value;
	} else {
		var encmeth = '';
	}
	var str;
	str = cspRunServerMethod(encmeth, '', '', BillNo, job, gnum);
	return str;
}

function print_click() {
	var Objtbl = document.getElementById('tUDHCJFBillDetail');
	var SelRowObj = document.getElementById('Tjobz' + 1);
	job = SelRowObj.innerText;
	var BillNO = document.getElementById("BillNo").value;
	var stdate = document.getElementById("stdate").value;
	var enddate = document.getElementById("endate").value;
	var fileName = "DHCIPBILLFindBillInfo.raq&BillNo=" + BillNO + "&job=" + job + "&stdate=" + stdate + "&enddate=" + enddate;
	DHCCPM_RQPrint(fileName, 800, 500);
}

function CellMerge(objSheet, r1, r2, c1, c2) {
	var range = objSheet.Range(objSheet.Cells(r1, c1), objSheet.Cells(r2, c2));
	range.MergeCells = "True";
}

function CellLine(objSheet, row1, row2, c1, c2, Style) {
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2, c2)).Borders(Style).LineStyle = 1;
}

function UnloadHandler() {
	var KillTMPPrtGlbobj = document.getElementById("KillTmp");
	if (KillTMPPrtGlbobj) {
		var encmeth = KillTMPPrtGlbobj.value;
	} else {
		var encmeth = '';
	}
	var mytmp = cspRunServerMethod(encmeth, BillNo, job)
}

function CheckOrderExec(Me, BtnComplete, OrderRowid, OrderSub, BillNo) {
	if ((OrderRowid != "") && (OrderSub != "")) {
		var OrderItemRowid = OrderRowid + "||" + OrderSub;
		var stdate = document.getElementById('stdate').value;
		var endate = document.getElementById('endate').value;
		var EpisodeID = document.getElementById('EpisodeID').value;
		var BillNo = document.getElementById('BillNo').value;
		var url = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdexcDetails1Copy&Oeordrowid=' + OrderItemRowid + "&StDate=" + stdate + "&EndDate=" + endate + "&EpisodeID=" + EpisodeID + "&BillNo=" + BillNo;
		websys_createWindow(url, '_blank', "width=80%,height=60%");
	} else {
		alert("请选择要查看的医嘱!");
	}
}

function getdoclocid(value) {
	var val = value.split("^");
	var obj = document.getElementById('getdoclocid');
	obj.value = val[1];
}

function cleardocloc() {
	var doclocobj = document.getElementById('docloc');
	if (doclocobj.value == "") {
		var obj = document.getElementById('getdoclocid');
		obj.value = "";
	}
}

function InitConfirmFlag() {
	var obj = document.getElementById("ConfirmFlag"); //生育类别
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.options[0] = new Option("通过", "Y");
		obj.options[1] = new Option("拒绝", "N");
		obj.selectedIndex = 0;
	}
}

function Confirm_click() {
	var confirmflag = document.getElementById('GetConfirm');
	if (confirmflag) {
		var encmeth = confirmflag.value;
	} else {
		var encmeth = '';
	}
	var ConfirmFlag = DHCWeb_GetListBoxValue("ConfirmFlag");
	var EpisodeIDobj = document.getElementById('EpisodeID');
	var BillNoobj = document.getElementById('BillNo');
	var ConfirmReasonobj = document.getElementById('ConfirmReason');

	var retval = cspRunServerMethod(encmeth, EpisodeIDobj.value, BillNoobj.value, session['LOGON.USERID'], ConfirmReasonobj.value, ConfirmFlag);
	if (retval == "0") {
		alert("审核成功!");
		return;
	} else if (retval == "Y") {
		alert("账单已经是审核通过状态,不用再审核通过!");
		return;
	} else if (retval == "N") {
		alert("账单已经是审核拒绝状态,不用再审核拒绝!");
		return;
	} else if (retval == "BillErr") {
		alert("患者有多个未结算账单,不允许审核!");
		return;
	} else if (retval == "VSatusErr") {
		alert("患者有未做最终结算,不允许审核!");
		return;
	} else if (retval == "CloseAcountErr") {
		alert("在院患者此账单未封帐,不允许审核!");
		return;
	} else if (retval == "AdmErr") {
		alert("患者正在进行费用调整,不允许审核!");
		return;
	} else {
		alert("审核失败!" + retval);
		return;
	}
}

function CanCConfirm_click() {
	var confirmflag = document.getElementById('GetConfirm');
	if (confirmflag) {
		var encmeth = confirmflag.value;
	} else {
		var encmeth = '';
	}
	var EpisodeIDobj = document.getElementById('EpisodeID');
	var BillNoobj = document.getElementById('BillNo');
	var ConfirmReasonobj = document.getElementById('ConfirmReason');

	var retval = cspRunServerMethod(encmeth, EpisodeIDobj.value, BillNoobj.value, session['LOGON.USERID'], ConfirmReasonobj.value, "C");
	if (retval == "0") {
		alert("撤销审核成功!");
		return;
	} else if (retval == "C") {
		alert("账单已经是撤销审核状态,不用撤销!");
		return;
	} else if (retval == "") {
		alert("账单未审核，无需撤销!");
		return;
	} else {
		alert("撤销审核失败!" + retval);
		return;
	}
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler;
