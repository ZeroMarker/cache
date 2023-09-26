/// UDHCJFDischQuery.js

var path, wardid, warddesc, today;
var num, job;
var medobj, finalobj, payflagobj, confirmflagobj;
var medvalobj, finalvalobj, payflagvalueobj, confirmvalueobj;
var wardobj, locobj;
var myobj;
var Adm = "", papno, name;
var guser, BillNo, flag, admreason;
var CurAdmObj;
var TBillno = "";

function BodyLoadHandler() {
	var regNoObj = document.getElementById('regno');
	if (regNoObj) {
		regNoObj.onkeydown = RegNoOnKeyDown;
	}
	medobj = document.getElementById('Medical');
	medvalobj = document.getElementById('Medval');
	finalobj = document.getElementById('Final');
	finalvalobj = document.getElementById('Finalval');
	payflagobj = document.getElementById('Payflag');
	payflagvalueobj = document.getElementById('payflagvalue');
	confirmflagobj = document.getElementById('confirmflag');
	confirmvalueobj = document.getElementById('confirmvalue');
	var Printdetailobj = document.getElementById('Printdetail');
	CurAdmObj = document.getElementById('CurAdm');
	//var printreceiptobj = document.getElementById('printreceipt');
	myobj = document.getElementById('Print');
	var Recordobj = document.getElementById('BtnRecord');
	if (Recordobj) {
		Recordobj.onclick = RecordSave_Click;
	}
	guser = session['LOGON.USERID'];
	if (myobj) {
		myobj.onclick = Print_OnClick;
	}
	locobj = document.getElementById('Loc');
	wardobj = document.getElementById('Ward');
	var obj = document.getElementById('Clear');
	if (obj) {
		obj.onclick = Clear_Click;
	}
	var obj = document.getElementById('LinkOrdChk');
	if (obj) {
		obj.onclick = LinkOrdChk;
	}
	var PCPNameobj = document.getElementById('PCPName');
	//+2017-09-12 ZhYW
	var obj = websys_$('Patinstype');
	if (obj){
		obj.onkeyup = clearAdmReaID;
	}
	locobj.onkeyup = clearlocid;
	wardobj.onkeyup = clearwardid;
	locobj.onkeydown = getloc;
	wardobj.onkeydown = getward;
	PCPNameobj.onkeyup = clearPCPName;
	medobj.onclick = getmedobjfun;
	finalobj.onclick = getfinalobjfun;
	payflagobj.onclick = getpayflagobjfun;
	confirmflagobj.onclick = getconfirmfun;
	CurAdmObj.onclick = GetCurAdmFun;
	Printdetailobj.onclick = PrtBillinfo;
	//printreceiptobj.onclick = PrtBillqingdan;
	var CancelConfirmobj = document.getElementById('CancelConfirm');
	if (CancelConfirmobj) {
		CancelConfirmobj.onclick = Confirm_Click;
	}
	var prtobj = document.getElementById("outExp");
	if (prtobj) {
		prtobj.onclick = outExp_click;
	}
	iniBgColor();
}

function PrtBillinfo() {
	flag = "detail";
	PrtBillDetail()
}

function PrtBillqingdan() {
	flag = "qingdan";
	PrtBillDetail();
}

function gettoday() {
	var encmeth = DHCWebD_GetObjValue('gettoday');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {}
}

function setdate_val(value) {
	var Stdate = document.getElementById('Stdate');
	var EndDate = document.getElementById('EndDate');
	Stdate.value = value;
	EndDate.value = value;
}

function getmedobjfun() {
	if (medobj.checked == true) {
		finalobj.checked = false;
		payflagobj.checked = false;
		confirmflagobj.checked = false;
		CurAdmObj.checked = false;
		medvalobj.value = "1";
		finalvalobj.value = "0";
		confirmvalueobj.value = "0";
		payflagvalueobj.value = "0";
		CurAdmObj.value = "0";
	} else if (medobj.checked == false) {
		medvalobj.value = "0";     //取消勾选时初始化参数值 YDF
	}
}

function getfinalobjfun() {
	if (finalobj.checked == true) {
		medobj.checked = false;
		payflagobj.checked = false;
		confirmflagobj.checked = false
		CurAdmObj.checked = false;
		finalvalobj.value = "1";
		medvalobj.value = "0";
		confirmvalueobj.value = "0";
		payflagvalueobj.value = "0";
		CurAdmObj.checked = false;
	} else if (finalobj.checked == false) {
		finalvalobj = "0"; //取消勾选时初始化参数值 YDF
	}
}

