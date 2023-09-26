/// UDHCJFRefundDeposit.js

var SelectedRow = 0;
var Adm, Prtrowid, Arpbl, PrtStatus, CurNo, EndNo, Title, RcptRowid, JkFlag;
var Guser, gusername, UserLoc;
var Objtbl, Rows, Sum, payamt, i, status, select;
var returnval, path;
var regnoobj, nameobj, rcptnoobj, prtdateobj, payamtobj, paymodeobj, statusobj;
var cardnoobj, authnoobj, companyobj, bankobj, refreasonobj, refreasonidobj, refdateobj;
var reftimeobj, usernameobj;
var regno, name, datestr, timestr;
var curyear, curmon, curday;
var subyjinfor, TDepositType, BPrintObj;
var paymodedesc, deptypeobj;

function BodyLoadHandler() {
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFDeposit");
	getzyjfconfig();
	paymodedesc = "";
	gusername = session['LOGON.USERNAME'];
	gusercode = session['LOGON.USERCODE'];
	Guser = session['LOGON.USERID'];
	gusername = session['LOGON.USERNAME'];
	UserLoc = session['LOGON.CTLOCID'];
	var admobj = document.getElementById("Adm");
	Adm = admobj.value;
	regnoobj = document.getElementById('regno');
	regnoobj.readOnly = true;
	nameobj = document.getElementById('name');
	nameobj.readOnly = true;
	rcptnoobj = document.getElementById('rcptno');
	rcptnoobj.readOnly = true;
	prtdateobj = document.getElementById('prtdate');
	prtdateobj.readOnly = true;
	payamtobj = document.getElementById('payamt');
	payamtobj.readOnly = true;
	paymodeobj = document.getElementById('paymode');
	paymodeobj.readOnly = true;
	statusobj = document.getElementById('status');
	statusobj.readOnly = true;
	cardnoobj = document.getElementById('cardno');
	cardnoobj.readOnly = true;
	authnoobj = document.getElementById('authno');
	authnoobj.readOnly = true;
	companyobj = document.getElementById('company');
	companyobj.readOnly = true;
	bankobj = document.getElementById('bank');
	bankobj.readOnly = true;
	BPrintObj = document.getElementById('BPrint');
	if (BPrintObj) {
		BPrintObj.onclick = BPrint_onclick;
	}
	refreasonobj = document.getElementById('refreason');
	refreasonidobj = document.getElementById('refreasonid');
	refdateobj = document.getElementById('refdate');
	refdateobj.readOnly = true;
	reftimeobj = document.getElementById('reftime');
	reftimeobj.readOnly = true;
	usernameobj = document.getElementById('username');
	usernameobj.readOnly = true;
	var obj = document.getElementById("RefundDeposit");
	if (obj) {
		obj.onclick = Refund_click;
	}
	var obj = document.getElementById("AbortDeposit");
	if (obj) {
		obj.onclick = Abort_click;
	}
	var backObj = document.getElementById("Return");
	if (backObj) {
		backObj.onclick = Return_click;
	}
	var tabLinkFlag = DHCWebD_GetObjValue('TabLinkFlag');
	if (tabLinkFlag == 'Y') {
		backObj.style.display = 'none';  //+2018-06-05 ZhYW 通过Tabs链接过来的,隐藏返回按钮
	}
	var encmeth = DHCWebD_GetObjValue('getpatinfo');
	var patinfostr = cspRunServerMethod(encmeth, '', '', Adm);
	var patinfostr1 = patinfostr.split("^");
	regno = patinfostr1[7];
	name = patinfostr1[0];
	EncryptLevel = patinfostr1[14];
	PatLevel = patinfostr1[15];
	document.getElementById('feesum').value = patinfostr1[13]; //add by YF 20170215
	document.getElementById('Mobile').value = patinfostr1[17];
	document.getElementById('PersonID').value = patinfostr1[18];
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.value = EncryptLevel;
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.value = PatLevel;
	}
	GetSum();
	gettoday();
	setrefmode();
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
	/*
	if (RefYjPrtFlag=="Y") {
		GetCurRcptNo();
	}
	*/
	//add by xiongwang 2018-03-14
	obj = document.getElementById("TransferOP");
	if (obj) {
		obj.onclick = TransferOP_Click;
	}
	GetTransferConfig();
}

