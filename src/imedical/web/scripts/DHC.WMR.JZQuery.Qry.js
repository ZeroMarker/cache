/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.JZQuery.Qry.js

AUTHOR: ZF , Microsoft
DATE  : 2007-7-25

============================================================================ */
var strMrType = "";
var strAdmType = ""; 
function QueryPatient(MrType, AdmitDate)
{	
	//var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.JZQuery.List&ADMType=" + strAdmType + "&MRTypeDr="  + MrType +  "&AdmDate=" + encodeURI (AdmitDate);
	var cFromDate=document.getElementById("txtFromDate").value;
	var cToDate=document.getElementById("txtToDate").value;
	//add by lyh 2012-12-14
	var cPatName=document.getElementById("PatName").value;
	var cPatMrNo=document.getElementById("PatMrNo").value;
	var cPatNo=document.getElementById("PatNo").value;
	
	var dtDiff=CheckDate(cFromDate,cToDate,0);
	if(MrType=="7")
	{
		if(dtDiff>365)
		{
		  alert("时间请控制在366天之间！");
		  return;
		}
	}
	else
	{
	  	if(dtDiff>1)
		{
		  alert("时间请控制在2天之间！");
		  return;
		}
	}
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.JZQuery.List&ADMType="+strAdmType+"&MRTypeDr="+MrType+"&FromDate="+cFromDate+"&ToDate="+cToDate+"&PatName="+cPatName+"&PatMrNo="+cPatMrNo+"&PatNo="+cPatNo;
	parent.frames[1].location.href = strUrl;
}


function cmdDisplay()
{
	//QueryPatient(strMrType, getElementValue("txtAdmitDate"));
	QueryPatient(strMrType);
}

function initForm()
{
	strMrType = GetParam(window, "MrType");
	strAdmType = GetParam(window, "AdmType");
	var objMrType = null;
	if(strMrType == "")
	{
		window.alert("Medical Record Type Error!!!!!!!");
		return;
	}
	objMrType = GetDHCWMRDictionaryByID("MethodGetDictionaryByID", strMrType);
	setElementValue("txtMrType", objMrType.Description);
	
}

function initEvevts()
{
	document.getElementById("cmdDisplay").onclick = cmdDisplay;
}

initForm();
initEvevts();
InitPrintEvents();				//add by liuxuefeng 2010-01-27
///////////////////////add by liuxuefeng 2010-01-27///////Start///////////////////
function InitPrintEvents()
{
	var obj=document.getElementById("cmdExport");
	if (obj) {obj.onclick=cmdExport_onclick;}
	var obj=document.getElementById("cmdPrint");
	if (obj) {obj.onclick=cmdPrint_onclick;}

}
function cmdExport_onclick()
{ 	
	var objLnk=parent.RPbottom;
	var ADMType=GetParam(objLnk,"ADMType");
	var MRTypeDr=GetParam(objLnk,"MRTypeDr");
	var FromDate=GetParam(objLnk,"FromDate");
	var ToDate=GetParam(objLnk,"ToDate");
	var dtDiff=CheckDate(FromDate,ToDate,0);
	if(ADMType=="7")
	{
		if(dtDiff>365)
		{
		  alert("时间请控制在366天之间！");
		  return;
		}
	}
	else
	{
	  	if(dtDiff>1)
		{
		  alert("时间请控制在2天之间！");
		  return;
		}
	}
	var PatType="";
	var PatTypeFlag=document.getElementById("PatType").checked;
	if(PatTypeFlag) PatType="O";
	
	//add by lyh 2012-12-14
	var cPatName=document.getElementById("PatName").value;
	var cPatMrNo=document.getElementById("PatMrNo").value;
	var cPatNo=document.getElementById("PatNo").value;
	
	var cArguments=ADMType+"^"+MRTypeDr+"^"+FromDate+"^"+ToDate+"^"+cPatName+"^"+cPatMrNo+"^"+cPatNo;
	//alert(cArguments);
	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHCWMRJZList.xls",cArguments);
}

function cmdPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var ADMType=GetParam(objLnk,"ADMType");
	var MRTypeDr=GetParam(objLnk,"MRTypeDr");
	var FromDate=GetParam(objLnk,"FromDate");
	var ToDate=GetParam(objLnk,"ToDate");
	var dtDiff=CheckDate(FromDate,ToDate,0);
	if(ADMType=="7")
	{
		if(dtDiff>365)
		{
		  alert("时间请控制在366天之间！");
		  return;
		}
	}
	else
	{
	  	if(dtDiff>1)
		{
		  alert("时间请控制在2天之间！");
		  return;
		}
	}
	var PatType="";
	var PatTypeFlag=document.getElementById("PatType").checked;
	if(PatTypeFlag) PatType="O";
	var cPatName=document.getElementById("PatName").value;
	var cPatMrNo=document.getElementById("PatMrNo").value;
	var cPatNo=document.getElementById("PatNo").value;
	var cArguments=ADMType+"^"+MRTypeDr+"^"+FromDate+"^"+ToDate+"^"+cPatName+"^"+cPatMrNo+"^"+cPatNo;
	//alert(cArguments);
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRJZList.xls",cArguments);
}
///////////////////////add by liuxuefeng 2010-01-27/////End/////////////////////


/////////for 控制时间段/////////////add by cjb 20101129 /////Start//////
function CheckDate(d1,d2,diff)
{
  if((typeof d1 == 'string' && d1.constructor == String) && (typeof d2 == 'string' && d2.constructor == String))
  {   
  	//alert(Math.abs(DateDiff(gFormatDateA(d1),gFormatDateA(d2))));
  	return DateDiff(gFormatDateA(d1),gFormatDateA(d2));
   }
   else
   {
   	alert("Date Format Error!");
   	}
}

function DateDiff(asStartDate,asEndDate){ 
    var miStart=Date.parse(asStartDate.replace(/\-/g,'/')); 
    var miEnd=Date.parse(asEndDate.replace(/\-/g,'/')); 
    //alert(asStartDate.replace(/\-/g,'/')+"---"+asStartDate);
    return (miEnd-miStart)/(1000*24*3600); 
}
/**********************************************
/
***********************************************/
function gFormatDateA(val){
	if (val==""){
		return "";
		}
	else{
		var TempPlist=val.split("/");
		var ret=TempPlist[2]+"-"+TempPlist[1]+"-"+TempPlist[0];
		return ret;
		}
	}

/**********************************************
/
***********************************************/ 
/////////////////////20101129 /////End///////////////////