function getpayflagobjfun() {
	if (payflagobj.checked == true) {
		medobj.checked = false;
		confirmflagobj.checked = false;
		finalobj.checked = false;
		CurAdmObj.checked = false;
		payflagvalueobj.value = "1";
		medvalobj.value = "0";
		confirmvalueobj.value = "0";
		finalvalobj.value = "0";
		CurAdmObj.checked = false;
	} else if (payflagobj.checked == false) {
		payflagvalueobj.value = "0"; //取消勾选时初始化参数值 YDF
	}
}

function getconfirmfun() {
	if (confirmflagobj.checked == true) {
		medobj.checked = false;
		payflagobj.checked = false;
		finalobj.checked = false;
		CurAdmObj.checked = false;
		confirmvalueobj.value = "1";
		medvalobj.value = "0";
		finalvalobj.value = "0";
		payflagvalueobj.value = "0";
	} else if (confirmflagobj.checked == false) {
		confirmvalueobj.value = "0"; //取消勾选时初始化参数值 YDF
	}
}

function GetCurAdmFun() {
	if (CurAdmObj.checked == true) {
		medobj.checked = false;
		payflagobj.checked = false;
		finalobj.checked = false;
		confirmflagobj.checked = false;
		confirmvalueobj.value = "0";
		medvalobj.value = "0";
		finalvalobj.value = "0";
		payflagvalueobj.value = "0";
	}
}

function clearAdmReaID(){
	DHCWebD_SetObjValueB('Patinstypeid', "");
}

function clearlocid() {
	var locidobj = document.getElementById('locid');
	locidobj.value = "";
}

function clearwardid() {
	var wardidobj = document.getElementById('wardid');
	wardidobj.value = "";
}

function Clear_Click() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDischQuery";
}

function getlocid(value) {
	var val = value.split("^");
	var obj = document.getElementById('locid');
	obj.value = val[1];
}

function getwardid(value) {
	var val = value.split("^");
	var obj = document.getElementById('wardid');
	obj.value = val[1];
}

function getward() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Ward_lookuphandler();
	}
}

function getloc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Loc_lookuphandler();
	}
}

