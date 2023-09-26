/// udhcOPCashCal.js
/// Lid
/// 2010-07-08

function BodyLoadHandler() {
	var obj = document.getElementById("Return");
	if (obj) {
		obj.onclick = Return_OnClick;
	}
	var obj = document.getElementById("InvNum");
	if (obj) {
		obj.onkeypress = InvNum_KeyPress;
	}
	var obj = document.getElementById("GetCash");
	if (obj) {
		obj.onkeypress = GetCash_KeyPress;
	}
	var obj = document.getElementById("FootSum");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("CurrentInvNO");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("CASH");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("RoundErrAmt");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("PutCash");
	if (obj) {
		obj.readOnly = true;
	}
	var myFootSum = DHCWebD_GetObjValue("InvNum");
	if (myFootSum == "") {
		websys_setfocus("InvNum");
	} else {
		websys_setfocus("GetCash");
	}
	//+2017-09-07 ZhYW
	var obj = websys_$("Find");
	if (obj) {
		obj.onclick = FindClick;
	}
	document.onkeydown = OPCashCalOnKeydown;
}

function InvNum_KeyPress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	//控制只能输入数字
	if (((key > 47) && (key < 58)) || (key == 13)) {
		//如果输入金额过长导致溢出计算有误
		if (this.value.length > 11) {
			window.event.keyCode = 0;
			return websys_cancel();
		}
	} else {
		window.event.keyCode = 0;
		return websys_cancel();
	}
	//
	if (key == 13) {
		FindClick();
	}
}

function GetCash_KeyPress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var obj = document.getElementById("GetCash");
		if (isNumeric(obj.value)) {
			var objb = document.getElementById("CASH");
			var tmp = parseFloat(Number(obj.value)) - parseFloat(Number(objb.value));
			if (tmp < 0) {
				var truthBeTold = window.confirm(t["FeeErr"]);
				if (!truthBeTold) {
					return;
				}
			}
			var Resobj = document.getElementById("PutCash");
			DHCWeb_Calobj(obj, objb, Resobj, "-");
			//websys_setfocus("GetCash");
			var myGetCash = DHCWebD_GetObjValue("GetCash");
			if (myGetCash != "") {
				websys_setfocus("Return");
			} else {
				websys_setfocus("GetCash");
			}
		} else {
			alert(t["InputErr"]);
			document.getElementById("GetCash").value = "";
		}
	}
}

function Return_OnClick() {
	var Guser = DHCWebD_GetObjValue("Guser");
	var job = DHCWebD_GetObjValue("job");
	var rtn = tkMakeServerCall("web.DHCOPBillCalculatorLogic", "ClearTemporaryData", Guser, job);
	window.opener.parent.frames("udhcOPPatinfo").document.getElementById("PatientID").focus();
	window.close();
}

///Lid
///2010-03-23
function BodyUnLoadHandler() {
	var n = (window.event.screenX) - (window.screenLeft);
	var b = n > ((document.documentElement.scrollWidth) - 20);
	if (b && window.event.clientY < 0 || window.event.altKey) {
		var Guser = DHCWebD_GetObjValue("Guser");
		var job = DHCWebD_GetObjValue("job");
		var rtn = tkMakeServerCall("web.DHCOPBillCalculatorLogic", "ClearTemporaryData", Guser, job);
	}
}

function OPCashCalOnKeydown() {
	var keycode;
	try {
		keycode = websys_getKey(e);
	} catch (e) {
		keycode = websys_getKey();
	}
	if ((keycode == 67) && (event.altKey)) {
		Return_OnClick();
	}
}

/**
 * Creator: ZhYW
 * CreatDate: 2017-09-07
 */
function FindClick() {
	var Guser = DHCWebD_GetObjValue("Guser");
	var InvNum = DHCWebD_GetObjValue("InvNum");
	if (isInteger(InvNum)) {
		var rtn = tkMakeServerCall("web.DHCOPBillCalculatorLogic", "GetInvFeeData", Guser, "", InvNum);
		var tmpAry = rtn.split('^');
		DHCWebD_SetObjValueB('job', tmpAry[0]);
		DHCWebD_SetObjValueB('FootSum', tmpAry[1]);
		DHCWebD_SetObjValueB('RoundErrAmt', tmpAry[5]);
		DHCWebD_SetObjValueB('CASH', tmpAry[7]);
		websys_setfocus('GetCash');
		Find_click();
	} else {
		alert(t["InputErr"]);
		DHCWebD_SetObjValueB('InvNum', "");
	}
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = BodyUnLoadHandler;

/*
function BodyLoadHandler(){
	//window.close();
	var obj=document.getElementById("Return");
	if (obj){
		obj.onclick=Return_OnClick;
	}
	var obj=document.getElementById("GetCash");
	if (obj){
		obj.onkeypress=GetCash_KeyPress;
	}

	var obj=document.getElementById("FootSum");
	if (obj){
		obj.readOnly=true;
	}

	var obj=document.getElementById("PutCash");
	if (obj){
		obj.readOnly=true;
	}
	websys_setfocus("GetCash");

	var myFootSum=DHCWebD_GetObjValue("FootSum");
	if (myFootSum==""){
		ReadFSum();
	}else{

	}
	var myFootSum=DHCWebD_GetObjValue("FootSum");
	//var myXmlStr="<SPrice><Instruction>"+myFootSum+"J</Instruction><Instruction>W</Instruction></SPrice>";
	//SoundPrice(myXmlStr);
}

function ReadFSum(){
	var sUser=session['LOGON.USERID'];
	var obj=document.getElementById("RPFSumEnvrypt");
	if (obj){
		var encmeth=obj.value;
		if (encmeth!=""){
			var FootInfo=cspRunServerMethod(encmeth,sUser);
			var obj=document.getElementById("FootSum");
			if (obj){
				var myary=FootInfo.split("^");
				obj.value=myary[0];
			}
		}
	}
}

function GetCash_KeyPress(){
	var key=event.keyCode;
	if (key==13){
		var obj=document.getElementById("GetCash");
		var objb=document.getElementById("FootSum");
		var Resobj=document.getElementById("PutCash");
		DHCWeb_Calobj(obj,objb,Resobj,"-");
		//websys_setfocus("GetCash");
		var myGetCash=DHCWebD_GetObjValue("GetCash");
		//var obj=document.getElementById("Return");
		if (myGetCash != ""){
			websys_setfocus("Return");
		}else{
			websys_setfocus("GetCash");
		}
	}
}

function SoundPrice(XMLStr){
	var myEquipDR=DHCWebD_GetObjValue("EquipDR");
	var myXmlStr=XMLStr;			///"<SPrice><Instruction>W</Instruction><Instruction>12Z</Instruction></SPrice>";
	DHCWCOM_SoundQuotePrice(myEquipDR,myXmlStr);
}

function Return_OnClick(){
	var myGetSum=DHCWebD_GetObjValue("GetCash");
	var myReturnSum=DHCWebD_GetObjValue("PutCash");
	myReturnSum=parseFloat(myReturnSum);
	var myXmlStr="<SPrice><Instruction></Instruction></SPrice>";
	if ((myGetSum!="")&&(myReturnSum!="")){
		var myXmlStr="<SPrice><Instruction>"+myReturnSum+"Z</Instruction><Instruction>D</Instruction></SPrice>";
		SoundPrice(myXmlStr);
	}
	window.close();
}

document.body.onload = BodyLoadHandler;
*/
