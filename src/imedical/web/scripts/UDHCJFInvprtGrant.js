/// UDHCJFInvprtGrant.js

var typeobj, lquserobj;
var typestatus;
var m_AmtMRowID = "";
var returnrowid;
var SelectedRow = 0;
	
function BodyLoadHandler() {
	typestatus = "0";
	var obj = document.getElementById('Add');
	if (obj) {
		obj.onclick = Add_Click;
	}
	var obj = document.getElementById('BtnReturn');
	if (obj) {
		obj.onclick = Return_Click;
	}
	var numobj = document.getElementById('number');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	typeobj = document.getElementById('type');
	/*
	if (typeobj) {
		typeobj.readOnly = true;
	}
	*/
	lquserobj = document.getElementById('lquser');
	/*
	if (lquserobj) {
		lquserobj.readOnly = true;
	}
	*/
	var obj = document.getElementById("startno");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("stdate1");
	if (obj) {
		obj.onkeydown = getstdate;
	}
	if (obj.value == "") {
		getdate();
	}
	var obj = document.getElementById("enddate1");
	if (obj) {
		obj.onkeydown = getenddate;
	}
	if (obj.value == "") {
		getdate();
	}
	if (typestatus == "1") {
		getmyid();
	}
	var obj = document.getElementById("Find");
	if (obj) {
		obj.onclick = find_OnClick;
	}
	var invprtFlagObj = document.getElementById("invprtFlag");
	if (invprtFlagObj) {
		invprtFlagObj.options[0] = new Option("全部", "All");
		invprtFlagObj.options[1] = new Option("可用", "Y");
		invprtFlagObj.options[2] = new Option("已用完", "N");
		invprtFlagObj.options[3] = new Option("待用", "");
		invprtFlagObj.options[4] = new Option("已核销", "Confirm");
		invprtFlagObj.multiple = false;
		invprtFlagObj.size = 1;
		invprtFlagObj.onchange = invprtFlag_OnChange;
		if (websys_$("currentInvprtFlag")) {
			if (websys_$("currentInvprtFlag").value) {
				invprtFlagObj.selectedIndex = websys_$("currentInvprtFlag").value;
			} else {
				invprtFlagObj.selectedIndex = 0;
			}
		}
	}
	var myobj = document.getElementById("Title");
	if (myobj) {
		myobj.readOnly = true;
	}
	var obj = document.getElementById("BtnConfirm");
	if (obj) {
		obj.onclick = confirmInvprt_Click;
	}
	//typeobj.onkeydown = gettype;
	var obj = websys_$("PrintInvoice"); //add by wanghc 090826
	if (obj) {
		obj.onclick = PrintInvoice;
	}
	var obj = websys_$("SelReceiptsNum");
	if (obj) {
		obj.onclick = selReceiptsNum_Click;
	}
	lquserobj = document.getElementById("lquser");
	lquserobj.onkeydown = getuser;
	getinvgrantmax();
}

function getinvgrantmax() {
	var p1 = typeobj.value;
	if (p1 == "") {
		return;
	}
	var HospDr = session['LOGON.HOSPID'];
	var encmeth = DHCWebD_GetObjValue('getstartno');
	if (cspRunServerMethod(encmeth, 'setstartno_val', '', p1, HospDr) == '1') {}
}

function getmyid() {
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "type";
		var typeobj1 = document.getElementById(imgname);
		typeobj1.style.display = "none";
		typeobj.readOnly = true;
	}
}

function getdate() {
	var encmeth = DHCWebD_GetObjValue('today');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	var enddate1 = document.getElementById('enddate1');
	var enddate = document.getElementById('enddate');
	var stdate1 = document.getElementById('stdate1');
	var stdate = document.getElementById('stdate');
	today = value;
	curdate = value;
	var curdate1 = value;
	var str = curdate.split("/");
	curdate = str[2] + "-" + str[1] + "-" + str[0];
	if (enddate1.value == "") {
		enddate1.value = curdate;
		enddate.value = curdate1;
	}
	if (stdate1.value == "") {
		stdate1.value = curdate;
		stdate.value = curdate1;
	}
	checkdate();
}

function checkdate() {
	var end1obj = document.getElementById('enddate1');
	var endobj = document.getElementById('enddate');
	var enddate1 = document.getElementById('enddate1').value;
	var stdate1 = document.getElementById('stdate1').value;
	if ((enddate1 != "") & (stdate1 != "")) {
		var date = enddate1.split("-");
		var date1 = stdate1.split("-");
		if (eval(date1[0]) > eval(date[0])) {
			end1obj.value = "";
			end1obj.value = "";
			alert(t['07']);
			return;
		}
		if (eval(date1[1]) > eval(date[1])) {
			end1obj.value = "";
			end1obj.value = "";
			alert(t['07']);
			return;
		}
		if (eval(date1[2]) > eval(date[2])) {
			end1obj.value = "";
			end1obj.value = "";
			alert(t['07']);
			return;
		}
	}
}

