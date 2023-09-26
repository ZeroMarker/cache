/// UDHCJFZYDB.js

var Adm;
var Guser, usercode, username, username1;
var RegNo;
var path;
var regnoobj;
var nameobj, patname1;
var admobj;
var moneyobj, money1;
var warrantorobj, warrantor1;
var remarkobj, remark1;
var startdateobj, startdate1;
var enddateobj, enddate1;
var addobj;
var printobj;
var findobj;
var SelectedRow = "-1";
var typeobj;
var type, type1;
var papno;
var updateobj;
var getupdateobj;
var adm1, regno1, status1, status2;
var rowid1;
var getmoney;
var CardNoobj, readcardobj;
var m_CardNoLength = 0;
var m_SelectCardTypeDR = "";
var Today = "", OldSelStDate = "";
var PatDepositObj, PatFeeObj, InsuFeeObj, PatRemainObj, PatNotBillFeeObj;
var admdeptObj;

function BodyLoadHandler() {
	ValidateDocumentData();
	rowid1 = "";
	regnoobj = websys_$('RegNo');
	nameobj = websys_$('name');
	admobj = websys_$('Adm');
	moneyobj = websys_$('money');
	if (moneyobj) {
		moneyobj.onkeypress = money_KeyPress;
	}
	warrantorobj = websys_$('warrantor');
	remarkobj = websys_$('remark');
	startdateobj = websys_$('startdate');
	enddateobj = websys_$('enddate');
	addobj = websys_$('Add');
	printobj = websys_$('Print');
	updateobj = websys_$('update');
	PatDepositObj = websys_$('PatDeposit');
	PatFeeObj = websys_$('PatFee');
	InsuFeeObj = websys_$('InsuFee');
	PatRemainObj = websys_$('PatRemain');
	PatNotBillFeeObj = websys_$('PatNotBillFee');     //待记账费用
	admdeptObj = websys_$('admdept');

	admobj.readOnly = true;
	PatDepositObj.readOnly = true;
	InsuFeeObj.readOnly = true;
	PatFeeObj.readOnly = true;
	PatRemainObj.readOnly = true;
	PatNotBillFeeObj.readOnly = true;

	Guser = session['LOGON.USERID'];
	usercode = session['LOGON.USERCODE'];
	username = session['LOGON.USERNAME'];

	regnoobj.onkeydown = getpat;
	addobj.onclick = add_click;
	updateobj.onclick = update_click;
	printobj.onclick = print_click;

	var PrtDBDetail = websys_$("PrtDBDetail");
	if (PrtDBDetail) {
		PrtDBDetail.onclick = PrtDBDetail_Click;
	}
	getenddate();
	getpath();
	var clearobj = websys_$('clear');
	clearobj.onclick = getclear;
	typeobj = websys_$('type');
	type = typeobj.value;
	CardNoobj = websys_$('cardno');
	if (CardNoobj) {
		if (CardNoobj.type != "Hiden") {
			CardNoobj.onkeydown = RCardNo_KeyDown;
		}
	}

	readcardobj = websys_$('readcard');
	if (readcardobj)
		readcardobj.onclick = ReadHFMagCard_Click;

	/*
	var PrtDBDetail = websys_$("PrtDBDetail");
	if (PrtDBDetail) {
		PrtDBDetail.onclick = PrtDBDetail_Click;
	}
	if (type == "E") {
		readcardobj.style.visibility = "visible";
		readcardobj.onclick = readcardinfo;
		//warrantorobj.value = username;
		//warrantorobj.readOnly = true;
	}
	if (type == "I"){
		readcardobj.style.visibility = "hidden";
		//CardNoobj.style.visibility = "hidden";
	}
	*/
	var myobj = websys_$("CardTypeDefine");
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
	}
	CardTypeDefine_OnChange();
	var obj = websys_$('Audit');
	if (obj) {
		obj.onclick = AuditWarr;
	}
	var objStatus = websys_$('warrstatus');
	objStatus.onkeydown = function () {
		return false;
	}
	websys_setfocus('RegNo');
}

function getpath() {
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}

function getenddate() {
	var encmeth = DHCWebD_GetObjValue('gettoday');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	startdateobj.value = value;
	Today = value;
	enddateobj.value = "";
}

