/// DHCIPBillOrdCheck.js

var Adm;
var Guser;
var RegNo;
var guserobj;
var papnoobj;
var nameobj;
var admobj;
var depositobj;
var amountobj;
var balanceobj;
var ordcatobj;
var orderobj;
var reclocobj;
var billobj;
var clearobj;
var notpaidobj;
var selectdateobj;
var dateobj;
var getnotpaidobj;
var getseldateobj;
var findobj;
var doclocobj;
var printdetailobj;
var selstatusobj;
var getstatusobj;
var path;
var PatMedicareObj;
var OrdList = new Array();  //add by zhl
var OrdSite = new Array();
OrdSite[0] = "Start";

function BodyLoadHandler() {
	papnoobj = document.getElementById('RegNo');
	nameobj = document.getElementById('name');
	//admobj = document.getElementById('Adm');
	admobj = document.getElementById('EpisodeID');
	depositobj = document.getElementById('deposit');
	amountobj = document.getElementById('amount');
	balanceobj = document.getElementById('balance');
	ordcatobj = document.getElementById('ordcat');
	orderobj = document.getElementById('order');
	reclocobj = document.getElementById('recloc');
	doclocobj = document.getElementById('docloc');
	billobj = document.getElementById('Bill');
	clearobj = document.getElementById('Clear');
	notpaidobj = document.getElementById('notpaid');
	selectdateobj = document.getElementById('seldate');
	getnotpaidobj = document.getElementById('getnotpaid');
	getseldateobj = document.getElementById('getseldate');
	dateobj = document.getElementById('date');
	guserobj = document.getElementById('Guser');
	findobj = document.getElementById('Find');
	printdetailobj = document.getElementById('printdetail');
	selstatusobj = document.getElementById('selstatus');
	getstatusobj = document.getElementById('getstatus');
	var PrtOrdDetailobj = document.getElementById('PrtOrdDetail');
	if (PrtOrdDetailobj) {
		PrtOrdDetailobj.onclick = PrtOrdDetail_click;
	}
	PatMedicareObj = document.getElementById('PatMedicare');
	if (PatMedicareObj) {
		PatMedicareObj.onkeydown = getpat;
	}
	Guser = guserobj.value;
	papnoobj.onkeydown = getpat;

	clearobj.onclick = clearall;
	notpaidobj.onclick = getnotpaidfun;
	selectdateobj.onclick = getseldatefun;
	billobj.onclick = bill;
	findobj.onclick = Find;
	printdetailobj.onclick = Print;
	ordcatobj.onkeyup = clearordcatid;
	orderobj.onkeyup = clearorderid;
	reclocobj.onkeyup = clearreclocid;
	doclocobj.onkeyup = cleardoclocid;
	depositobj.readOnly = true;
	amountobj.readOnly = true;
	balanceobj.readOnly = true;
	selstatusobj.onclick = selstatusfun;
	//预交金明细
	var depositViewobj = document.getElementById('btnDepositView');
	if (depositViewobj) {
		depositViewobj.onclick = depositView_onclick;
	}
	//notpaidobj.checked = true;
	//getnotpaidobj.value = "0";
	//getseldateobj.value = "0";
	if (getnotpaidobj.value == "0") {
		notpaidobj.checked = true;
	}
	if (getnotpaidobj.value == "1") {
		notpaidobj.checked = false;
	}
	if (getseldateobj.value == "0") {
		selectdateobj.checked = false;
	}
	if (getseldateobj.value == "1") {
		selectdateobj.checked = true;
	}
	if (doclocobj.value == "") {
		cleardoclocid();
	}
	if (getstatusobj.value == "0") {
		selstatusobj.checked = true;
	}
	if (getstatusobj.value == "1") {
		selstatusobj.checked = false;
	}
	//insert by cx 2006.05.26
	getstatusobj.value = "1";
	var admnew = DHCWebD_GetObjValue("admnew");
	/*
	if ((papnoobj.value != "") && (admnew == "")){
		p1 = papnoobj.value;
		var encmeth = DHCWebD_GetObjValue("getregno");
		if (cspRunServerMethod(encmeth, 'setpat_val', '', p1)=='1'){}
	}
	if (admnew != ""){
		var encmeth = DHCWebD_GetObjValue("getpayinfo");
		if (cspRunServerMethod(encmeth, 'setpayinfo', '', admnew)=='1'){}
	}
	*/
	getpayinfo();  //wangjian 2014-12-03
	getpath();
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readcard_click;
	}
	var obj = document.getElementById('OPCardType');
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		loadCardType();
		obj.onchange = OPCardType_OnChange;
	}

	var obj = document.getElementById('opcardno');
	if (obj) {
		obj.onkeydown = CardNoKeydownHandler;
	}
	var obj = document.getElementById('BtnPreInsu');
	if (obj) {
		obj.onclick = BtnPrtInsu_Click;
	}
	var obj = document.getElementById('Audit');
	if (obj) {
		obj.onclick = Audit_Click;
	}
	var obj = document.getElementById('Caudit');
	if (obj) {
		obj.onclick = Caudit_Click;
	}
	var obj = document.getElementById('Refuse');
	if (obj) {
		obj.onclick = Refuse_Click;
	}
	var CheckOrderFeeobj = document.getElementById('CheckOrderFee');
	if (CheckOrderFeeobj) {
		CheckOrderFeeobj.onclick = CheckOrderFee;
	}
	/*
	if (papnoobj.value != ""){
		p1 = papnoobj.value;
		var encmeth = DHCWebD_GetObjValue("getregno");
		if (cspRunServerMethod(encmeth,'setpat_val','',p1,"")=='1'){}
	}
	*/
	var billflag = DHCWebD_GetObjValue("billflagornot");
	if (billflag == "") {
		DHCWebD_SetObjValueB("billflagornot", 1);
		bill();
	}
	websys_setfocus('RegNo');
	iniBgColor();
	initDoc();
}

