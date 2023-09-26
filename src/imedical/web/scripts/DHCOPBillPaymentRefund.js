///DHCOPBillPaymentRefund.js
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
	   	obj.onkeyup=PM1Amt_onkeyup;
	    obj.value=0.00
	}
	var obj=document.getElementById("PM2Amt");
	if(obj){
	    obj.onkeydown=DHCWeb_SetLimitNumABCD;
	    obj.onkeypress=PM2Amt_onkeydown;
	   	obj.onkeyup=PM2Amt_onkeyup;
	    obj.value=0.00
	}
	var obj=document.getElementById("PM3Amt");
	if(obj){
	    obj.onkeydown=DHCWeb_SetLimitNumABCD;
	    obj.onkeypress=PM3Amt_onkeydown;
	   	obj.onkeyup=PM3Amt_onkeyup;
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
	var newprtRowid=websys_$V("NewPrtRowid"); //新发票Rowid串
    var oldPrtRowid=websys_$V("OldPrtRowid");  //原发票Rowid
    var oldPayMStr=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMListByPrtRowid",oldPrtRowid);
    var paymAry=oldPayMStr.split("!");
    var oldPayMList=document.getElementById("OldPayMList");
	for (var i=0;i<paymAry.length;i++){
		var oldPayMDesc=paymAry[i].split("^")[2];
		var oldPayMAmt=paymAry[i].split("^")[3];
		var option=document.createElement("option");
		option.value=paymAry[i];
		option.text=oldPayMDesc+":"+oldPayMAmt;		
		oldPayMList.add(option);
	}
	//alert(oldPrtRowid+","+newprtRowid);
	var rtn=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetRefundAmtByPrtRowid",oldPrtRowid,newprtRowid);
	websys_$("factRefundAmt").value=rtn.split("^")[3];
	//
	//初始化每种支付方式的退费金额
	var RefPayMList=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","CalcRefundPayMAmt",oldPrtRowid,newprtRowid);
	var RefPayMAry=RefPayMList.split("!");
	//alert(RefPayMAry);
	for(var i=1;i<RefPayMAry.length;i++){
		var tmp=RefPayMAry[i];
		if(tmp=="")continue;
		var RefPayMDR=tmp.split("^")[0];
		var RefPayMCode=tmp.split("^")[1];
		var RefPayMAmt=tmp.split("^")[3];
		if(i==1){
			DHCWeb_SetListDefaultValue("listPaymode1", RefPayMCode,"^",2);
			DHCWebD_SetObjValueB("PM1Amt",+RefPayMAmt);
		}else if(i==2){
			DHCWeb_SetListDefaultValue("listPaymode2", RefPayMCode,"^",2);
			DHCWebD_SetObjValueB("PM2Amt",+RefPayMAmt);
		}else{
			DHCWeb_SetListDefaultValue("listPaymode3", RefPayMCode,"^",2);
			DHCWebD_SetObjValueB("PM3Amt",+RefPayMAmt);
		}
	}
    websys_setfocus("btnOK");
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
		WshShell=null; 
}
function PayMode_OnClick(){
	isExpanded=false;	
}
function PayMode_OnKeyDown(){
		 var key=window.event.keyCode;
		 var WshShell = new ActiveXObject("Wscript.Shell");
		 if(key==40){
		 	 if(!isExpanded){
		 		 WshShell.SendKeys("%{DOWN}");
		 		 isExpanded=true;
		 		 //alert(this.options.selectedIndex);
		 		 this.options[1].selected=true; 
		     }
		 }else if(key==13){
			if(this.id=="listPaymode1"){
				websys_setfocus2("PM1Amt");
			}else if(this.id=="listPaymode2"){
				websys_setfocus2("PM2Amt");	
			}else if(this.id=="listPaymode3"){
				websys_setfocus2("PM3Amt");
			}
		 	isExpanded=false;
		 }
		 WshShell.Quit;
}
function PayMode_OnKeyDownOLD(){
		var key=window.event.keyCode;
		if(key==13){
			if(this.id=="listPaymode1"){
				websys_setfocus2("PM1Amt");
			}else if(this.id=="listPaymode2"){
				websys_setfocus2("PM2Amt");	
			}else if(this.id=="listPaymode3"){
				websys_setfocus2("btnOK");
			}
		}
}
function PM1Amt_onkeydown(){
	var key=window.event.keyCode;
	if (key==13){
		var factRefundAmt=parseFloat(Number(document.getElementById("factRefundAmt").value));
		var payM1Desc=DHCWebD_GetObjValue("listPaymode1");
	    var payM1Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM1Desc)
		var payM1Amt=parseFloat(Number(document.getElementById("PM1Amt").value))
		if(!CheckRefundAmt(payM1Rowid,payM1Amt)){
			alert("退费金额不能大于原收费金额.");
			websys_setfocus2("PM1Amt");
			return;
		}
		document.getElementById("PM2Amt").value=(factRefundAmt-payM1Amt).toFixed(2);
		//document.getElementById("PM2Amt").value=0.00;
		websys_setfocus2("listPaymode2");	
	}
}