function Print_OnClick() {
	var i;
	var disdate = "";
	var patward = "";
	var bed = "";
	var regno = "";
	var zyno = "";
	var name = "";
	var sex = "";
	var admitdate = "";
	var deposit = 0;
	var patfee = 0;
	var remain = 0;
	var rcptno = "";
	var MRDiagnos = "";
	var HomePlace = "";
	yjData = new Array();
	var Objtbl = document.getElementById('tUDHCJFDischQuery');
	var Rows = Objtbl.rows.length;
	allnum = Rows - 2;
	//出院日期	病区	床号	登记号	住院号	姓名	性别	入院日期	预交金	总费用	余额	发票号	诊断	籍贯
	//Tpawad,name,Teo,Tsex,Tadmdae,Tdsdae,Tdschme,Tdsc,Tmeddsc,Tmeddscdae,Tmeddscme,Tbed,Tloc,Tpafee,Tdepos,Tema,Tzyo,To,Tcpo,Tpaydae,Tpayme,Tadmeas,Tpada,TAddess,EpsodeID,Tcofmfla,TMRDaos,TPaplkphoe,Tdecease,TRecodDae,TRecodUse,TRecodComme,TPaAe,TPaNum,THomePlace
	for (i = 1; i <= Rows - 1; i++) {
		var SelRowObj = document.getElementById('Tdisdatez' + i);
		var disdate = SelRowObj.innerText; //出院日期
		var SelRowObj = document.getElementById('Tpatwardz' + i);
		var patward = SelRowObj.innerText; //病区
		SelRowObj = document.getElementById('Tbedz' + i);
		var bed = SelRowObj.innerText; //床号
		SelRowObj = document.getElementById('Tregnoz' + i);
		var regno = SelRowObj.innerText; //登记号
		SelRowObj = document.getElementById('Tzynoz' + i);
		var zyno = SelRowObj.innerText; //住院号
		SelRowObj = document.getElementById('Tnamez' + i);
		var name = SelRowObj.innerText; //姓名
		SelRowObj = document.getElementById('Tsexz' + i);
		var sex = SelRowObj.innerText; //性别
		SelRowObj = document.getElementById('Tadmitdatez' + i);
		var admitdate = SelRowObj.innerText; //入院日期
		SelRowObj = document.getElementById('Tdepositz' + i);
		var deposit = SelRowObj.innerText; //预交金
		SelRowObj = document.getElementById('Tpatfeez' + i);
		var patfee = SelRowObj.innerText; //总费用
		SelRowObj = document.getElementById('Tremainz' + i);
		var remain = SelRowObj.innerText; //余额
		SelRowObj = document.getElementById('Trcptnoz' + i);
		var rcptno = SelRowObj.innerText; //收据号
		SelRowObj = document.getElementById('TMRDiagnosz' + i);
		var MRDiagnos = SelRowObj.innerText; //诊断
		var HomePlace = document.getElementById('THomePlacez' + i).innerText; //籍贯
		/*
		if(i == Rows - 1){
			Tno = "合计";
			patname = "";
		}
		 */
		var str = disdate + "^" + patward + "^" + bed + "^" + regno + "^" + zyno + "^" + name + "^" + sex + "^" + admitdate + "^" + deposit + "^" + patfee + "^" + remain + "^" + rcptno + "^" + MRDiagnos + "^" + HomePlace;
		yjData[i - 1] = str.split("^");
		alert(i+",,"+str);
	}
	getpath();
	PrintDischFind();
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = document.getElementById('tUDHCJFDischQuery');
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var SelRowObj = document.getElementById('EpisodeIDz' + selectrow);
	Adm = SelRowObj.innerText;
	Adm = websys_trim(Adm);
	var SelRowObj = document.getElementById('Tregnoz' + selectrow);
	papno = SelRowObj.innerText;
	var SelRowObj = document.getElementById('Tnamez' + selectrow);
	name = SelRowObj.innerText;
	var PatientObj = document.getElementById("TPatientIDz" + selectrow);
	var PatientID = PatientObj.innerText;
	var TBillnoObj = document.getElementById("TBillnoz" + selectrow);
	TBillno = TBillnoObj.value;
	if (TBillno == " ") {
		TBillno = "";
	}
	//头菜单传值
	var frm = dhcsys_getmenuform();
	if (frm) {
		frm.EpisodeID.value = Adm;
		frm.PatientID.value = PatientID;
	}
	if (Adm != "") {
		getpatinfo();
	}
}

function LinkOrdChk() {
	if (Adm == "") {
		alert(t['07']);
		return;
	}
	var BillStr = GetBillNum();
	var BillStr1 = BillStr.split("^");
	var BillNum = BillStr1[0];
	BillNo = BillStr1[1];
	if (eval(BillNum) > 1) {
		//alert(t['JudgePbBillErr02']);
		//return;
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPatBill&Adm=' + Adm;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0');
	} else {
		if (BillNo == "") {
			alert("billno");
			return;
		}
		var WshNetwork = new ActiveXObject("WScript.NetWork");
		var computername = WshNetwork.ComputerName;
		var getbill = document.getElementById('getbill');
		if (getbill) {
			var encmeth = getbill.value;
		} else {
			var encmeth = '';
		}
		var num = cspRunServerMethod(encmeth, '', '', Adm, guser, BillNo, computername);
		if (num == '2') {
			alert(t['JudgePbBillErr02']);
			return;
		}
		if (num == '-1') {
			alert(t['JudgePbBillErr03']);
		}
		var JudgePbBillErr = JudgePatfee(BillNo);
		if (eval(JudgePbBillErr) != 0) {
			alert(t['JudgePbBillErr01']);
			return;
		}
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetailOrder&BillNo=' + BillNo + '&EpisodeID=' + Adm;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1200,height=820,left=0,top=0');
	}
	/*
	var confirmflag = document.getElementById('GetConfirm');
	if (confirmflag) {
		var encmeth = confirmflag.value;
	} else {
		var encmeth = '';
	}
	var retval = cspRunServerMethod(encmeth, Adm, guser);
	if (retval == "") {
		alert(t['05']);
		return;
	}
	if (retval == "Y") {
		alert(t['04']);
		return;
	}
	if (retval == "0") {
		alert(t['06']);
		return;
	}
	if (Adm=="") {
		alert(t['Err01']);
		return;
	}
	//var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFORDCHK&EpisodeID='+Adm
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFORDcat&EpisodeID='+Adm+'&RegNo='+papno+'&name='+name
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1200,height=520,left=5,top=100')
	*/
}
function Confirm_Click() {
	if (Adm == "") {
		alert(t['Err01']);
		return;
	}
	var BillStr = GetBillNum();
	var BillStr1 = BillStr.split("^");
	var BillNum = BillStr1[0];
	BillNo = BillStr1[1];
	if (eval(BillNum) > 1) {
		//alert(t['JudgePbBillErr02']);
		//return;
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPatBill&Adm=' + Adm;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
	} else {
		if (BillNo == "") {
			alert("billno");
			return;
		}
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetailOrder&BillNo=' + BillNo + '&EpisodeID=' + Adm;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1200,height=820,left=0,top=0');
	}
	/*
	var cconfirm = document.getElementById('cconfirm');
	if (cconfirm) {
		var encmeth = cconfirm.value;
	} else {
		var encmeth = '';
	}
	var retconfirm = cspRunServerMethod(encmeth, Adm, guser);
	if (retconfirm == "") {
		alert(t['Err01']);
		return;
	}
	if (retconfirm == "N") {
		alert(t['Err02']);
		return;
	}
	if (retconfirm == "0") {
		alert(t['Err03']);
		return;
	}
	if (retconfirm == "1") {
		alert(t['Err04']);
		return;
	}
	if (retconfirm == "100") {
		alert(t['Err05']);
		return;
	}
	*/
}

