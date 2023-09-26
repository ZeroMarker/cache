///DHCOPBillPayment.js
document.write('<Object type="application/x-oleobject" id=Shell classid="clsid:F935DC22-1CF0-11D0-ADB9-00C04FD58A0B">');
document.write('</Object>');

///定义分割符
var CH2=String.fromCharCode(2);
var CH3=String.fromCharCode(3); 
var CH4=String.fromCharCode(4); 
var CH5=String.fromCharCode(5); 
var isExpanded=false;  //下拉列表框是否展开
function BodyLoadHandler(){
	initDoc();	
	//listPaymode1_OnChange();
	//listPaymode2_OnChange();
}

function initDoc(){
	//初始化支付方式
	var obj=document.getElementById("listPaymode1");
   	if (obj){
	   	obj.onchange=listPaymode1_OnChange;
	   	//obj.onfocus=SelectBoxExtEnd;
	   	//obj.onclick=PayMode_OnClick;
	   	obj.onkeydown=PayMode_OnKeyDown;
	   	obj.multiple=false;
	   	obj.size=1;
   	}
	DHCWebD_ClearAllListA("listPaymode1");
	var encmeth=DHCWebD_GetObjValue("PMEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	var myInsType="";
	var myExpStr="";
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","listPaymode1",mygLoc, myInsType, myExpStr);
	}
	var PaymodeStatus1=DHCWebD_GetObjValue("PaymodeStatus1");
	if (PaymodeStatus1!=""){	
		DHCWeb_SetListDefaultValue("listPaymode1", PaymodeStatus1,"^",2)
	}
	
	var obj=document.getElementById("listPaymode2");
   	if (obj){
	   	obj.onchange=listPaymode2_OnChange;
	   	//obj.onfocus=SelectBoxExtEnd;
	   	//obj.onclick=PayMode_OnClick;
	   	obj.onkeydown=PayMode_OnKeyDown;
	   	obj.multiple=false;
	   	obj.size=1;
   	}
	DHCWebD_ClearAllListA("listPaymode2");
	var encmeth=DHCWebD_GetObjValue("PMEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	var myInsType="";
	var myExpStr="";
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","listPaymode2",mygLoc, myInsType, myExpStr);
	}
	var PaymodeStatus2=DHCWebD_GetObjValue("PaymodeStatus2");
	if (PaymodeStatus2!=""){	
		DHCWeb_SetListDefaultValue("listPaymode2", PaymodeStatus2,"^",2)
	}
	
	var obj=document.getElementById("listPaymode3");
   	if (obj){
	   	obj.onchange=listPaymode2_OnChange;
	   	//obj.onfocus=SelectBoxExtEnd;
	   	//obj.onclick=PayMode_OnClick;
	   	obj.onkeydown=PayMode_OnKeyDown;
	   	obj.multiple=false;
	   	obj.size=1;
   	}
	DHCWebD_ClearAllListA("listPaymode3");
	var encmeth=DHCWebD_GetObjValue("PMEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	var myInsType="";
	var myExpStr="";
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","listPaymode3",mygLoc, myInsType, myExpStr);
	}
	var PaymodeStatus3=DHCWebD_GetObjValue("PaymodeStatus3");
	if (PaymodeStatus3!=""){	
		DHCWeb_SetListDefaultValue("listPaymode3", PaymodeStatus3,"^",2)
	}
	
	var obj=document.getElementById("PM1Amt");
	if(obj){
	    obj.onkeydown=DHCWeb_SetLimitNumABCD;
	    obj.onkeypress=PM1Amt_onkeydown; 
	    obj.value=0.00
	}
	var obj=document.getElementById("PM2Amt");
	if(obj){
	    obj.onkeydown=DHCWeb_SetLimitNumABCD; 
	    obj.onkeypress=PM2Amt_onkeydown;
	    obj.value=0.00
	}
	var obj=document.getElementById("PM3Amt");
	if(obj){
	    obj.onkeydown=DHCWeb_SetLimitNumABCD; 
	    obj.onkeypress=PM3Amt_onkeydown; 
	    obj.value=0.00
	}
	var obj=document.getElementById("btnOK");
	if(obj){
	    obj.onclick=btnOK_OnClick; 
	}
	var obj=document.getElementById("btnCancel");
	if(obj){
	    obj.onclick=btnCancel_OnClick; 
	}
	var obj=websys_$("Calc");
	if(obj){
		obj.onclick=Calc_OnClick;	
	}
	var obj=websys_$("Actualmoney");
	if(obj){
		obj.onkeydown=DHCWeb_SetLimitNumABCD;
		obj.onkeypress=Actualmoney_OnKeyDown;	
	}
	var obj=websys_$("Change");
	if(obj){
		obj.readOnly=true;
		obj.onkeydown=Change_OnKeyDown;	
	}
	var prtRowidStr=DHCWebD_GetObjValue("PrtRowidStr"); //发票Rowid串
    var oldPayMDr=websys_$V("OldPayMRowid");  //原支付方式Rowid
    var obj=document.getElementById("listPaymode1");
	var myLen=obj.options.length;
	for (var i=0;i<myLen;i++){
		var mystr=obj.options[i].value;
		var myary=mystr.split("^");
		if (myary[0]==oldPayMDr){
			obj.selectedIndex=i;
			break;
		}
	}
	var rtn=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPatFeeInfoByPrtRowid",prtRowidStr);
	document.getElementById("txtPatShareAmt").value=rtn.split("^")[1];
	document.getElementById("PM1Amt").value=rtn.split("^")[1];
	websys_setfocus("PM1Amt");
	RemovePM()
}
function listPaymode1_OnChange(){
	var myINVFlag=DHCWeb_GetListBoxValue("listPaymode1");
	var myary=myINVFlag.split("^");
	var obj=document.getElementById("PaymodeStatus1");
	if(obj){
		obj.value=myary[0];
	}	
}
function listPaymode2_OnChange(){
	var myINVFlag=DHCWeb_GetListBoxValue("listPaymode2");
	var myary=myINVFlag.split("^");
	var obj=document.getElementById("PaymodeStatus2");
	if(obj){
		obj.value=myary[0];
	}	
}

