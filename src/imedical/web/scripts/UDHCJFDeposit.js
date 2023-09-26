/// UDHCJFDeposit.js

var SelectedRow = -1;
var Adm, Guser, CurNo, EndNo, Title, UserLoc, LocDesc, UserGrp;
var returnval, path;
var gusername, PrtFlag;
var curyear, curmon, curday;
var gusercode;
var payamt;
var Prtrowid = "", Arpbl, PrtStatus, RcptRowid, JkFlag, rcptno;
var Objtbl, Rows, Sum, i, status, select;
var gusername;
var curyear, curmon, curday, path;
var deptypeobj, pyobj, bankobj;
var company, bank, cardno, authno, patadmdate; //yyx 2006-11-08
var AbortClickFlag;
var subyjinfor;
var m_Hospital;
var m_RequiredFlag = 'N';
var m_AutoFlag = "";  //zhho
var m_ReRcptNo = "";    //zhho
var m_IBPRowId = "";

function BodyLoadHandler() {
	//var teststr = readFile();
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readcard_click;
	}
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFDeposit");
	var obj = document.getElementById('OPCardType');
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		loadCardType();
		obj.onchange = OPCardType_OnChange;
	}

	gettoday();
	getzyjfconfig();
	PrtFlag = "N";
	AbortClickFlag = "N";
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
	Guser = session['LOGON.USERID'];
	UserLoc = session['LOGON.CTLOCID'];
	gusercode = session['LOGON.USERCODE'];
	LocDesc = session['LOGON.GROUPDESC'];
	UserGrp = session['LOGON.GROUPID'];
	m_Hospital = session['LOGON.HOSPID'];
	document.getElementById('UserGrp').value = UserGrp;
	CurNo = "";
	var papobj = document.getElementById('papno');
	var papno = papobj.value;
	papobj.onkeydown = getpapno;
	Adm = document.getElementById('Adm').value;
	if ((papno == "") && (Adm != "")) {
		var encmeth = DHCWebD_GetObjValue('getinfro');
		if (cspRunServerMethod(encmeth, 'set_pat', '', Adm, t['HXEY03']) == '1') {}
	}
	var encmeth = DHCWebD_GetObjValue('getpayinfo');
	if (cspRunServerMethod(encmeth, 'payinfo', '', Adm) == '1') {}

	deptypeobj = document.getElementById('deposittype');
	pyobj = document.getElementById('paymode');
	bankobj = document.getElementById('bank');
	var authnoobj = document.getElementById('authno');
	deptypeobj.onkeydown = getdeptype;
	pyobj.onkeydown = getpy;
	bankobj.onkeydown = getbank;
	authnoobj.onkeydown = enterauthno;
	///取安全组默认的押金类型
	var encmeth = DHCWebD_GetObjValue('GetDefaultDepType');
	deptypeobj.value = cspRunServerMethod(encmeth, UserGrp);
	var deposittype = deptypeobj.value;
	if (deposittype == "") {
		deposittype = t['09'];
		deptypeobj.value = deposittype;
	}
	var encmeth = DHCWebD_GetObjValue('gettyperowid');
	var tmp = cspRunServerMethod(encmeth, '', '', deposittype);
	document.getElementById('deptype').value = tmp;
	document.getElementById('paymode').value = t['10'];

	var encmeth = DHCWebD_GetObjValue('getpaymodeid');
	var tmp1 = cspRunServerMethod(encmeth, '', '');
	document.getElementById('moderowid').value = tmp1;
	document.getElementById('deposittype').readOnly = false;
	document.getElementById('currentno').readOnly = true;

	GetCurRcptNo();

	var obj = document.getElementById("BtnPrint");
	if (obj) {
		obj.onclick = Add_click;
	}
	var obj = document.getElementById("BPrtDeposit");
	if (obj) {
		obj.onclick = BPrtDeposit_click;
	}
	var obj = document.getElementById("Return");
	if (obj) {
		obj.onclick = Return_click;
	}
	if (Adm != "") {
		var encmeth = DHCWebD_GetObjValue('GetInsu');
		if (cspRunServerMethod(encmeth, Adm) == '') {
			alert(t['11']);
		}
	}
	/*
	退押金功能不在此界面实现,改在 UDHCJFRefundDeposit 中实现
	var obj = document.getElementById("RefundDeposit");
	if (obj) {
	obj.onclick = Refund_click;
	}
	 */
	var obj = document.getElementById("AbortDeposit");
	if (obj) {
		obj.onclick = Abort_click;
	}
	//GetSum();
	var payamtobj = document.getElementById("payamt");
	if (payamtobj) {
		payamtobj.onkeydown = enterpayamt;
		//+2018-02-23 ZhYW
		payamtobj.onkeypress = payAmt_KeyPress;
	}
	var compobj = document.getElementById("company");
	compobj.onkeydown = entercomp;
	var bksubobj = document.getElementById("banksub");
	bksubobj.onkeydown = enterbksub;
	var cardnoobj = document.getElementById("cardno");
	cardnoobj.onkeydown = entercardno;
	//+2016-12-16 ZhYW 跳号
	var voidInvNoObj = document.getElementById("voidInvNo");
	if (voidInvNoObj) {
		voidInvNoObj.onclick = altVoidInv;
	}
	//zhho
	var obj = document.getElementById("BtnAutoDeposit");
	if(obj) {
		obj.onclick = BPrtAutoDep_Click;
	}
	//
	elementformat();
	InitDocument(Adm);
	websys_setfocus('payamt');
	document.onkeydown = FrameEnterkeyCode;

}
function payinfo(value) {
	var str = value.split("^");
	document.getElementById('sum').value = str[0];
	document.getElementById('patfee').value = str[1];
	document.getElementById('patremain').value = str[2];
}