function gettoday() {
	var encmeth = DHCWebD_GetObjValue('getdatetime');
	var str = cspRunServerMethod(encmeth);
	var str1 = str.split("^");
	datestr = str1[0];
	timestr = str1[1];
	var d = datestr.split("-");
	curday = d[2];
	curmon = d[1];
	curyear = d[0];
}

function Refund_click() {
	/*
	注释掉不允许退病历押金的功能
	if (TDepositType == t['depttype01']){
		alert(t['depttype02']);
		return;
	}
	*/
	var truthBeTold = window.confirm(t['23']);
	if (!truthBeTold) {
		return;
	}
	//+2018-07-11 ZhYW 
	var rtn = tkMakeServerCall("web.DHCBillPreIPAdmTrans", "CheckRefDeposit", Adm);
	if (+rtn == 1) {
		alert('该患者的预住院医嘱存在有效医嘱,不能退押金.');
		return;
	}else if (+rtn == 2) {
		alert('该患者由预住院转入门诊的费用未结清,不能退押金.');
		return;
	};
	var paymodedesc1 = paymodeobj.value;
	var moderowidobj = document.getElementById('moderowid');
	var moderowiddesc = moderowidobj.value;
	if (UPPaymFlag == "Y") {
		if ((paymodedesc == paymodedesc1) && (moderowiddesc != "")) {
			var encmeth = DHCWebD_GetObjValue('getpaymodeid');
			var tmp1 = cspRunServerMethod(encmeth, '', '', paymodedesc);
			if (tmp1 != moderowiddesc) {
				alert(t['HXEY01']);
				return;
			}
		}
		if ((paymodedesc != paymodedesc1) && (moderowiddesc == "")) {
			alert(t['HXEY01']);
			return;
		}
		if ((paymodedesc != paymodedesc1) && (moderowiddesc != "")) {
			var encmeth = DHCWebD_GetObjValue('getpaymodeid');
			var tmp1 = cspRunServerMethod(encmeth, '', '', paymodedesc1);
			if (tmp1 != moderowiddesc) {
				alert(t['HXEY01']);
				return;
			}
			var truthBeTold = window.confirm(t['HXEY02']);
			if (!truthBeTold) {
				return;
			}
		}
	}
	
	//paymodeobj.value = DHCWeb_GetColumnData('Tpaymode', selectrow);
	//paymodedesc = DHCWeb_GetColumnData('Tpaymode', selectrow);
	if((paymodedesc=="押金转账")&&(paymodeobj.value=="押金转账")){
		alert('不能以"押金转账"方式退款.');
		return;
	}
	
	if (!Prtrowid) {
		alert(t['01']);
		return;
	}
	if ((Arpbl != "") && (Arpbl != " ")) {
		alert(t['02']);
		return;
	}
	if (PrtStatus == t['18']) {
		alert(t['03']);
		return;
	}
	if (PrtStatus == t['20']) {
		alert(t['04']);
		return false;
	}
	if (PrtStatus == t['19']) {
		alert(t['05']);
		return false;
	}
	var encmeth = DHCWebD_GetObjValue('getprtstatus');
	if (cspRunServerMethod(encmeth, Prtrowid) == '4') {
		alert(t['27']);
		return;
	}
	var DepsoitInfo = tkMakeServerCall("web.UDHCJFDeposit", "getyjinfo", Prtrowid);
	var OldUserDR = "";
	if (DepsoitInfo != "") {
		OldUserDR = DepsoitInfo.split("^")[0];
	}
	if ((RefYjFlag == "N") || (JkFlag == "Y")) {
		Refund(Prtrowid, moderowiddesc);
	} else if ((RefYjFlag == "Y") && (OldUserDR != Guser)) {
		Refund(Prtrowid, moderowiddesc);
	} else {
		abort(Prtrowid, RcptRowid);
	}
}

function GetCurRcptNo() {
	var encmeth = DHCWebD_GetObjValue('getrcptno');
	if (cspRunServerMethod(encmeth, 'GetRcptNo', '', Guser, TDepositType) == '0') {}
	if (CurNo == "") {
		alert(t['depttype03']);
		return;
	}
}

function GetRcptNo(value) {
	var sub = value.split("^");
	var receiptrowid = sub[0];
	if (receiptrowid == "") {
		if (this.id == "RefundDeposit") {
			alert(t['05']);
		} else {
			alert("没有可用收据号,不能退押金");
		}
		return;
	}
	EndNo = sub[1];
	CurNo = sub[2];
	Title = sub[3];
	document.getElementById('currentno').value = CurNo;
	var rcptrowidobj = document.getElementById('rcptrowid');
	rcptrowidobj.value = sub[0];
}