///Lid
///2015-03-24
///根据门诊、住院类型初始化界面元素
function initDoc() {
	var patTypeObj = document.getElementById('PatType');
	if ((patTypeObj) && (patTypeObj.value == "O")) {
		//查门诊医嘱费用时，隐藏以下元素;
		var displayItmAry = ['Bill', 'BtnConfirm', 'btnDepositView', 'BtnPreInsu', 'Clear', 'printdetail'];
		//setItemDisplay(displayItmAry, "none");
		setItemVisibility(displayItmAry, 'hidden');
		var lookupAry = ['RegNo', 'EpisodeID'];
		setHiddenLookup(lookupAry);
	} else {
		//默认是住院
	}
}

///禁用放到镜
function setHiddenLookup(s) {
	if (s == "") {
		return;
	}
	//获取组件ID
	var compId = tkMakeServerCall("websys.Component", "GetIdFromCodeOrDescription", "DHCIPBillOrdCheck");
	if (typeof(s) == "string") {
		//字符串
		var imgId = "ld" + compId + "i" + s;
		var imgObj = document.getElementById(imgId);
		if (imgObj) {
			imgObj.style.visibility = 'hidden';
		}
		var o = document.getElementById(s);
		if (o) {
			o.readOnly = true;
		}
	} else if (Object.prototype.toString.call(s) == '[object Array]') {
		//数组
		for (var i = 0; i < s.length; i++) {
			var imgId = "ld" + compId + "i" + s[i];
			var imgObj = document.getElementById(imgId);
			if (imgObj) {
				imgObj.style.visibility = 'hidden';
			}
			var o = document.getElementById(s[i]);
			if (o) {
				o.readOnly = true;
			}
		}
	} else {}
}

function setItemDisplay(s, v) {
	if (s == "") {
		return;
	}
	if (typeof(s) == "string") {
		//字符串
		var o = document.getElementById(s);
		if (o) {
			o.style.display = v;
		}
	} else if (Object.prototype.toString.call(s) == '[object Array]') {
		//数组
		for (var i = 0; i < s.length; i++) {
			var o = document.getElementById(s[i]);
			if (o) {
				o.style.display = v;
			}
		}
	} else {}
}

