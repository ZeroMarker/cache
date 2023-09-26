/// UDHCJFCASHIER.js

var Adm = "";
var BillNo = "";
var Guser;
var instype;
var disch;
var papnoobj;
var locobj;
var nameobj;
var admobj;
var billnoobj, billednoobj;
var depositobj, totalamountobj, amttopayobj;
var billedobj;
var paidobj;
var tobillobj;
var stdateobj;
var enddateobj;
var discretamtobj;
var payobj;
var episodeidobj;
var patidobj;
var patzynoobj;
var patloc;
var SelectedRow = "-1";
var billed = [];
var RegistrationNoobj;
var dischobj;
var getdischobj;
var myData1 = new Array();
var myData2 = new Array();
var myData3 = new Array();
var myData4 = new Array();
var myData5 = new Array();
var myData6 = new Array();
var catedata = new Array();
var path, gusercode, today, GuserCode, Tinvno, billstatus;
var ryyear, rymon, ryday, cyyear, cymon, cyday;
var flag;
var typeobj;
var oldtotalamount;
var RefundFlag;

function BodyLoadHandler() {
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	document.onkeydown = FrameEnterkeyCode;
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
	getzyjfconfig();
	papnoobj = document.getElementById('Regno');
	locobj = document.getElementById('Loc');
	typeobj = document.getElementById('Type');
	nameobj = document.getElementById('Name');
	admobj = document.getElementById('Adm');
	billnoobj = document.getElementById('BillNo');
	depositobj = document.getElementById('Deposit');
	totalamountobj = document.getElementById('Totalamount');
	amttopayobj = document.getElementById('Amounttopay');
	discretamtobj = document.getElementById('Discretamt');
	billedobj = document.getElementById('Billed');
	billednoobj = document.getElementById('billedno');
	paidobj = document.getElementById('Paid');
	tobillobj = document.getElementById('ToBill');
	dischobj = document.getElementById('Discharge');
	getbilledobj = document.getElementById('getbilled');
	getpaidobj = document.getElementById('getpaid');
	gettobillobj = document.getElementById('gettobill');
	getdischobj = document.getElementById('getdisch');
	//stdateobj = document.getElementById('StDate');
	enddateobj = document.getElementById('EndDate');
	payobj = document.getElementById('Pay');
	var clearobj = document.getElementById('Clear');
	episodeidobj = document.getElementById('EpisodeID');
	patidobj = document.getElementById('PatientID');
	RegistrationNoobj = document.getElementById('RegistrationNo'); //登记号
	var printdetailobj = document.getElementById('Printdetail');
	var adddepositobj = document.getElementById('AddDeposit');
	var refunddepobj = document.getElementById('RefundDeposit');
	if (papnoobj) {
		papnoobj.onkeydown = getpat;
	}
	if (adddepositobj) {
		adddepositobj.onclick = LinkAddDeposit;
	}

	if (refunddepobj) {
		refunddepobj.onclick = LinkRefundDeposit;
	}

	var btnbill = document.getElementById('BtnBill');
	if (btnbill) {
		btnbill.onclick = Bill;
	}
	if (printdetailobj) {
		printdetailobj.onclick = LinkBillDetail;
	}
	if (payobj) {
		payobj.onclick = LinkPay;
	}
	if (clearobj) {
		clearobj.onclick = clearall;
	}
	if (billedobj) {
		billedobj.onclick = getbilledobjfun;
	}
	if (paidobj) {
		paidobj.onclick = getpaidobjfun;
	}
	if (tobillobj) {
		tobillobj.onclick = gettobillobjfun;
	}
	if (dischobj) {
		dischobj.onclick = getdischobjfun;
	}
	if (depositobj) {
		depositobj.readOnly = true;
	}
	if (totalamountobj) {
		totalamountobj.readOnly = true;
	}
	if (amttopayobj) {
		amttopayobj.readOnly = true;
	}

	if (discretamtobj) {
		discretamtobj.readOnly = true;
	}

	getbilledobjfun();
	getpaidobjfun();
	gettobillobjfun();
	getdischobjfun();
	if (locobj) {
		locobj.onkeyup = clearLoc;
		locobj.onkeydown = getloc;
	}
	if (typeobj) {
		typeobj.onkeyup = clearType;
		typeobj.onkeydown = gettype;
	}
	//getenddate();   刷新不更新结束日期  add 17.12.26

	//getpath();

	//insert by 2006.06.01 by cx
	var obj = document.getElementById("ybcardno");
	if (obj) {
		obj.onkeydown = ybcardnoEnter;
	}
	patzynoobj = document.getElementById("patmedicare");
	patzynoobj.onkeydown = getpat;
	//insert by 2008.05.05 增加读卡功能
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
	websys_setfocus('Regno');
	RefundFlag = "";
	var reprtFPbtn = document.getElementById('RePrintFP');
	if (reprtFPbtn) {
		reprtFPbtn.onclick = ReprintFP;
	}
	var UserDepIDobj = document.getElementById('UserDepID');
	if (UserDepIDobj) {
		UserDepIDobj.value = session['LOGON.CTLOCID'];
	}

	var CloseAcount = document.getElementById('BtnCloseAcount');
	if (CloseAcount) {
		CloseAcount.onclick = CloseAcount_click;
	}

	var UnCloseAcount = document.getElementById('BtnUnCloseAcount');
	if (UnCloseAcount) {
		UnCloseAcount.onclick = UnCloseAcount_click;
	}
}

///dump fee detaile
function DumpFiles() {
	var str = IPRevOutPut(BillNo);
	if (str == "0") {
		alert(t['msgIns01']);
	}
}

function getpat() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		getpatinfo1();
	}
}

function setpat_val(value) {
	var val = value.split("^");
	papnoobj.value = val[0];
	nameobj.value = val[1];
	admobj.value = val[2];
	Adm = admobj.value;
	episodeidobj.value = Adm;
	var patzynoobj = document.getElementById("patmedicare"); //yyx
	patzynoobj.value = val[6];
	document.getElementById("decease").value = val[7];
	if (val[7] != t['23']) {
		document.getElementById("decease").style.color = "red";
	} else {
		document.getElementById("decease").style.color = "black";
	}
	if (val[8] == "A") {
		//alert(t['56']);
	}
	//insert by cx 2006.06.03
	var patid = "";
	var encmeth = DHCWebD_GetObjValue('getpapmiid');
	patid = cspRunServerMethod(encmeth, val[0]);
	var patidobj = document.getElementById('PatientID');
	patidobj.value = patid;
	if (patid != "") {
		getybcardno();
	}
}

function getbilledobjfun() {
	if (getbilledobj.value == "1") {
		billedobj.checked = true;
	}
	if (billedobj.checked == true) {
		paidobj.checked = false;
		tobillobj.checked = false;
		dischobj.checked = false;
		getbilledobj.value = "1";
		getpaidobj.value = "0";
		gettobillobj.value = "0";
		getdischobj.value = "0";
	}
}