function add_click() {
	Adm = admobj.value;
	if (typeobj.value == "") {
		typeobj.value = "E";
	}
	if ((typeobj.value == "I") && (Adm == "")) {
		alert("请选择就诊记录");
		return;
	}
	patname1 = nameobj.value;
	warrantor1 = warrantorobj.value;
	money1 = moneyobj.value;
	startdate1 = startdateobj.value;
	enddate1 = enddateobj.value;
	remark1 = remarkobj.value;
	username1 = username;
	type1 = typeobj.value;
	papno = regnoobj.value;
	/*
	if (patname1 == "" || warrantor1 == "" || money1 == "" || startdate1 == "" || enddate1 == "") {
		alert(t['03']);
		return;
	}
	*/
	if (patname1 == "" || startdate1 == "") {
		alert(t['03']);
		return;
	}
	/*
	if (type1 == "") {
		type1 = "I";
	}
	*/
	if (type1 == "") {
		type1 = "E";
	}
	if (type1 == "") {
		alert(t['04']);
		return;
	}
	if ((type1 != "I") && (enddateobj.value == "")) {
		alert("急诊绿色通道需选择结束日期");
		return;
	}
	if (warrantor1 == "") {
		alert("担保人不能为空");
		return;
	}
	if (money1 == "") {
		alert("担保金额不能为空");
		return;
	}
	if (isNaN(money1) || (parseFloat(money1) <= 0)) {
		alert("担保金额须为有效正数！");
		DHCWeb_setfocus("money");
		return;
	}
	var status = "";
	var warrStatus = DHCWebD_GetObjValue('warrstatus');
	if (warrStatus == t['10']) {
		status = "Y";
	}
	if (warrStatus == t['11']) {
		status = "N";
	}
	if (warrStatus == "") {
		status = "Y";
	}
	p1 = Adm + "&" + startdateobj.value + "&" + enddateobj.value + "&" + warrantorobj.value + "&" + moneyobj.value + "&" + status + "&" + remarkobj.value + "&" + Guser + "&" + type1 + "&" + papno;
	var encmeth = DHCWebD_GetObjValue('getadd');
	var rtn = cspRunServerMethod(encmeth, '', '', p1);
	if (rtn == '0') {
		alert(t['01']);
		var find1obj = websys_$('Find');
		if (find1obj) {
			find1obj.click();
		}
		//printZYDB();
	} else if (rtn == 'DateErr1') {
		alert("开始日期不能大于结束日期");
	} else if (rtn == 'DateErr2') {
		alert("开始日期不能小于当前日期");
	} else if (rtn == '1') {
		alert(t['05']);
	} else if (rtn == '2') {
		alert(t['06']);
	} else if (rtn == '3') {
		alert("超过担保额度,担保失败");
	} else {
		alert(t['02'] + ', 错误代码:' + rtn);
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	Objtbl = websys_$("tUDHCJFZYDB");
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (selectrow != SelectedRow) {
		patname1 = DHCWeb_GetColumnData("Tpatname", selectrow);
		patname1 = websys_trim(patname1);
		nameobj.value = patname1;
				
		warrantor1 = DHCWeb_GetColumnData("Twarrantor", selectrow);
		warrantor1 = websys_trim(warrantor1);
		DHCWebD_SetObjValueB("warrantor", warrantor1);
		
		money1 = DHCWeb_GetColumnData("Tmoney", selectrow);
		money1 = websys_trim(money1);
		DHCWebD_SetObjValueB("money", money1);
		
		startdate1 = DHCWeb_GetColumnData("Tstartdate", selectrow);
		startdate1 = websys_trim(startdate1);
		startdateobj.value = startdate1;
		
		enddate1 = DHCWeb_GetColumnData("Tenddate", selectrow);
		enddate1 = websys_trim(enddate1);
		enddateobj.value = enddate1;
		
		username1 = DHCWeb_GetColumnData("Tuser", selectrow);
		username1 = websys_trim(username1);
		
		remark1 = DHCWeb_GetColumnData("Tremark", selectrow);
		remark1 = websys_trim(remark1);
		remarkobj.value = remark1;
		
		rowid1 = DHCWeb_GetColumnData("Trowid", selectrow);
		rowid1 = websys_trim(rowid1);
		
		adm1 = DHCWeb_GetColumnData("Tadmid", selectrow);
		adm1 = websys_trim(adm1);
		admobj.value = adm1;
		
		regno1 = DHCWeb_GetColumnData("Tregno", selectrow);
		regno1 = websys_trim(regno1);
		regnoobj.value = regno1;
		
		status1 = DHCWeb_GetColumnData("Tstatus", selectrow);
		status1 = websys_trim(status1);
		DHCWebD_SetObjValueB("warrstatus", status1);

		admdept1 = DHCWeb_GetColumnData("Tdeptcode", selectrow);
		status1 = websys_trim(status1);
		DHCWebD_SetObjValueB("admdept", admdept1);
		/*
		if (typeobj.value == "E"){
			var encmeth = DHCWebD_GetObjValue('getepmoney');
			var p1 = regno1;
			var p2 = typeobj.value;
			getmoney = cspRunServerMethod(encmeth,'','',p1,p2)
			moneyobj.value = getmoney;
			money1 = getmoney;
		}
		*/
		SelectedRow = selectrow;
	} else {
		patname1 = "";
		warrantor1 = "";
		money1 = "";
		startdate1 = "";
		enddate1 = "";
		remark1 = "";
		username1 = "";
		SelectedRow = "-1";
		regnoobj.value = "";
		admobj.value = "";
		nameobj.value = "";
		enddateobj.value = "";
		remarkobj.value = "";
		DHCWebD_SetObjValueB("money", "");
		DHCWebD_SetObjValueB("warrstatus", "");
		DHCWebD_SetObjValueB("warrantor", "");
		DHCWebD_SetObjValueB("admdept", "");
		rowid1 = "";
	}
	getDepositFeeByAdm();
	websys_$('money').disabled = true;
	websys_$('warrantor').disabled = true;
	//websys_$('RegNo').disabled = true;
	//websys_$('name').disabled = true;
	//websys_$('admdept').disabled = true;
}

function print_click() {
	if (SelectedRow > 0) {
		if (status1 == t['10']) {
			printZYDB();
		}
		if (status1 == t['11']) {
			alert(t['15']);
			return;
		}
	}
}

function getpat() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		getpatinfo();
	}
}