function SelectBoxExtEnd(){
		//websys_$(name).focus();
		var WshShell = new ActiveXObject("Wscript.Shell");
		try{
		   if(!isExpanded){
		      WshShell.SendKeys("%{DOWN}");
			  isExpanded=true;
			  window.event.cancelBubble=true
			  //window.event.returnValue = false
		   }
		}
		catch(e){} 
		WshShell.Quit; 
}
function PayMode_OnClick(){
	isExpanded=false;	
}
function PayMode_OnKeyDown(){
		 var e = event?event:(window.event?window.event:null);
		 var key=websys_getKey(e);
		 var WshShell = new ActiveXObject("Wscript.Shell");
		 if(key==40){
		 	 if(!isExpanded){
		 		 WshShell.SendKeys("%{DOWN}");
		 		 isExpanded=true;
		 		 //alert(this.options.selectedIndex);
		 		 //this.options[1].selected=true; 
		     }
		 }else if(key==13){
			if(this.id=="listPaymode1"){
				websys_setfocus("PM1Amt");
			}else if(this.id=="listPaymode2"){
				websys_setfocus("PM2Amt");	
			}else if(this.id=="listPaymode3"){
				websys_setfocus("PM3Amt");
			}
		 	isExpanded=false;
		 }
		 WshShell.Quit;
}
function PayMode_OnKeyDownOLD(){
		var e = event?event:(window.event?window.event:null);
		var key=websys_getKey(e);
		if(key==13){
			if(this.id=="listPaymode1"){
				websys_setfocus("PM1Amt");
			}else if(this.id=="listPaymode2"){
				websys_setfocus("PM2Amt");	
			}else if(this.id=="listPaymode3"){
				websys_setfocus("btnOK");
			}
		}
}
function PM1Amt_onkeydown(){
	var e = event?event:(window.event?window.event:null);
	var key=websys_getKey(e);
	if (key==13){
		var patShareAmt=parseFloat(Number(document.getElementById("txtPatShareAmt").value));
		var payM1Amt=parseFloat(Number(document.getElementById("PM1Amt").value));
		var balance=(patShareAmt-payM1Amt).toFixed(2);
		if(balance<0){
			websys_setfocus("PM1Amt");
			return;
		}
		document.getElementById("PM2Amt").value=balance;
		document.getElementById("PM3Amt").value=0;	//金额一发生变化时，三赋值为0
		websys_setfocus2("PM2Amt");	
	}
}