function gettoday() {
	var encmeth = DHCWebD_GetObjValue('gettoday');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	date = value.split("/");
	curday = date[0];
	curmon = date[1];
	curyear = date[2];
}

function getpapno() {
	var key = websys_getKey(e);
	if (key == 13) {
		var papobj = document.getElementById('papno');
		var papno = papobj.value;
		if (papno != "") {
			DHCWebD_SetObjValueB("Adm", "");
			Adm = "";
			if (Adm == "") {
				var encmeth = DHCWebD_GetObjValue('getadm');
				var str = cspRunServerMethod(encmeth, "", "", papno);
				if (str != "") {
					var str1 = str.split("^");
					papobj.value = str1[0];
					Adm = str1[1];
					DHCWebD_SetObjValueB("Adm", str1[1]);
					if (Adm != "") {
						var encmeth = DHCWebD_GetObjValue('getinfro');
						if (cspRunServerMethod(encmeth, 'set_pat', '', Adm, t['HXEY03']) == '1') {
						}
					} else {
						alert(t['HXEY02']);
						return;
					}
				} else {
					alert(t['HXEY02']);
					return;
				}
			} else {
				alert(t['HXEY01']);
				return;
			}
		}
		window.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=" + Adm;
	}
}

function Add_click() {
	if (Adm == "") {
		alert(t['32']);
		websys_setfocus('papno');
		return;
	}
	var encmeth = DHCWebD_GetObjValue('GetBillFlag');
	var str = cspRunServerMethod(encmeth, Adm);
	if (str == "Y") {
		alert(t['33']);
		return;
	}
	selectrow = SelectedRow;
	var encmeth = DHCWebD_GetObjValue('GetInsu');
	if (cspRunServerMethod(encmeth, Adm) == '') {
		alert(t['11']);
	}
	if (PrtFlag == "Y") {
		alert(t['01']);
		return;
	}
	var deptype = document.getElementById('deptype').value;
	if (deptype == "") {
		alert(t['02']);
		return;
	}
	//add by wangjian 2014-12-01
	if (!checkpayamt()) {
		alert("请输入两位小数以内的数字");
		websys_setfocus('payamt');
		return;
	}
	//end
	var payamt = DHCWebD_GetObjValue('payamt');
	payamt = websys_trim(payamt);
	if ((payamt == "") || (!payamt)) {
		alert(t['03']);
		websys_setfocus('payamt');
		return;
	}
	if (eval(payamt) <= 0) {
		alert("输入金额错误,不允许输入负金额.");
		return;
	}
	var moderowid = DHCWebD_GetObjValue('moderowid');
	if (moderowid == "") {
		websys_setfocus('paymode');
		alert(t['04']);
		return;
	}
	if (CurNo == "") {
		alert(t['05']);
		return;
	}
	var bankDesc = bankobj.value;
	if ((m_RequiredFlag == "Y") && (bankDesc == "")) {
		alert("请选择银行.");
		return;
	}
	if (AbortClickFlag == "Y") {
		var truthBeTold = "true";
	} else {
		var truthBeTold = window.confirm(t['jst08']);
	}
	AbortClickFlag = "N";
	if (!truthBeTold) {
		return;
	}
	company = document.getElementById('company').value;
	bank = document.getElementById('bankrowid').value;
	cardno = document.getElementById('cardno').value;
	authno = document.getElementById('authno').value;
	var banksubobj = document.getElementById('banksub');
	var banksub = banksubobj.value;
	var comment = document.getElementById('comment').value;
	var pass = document.getElementById('password').checked;
	if (pass == true) {
		pass = "Y";
	} else {
		pass = "";
	}
	var rcptrowidobj = document.getElementById('rcptrowid');
	var receiptrowid = rcptrowidobj.value;
	var deposittype = deptypeobj.value;
	var transferflag = ""; //add by zhl 20111024  xh
	var Transobj = document.getElementById('transferflag');
	if (Transobj) {
		transferflag = Transobj.value;
	}
	/*
	var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^^^^C";
	var payCenterRtn = PayService("DEP", moderowid, payamt, expStr);
	if (payCenterRtn.returnCode != 0) {
		alert("支付失败" + payCenterRtn.returnMsg);
		return;
	}else {
		m_IBPRowId = payCenterRtn.IBPRowid;
	}
	*/
	var encmeth = DHCWebD_GetObjValue('Add');
	dep = deptype + "^" + payamt + "^" + moderowid + "^" + company + "^" + bank + "^" + cardno + "^" + authno + "^" + Adm + "^" + CurNo + "^" + UserLoc + "^" + Guser + "^" + EndNo + "^" + Title + "^" + banksub + "^" + comment + "^" + pass + "^" + receiptrowid + "^" + transferflag + "^" + m_Hospital;
	var Error = cspRunServerMethod(encmeth, 'SetPidAdd', '', dep);
	if (Error == '-2') {
		alert("此收据号已经使用过,请刷新界面.");
		return;
	} else if (Error == '-3') {
		alert("病人已退院,不允许交押金.");
		return;
	} else if (Error == '-3') {
		alert("病人已退院,不允许交押金.");
		return;
	} else if (Error == '-4') {
		alert("没有可用收据号,请核实.");
		return;
	} else if (Error == '-5') {
		alert("收据号与系统实际收据号不符,请核实.");
		return;
	} else if (Error != 0) {
		alert("交押金失败,错误代码：" + Error);
		return;
	} else {}

}