function GetNextNo(value) {
	if (parseInt(value, 10) > parseInt(EndNo, 10)) {
		alert(t['07'])
		return false;
	}
}

function SetPid(value) {
	var str = value.split("^");
	var retcode = str[0];
	var yjrowid = str[1];
	if (retcode != "0") {
		alert(t['08']);
		return;
	}
	try {
		alert(t['09']);
		if (RefYjPrtFlag == "Y") {
			var encmeth = DHCWebD_GetObjValue('getyjdetail');
			returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
			subyjinfor = returnval.split("^");
			var depttypedesc = subyjinfor[25];
			if (depttypedesc == t['depttype01']) {
				return;
			}
			var RemarkStr = "退款原因:" + subyjinfor[27];
			printYJ("", RemarkStr);
		}
		window.location.reload();
	} catch (e) {
	}
}

function Abort_click() {
	var truthBeTold = window.confirm(t['28']);
	if (!truthBeTold) {
		return;
	}
	if (!Prtrowid) {
		alert(t['10']);
		return false;
	}
	if ((Arpbl != "") && (Arpbl != " ")) {
		alert(t['11']);
		return false;
	}
	if (JkFlag == "Y") {
		alert(t['12']);
		return false;
	}
	if (PrtStatus == t['18']) {
		alert(t['15'] + rcptno + t['16']);
		return false;
	}
	if (PrtStatus == t['20']) {
		alert(t['13']);
		return false;
	}
	if (PrtStatus == t['17']) {
		//作废押金
		var encmeth = DHCWebD_GetObjValue('Abort');
		if (cspRunServerMethod(encmeth, 'SetPid1', '', Prtrowid, RcptRowid, Guser) == '0') {}
	}
	if (PrtStatus == t['19']) {
		if (RefYjPrtFlag == "Y") {
			GetCurRcptNo();
		}
		if (RefYjPrtFlag == "N") {
			rcptno = "";
			CurNo = "";
			EndNo = "";
		}
		if (RefYjPrtFlag == "Y") {
			var encmeth = DHCWebD_GetObjValue('getnextno');
			if (cspRunServerMethod(encmeth, 'GetNextNo', '', CurNo) == '0') {
			}
		}
		var rcptrowidobj = document.getElementById('rcptrowid');
		var receiptrowid = rcptrowidobj.value;
		var encmeth = DHCWebD_GetObjValue('AbortCH');
		if (cspRunServerMethod(encmeth, 'AbortCH', '', Prtrowid, Guser, CurNo, EndNo, RefYjPrtFlag, receiptrowid) == '0') {
		}
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	clearyjinfo();
	GetSum();
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	Prtrowid = DHCWeb_GetColumnData('Tprtrowid', selectrow);
	var obj = document.getElementById('prtrowid');
	obj.value = Prtrowid;
	regnoobj.value = regno;
	nameobj.value = name;
	Arpbl = DHCWeb_GetColumnData('Tarpbl', selectrow);
	Arpbl = websys_trim(Arpbl);
	rcptnoobj.value = DHCWeb_GetColumnData('Trcptno', selectrow);
	prtdateobj.value = DHCWeb_GetColumnData('Tprtdate', selectrow);
	payamtobj.value = DHCWeb_GetColumnData('Tpayamt', selectrow);
	PrtStatus = DHCWeb_GetColumnData('Tprtstatus', selectrow);
	statusobj.value = PrtStatus;
	if (PrtStatus == t['19']) {
		refdateobj.value = DHCWeb_GetColumnData('Tprtdate', selectrow);
		reftimeobj.value = DHCWeb_GetColumnData('Tprttime', selectrow);
		usernameobj.value = DHCWeb_GetColumnData('Tadduser', selectrow);
	}
	if (PrtStatus == t['17']) {
		refdateobj.value = datestr;
		reftimeobj.value = timestr;
		usernameobj.value = gusername;
	}
	paymodeobj.value = DHCWeb_GetColumnData('Tpaymode', selectrow);
	paymodedesc = DHCWeb_GetColumnData('Tpaymode', selectrow);
	cardnoobj.value = DHCWeb_GetColumnData('Tauthno', selectrow);
	companyobj.value = DHCWeb_GetColumnData('Tcompany', selectrow);
	//authnoobj.value = DHCWeb_GetColumnData('Tauthno', selectrow);
	bankobj.value = DHCWeb_GetColumnData('Tbank', selectrow);
	refreasonobj.value = DHCWeb_GetColumnData('Trefreason', selectrow);
	RcptRowid = DHCWeb_GetColumnData('Trcptrowid', selectrow);
	JkFlag = DHCWeb_GetColumnData('Tjkflag', selectrow);
	TDepositType = DHCWeb_GetColumnData('TDepositType', selectrow);
	SelectedRow = selectrow;
	websys_setfocus('refreason');
}

function GetSum() {
	Sum = 0;
	var YJNum=0;
	Objtbl = document.getElementById('tUDHCJFRefundDeposit');
	Rows = Objtbl.rows.length;
	Sum = 0;
	for (i = 1; i <= Rows - 2; i++) {
		var prtstatus = DHCWeb_GetColumnData('Tprtstatus', i);
		var select = DHCWeb_GetColumnData('select', i);
		var payamt = DHCWeb_GetColumnData('Tpayamt', i);
		var paystatus = DHCWeb_GetColumnData('Tpaystatus', i);
		if ((prtstatus != t['18']) && (select) && (paystatus != t['29'])) {
			Sum = eval(Sum) + eval(payamt);
			YJNum=YJNum+1;
		}
		obj = document.getElementById('sum');
		obj.value = Sum;
		if (prtstatus != "正常") {
			//Objtb.rows[i].style.background = "red"; //设置背景色
			Objtbl.rows[i].style.color = 'red';       //设置前景色
		}
	}
	obj = document.getElementById('yjnum');
	obj.value =YJNum;
	//obj.value = Rows - 2;
}

function Return_click() {
	parent.close();
}

function clearyjinfo() {
	regnoobj.value = "";
	nameobj.value = "";
	rcptnoobj.value = "";
	prtdateobj.value = "";
	payamtobj.value = "";
	paymodeobj.value = "";
	statusobj.value = "";
	cardnoobj.value = "";
	authnoobj.value = "";
	companyobj.value = "";
	bankobj.value = "";
	refreasonobj.value = "";
	refreasonidobj.value = "";
	refdateobj.value = "";
	reftimeobj.value = "";
	usernameobj.value = "";
}

function LookUprefrea(str) {
	var obj = document.getElementById('refreasonid');
	var tem = str.split("^");
	obj.value = tem[1];
}

function abort(yjrowid, rcptrid) {
	var abortobj;
	var p1 = yjrowid;
	var p2 = rcptrid;
	var p3 = Guser;
	var rcptrowidobj = document.getElementById('rcptrowid');
	var receiptrowid = rcptrowidobj.value;
	if (refreasonobj.value == "") {
		refreasonidobj.value = "";
	}
	var p4 = refreasonidobj.value; //+DingSH 2017-02-15
	var encmeth = DHCWebD_GetObjValue('Abort');
	if (cspRunServerMethod(encmeth, 'SetPid1', '', p1, p2, p3, p4) == '0') {}
}

function SetPid1(value) {
	if (value != "0") {
		alert(t['22']);
		return;
	} else {
		if (AbortYJprtFlag == "Y") {
			GetCurRcptNo();
			Add_click();
		} else {
			window.location.reload();
		}
	}
}

function AbortCH(value) {
	if (value == "") {
		alert(t['22']);
		return;
	} else {
		var tmp = value.split("^");
		if (tmp[0] == "1") {
			alert(t['HXEY01']);
			return;
		} else if (tmp[0] == "0") {
			alert(t['09']);
			if (RefYjPrtFlag == "Y") {
				yjrowid = tmp[1];
				var encmeth = DHCWebD_GetObjValue('getyjdetail');
				returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
				subyjinfor = returnval.split("^");
				var depttypedesc = subyjinfor[25];
				if (depttypedesc == t['depttype01']) {
					return;
				}
				var RemarkStr = "退款原因:" + subyjinfor[27];
				printYJ("", RemarkStr);
			}
			window.location.reload();
		} else {
			alert(t['08']);
			return;
		}
	}

}

function Add_click() {
	var encmeth = DHCWebD_GetObjValue('getabortyjdetail');
	var ayjdetail = cspRunServerMethod(encmeth, '', '', Prtrowid);
	if (ayjdetail != "") {
		var ayjdetailstr = ayjdetail.split("^");
		deptypestr = ayjdetailstr[0].split("@");
		deptype = deptypestr[0];
		var payamt1 = ayjdetailstr[1];
		var modestr = ayjdetailstr[2].split("@");
		var moderowid = modestr[0];
		var bankstr = ayjdetailstr[3].split("@");
		var bank = bankstr[0];
		var banksub = ayjdetailstr[4];
		var company = ayjdetailstr[5];
		var authno = ayjdetailstr[6];
		var cardno = ayjdetailstr[7];
		var pass = ayjdetailstr[8];
		var comment = ayjdetailstr[9];
		if (RefYjPrtFlag == "Y") {
			GetCurRcptNo();
		}
		if (RefYjPrtFlag == "N") {
			rcptno = "";
			CurNo = "";
			EndNo = "";
		}
		if (RefYjPrtFlag == "Y") {
			var encmeth = DHCWebD_GetObjValue('getnextno');
			if (cspRunServerMethod(encmeth, 'GetNextNo', '', CurNo) == '0') {}
		}
		var rcptrowidobj = document.getElementById('rcptrowid');
		var receiptrowid = rcptrowidobj.value;
		var encmeth = DHCWebD_GetObjValue('Add');
		var dep = deptype + "^" + payamt1 + "^" + moderowid + "^" + company + "^" + bank + "^" + cardno + "^" + authno + "^" + Adm + "^" + CurNo + "^" + UserLoc + "^" + Guser + "^" + EndNo + "^" + Title + "^" + banksub + "^" + comment + "^" + pass + "^" + receiptrowid;
		if (cspRunServerMethod(encmeth, 'SetPidAdd', '', dep) == '0') {}
	}
}

function SetPidAdd(value) {
	var sub;
	var amt;
	var str = value.split("^");
	var retcode = str[0];
	var yjrowid = str[1];
	var rcptrid = str[2];
	if ((retcode != "0") && (retcode != "100")) {
		alert(t['HXEY02']);
		return;
	}
	if ((retcode == "0") || (retcode == "100")) {
		var encmeth = DHCWebD_GetObjValue('getyjdetail');
		returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
		subyjinfor = returnval.split("^");
		var depttypedesc = subyjinfor[25];
		if (depttypedesc == t['depttype01']) {
			return;
		}
		/*
		//第三方退费接口 start
		var tradeType = "DEP";
		var receipRowId = Prtrowid;	//此处的id需要根据选中原正记录获取
		var expStr = session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'] + "^" + session['LOGON.USERID'] + "^^";
		var refRtn = RefundPayService(tradeType, receipRowId, yjrowid, "", "", "", expStr);
		if(refRtn.split("^")[0] != 0) {
			alert(refRtn.split("^")[1] + ",错误代码" + refRtn.split("^")[0] + ",请补交易。");
		}
		//
		*/
		var RemarkStr = "退款原因:" + subyjinfor[27];
		printYJ("", RemarkStr);
		/*
		var truthBeTold = window.confirm(t['anh01']);
		if (!truthBeTold) {
			abort(yjrowid,rcptrowid);
		}
		*/
		window.location.reload();
	}
}

function LookUpPayMode(str) {
	var obj = document.getElementById('moderowid');
	var tem = str.split("^");
	obj.value = tem[1];
	if (UPPaymFlag == "N") { // +renyp 如果配置不能换支付方式退押金，选择后回填选中的支付方式
		paymodeobj.value = DHCWeb_GetColumnData('Tpaymode', SelectedRow);
	}
}

function setrefmode() {
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "paymode";
		var paymode1obj = document.getElementById(imgname);
	}
	if (UPPaymFlag == "Y") {
		paymode1obj.style.display = "";
		paymode1obj.readOnly = false;
		paymodeobj.readOnly = false;
	}
	if (UPPaymFlag == "N") {
		paymode1obj.style.display = "none";
		paymode1obj.readOnly = true;
		paymodeobj.readOnly = true;
	}
}

