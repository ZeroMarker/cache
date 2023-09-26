//名称	DHCPEPersonStatistic.js
//功能	体检综合查询
//组件	DHCPEPersonStatistic
//对象	
//创建	2007.08.14 xuwm
//最后修改时间	
//最后修改人	
//完成
var TFORM="";
var TFORM="DHCPEPersonStatistic";

function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("GDesc");
	if (obj) {
		obj.onchange=GDesc_change;
		obj.onblur=GDesc_blur;
	}
	obj=document.getElementById("Saler");
	if (obj) {
		obj.onchange=Saler_change;
		obj.onblur=Saler_blur;
	}
	obj=document.getElementById("BFind");
	if (obj) {
		obj.onclick=BFind_click;
	}
	
	//Status_REGISTERED
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		obj.onclick=Status_REGISTERED;
	}
	
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		obj.onclick=Status_ARRIVED;
	}
	
	
	
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	obj=document.getElementById("Name");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	obj=document.getElementById("btnImportPersonStatistic")
	if (obj) { obj.onclick=ImportPersonStatistic_click; }
	
	obj=document.getElementById("PersonStatisticSavePath")
	if (obj) { obj.value='D:\\'+"体检综合总汇.xls"; }
	
	
	//alert(1)
	obj=document.getElementById("BPrint");
	if (obj){ obj.onclick=PisRequestPrint; }
	//alert(2)
	iniForm();
}
function PisRequestPrint()
{
	//alert('s')
	
	var Data=GetSelectId("");
	//alert(Data);
	if (""==Data) {
		return ;
	}
	//
	var Datas=Data.split(";");
	var obj;
	for (var iLLoop=0;iLLoop<Datas.length-1;iLLoop++){
		FData=Datas[iLLoop];  //.split("^");
		//alert(FData)
		if (""!=FData) {
			var iIAdmId=FData;
			//alert(iIAdmId)
			PrintByTemplate(iIAdmId);
		}
	}
}
function GetSelectId(FiledName) 
{   
	//return "";
	
	var tbl=document.getElementById('t'+TFORM);	//取表格元素?名称
	var row=tbl.rows.length;
	var vals="";
	var val=""
	var val1=""
	var FNames=FiledName.split('^'); //PA_ADMDR
	FNames="PA_ADMDR";
    
	for (var iLLoop=2;iLLoop<row;iLLoop++) {
		obj=document.getElementById('TSelect'+'z'+iLLoop);
		if (obj && obj.checked) {
			
			obj=document.getElementById('PA_ADMDR'+'z'+iLLoop);
			if (obj) { val=obj.value; }
			//var val1=tkMakeServerCall("web.DHCPE.Public.Common","GetIADMByPAADM",val);
			
			/*
			obj=document.getElementById('TPatNAME'+'z'+iLLoop);
			if (obj) { val=iLLoop+'^'+obj.innerText+'^'; }
			
			for (var iFLoop=0;iFLoop<FNames.length-1;iFLoop++){			
				obj=document.getElementById(FNames[iFLoop]+'z'+iLLoop);
				if (obj) {if (obj.type!='checkbox') val=val+obj.value+'^'; 
				if (obj.type=='checkbox') val=val+obj.checked+"^"}
			*/		
			
			
			vals=vals+val+";";
		}
	}
	if (""==vals) { alert("未选择受检人,操作中止!"); }
	/*
	if (vals!="")
	{
		var Flag="PEADM"
		//if (FiledName.split("^")[0]=="TPEIAdmId") Flag="PEADM"
		var obj=document.getElementById("printSortClass");
		if (obj)
		{
			var encmeth=obj.value;
			vals=cspRunServerMethod(encmeth,vals,Flag)
			
		}
	}*/
	//alert(vals)
	return vals;
}
function Status_REGISTERED()
{
	var obj1=document.getElementById("Status_REGISTERED");
	var obj2=document.getElementById("Status_ARRIVED");
	//alert(obj1.value)
	//alert(obj2.value)
	if ((obj2.checked)&&(obj1.checked))
	{
		obj2.checked=false;
		
		
		}
	
	}
	
function Status_ARRIVED()
{
	var obj1=document.getElementById("Status_REGISTERED");
	var obj2=document.getElementById("Status_ARRIVED");
	//alert(obj1.value)
	//alert(obj2.value)
	
	if ((obj2.checked)&&(obj1.checked))
	{
		obj1.checked=false;
		
		
		}
	
	}