function set_pat(value) {
	var sub = value.split("^");
	var papnoobj = document.getElementById('papno');
	papnoobj.value = sub[0];
	var nameobj = document.getElementById('name');
	nameobj.value = sub[1];
	document.getElementById('pattype').value = sub[2];
	document.getElementById('pataddress').value = sub[3];
	document.getElementById('patzyno').value = sub[4];
	document.getElementById('admdate').value = sub[5];
	document.getElementById('foreignid').value = sub[6];
	document.getElementById('foreignphone').value = sub[7];
	document.getElementById('workaddress').value = sub[8];
	document.getElementById('deptdesc').value = sub[9];
	document.getElementById('warddesc').value = sub[10];
	document.getElementById('bedno').value = sub[11];
	document.getElementById('diagnos').value = sub[12];
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.value = sub[13];
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.value = sub[14];
	}
}

function GetCurRcptNo() {
	var deposittype = deptypeobj.value;
	var encmeth = DHCWebD_GetObjValue('getrcptno');
	if (cspRunServerMethod(encmeth, 'GetRcptNo', '', Guser, deposittype) == '0') {
	}
	/*
	if (CurNo == ""){
		alert(t['depttype03']);
		return;
	}
	*/
}

function GetRcptNo(value) {
	var sub = value.split("^");
	var receiptrowid = sub[0];
	var obj = document.getElementById('currentno');
	if (receiptrowid == "") {
		obj.value = "";
		alert(t['05']);
		return;
	}
	EndNo = sub[1];
	CurNo = sub[2];
	Title = sub[3];
	obj.value = CurNo;
	var rcptrowidobj = document.getElementById('rcptrowid');
	rcptrowidobj.value = sub[0];
}