function getpatinfo() {
	if (regnoobj.value != "") {
		p1 = regnoobj.value;
		var p2 = typeobj.value;
		var encmeth = DHCWebD_GetObjValue('getadm');
		if (cspRunServerMethod(encmeth, 'setpat_val', '', p1, p2) == '1') {
		}
	}
}

function setpat_val(value) {
	var val = value.split("^");
	if (val[1] == "") {
		alert("无此病人.");
		return;
	}
	regnoobj.value = val[0];
	nameobj.value = val[1];
	admdeptObj.value = "";
	if ((typeobj.value == "I") || (typeobj.value == "")) {
		admobj.value = val[2];
		Adm = admobj.value;
		PatDepositObj.value = val[4];
		PatFeeObj.value = val[5];
		InsuFeeObj.value = val[6];
		PatRemainObj.value = val[7];
		PatNotBillFeeObj.value = val[8];
		moneyobj.value = val[9];
		admdeptObj.value = val[10];
	}
	if (typeobj.value == "E") {
		if (eval(val[3]) == 0) {
			//moneyobj.value = 5000.00;
			//moneyobj.value = 2000.00;
		} else {
			moneyobj.value = val[3];
		}
	}
	var find1obj = websys_$('Find');
	if (find1obj) {
		find1obj.click();
	}
}

function LookUppat(str) {
	var obj = websys_$('Adm');
	var tem = str.split("^");
	obj.value = tem[0];
	regnoobj.value = tem[4];
	nameobj.value = tem[5];
	var admdeptobj = websys_$('admdept');
	admdeptobj.value = tem[2];
	getDepositFeeByAdm();
	var find1obj = websys_$('Find');
	if (find1obj) {
		find1obj.click();
	}
}

function getstatus(str) {
	var myAry = str.split("^");
	obj.value = myAry[0];
	DHCWebD_SetObjValueB("warrstatus", myAry[0]);
}