function setItemVisibility(s, v) {
	if (s == "") {
		return;
	}
	if (typeof(s) == "string") {
		//字符串
		var o = document.getElementById(s);
		if (o) {
			o.style.visibility = v;
		}
	} else if (Object.prototype.toString.call(s) == '[object Array]') {
		//数组
		for (var i = 0; i < s.length; i++) {
			var o = document.getElementById(s[i]);
			if (o) {
				o.style.visibility = v;
			}
		}
	} else {}
}

function Audit_Click() {
	UpdateConfrimStatus("C", "")
}

function Caudit_Click() {
	UpdateConfrimStatus("R", "")
}

function Refuse_Click() {
	var reason = DHCWebD_GetObjValue("Reason");
	UpdateConfrimStatus("D", reason);
}

function UpdateConfrimStatus(status, reason) {
	var Ordstr = OrdSite.join("^");
	var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "ConfirmOrder", session['LOGON.USERID'], Ordstr, "", status, reason);
	var ReturnVal = rtn.split("^");
	var DrugUnAudit = ReturnVal[1];
	if (DrugUnAudit > 0) {
		alert("有出院带药未审核,出院带药不允许审核.");
		return;
	}
	if (ReturnVal[0] == 'UserNull') {
		alert("操作员不能为空");
		return;
	} else if (ReturnVal[0] == 'jobNull') {
		alert("进程号不能为空");
		return;
	} else if (ReturnVal[0] == '0') {
		alert("审核成功");
	} else {
		alert("审核失败");
	}
}

function Find() {
	Find_click();
}

function getnotpaidfun() {
	if (notpaidobj.checked == true) {
		getnotpaidobj.value = "0";
	} else {
		getnotpaidobj.value = "1";
	}
}

function getseldatefun() {
	if (selectdateobj.checked == true) {
		getseldateobj.value = "1";
	} else {
		getseldateobj.value = "0";
	}
}

function clearordcatid() {
	DHCWebD_SetObjValueB("getordcatid", "");
}

function clearorderid() {
	DHCWebD_SetObjValueB("getorderid", "");
}

function clearreclocid() {
	DHCWebD_SetObjValueB("getreclocid", "");
}

function cleardoclocid() {
	DHCWebD_SetObjValueB("getdoclocid", "");
}

function clearall() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdCheck";
	notpaidobj.checked = true;
}

function bill() {
	if (admobj.value == "") {
		alert("请选择病人就诊信息");
		return;
	}
	Adm = admobj.value;
	if (Adm && Adm != "") {
		var billedflag = tkMakeServerCall("web.UDHCJFORDCHK", "GetBilledByAdm", Adm);
		if (billedflag == "Y") {
			alert("已做财务结算,账单锁定");
			return;
		}
		var WshNetwork = new ActiveXObject("WScript.NetWork");
		var computername = WshNetwork.ComputerName;
		p1 = Adm;
		var encmeth = DHCWebD_GetObjValue("getmotheradm");
		if (cspRunServerMethod(encmeth, p1) == 'true') {
			alert(t['03']);
			return;
		}
		p2 = Guser;
		p3 = "";
		p4 = computername;
		var encmeth = DHCWebD_GetObjValue("getbill");
		var num = cspRunServerMethod(encmeth, '', '', p1, p2, p3, p4);
		if (num == "AdmNull") {
			alert("就诊号不能为空.");
			return;
		}
		if (num == "PBNull") {
			alert("账单号为空,账单失败.");
			return;
		}
		if (num == "OrdNull") {
			alert("病人没有医嘱,账单失败.");
			return;
		}
		if (num == '0') {
			alert("账单成功.");
		}
		if (num == '2') {
			alert("同时存在两个未付账单,不允许做账单.");
			return;
		}
		if (num != '0') {
			alert("账单失败.");
			return;
		}
		Find_click();
		//window.location.reload();
		if (papnoobj.value != "") {
			p1 = papnoobj.value;
			var encmeth = DHCWebD_GetObjValue("getregno");
			if (cspRunServerMethod(encmeth, 'setpat_val', '', p1) == '1') {};
		}
	}
}

