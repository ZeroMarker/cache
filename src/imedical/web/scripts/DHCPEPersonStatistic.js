//名称	DHCPEPersonStatistic.js
//功能	体检综合查询
//组件	DHCPEPersonStatistic	
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
	
	    ///指引单打印预览
    obj=document.getElementById("BPrintView")
    if (obj) {
	       obj.onclick=PatItemPrintXH;  
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
	
	var Data=GetSelectId("");
	if (""==Data) {
		return false;
	}
	
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

	return vals;
}
function Status_REGISTERED()
{
	var obj1=document.getElementById("Status_REGISTERED");
	var obj2=document.getElementById("Status_ARRIVED");

	if ((obj2.checked)&&(obj1.checked))
	{
		obj2.checked=false;
		
		
		}
	
	}
	
function Status_ARRIVED()
{
	var obj1=document.getElementById("Status_REGISTERED");
	var obj2=document.getElementById("Status_ARRIVED");
	
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

function RegNo_KeyDown(e){
	
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
	if (obj) { 
		iRegNo=obj.value;
		if (iRegNo.length<8&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}

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
	obj=document.getElementById("FactAmountEnd");  
	if (obj) { iFactAmountEnd=obj.value; }
	obj=document.getElementById("SexDR");
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
    var ChargeStatus="";
    obj=document.getElementById("ChargeStatus");  
	if (obj) { var ChargeStatus=obj.value; }
    
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
			+"&SexDR="+iPatSex
			+"&DepName="+iDepName
			+"&VIPLevel="+iVIPLevel
			+"&ReCheck="+iReCheck+"^"+ChargeStatus
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

/*
function ImportPersonStatistic_click() {

	var SaveFilePath='';
	var obj;
	obj=document.getElementById('PersonStatisticSavePath');
	if (obj && ""!=obj.value) { SaveFilePath=obj.value; }
	PersonStatisticImport(SaveFilePath);
}
*/
function ImportPersonStatistic_click() {
try{
		var obj,iBeginDate="",iEndDate="";
		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEPersonStatistic.xls';

		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
         xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); 
		xlsheet = xlBook.WorkSheets("汇总"); 
    	var iBeginDate=document.getElementById('PEBeginDate').value;
		var iEndDate=document.getElementById('PEEndDate').value;
	 	if (iEndDate=="")
		{ iEndDate=EndDate()}
		var Ins=document.getElementById('PEPersonStatisticBox');
		if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		var value=cspRunServerMethod(encmeth);
		if (""==value) { return false; }
		var FRow=4; 
		xlsheet.cells(1,2)=iBeginDate;
		xlsheet.cells(2,2)=iEndDate;
		var User=session['LOGON.USERID']
		var values=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","GetPEPersonStatisticImportRows",User)
        var value=values.split("&");
        var Rows=value[0];
        var valueTotal=value[1];
        
        
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Report.PEPersonStatistic","GetPEPersonStatisticImportData",User,i+1)

			var DayData=Datas.split("^");
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				xlsheet.cells(i+3, iDayLoop+1)=DayData[iDayLoop];
			}

		}
		
	    var valueTotalData=valueTotal.split("^");
	 
		for (var j=0;j<valueTotalData.length;j++) {
				xlsheet.cells(parseInt(Rows)+4,j+1)=valueTotalData[j];
			}
			
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;

   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}
}

document.body.onload = BodyLoadHandler;
/*
//指引单打印预览
function PatItemPrintXH(e)
{
	var viewmark=2;
	iTAdmId=e.id; 
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false;    
	}
	var PrintFlag=1;
	var PrintView=1;
	var Instring=iTAdmId+"^"+PrintFlag+"^PAADM"+"Y";	
	var Ins=document.getElementById('GetOEOrdItemBox');	
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	Print(value,PrintFlag,viewmark);	//DHCPEIAdmItemStatusAdms.PatItemPrint
	location.reload();
}
*/
//指引单打印预览
function PatItemPrintXH()
{

	var viewmark=2;
	var iTAdmId="";
	var objtbl=document.getElementById("tDHCPEPersonStatistic"); 
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked) {
		var obj=document.getElementById('PA_ADMDR'+'z'+i);
		if (obj) { var iTAdmId=obj.value; }
		}
	}
	
	if (""==iTAdmId) { 
	    alert("您没有选择客户,或者没有登记")
	    return false; 
	}
	var PrintFlag=1;
	var PrintView=1;
	var Instring=iTAdmId+"^"+PrintFlag+"^PAADM"+"Y"; 
	var Ins=document.getElementById('GetOEOrdItemBox'); 
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	Print(value,PrintFlag,viewmark); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
	location.reload();
}
