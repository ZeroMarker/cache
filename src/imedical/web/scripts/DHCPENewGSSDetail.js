
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var objArr=document.getElementsByTagName("textarea");
	var objLength=objArr.length;
	for (var i=0;i<objLength;i++)
	{
		if (objArr[i].id=="GSSDetail")
		{
		 var GSID="";
		 var obj=document.getElementById("GSID");
	     if (obj) GSID=obj.value;
		 var ret= tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","OutGSSDetail1",GSID);
		 var obj=document.getElementById("GSSDetail");
	     if (obj) obj.value=ret;
		}
		setTareaAutoHeight(objArr[i]);
	}
	var GSSDetailObj=document.getElementById("GSSDetail");
	
	var obj=document.getElementById("OK");
	if(obj) obj.onclick=SaveGSSDetail;
	var obj=document.getElementById("Cancel");
	if(obj) obj.onclick=Close;
	//var tempText=objArr.createTextRange(); 
	//tempText.moveEnd("character",0-tempText.text.length); 
	//tempText.select(); 
	//websys_setfocus('OK');
	setTimeout(function(){
			setTextSelected(GSSDetailObj,0,1);
			//document.getElementById("OK").focus();
	},500);	
}
function GSSDetailKeyDown()
{
	return ;
	if(window.event.keyCode != 32) return;
	var curtr = document.getElementById("GSSDetail");
	var o = document.createElement("<span style='width:20px; background-color:white;margin:0px;padding:0px;'></span>");
	curtr.appendChild(o);
	window.event.returnValue = false; 
}
function setTextSelected(inputDom, startIndex, endIndex)
 {
	if (CurisIE()=="-1"){
		if (inputDom.setSelectionRange)
		{  
			inputDom.setSelectionRange(startIndex, endIndex);  
		}
	}
    else if (inputDom.createTextRange) //IE 
    {
         var range = inputDom.createTextRange();  
        range.collapse(true);  
        range.moveStart('character', startIndex);  
        range.moveEnd('character', endIndex - startIndex-1);  
        range.select();
     }  
	   inputDom.focus();  
}
//ÅÐ¶ÏÊÇ·ñÊÇIEä¯ÀÀÆ÷  
function CurisIE()  
{  
	var userAgent = navigator.userAgent; //È¡µÃä¯ÀÀÆ÷µÄuserAgent×Ö·û´® 
	var isOpera = userAgent.indexOf("Opera") > -1
	var cisIE = userAgent.indexOf("compatible") > -1  && userAgent.indexOf("MSIE") > -1 && !isOpera; //ÅÐ¶ÏÊÇ·ñIEä¯ÀÀÆ÷  
	if(cisIE)  
	{  
		return "1";  
	}  
	else  
	{  
		if (userAgent.indexOf("rv:11.0") > -1) return "1";  //ie11
		return "-1";  
	}  
}

function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
	if (e.scrollHeight<32){
		e.style.height=32+"px";
	}else{
		e.style.height = e.scrollHeight + "px";
	}
	websys_setfocus('OK');
}
function SaveGSSDetail()
{
	
	var obj,encmeth,GSID,GSSDetail;
	var obj=document.getElementById("UpdateGSSDetail");
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("GSID");
	if (obj) GSID=obj.value;
	obj=document.getElementById("GSSDetail");
	if (obj) GSSDetail=obj.value;
	var ret=cspRunServerMethod(encmeth,GSID,GSSDetail);
	
	if (window.opener) {
       window.opener.returnValue = 1;
	}
	else {
       window.returnValue = 1;
	}
	window.close();
	return false;
	//window.returnValue=1;
	
	
}
function Close()
{
	if (window.opener) {
       window.opener.returnValue = 2;
	}
	else {
       window.returnValue = 2;
	}
	//window.returnValue=0;
	window.close();
	return false;
}