function getpaidobjfun() {
	if (getpaidobj.value == "1") {
		paidobj.checked = true;
	}
	if (paidobj.checked == true) {
		getpaidobj.value = "1";
		tobillobj.checked = false;
		dischobj.checked = false;
		billedobj.checked = false;
		gettobillobj.value = "0";
		getdischobj.value = "0";
		getbilledobj.value = "0";
	}
}

function gettobillobjfun() {
	if (gettobillobj.value == "1") {
		tobillobj.checked = true;
	}
	if (tobillobj.checked == true) {
		gettobillobj.value = "1";
		paidobj.checked = false;
		dischobj.checked = false;
		billedobj.checked = false;
		getpaidobj.value = "0";
		getdischobj.value = "0";
		getbilledobj.value = "0";
	}
}

function getdischobjfun() {
	if (getdischobj.value == "1") {
		dischobj.checked = true;
	}
	if (dischobj.checked == true) {
		getdischobj.value = "1";
		paidobj.checked = false;
		tobillobj.checked = false;
		billedobj.checked = false;
		getpaidobj.value = "0";
		gettobillobj.value = "0";
		getbilledobj.value = "0";
	}
}

function clearall() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCASHIER";
}

function gettypeid(value) {
	var val = value.split("^");
	var obj = document.getElementById('typeid');
	obj.value = val[1];
}

function getlocid(value) {
	var val = value.split("^");
	var obj = document.getElementById('locid');
	obj.value = val[1];
}

/*
function getpath(){
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}
*/

function getenddate() {
	var encmeth = DHCWebD_GetObjValue('getenddate');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	enddateobj.value = value;
	today = value;
}

function getdeposit(Adm) {
	p1 = Adm;
	var encmeth = DHCWebD_GetObjValue('getdeposit');
	return cspRunServerMethod(encmeth, p1);
}

function gettoday() {
	var d = new Date();
	var s = d.getDate() + "/";
	s += (d.getMonth() + 1) + "/";
	s += d.getYear();
	return (s);
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	Objtbl = document.getElementById('tUDHCJFCASHIER');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow){
		return;
	}
	if (selectrow != SelectedRow) {
		//+2015-3-23 hujunbin 将就诊ID和账单ID传到头菜单
		var episodeObj = document.getElementById('Tadmz' + selectrow);
		var billObj = document.getElementById('Tbillrowidz' + selectrow);
		var frm = parent.parent.document.forms['fEPRMENU'];
		if (typeof(frm) != "undefined") {
			var frmEpisodeID = frm.EpisodeID;
			var frmBillID = frm.BillRowIds;
			if (billObj){
				frmBillID.value = billObj.innerText;
			}
			if (episodeObj){
				frmEpisodeID.value = episodeObj.innerText;
			}
		}
		var SelRowObj = document.getElementById('Tadmz' + selectrow);
		Adm = SelRowObj.innerText;
		if (Adm) {
			admobj.value = Adm;
			episodeidobj.value = Adm;
		} else {
			admobj.value = "";
			episodeidobj.value = "";
		}
		SelRowObj = document.getElementById('Tregnoz' + selectrow);
		var regno = SelRowObj.innerText;
		if (regno) {
			RegistrationNoobj.value = regno;
		} else {
			RegistrationNoobj.value = "";
		}
		var SelRowObj = document.getElementById('TPatientIDz' + selectrow);
		var PatientID = SelRowObj.innerText;
		if (PatientID) {
			patidobj.value = PatientID;
		} else {
			patidobj.value = "";
		}
		var SelRowObj = document.getElementById('Tbillstatusz' + selectrow);
		billstatus = SelRowObj.innerText;
		depositobj.value = getdeposit(Adm);
		//SelRowObj = document.getElementById('Tdiscretamtz' + selectrow);
		//discretamtobj.value = SelRowObj.innerText;
		if (discretamtobj.value == "")
			discretamtobj.value = "0.00";
		if (billstatus == "Paid") {
			totalamountobj.value = "0.00";
			amttopayobj.value = "0.00";
		} else {
			SelRowObj = document.getElementById('Tpatientsharez' + selectrow);
			totalamountobj.value = SelRowObj.innerText;
			var tmpamt = totalamountobj.value - depositobj.value - discretamtobj.value;   //*
			amttopayobj.value = tmpamt.toFixed(2);
		}
		if (amttopayobj.value < 0) {
			amttopayobj.style.color = "red";
		} else {
			amttopayobj.style.color = "black";
		}
		var SelRowObj = document.getElementById('Tbillrowidz' + selectrow);
		BillNo = SelRowObj.innerText;
		if (BillNo) {
			billnoobj.value = BillNo;
		} else {
			billnoobj.value = "";
			BillNo = "";
		}
		SelRowObj = document.getElementById('Tinvnoz' + selectrow);
		Tinvno = SelRowObj.innerText;
		if (!Tinvno){
			Tinvno = "";
		}
		SelRowObj = document.getElementById('Tregnoz' + selectrow);
		papnoobj.value = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tnamez' + selectrow);
		nameobj.value = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tbilltypez' + selectrow);
		instype = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tdischargestatusz' + selectrow);
		disch = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tlocz' + selectrow);
		patloc = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tpatzynoz' + selectrow);
		patzynoobj.value = SelRowObj.innerText;
		//+2018-01-15 ZhYW 
		var decease = DHCWeb_GetColumnData('TDecease', selectrow);
		var deceaseObj = websys_$("decease");
		deceaseObj.value = decease;
		if (decease != t['23']) {
			deceaseObj.style.color = "red";
		} else {
			deceaseObj.style.color = "black";
		}
		//
		RefundFlag = document.getElementById('Trefundz' + selectrow).innerText;
		SelectedRow = selectrow;
	} else {
		papnoobj.value = "";
		nameobj.value = "";
		admobj.value = "";
		billnoobj.value = "";
		depositobj.value = "";
		totalamountobj.value = "";
		amttopayobj.value = "";
		discretamtobj.value = "";
		SelectedRow = "-1";
		Adm = "";
		BillNo = "";
		Tinvno = "";
		billstatus = "";
		episodeidobj.value = "";
		patidobj.value = "";
		patzynoobj.value = "";
		DHCWebD_SetObjValueB("decease", "");
	}
	//insert by cx 2006.06.03
	getybcardno()
}