function getpat() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		if ((papnoobj.value != "") || (PatMedicareObj.value != "")) {
			p1 = papnoobj.value;
			var PatMedicare = DHCWebD_GetObjValue("PatMedicare"); //yyx 2009-06-17
			var encmeth = DHCWebD_GetObjValue("getregno");
			if (cspRunServerMethod(encmeth, 'setpat_val', '', p1, PatMedicare) == "") {
				alert("此病人信息不存在.");
			}
		}
		Find_click();

		var patTypeObj = document.getElementById('PatType');
		if ((patTypeObj) && (patTypeObj.value == "O")) {
			//门诊
		} else {
			//住院
			//bill();
			parent.frames['DHCIPBillOrdexcDetails1'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdexcDetails1&Oeordrowid=" + "";
			parent.frames['DHCIPBillOrdItem'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdItem&PatBillOrd=" + "";
		}
	}
}

function setpat_val(value) {
	var val = value.split("^");
	papnoobj.value = val[0];
	nameobj.value = val[1];
	admobj.value = val[2];
	Adm = admobj.value;
	depositobj.value = val[3];
	amountobj.value = val[4];
	balanceobj.value = val[5];
	PatMedicareObj.value = val[6];
	DHCWebD_SetObjValueB("PatFeeInsu", val[10]);
	DHCWebD_SetObjValueB("DisAmt", val[11]);
	DHCWebD_SetObjValueB("PayorShare", val[12]);
	DHCWebD_SetObjValueB("PatShare", val[13]);
	DHCWebD_SetObjValueB("EncryptLevel", val[15]);
	DHCWebD_SetObjValueB("PatLevel", val[16]);
	//取医保押金自费押金医保费用自费费用医保余额自付余额
	//GetPatDepositFeeInfo(Adm);
}

function getpayinfo() {
	if (admobj.value == "") {
		return;
	}
	p1 = admobj.value;
	var patType = DHCWebD_GetObjValue("PatType");
	var encmeth = DHCWebD_GetObjValue("getpayinfo");
	if (cspRunServerMethod(encmeth, 'setpayinfo', '', p1, patType) == '1') {};
}

function setpayinfo(value) {
	var val = value.split("^");
	depositobj.value = val[0];
	amountobj.value = val[1];
	balanceobj.value = val[2];
	DHCWebD_SetObjValueB("PatFeeInsu", val[3]);
	DHCWebD_SetObjValueB("DisAmt", val[4]);
	DHCWebD_SetObjValueB("PayorShare", val[5]);
	DHCWebD_SetObjValueB("PatShare", val[6]);
	DHCWebD_SetObjValueB("EncryptLevel", val[7]);
	DHCWebD_SetObjValueB("PatLevel", val[8]);
	DHCWebD_SetObjValueB("AdmWarrantSum", val[9]);
}

function getordcatid(value) {
	var val = value.split("^");
	DHCWebD_SetObjValueB("getordcatid", val[1]);
}

function getorderid(value) {
	var val = value.split("^");
	DHCWebD_SetObjValueB("getorderid", val[1]);
}

function getreclocid(value) {
	var val = value.split("^");
	DHCWebD_SetObjValueB("getreclocid", val[1]);
}

function getdoclocid(value) {
	var val = value.split("^");
	DHCWebD_SetObjValueB("getdoclocid", val[1]);
}