function update_click() {
	type1 = typeobj.value;
	/*
	if (patname1 == "" || warrantor1 == "" || money1 == "" || startdate1 == "" || enddate1 == "") {
		alert(t['03']);
		return;
	}
	*/
	if (type1 == "") {
		type1 = "I"
	}
	if (type1 == "") {
		alert(t['04']);
		return;
	}
	if (rowid1 == "") {
		alert(t['14']);
		return;
	}
	var status = "";
	var warrStatus = DHCWebD_GetObjValue('warrstatus');
	if (warrStatus == t['10']) {
		status = "Y";
	}
	if (warrStatus == t['11']) {
		status = "N";
	}
	if (warrStatus == "") {
		status = "Y";
	}
	var remarkstr = DHCWebD_GetObjValue('remark');
	/*
	if (OldSelStDate != startdateobj.value){
		var myrtn = window.confirm("担保开始日期发生变化,是否确认修改?");
		if (!myrtn){
			return myrtn;
		}
	}
	*/
	if (startdateobj.value == "") {
		alert("请选择开始日期.");
		return;
	}
	p1 = startdateobj.value + "&" + enddateobj.value + "&" + warrantorobj.value + "&" + moneyobj.value + "&" + status + "&" + Guser + "&" + type1 + "&" + regno1 + "&" + rowid1 + "&" + remarkstr;
	var encmeth = DHCWebD_GetObjValue('getupdate');
	var rtn = cspRunServerMethod(encmeth, '', '', p1);
	if (rtn == '0') {
		alert(t['08']);
		var find1obj = document.getElementById('Find');
		if (find1obj) {
			find1obj.click();
		}
	} else if (rtn == '3') {
		alert(t['12']);
	} else if (rtn == '4') {
		alert(t['13']);
	} else if (rtn == 'DateErr') {
		alert("开始日期不能大于结束日期");
	} else {
		alert(t['09'] + ', 错误代码:' + rtn);
	}
}

function getclear() {
	regnoobj.value = "";
	admobj.value = "";
	nameobj.value = "";
	//moneyobj.value = "";
	CardNoobj.value = "";
	DHCWebD_SetObjValueB("warrstatus", "");
	DHCWebD_SetObjValueB("admdept", "");
	getenddate();
	type = typeobj.value;
	if (type == "E") {
		warrantorobj.value = username;
		warrantorobj.readOnly = true;
	}
	if (type == "I") {
		warrantorobj.value = "";
		warrantorobj.readOnly = false;
	}
	/*
	var find1obj = websys_$('Find');
	if (find1obj) {
		find1obj.click();
	}
	*/
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFZYDB&type=" + type;
}

function readcardinfo() {
	var cardstr = DHCACC_GetAccInfo();
	var cardstr1 = cardstr.split("^");
	if (eval(cardstr1[0]) == 0) {
		regnoobj.value = cardstr1[5];
		CardNoobj.value = cardstr1[1];
		if (regnoobj.value != "") {
			p1 = regnoobj.value;
			var p2 = typeobj.value;
			var encmeth = DHCWebD_GetObjValue('getadm');
			if (cspRunServerMethod(encmeth, 'setpat_val', '', p1, p2) == '1') {}
		}
	} else if (eval(cardstr1[0] == -200)) {
		alert(t['jst01']);
		return;
	} else if (eval(cardstr1[0]) == -201) {
		alert(t['jst02']);
		return;
	}
}

function PrtDBDetail_Click() {
	var job = document.getElementById("job").value;
	var Guser = session['LOGON.USERID'];
	var gusername = session['LOGON.USERNAME'];
	var encmeth = DHCWebD_GetObjValue('HPrtDBDetail');
	var DailyPrintInfo = cspRunServerMethod(encmeth, job, Guser);
	if ((DailyPrintInfo == "") || (DailyPrintInfo == null)) {
		alert("没有数据, 不能打印");
		return;
	}
	getpath();
	var Template = path + "PatzyDBSummary.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	xlApp.visible = true;
	var date = new Date();
	var TodayDate = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
	var TodayTime = date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	stdate = document.getElementById("startdate").value;
	enddate = document.getElementById("enddate").value;
	stdate1 = stdate.split("/");
	enddate1 = enddate.split("/");
	stdate1 = stdate1[2] + "-" + stdate1[1] + "-" + stdate1[0];
	enddate1 = enddate1[2] + "-" + enddate1[1] + "-" + enddate1[0];
	xlsheet.cells(2, 1).value = "统计时间范围:" + stdate1 + "-" + enddate1;

	var DailyPrintInfo = DailyPrintInfo.split("#");
	var DailyLen = eval(DailyPrintInfo.length);
	var sum = 0;
	var column = 0;
	for (i = 0; i < DailyLen; i++) {
		var Daily = DailyPrintInfo[i].split("^");
		for (var j = 0; j < Daily.length; j++) {
			xlsheet.cells(i + 4, j + 1).value = Daily[j];
		}
		sum = eval(sum) + eval(Daily[5]);
		column = Daily.length;

	}
	xlsheet.Range("A" + (5 + DailyLen) + ":K" + (5 + DailyLen)).MergeCells = true;
	xlsheet.cells(5 + DailyLen, 1).value = "担保金额合计:" + sum;
	xlsheet.Cells(5 + DailyLen, 1).HorizontalAlignment = 2;
	xlsheet.Range("A" + (6 + DailyLen) + ":K" + (6 + DailyLen)).MergeCells = true;
	xlsheet.cells(6 + DailyLen, 1).value = "打印日期:" + TodayDate + " " + TodayTime + "    收款员姓名: " + gusername;
	xlsheet.Cells(6 + DailyLen, 1).HorizontalAlignment = 4;
	AddGrid1(xlsheet, 3, 1, 5 + DailyLen, column);
	xlsheet.PrintPreview();
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

function AddGrid1(objSheet, tRow, tCol, xlsTop, xlsLeft) {
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(tRow, tCol)).Borders(1).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(tRow, tCol)).Borders(2).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(tRow, tCol)).Borders(3).LineStyle = 1;
	objSheet.Range(objSheet.Cells(xlsTop, xlsLeft), objSheet.Cells(tRow, tCol)).Borders(4).LineStyle = 1;
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("cardno");
		if (myobj) {
			myobj.readOnly = false;
		}
		DHCWeb_DisBtnA("readcard");
	} else {
		var myobj = document.getElementById("cardno");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("readcard");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("cardno");
	} else {
		DHCWeb_setfocus("readcard");
	}
	m_CardNoLength = myary[17];
}