function SetPidAdd(value) {
	var sub;
	var amt;
	var str = value.split("^"); ;
	var retcode = str[0];
	var yjrowid = str[1];
	var receiptrowid = str[2];
	if ((retcode != "0") && (retcode != "100")) {
		alert(t['06']);
		return;
	}
	if ((retcode == "0") || (retcode == "100")) {
		/*
		//用于第三方支付接口保存信息
		if (m_IBPRowId != ""){
			var linkRtn = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "RelationOrderToHIS", m_IBPRowId, yjrowid);
		}
		//
		*/
		PrtFlag = "Y";
		var encmeth = DHCWebD_GetObjValue('getyjdetail');
		returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
		subyjinfor = returnval.split("^");
		var depttypedesc = subyjinfor[25];
		if (depttypedesc == t['depttype01']) {
			window.location.reload();
			return;
		}
		printYJ("", "");
		/*
		var truthBeTold = window.confirm(t['anh01']);
		if (!truthBeTold) {
			abort(yjrowid,receiptrowid)
		}
		*/
		window.location.reload();
	}
}

function Return_click() {
	parent.close();
}

function LookUpType(str) {
	var tem = str.split("^");
	DHCWebD_SetObjValueB('deptype', tem[1]);
	GetCurRcptNo();
}

function LookUpPayMode(str) {
	var tem = str.split("^");
	DHCWebD_SetObjValueB('moderowid', tem[1]);
	m_RequiredFlag = tem[2];
	elementformat();
}

function LookUpBank(str) {
	var tem = str.split("^");
	DHCWebD_SetObjValueB('bankrowid', tem[1]);
	elementformat(); //add xubaobao 2017 02 15
}

function getamt() {
	var key = websys_getKey(e);
	if (key == 13) {
		var payamt = document.getElementById('payamt').value;
		if (payamt != "") {
			var ss = payamt;
			ss = eval(ss);
			payamt.value = ss.toFixed(2);
			if (pyobj.value == t['10']) {
				websys_setfocus('BtnPrint');
			} else {
				DHCWeb_Nextfocus();
			}
		}
	}
}

/*
//退押金功能不在此界面实现,改在 UDHCJFRefundDeposit 中实现
function Refund_click() {
	selectrow = SelectedRow;
	var truthBeTold = window.confirm(t['12']);
	if (!truthBeTold) {
		return;
	}
	if (!Prtrowid) {
		alert(t['13']);
		return;
	}
	if (Arpbl) {
		alert(t['14']);
		return;
	}
	if (PrtStatus == t['15']) {
		alert(t['16']);
		return;
	}
	if (PrtStatus == t['17']) {
		alert(t['18']);
		return false;
	}
	if (PrtStatus == t['19']) {
		alert(t['20']);
		return false;
	}
	var encmeth = DHCWebD_GetObjValue('getprtstatus');
	if (cspRunServerMethod(encmeth, Prtrowid) == '4') {
		alert(t['27']);
		return;
	}
	if (RefYjFlag == "N") {
		GetCurRcptNo();
	}
	if (RefYjPrtFlag == "N") {
		rcptno = "";
		CurNo = "";
		EndNo = "";
	}
	if (RefYjPrtFlag == "Y") {
		if (CurNo == "") {
			alert(t['05']);
			return;
		}
		var encmeth = DHCWebD_GetObjValue('getnextno');
		if (cspRunServerMethod(encmeth, 'GetNextNo', '', CurNo) == '0') {}
		var encmeth = DHCWebD_GetObjValue('Refund');
		if (cspRunServerMethod(encmeth, 'SetPid', '', CurNo, EndNo, Prtrowid, Guser, RcptRowid, RefYjPrtFlag) == '0') {}
	}else {
		abort(Prtrowid, RcptRowid);
	}
}

function SetPid(value) {
	var str = value.split("^");
	var retcode = str[0];
	var yjrowid = str[1];

	if (retcode != "0") {
		alert(t['21']);
		return;
	}
	try {
		alert(t['07']);
		if (RefYjPrtFlag == "Y") {
			var encmeth = DHCWebD_GetObjValue('getyjdetail');
			var patinfo = cspRunServerMethod(encmeth, '', '', yjrowid);
			gusername = session['LOGON.USERNAME'];
			gusercode = session['LOGON.USERCODE'];
			returnval = patinfo;
			printYJ();
		}
		window.location.reload();
		//parent.frames['UDHCJFFindDeposit'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&Adm="+Adm;
		//parent.frames['UDHCJFAddDeposit'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFAddDeposit&Adm="+Adm;
	} catch (e) {
	}
}
*/

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tUDHCJFDeposit');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (selectrow != SelectedRow) {
		Prtrowid = DHCWeb_GetColumnData('Tprtrowid', selectrow);
		DHCWebD_SetObjValueB('Prtrowid', Prtrowid);
		Arpbl = DHCWeb_GetColumnData('Tarpbl', selectrow);
		Arpbl = websys_trim(Arpbl);
		PrtStatus = DHCWeb_GetColumnData('Tprtstatus', selectrow);
		RcptRowid = DHCWeb_GetColumnData('Trcptrowid', selectrow);
		JkFlag = DHCWeb_GetColumnData('Tjkflag', selectrow);
		rcptno = DHCWeb_GetColumnData('Trcptno', selectrow);
		
		m_AutoFlag = DHCWeb_GetColumnData('TAutoFlag', selectrow);    //zhho
		m_ReRcptNo = DHCWeb_GetColumnData('TReRcptNo', selectrow);       //zhho
		m_ReRcptNo = websys_trim(m_ReRcptNo);
		SelectedRow = selectrow;
	} else {
		Prtrowid = "";
		Arpbl = "";
		PrtStatus = "";
		RcptRowid = "";
		JkFlag = "";
		rcptno = "";
		m_AutoFlag = "";
		m_ReRcptNo = "";
		SelectedRow = -1;
	}
}