function PM2Amt_onkeydown(){
	var e = event?event:(window.event?window.event:null);
	var key=websys_getKey(e);
	if (key==13){
		var patShareAmt=parseFloat(Number(document.getElementById("txtPatShareAmt").value));
		var payM1Amt=parseFloat(Number(document.getElementById("PM1Amt").value))
		var payM2Amt=parseFloat(Number(document.getElementById("PM2Amt").value))
		var balance=(patShareAmt-payM1Amt-payM2Amt).toFixed(2)
		if(eval(balance)<0){
			this.select();
			return;	
		}
		document.getElementById("PM3Amt").value=balance;
		/*if((this.value.Trim()=="")||(this.value==0)){
			websys_setfocus("btnOK");	
		}else{
			websys_setfocus("listPaymode3");	
		}*/
		var payM1Desc=DHCWebD_GetObjValue("listPaymode1");
		var payM1Amt=DHCWebD_GetObjValue("PM1Amt");
		var payM2Desc=DHCWebD_GetObjValue("listPaymode2");
		var payM2Amt=DHCWebD_GetObjValue("PM2Amt");
		if((payM1Desc!="现金")&&(payM2Desc!="现金")){
			websys_setfocus("btnOK");
		}else{
			websys_setfocus("Actualmoney");
		}
	}
		
}
function PM3Amt_onkeydown(){
	var e = event?event:(window.event?window.event:null);
	var key=websys_getKey(e);
	if (key==13){
		/*var patShareAmt=parseFloat(Number(document.getElementById("txtPatShareAmt").value));
		var payM2Amt=parseFloat(Number(document.getElementById("PM2Amt").value))
		var payM3Amt=parseFloat(Number(document.getElementById("PM3Amt").value))
		var balacne=(patShareAmt-payM2Amt-payM3Amt).toFixed(2);
		if(eval(balacne)<0){
			this.select();
			return;	
		}
		document.getElementById("PM1Amt").value=balacne
		*/
		websys_setfocus("btnOK");	
	}	
}

function btnOK_OnClick(){
	//生成支付方式串
	var rtn=""
	var prtRowidStr=DHCWebD_GetObjValue("PrtRowidStr"); //发票Rowid串
	var patShareAmt=DHCWebD_GetObjValue("txtPatShareAmt"); //病人自付金额
	var payM1Desc=DHCWebD_GetObjValue("listPaymode1");
	var payM1Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM1Desc)
	var payM1Amt=DHCWebD_GetObjValue("PM1Amt"); //支付方式一金额
	var payM2Desc=DHCWebD_GetObjValue("listPaymode2");
	var payM2Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM2Desc)
	var payM2Amt=DHCWebD_GetObjValue("PM2Amt"); //支付方式二金额
	var payM3Desc=DHCWebD_GetObjValue("listPaymode3");
	var payM3Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM3Desc)
	var payM3Amt=DHCWebD_GetObjValue("PM3Amt"); //支付方式二金额
	
	///2016-07-26 chenxi 不能选择医保相关的支付方式
	if (payM1Rowid!=""){
		var payM1Rowidflag=tkMakeServerCall("web.UDHCINVPRT","CheckYBPayMode",payM1Rowid);
		if ((payM1Rowidflag=="0")||(payM1Rowidflag==0)){
			alert("支付方式一不能选择医保报销的支付方式");
			return;
		} 
	}
	
	if (payM2Rowid!=""){
		var payM2Rowidflag=tkMakeServerCall("web.UDHCINVPRT","CheckYBPayMode",payM2Rowid);
		if ((payM2Rowidflag=="0")||(payM2Rowidflag==0)){
			alert("支付方式二不能选择医保报销的支付方式");
			return;
		} 
	}
	if (payM3Rowid!=""){
		var payM3Rowidflag=tkMakeServerCall("web.UDHCINVPRT","CheckYBPayMode",payM3Rowid);
		if ((payM3Rowidflag=="0")||(payM3Rowidflag==0)){
			alert("支付方式三不能选择医保报销的支付方式");
			return;
		} 
	}
	
	/*if(payM1Rowid===payM2Rowid){
		alert("两种支付方式相同,请核实!");
		return;	
	}*/
	var PayAmtSum=eval(Number(payM1Amt).toFixed(2))+eval(Number(payM2Amt).toFixed(2))+eval(Number(payM3Amt).toFixed(2))
	PayAmtSum=eval(PayAmtSum).toFixed(2)

	if(eval(Number(patShareAmt))!==PayAmtSum){
		
		alert("金额不平,请核实!");	
		return;
	}

    var payMInfo=payM1Rowid+"^"+payM1Amt+CH2+payM2Rowid+"^"+payM2Amt+CH2+payM3Rowid+"^"+payM3Amt;	
	window.returnValue=payMInfo;
	window.close();
}

