var startdate;
var enddate;
var Guser=session['LOGON.USERID'];
var rtn="";
var pattypeobj;
function BodyLoadHandler() { 
	websys_setfocus('AbortNum');
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
	 pattypeobj=document.getElementById('pattype');
	SetItemReadOnly("invno",true);
	SetItemReadOnly("StartInvNO",true);
	SetItemReadOnly("EndInvNO",true);
	SetItemReadOnly("INVLeftNum",true);
	GetReceiptNo();
}

function Determine_click(){
	var Guser=session['LOGON.USERID'];
	var AbortUser=Guser;
	var myPINVFlag="Y";
	var myGroupDR=session['LOGON.GROUPID'];
	var invnoValue=document.getElementById("invno").value;
	var startno=document.getElementById("StartInvNO").value;
	var endno=document.getElementById("EndInvNO").value;
	var InsType=pattypeobj.value;   //增加收费类别取发票类型
	if(!checkno(endno)) {
		alert(t['02']);
		return false;
	}
	if (parseInt(endno,10)<parseInt(startno,10)){
		alert(t['03']);
		return false;
	}
	if (endno.length!=startno.length){
		alert(t['04']);
		return false;
	}
	if(AbortUser==""){
		alert(t['05']);
		return false;
	}
	var voidReaValue=document.getElementById("voidReason").value;
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
	var myExpStr=Guser+"^"+myGroupDR+"^"+invnoValue+"^"+voidReaValue+"^"+startno+"^"+endno+"^"+AbortNum+"^"+InsType;
	var myrtn=window.confirm("是否确认跳号?");
    if (!myrtn){
       		return myrtn;
	}
	rtn=tkMakeServerCall("web.UDHCJFPAY","VoidIPINV",myExpStr);
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
	var checktext="1234567890";
	for (var i = 0; i < inputtext.length; i++) {
		var chr = inputtext.charAt(i);
		var indexnum=checktext.indexOf(chr);
		if (indexnum<0)  return false;
	}
	return true;
}

function AbortNum_OnKeyUp() {
	var numobj=document.getElementById('AbortNum');
	var endnoobj=document.getElementById('EndInvNO');
	if (numobj) var num=numobj.value;
	if (num.indexOf("-")>-1){numobj.value="";return;}
	var obj=document.getElementById("INVLeftNum");
	var leftnum=obj.value;
	if (parseInt(num,10)>parseInt(leftnum,10)){
		alert("作废张数超出剩余张数，请重新输入");
		if (endnoobj) endnoobj.value="";
		numobj.value="";
		return;
		}
	var snoobj=document.getElementById('StartInvNO');
	if (snoobj) var sno=snoobj.value;
	var ssno="";
	var ssno1,slen,sslen;
	if (num==""||(parseInt(num,10)==0)) return;
	if (checkno(num)&&(sno!="")&&checkno(sno)){
		ssno1=parseInt(sno,10)+parseInt(num,10)-1;
		ssno=ssno1.toString();
		slen=sno.length;
		sslen=ssno.length;
		for (i=slen;i>sslen;i--){
			ssno="0"+ssno;
		}
		if (endnoobj) endnoobj.value=ssno;
	}
}
function GetReceiptNo() 
{
	var InsType=pattypeobj.value;   //增加收费类别取发票类型
	var rtn=tkMakeServerCall("web.UDHCJFPAY","ReceiptInvNO",Guser,InsType);
	if (rtn!='0')
	{
		var myary=rtn.split("^");
		var obj=document.getElementById("invno");
		if (obj){
			obj.value=myary[0];
		}
		var obj=document.getElementById("StartInvNO");
		if (obj){
			obj.value=myary[0];
		}
		var obj=document.getElementById("INVLeftNum");
		if (obj){
			obj.value=myary[4];
		}
		/*
   		var obj=document.getElementById("currentinvnotitle");     
   		if(obj){
   			curtinvnotobj.value=val[3];	 
   		} */                              
	}else {return false;}
}

///设置文本框的只读属性
function SetItemReadOnly(ItmName,ReadOnlyFlag){
	var obj=websys_$(ItmName);
	if(obj)obj.readOnly=ReadOnlyFlag;	
}
document.body.onload = BodyLoadHandler;




