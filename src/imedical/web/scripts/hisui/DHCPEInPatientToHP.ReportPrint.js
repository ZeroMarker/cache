//名称	DHCPEInPatientToHP.ReportPrint.js
//功能	报告打印
//组件	DHCPEInPatientToHP.ReportPrint	
//创建	2018.09.21
//创建人  xy

function BodyLoadHandler() {
   
   //查询
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	//打印
	var obj=document.getElementById("BPrint");
	if (obj){
		DisableBElement("BPrint",true);
		obj.onclick=BPrint_click;
	}
	
	//预览    
	var obj=document.getElementById("BPrivew");
	if (obj){
		DisableBElement("BPrivew",true);
		obj.onclick=BPrivew_click;
	}
	
	var obj=document.getElementById("RegNo");
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
}

function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}

function BPrint_click()
{
	Print("P");
}
function BPrivew_click()
{
	Print("V");
}
function Print(Type)
{
	var NewVerReportFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",session['LOGON.CTLOCID'],"NewVerReport");
	//alert(NewVerReportFlag)
	if(NewVerReportFlag=="Word"){ 
	
	if(Type=="P"||Type=="V"){
		if (jarPAADM==""){
			$.messager.alert("提示","请选择待打印报告","info");
		}else if(statusStr.indexOf("未")>0){
			$.messager.alert("提示","未初检，请核实报告状态","info");
		}else if(Type=="P"&&jarPAADM.split("#").length>1){
			$.messager.alert("提示","不可批量预览，请重新选择！","info");
			
		}else{ 
			calPEReportProtocol(Type,jarPAADM);
		} 
		return false;
	}
	
	}else if(NewVerReportFlag=="Lodop"){
		BPrintViewLodop(Type);
		
	}else{
	
	 var objtbl = $("#tDHCPEInPatientToHP_ReportPrint").datagrid('getRows');
	  var PAADM=objtbl[selectrow].TEpisodeID;
	  if(PAADM==""){
		  $.messager.alert("提示","请选择待打印报告！","info");
		  return false;
	  }
		var width=screen.width-60;
		var height=screen.height-10;
		var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 		var lnk="dhcpeireport.normal.otherpat.csp?PatientID="+PAADM+"&Type="+Type;
		open(lnk,"_blank",nwin);
		return false;

	}
	return false;
}

//外部协议打开体检报告程序 
function calPEReportProtocol(sourceID,jarPAADM){

	var opType=(sourceID=="P")?"2":(sourceID=="V"?"5":"1");
	if(opType=="2"){
		jarPAADM=jarPAADM+"@"+session['LOGON.USERID'];
	}
	var saveType=sourceID=="BExportPDF"?"pdf":(sourceID=="BExportHtml"?"html":"word"); 
	var printType=sourceID=="NoCoverPrint"?"2":"1";
	location.href="PEReport://"+jarPAADM+":"+opType+":"+saveType+":"+printType
}

 function BPrintViewLodop(Type){
	
	 var objtbl = $("#tDHCPEInPatientToHP_ReportPrint").datagrid('getRows');
	  var PAADM=objtbl[selectrow].TEpisodeID;
	  
	  var printerName=tkMakeServerCall("web.DHCPE.Report","GetVirtualPrinter");
	  //alert(PAADM+"^"+printerName)
		if (Type=="P"){//打印报告
			PEPrintReport("P",PAADM,printerName);
		}else if (Type=="V"){//打印预览
		 
			PEPrintReport("V",PAADM,printerName);
		}
	
	return false

}

/*
function Print(Type)
{
	  var objtbl = $("#tDHCPEInPatientToHP_ReportPrint").datagrid('getRows');
	  var PAADM=objtbl[selectrow].TEpisodeID	
		var width=screen.width-60;
		var height=screen.height-10;
		var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 		var lnk="dhcpeireport.normal.otherpat.csp?PatientID="+PAADM+"&Type="+Type;
		open(lnk,"_blank",nwin);
		return false;
}
*/

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function BFind_click()
{

	StartDate=getValueById("StartDate");
	
	EndDate=getValueById("EndDate");
	
	AuditStartDate=getValueById("AuditStartDate");
	
	AuditEndDate=getValueById("AuditEndDate");
	
	PrintStartDate=getValueById("PrintStartDate");
	
	PrintEndDate=getValueById("PrintEndDate");
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	RegNo=getValueById("RegNo");
	if (RegNo.length<RegNoLength&&RegNo.length>0) { RegNo=RegNoMask(RegNo);}
	
	Name=getValueById("Name");
	
	Status=getValueById("Status");
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEInPatientToHP.ReportPrint"
   	+"&StartDate="+StartDate+"&EndDate="+EndDate+"&AuditStartDate="+AuditStartDate+"&AuditEndDate="+AuditEndDate
   	+"&PrintStartDate="+PrintStartDate+"&PrintEndDate="+PrintEndDate+"&RegNo="+RegNo+"&Name="+Name+"&Status="+Status;
   	//alert(lnk)
   	window.location.href=lnk;
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if (selectrow=="-1") return;
	if(index==selectrow)
	{
		var obj=document.getElementById("BPrint");
		if (obj){
			DisableBElement("BPrint",false);
			var Status=rowdata.TStatus;
        	if(Status=="未审核"){DisableBElement("BPrint",true);}
		
		}	    
		var obj=document.getElementById("BPrivew");
		if (obj) {DisableBElement("BPrivew",false);}
	   
		
	}else
	{
		var obj=document.getElementById("BPrint");
		if (obj) {DisableBElement("BPrint",true);}	    
		var obj=document.getElementById("BPrivew");
		if (obj) {DisableBElement("BPrivew",true);}
		selectrow=-1;
	
	}	

}
document.body.onload = BodyLoadHandler;