function GetNextNo(value) {
	if (parseInt(value, 10) > parseInt(EndNo, 10)) {
		alert(t['07'])
		return false;
	}
}

function abort(yjrowid, rcptrowid) {
	var abortobj;
	var p1 = yjrowid;
	var p2 = rcptrowid;
	var p3 = Guser;
	var encmeth = DHCWebD_GetObjValue('Abort');
	if (cspRunServerMethod(encmeth, 'SetPid1', '', p1, p2, p3) == '0') {}
}

function SetPid1(value) {
	if (value != "0") {
		alert(t['21']);
		return;
	} else {
		if (AbortYJprtFlag == "Y") {
			PrtFlag = "N";
			AbortClickFlag = "Y";
			GetCurRcptNo();
			Add_click();
		} else {
			window.location.reload();
		}
	}
}

function Abort_click() {
	//add by 20150302 for pos
	/*
	var posFlag = tkMakeServerCall("web.DHCBillBankLogic", "CheckPayMByDepositRowID", Prtrowid);
	var payAry = posFlag.split("^");
		if(payAry[0] != "0"){
		alert("POS押金不允许作废!");
		return;
	}
	*/
	if ((Prtrowid == "") || (Prtrowid == " ")) {
		alert(t['23']);
		return false;
	}
	if (Arpbl != "") {
		alert(t['14']);
		return false;
	}
	if (JkFlag == "Y") {
		alert(t['24']);
		return false;
	}
	if (PrtStatus == t['17']) {
		alert(t['25']);
		return false;
	}
	if (PrtStatus == t['19']) {
		alert(t['29']);
		return false;
	}
	if (PrtStatus == t['26']) {
		alert(t['27'] + rcptno + t['28']);
		return false;
	}
	var encmeth = DHCWebD_GetObjValue('getabortyjdetail');
	var ayjdetail = cspRunServerMethod(encmeth, '', '', Prtrowid);
	if (ayjdetail != "") {
		var ayjdetailstr = ayjdetail.split("^");
		deptypestr = ayjdetailstr[0].split("@");
		document.getElementById('deposittype').value = deptypestr[1];
		document.getElementById('deptype').value = deptypestr[0];
		document.getElementById('payamt').value = ayjdetailstr[1];
		var modestr = ayjdetailstr[2].split("@");
		document.getElementById('paymode').value = modestr[1];
		document.getElementById('moderowid').value = modestr[0];
		var bankstr = ayjdetailstr[3].split("@");
		document.getElementById('bank').value = bankstr[1];
		document.getElementById('bankrowid').value = bankstr[0];
		document.getElementById('banksub').value = ayjdetailstr[4];
		document.getElementById('company').value = ayjdetailstr[5];
		document.getElementById('authno').value = ayjdetailstr[6];
		document.getElementById('cardno').value = ayjdetailstr[7];
		if (ayjdetailstr[8] == "Y") {
			document.getElementById('password').checked = true;
		} else {
			document.getElementById('password').checked = false;
		}
		document.getElementById('comment').value = ayjdetailstr[9];
		var addUserId = ayjdetailstr[10];
		if (addUserId != Guser) {
			alert("不能作废非本人收的押金");
			return;
		}
		var truthBeTold = window.confirm(t['22']);
		if (!truthBeTold) {
			return;
		}
		var encmeth = DHCWebD_GetObjValue('Abort');
		var rtn = cspRunServerMethod(encmeth, 'SetPid1', '', Prtrowid, RcptRowid, Guser);
		if (rtn == 0) {}
		else if (rtn = "-111") {
			alert("不能作废非本人收的押金:" + rtn);
		}
	}
}

