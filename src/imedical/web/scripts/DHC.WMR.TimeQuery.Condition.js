function BtnAddOnClick1()
{
	var objSrc = window.event.srcElement;
	var	strRelCondition = "RelConOne";
	var	strValueCondition = "DesCondition";
	var	strComCondition ="ComConditionOne";
	var	strAreaCondition = "TextOne";
	var	strValue="DisArea";
	if (typeof(strValue)=="undefined") return;
	MakeExpress(strValue,strRelCondition,strValueCondition,strComCondition,strAreaCondition);
	/*
			strOlderValue = getElementValue(strValue);
			setElementValue(strValue,
			strOlderValue+(strOlderValue==""?"":getElementValue(strRelCondition, document, true)+" ")+
			 "(<" +  getElementValue(strValueCondition, document, true)   + "> " + getElementValue(strComCondition, document, true)  +" "+String.fromCharCode(34)+ getElementValue(strAreaCondition, document, true) +String.fromCharCode(34)+ ")")
    */
}
function BtnAddOnClick2()
{
	var objSrc = window.event.srcElement;
	var	strRelCondition = "RelConTwo";
	var	strValueCondition = "IPCondition";
	var	strComCondition = "ComConditionTwo";	
	var	strAreaCondition = "TextTwo";
	var	strValue = "AdmArea";
	if (typeof(strValue)=="undefined") return;
	MakeExpress(strValue,strRelCondition,strValueCondition,strComCondition,strAreaCondition);
	/*
			strOlderValue = getElementValue(strValue);
			setElementValue(strValue,
			strOlderValue+(strOlderValue==""?"":getElementValue(strRelCondition, document, true)+" ")+
			 "(<" +  getElementValue(strValueCondition, document, true)   + "> " + getElementValue(strComCondition, document, true)  +" "+String.fromCharCode(34)+ getElementValue(strAreaCondition, document, true) +String.fromCharCode(34)+ ")")
    */
}
function BtnAddOnClick3()
{
	var objSrc = window.event.srcElement;
	var	strRelCondition = "RelConThree";
	var	strValueCondition = "PatmasCondition";
	var	strComCondition = "ComConditionThree";		
	var	strAreaCondition = "TextThree";
	var	strValue = "BaseArea"
	if (typeof(strValue)=="undefined") return;
    MakeExpress(strValue,strRelCondition,strValueCondition,strComCondition,strAreaCondition);
    /*
			strOlderValue = getElementValue(strValue);
			setElementValue(strValue,
			strOlderValue+(strOlderValue==""?"":getElementValue(strRelCondition, document, true)+" ")+
			 "(<" +  getElementValue(strValueCondition, document, true)   + "> " + getElementValue(strComCondition, document, true)  +" "+String.fromCharCode(34)+ getElementValue(strAreaCondition, document, true) +String.fromCharCode(34)+ ")")
    */
}
function BtnAddOnClick4()
{
	var objSrc = window.event.srcElement;
	var	strRelCondition = "RelConFour";
	var	strValueCondition = "AddCondition";
	var	strComCondition = "ComConditionFour";	
	var	strAreaCondition = "TextFour";
	var	strValue = "AddArea"
	if (typeof(strValue)=="undefined") return;
	MakeExpress(strValue,strRelCondition,strValueCondition,strComCondition,strAreaCondition);
	/*
			strOlderValue = getElementValue(strValue);
			setElementValue(strValue,
			strOlderValue+(strOlderValue==""?"":getElementValue(strRelCondition, document, true)+" ")+
			 "(<" +  getElementValue(strValueCondition, document, true)   + "> " + getElementValue(strComCondition, document, true)  +" "+String.fromCharCode(34)+ getElementValue(strAreaCondition, document, true) +String.fromCharCode(34)+ ")")
    */
}
function BtnAddOnClick()
{
	var objSrc = window.event.srcElement;
	var strRelCondition = "";
	var strValueCondition = "";
	var strComCondition = "";
	var strAreaCondition = "";

	switch(objSrc.id)
	{
		case "AddOne":
			strRelCondition = "RelConOne";
			strValueCondition = "DesCondition";
			strComCondition ="ComConditionOne";
			strAreaCondition = "TextOne";
			strValue="DisArea";
			break;
		case "AddTwo":
			strRelCondition = "RelConTwo";
			strValueCondition = "IPCondition";
			strComCondition = "ComConditionTwo";	
			strAreaCondition = "TextTwo";
			strValue = "AdmArea";
			break;
		case "AddThree":
			strRelCondition = "RelConThree";
			strValueCondition = "PatmasCondition";
			strComCondition = "ComConditionThree";		
			strAreaCondition = "TextThree";
			strValue = "BaseArea"	
			break;
		case "AddFour":
			strRelCondition = "RelConFour";
			strValueCondition = "AddCondition";
			strComCondition = "ComConditionFour";	
			strAreaCondition = "TextFour";
			strValue = "AddArea"	
			break;
	}	
	
	if (typeof(strValue)=="undefined") return;
	/*
			strOlderValue = getElementValue(strValue);
			setElementValue(strValue,
			strOlderValue+(strOlderValue==""?"":getElementValue(strRelCondition, document, true)+" ")+
			 "(<" +  getElementValue(strValueCondition, document, true)   + "> " + getElementValue(strComCondition, document, true)  +" "+encodeURI(String.fromCharCode(34))+ getElementValue(strAreaCondition, document, true) +encodeURI(String.fromCharCode(34))+ ")")
    */
    MakeExpress(strValue,strRelCondition,strValueCondition,strComCondition,strAreaCondition);
    
}
function MakeExpress(strValue,strRelCondition,strValueCondition,strComCondition,strAreaCondition){
		StringOlderValue = getElementValue(strValue);
		StringRelCondition=getElementValue(strRelCondition, document, true);
		StringValueCondition=getElementValue(strValueCondition, document, true);
		StringComCondition=getElementValue(strComCondition, document, true);
		StringAreaCondition=getElementValue(strAreaCondition, document, true);
		if ((StringValueCondition.indexOf("日期")>-1)||(StringValueCondition.indexOf("生日")>-1)){
		   var ObjConvertDateToInt=document.getElementById("ConvertDateToInt")
		   if (ObjConvertDateToInt){
			   var Method=ObjConvertDateToInt.value;
		    }
		    var DateInt=cspRunServerMethod(Method,StringAreaCondition);
		    if (DateInt!="") {
		       StringAreaCondition=DateInt;
		    }
		}
		StringValue=StringOlderValue+(StringOlderValue==""?"":StringRelCondition+" ")+
			 "(<" +  StringValueCondition   + "> " + StringComCondition  +" "+String.fromCharCode(34)+ StringAreaCondition +String.fromCharCode(34)+ ")"
	    setElementValue(strValue,StringValue)
	    /*	
			setElementValue(strValue,
			strOlderValue+(strOlderValue==""?"":getElementValue(strRelCondition, document, true)+" ")+
			 "(<" +  getElementValue(strValueCondition, document, true)   + "> " + getElementValue(strComCondition, document, true)  +" "+encodeURI(String.fromCharCode(34))+ getElementValue(strAreaCondition, document, true) +encodeURI(String.fromCharCode(34))+ ")")
        */
}
function BuildBinExpress(str)
{
	var strTmp = "";
	for(var i = 0; i < str.length; i ++)
	{
		strTmp += "$c(" + str.charCodeAt(i) + ")";
		if(i < str.length - 1)
			strTmp +="_";	
	}
	return strTmp;	
}
function BuildExpress(strArg, objCbo, from, after)
{
	var objItem = null;
	var arryOption = null;
	var strTmp = strArg;
	arryOption = objCbo.options;
	//alert(arryOption.length)
	for(var j = 1; j < arryOption.length; j ++)
	{
		objItem = arryOption[j];
		strTmp = ReplaceText(strTmp, "<" + objItem.innerText + ">" , from + objItem.value + after);
	}
	return strTmp;
}
function BuildDisOpeExpress(strArg, objCbo, from, after)
{
	var objItem = null;
	var strTmp = strArg;
	for(var j = 0; j < arryICDFields.length; j ++)
	{
		objItem = arryICDFields[j];
		strTmp = ReplaceText(strTmp, "<" + objItem.Description + ">", from + objItem.Code + after);
	}
	return strTmp;
}
function ConvertToCharCode(OldStr){
	 var strTmp="";
	 for(var i = 0; i < OldStr.length; i ++)
     {
            strTmp += OldStr.charCodeAt(i) + "-";
     }
     return strTmp
}
function btnQueryOnClick(){
	var strDisCondition = getElementValue("DisArea");
	
	//var strDisCondition=encodeURI(strDisCondition)
	var strAdmCondition = getElementValue("AdmArea");
	var strBaseCondition = getElementValue("BaseArea");
	var strAddCondition = getElementValue("AddArea");
	if(strDisCondition!=""){
		//strDisCondition=strDisCondition.substring(3);
		//strDisCondition="$c(2)_"+strDisCondition+"_$c(1)"
		//strDisCondition=strDisCondition	
		var str="";
	    var leftFirstStr=strDisCondition.substring(0,1);
	    
	    if (leftFirstStr=="-"){
	    	str=str+"-"+String.fromCharCode(2)+strDisCondition.substring(strDisCondition.length-2,strDisCondition.length-1);
	    }else{
	    	str=str+String.fromCharCode(2)+strDisCondition;
	    }
	    str=str+String.fromCharCode(1);
	    strDisCondition=str;
	}
	
	if (strAdmCondition != "" ){
		//strAdmCondition=strDisCondition.substring(3);
	}
	if(strBaseCondition != "" ){
		//strBaseCondition=strBaseCondition.substring(3);
	}
	if(strAddCondition != "" ){
		//strAddCondition=strAddCondition.substring(3);
	}
	var FromDate="",ToDate="",SimpleOutput="";
	var obj=document.getElementById("FromDate");
	if (obj){
		FromDate=obj.value;	
	}
	var obj=document.getElementById("EndDate");
	if (obj){
		ToDate=obj.value;	
	}
	var obj=document.getElementById("ShortQuery");
	if (obj){
		if(obj.checked){
			SimpleOutput=1;
		}else{
			SimpleOutput=0;	
		}
	}
		var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.TimeQuery.List"+
		"&FromDate="+FromDate+
		"&ToDate="+ToDate+
		"&ICDInfo="+ConvertToCharCode(strDisCondition)+
		"&AdmitInfo="+ConvertToCharCode(strAdmCondition)+
		"&BaseInfo="+ConvertToCharCode(strBaseCondition) +
		"&ExtraInfo="+ConvertToCharCode(strAddCondition)+
		"&SimpleOutput="+SimpleOutput;
	//window.parent.RPBottom.location.href = decodeURIComponent(strUrl);
	window.parent.RPBottom.location.href = strUrl;
}
function btnExport()
{

	var strDisCondition = getElementValue("DisArea");
	var strAdmCondition = getElementValue("AdmArea");
	var strBaseCondition = getElementValue("BaseArea");
	var strAddCondition = getElementValue("AddArea");
	if(strDisCondition != "" ){
		var str=""
	    var leftFirstStr=strDisCondition.substring(0,1)
	    if (leftFirstStr=="-"){
	    	str=str+"-"+String.fromCharCode(2)+strDisCondition.substring(strDisCondition.length-2,strDisCondition.length-1)
	    }else{
	    	str=str+encodeURI(String.fromCharCode(2))+strDisCondition
	    }
	    str=str+encodeURI(String.fromCharCode(1))
	    strDisCondition=str;
	}
	
	if (strAdmCondition != "" ){
		//strAdmCondition=strDisCondition.substring(3);
	}
	if(strBaseCondition != "" ){
		//strBaseCondition=strBaseCondition.substring(3);
	}
	if(strAddCondition != "" ){
		//strAddCondition=strAddCondition.substring(3);
	}
	var FromDate="",ToDate="",SimpleOutput="";
	var obj=document.getElementById("FromDate");
	if (obj){
		FromDate=obj.value;	
	}
	var obj=document.getElementById("EndDate");
	if (obj){
		ToDate=obj.value;	
	}
	var obj=document.getElementById("ShortQuery");
	if (obj){
		if(obj.checked){
			SimpleOutput=1;
		}else{
			SimpleOutput=0;	
		}
	}
	var cArguments=FromDate+"^"+ToDate+"^"+strDisCondition+"^"+strAdmCondition+"^"+strBaseCondition+"^"+strAddCondition+"SimpleOutput"
	
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRCirculQryNotFrontPage.xls",cArguments);
	
	return;
	}
function initForm()
{
	//document.getElementById("AddOne").onclick = BtnAddOnClick;
	//document.getElementById("AddTwo").onclick = BtnAddOnClick;
	//document.getElementById("AddThree").onclick = BtnAddOnClick;
	//document.getElementById("AddFour").onclick = BtnAddOnClick;
	
	var Obj=document.getElementById("AddOne");
	if (Obj){
		Obj.onclick = BtnAddOnClick1;	
	}
	var Obj=document.getElementById("AddTwo");
	if (Obj){
	   Obj.onclick = BtnAddOnClick2;
	}
	var Obj=document.getElementById("AddThree");
	if (Obj){
	   Obj.onclick = BtnAddOnClick3;
	}
	var Obj=document.getElementById("AddFour");
	if (Obj){
	    Obj.onclick = BtnAddOnClick4;
	}
	var Obj=document.getElementById("Find");
	if (Obj){
	   Obj.onclick = btnQueryOnClick;
	}
	var Obj=document.getElementById("Export");
	if (Obj){
	   Obj.onclick = btnExport;	
	}

}
window.onload = initForm;