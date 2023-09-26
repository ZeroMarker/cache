///UDHCJFInvprtBuy.js

var typeobj, buyerobj, path;
var SelectedRow = 0;
var typestatus, buyusrstatus, selectrowid, returnflag;

function BodyLoadHandler() {
	typestatus = "0";
	buyusrstatus = "0";
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
	var obj = document.getElementById('add');
	if (obj) {
		obj.onclick = Add_Click;
	}
	var obj = document.getElementById('BtnRestore');
	if (obj) {
		obj.onclick = Restore_Click;
	}
	var numobj = document.getElementById('number');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	typeobj = document.getElementById('type');
	/*
	if (typeobj) {
		typeobj.readOnly = true;
		typeobj.onkeydown = gettype;
	}
	*/
	buyerobj = document.getElementById('buyer');
	if (typestatus == "1") {
		getmyid();
	}
	if (buyusrstatus == "1") {
		getmyid1();
	}
	var obj = document.getElementById("stdate1");
	obj.onkeydown = getstdate;
	if (obj.value == "") {
		getdate();
	}
	var obj = document.getElementById("enddate1");
	obj.onkeydown = getenddate;
	if (obj.value == "") {
		getdate();
	}
	var obj = document.getElementById("delete");
	if (obj) {
		obj.onclick = delete_Click;
	}
	getinvmax();
	var printobj = document.getElementById("Print");
	if (printobj) {
		printobj.onclick = Print_Click;
	}
}

function getinvmax() {
	var p1 = typeobj.value;
	if (p1 == "") {
		return;
	}
	var HospDr = session['LOGON.HOSPID'];
	var encmeth = websys_$V('getstartno');
	if (cspRunServerMethod(encmeth, 'setstartno_val', '', p1, HospDr) == '1') {};
}

function getdate() {
	var encmeth = websys_$V('today');
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
			alert(t['17']);
			return;
		}
		if (eval(date1[1]) > eval(date[1])) {
			end1obj.value = "";
			end1obj.value = "";
			alert(t['17']);
			return;
		}
		if (eval(date1[2]) > eval(date[2])) {
			end1obj.value = "";
			end1obj.value = "";
			alert(t['17']);
			return;
		}
	}
}