function PrtBillDetail() {
	if (Adm == "") {
		alert(t['Err01']);
		return;
	}
	if (TBillno == " ") {
		TBillno = "";
	}
	if (TBillno != "") {
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + TBillno;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0');
	}
	var BillStr = GetBillNum();
	var BillStr1 = BillStr.split("^");
	var BillNum = BillStr1[0];
	BillNo = BillStr1[1];
	var curbillflag = BillStr1[2];
	if (eval(BillNum) == 1) {
		if (curbillflag != "P") {
			Bill();
		} else {
			alert(t['js']);
			return;
		}
	}
	if (eval(BillNum) > 1) {
		//alert(t['JudgePbBillErr02']);
		//return;
		var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillNum&Adm=' + Adm;
		window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0');
	}
}

function Bill() {
	if (Adm == "") {
		alert(t['billno']);
		return;
	}
	if (Adm != "") {
		var BabyFeeObj = document.getElementById('GetBabyFee');
		if (BabyFeeObj) {
			var encmeth = BabyFeeObj.value;
		} else {
			var encmeth = '';
		}
		var BabyFee = cspRunServerMethod(encmeth, Adm);
		var WshNetwork = new ActiveXObject("WScript.NetWork");
		var computername = WshNetwork.ComputerName;
		var getbill = document.getElementById('getbill');
		if (getbill) {
			var encmeth = getbill.value;
		} else {
			var encmeth = '';
		}
		var num = cspRunServerMethod(encmeth, '', '', Adm, guser, BillNo, computername);
		if (num == '0') {
			if (flag == "detail") {
				if (BillNo == "") {
					alert("billno");
					return;
				}
				var JudgePbBillErr = JudgePatfee(BillNo);
				if (eval(JudgePbBillErr) != 0) {
					alert(t['JudgePbBillErr01']);
					return;
				}
				var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + BillNo;
				window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0');
			}
			if (flag == "qingdan") {
				document.getElementById('BillNo').value = BillNo;
				if (BillNo == "") {
					alert("billno");
					return;
				}
				var JudgePbBillErr = JudgePatfee(BillNo);
				if (eval(JudgePbBillErr) != 0) {
					alert(t['JudgePbBillErr01']);
					return;
				}
				if (admreason == t['ybdesc']) {
					CommonPrint('UDHCJFIPcybrjsqdyh');
					if (eval(BabyFee) != 0) {
						CommonPrint('DHCJFPatCatFeeBaby');
					}
				} else {
					CommonPrint('UDHCJFIPcybrjsqd');
					if (eval(BabyFee) != 0) {
						CommonPrint('DHCJFPatCatFeeBaby');
					}
				}
			}
		}
		if (num == '2') {
			alert(t['JudgePbBillErr02'])
			return;
		}
		if (num == '-1') {
			alert(t['JudgePbBillErr03']);
		}
	}
}