function PM1Amt_onkeyup(){
	var key=window.event.keyCode;
	if (key!=13){
		var factRefundAmt=parseFloat(Number(document.getElementById("factRefundAmt").value));
		var payM1Desc=DHCWebD_GetObjValue("listPaymode1");
	    var payM1Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM1Desc)
		var payM1Amt=parseFloat(Number(document.getElementById("PM1Amt").value))
		if(!CheckRefundAmt(payM1Rowid,payM1Amt)){
			alert("退费金额不能大于原收费金额.");
			document.getElementById("PM1Amt").value="";
			websys_setfocus2("PM1Amt");
			return;
		}
	}
}

function PM2Amt_onkeydown(){
	var key=window.event.keyCode;
	if (key==13){
		var factRefundAmt=parseFloat(Number(document.getElementById("factRefundAmt").value));
		var payM2Desc=DHCWebD_GetObjValue("listPaymode2");
	    var payM2Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM2Desc)
		var payM2Amt=parseFloat(Number(document.getElementById("PM2Amt").value))
		if(!CheckRefundAmt(payM2Rowid,payM2Amt)){
			alert("退费金额不能大于原收费金额.");
			websys_setfocus2("PM2Amt");
			return;
		}
		var payM1Amt=parseFloat(Number(document.getElementById("PM1Amt").value))
		document.getElementById("PM3Amt").value=(factRefundAmt-payM1Amt-payM2Amt).toFixed(2)
		if((this.value.Trim()=="")||(this.value==0)){
			websys_setfocus2("btnOK");	
		}else{
			websys_setfocus2("listPaymode3");	
		}
	}
		
}

function PM2Amt_onkeyup(){
	var key=window.event.keyCode;
	if (key!=13){
		var factRefundAmt=parseFloat(Number(document.getElementById("factRefundAmt").value));
		var payM2Desc=DHCWebD_GetObjValue("listPaymode2");
	    var payM2Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM2Desc)
		var payM2Amt=parseFloat(Number(document.getElementById("PM2Amt").value))
		if(!CheckRefundAmt(payM2Rowid,payM2Amt)){
			alert("退费金额不能大于原收费金额.");
			document.getElementById("PM2Amt").value="";
			websys_setfocus2("PM2Amt");
			return;
		}
	}
}

function PM3Amt_onkeydown(){
	var key=window.event.keyCode;
	if (key==13){
		var factRefundAmt=parseFloat(Number(document.getElementById("factRefundAmt").value));
	    var payM3Desc=DHCWebD_GetObjValue("listPaymode3");
	    var payM3Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM3Desc)
		var payM3Amt=parseFloat(Number(document.getElementById("PM3Amt").value))
		if(!CheckRefundAmt(payM3Rowid,payM3Amt)){
			alert("退费金额不能大于原收费金额.");
			websys_setfocus2("PM3Amt");
			return;
		}
		websys_setfocus2("btnOK");	
	}	
}

function PM3Amt_onkeyup(){
	var key=window.event.keyCode;
	if (key!=13){
		var factRefundAmt=parseFloat(Number(document.getElementById("factRefundAmt").value));
	    var payM3Desc=DHCWebD_GetObjValue("listPaymode3");
	    var payM3Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM3Desc)
		var payM3Amt=parseFloat(Number(document.getElementById("PM3Amt").value))
		if(!CheckRefundAmt(payM3Rowid,payM3Amt)){
			alert("退费金额不能大于原收费金额.");
			document.getElementById("PM3Amt").value="";
			websys_setfocus2("PM3Amt");
			return;
		}
	}
}