function iniForm(){
	var obj;
	obj=document.getElementById("Status");
	if (obj) { SetStatus(obj.value); }
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function RegNo_KeyDown(){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function BFind_click() {
	var iGDR='', iGDesc="",  iPatSex=''
		iRegNo='', iName='', iPEBeginDate='', iPEEndDate='',iDepName="",iVIPLevel="";
		iSaler='', iSalerDR='' , iStatus='', iFactAmountBegin='', iFactAmountEnd='',iReCheck="",
        
	//
	obj=document.getElementById("RegNo");  
	if (obj) { iRegNo=obj.value; }
	//
	obj=document.getElementById("Name");  
	if (obj) { iName=obj.value; }
	//
	obj=document.getElementById("PEBeginDate");  
	if (obj) { iPEBeginDate=obj.value; }
	//
	obj=document.getElementById("PEEndDate");  
	if (obj) { iPEEndDate=obj.value; }
	//
	obj=document.getElementById("GDR");  
	if (obj) { iGDR=obj.value; }
	obj=document.getElementById("GDesc");  
	if (obj) { iGDesc=obj.value; }
	//
	obj=document.getElementById("SalerDR");  
	if (obj) { iSalerDR=obj.value; }
	
	obj=document.getElementById("Saler");  
	if (obj) { iSaler=obj.value; }
	
	
	iStatus=GetStatus();
	

	
	obj=document.getElementById("FactAmountBegin");
	if (obj) { iFactAmountBegin=obj.value; }
	//
	obj=document.getElementById("FactAmountEnd");  
	if (obj) { iFactAmountEnd=obj.value; }
	//obj=document.getElementById("PatSex");
	obj=document.getElementById("Sex");
    	if (obj) { iPatSex=obj.value};
    	obj=document.getElementById("DepName");
    	if (obj) iDepName=obj.value;
    	obj=document.getElementById("VIPLevel");
    	if (obj) iVIPLevel=obj.value;
    obj=document.getElementById("ReCheck");
    if (obj) iReCheck=obj.value;	
    	
    var IFSTSF="";
    obj=document.getElementById("IFSTSF");  
	if (obj) { var IFSTSF=obj.value; }
    
    
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT='+'DHCPEPersonStatistic'
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&PEBeginDate="+iPEBeginDate
			+"&PEEndDate="+iPEEndDate
			+"&GDR="+iGDR
			+"&GDesc="+iGDesc
			+"&SalerDR="+iSalerDR
			+"&Saler="+iSaler
			+"&Status="+iStatus
			+"&FactAmountBegin="+iFactAmountBegin
			+"&FactAmountEnd="+iFactAmountEnd
			+"&PatSex="+iPatSex
			+"&DepName="+iDepName
			+"&VIPLevel="+iVIPLevel
			+"&ReCheck="+iReCheck
			+"&IFSTSF="+IFSTSF
			;

	
	
	
	
	location.href=lnk;
	//var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=680,height=400,left=150,top=150';
	//window.open(lnk,"_blank",nwin); 
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function GetReportStatus() {
	var obj;
	var iSTatus="";
 	obj=document.getElementById("STatusIsNoAudit");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"NA"+"^"+"NoAudit"+"^"+"UNCHECKED"+"^"; }

 	obj=document.getElementById("STatusIsCheched");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"CHECKED"+"^"+"Audited"+"^"+"A"+"^"; }

 	obj=document.getElementById("STatusIsPrint");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"PRINTED"+"^"+"P"+"^"; }

 	obj=document.getElementById("STatusIsSend");
	if ((obj)&&(obj.checked==true)) { iSTatus=iSTatus+"^"+"SEND"+"^"+"S"+"^"; }
	return iSTatus;
	
}
function SetReportStatus(ReportStatus) {
	var iReportStatus=ReportStatus;
	//条件 未审核
	var obj=document.getElementById("STatusIsNoAudit");
	if (obj && (iReportStatus.indexOf("^NA^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	//if (""==iReportStatus) { obj.checked=true; }
	
	//条件 审核
	obj=document.getElementById("STatusIsCheched");
	if (obj && (iReportStatus.indexOf("^Audited^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }

	//条件 打印
 	obj=document.getElementById("STatusIsPrint");
	if (obj && (iReportStatus.indexOf("^PRINTED^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
	
	//条件 发送
 	obj=document.getElementById("STatusIsSend");
	if (obj && (iReportStatus.indexOf("^SEND^")>-1)) { obj.checked=true; }
	else{ obj.checked=false; }
}

function Status_PREREG_NoALL() {
	var src=window.event.srcElement;
	if (src && src.checked){
		obj=document.getElementById("Status_PREREG");
		if (obj){  obj.checked=false; }
	}
}

function GetStatus() {
	var obj;
	var iStatus="";
	
	
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED^"; }
	                                               
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED^"; }
	
	return iStatus;
	
}

function SetStatus(Status) {
	var obj;
	var value=Status;

	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

	// CANCELPREREG 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

	
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function GDesc_change() {

	var obj;

	obj=document.getElementById('GDR');
	if (obj) { obj.value="";}
}

function GDesc_blur() {
	return;
	var obj;
	obj=document.getElementById('GDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('GDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function AfterGroupSelected(value){
	
	var aiList=value.split("^");
	if (""==value){return false;}
	obj=document.getElementById("GDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("GDR");
	if (obj) { obj.value=aiList[0]; }
	
}
	

	
function Saler_change() {
	
	var obj;
	
	obj=document.getElementById('SalerDR');
	if (obj) { obj.value=''; }
	
}

function Saler_blur() {
	return;
	var obj;
	obj=document.getElementById('Saler');
	if (obj && ""==obj.value) {
		obj=document.getElementById('SalerDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function GetSales(value){

	var aiList=value.split('^');
	if (''==value){ return false; }

	obj=document.getElementById('Saler');
	if (obj) { obj.value=aiList[0]; }
	
	obj=document.getElementById('SalerDR');
	if (obj) { obj.value=aiList[1]; }
}
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function ImportPersonStatistic_click() {

	var SaveFilePath='';
	var obj;
	obj=document.getElementById('PersonStatisticSavePath');
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }
	PersonStatisticImport(SaveFilePath);
}

document.body.onload = BodyLoadHandler;