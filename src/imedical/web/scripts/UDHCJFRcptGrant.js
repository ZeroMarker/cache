///UDHCJFRcptGrant.js

var SelectedRow = 0;
var maxrowid;
var stno;
var endno;
var type1obj, lquser1obj;
var m_BuyRowID = "";

function BodyLoadHandler() {
	var obj = document.getElementById("grantflag");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.options[0] = new Option('', '');
		obj.options[1] = new Option(t['13'], t['13']);
		obj.options[2] = new Option(t['14'], t['14']);
		obj.options[3] = new Option(t['15'], t['15']);
		obj.options[4] = new Option(t['16'], t['16']);
	}
	var obj = document.getElementById("Add");
	if (obj) {
		obj.onclick = Add_click;
	}
	var obj = document.getElementById("Delete");
	if (obj) {
		obj.onclick = Delete_click;
	}
	document.getElementById('stno').readOnly = true;
	type1obj = document.getElementById("type");
	type1obj.onkeydown = gettype;
	lquser1obj = document.getElementById("lquser");
	lquser1obj.onkeydown = getuser;
	var numobj = document.getElementById('number');
	if (numobj) {
		numobj.onkeyup = celendno;
	}
	var obj = websys_$("SelReceiptsNum");
	if (obj) {
		obj.onclick = selReceiptsNum_Click;
	}
	StartNo();
}

function StartNo() {
	selectrow = SelectedRow;
	var typeobj = document.getElementById('type');
	var p1 = typeobj.value;
	var p2 = session['LOGON.USERID'];
	var HospDr = session['LOGON.HOSPID'];
	var encmeth = DHCWebD_GetObjValue('getstno');
	if (cspRunServerMethod(encmeth, 'SetNo', '', p1, p2, HospDr) == '0') {}
}

function SetNo(value) {
	var str = value;
	var str1 = str.split("^");
	var obj = document.getElementById('stno');
	obj.value = str1[0];
	obj1 = document.getElementById('endno');
	obj1.value = str1[1];
	obj2 = document.getElementById('kyendno');
	obj2.value = str1[1];
	m_BuyRowID = str1[3];
}

function Add_click() {
	selectrow = SelectedRow;
	var stno = document.getElementById('stno').value;
	if (stno == "") {
		alert(t['01'])
		return;
	}
	var endno = document.getElementById('endno').value;
	if (endno == "") {
		alert(t['02']);
		return;
	}
	if ((stno.length) != (endno.length)) {
		alert(t['03']);
		return;
	}
	var kyendno = document.getElementById('kyendno').value;
	if (endno > kyendno) {
		alert(t['04']);
		return;
	}
	if (parseInt(endno, 10) < parseInt(stno, 10)) {
		alert(t['11']);
		return;
	}
	var lquserid = document.getElementById('lquserid').value;
	if (lquserid == "") {
		alert(t['05']);
		return;
	}
	var title = document.getElementById('title').value;
	//var userid=document.getElementById('userid').value;
	userid = session['LOGON.USERID'];
	var typeobj = document.getElementById('type');
	var type = typeobj.value;
	var HospDr = session['LOGON.HOSPID'];
	if (m_BuyRowID == "") {
		alert("选择发票错误");
		return false;
	}
	var encmeth = DHCWebD_GetObjValue('Ins');
	var str = stno + '^' + endno + '^' + kyendno + '^' + userid + '^' + lquserid + '^' + title + '^' + type;
	var rtn = cspRunServerMethod(encmeth, 'SetPid', '', str, m_BuyRowID, HospDr);
	if (rtn == "-507") {
		alert("开始号码错误");
	}else if (rtn == "-508") {
		alert("结束号码错误");
	}
}
function Delete_click() {
	selectrow = SelectedRow;
	var grantrowid = document.getElementById('grantrowid').value;
	if (grantrowid == "") {
		alert(t['06']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('maxrowid');
	if (cspRunServerMethod(encmeth, 'MaxRowId', '') == '0') {}

	if (grantrowid != maxrowid) {
		alert(t['07'])
		return;
	}
	if ((grantrowid = maxrowid) & (stno != curno)) {
		alert(t['08']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('del');
	if (cspRunServerMethod(encmeth, 'SetPid', '', grantrowid) == '0') {}
}

function MaxRowId(value) {
	var str = value;
	str = str.split("^");
	maxrowid = str[0];
	stno = str[1];
	curno = str[2];
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tUDHCJFRcptGrant');
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var obj = document.getElementById('grantrowid');
	var SelRowObj = document.getElementById('Tgrantrowidz' + selectrow);
	var grantrowid = SelRowObj.innerText;
	obj.value = grantrowid;
	SelectedRow = selectrow;
}

function SetPid(value) {
	if (value != "0") {
		alert(t['09']);
		return;
	}
	try {
		alert(t['10']);
		Find_click()
	} catch (e) {
	}
}

function LookUpUser(str) {
	var obj = document.getElementById('lquserid');
	var tem = str.split("^");
	obj.value = tem[1];
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

function celendno() {
	var numobj = document.getElementById('number');
	if (numobj) {
		var num = numobj.value;
	}
	var snoobj = document.getElementById('stno');
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
			ssno = "0" + ssno
		}
		var endnoobj = document.getElementById('endno');
		if (endnoobj) {
			endnoobj.value = ssno;
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
	var flag = 'RCPT';
	var url = "dhcbill.receiptsselected.csp?flag=" + flag + "&type=" + type;
	var rtn = window.showModalDialog(url, "", "dialogwidth:580px;dialogheight:350px;center:1");
	if (rtn) {
		var myAry = rtn.split('^');
		m_BuyRowID =  myAry[0];
		var startNO = myAry[1];
		var endNO = myAry[2];
		var title = myAry[3];
		DHCWebD_SetObjValueB('stno', startNO);
		DHCWebD_SetObjValueB('endno', endNO);
		DHCWebD_SetObjValueB('kyendno', endNO);
		DHCWebD_SetObjValueB('title', title);
		if (startNO == "") {
			websys_setfocus('stno');
		} else {
			DHCWebD_SetObjValueB('number', "");
			websys_setfocus('number');
		}
	}
}

document.body.onload = BodyLoadHandler;