///Lid
///2009-04-24
///补打退押金收据
function BPrint_onclick() {
	if (!Prtrowid) {
		alert("请选择要补打的收据");
		return;
	}
	if (PrtStatus != "冲红") {
		alert("该押金收据非冲红状态,不能重新打印");
		return;
	}
	var truthBeTold = window.confirm("是否补打该退押金收据");
	if (!truthBeTold) {
		return;
	}
	var encmeth = DHCWebD_GetObjValue('InsertPrtDeposit');
	var ReturnvalRePrt = cspRunServerMethod(encmeth, Prtrowid, Guser);
	if (ReturnvalRePrt == 0) {
		var encmeth = DHCWebD_GetObjValue('getyjdetail');
		returnval = cspRunServerMethod(encmeth, '', '', Prtrowid);
		subyjinfor = returnval.split("^");
		var RemarkStr = "退款原因:" + subyjinfor[27];
		printYJ("补", RemarkStr);
		alert("补打成功");
	}
	if (ReturnvalRePrt != 0) {
		alert("补打失败,请重新补打");
	}
}

function Refund(Prtrowid, moderowiddesc) {
	if (RefYjPrtFlag == "Y") {
		GetCurRcptNo();
	}
	if (RefYjPrtFlag == "N") {
		rcptno = "";
		CurNo = "";
		EndNo = "";
	}
	if (RefYjPrtFlag == "Y") {
		var encmeth = DHCWebD_GetObjValue('getnextno');
		if (cspRunServerMethod(encmeth, 'GetNextNo', '', CurNo) == '0') {}
	}
	if (refreasonobj.value == "") {
		refreasonidobj.value = "";
	}
	var p1 = refreasonidobj.value;
	if (paymodeobj.value == "") {
		moderowiddesc = "";
	}
	var rcptrowidobj = document.getElementById('rcptrowid');
	var receiptrowid = rcptrowidobj.value;
	var expstr=session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];
	//alert("expstr="+expstr)
	var encmeth = DHCWebD_GetObjValue('Refund');
	if (cspRunServerMethod(encmeth, 'SetPid', '', CurNo, EndNo, Prtrowid, Guser, RcptRowid, RefYjPrtFlag, p1, receiptrowid, moderowiddesc,expstr) == '0') {}
}