function GetSum() {
	Sum = 0;
	Objtbl = document.getElementById('tUDHCJFDeposit');
	Rows = Objtbl.rows.length;
	Sum = 0;
	for (i = 1; i <= Rows - 1; i++) {
		SelRowObj = document.getElementById('Tprtstatusz' + i);
		prtstatus = SelRowObj.innerText;
		SelRowObj = document.getElementById('selectz' + i);
		select = SelRowObj.checked;
		SelRowObj = document.getElementById('Tpayamtz' + i);
		payamt = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tpaystatusz' + i);
		var paystatus = SelRowObj.innerText;
		if ((prtstatus != t['26']) && (select == true)) {
			Sum = eval(Sum) + eval(payamt);
		}
	}
	obj = document.getElementById('yjnum');
	obj.value = Rows - 2;
	obj = document.getElementById('sum');
	obj.value = parseFloat(Sum).toFixed(2);
}

function getdeptype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		deposittype_lookuphandler();
	}
}

function getpy() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		paymode_lookuphandler();
	}
}

function elementformat() {
	var compobj = document.getElementById("company");
	var cardnoobj = document.getElementById("cardno");
	var banksubobj = document.getElementById("banksub");
	var authnoobj = document.getElementById("authno");
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "bank";
		var bankobj1 = document.getElementById(imgname);
	}
	var paymode = DHCWebD_GetObjValue('paymode');
	var paymode = websys_trim(paymode);
	if (paymode == t['10']) {
		bankobj.value = "";
		bankobj.readOnly = true;
		compobj.readOnly = true;
		cardnoobj.readOnly = true;
		authnoobj.readOnly = true;
		banksubobj.readOnly = true;
		bankobj1.style.display = "none";
		websys_setfocus('BtnPrint');
	} else {
		bankobj.readOnly = false;
		compobj.readOnly = false;
		banksubobj.readOnly = false;
		bankobj1.style.display = "";
		cardnoobj.readOnly = false;
		authnoobj.readOnly = false;
		websys_setfocus('bank');
	}
}

function getbank() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		if (pyobj.value == "现金") {}
		else {
			bank_lookuphandler();
			DHCWeb_Nextfocus();
		}
	}
}

function entercomp(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus()
	}
}