function btnCancel_OnClick(){
   var truthBeTold = window.confirm(t['MSG1']);
   if (!truthBeTold) {return  }
	window.returnValue=-2;  
	window.close();
}
function Actualmoney_OnKeyDown(){
	var e = event?event:(window.event?window.event:null);
	var key=websys_getKey(e);
	if (key==13){
		if (Number(this.value)==""){
			websys_setfocus("btnOK");
			return;
		}
		var payM1Desc=DHCWebD_GetObjValue("listPaymode1");
		var payM1Amt=DHCWebD_GetObjValue("PM1Amt");
		var payM2Desc=DHCWebD_GetObjValue("listPaymode2");
		var payM2Amt=DHCWebD_GetObjValue("PM2Amt");
		var payM3Desc=DHCWebD_GetObjValue("listPaymode3");
		var payM3Amt=DHCWebD_GetObjValue("PM3Amt");
		var CASHAmt=0;
		if(payM1Desc=="现金"){
			CASHAmt=CASHAmt+parseFloat(payM1Amt);
		}
		if(payM2Desc=="现金"){
			CASHAmt=CASHAmt+parseFloat(payM2Amt);
		}
		if(payM3Desc=="现金"){
			CASHAmt=CASHAmt+parseFloat(payM3Amt);
		}
		var myCharge=this.value-CASHAmt;
		if(myCharge<0){
			alert("实付金额不足.");
			websys_setfocus("Actualmoney");
			return;
		}
		var Resobj=websys_$("Change");
		Resobj.value=eval(myCharge).toFixed(2);

		websys_setfocus("btnOK");

	}
}
function Change_OnKeyDown(){
	var e = event?event:(window.event?window.event:null);
	var key=websys_getKey(e);
	if (key==13){
		
	}
}

//删除左右两端的空格
function DHCWeb_Trim(str){   
	 return str.replace(/(^\s*)|(\s*$)/g, "");  
}  
//删除左边的空格
function DHCWeb_LTrim(str){   
	return str.replace(/(^\s*)/g,"");  
}  
//删除右边的空格
function DHCWeb_RTrim(str){   
	return str.replace(/(\s*$)/g,"");  
}  

///Lid
///2011-07-12
///启动计算器
function Calc_OnClick()
{
    var calc=new ActiveXObject("WScript.shell");
    calc.Run("calc");
}

function DHCWeb_SetLimitNumABCD(e){
	var e = event?event:(window.event?window.event:null);
	if(e){
		var key=e.keyCode;
	}else{
		var key=event.keyCode;	
	}
	if ((((key>47)&&(key<58))||(key==46)||(key==8)||((key>95)&&(key<106))||(key==37)||(key==38)||(key==39)||(key==40)||(key==110)||(key==190)||(key==13)))
	{}
	else
	{
		if(e){
			e.keyCode=0;	
		}else{
			event.returnValue=false;	
		}
		//
	}
}

//移除不需要使用的支付方式
function RemovePM(){
	var objde1=document.getElementById("listPaymode1");
	for(var i=objde1.options.length-1;i>=0;i--)
	{
		if(objde1.options[i].value.indexOf("ECPP")>-1)
		{
			objde1.remove(i);
		}
	}
	var objde2=document.getElementById("listPaymode2");
	for(var i=objde2.options.length-1;i>=0;i--)
	{
		if(objde2.options[i].value.indexOf("ECPP")>-1)
		{
			objde2.remove(i);
		}
	}
	var objde3=document.getElementById("listPaymode3");
	for(var i=objde3.options.length-1;i>=0;i--)
	{
		if(objde3.options[i].value.indexOf("ECPP")>-1)
		{
			objde3.remove(i);
		}
	}
}

/*
///Lid
///2010-03-23
///用于在点击IE右上角关闭按钮时做一个提示
function window.onbeforeunload(){
	 var   n   =   window.event.screenX   -   window.screenLeft;   
      var   b   =   n   >   document.documentElement.scrollWidth-20;   
      if(b   &&   window.event.clientY   <   0   ||   window.event.altKey)   
      {    
          window.event.returnValue= t['MSG2'];
          window.returnValue=-2;
      }
}
*/




document.body.onload = BodyLoadHandler;