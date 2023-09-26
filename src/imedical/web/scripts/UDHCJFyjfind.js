/// UDHCJFyjfind.js

var Adm = "";
var SelectedRow = 0;
var name, papno, P1;
var Adm = "";
var SelectedRow = 0;
var name, papno, P1;
var papnoobj, nameobj, zynoobj;
var EncryptLevelObj, PatLevelObj;

function BodyLoadHandler() {
	nameobj = document.getElementById("name");
	name = document.getElementById("name").value;
	Adm = document.getElementById("Adm").value;
	wardobj = document.getElementById('ward');
	papno = document.getElementById("papno").value;
	papnoobj = document.getElementById("papno");
	papnoobj.onkeydown = findno;
	zynoobj = document.getElementById("zyno");
	zynoobj.onkeydown = findno;
	var add = document.getElementById("ADD");
	add.onclick = LinkaddDeposit;
	var obj = document.getElementById("clear");
	obj.onclick = clearall;
	var obj = document.getElementById("refunddeposit");
	obj.onclick = refunddeposit_click;
	var obj = document.getElementById("Find");
	obj.onclick = Find_click;
	EncryptLevelObj = document.getElementById('EncryptLevel');
	PatLevelObj = document.getElementById('PatLevel');
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
	DHCWebD_SetObjValueB("UserDepID", session['LOGON.CTLOCID']);
	websys_setfocus('papno');
	var findObj = document.getElementById('Find');
	if (findObj) {
		findObj.onclick = find_OnClick;
	}
	//+add by Suhuide at 2018-06-30 加载就诊状态列表	
	var obj = document.getElementById("AdmTypeList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = AdmType_OnChange;
	}
	IntDoc();
}

function find_OnClick() {
	var ward = "";
	var bed = "";
	var bedObj = document.getElementById('bed');
	var wardObj = document.getElementById('ward');
	if (bedObj) {
		bed = bedObj.value;
		bed = bed.replace(/(^\s*)|(\s*$)/g, "");
		if (bed == "") {
			DHCWebD_SetObjValueB("name", "");
			DHCWebD_SetObjValueB("papno", "");
		}
	}
	if (wardObj) {
		ward = wardObj.value;
		ward = ward.replace(/(^\s*)|(\s*$)/g, "");
		if (ward == "") {
			DHCWebD_SetObjValueB("wardid", "");
		}
	}

	Find_click();
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	Objtbl = document.getElementById('tUDHCJFyjfind');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (selectrow != SelectedRow) {
		var SelRowObj = document.getElementById('Tadmidz' + selectrow);
		var adm1 = SelRowObj.innerText;
		var obj = document.getElementById("Adm");
		obj.value = adm1;
		Adm = adm1;
		var SelRowObj = document.getElementById('Tadmnamez' + selectrow);
		nameobj.value = SelRowObj.innerText;
		var SelRowObj = document.getElementById('Tpapnoz' + selectrow);
		papnoobj.value = SelRowObj.innerText;
		var SelRowObj = document.getElementById('Tbedz' + selectrow);
		var obj = document.getElementById('bed');
		obj.value = SelRowObj.innerText;
		var SelRowObj = document.getElementById('Twardz' + selectrow);
		var obj = document.getElementById('ward');
		obj.value = SelRowObj.innerText;
		var SelRowObj = document.getElementById('TEncryptLevelz' + selectrow);
		EncryptLevelObj.value = SelRowObj.innerText;
		var SelRowObj = document.getElementById('TPatLevelz' + selectrow);
		PatLevelObj.value = SelRowObj.innerText;
		SelectedRow = selectrow;
	}
}

function clearall() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFyjfind";
}

function findno() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		getpatinfo1();
	}
}

function setpat_val(value) {
	var val = value.split("^");
	nameobj.value = val[0];
	if (nameobj.value == "") {
		papnoobj.value = "";
		alert(t['02']);
		websys_setfocus('papno');
		return;
	}
	//DHCWebD_SetObjValueB("ward", val[1]);
	//DHCWebD_SetObjValueB("bed", val[2]);
	DHCWebD_SetObjValueB("zyno", val[5]);
	DHCWebD_SetObjValueB("papno", val[6]);
	DHCWebD_SetObjValueB("EncryptLevel", val[7]);
	DHCWebD_SetObjValueB("PatLevel", val[8]);
	Find_click();
}

function LinkaddDeposit() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	var jsonStr = tkMakeServerCall("web.DHCBillCommon", "GetClsPropValById", "User.PAAdm", Adm);
	var jsonObj = eval("(" + jsonStr + ")");
	var admType = jsonObj.PAADMType;
	if (admType != "I") {
		alert("非住院就诊，不能交押金");
		return;
	}
	var deposittype = t['04'];
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + Adm + '&deposittype=' + deposittype;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes')
}

function checkno(inputtext) {
	var checktext = "1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum = checktext.indexOf(chr);
		if (indexnum < 0)
			return false;
	}
	return true;
}

function lookupbed(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('papno', myAry[0]);
	DHCWebD_SetObjValueB('name', myAry[1]);
	DHCWebD_SetObjValueB('bed', myAry[2]);
}

function lookupward(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('wardid', myAry[1]);
}

function refunddeposit_click() {
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

function readcard_click() {
	ReadCardClickHandler();
}

function getpatinfo1() {
	if ((papnoobj.value != "") || (zynoobj.value != "")) {
		papno = papnoobj.value;
		papno = papno.toString();
		if (papnoobj.value != "") {
			if (checkno(papno)) {
				var encmeth = DHCWebD_GetObjValue('getpapno');
				papno = cspRunServerMethod(encmeth, papno);
				papnoobj.value = papno;
			}
		}
		P1 = papno;
		var P2 = zynoobj.value;
		var encmeth = DHCWebD_GetObjValue('getadm');
		if (cspRunServerMethod(encmeth, 'setpat_val', '', P1, P2) == 1) {
		}
	}
}

/**
* Creator:Suhuide
* CreatDate:2018-06-30
* Description:获取就诊类型列表
*/
function IntDoc() {
	DHCWebD_ClearAllListA("AdmTypeList");
	var encmeth = DHCWebD_GetObjValue("ReadAdmTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "AdmTypeList");
	}
	
	var myAdmType = DHCWebD_GetObjValue("AdmType");
	if (myAdmType != "") {
		DHCWeb_SetListDefaultValue("AdmTypeList", myAdmType, "^", 0);
	}
	AdmType_OnChange();
}

function AdmType_OnChange() {
	var myAdmTypeStr = DHCWeb_GetListBoxValue("AdmTypeList");
	var myAry = myAdmTypeStr.split("^");
	DHCWebD_SetObjValueB("AdmType", myAry[0]);
}

document.body.onload = BodyLoadHandler;