function setstartno_val(value) {
	//alert(value);
	var val = value.split("^");
	if (val[3] == "") {
		var maxno = document.getElementById('maxno');
		if (maxno) {
			maxno.value = "";
			maxno.readOnly = true;
		}
		var startno = document.getElementById('startno');
		if (startno) {
			startno.value = "";
		}
		alert(t['01']);
		return;
	}
	m_AmtMRowID = val[3];
	var startno = document.getElementById('startno');
	startno.value = val[2];
	var EndNoObj = document.getElementById('endno');
	var title = document.getElementById('Title');
	title.value = val[4];
	var maxno = document.getElementById('maxno');
	if (maxno) {
		maxno.value = val[1];
		EndNoObj.value = val[1];
		maxno.readOnly = true;
	}
	if (val[2] == "") {
		websys_setfocus('startno');
	} else {
		websys_setfocus('number');
	}
}

function getstdate() {
	var key = websys_getKey(e);
	if (key == 13) {
		var mybirth = DHCWebD_GetObjValue("stdate1");
		if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsInvalid';
			websys_setfocus("stdate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsvalid';
		}
		if ((mybirth.length == 8)) {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
			DHCWebD_SetObjValueA("stdate1", mybirth);
		}
		var myrtn = DHCWeb_IsDate(mybirth, "-");
		if (!myrtn) {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsInvalid';
			websys_setfocus("stdate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("stdate1");
			obj.className = 'clsvalid';
		}
		checkdate();
		var obj = document.getElementById("stdate1");
		var str1 = obj.value.split("-");
		var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
		var stdateobj = document.getElementById("stdate");
		stdateobj.value = str2;
		websys_setfocus('enddate1');
	}
}

function getenddate() {
	var key = websys_getKey(e);
	if (key == 13) {
		var mybirth = DHCWebD_GetObjValue("enddate1");
		if ((mybirth == "") || ((mybirth.length != 8) && ((mybirth.length != 10)))) {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsInvalid';
			websys_setfocus("enddate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsvalid';
		}
		if ((mybirth.length == 8)) {
			var mybirth = mybirth.substring(0, 4) + "-" + mybirth.substring(4, 6) + "-" + mybirth.substring(6, 8);
			DHCWebD_SetObjValueA("enddate1", mybirth);
		}
		var myrtn = DHCWeb_IsDate(mybirth, "-");
		if (!myrtn) {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsInvalid';
			websys_setfocus("enddate1");
			return websys_cancel();
		} else {
			var obj = document.getElementById("enddate1");
			obj.className = 'clsvalid';
		}
		checkdate();
		var obj = document.getElementById("enddate1");
		var str1 = obj.value.split("-");
		var str2 = str1[2] + "/" + str1[1] + "/" + str1[0];
		var enddateobj = document.getElementById("enddate");
		enddateobj.value = str2;
		websys_setfocus('find');
	}
}

function Add_Click() {
	var stnoobj = document.getElementById('startno');
	if (stnoobj) {
		var startno = stnoobj.value;
	}
	var endnoobj = document.getElementById('endno');
	if (endnoobj) {
		var endno = endnoobj.value;
	}
	var maxno = document.getElementById('maxno');
	if (maxno) {
		var buyend = maxno.value;
	}
	var title = document.getElementById('Title');
	if (title) {
		var title = title.value;
	}
	var lquserobj = document.getElementById('lquser');
	if (lquserobj) {
		var lquser = lquserobj.value;
	}
	var lquseridobj = document.getElementById('lquserid');
	if (lquseridobj) {
		var lquserid = lquseridobj.value;
	}
	if (typeobj) {
		var type = typeobj.value;
	}
	//var userid = buyuser;
	var useflag = "";
	if (buyend == "") {
		alert(t['01']);
		return;
	}
	if (type == "") {
		alert(t['03']);
		websys_setfocus('type');
		return false;
	}
	if (startno == "" || endno == "") {
		alert(t['04']);
		websys_setfocus('endno');
		return false;
	}
	if (!checkno(startno)) {
		alert(t['05']);
		websys_setfocus('startno');
		return false;
	}
	if (!checkno(endno)) {
		alert(t['06']);
		websys_setfocus('endno');
		return false;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		alert(t['07']);
		websys_setfocus('endno');
		return false;
	}
	if (endno.length != startno.length) {
		alert(t['08']);
		websys_setfocus('endno');
		return false;
	}
	if (parseInt(endno, 10) > parseInt(buyend, 10)) {
		alert(t['09'] + buyend + t['10']);
		websys_setfocus('endno');
		return false;
	}
	if (lquser == "") {
		alert(t['11']);
		websys_setfocus('lquser');
		return false;
	}
	if (m_AmtMRowID == "") {
		alert("选择发票错误");
		return false;
	}
	var truthBeTold = window.confirm(t['12'] + startno + t['13'] + endno + t['14']);
	if (truthBeTold) {
		/*
		var userobj = document.getElementById('userid');
		if (userobj) {
			var userid = userobj.value;
		}
		*/
		var str = "^" + startno + "^" + endno + "^" + lquserid + "^" + buyend + "^" + type + "^" + title;
		//var str = "^^"+type+"^"+buyuser+"^^"+startno+"^"+endno+"^^"+userid+"^^"+useflag;
		p1 = str;
		var HospDr = session['LOGON.HOSPID'];
		var encmeth = DHCWeb_GetValue('getadd');
		if (cspRunServerMethod(encmeth, 'addok', '', p1, m_AmtMRowID, HospDr) == '1') {
			//alert("ok");
		}
	}
}

function addok(value) {
	if (value == 0) {
		alert("发放成功！");
		var findobj = document.getElementById('Find');
		if (findobj) {
			findobj.click();
		}
		Find_click();
		//window.location.reload();
	} else {
		if (value == "-506") {
			alert("发放号段不存在,请刷新后重发");
		} else {
			alert(value);
		}
	}
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0) {
			return false;
		}
	}
	return true;
}

