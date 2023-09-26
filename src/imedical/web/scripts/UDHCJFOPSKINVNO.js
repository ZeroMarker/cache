var startdate
var enddate
var guser=session['LOGON.USERID'];
var rtn=""

function BodyLoadHandler() {  	
   	guser=session['LOGON.USERID'];
   	var guserobj=document.getElementById("guser");
   	guserobj.value=guser;
   	var Determineobj=document.getElementById("Determine");
   	if(Determineobj){
	   	 Determineobj.onclick=Determine_click;
	}
	
	var cancelobj=document.getElementById("Cancel");
	if(cancelobj){
	   	 cancelobj.onclick=cancel_click;
	}
	var Obj=document.getElementById("AbortNum");
	if(Obj){
	   	 Obj.onkeyup=AbortNum_OnKeyUp;
	}
	SetItemReadOnly("invno",true);
	SetItemReadOnly("StartInvNO",true);
	SetItemReadOnly("EndInvNO",true);
	SetItemReadOnly("INVLeftNum",true);
	GetReceiptNo();
	websys_setfocus('AbortNum');
}

function Determine_click(){
	var Guser=session['LOGON.USERID'];
	var AbortUser=Guser;
	var myPINVFlag="Y";
	var myGroupDR=session['LOGON.GROUPID'];
	var invnoValue=document.getElementById("invno").value;
	var startno=document.getElementById("StartInvNO").value;
	var endno=document.getElementById("EndInvNO").value;
	var CurrentInsType=document.getElementById("CurrentInsType").value;
	//zhangli  增加票据类型 17.7.28
	var receiptType = document.getElementById("receiptType").value;
	if (receiptType == "") {  
		alert('票据类型不能为空!');
		return;
	}
	/*
	if(!checkno(endno)) {
		alert(t['02']);
		//websys_setfocus('EndInvNO');
		return false;
	}*/
	if (parseInt(endno,10)<parseInt(startno,10)){
		alert(t['03']);
		//websys_setfocus('EndInvNO');
		return false;
	}
	if (endno.length!=startno.length){
		alert(t['04']);
		//websys_setfocus('EndInvNO');
		return false;
	}
	if(AbortUser==""){
		alert(t['06']);
		//websys_setfocus('lquser');
		return false;
	}
	var voidReaValue=document.getElementById("voidRea").value;
	if(voidReaValue==""){
		alert("作废原因不能为空!");
		return;
	}
	var AbortNum=document.getElementById("AbortNum").value;
	var MaxNum=document.getElementById("INVLeftNum").value;
	if(parseInt(AbortNum,10)>parseInt(MaxNum,10)){
		alert(t['07']);
		return;
	}
	var getVoidInvobj=document.getElementById('getVoidInvEncrypt');
	if (getVoidInvobj) {var encmeth=getVoidInvobj.value} else {var encmeth=''};
	var myExpStr=Guser+"^"+myGroupDR+"^"+invnoValue+"^"+voidReaValue+"^"+startno+"^"+endno+"^"+AbortNum+"^"+CurrentInsType;
	//zhangli  增加票据类型 17.7.28
	myExpStr += '^' + receiptType;  
	var myrtn=window.confirm("是否确认跳号?");
    if (!myrtn){
       return myrtn;
	}
	//alert(myExpStr);
	//return;
	rtn=cspRunServerMethod(encmeth,myExpStr);
	if (rtn!=0){	
		alert("作废发票失败!");
		return;
	}else{
		alert("作废发票成功!");
		window.opener.location.reload();
	}
	window.close();
}


function cancel_click(){
	  window.close();
}
function checkno(inputtext) {
	var checktext="1234567890"
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum=checktext.indexOf(chr);
		if (indexnum<0)  return false;
	}
	return true;
}
function AbortNum_OnKeyUp() {
	var numobj=document.getElementById('AbortNum');
	if (numobj) var num=numobj.value
	if (num.indexOf("-")>-1){numobj.value="";return;}
	var snoobj=document.getElementById('StartInvNO');
	if (snoobj) var sno=snoobj.value;
	var ssno="";
	var ssno1,slen,sslen;
	if (num==""||(parseInt(num,10)==0)) return;
	var snost=sno.substring(0,1);
	var snoend=sno.substring(1);
	if (checkno(num)&&(sno!="")&&checkno(snoend)){
		ssno1=parseInt(snoend,10)+parseInt(num,10)-1;
		ssno=ssno1.toString();
		slen=snoend.length;
		sslen=ssno.length;
		for (i=slen;i>sslen;i--){
			ssno="0"+ssno;
		}
		ssno=snost+ssno;
	
		var endnoobj=document.getElementById('EndInvNO');
		if (endnoobj) endnoobj.value=ssno;
	}
}
function GetReceiptNo(){
	
	//门诊发票
	var receiptType = document.getElementById("receiptType").value;
	var Guser = session['LOGON.USERID'];
	var currentInsType = document.getElementById('CurrentInsType').value;
	if (receiptType == 'OP'){
		var receipNOobj=document.getElementById('GetOPreceipNO');
		if (receipNOobj) {var encmeth=receipNOobj.value} else {var encmeth=''};
		var myPINVFlag="Y";
		var myGroupDR=session['LOGON.GROUPID'];
		var myExpStr=Guser+"^"+myPINVFlag+"^"+myGroupDR+"^"+"F"+"^"+currentInsType;
		rtn=cspRunServerMethod(encmeth,"SetReceipNO","",myExpStr);	
	}else if (receiptType == 'OD'){
		//门诊预交金
		var receiptNOobj = document.getElementById('GetPreReceipNO');
		if (receiptNOobj) {
			var encmeth = receiptNOobj.value;
		} else {
			var encmeth = '';
		}
		var rtn = cspRunServerMethod(encmeth, Guser, receiptType);
		var myary = rtn.split("^");
		DHCWebD_SetObjValueA("invno", myary[3]);
		DHCWebD_SetObjValueA("StartInvNO", myary[3]);
		DHCWebD_SetObjValueA("INVLeftNum", myary[6]);
	}else {
		//住院押金
		var receiptNOobj = document.getElementById('GetIDReceipNO');
		if (receiptNOobj) {
			var encmeth = receiptNOobj.value;
		} else {
			var encmeth = '';
		}
		var Guser = session['LOGON.USERID'];
		var rtn = cspRunServerMethod(encmeth, 'SetIDepRcptNo', '', Guser, receiptType);
	}
}

function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	var obj=document.getElementById("invno");
	if (obj){
		obj.value=ls_ReceipNo;
	}
	var obj=document.getElementById("StartInvNO");
	if (obj){
		obj.value=ls_ReceipNo;
	}
	DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
}
///设置文本框的只读属性
function SetItemReadOnly(ItmName,ReadOnlyFlag){
	var obj=websys_$(ItmName);
	if(obj)obj.readOnly=ReadOnlyFlag;	
}
/**
* Creator: ZhYW
* CreatDate: 2016-12-16
*/
function SetIDepRcptNo(value) {
	var myary = value.split("^");
	DHCWebD_SetObjValueA("invno", myary[2]);
	DHCWebD_SetObjValueA("StartInvNO", myary[2]);
	DHCWebD_SetObjValueA("INVLeftNum", myary[4]);
}
document.body.onload = BodyLoadHandler;