function getpatinfo() {
	var infro = document.getElementById('getpatinfo');
	if (infro) {
		var encmeth = infro.value;
	} else {
		var encmeth = '';
	}
	var returnvalue = cspRunServerMethod(encmeth, "", "", Adm);
	var sub = returnvalue.split("^");
	admreason = sub[11];
}

function JudgePatfee(PatBillId) {
	var JudgePbBillobj = document.getElementById('JudgePbBill');
	if (JudgePbBillobj) {
		var encmeth = JudgePbBillobj.value;
	} else {
		var encmeth = '';
	}
	var JudgePbBillErr = cspRunServerMethod(encmeth, PatBillId);
	return JudgePbBillErr;
}

function GetBillNum() {
	var getnum = document.getElementById('getbillnum');
	if (getnum) {
		var encmeth = getnum.value;
	} else {
		var encmeth = '';
	}
	var str = cspRunServerMethod(encmeth, Adm);
	return str;
}

function RecordSave_Click() {
	var RecordComment = document.getElementById('Comment').value;
	if (RecordComment == "") {
		alert("请输入随访日志.");
		return;
	}
	var encmeth = DHCWebD_GetObjValue('GetRecord');
	cspRunServerMethod(encmeth, Adm, guser, RecordComment);
	alert("保存成功.");
}

//说明余额的列数必须在第21列否则的改下面的下标
function iniBgColor() {
	var tableObj = document.getElementById('tUDHCJFDischQuery');
	var rowNum = tableObj.rows.length;
	var leftObj = document.getElementById('Tremainz' + 1);
	if (leftObj = "") {
		return;
	}
	for (var i = 1; i < rowNum; i++) {
		var leftObj = document.getElementById('Tremainz' + i);
		var leftAcount = parseInt(leftObj.innerText);
		if (leftAcount < 0) {
			leftObj.style.color = "Red";
			//tableObj.rows[i].cells[21].className = "Red";
		}
	}
}

function GetPCPName(value) {
	var RtnInfo = value.split("^");
	var PCPRowID = RtnInfo[1];
	DHCWebD_SetObjValueB("DocID", PCPRowID);
}

function clearPCPName() {
	var PCPName = websys_$V("PCPName");
	if (PCPName == "") {
		DHCWebD_SetObjValueB("DocID", "");
	}
}

function outExp_click() {
	var objtbl = document.getElementById("tUDHCJFDischQuery");
	var Rows = objtbl.rows.length;
	if (Rows < 2) {
		alert("没有可以打印数据");
		return;
	}
	var Medval = document.getElementById("Medval").value;
	var Finalval = document.getElementById("Finalval").value;
	var Stdate = document.getElementById("Stdate").value;
	var EndDate = document.getElementById("EndDate").value;
	var locid = document.getElementById("locid").value;
	var wardid = document.getElementById("wardid").value;
	var payflagvalue = document.getElementById("payflagvalue").value;
	var grp = document.getElementById("grp").value;
	var confirmvalue = document.getElementById("confirmvalue").value;
	var DocID = document.getElementById("DocID").value;
	var regno = document.getElementById("regno").value;
	var MasterName = document.getElementById("MasterName").value;
	var Patzyno = document.getElementById("Patzyno").value;
	var CurAdmobj = document.getElementById("CurAdm");
	var Patinstypeid = document.getElementById("Patinstypeid").value;
	if (CurAdmobj.checked == true) {
		CurAdm = "on";
	} else {
		CurAdm = "";
	}
	var fileName = "DHCBill_出院患者统计.raq&Medval=" + Medval + "&Finalval=" + Finalval + "&Stdate=" + Stdate;
	fileName += "&EndDate=" + EndDate + "&locid=" + locid + "&wardid=" + wardid + "&payflagvalue=" + payflagvalue;
	fileName +=	"&grp=" + grp + "&confirmvalue=" + confirmvalue + "&regno=" + regno + "&MasterName=" + MasterName;
	fileName +=	"&Patzyno=" + Patzyno + "&CurAdm=" + CurAdm + "&DocID=" + DocID+"&Patinstypeid="+Patinstypeid;
	DHCCPM_RQPrint(fileName, 800, 500);
}

function RegNoOnKeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		this.value = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", this.value);
	}
}

function getPatinstypeid(value) {
	var val = value.split("^");
	var obj = document.getElementById('Patinstypeid');
	obj.value = val[1];
}

document.body.onload = BodyLoadHandler;