///验证退费金额是否大于原支付方式金额
function CheckRefundAmt(refundPayMDr,refundAmt){
	if (+refundAmt==0){
		return true;	//如果退费金额为0，不需要验证了
	}
	var oldPayMList=document.getElementById("OldPayMList");
	var mylen=oldPayMList.options.length;
	for (var myIdx=0;myIdx<mylen;myIdx++){
		var payMListArry=oldPayMList.options[myIdx].value.split("^");
		var payMDr=payMListArry[0];
		var payMAmt=payMListArry[3];
		//alert(refundPayMDr+"^"+eval(payMAmt)+"^"+eval(refundAmt))
		if((refundPayMDr==payMDr)&&(eval(payMAmt)>=eval(refundAmt))){
			 return true;	
		}
	}
	
	return false;
}
function btnOK_OnClick(){
	//生成支付方式串
	var rtn=""
	var factRefundAmt=DHCWebD_GetObjValue("factRefundAmt"); //病人自付金额
	var payM1Desc=DHCWebD_GetObjValue("listPaymode1");
	var payM1Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM1Desc)
	var payM1Amt=DHCWebD_GetObjValue("PM1Amt"); //支付方式一金额
	var payM2Desc=DHCWebD_GetObjValue("listPaymode2");
	var payM2Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM2Desc)
	var payM2Amt=DHCWebD_GetObjValue("PM2Amt"); //支付方式二金额
	var payM3Desc=DHCWebD_GetObjValue("listPaymode3");
	var payM3Rowid=tkMakeServerCall("web.DHCOPBillManyPaymentLogic","GetPayMDrByPayMDesc",payM3Desc)
	var payM3Amt=DHCWebD_GetObjValue("PM3Amt"); //支付方式二金额
	
	/*if(payM1Rowid===payM2Rowid){
		alert("两种支付方式相同,请核实!");
		return;	
	}*/
	var PayAmtSum=eval(Number(payM1Amt).toFixed(2))+eval(Number(payM2Amt).toFixed(2))+eval(Number(payM3Amt).toFixed(2))
	PayAmtSum=eval(PayAmtSum).toFixed(2)

	//if((!CheckRefundAmt(payM1Rowid,+payM1Amt))||(!CheckRefundAmt(payM2Rowid,+payM2Amt))||(!CheckRefundAmt(payM3Rowid,+payM3Amt))){
			
			if(!CheckRefundAmt(payM1Rowid,+payM1Amt)){
				alert("退费金额不能大于原收费金额.111");
				document.getElementById("PM1Amt").value=0;
				return;
			}
			if(!CheckRefundAmt(payM2Rowid,+payM2Amt)){
				alert("退费金额不能大于原收费金额.222");
				document.getElementById("PM2Amt").value=0;
				return;
			}
			if(!CheckRefundAmt(payM3Rowid,+payM3Amt)){
				alert("退费金额不能大于原收费金额.3333");
				document.getElementById("PM3Amt").value=0;
				return;
			}
			//return;
	//}
	
	if(eval(Number(factRefundAmt))!==PayAmtSum){
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
	window.returnValue=-2;  //撤销回滚
	window.close();
}

///Lid
///2011-07-12
///启动计算器
function Calc_OnClick()
{
    var calc=new ActiveXObject("WScript.shell");
    calc.Run("calc");
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

function DHCWeb_SetLimitNumABCD(e){
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

///Lid
///2010-03-23
///用于在点击IE右上角关闭按钮时做一个提示
document.body.onbeforeunload = function (){
		/*
	  var n = window.event.screenX - window.screenLeft;   
      var b = n > document.documentElement.scrollWidth-20;   
      if(b && window.event.clientY < 0 || window.event.altKey)   
      {    
          window.event.returnValue= "如关闭此窗口,则按系统默认的支付方式进行结算。";
          window.returnValue=-2;
      }
	  */
}
document.body.onload = BodyLoadHandler;