function Print() {
	if (admobj.value == "") {
		alert("请选择病人就诊信息");
		return;
	}
	Adm = admobj.value;
	var encmeth = DHCWebD_GetObjValue("getbillnum");
	var str = cspRunServerMethod(encmeth, Adm);
	str = str.split("^");
	num = str[0];
	var BillNo = str[1];
	var AdmType = str[3];
	if (AdmType != "I") {
		alert("此病人为门诊病人,不能打印费用明细单.");
		return;
	}
	var iHeight = 650;
	var iWidth = 1200;
	var lnk = "";
	if (num == 1) {
		if (BillNo == "") {
			alert("BillNo is Null");
			return;
		}
		lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + BillNo;
	} else {
		iHeight = 520;
		iWidth = 780;
		lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPatBill&Adm=' + Adm;
	}
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置
	websys_createWindow(lnk, "_blank", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=" + iTop + ",left=" + iLeft + ",width=" + iWidth + ",height=" + iHeight);
}

function selstatusfun() {
	if (selstatusobj.checked == true) {
		getstatusobj.value = "0";
	} else {
		getstatusobj.value = "1";
	}
}

function PrtOrdDetail_click() {
	var Objtbl = document.getElementById('tDHCIPBillOrdCheck');
	var Rows = Objtbl.rows.length;
	if (eval(Rows) < 3) {
		return;
	}
	var job = DHCWeb_GetColumnData("Tjob", 1);
	var encmeth = DHCWebD_GetObjValue("GetPrtDetailNum");
	var PrtOrdDetailNum = cspRunServerMethod(encmeth, job);
	PrtOrdDetail(job, PrtOrdDetailNum);
}

function UnloadHandler() {
	var Objtbl = document.getElementById('tDHCIPBillOrdCheck');
	var Rows = Objtbl.rows.length;
	if (eval(Rows) < 3) {
		return;
	}
	var job = DHCWeb_GetColumnData("Tjob", 1);
	var encmeth = DHCWebD_GetObjValue("KillTMPGlobe");
	var mytmp = cspRunServerMethod(encmeth, job);
}

function ListPrtOrdDetail(job, PrtNum) {
	var encmeth = DHCWebD_GetObjValue("GetPrtOrdDetail");
	var PrtDetailInfo = cspRunServerMethod(encmeth, job, PrtNum);
	return PrtDetailInfo;
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue("getpath");
	path = cspRunServerMethod(encmeth, '', '');
}

///Lid
///2009-05-25
///医嘱数量调整事件
function link_upqty() {
	Adm = admobj.value;
	if (Adm == "") {
		alert(t['07']);
		return;
	}
	if (qty == "0") {
		alert(t['05']);
		return;
	}
	if (eval(qty) < 0) {
		alert(t['06']);
		return;
	}
	if (Tbillno == "0") {
		alert(t['04']);
		return;
	}
	if (Tbillno == "") {
		alert(t['04']);
		return;
	}
	if (Tbillstatus == "P") {
		alert(t['09']);
		return;
	}
	if (ordname.indexOf(t['ahsl01']) != -1) {
		alert(t['ahsl02']);
		return;
	}

	var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdQtyUp&billno=' + Tbillno + '&oeid=' + ordid + '&Adm=' + Adm + '&orddate=' + execdate + '&prenum=' + qty + '&order=' + ordname;
	window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=200,left=200,top=200');
}

//yyx 2009-11-02 读卡
function getpatinfo1() {
	if ((papnoobj.value != "") || (PatMedicareObj.value != "")) {
		p1 = papnoobj.value;
		var PatMedicare = DHCWebD_GetObjValue("PatMedicare");   //yyx 2009-06-17
		p2 = getnotpaidobj.value;
		var encmeth = DHCWebD_GetObjValue("getregno");
		if (cspRunServerMethod(encmeth, 'setpat_val', '', p1, PatMedicare) == '1') {};
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	var myOeordrowid = DHCWeb_GetColumnData('Tordrowid', selectrow);
	myOeordrowid = myOeordrowid.Trim();
	if (myOeordrowid != "") {
		parent.frames['DHCIPBillOrdexcDetails1'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdexcDetails1&Oeordrowid=" + myOeordrowid;
		parent.frames['DHCIPBillOrdItem'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdItem&PatBillOrd=" + "";
		var SelRowObj = document.getElementById('TSelz' + selectrow);
		if (SelRowObj) {
			if (SelRowObj.checked) {
				var unconfnum = DHCWeb_GetColumnData("Tundonum", selectrow);
				if ((unconfnum == "") || (unconfnum == 0)) {
					return;
				}
				if ((OrdList[myOeordrowid] == "0") || (OrdList[myOeordrowid] == "") || (OrdList[myOeordrowid] == undefined)) {
					len = OrdSite.length;
					OrdList[myOeordrowid] = len;
					OrdSite[len] = myOeordrowid;
				}
			} else {
				if ((OrdList[myOeordrowid] != "0") && (OrdList[myOeordrowid] != "") && (OrdList[myOeordrowid] != undefined)) {
					sitecode = OrdList[myOeordrowid];
					OrdList[myOeordrowid] = "";
					len = OrdSite.length - 1;
					if (sitecode < len) {
						OldId = OrdSite[len];
						OrdSite[sitecode] = OldId;
						OrdList[OldId] = sitecode;
					}
					OrdSite.pop();
				}
			}
		}
		//Lid 2015-01-26 不明白什么意思，先注释
		/*
		else{
			alert("所选行非明细行");
			return;
		}
		*/
	}
}

function iniBgColor() {
	var tableObj = document.getElementById('tDHCIPBillOrdCheck');
	var rowNum = tableObj.rows.length;
	for (var i = 1; i < rowNum; i++) {
		var TNotBillNum = DHCWeb_GetColumnData("TNotBillNum", i);
		if (TNotBillNum > 0) {
			document.getElementById('Torderz' + i).style.color = "Red";
			//tableObj.rows[i].cells[21].className = "Red";
		}
	}
}

function LookUppapno(str) {
	var myAry = str.split("^");
	DHCWebD_SetObjValueB("RegNo", myAry[0]);
	getpat();
}

//查看预交金
function depositView_onclick() {
	var Adm = DHCWebD_GetObjValue("EpisodeID");
	if (Adm == "") {
		alert("病人就诊号不能为空.");
		return;
	}
	var iHeight = 520;
	var iWidth = 900;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&Adm=' + Adm + '&deposittype=' + "";
	websys_createWindow(lnk, "_blank", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=" + iTop + ",left=" + iLeft + ",width=" + iWidth + ",height=" + iHeight);
}

function BtnPrtInsu_Click() {
	var Adm = DHCWebD_GetObjValue("EpisodeID");
	var encmeth = DHCWebD_GetObjValue("getbillnum");
	var str = cspRunServerMethod(encmeth, Adm);
	str = str.split("^");
	var billnum = str[0];
	var BillNo = str[1];
	if (billnum == 0) {
		alert("病人没有账单，不能预结算");
		return;
	}
	if (billnum == 1) {
		if (BillNo == "") {
			return;
		}
		var ReaInfo = tkMakeServerCall("web.UDHCJFORDCHK", "GetAdmReaInfo", Adm);
		if (ReaInfo == "") {
			return;
		}
		var ReaInfo1 = ReaInfo.split("^");
		var AdmReasonNationCode = ReaInfo1[1];
		var AdmReasonId = ReaInfo1[0];
		if ((AdmReasonNationCode != "") && (AdmReasonNationCode != "0")) {
			var Ret = InsuIPDividePre("0", Guser, BillNo, AdmReasonNationCode, AdmReasonId, "");
		} else {
			alert("非医保病人不能医保预结算");
		}
	} else {
		alert("病人有两个未结算的账单,不允许医保预结算,请撤消中途结算.");
	}
}

//2015-08-12 zhuangna 医嘱费用核对 st
function CheckOrderFee() {
	if (admobj.value == "") {
		alert("请选择病人就诊信息");
		return;
	}
	Adm = admobj.value;
	var encmeth = DHCWebD_GetObjValue("getbillnum");
	var str = cspRunServerMethod(encmeth, Adm);
	str = str.split("^");
	num = str[0];
	var AdmType = str[3];
	if (AdmType != "I") {
		alert("此病人为门诊病人,不需要费用核对.");
		return;
	}
	var BillNo = str[1];

	var iHeight = 650;
	var iWidth = 1200;
	var lnk = "";
	if (num == 1) {
		if (BillNo == "") {
			alert("BillNo is Null");
			return;
		}
		lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetailOrder&BillNo=' + BillNo + '&EpisodeID=' + Adm;
	} else {
		iHeight = 520;
		iWidth = 780;
		lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPatBill&Adm=' + Adm;
	}
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置
	websys_createWindow(lnk, "_blank", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=" + iTop + ",left=" + iLeft + ",width=" + iWidth + ",height=" + iHeight);
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = UnloadHandler;
