/// DHCIPBILLOEORIItemGroup.js

var Guser;
var SelectedRow = "-1";

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	var PAPERNoobj = document.getElementById('PAPERNo');
	if (PAPERNoobj) {
		PAPERNoobj.onkeydown = GetPatInfo;
	}
	var BtnClearobj = document.getElementById('BtnClear');
	if (BtnClearobj) {
		BtnClearobj.onclick = Clear_click;
	}
	var BtnUpdateobj = document.getElementById('BtnUpdate');
	if (BtnUpdateobj) {
		BtnUpdateobj.onclick = Update_click;
	}
	var BtnIntBillobj = document.getElementById('BtnIntBill');
	if (BtnIntBillobj) {
		BtnIntBillobj.onclick = IntBill_click;
	}
	var BtnBillobj = document.getElementById('BtnBill');
	if (BtnBillobj) {
		BtnBillobj.onclick = Bill_click;
	}
	var AllSelectobj = document.getElementById('AllSelect');
	if (AllSelectobj) {
		AllSelectobj.onclick = AllSelect_click;
	}
	if (PAPERNoobj.value != "") {
		var PAPERNo = PAPERNoobj.value;
		var encmeth = websys_$V('getpatinfo');
		if (cspRunServerMethod(encmeth, 'setpat_val', '', PAPERNo) == '1') {}
	}
	GetCurrJob();
	
	//+2018-04-27 ZhYW 刷新界面时直接获取到选中执行记录的计费金额
	var billNo = DHCWebD_GetObjValue('BillNo');
	var job = DHCWebD_GetObjValue('job');
	var checkAmt = tkMakeServerCall("web.DHCIPBILLOEORIItemGroup", "GetSelOEOREBillAmt", billNo, job, Guser);
	DHCWebD_SetObjValueB('CheckAmt', checkAmt);
	//
}

function GetPatInfo() {
	var key = websys_getKey(e);
	if (key == 13) {
		var PAPERNo = DHCWebD_GetObjValue('PAPERNo');
		if ((PAPERNo == "") || (PAPERNo == " ")) {
			return;
		}
		var encmeth = DHCWebD_GetObjValue('getpatinfo');
		if (cspRunServerMethod(encmeth, 'setpat_val', '', PAPERNo) == '1') {}
	}
}

function setpat_val(value) {
	if (value == "") {
		return;
	}
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('PAPERNo', myAry[0]);
	DHCWebD_SetObjValueB('PAPERName', myAry[1]);
	DHCWebD_SetObjValueB('PAPERRowid', myAry[14]);
	DHCWebD_SetObjValueB('EncryptLevel', myAry[15]);
	DHCWebD_SetObjValueB('PatLevel', myAry[16]);
}

function Update_click() {
	var CheckBillNo = DHCWebD_GetObjValue('CheckBillNo');
	if ((CheckBillNo == "") || (CheckBillNo == " ")) {
		alert(t['NotBill']);
		return;
	}
	var BillNo = DHCWebD_GetObjValue('BillNo');
	if ((BillNo == "") || (BillNo == " ")) {
		alert(t['NotBill']);
		return;
	}
	var Job = DHCWebD_GetObjValue('job');
	if ((Job == "") || (Job == " ")) {
		alert(t['JobNull']);
		return;
	}
	if (Guser == "") {
		alert(t['GuserNull']);
		return;
	}
	var Rows = DHCWeb_GetTBRows('tDHCIPBILLOEORIItemGroup');
	if (Rows == 0) {
		return;
	}
	var allDtlAry = new Array();
	var selDtlAry = new Array();
	for (var i = 1; i <= Rows; i++) {
		var SelectFlag = DHCWeb_GetColumnData('SelectFlag', i) ? 1: 0;
		var oeore = DHCWeb_GetColumnData('TOrdRowid', i);
		if (oeore == "") {
			continue;
		}
		rowData = SelectFlag + '^' + oeore;
		allDtlAry.push(rowData);
		if (SelectFlag == 1) {
			selDtlAry.push(rowData);
		}
	}
	//判断是否有已保存的执行记录
	var rtn = tkMakeServerCall("web.DHCIPBILLOEORIItemGroup", "CheckSelOEORE", Job, Guser);
	var selDtlStr = selDtlAry.join('!');
	if ((selDtlStr == "") && (rtn == 0)) {
		alert('请选择需要拆分的医嘱');
		return;
	}
	var allDtlStr = allDtlAry.join('!');
	var encmeth = DHCWebD_GetObjValue('UPCheckOrd');
	var RetCode = cspRunServerMethod(encmeth, BillNo, allDtlStr, Guser, Job);
	if (RetCode == "OrdNull") {
		alert(t['OrdNull']);
		return;
	} else if (RetCode == "GuserNull") {
		alert(t['GuserNull']);
		return;
	} else if (RetCode == "GuserNull") {
		alert(t['JobNull']);
		return;
	} else if (RetCode.split("^")[0] == "0") {
		DHCWebD_SetObjValueB('CheckAmt', RetCode.split("^")[1]);
		alert(t['UpdateSucc']);
		return;
	} else {
		alert(t['UpdateErr']);
		return;
	}
}