/**
* Creator: xiongwang
* CreatDate: 2018-03-14
* Description: 住院押金转门诊账户
*/
function TransferOP_Click() {
	if (!Prtrowid) {
		alert("请选择要转的押金.");
		return;
	}
	var truthBeTold = window.confirm("是否确认转押金到门诊账户?");
	if (!truthBeTold) {
		return;
	}
	var rtn = tkMakeServerCall("web.DHCBillDepConversion", "GetDEPZZDepTypeID");
	var deptype = rtn.split("^")[1];
	if (TDepositType != deptype){
		alert("只能转" + deptype);
		return;
	}
	if ((Arpbl != "") && (Arpbl != " ")) {
		alert("押金已经结算,不允许转账.");
		return;
	}
	if (PrtStatus == "作废") {
		alert("此收据已经作废,不允许转账.");
		return;
	}
	if (PrtStatus == "已冲红") {
		alert("此押金已经冲红,不能转账.");
		return false;
	}
	if (PrtStatus == "冲红") {
		alert("此押金状态为冲红,不能转账.");
		return false;
	}
	var rtn = tkMakeServerCall("web.UDHCJFDeposit", "GetPrtStatus", Prtrowid);
	if (rtn == '4') {
		alert("此收据已经退掉,不允许转账");
		return;
	}
	// 走退押金??? 
	if (RefYjPrtFlag == "N") {
		rcptno = "";
		CurNo = "";
		EndNo = "";
	}else if(RefYjPrtFlag == "Y") {
		GetCurRcptNo();
		var encmeth = DHCWebD_GetObjValue("getnextno");
		if (cspRunServerMethod(encmeth, 'GetNextNo', '', CurNo) == '0') {}
	}
	if (refreasonobj.value == "") {
		refreasonidobj.value = "";
	}
	var p1 = refreasonidobj.value;
	var rcptrowidobj = document.getElementById('rcptrowid');
	var receiptrowid = rcptrowidobj.value;
	var paymodeid = tkMakeServerCall("web.DHCBillDepConversion", "GetDEPZZPayModeID");
	if (paymodeid == ""){
		alert("请维护转账支付方式,系统默认取支付方式代码为:DEPZZ");
		return;
	}
	
	var para1 = CurNo + "^" + EndNo + "^" + Prtrowid + "^" + Guser + "^" + RcptRowid + "^" + RefYjPrtFlag;
	para1 += "^" + p1 + "^" + receiptrowid + "^" + paymodeid;
	
	var RegNo = DHCWebD_GetObjValue("regno");
	var rtn = tkMakeServerCall("web.UDHCAccManageCLS", "GetAccByPAPMINo", RegNo, "");
	var mystr = rtn.split("^");
	var AccountID = mystr[1];
	if (AccountID == "") {
		alert("没有有效账户,不能进行押金转账");
		return;
	}
	var OPReceiptsType;
	var OPReceiptsNo;
	var ren = tkMakeServerCall("web.UDHCAccAddDeposit", "GetCurrentRecNo", Guser, "D");
	var myary = ren.split("^");
	if (myary.length > 5) {
		OPReceiptsType = myary[5];
	}
	if (myary[0] == '0') {
		OPReceiptsNo = myary[3];
	}
	if ((OPReceiptsType!= "") && (OPReceiptsNo == "")) {
		alert("您已经没有可用门诊收据,请领取收据");
		return;
	}
	
	var Amt = DHCWebD_GetObjValue("payamt");
	/*
	var myCardNo = DHCWebD_GetObjValue("CardNo");
	var mycheckrtn = DHCACC_CheckCardNoForDeposit(myCardNo, m_SelectCardTypeDR);
	if (!mycheckrtn) {
		alert("请读卡！");
		return;
	}
	*/
	var Password;
	var para2 = AccountID + "^" + Amt + "^" + Guser + "^" + OPReceiptsNo + "^" + "" + "^" + Password + "^" + paymodeid + "^" + "" + "^" + ""+ "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^P" + "^" + session['LOGON.HOSPID'];
	var rtn = tkMakeServerCall("web.DHCBillDepConversion", "DepositTransAcount", para1, para2);
	var myary = rtn.split("^");
	var ren = myary[0];
	switch (ren){
		case 'RefErr':
			alert("退住院押金支付方式不能为空,转账失败");
			break
		case 'RefErr':
			alert("退住院押金失败,转账失败");
			break;
		case 'passerr':
			alert("密码验证失败,转账失败");
			break;
		case 'amterr':
			alert("金额输入有误,转账失败");
			break;
		case 'accerr':
			alert("账户有误,转账失败");
			break;
		case '0':
			alert("转账成功");
			var IPDepRowID = myary[1];
			//打印负票
			if (RefYjPrtFlag == "Y") {
				var encmeth = DHCWebD_GetObjValue("getyjdetail");
				returnval = cspRunServerMethod(encmeth, '', '', IPDepRowID);
				subyjinfor = returnval.split("^");
				var depttypedesc = subyjinfor[25];
				if (depttypedesc == t['depttype01']) {
					return;
				}
				var RemarkStr = "退款原因:" + subyjinfor[27];
				printYJ("", RemarkStr);
			}
			//打印门诊收据
			var OPDepRowID=myary[2];
			BillPrintNew(OPDepRowID);
			window.location.reload();
			break;
		default:
			alet("转账失败:" + ren);
			break;
	}
}