function enterbksub(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function entercardno(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enterpayamt(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if (key == 13) {
		//add by wangjian 2014-12-01
		if (!checkpayamt()) {
			alert("请输入两位小数以内的数字");
			websys_setfocus('payamt');
			return;
		}
		//end
		DHCWeb_Nextfocus();
		var payamt = document.getElementById('payamt').value;
		//document.getElementById('payamt').value = eval(payamt).toFixed(2); //yyx
		var encmeth = DHCWebD_GetObjValue('getamtdx');
		var amtdx = cspRunServerMethod(encmeth, "", "", payamt);
		var rtnStr = amtdx.split("^");
		amtdx = rtnStr[0];
		if (amtdx == "-1") {
			alert("输入金额过大,请重新输入！");
			document.getElementById('payamt').value = "";
			return;
		}
		document.getElementById('amtdx').value = amtdx;
	}
}

function enterauthno(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus()
	}
}

function DHCWeb_Nextfocus(e) {
	if (!e) {
		var e = event ? event : (window.event ? window.event : null);
	}
	var eSrc = window.event.srcElement;
	var key = websys_getKey(e);
	if (key == 13) {
		websys_nexttab(eSrc.tabIndex);
	}
}

//原票补打功能
function BPrtDeposit_click() {
	selectrow = SelectedRow;
	var yjrowid = Prtrowid;
	if ((yjrowid == "") || (yjrowid == " ")) {
		alert("请选择要补打的押金记录")
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getyjdetail');
	returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
	if (returnval == "") {
		alert("作废押金记录不能补打!");
		return;
	}
	subyjinfor = returnval.split("^");
	printYJ("补打", "");
}

//add by wangjian 2014-12-01
//校验金额金额小数点后不能超过两位有效数字
function checkpayamt() {
	var payamtobj = document.getElementById('payamt');
	var Testrtn = false;
	if (payamtobj) {
		var pattern = /^-?\d+(\.\d{1,2})?$/; //^(-)?(([1-9]{1}\d*)|([0]{1}))(\.(\d){1,2})?$/
		var payamt = payamtobj.value;
		if (pattern.test(payamt)) {
			Testrtn = true;
		}
	}
	return Testrtn;
}

function readcard_click() {
	ReadCardClickHandler();
}

//读文件
function readFile() {
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	var f = fso.OpenTextFile("c://testfile.txt", 1);
	var s = "";
	//while (!f.AtEndOfStream)
	//while (!f.AtEndOfLine)
	//{
	s += f.ReadLine();
	//}

	f.Close();
	return s;
}

/**
 * Creator: ZhYW
 * CreatDate: 2016-12-16
 * Description: 住院押金跳号
 */
function altVoidInv() {
	var depositType = deptypeobj.value;
	var iHeight = 400;
	var iWidth = 620;
	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置
	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&receiptType=" + depositType;
	window.open(lnk, "_blank", "toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,top=" + iTop + ",left=" + iLeft + ",width=" + iWidth + ",height=" + iHeight);
}

/**
 * Creator: zhangli
 * CreatDate: 2017-08-17
 * Description: 快捷键触发方法
 */
function FrameEnterkeyCode() {
	var e = window.event;
	switch (e.keyCode) {
	case 121:
		Add_click();
		break;
	}
}

/**
 * Creator: ZhYW
 * CreatDate: 2018-02-23
 * Description: 控制只能输入数字
 */
function payAmt_KeyPress() {
	var key = event.keyCode;
	if (((key > 47) && (key < 58)) || (key == 46) || (key == 13)) {
		//如果输入金额过长导致溢出计算有误
		if (this.value.length > 11) {
			window.event.keyCode = 0;
			return websys_cancel();
		}
	} else {
		window.event.keyCode = 0;
		return websys_cancel();
	}
}

/**
 * Creator: zhli
 * CreatDate: 2018-02-27
 * Description: 最终结算是否可以交押金
 */
function InitDocument(Adm) {
	if (Adm != "") {
		var rtnStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetOutAdmInOutDateInfo", Adm);
		var dischstatus = rtnStr.split("^")[3];
		if (dischstatus == "护士办理出院") {
			if (FinalChargeCheckDepFlag == "N") { //最终结算不允许交押金
				alert("最终结算不允许交押金!");
				var obj = document.getElementById("BtnPrint");
				DHCWeb_DisBtn(obj);
				return;
			} else {
				var rtnnum = tkMakeServerCall("web.UDHCJFCOMMON", "getinfro", Adm); //财务结算不允许交押金
				if (rtnnum == "0") {
					alert("财务结算不允许交押金!");
					var obj = document.getElementById("BtnPrint");
					DHCWeb_DisBtn(obj);
					return;
				}
			}
		}
	}
}

//zhho
function BPrtAutoDep_Click() {
	var fprowid = DHCWebD_GetObjValue('rcptrowid');
	var yjrowid = Prtrowid;
    if (yjrowid == "") {
		alert("请选择要补打的押金记录");
		return;
	}
	if(m_AutoFlag == "") {
		alert("非自助押金记录,无法补打");
		return;
	}
	if(m_ReRcptNo != "") {
		alert("已补打记录,无法补打");
		return;
	}
	//走收款员票据	
	var upstr = session['LOGON.USERID'] + "^" + session['LOGON.GROUPID'] + "^" + m_ReRcptNo;
	upstr += "^" + yjrowid + "^" + CurNo + "^" + EndNo + "^" + fprowid;
	var uprtn = tkMakeServerCall("web.UDHCJFDeposit", "VoidIPINV", upstr);
	if(uprtn == "0"){
		var encmeth = DHCWebD_GetObjValue('getyjdetail');
		returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
		subyjinfor = returnval.split("^");
		printYJ("补打自助押金", "");
	}else {
		alert("请重试");
		return;
	}
}

document.body.onload = BodyLoadHandler;