function Clear_click() {
	DHCWebD_SetObjValueB('PatDept', "");
	DHCWebD_SetObjValueB('OrdDesc', "");
	DHCWebD_SetObjValueB('OrdRowid', "");
	DHCWebD_SetObjValueB('STDate', "");
	DHCWebD_SetObjValueB('EndDate', "");
	DHCWebD_SetObjValueB('PAPERRowid', "");
	DHCWebD_SetObjValueB('CheckBillNo', "");
	var job = DHCWebD_GetObjValue('job');
	var encmeth = DHCWebD_GetObjValue('KillCheckGlb');
	var rtn = cspRunServerMethod(encmeth, Guser, job);    //清除global
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function IntBill_click() {
	var CheckBillNo = DHCWebD_GetObjValue('CheckBillNo');
	if ((CheckBillNo == "") || (CheckBillNo == " ")) {
		alert(t['NotBill']);
		return;
	}
	var BillNo = DHCWebD_GetObjValue('BillNo');
	if ((BillNo == "") || (BillNo == " ")) {
		alert(t['NotBill']);
		return;
	}
	var Job = DHCWebD_GetObjValue('job');
	if ((Job == "") || (Job == " ")) {
		alert(t['JobNull']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('UpOEORIItemGroup');
	var RetCode = cspRunServerMethod(encmeth, Guser, Job);
	if (RetCode == "JobNull") {
		alert(t['JobNull']);
		return;
	} else if (RetCode == "GuserNull") {
		alert(t['GuserNull']);
		return;
	} else if (RetCode == "0") {
		
	} else {
		alert("更新医嘱表失败");
		return;
	}
	var Adm = DHCWebD_GetObjValue('EpisodeID');
	var num = tkMakeServerCall("web.UDHCJFCASHIER", "Judge", "", "", Adm);
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
	var encmeth = DHCWebD_GetObjValue('RINBILLOrdItemGroup');
	var RetStr = cspRunServerMethod(encmeth, BillNo, Guser, Job);
	//alert(RetStr);
	if (RetStr == "") {
		alert(t['IntBillErr']);
		return;
	} else {
		var RetStr1 = RetStr.split("^");
		if (RetStr1[0] == "NotBill") {
			alert(t['NotBill']);
			return;
		} else if (RetStr1[0] == "GuserNull") {
			alert(t['GuserNull']);
			return;
		} else if (RetStr1[0] == "NotItemGroup") {
			alert(t['NotItemGroup']);
			return;
		} else if (RetStr1[0] == "0") {
			alert(t['IntBillSucc']);
			//modify 2015-2-28 hujunbin 新住院收费中途结算后跳转
			if (window.parent && window.parent.document.getElementById('chargeTabs')) {
				window.parent.setDefTabFromIframe();
			}
			return;
		} else {
			alert(t['IntBillErr']);
			return;
		}
	}
	var job = DHCWebD_GetObjValue('job');
	var encmeth = DHCWebD_GetObjValue('KillCheckGlb');
	var rtn = cspRunServerMethod(encmeth, Guser, job);    //清除global
}

function Bill_click() {
	var EpisodeID = DHCWebD_GetObjValue('EpisodeID');
	if ((EpisodeID == "") || (EpisodeID == " ")) {
		alert(t['PatNull']);
		return;
	}
	var BillNo = DHCWebD_GetObjValue('BillNo');
	if (BillNo == " ") {
		BillNo == "";
	}
	var encmeth = DHCWebD_GetObjValue('getmotheradm');
	if (cspRunServerMethod(encmeth, EpisodeID) == 'True') {
		alert(t['BabyBillErr']);
		return;
	}
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var encmeth = DHCWebD_GetObjValue('getbill');
	var billstr = cspRunServerMethod(encmeth, '', '', EpisodeID, Guser, BillNo, computername);
	if (billstr == "") {
		DHCWebD_SetObjValueB('CheckBillNo', "");
		alert(t['BillErr']);
		return;
	} else {
		var billstr1 = billstr.split("^");
		if (billstr1[0] == "2") {
			DHCWebD_SetObjValueB('CheckBillNo', "");
			alert(t['MoreBillNum']);
			return;
		} else if (billstr1[0] == "0") {
			DHCWebD_SetObjValueB('BillNo', billstr1[1]);
			DHCWebD_SetObjValueB('CheckBillNo', billstr1[1]);
			alert(t['BillSucc']);
			var Findobj = document.getElementById('Find');
			Findobj.click();
		} else {
			DHCWebD_SetObjValueB('CheckBillNo', "");
			alert(t['BillErr']);
			return;
		}
	}
	var job = DHCWebD_GetObjValue('job');
	var encmeth = DHCWebD_GetObjValue('KillCheckGlb');
	var rtn = cspRunServerMethod(encmeth, Guser, job);    //清除global
}

function PatDeptLookUp(value) {
	if (value == "") {
		return;
	}
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('BillNo', myAry[2]);
	DHCWebD_SetObjValueB('EpisodeID', myAry[3]);
}

function OrdDescLookUp(value) {
	if (value == "") {
		return;
	}
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('OrdRowid', myAry[2]);
}

function GetCurrJob() {
	var job = DHCWebD_GetObjValue('job');
	if ((job == "") || (job == " ")) {
		var encmeth = DHCWebD_GetObjValue('GetCurrJob');
		var job = cspRunServerMethod(encmeth);
		if (job == "") {
			alert(t['JobNull']);
			return;
		}
		DHCWebD_SetObjValueB('job', job);
	}
}

function AllSelect_click() {
	var Rows = DHCWeb_GetTBRows('tDHCIPBILLOEORIItemGroup');
	var AllSelected = DHCWebD_GetObjValue('AllSelect');
	for (var i = 1; i <= Rows; i++) {
		DHCWeb_SetColumnData('SelectFlag', i, AllSelected);
	}
}

function UnloadHandler() {
	/*
	var job = DHCWebD_GetObjValue('job');
	var encmeth = DHCWebD_GetObjValue('KillCheckGlb');
	var rtn = cspRunServerMethod(encmeth, Guser, job);    //清除global
	*/
}

document.body.onbeforeunload = UnloadHandler;
document.body.onload = BodyLoadHandler;
