var iFrequency=0;
var autoQryFlag=false;
var autoQryHandle=null;
var unitFrequency=60000; //Modified By LiYang 2009-11-26 Interval of refresh is too fast 
var aimDateFrom, aimDateTo, MrTypeList, ReqTypeList, WorkItemList, ActiveList
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){obj.onclick=Query_click;}
	var obj=document.getElementById("chkAutoQuery");
	if (obj){obj.onclick=chkAuto_click;}
	iniForm();
}

function iniForm()
{
	var obj=document.getElementById("cboFrequency");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.disabled=true;
		if (obj.options.length>0) obj.options[0].selected=true;
	}
	///////add by liuxuefeng 2010-01-18///////////
	var obj=document.getElementById("cboMrType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		OMrType=GetParam(window.parent, "OMrType");
    setElementValue("cboMrType",OMrType);
		obj.disabled=true;
	}
	
	var obj=document.getElementById("cboWorkItem");
	if (obj){
		obj.options[0].selected=true;
	}
	var obj=document.getElementById("cboRequestType");
	if (obj){
		obj.options[0].selected=true;
	}
	/////////////////End/////////////////
}

function getFrequency()
{
	var obj=document.getElementById("cboFrequency")
	var myidx=obj.selectedIndex;
	var tmpValue=parseInt(obj.options[myidx].text);
	var tmpiFrequency=tmpValue*unitFrequency;
	return tmpiFrequency;
}		

function chkAuto_click()
{
	var objchkAuto=document.getElementById("chkAutoQuery");
	var obj=document.getElementById("cboFrequency");
	
	if (objchkAuto.checked){
		obj.disabled=false;
		autoQryFlag=true;
		}
	else{
		clearInterval(autoQryHandle);
		obj.disabled=true;
		autoQryFlag=false;
		}
}

function Query_click()
{
	/*
	setElementValue("aimDateFrom",getElementValue("dateFrom"));
	setElementValue("aimDateTo",getElementValue("dateTo"));
	setElementValue("MrTypeList",getElementValue("cboMrType"));
	setElementValue("ReqTypeList",getElementValue("cboRequestType"));
	setElementValue("WorkItemList",getElementValue("cboWorkItem"));
	setElementValue("ActiveList","Y");
	*/
	aimDateFrom=getElementValue("dateFrom");
	aimDateTo=getElementValue("dateTo");
	MrTypeList=getElementValue("cboMrType");
	ReqTypeList=getElementValue("cboRequestType");
	WorkItemList=getElementValue("cboWorkItem");
	ActiveList="";
	FirstFlag="";
	var tmpFirst=getElementValue("FirstFlag");
	if (tmpFirst!==""){FirstFlag=tmpFirst;}
	
  	Query();
	iFrequency=getFrequency();
  if ((autoQryFlag)&(iFrequency>0)) 
  {
  	if(autoQryHandle != null)
  		clearInterval(autoQryHandle);
  	autoQryHandle = setInterval(Query,iFrequency);
  }
}
function Query()
{
	//alert(getElementValue("ReqTypeList"));
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Req.List"
	lnk += "&aimDateFrom="+aimDateFrom
	lnk += "&aimDateTo="+aimDateTo
	lnk += "&MrTypeList="+MrTypeList
	lnk += "&ReqTypeList="+ReqTypeList
	lnk += "&WorkItemList="+WorkItemList
	lnk += "&ActiveList="+ActiveList
	lnk += "&TransferItemDr="+getElementValue("TransferItemDr")
	lnk += "&FirstFlag="+FirstFlag
	parent.RPbottom.location.href=lnk;
}

document.body.onload = BodyLoadHandler;