function LinkPay() {
	if (Adm == "" || BillNo == "") {
		alert("请先选择账单!");
		return;
	}
	//判断婴儿是否结算
	var rtn = tkMakeServerCall("web.UDHCJFCOMMON", "CheckBabyAdmDisCharge", Adm);
	if (rtn == "-1") {
		var PayFlag = window.confirm("有婴儿未结算,母亲是否确认结算?");
		if (!PayFlag) {
			return;
		}
	}
	if (rtn == "-2") {
		var PayFlag = window.confirm("婴儿未做最终结算,母亲是否确认结算?");
		if (!PayFlag) {
			return;
		}
	}
	if (disch == t['53']) {
		alert(t['54']);
	}

	if (RefundFlag == "B") //yyx 2009-09-24 bug修改
	{
		alert("此账单已经红冲,不允许结算.");
		return
	}
	GetAdmReaNationCode();
	if (disch != t['55']) {
		if ((ReaNationCode != "") && (ReaNationCode != "0") && (InsuPayFlag == "N")) {
			alert("医保病人未做最终结算不能结算!!");
			return;
		} else {
			if (!confirm(t['56'])) {
				return;    //alert(t['56']);
			}
		}
	}
	//判断收费有未记账的医嘱有计费数量与发药数量不一致的药品如果有则不允许结算
	/*
	var ReturnValStr=tkMakeServerCall("web.DHCIPBillPayControl","GetNotBillOrd",Adm,BillNo)

	var ReturnVal=ReturnValStr.split("^")

	var MNotBill=ReturnVal[0].split(",");
	var MNotBillNum=MNotBill[0],MNotBillInfo=MNotBill[1];
	var MDis=ReturnVal[1].split(",");
	var MDisNum=MDis[0];
	var MDisInfo=MDis[1];
	var NotDisp=ReturnVal[2].split(",");
	var NotDispNum=NotDisp[0],NotDispInfo=NotDisp[1];
	if (MDisNum!=0)
{  alert("此病人有药品发药数量与计费数量不一致的医嘱,不允许结算."+"^"+MDisInfo);
	return;   }
	if (MNotBillNum!=0)
{  alert("此病人有需要计费的医嘱,不允许结算."+"^"+MNotBillInfo);
	return;   }

	if (NotDispNum!=0)
{
	alert("病人有药品需要发放的医嘱,不允许结算"+NotDispInfo);
	return;
	}
	//判断婴儿的
	var ReturnValStr=tkMakeServerCall("web.DHCIPBillPayControl","GetBabyNotBillOrd",Adm,BillNo);
	var ReturnVal=ReturnValStr.split("^");
	var MNotBill=ReturnVal[0].split(",");
	var MNotBillNum=MNotBill[0];
	var MNotBillInfo=MNotBill[1];
	var MDis=ReturnVal[1].split(",");
	var MDisNum=MDis[0],MDisInfo=MDis[1];
	var NotDisp=ReturnVal[2].split(",");
	var NotDispNum=NotDisp[0],NotDispInfo=NotDisp[1];
	if (MDisNum != 0){
  		alert("此病人的婴儿有药品发药数量与计费数量不一致的医嘱,不允许结算."+"^"+MDisInfo);
		return;
	}
	if (MNotBillNum!=0){
		alert("此病人的婴儿有需要计费的医嘱,不允许结算."+"^"+MNotBillInfo);
		return;
	}

	if (NotDispNum!=0) {
		alert("病人的婴儿有药品需要发放的医嘱,不允许结算"+NotDispInfo);
		return;
	}
	*/

	//modify 2014-11-12  住院结算控制使用新监控配置查询
	var CheckFlag = "PAY";
	var BillFlag = "New";     //7.0之前版本为"Old"，之后包括7.0为 "New"
	var ReturnValStr = tkMakeServerCall("web.DHCIPBillCheckAdmFee", "AdmSettlementCheck", Adm, BillNo, CheckFlag, BillFlag)
	var ReturnVal = ReturnValStr.split("^");
	//进程号^7.0后版本没有执行记录^核实状态医嘱没有计费^没有发药医嘱^发药数量与计费数量不一致^缺少床位的天数^缺少护理费的天数^缺少诊查费的天数^缺少伙食费的天数^缺少取暖费的天数^手术申请是否有手术医嘱^手术申请是否有麻醉医嘱^费用不平的账单数量^费用不平的医嘱数量^账单数量小于0
	var NExecNull = ReturnVal[1];
	var TBOEOrd = ReturnVal[2];
	var NCDrug = ReturnVal[3];
	var NDrugErr = ReturnVal[4];
	var NBedNumErr = ReturnVal[5];
	var NNurseNumErr = ReturnVal[6];
	var NExamNumErr = ReturnVal[7];
	var NFoodNumErr = ReturnVal[8];
	var NWarmNumErr = ReturnVal[9];
	var NOPOENum = ReturnVal[10];
	var NAnAOENum = ReturnVal[11];
	var UnevenBillNum = ReturnVal[12];
	var UnevenOrdNum = ReturnVal[13];
	var BillNegativeNum = ReturnVal[14];

	//新版医嘱没有执行记录
	if ((NExecNull == "") || (NExecNull == "")) {
		alert("检查医嘱执行信息失败不能结算!!");
		return;
	}
	if (isNaN(NExecNull)) {
		alert("检查医嘱执行信息失败不能结算!!");
		return;
	}
	if ((eval(NExecNull) != 0) && (BillFlag == "New")) {
		alert("患者医嘱未找到执行记录,计费错误不能结算,您可在《患者住院费用核查》模块找到错误数据");
		return;
	}
	//患者医嘱有"TB" 状态
	if ((TBOEOrd == "") || (TBOEOrd == "")) {
		alert("检查医嘱是否计费失败不能结算!!");
		return;
	}
	if (isNaN(TBOEOrd)) {
		alert("检查医嘱是否计费失败不能结算!!");
		return;
	}
	if (eval(TBOEOrd) != 0) {
		alert("患者医嘱中未计费医嘱错不能结算,您可在《患者住院费用核查》模块找到错误数据");
		return;
	}
	//患者医嘱有未发药记录
	if ((NCDrug == "") || (NCDrug == "")) {
		alert("检查患者是否有未发药医嘱不能结算!!");
		return;
	}
	if (isNaN(NCDrug)) {
		alert("检查患者是否有未发药医嘱不能结算!!");
		return;
	}
	if (eval(NCDrug) != 0) {
		alert("患者有未发药医嘱不能结算,您可在《患者住院费用核查》模块找到错误数据");
		return;
	}
	//患者医嘱有未发药记录
	if ((NDrugErr == "") || (NDrugErr == "")) {
		alert("检查患者发药与计费数量是否一致失败不能结算!!");
		return;
	}
	if (isNaN(NDrugErr)) {
		alert("检查患者发药与计费数量是否一致失败不能结算!!");
		return;
	}
	if (eval(NDrugErr) != 0) {
		alert("患者有发药数量与计费数量不一致不能结算,您可在《患者住院费用核查》模块找到错误数据");
		return;
	}
	//患者住院天数与床位费天数不符
	if ((NBedNumErr == "") || (NBedNumErr == "")) {
		alert("检查患者收取床位费天数失败不能结算!!");
		return;
	}
	if (isNaN(NBedNumErr)) {
		alert("检查患者收取床位费天数失败不能结算!!");
		return;
	}
	if (eval(NBedNumErr) != 0) {
		var PayFlag = window.confirm("患者收取床位费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收床位费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//患者护理费天数与住院天数不符
	if ((NNurseNumErr == "") || (NNurseNumErr == "")) {
		alert("检查患者收取护理费天数失败不能结算!!");
		return;
	}
	if (isNaN(NNurseNumErr)) {
		alert("检查患者收取护理费天数失败不能结算!!");
		return;
	}
	if (eval(NNurseNumErr) != 0) {
		var PayFlag = window.confirm("换着收取床位费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收护理费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//患者诊查费天数与住院费天数不符
	if ((NExamNumErr == "") || (NExamNumErr == "")) {
		alert("检查患者收取诊查费天数失败不能结算!!");
		return;
	}
	if (isNaN(NExamNumErr)) {
		alert("检查患者收取诊查费天数失败不能结算!!");
		return;
	}
	if (eval(NExamNumErr) != 0) {
		var PayFlag = window.confirm("患者收取诊查费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收诊查费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//患者伙食费天数与住院天数不符
	if ((NFoodNumErr == "") || (NFoodNumErr == "")) {
		alert("检查患者收取伙食费天数失败不能结算!!");
		return;
	}
	if (isNaN(NFoodNumErr)) {
		alert("检查患者收取伙食费天数失败不能结算!!");
		return;
	}
	if (eval(NFoodNumErr) != 0) {
		var PayFlag = window.confirm("患者收取伙食费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收伙食费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//患者空调取暖费天数与住院天数不符
	if ((NWarmNumErr == "") || (NWarmNumErr == "")) {
		alert("检查患者收取空调/取暖费天数失败不能结算!!");
		return;
	}
	if (isNaN(NWarmNumErr)) {
		alert("检查患者收取空调/取暖费天数失败不能结算!!");
		return;
	}
	if (eval(NWarmNumErr) != 0) {
		var PayFlag = window.confirm("患者收取空调/取暖天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收空调/取暖费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//已做手术申请但没有手术相关医嘱
	if ((NOPOENum == "") || (NOPOENum == "")) {
		alert("检查患者手术相关医嘱失败不能结算!!");
		return;
	}
	if (isNaN(NOPOENum)) {
		alert("检查患者手术相关医嘱失败不能结算!!");
		return;
	}
	if (eval(NOPOENum) != 0) {
		var PayFlag = window.confirm("患者已做手术申请但未补录手术相关医嘱,您可在《患者住院费用核查》模块找到未收空调/取暖费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//已做手术申请但没有麻醉相关医嘱
	if ((NAnAOENum == "") || (NAnAOENum == "")) {
		alert("检查患者麻醉相关医嘱失败不能结算!!");
		return;
	}
	if (isNaN(NAnAOENum)) {
		alert("检查患者麻醉相关医嘱失败不能结算!!");
		return;
	}
	if (eval(NAnAOENum) != 0) {
		var PayFlag = window.confirm("患者已做手术申请但未补录麻醉相关医嘱,您可在《患者住院费用核查》模块找到未收空调/取暖费日期,是否结算?");
		if (!PayFlag) {
			return;
		}
	}
	//患者账单金额不平
	if ((UnevenBillNum == "") || (UnevenBillNum == "")) {
		alert("检查患者账单失败不能结算!!");
		return;
	}
	if (isNaN(UnevenBillNum)) {
		alert("检查患者账单失败不能结算!!");
		return;
	}
	if (eval(UnevenBillNum) != 0) {
		alert("患者账单不平不能结算!!");
		return;
	}
	//患者医嘱账单金额不平
	if ((UnevenOrdNum == "") || (UnevenOrdNum == "")) {
		alert("检查患者医嘱账单金额失败不能结算!!");
		return;
	}
	if (isNaN(UnevenOrdNum)) {
		alert("检查患者医嘱账单金额失败不能结算!!");
		return;
	}
	if (eval(UnevenOrdNum) != 0) {
		alert("患者医嘱账单金额不平不能结算!!");
		return;
	}
	//患者医嘱账单数量为负数
	if ((BillNegativeNum == "") || (BillNegativeNum == "")) {
		alert("检查患者医嘱账单数量失败不能结算!!");
		return;
	}
	if (isNaN(BillNegativeNum)) {
		alert("检查患者医嘱账单数量失败不能结算!!");
		return;
	}
	if (eval(BillNegativeNum) != 0) {
		alert("患者医嘱账单数量为负数不能结算!!");
		return;
	}
	//判断婴儿医嘱
	var CheckFlag = "PAY";
	var BillFlag = "New";     //7.0之前版本为"Old"，之后包括7.0为 "New"
	var ReturnValStr = tkMakeServerCall("web.DHCIPBillCheckAdmFee", "GetBabySettlementCheck", Adm, BillNo, CheckFlag, BillFlag);
	if (ReturnValStr != "") {
		var ReturnValStr1 = ReturnValStr.split(String.fromCharCode(3));
		for (var i = 0; i < ReturnValStr1.length - 1; i++) {
			if (ReturnValStr1[i] != "") {
				var ReturnValStr12 = ReturnValStr1[i].split(String.fromCharCode(2));
				var BabyName = ReturnValStr12[0];
				var ReturnVal = ReturnValStr12[1].split("^");
				//进程号^7.0后版本没有执行记录^核实状态医嘱没有计费^没有发药医嘱^发药数量与计费数量不一致^缺少床位的天数^缺少护理费的天数^缺少诊查费的天数^缺少伙食费的天数^缺少取暖费的天数^费用不平的账单数量^费用不平的医嘱数量^账单数量小于0
				var NExecNull = ReturnVal[1];
				var TBOEOrd = ReturnVal[2];
				var NCDrug = ReturnVal[3];
				var NDrugErr = ReturnVal[4];
				var NBedNumErr = ReturnVal[5];
				var NNurseNumErr = ReturnVal[6];
				var NExamNumErr = ReturnVal[7];
				var NFoodNumErr = ReturnVal[8];
				var NWarmNumErr = ReturnVal[9];
				var NOPOENum = ReturnVal[10];
				var NAnAOENum = ReturnVal[11];
				var UnevenBillNum = ReturnVal[12];
				var UnevenOrdNum = ReturnVal[13];
				var BillNegativeNum = ReturnVal[14];

				//新版医嘱没有执行记录
				if ((NExecNull == "") || (NExecNull == "")) {
					alert("检查医嘱执行信息失败不能结算!!");
					return;
				}
				if (isNaN(NExecNull)) {
					alert("检查医嘱执行信息失败不能结算!!");
					return;
				}
				if ((eval(NExecNull) != 0) && (BillFlag == "New")) {
					alert("患者医嘱未找到执行记录,计费错误不能结算,您可在《患者住院费用核查》模块找到错误数据");
					return;
				}
				//患者医嘱有"TB" 状态
				if ((TBOEOrd == "") || (TBOEOrd == "")) {
					alert("检查医嘱是否计费失败不能结算!!");
					return;
				}
				if (isNaN(TBOEOrd)) {
					alert("检查医嘱是否计费失败不能结算!!");
					return;
				}
				if (eval(TBOEOrd) != 0) {
					alert("患者医嘱中未计费医嘱错不能结算,您可在《患者住院费用核查》模块找到错误数据");
					return;
				}
				//患者医嘱有未发药记录
				if ((NCDrug == "") || (NCDrug == "")) {
					alert("检查患者是否有未发药医嘱不能结算!!");
					return;
				}
				if (isNaN(NCDrug)) {
					alert("检查患者是否有未发药医嘱不能结算!!");
					return;
				}
				if (eval(NCDrug) != 0) {
					alert("患者有未发药医嘱不能结算,您可在《患者住院费用核查》模块找到错误数据");
					return;
				}
				//患者医嘱有未发药记录
				if ((NDrugErr == "") || (NDrugErr == "")) {
					alert("检查患者发药与计费数量是否一致失败不能结算!!");
					return;
				}
				if (isNaN(NDrugErr)) {
					alert("检查患者发药与计费数量是否一致失败不能结算!!");
					return;
				}
				if (eval(NDrugErr) != 0) {
					alert("患者有发药数量与计费数量不一致不能结算,您可在《患者住院费用核查》模块找到错误数据");
					return;
				}
				//患者住院天数与床位费天数不符
				if ((NBedNumErr == "") || (NBedNumErr == "")) {
					alert("检查患者收取床位费天数失败不能结算!!");
					return;
				}
				if (isNaN(NBedNumErr)) {
					alert("检查患者收取床位费天数失败不能结算!!");
					return;
				}
				if (eval(NBedNumErr) != 0) {
					var PayFlag = window.confirm("患者收取床位费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收床位费日期,是否结算?");
					if (!PayFlag) {
						return;
					}
				}
				//患者护理费天数与住院天数不符
				if ((NNurseNumErr == "") || (NNurseNumErr == "")) {
					alert("检查患者收取护理费天数失败不能结算!!");
					return;
				}
				if (isNaN(NNurseNumErr)) {
					alert("检查患者收取护理费天数失败不能结算!!");
					return;
				}
				if (eval(NNurseNumErr) != 0) {
					var PayFlag = window.confirm("患者收取床位费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收护理费日期,是否结算?");
					if (!PayFlag) {
						return;
					}
				}
				//患者诊查费天数与住院费天数不符
				if ((NExamNumErr == "") || (NExamNumErr == "")) {
					alert("检查患者收取诊查费天数失败不能结算!!");
					return;
				}
				if (isNaN(NExamNumErr)) {
					alert("检查患者收取诊查费天数失败不能结算!!");
					return;
				}
				if (eval(NExamNumErr) != 0) {
					var PayFlag = window.confirm("患者收取诊查费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收诊查费日期,是否结算?");
					if (!PayFlag) {
						return
					}
				}
				//患者伙食费天数与住院天数不符
				if ((NFoodNumErr == "") || (NFoodNumErr == "")) {
					alert("检查患者收取伙食费天数失败不能结算!!");
					return;
				}
				if (isNaN(NFoodNumErr)) {
					alert("检查患者收取伙食费天数失败不能结算!!");
					return;
				}
				if (eval(NFoodNumErr) != 0) {
					var PayFlag = window.confirm("患者收取伙食费天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收伙食费日期,是否结算?");
					if (!PayFlag) {
						return;
					}
				}
				//患者空调取暖费天数与住院天数不符
				if ((NWarmNumErr == "") || (NWarmNumErr == "")) {
					alert("检查患者收取空调/取暖费天数失败不能结算!!");
					return;
				}
				if (isNaN(NWarmNumErr)) {
					alert("检查患者收取空调/取暖费天数失败不能结算!!");
					return;
				}
				if (eval(NWarmNumErr) != 0) {
					var PayFlag = window.confirm("患者收取空调/取暖天数与实际住院天数不符,您可在《患者住院费用核查》模块找到未收空调/取暖费日期,是否结算?");
					if (!PayFlag) {
						return;
					}
				}
				//已做手术申请但没有手术相关医嘱
				if ((NOPOENum == "") || (NOPOENum == "")) {
					alert("检查患者手术相关医嘱失败不能结算!!");
					return;
				}
				if (isNaN(NOPOENum)) {
					alert("检查患者手术相关医嘱失败不能结算!!");
					return;
				}
				if (eval(NOPOENum) != 0) {
					var PayFlag = window.confirm("患者已做手术申请但未补录手术相关医嘱,您可在《患者住院费用核查》模块找到未收空调/取暖费日期,是否结算?");
					if (!PayFlag) {
						return;
					}
				}
				//已做手术申请但没有麻醉相关医嘱
				if ((NAnAOENum == "") || (NAnAOENum == "")) {
					alert("检查患者麻醉相关医嘱失败不能结算!!");
					return;
				}
				if (isNaN(NAnAOENum)) {
					alert("检查患者麻醉相关医嘱失败不能结算!!");
					return;
				}
				if (eval(NAnAOENum) != 0) {
					var PayFlag = window.confirm("患者已做手术申请但未补录麻醉相关医嘱,您可在《患者住院费用核查》模块找到未收空调/取暖费日期,是否结算?");
					if (!PayFlag) {
						return;
					}
				}

				//患者账单金额不平
				if ((UnevenBillNum == "") || (UnevenBillNum == "")) {
					alert("检查患者账单失败不能结算!!");
					return;
				}
				if (isNaN(UnevenBillNum)) {
					alert("检查患者账单失败不能结算!!");
					return;
				}
				if (eval(UnevenBillNum) != 0) {
					alert("患者账单不平不能结算!!");
					return;
				}
				//患者医嘱账单金额不平
				if ((UnevenOrdNum == "") || (UnevenOrdNum == "")) {
					alert("检查患者医嘱账单金额失败不能结算!!");
					return;
				}
				if (isNaN(UnevenOrdNum)) {
					alert("检查患者医嘱账单金额失败不能结算!!");
					return;
				}
				if (eval(UnevenOrdNum) != 0) {
					alert("患者医嘱账单金额不平不能结算!!");
					return;
				}
				//患者医嘱账单数量为负数
				if ((BillNegativeNum == "") || (BillNegativeNum == "")) {
					alert("检查患者医嘱账单数量失败不能结算!!");
					return;
				}
				if (isNaN(BillNegativeNum)) {
					alert("检查患者医嘱账单数量失败不能结算!!");
					return;
				}
				if (eval(BillNegativeNum) != 0) {
					alert("患者医嘱账单数量为负数不能结算!!");
					return;
				}
			}
		}
	}

	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if (num == '1') {     //if (billednoobj.value!=Adm && billstatus!="Paid")
		//{  alert(t['02']);return; }
	}
	if (PatFeeConfirmFlag == "Y") {    //费用审核yyx
		var encmeth = DHCWebD_GetObjValue('getconfirmflag');
		var retval = cspRunServerMethod(encmeth, Adm);
		var confirmflagstr = retval.split("^");
		if (confirmflagstr[1] == "N") {
			alert(t['Confirm01']);
			return;
		}
	}
	var pay = amttopayobj.value;
	var deposit = depositobj.value;
	var patfee = totalamountobj.value;
	/*
	var encmeth = DHCWebD_GetObjValue('UpdatePatFee');
	var RetVal = cspRunServerMethod(encmeth,BillNo);
	var RetVal = RetVal.split("^");
	var Error = RetVal[0];
	if ((Error != 0)&&(Error != "1")){
		alert("更新费用表出错");
		return;
	}
	if (Error == "0"){   
		patfee = RetVal[1];
		deposit = depositobj.value;
		pay = (eval(patfee)-eval(deposit)).toFixed(2).toString(10);
	}
	*/
	var ybcardno = "";     //医保卡号
	var encmeth = DHCWebD_GetObjValue('SetPaybzclass');  //增加结算标志
	var getbzclassbz = cspRunServerMethod(encmeth, Adm, BillNo);

	//var lnk='udhcjfpay.csp?&Adm='+Adm+'&BillNo='+BillNo+'&Pay='+pay+'&Deposit='+deposit+'&pattype='+instype+'&patfee='+patfee+"&ybcardno="+ybcardno
	//websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');

	var str = 'dhcipbillcharge.main.csp';
	window.open(str, "_self");

	//+2015-3-11 hujunbin 链接到新住院收费
	//selectTabBar("Menu53617", "Menu54484");
}

function LinkBillDetail() {
	if ((BillNo == "") || (BillNo == " ")) {
		alert("请选择病人!!");
		return;
	}
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + BillNo;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function judge() {
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	return num;
}

function Bill() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	if (Adm != "") {
		var encmeth = DHCWebD_GetObjValue('getmotheradm');
		if (cspRunServerMethod(encmeth, Adm) == 'true') {
			alert("此病人为婴儿不允许做账单.");
			return;
		}
		var WshNetwork = new ActiveXObject("WScript.NetWork");
		var computername = WshNetwork.ComputerName;
		/*
		var myrtn = tkMakeServerCall("web.DHCIPMealWorkLoad","toHisBillByAdm",Adm);
		if (myrtn != "0"){
			alert("导入膳食费用错误! 错误代码：" + rtn);
			return;
		}else {
			alert("导入膳食费用成功!");
		}
		*/
		var encmeth = DHCWebD_GetObjValue('getbill');
		var num = cspRunServerMethod(encmeth, '', '', Adm, Guser, BillNo, computername);
		if (num == "AdmNull") {
			alert("就诊号不能为空.");
			return;
		}
		if (num == "PBNull") {
			alert("账单号为空,账单失败.");
			return;
		}
		if (num == "OrdNull") {
			alert("病人没有医嘱,不能账单");
			return;
		}
		if (num == '0') {
			billednoobj.value = Adm;
			alert(t['04']);
			//var Findobj = document.getElementById('Find');
			//Findobj.click()    //Lid 2010-07-09 账单成功后不刷新界面
			//Lid 2010-07-09 账单后重新更新结算数据
			UpdateFootData(BillNo);
		}
		if (num == '2') {
			alert(t['05'])
			return;
		}
		if (num != '0') {
			alert(t['06']);
		}
	}
}

function ReBill() {
	if (BillNo == "") {
		alert(t['57']);
		return;
	}
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	if (Adm != "") {
		var PBNum = tkMakeServerCall("web.UDHCJFBaseCommon", "JudgeBillNum", Adm);
		if (PBNum >= 2) {
			rtn = window.confirm("病人有两个未结算的账单,是否确认重新生成账单?");
			if (!rtn) {
				return;
			}
		}
		var encmeth = DHCWebD_GetObjValue('rebill');
		var num = cspRunServerMethod(encmeth, '', '', Adm, BillNo, Guser);
		if (num == '0') {
			alert(t['07']);
		}
		if (num == "ExtItmErr") {
			alert("账单中执行记录有附加的收费项目,不能重新生成账单.")
			return;
		}
		if (num != '0') {
			alert(t['08']);
		}
	}
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function LinkAddDeposit() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + Adm + '&deposittype=' + "";
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function LinkRefundDeposit() {
	if (Adm == "") {
		alert(t['03']);
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
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFRefundDeposit&Adm=' + Adm;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function LinkIntBill() {
	if (BillNo == " ") {
		alert("账单为空,不允许拆分账单.");
		return;
	}
	if (BillNo == "") {
		alert("账单为空,不允许拆分账单.");
		return;
	}
	if (billstatus == "Paid") {
		alert("此账单已结算,不允许拆分账单");
		return;
	}
	//此函数用途是某些类型的医保病人不能进行中途结算
	var InitPayflag = DoNotInitPay();
	if (InitPayflag == false) {
		alert(t['HXEY01']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if ((num == "") || (num == " ")) {
		num = 0;
	}
	if (isNaN(num)) {
		num = 0;
	}
	if (eval(num) > 1) {
		alert("病人有多个未结算账单不允许拆分账单!!")
		return;
	}
	//add hujunbin 15.1.14 中途结算时自动账单
	Bill();
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFIntPay&BillNo=' + BillNo;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function DelIntBill() {
	var truthBeTold = window.confirm(t['15']);
	if (!truthBeTold) {
		return
	}
	if (BillNo == "") {
		alert(t['01']);
		return
	}
	var encmeth = DHCWebD_GetObjValue('delbill');
	var num = cspRunServerMethod(encmeth, BillNo, Guser);
	if (num == '0') {
		alert(t['09']);
	}
	if (num != '0') {
		alert(t['10']);
		return;
	}
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function DelPay(lnk) {
	var truthBeTold = window.confirm(t['14']);
	if (!truthBeTold) {
		return;
	}
	if ((Adm == "") || (BillNo == "")) {
		alert(t['01']);
		return;
	}
	if (billstatus == "Bill") {
		alert(t['16']);
		return;
	}
	//判断患者是否能取消结算
	var encmeth = DHCWebD_GetObjValue('getpbflag');
	var pbflagstr = cspRunServerMethod(encmeth, BillNo);
	if (pbflagstr == "Abort") {
		alert(t['PbCancel01']);
		return;
	}
	if (pbflagstr == "QF") {
		alert(t['PbCancel02']);
		return;
	}
	if (pbflagstr == "PbNotPaid") {
		alert(t['PbCancel03']);
		return;
	}
	if (pbflagstr == "PbAlready") {
		alert(t['PbCancel04']);
		return;
	}
	if (pbflagstr == "TransErr") {
		var Flag = window.confirm("病人结算时转过预交金,是否确认取消结算,如果取消结算预交金会虚增.");
		if (!Flag) {
			return;
		} else {
			alert("请退掉中途结算转过的预交金");
		}
	}
	//调用医保组IPRevFootBack函数的医保病人
	var ReturnValue = TransIPRevFootBack(Guser, BillNo, Adm);
	if (ReturnValue < 0) {
		alert("医保取消结算失败.");
		return;
	}
	var invnoflag = "N";
	var invflag;
	var delpay = document.getElementById('delpay');
	if (delpay) {
		var encmeth = delpay.value;
	} else {
		var encmeth = '';
	}
	var str = cspRunServerMethod(encmeth, '', '', Adm, BillNo, Guser, RefFpPrtFlag, RefFpFlag);
	str = str.split("^");
	var num = str[0];
	var chprtrowid = str[3];
	var invflag = str[4];
	var chprt = str[5];
	if (num == 'null' && invflag == "Y") {
		alert(t['13']);
		return;
	}
	if (num == 'abort') {
		alert(t['PbCancel01']);
		return;
	}
	if (num == "QF") {
		alert(t['PbCancel02']);
		return;
	}
	if (num == "CloseAcountErr") {
		alert("此账单已经封帐,不允许取消结算.")
		return
	}
	if (num != '0') {
		alert(t['12']);
		return;
	}
	if (num == '0') {
		alert(t['11']);
	}
	if (chprt == "N") {
		return;
	}
	if (RefFpPrtFlag == "Y" && Tinvno != "" && chprt == "Y") {
		PrintFP(chprtrowid);
	}
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function getdata(value) {
	//modify 2006.2.28 by cx
	catedata = value.split("###");
	var mydata = catedata[0].split("&");
	for (i = 1; i < mydata.length; i++) {
		var tmpstrs = mydata[i];
		myData1 = tmpstrs.split("^");
		InPatCate[i - 1] = myData1;
	}
	if (catedata[1] != "") {
		var inpatdata = catedata[1].split("&");
		for (j = 1; j < inpatdata.length; j++) {
			var tmpstrs1 = inpatdata[j];
			var tmpstrs2 = tmpstrs1.split("^");
			InPatSubCate[j - 1] = tmpstrs2;
		}
	}
}

function PrintAdmInfo() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	if (Adm != "") {
		var encmeth = DHCWebD_GetObjValue('printadminfo');
		var str = cspRunServerMethod(encmeth, '', '', Adm);
		if (str != "") {
			AdmInfoPrint(str)
		}
	}
}

function gettype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Type_lookuphandler();
	}
}

function getloc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Loc_lookuphandler();
	}
}

function readcard_click() {
	//clearall();
	var rtn = ReadCardClickHandler();
	if (rtn) {
		var Findobj = document.getElementById('Find');
		Findobj.click();
	}
}

function getpatinfo1() {
	if ((papnoobj.value != "") || (patzynoobj.value != "")) {
		p1 = papnoobj.value;
		var Medicare = patzynoobj.value;
		var encmeth = DHCWebD_GetObjValue('getadm');
		if (cspRunServerMethod(encmeth, 'setpat_val', '', p1, Medicare) == "") {
			alert("没有此病人信息");
		}
	}
}

function FrameEnterkeyCode() {
	var e = window.event;
	switch (e.keyCode) {
	case 119:
		LinkBillDetail();
		break;
	case 118:
		clearall();
		break;
	case 119:
		var Findobj = document.getElementById('Find');
		Findobj.click();
		break;
	case 120:
		//LinkPay();    //2017-08-30 ZhYW 注释
		break;
	case 121:
		LinkAddDeposit();
		break;
	//case 123:
	case 117:  //和调试F12冲突  改成F6
		LinkRefundDeposit();
		break;
	}
}

///Lid
///2010-07-09
///账单成功后不刷新界面只更新结算数据
function UpdateFootData(BillNO) {
	//根据账单号,获取账单后的结算数据
	var CH2 = String.fromCharCode(2);
	var ExpStr = "";
	var SelRowObj = document.getElementById('Tbillstatusz' + SelectedRow);
	var payedFlag = "";
	if (SelRowObj.innerText === "Bill") {
		payedFlag = "B";
	} else {
		payedFlag = "P";
	}
	//未结算记录修改数据
	if (payedFlag === "B") {
		//押金$c(2)总金额^自付金额^折扣金额^记账金额
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatFeeByBillNO", BillNO, payedFlag, ExpStr);
		var tmpAry = rtn.split(CH2);
		var deposit = tmpAry[0];
		var patfeeInfo = tmpAry[1].split("^");
		var stAmt = tmpAry[2];
		depositobj.value = deposit;
		totalamountobj.value = patfeeInfo[1];
		amttopayobj.value = stAmt;
		if (eval(amttopayobj.value) < 0) {
			amttopayobj.style.color = "red";
		} else {
			amttopayobj.style.color = "black";
		}
		//更新选中记录的数据
		var SelRowObj = document.getElementById('Tdepositz' + SelectedRow);
		SelRowObj.innerText = deposit;
		var SelRowObj = document.getElementById('Ttotalamountz' + SelectedRow);
		SelRowObj.innerText = patfeeInfo[0];
		var SelRowObj = document.getElementById('Tpatientsharez' + SelectedRow);
		SelRowObj.innerText = patfeeInfo[1];
		//var SelRowObj = document.getElementById('Tdiscountamountz'+SelectedRow);
		//SelRowObj.value = patfeeInfo[2];    //Tdiscountamountz元素被隐藏
	}
}

///组件增加隐藏元素GetNotBillOrd,调用UDHCJFBaseCommon中的GetNotBillOrdAdm)
function GetNotBillOrd(Adm) {
	/*
	var NotBillOrdObj = document.getElementById('GetNotBillOrd');
	if (NotBillOrdObj) {
		var encmeth = NotBillOrdObj.value;
	} else {
		var encmeth = '';
	}
	var ReturnVal = cspRunServerMethod(encmeth,Adm);
	*/
	var ReturnVal = tkMakeServerCall("web.UDHCJFBaseCommon", "GetNotBillOrd", Adm);
	return ReturnVal;
}

///补打发票
function ReprintFP() {
	var Guser = session['LOGON.USERID'];
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	if ((!Tinvno) || (Tinvno == " ")) {
		alert("未选择补打发票的信息或没有补打信息");
		return;
	} else {
		var invrtn = tkMakeServerCall("web.UDHCJFPRINTINV", "GetInvflagByInvno", Tinvno, Guser);
		var prtinvflag = invrtn.split("^")[0];
		var prtinvrowid = invrtn.split("^")[1];
		var InvReasonDR = invrtn.split("^")[2];
		GetXMLName(InvReasonDR);
		if (prtinvflag != 1) {
			alert("此发票不能重打");
			return;
		} else {
			var selecttrue = window.confirm("确定要重打发票？");
			if (!selecttrue) {
				return;
			}
			var prtinvrowid = prtinvrowid + "#" + "R"; //增加补打标志
			PrintFP(prtinvrowid);
		}
	}
}

function GetXMLName(InvReasonDR) {
	if ((Adm == "") || (BillNo == "")) {
		return;
	}
	if ((Tinvno == "") || (Tinvno == " ")) {
		return;
	}
	GetAdmReaNationCodeByAdm(Adm);
	var XMLName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetInvXMLName", AdmReasonId);
	if (XMLName == "") {
		DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	} else {
		DHCP_GetXMLConfig("InvPrintEncrypt", XMLName);
	}
}

function GetAdmReaNationCodeByAdm(Adm) {
	var encmeth = DHCWebD_GetObjValue('GetAdmReaNationCode');
	var GetAdmReasonStr = cspRunServerMethod(encmeth, Adm);
	var GetAdmReasonStrDetail = GetAdmReasonStr.split("^");
	AdmReasonId = GetAdmReasonStrDetail[0];
	AdmReasonNationCode = GetAdmReasonStrDetail[1];
}

///按医嘱拆分账单
function LinkIntBillDetail() {
	if (BillNo == " " || BillNo == "") {
		alert("此病人没有账单,不能拆分账单");
		return;
	}
	if (billstatus == "Paid") {
		alert("此账单已经结算,不能拆分账单");
		return;
	}
	//此函数用途是某些类型的医保病人不能进行中途结算
	var InitPayflag = DoNotInitPay();
	if (InitPayflag == false) {
		alert(t['HXEY01']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if ((num == "") || (num == " ")) {
		num = 0;
	}
	if (isNaN(num)) {
		num = 0;
	}
	if (eval(num) > 1) {
		alert("病人有多个未结算账单不允许拆分账单!!");
		return;
	}
	var RegNo = RegistrationNoobj.value;
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBILLOEORIItemGroup&EpisodeID=' + Adm + '&BillNo=' + BillNo + '&Guser=' + Guser;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function CloseAcount_click() {
	if ((Adm == "") || (Adm == " ")) {
		alert("请选择需封账的账单");
		return;
	}
	if ((BillNo == "") || (BillNo == " ")) {
		alert("请选择需封账的账单");
		return;
	}
	if (RefundFlag == "B") { //yyx 2009-09-24 bug修改
		alert("此账单已经红冲,不允许封账");
		return;
	}
	Bill();
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if (num == '1') {
		if ((billednoobj.value != Adm) && (billstatus != "Paid")) {
			alert(t['02']);
			return;
		}
	}
	/*
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth,'','',Adm);
	if (num == '1'){
		if ((billednoobj.value != Adm) && (billstatus!="Paid")) {
			alert(t['02']);
			return;
		}
	}
	*/

	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var RetCode = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "PaidPatientbill", Adm, BillNo, Guser, computername);
	if (RetCode == "0") {
		alert("封账成功.");
		return;
	} else {
		alert("封账失败:"+RetCode);
		return;
	}
}

function GetPaidCAcountFlag() {
	if (Adm == "" || BillNo == "") {
		return "N";
	}
	var RetCode = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "GetPaidCAcountFlag", BillNo);
	return RetCode;
}

function UnCloseAcount_click() {
	if ((Adm == "") || (Adm == " ")) {
		alert("请选择需取消封账的账单");
		return;
	}
	if ((BillNo == "") || (BillNo == " ")) {
		alert("请选择需取消封账的账单");
		return;
	}
	if (RefundFlag == "B") {
		alert("此账单已经红冲,不允许取消封账");
		return;
	}
	var PaidCAcountFlag = GetPaidCAcountFlag();
	if (PaidCAcountFlag != "Y") {
		alert("此账单不需取消封帐");
		return;
	}
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var RetCode = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "UnCloseAcount", Adm, BillNo, Guser, computername);
	if (RetCode == "0") {
		alert("取消封帐成功");
		var Findobj = document.getElementById('Find');
		Findobj.click();
		//Lid 2010-07-09 账单成功后不刷新界面
		return;
	}else {
		if (RetCode == "AdmNull") {
			alert("请选择需取消封账的账单");
			return;
		} else if (RetCode == "ErrNull") {
			alert("此账单不需取消封帐");
			return;
		} else if (RetCode == "AlreadyPRT") {
			alert("此账单已经结算不能取消封帐");
			return;
		}else if (RetCode == "CofimOK") {
			alert("已经审核,不能取消封账.");
			return;
		} else {
			alert("取消封帐失败,错误代码:" + RetCode);
			return;
		}
	}
}

//hujunbin 选择头菜单
function selectTabBar(preId, newId) {
	if (window.parent) {
		var PreBarObj = window.parent.document.getElementById(preId);
		var menuBarObj = window.parent.document.getElementById(newId);
		if (menuBarObj) {
			var href = menuBarObj.getAttribute("jshref");
			var target = menuBarObj.getAttribute("target");
			var blankOpt = menuBarObj.getAttribute("blankOpt");
			if (href == "#") {
				event.preventDefault();
				event.stopPropagation();
				return false;
			}
			if (menuBarObj) {
				PreBarObj.getAttribute("style")["border-color"] = "";
				PreBarObj.getAttribute("style")["color"] = "";
				PreBarObj.getAttribute("style")["background"] = "";
			}
			if (menuBarObj) {
				//menuBarObj.getAttribute("style")["border-color"] = "#b7d2ff";
				//menuBarObj.getAttribute("style")["color"] = "#ffffff";
				//menuBarObj.getAttribute("style")["background"] = "#1369c0";
			}
			window.location.href = href;
		}
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-09-13
*/
function clearLoc() {
	var loc = websys_$V("Loc");
	if (loc == ""){
		DHCWebD_SetObjValueB("locid", "");
	}
}

function clearType() {
	var type = websys_$V("Type");
	if (type == ""){
		DHCWebD_SetObjValueB("typeid", "");
	}
}

document.body.onload = BodyLoadHandler;
