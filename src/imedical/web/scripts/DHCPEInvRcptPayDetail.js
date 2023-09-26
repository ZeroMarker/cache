/// DHCPEInvRcptPayDetail.js
/// 创建时间		2007.10.22
/// 创建人			xuwm
/// 主要功能		体检收费员统计
/// 组件			DHCPEInvRcptPayDetail
/// 对应表			
/// 最后修改时间	
/// 最后修改人		

var CurrentSel=0;

function BodyLoadHandler() {

	var obj;
	
	obj=document.getElementById("Find")
	if (obj) { obj.onclick = Find_click; }
	
	obj=document.getElementById('Print');
	if (obj) { obj.onclick = Print_click; }
	
	obj=document.getElementById('UserName');
	if (obj) { obj.onchange = UserName_change; }
	
	obj=document.getElementById('PayModeDesc');
	if (obj) { obj.onchange = PayModeDesc_change; }
			
	iniForm();

}

function BodyUnLoadHandler() {

	var obj;

}

function iniForm() {
	var obj;

}

function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function Find_click(){
	var obj;
	var iUserID='', iUserName='', iBeginDate='', iEndDate='', iPayMode='', iPayModeDesc=''
		;
	obj=document.getElementById("UserID")
	if (obj) { iUserID = obj.value; }
	obj=document.getElementById("UserName")
	if (obj) { iUserName = obj.value; }	
	obj=document.getElementById("BeginDate")
	if (obj) { iBeginDate = obj.value; }	
	obj=document.getElementById("EndDate")
	if (obj) { iEndDate = obj.value; }
	obj=document.getElementById("PayMode")
	if (obj) { iPayMode = obj.value; }
	obj=document.getElementById("PayModeDesc")
	if (obj) { iPayModeDesc = obj.value; }
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEInvRcptPayDetail'
			+'&'+'UserID'+'='+iUserID
			+'&'+'UserName'+'='+iUserName
			+'&'+'BeginDate'+'='+iBeginDate
			+'&'+'EndDate'+'='+iEndDate
			+'&'+'PayMode'+'='+iPayMode
			+'&'+'PayModeDesc'+'='+iPayModeDesc
			;
	location.href=lnk;

}

// 月统计数据
function Print_click() {
	var obj;	
	var iUserID='', iBeginDate='', iEndDate='', iPayMode='', iPayModeDesc=""
			;
	obj=document.getElementById("ksrq")
	if (obj) { iBeginDate=obj.value; }	

	obj=document.getElementById("jsrq")
	if (obj) { iEndDate=obj.value; }
	obj=document.getElementById("tjsj")
	if (obj) { iCurDate=obj.value; }
	obj=document.getElementById("PayModeDesc")
	if (obj) { iPayModeDesc=obj.value; }
	InvRcptPayDetailPrint(iBeginDate, iEndDate,iCurDate, iPayModeDesc); // DHCPEInvRcptPayDetailPrint.js
}

function SetPayMode(value)
{
	var obj
	list = value.split("^");
	obj=document.getElementById("PayModeDesc")
	if (obj && list[0]) { obj.value=list[0]; }
	obj=document.getElementById("PayMode")
	if (obj && list[1]) { obj.value=list[1]; }	
}

function PayModeDesc_change() 
{
	obj = document.getElementById("PayMode")
	if (obj) { obj.value=''; }	
}

function GetUser(value)
{
	var obj
	list=value.split("^");
	obj=document.getElementById("UserName")
	if (obj && list[0]) { obj.value=list[1]; }
	obj=document.getElementById("UserID")
	if (obj && list[1]) { obj.value=list[2]; }	
}

function UserName_change() 
{
	obj=document.getElementById("UserID")
	if (obj) { obj.value=''; }	
}
document.body.onload = BodyLoadHandler;

/// 