function ValidateDocumentData() {
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		var obj = document.getElementById("RegNo");
		obj.value = myary[5];
		var obj = document.getElementById("cardno");
		obj.value = myary[1];
		getpatinfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		var obj = document.getElementById("RegNo");
		obj.value = myary[5];
		getpatinfo();
		break;
	default:
		//alert("");
	}
}

function AuditWarr() {
	if (SelectedRow < 1) {
		alert("请选择需要审核的数据");
		return;
	}
	var AuditFlag;
	if (window.event.srcElement.name == "Audit") {
		AuditFlag = "Y"
	}
	if (window.event.srcElement.name == "AuditCancle") {
		AuditFlag = "N"
	}
	var warrdr = document.getElementById('Trowidz' + SelectedRow).innerText;
	if (warrdr == "") {
		alert("请选择需要审核的数据");
		return;
	}
	var money = DHCWebD_GetObjValue('money');
	var val = warrdr + "^" + session['LOGON.USERID'] + "^" + AuditFlag + "^" + money;
	var encmeth = DHCWebD_GetObjValue('GetAuditing');
	var rtn = cspRunServerMethod(encmeth, val);
	if (rtn == "-1") {
		alert("担保记录不存在,请重新选择");
		return;
	}
	if (rtn == "-2") {
		alert("此担保记录已经是您希望的状态");
		return;
	}
	/*
	if (rtn == "0") {
		alert("操作成功");
		return;
	}
	*/
	if (rtn == "0") {
		alert("操作成功");
		getclear();
		return
	}

}

function SetCardNOLength() {
	var obj = document.getElementById('cardno');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
		var myCardobj = document.getElementById('cardno');
		if (myCardobj) {
			myCardobj.value = obj.value;
		}
	}
}

function RCardNo_KeyDown() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13)) {
		var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("cardno");
		if (myCardNo == "") {
			return;
		}
		var mySecurityNo = "";
		//var myrtn = DHCACC_GetAccInfo();
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		//alert(myary);
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj = document.getElementById("RegNo");
			obj.value = myary[5];
			var obj = document.getElementById("cardno");
			obj.value = myary[1];
			getpatinfo();
			break;
		case "-200":
			//alert(t["-200"]);
			break;
		case "-201":
			var obj = document.getElementById("RegNo");
			obj.value = myary[5];
			getpatinfo();
			break;
		default:
			//alert("");
		}
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-09-14
*/
function getDepositFeeByAdm(){
	var adm = admobj.value;
	var type = typeobj.value;
	if ((adm == "")||(type == 'E')){
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetDepositFeeByAdm", adm);
	var myAry = rtn.split('^');
	PatDepositObj.value = myAry[0];
	PatFeeObj.value = myAry[1];
	InsuFeeObj.value = myAry[2];
	PatRemainObj.value = myAry[3];
	PatNotBillFeeObj.value = myAry[4];
}

/**
* Creator: ZhYW
* CreatDate: 2018-02-24
*/
function money_KeyPress(e) {
	var key = websys_getKey(e);
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

document.body.onload = BodyLoadHandler;