function GetTransferConfig() {
	var myrtn = tkMakeServerCall("web.DHCOPConfig", "ReadOPSPConfig");
	var str = myrtn.split("^");
	if (str[46] == "1"){
		document.getElementById("TransferOP").style.display = "block";
		var obj = document.getElementById("OPRcptNo");
		if (obj){
			var OPRcpNo = GetOPCurrentRecNo();
			obj.value = OPRcpNo;
		}
	}else {
		document.getElementById("TransferOP").style.display = "none";
	}
}

function GetOPCurrentRecNo() {
	var OPRcpNo = "";
	var p1 = Guser;
	var p2 = "D";
	var ren = tkMakeServerCall("web.UDHCAccAddDeposit", "GetCurrentRecNo", p1, p2);
	var myary = ren.split("^");
	/*
	if (myary.length > 5) {
		m_ReceiptsType = myary[5];
	}
	*/
	if (myary[0] == '0') {
		OPRcpNo = myary[3];
	} else {
		OPRcpNo = "";
		DHCWeb_DisBtnA("TransferOP");
		alert("您已经没有可用收据,请领取收据");
	}
	return OPRcpNo;
}

function BillPrintNew(INVstr) {
	var PrtXMLName = "UDHCAccDeposit";
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
	var INVtmp = INVstr.split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue("ReadAccDPEncrypt");
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myExpStr = "";
			var printInfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], Guser, myExpStr);
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

document.body.onload = BodyLoadHandler;