function SelectRowHandler() {
	var rowObj = getRow(window.event.srcElement);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	selectrowid = DHCWeb_GetValue('TRowidz' + selectrow);
	returnflag = DHCWeb_GetValue('TReturnFlagz' + selectrow);
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

function getmyid1() {
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname1 = "ld" + Myobj.value + "i" + "buyer";
		var obj = document.getElementById(imgname1);
		obj.style.display = "none";
		buyerobj.value = GuserCode;
		buyerobj.readOnly = true;
		var obj = document.getElementById('userid');
		obj.value = Guser;
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

function delete_Click() {
	var selrow = selectrowid;
	if (!selrow){
		alert('请先选择需要删除的票据记录');
		return;
	}
	var encmeth = websys_$V("getdel");
	var rtn = cspRunServerMethod(encmeth, selrow);
	if (+rtn == 0) {
		alert("删除成功.");
		var find = websys_$("Find");
		if (find) {
			find.click();
		}
	}else if (+rtn == -2) {
		alert(t['16']);
		return;
	}else {
		alert("删除失败:" + rtn);
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

function setstartno_val(value) {
	var startno = document.getElementById('Startno');
	if (value == "") {
		startno.value = "";
		websys_setfocus('Startno');
	} else {
		startno.value = value;
		websys_setfocus('endno');
	}
}

function Add_Click() {
	var stnoobj = document.getElementById('Startno');
	if (stnoobj) {
		var startno = stnoobj.value;
	}
	var endnoobj = document.getElementById('endno');
	if (endnoobj) {
		var endno = endnoobj.value;
	}
	var buyuserobj = document.getElementById('userid');
	if (buyuserobj) {
		var buyuser = buyuserobj.value;
	}
	var titleobj = document.getElementById('Title');
	if (titleobj) {
		var title = titleobj.value;
	}
	var typeobj = document.getElementById('type');
	if (typeobj) {
		var type = typeobj.value;
	}
	var userid = buyuser;
	var useflag = "";
	//add by zhl anh
	if (userid == "") {
		alert(t['14']);
		websys_setfocus('buyer');
		return false;
	}
	if (type == "") {
		alert(t['13']);
		websys_setfocus('type');
		return false;
	}
	if (startno == "" || endno == "") {
		alert(t['01']);
		websys_setfocus('endno');
		return false;
	}
	if (!checkno(startno)) {
		alert(t['02']);
		websys_setfocus('Startno');
		return false;
	}
	if (!checkno(endno)) {
		alert(t['03']);
		websys_setfocus('endno');
		return false;
	}
	if (parseInt(endno, 10) < parseInt(startno, 10)) {
		alert(t['04']);
		websys_setfocus('endno');
		return false;
	}
	if (endno.length != startno.length) {
		alert(t['05']);
		websys_setfocus('endno');
		return false;
	}
	/*
	var encmeth = websys_$V('getbuynote');
	var buynum = cspRunServerMethod(encmeth,'','',startno,endno,type)
	if (eval(buynum) > 0) {
		alert(t['09']);
		return;
	}
	*/
	var truthBeTold = window.confirm(t['06'] + startno + t['07'] + endno + t['08']);
	if (truthBeTold) {
		var userobj = document.getElementById('user');
		if (userobj) {
			var userid = userobj.value;
		}
		var str = "^^" + type + "^" + buyuser + "^^" + startno + "^" + endno + "^^" + userid + "^^" + useflag + "^" + title;
		var err = "";
		var HospDr = session['LOGON.HOSPID'];
		var encmeth = websys_$V('getadd');
		if (cspRunServerMethod(encmeth, 'addok', '', str, HospDr) == '0') {};
	}
}

function addok(value) {
	if (value == 0) {
		alert("购入成功");
		window.location.reload();
	} else if (value == "-505") {
		alert(t['09']);
	} else {
		alert("购入失败" + value);
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
	var snoobj = document.getElementById('Startno');
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

function Find_Click() {
	var find = websys_$("Find");
	if (find) {
		find.click();
	}
}

function getuserid(value) {
	var user = value.split("^");
	var obj = document.getElementById('userid');
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
		buyer_lookuphandler();
	}
}

function Restore_Click() {
	if (returnflag == "") {
		alert(t['18']);
		return;
	}
	var encmeth = websys_$V('GetRestore');
	if (cspRunServerMethod(encmeth, selectrowid) == 0) {
		alert(t['19']);
	} else {
		alert(t['20']);
	}
	// window.location.reload();
	Find_click();
}

//add by tangtao 2010-09-08 打印收据明细
function Print_Click() {
	getpath();
	var Template = path + "DHCInvBuyDetail.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;
	var StartDateobj = document.getElementById('stdate');
	if (StartDateobj) {
		var StartDate = StartDateobj.value;
	}
	var EndDateobj = document.getElementById('enddate');
	if (EndDateobj) {
		var EndDate = EndDateobj.value;
	}
	var SelRowObj = document.getElementById('Tjobz' + 1);
	var job = SelRowObj.innerText;
	var currRow = 2;
	xlsheet.cells(currRow, 2) = StartDate + " 至 " + EndDate;
	++currRow;
	xlsheet.range(xlsheet.cells(currRow, 1), xlsheet.cells(currRow, 10)).borders.weight = 1;
	++currRow;
	xlsheet.range(xlsheet.cells(currRow, 1), xlsheet.cells(currRow, 10)).borders.weight = 1;
	//添加数据
	var num = tkMakeServerCall("web.UDHCJFInvprt", "GetInvNum", job);
	var BuyDate = "";
	for (var j = 1; j < (parseInt(num) + 1); j++) {
		var rtn = tkMakeServerCall("web.UDHCJFInvprt", "GetInvData", job, j);
		var strArray = rtn.split("^");
		++currRow;
		for (k = 0; k < strArray.length - 0; k++) {
			xlsheet.Cells(currRow, k + 1) = strArray[k];
			xlsheet.cells(currRow, k + 1).borders.weight = 1;
			if (k == 7) {
				var PrtDate = strArray[k];
			}
			if (k == 3) {
				var UseDate = strArray[k];
			}
		}
		if (PrtDate == "") {    //未使用号段用¨黄色〃显示...6
			xlsheet.range(xlsheet.cells(currRow, 8), xlsheet.cells(currRow, 10)).Interior.ColorIndex = 6;
		}
		if (UseDate == "") {    //未领取号段用¨黄色〃显示...6
			xlsheet.range(xlsheet.cells(currRow, 4), xlsheet.cells(currRow, 10)).Interior.ColorIndex = 6;
		}
		if (BuyDate == strArray[1]) {  //删除重复日期
			xlsheet.range(xlsheet.cells(currRow, 1), xlsheet.cells(currRow, 3)).value = "";
		}
		BuyDate = strArray[1];
	}
	xlsheet.printout;
	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}

function getpath() {
	var encmeth = websys_$V('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}

document.body.onload = BodyLoadHandler;
