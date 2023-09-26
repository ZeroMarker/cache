///UDHCJFInvDetailSearch.js

function BodyLoadHandler() {
	var obj = document.getElementById("outExcel");
	if (obj) {
		obj.onclick = outExcel_click;
	}
	//+2018-01-24 ZhYW
	initChargeType();
	initInvNOType();
	initPatType();
	//add hujunbin 14.11.19
	initInsType();
}

function initChargeType() {
	var obj = document.getElementById("BalanceList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = Balance_OnChange;
		DHCWebD_ClearAllListA("BalanceList");
		var encmeth = DHCWebD_GetObjValue("BalanceEncrypt");
		if (encmeth != "") {
			var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "BalanceList");
		}
		var myBalance = DHCWebD_GetObjValue("balance");
		if (myBalance != "") {
			DHCWeb_SetListDefaultValue("BalanceList", myBalance, "^", 0);
		}
	}
}

function initInvNOType() {
	var obj = document.getElementById("InvNOTypeList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = InvNOType_OnChange;
		DHCWebD_ClearAllListA("InvNOTypeList");
		var encmeth = DHCWebD_GetObjValue("InvNOTypeEncrypt");
		if (encmeth != "") {
			var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "InvNOTypeList");
		}
		var myInvNOType = DHCWebD_GetObjValue("invNoType");
		if (myInvNOType != "") {
			DHCWeb_SetListDefaultValue("InvNOTypeList", myInvNOType, "^", 0);
		}
	}
}

function initPatType() {
	var obj = document.getElementById("PatTypeList");
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		obj.onchange = PatType_OnChange;
	}
	DHCWebD_ClearAllListA("PatTypeList");
	var encmeth = DHCWebD_GetObjValue("PatTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "PatTypeList");
	}
	var myPatType = DHCWebD_GetObjValue("PatType");
	if (myPatType != "") {
		DHCWeb_SetListDefaultValue("PatTypeList", myPatType, "^", 0);
	}
}

//add hujunbin 14.11.19
function initInsType() {
	var obj = document.getElementById("AdmReasonDesc");
	if (obj) {
		obj.size = 1;
		obj.length = 14;
		obj.multiple = false;
		obj.onchange = AdmReason_Change;
		DHCWebD_ClearAllListA("AdmReasonDesc");

		var ybFlag = DHCWebD_GetObjValue("PatType");
		var rtn = tkMakeServerCall("web.DHCIPBillInvDetailSearch", "getAllInsType", "DHCWeb_AddToListA", "AdmReasonDesc", obj.value, "IP", ybFlag);
		//+2018-01-19 ZhYW
		var myAdmReason = DHCWebD_GetObjValue("AdmReason");
		if (myAdmReason != "") {
			DHCWeb_SetListDefaultValue("AdmReasonDesc", myAdmReason, "^", 0);
		}
	}
}

//add hujunbin 14.11.19
function AdmReason_Change() {
	var admReasonStr = DHCWeb_GetListBoxValue("AdmReasonDesc");
	var myAry = admReasonStr.split("^");
	DHCWebD_SetObjValueB("AdmReason", myAry[0]);
}

function Balance_OnChange() {
	var balanceStr = DHCWeb_GetListBoxValue("BalanceList");
	var myAry = balanceStr.split("^");
	DHCWebD_SetObjValueB("balance", myAry[0]);
}

function InvNOType_OnChange() {
	var invNOTypeStr = DHCWeb_GetListBoxValue("InvNOTypeList");
	var myAry = invNOTypeStr.split("^");
	DHCWebD_SetObjValueB("invNoType", myAry[0]);
}

function PatType_OnChange() {
	var patTypeStr = DHCWeb_GetListBoxValue("PatTypeList");
	var myAry = patTypeStr.split("^");
	DHCWebD_SetObjValueB("PatType", myAry[0]);

	initInsType();      //add hujunbin 14.11.19
}

function GetUserId(value) {
	var obj = document.getElementById("admUserTo");
	obj.value = value.split("^")[1];
}

function outExcel_click() {
	getpath();
	Template = path + "住院票据明细.xls";
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Template);
	xlsheet = xlBook.ActiveSheet;

	var SelRowObj = document.getElementById('Tjobz' + 1);
	var job = SelRowObj.innerText;
	var Num = tkMakeServerCall("web.DHCIPBillInvDetailSearch", "GetNum", job);
	var startDate = document.getElementById("startDate");
	var endDate = document.getElementById("endDate");
	xlsheet.cells(2, 2).value = startDate.value + "--" + endDate.value;
	for (var i = 1; i <= Num; i++) {
		var PrintInfo = tkMakeServerCall("web.DHCIPBillInvDetailSearch", "GetData", job, i);
		var PrintInfo = PrintInfo.split("^");
		var DataLength = PrintInfo.length;
		for (j = 1; j <= DataLength; j++) {
			xlsheet.cells(3 + i, j).value = PrintInfo[j - 1];
		}
	}
	//xlsheet.printout;
	xlApp.Visible = true;
	xlsheet.PrintPreview();

	xlBook.Close(savechanges = false);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;
}
function getpath() {
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}
document.body.onload = BodyLoadHandler;
