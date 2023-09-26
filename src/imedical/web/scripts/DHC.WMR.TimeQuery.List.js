//DHC.WMR.TimeQuery.List.js
//Creator:wangcs
//CreateDate:2013-04-27

function Init(){
	var printObj=document.getElementById("Print");
	if(printObj){
		printObj.onclick=Print_Click;
	}
	var ExportObj=document.getElementById("Export");
	if (ExportObj){
		ExportObj.onclick=Export_Click;
	}
}
function ConvertToCharCode(OldStr){
	 var strTmp="";
	 for(var i = 0; i < OldStr.length; i ++)
     {
            strTmp += OldStr.charCodeAt(i) + "-";
     }
     return strTmp
}
function Print_Click(){
	var strDisCondition = window.parent.RPtop.getElementValue("DisArea");
	var strAdmCondition = window.parent.RPtop.getElementValue("AdmArea");
	var strBaseCondition = window.parent.RPtop.getElementValue("BaseArea");
	var strAddCondition = window.parent.RPtop.getElementValue("AddArea");

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
	var obj=window.parent.RPtop.document.getElementById("FromDate");
	if (obj){
		FromDate=obj.value;	
	}
	var obj=window.parent.RPtop.document.getElementById("EndDate");
	if (obj){
		ToDate=obj.value;	
	}
	var obj=window.parent.RPtop.document.getElementById("ShortQuery");
	if (obj){
		if(obj.checked){
			SimpleOutput=1;
		}else{
			SimpleOutput=0;	
		}
	}
	var arguments=FromDate+"^"+ ToDate+"^"+ConvertToCharCode(strDisCondition)+"^"+ConvertToCharCode(strAdmCondition)+"^"+ConvertToCharCode(strBaseCondition)+"^"+ConvertToCharCode(strAddCondition)+"^"+SimpleOutput;
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHC.WMR.TimeQuery.xls",arguments);
}
function Export_Click(){
	var strDisCondition = window.parent.RPtop.getElementValue("DisArea");
	var strAdmCondition = window.parent.RPtop.getElementValue("AdmArea");
	var strBaseCondition = window.parent.RPtop.getElementValue("BaseArea");
	var strAddCondition = window.parent.RPtop.getElementValue("AddArea");

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
	var obj=window.parent.RPtop.document.getElementById("FromDate");
	if (obj){
		FromDate=obj.value;	
	}
	var obj=window.parent.RPtop.document.getElementById("EndDate");
	if (obj){
		ToDate=obj.value;	
	}
	var obj=window.parent.RPtop.document.getElementById("ShortQuery");
	if (obj){
		if(obj.checked){
			SimpleOutput=1;
		}else{
			SimpleOutput=0;	
		}
	}
	var arguments=FromDate+"^"+ ToDate+"^"+ConvertToCharCode(strDisCondition)+"^"+ConvertToCharCode(strAdmCondition)+"^"+ConvertToCharCode(strBaseCondition)+"^"+ConvertToCharCode(strAddCondition)+"^"+SimpleOutput;
	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHC.WMR.TimeQuery.xls",arguments);
}
window.onload=Init;