function celendno() {
	var numobj = document.getElementById('number');
	if (numobj) {
		var num = numobj.value;
	}
	if (num.indexOf("-") > -1) {
		numobj.value = "";
		return;
	}
	var snoobj = document.getElementById('startno');
	if (snoobj) {
		var sno = snoobj.value;
	}
	var ssno = "";
	var ssno1;
	var slen;
	var sslen;
	if (num == "" || (parseInt(num, 10) == 0)) {
		return;
	}
	if (checkno(num) && (sno != "") && checkno(sno)) {
		ssno1 = parseInt(sno, 10) + parseInt(num, 10) - 1;
		ssno = ssno1.toString();
		slen = sno.length;
		sslen = ssno.length;
		for (i = slen; i > sslen; i--) {
			ssno = "0" + ssno;
		}
		var endnoobj = document.getElementById('endno');
		if (endnoobj) {
			endnoobj.value = ssno;
		}
	}
}

function getuserid(value) {
	var user = value.split("^");
	var obj = document.getElementById('lquserid');
	obj.value = user[1];
}

function gettype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		type_lookuphandler();
	}
}

function getuser() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		lquser_lookuphandler();
	}
}

function confirmInvprt_Click() {
	if (SelectedRow == 0) {
		return false;
	}
	/*
	var rowidObj = document.getElementById("Trowidz" + SelectedRow);
	if (rowidObj) {
		var invRowid = rowidObj.innerText;
	}
	var flagObj = document.getElementById("Tflagz" + SelectedRow);
	if (flagObj) {
		var invFlag = flagObj.innerText;
	}
	var userRowidObj = document.getElementById("TlquserIdz" + SelectedRow);
	if (userRowidObj) {
		var userRowid = userRowidObj.value;
	}
	*/
	var invRowid = DHCWeb_GetValue("Trowidz" + SelectedRow);
	var invFlag = DHCWeb_GetValue("Tflagz" + SelectedRow);
	var userRowid = DHCWeb_GetValue("TlquserIdz" + SelectedRow);
	var confirmUserRowid = session['LOGON.USERID'];
	if (invFlag == "已用完") {
		var encmeth = DHCWeb_GetValue('BtnConfirmEncrypt');
		var returnCode = cspRunServerMethod(encmeth, invRowid, confirmUserRowid);
		//alert(returnCode)
		if (returnCode == 0) {
			alert("核销成功");
			Find_click();
			//window.location.reload();
		} else {
			alert("核销失败");
		}
	} else {
		alert("票据未用完或已核销,不能核销!");
		return false;
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex; //得到你选中的行
	var objtbl = document.getElementById("t" + "UDHCJFInvprtGrant");
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	SelectedRow = selectrow;
}

//add by wanghuicai
function find_OnClick() {
	var tmpFlag = websys_$("invprtFlag").value;
	Find_click();
}

function invprtFlag_OnChange() {
	websys_$("currentInvprtFlag").value = websys_$("invprtFlag").selectedIndex
}

//add by wanghc 090826
function PrintInvoiceOld() {
	var path = tkMakeServerCall("web.DHCOPConfig", "GetPath");
	var Template = path + "JF_InvoiceBill.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet;
	xlsheet.cells(2, 3) = websys_$V("stdate");
	var tableObj = websys_$("tUDHCJFInvprtGrant");
	var rowsNum = tableObj.rows.length;
	for (var i = 1; i < rowsNum; i++) {
		xlsheet.cells(i + 4, 1) = websys_$("Trowidz" + i).innerText;
		xlsheet.cells(i + 4, 2) = websys_$("Ttypez" + i).innerText;
		xlsheet.cells(i + 4, 3) = websys_$("Tstartnoz" + i).innerText;
		xlsheet.cells(i + 4, 4) = websys_$("Tendnoz" + i).innerText;
		xlsheet.cells(i + 4, 5) = parseFloat(websys_$("Tendnoz" + i).innerText - websys_$("Tstartnoz" + i).innerText) + 1;
		xlsheet.cells(i + 4, 6) = websys_$("Tlquserz" + i).innerText;
	}
	printTableLine(xlsheet, 4, 1, rowsNum + 3, 7)
	xlsheet.cells(rowsNum + 5, 2) = "发放员:";
	xlsheet.cells(rowsNum + 5, 3) = session['LOGON.USERNAME'];
	xlsheet.cells(rowsNum + 5, 5) = "领票人员签名:";
	xlApp.Visible = true;
	xlsheet.PrintPreview();
	//xlsheet.printout;
	xlsheet = null;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
}

//add by wanghc 090826
function printTableLine(objSheet, rowTop, columnLeft, rowButton, columnRight) {
	var topLeftCell = objSheet.Cells(rowTop, columnLeft);
	var ButtonRightCell = objSheet.Cells(rowButton, columnRight);
	with (objSheet.Range(topLeftCell, ButtonRightCell)) {
		Borders(1).LineStyle = 1;
		Borders(2).LineStyle = 1;
		Borders(3).LineStyle = 1;
		Borders(4).LineStyle = 1;
	}
}

//add hujunbin 14.11.19
function PrintInvoice() {
	var guser = session["LOGON.USERID"];
	var path = tkMakeServerCall("web.DHCOPConfig", "GetPath");
	var SelRowObj = document.getElementById('TJobz' + 1);
	if (!SelRowObj) {
		alert('没有打印数据');
		return;
	}
    var job = SelRowObj.value;
	var Template = path + "JF_InvoiceBill.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet;
	var dataLen = tkMakeServerCall("web.UDHCJFInvprt", "getGrantInvNum", guser, job);
	dataLen = parseFloat(dataLen);
	var rowsNum = 4;
	if (dataLen == 0) {
		alert("没有打印数据");
		return;
	}
	for (var i = 1; i <= dataLen; i++) {
		var dataInfo = tkMakeServerCall("web.UDHCJFInvprt", "getGrantInvData", guser, job, i);
		var dataArr = dataInfo.split("^");
		for (var j = 0; j < 10; j++) {
			xlsheet.cells(i + 4, j + 1) = dataArr[j];
		}
		rowsNum = rowsNum + 1;
	}
	printTableLine(xlsheet, 4, 1, rowsNum, 11)
	xlsheet.cells(3, 2) = websys_$V("stdate");
	xlsheet.cells(3, 5) = websys_$V("enddate");
	xlsheet.cells(rowsNum + 5, 2) = "发放员:";
	xlsheet.cells(rowsNum + 5, 3) = session['LOGON.USERNAME'];
	xlsheet.cells(rowsNum + 5, 5) = "领票人员签名:";
	xlApp.Visible = true;
	xlsheet.PrintPreview();
	xlsheet = null;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-09-30
 */
function selReceiptsNum_Click() {
	var type = DHCWebD_GetObjValue('type');
	if (type == "") {
		alert('请先选择票据类型');
		return;
	}
	var flag = 'INV';
	var url = "dhcbill.receiptsselected.csp?flag=" + flag + "&type=" + type;
	var rtn = window.showModalDialog(url, "", "dialogwidth:580px;dialogheight:350px;center:1");
	if (rtn) {
		var myAry = rtn.split('^');
		m_AmtMRowID =  myAry[0];
		var startNO = myAry[1];
		var endNO = myAry[2];
		var title = myAry[3];
		DHCWebD_SetObjValueB('startno', startNO);
		DHCWebD_SetObjValueB('endno', endNO);
		DHCWebD_SetObjValueB('maxno', endNO);
		DHCWebD_SetObjValueB('Title', title);
		if (startNO == "") {
			websys_setfocus('startno');
		} else {
			DHCWebD_SetObjValueB('number', "");
			websys_setfocus('number');
		}
	}
}

document.body.onload = BodyLoadHandler;
