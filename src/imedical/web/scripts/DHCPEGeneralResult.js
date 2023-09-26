/// DHCPEGeneralResult.js
var obj;
var UserId=session['LOGON.USERID'];
function InitMe() {
	var SummaryForm=document.forms['fDHCPEGeneralResult'];
	if (SummaryForm) {
		var Audit=SummaryForm.all['BAudit'];
		var SumResult=SummaryForm.all['BSumResult'];
		var Update=SummaryForm.all['BUpdate'];
		var Find=SummaryForm.all['BFind'];
		if (Audit) {Audit.onclick=Audit_click;}
		if (SumResult) {SumResult.onclick=SumResult_click;}
		if (Update) {Update.onclick=Update_click;}
		if (Find) {Find.onclick=Find_click;}
		var obj=SummaryForm.all['cUnAppedItems'];
		if (obj) {obj.style.color="red"}
		var UnAppedItems=SummaryForm.all['UnAppedItems'];
		if (UnAppedItems) {UnAppedItems.style.color="red"}
		var UnAppedItems=SummaryForm.all['RefuseItem'];
		if (UnAppedItems) {UnAppedItems.style.color="red"}
		
		var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralResult');
		if (objtbl) { var rows=objtbl.rows.length; }
		
		for (i=1;i<rows;i++)
		{     
		      //随访勾控制 20110826 ZL
		      var RowObj=objtbl.rows[i];
              for (k=0; k<RowObj.all.length; k++)	
              {
	          	var ItemObj=RowObj.all[k];
	          	ItemObj.className="Green";   //add by lxl 20121203
             	if(ItemObj.id=="THighRiskRemindz"+i)
              	{  
              		ItemObj.onclick=ChangeFlag_Click;
              	}
               	//高危勾控制 20110826 ZL  
              	if(ItemObj.id=="THighRiskFlagz"+i)
              	{  
              		ItemObj.onclick=ChangeHighRiskFlag_Click;
              	}
             }
             //自动产生诊断标记
			var RLable=SummaryForm.document.getElementById("TAutoRecommz"+i);
			var strCell=RLable.value;
        	var RLable=SummaryForm.document.getElementById("TResultz"+i);
			var sTD=RLable.parentElement;
			if (strCell=='0')
			{
				sTD.bgColor="#FFC1C1"
				//RLable.style.color="#FFC1C1";
			}
		}
	     

	}
	PermissonSetting();

}
function ChangeFlag_Click()
{  	
   var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEGeneralResult');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var RemindFlag="N"
	var obj=document.getElementById('TRLTDRz'+selectrow);	
	if (obj) {var RLTDR=obj.value;}
	var obj=document.getElementById('THighRiskRemindz'+selectrow);	
	if (obj&&obj.checked){var RemindFlag="Y"}
	var obj=document.getElementById("RemindFlagBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,RLTDR,RemindFlag);
	//location.reload()
}

function ChangeHighRiskFlag_Click()
{  	
   var eSrc = window.event.srcElement;	//触发事件的
	var objtbl=document.getElementById('tDHCPEGeneralResult');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var HighRiskFlag="N"
	var obj=document.getElementById('TRLTDRz'+selectrow);	
	if (obj) {var RLTDR=obj.value;}
	var obj=document.getElementById('THighRiskFlagz'+selectrow);	
	if (obj&&obj.checked){var HighRiskFlag="Y"}
	var obj=document.getElementById("HighRiskFlagFlagBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,RLTDR,HighRiskFlag);
	//location.reload()
}
function Find_click()
{
	var lnk=window.location.href;
	var lnk=lnk.split("&Include")[0];
	var Include="";
	var obj=document.getElementById("Include");
	if (obj&&obj.checked) Include="on";
	var lnk=lnk+"&Include="+Include;
	window.location.href=lnk;
}
function Update_click(){
	var SummaryForm=document.forms['fDHCPEGeneralResult'];
	if (SummaryForm) {
		var objtbl=SummaryForm.document.getElementById('tDHCPEGeneralResult');
	
		if (objtbl) { var rows=objtbl.rows.length; }
		
		var lastrowindex=rows - 1;
		var i,obj,ID,Remark,Strings;
		var ID,Remark,Strings="";
		for (i=1;i<rows;i++)
		{
			obj=SummaryForm.document.getElementById("TRowIdz"+i);
			if (obj) ID=obj.value;
			obj=SummaryForm.document.getElementById("TRemarkz"+i);
			if (obj) Remark=obj.value;
			obj=SummaryForm.document.getElementById("TReportz"+i);
			var Report="N"
			if (obj&&obj.checked){Report="Y"}
			if (Strings=="")
			{
				Strings=ID+"&&"+Remark+"&&"+Report
			}
			else
			{
				Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Report
			}
		}
		if (Strings=="") return false;
		var obj=SummaryForm.document.getElementById("UpdateBox");
		if (obj) var encmeth=obj.value;
		var flag=cspRunServerMethod(encmeth,Strings)
		Find_click();
		return false;
		
		
	}
}
function StationSubCancel()
{
	StatusChange("Cancel","1");
}
function StationSCancelSub()
{
	StatusChange("Cancel","0");
}
function Audit_click() {
	StatusChange("Submit","0");
}
function StatusChange(Type,QXType)
{
	var SummaryForm=document.forms['fDHCPEGeneralResult'];
	if (SummaryForm) {
	obj=SummaryForm.document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	if(Type=="Cancel")
	{
		var AuditUser=tkMakeServerCall("web.DHCPE.ResultDiagnosis","GetAuditUserId",PAADM);
		if (AuditUser==""){
			alert(t["NoAudit"]);
			return false;
		}
		if(AuditUser!=UserId){
			alert("非本人提交不能放弃提交");
			return;	
		}
			
	}
	obj=SummaryForm.document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var MainDoctor="";
	var obj=document.getElementById("MainDoctor");
	if (obj) MainDoctor=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,Type,QXType,MainDoctor);
	if (flag=="0")
	{
		if (Type=="Submit")
		{
			try{
				if (parent.frames("diagnosis")){
					parent.frames("diagnosis").location.reload();
					window.location.reload();
					return false;
				}
			}catch(e){
				parent.parent.location.href="epr.default.csp";
			}
			
		}
		else if (Type=="Cancel")
		{
			
			try{
				if (parent.frames("diagnosis")){
					parent.frames("diagnosis").location.reload();
					window.location.reload();
					return false;
				}
			}catch(e){
				window.location.reload();
			}
			
		}
		return false;
	}
	alert(t[flag]);
	return false;
	}
}
function SumResult_click(){
	var SummaryForm=document.forms['fDHCPEGeneralResult'];
	if (SummaryForm) {
	var Type=0
	obj=SummaryForm.document.getElementById("SSID");
	if (obj) var SSID=obj.value;
	if (SSID!="")
	{
		if (confirm(t['04'])) var Type=1;
	}
	obj=SummaryForm.document.getElementById("EpisodeID");
	if (obj) var PAADM=obj.value;
	obj=SummaryForm.document.getElementById("IsCanSumResult");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM);
	var values=flag.split("^");
	flag=values[0];
	if (flag!=0)
	{
		if (!confirm(values[1]+t[flag]+",是否继续总检?")) return false;
	}
	
	obj=SummaryForm.document.getElementById("SumResultBox");
	if (obj) var encmeth=obj.value;
	var Remark=""
	obj=SummaryForm.document.getElementById("Remark");
	if (obj) Remark=obj.value;
	var flag=cspRunServerMethod(encmeth,PAADM,Type,Remark);
	var values=flag.split("^");
	flag=values[0];
	if (flag==0)
	{
		window.location.reload();
		
		try{
			if (parent.frames("diagnosis")){
				parent.frames("diagnosis").location.reload();
			}
		}catch(e){}
		
		return false;
	}
	alert(values[1]+t[flag]);
	return false;
	}
	
}
function PreviewReport()
{
	var obj;
	var iReportName="",iEpisodeID="";
	obj=document.getElementById("ReportNameBox");
	if (obj) { iReportName=obj.value; }
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no'
				+',left=0'
				+',top=0'
				+',width='+window.screen.availWidth
				+',height='+window.screen.availHeight
				;
		var lnk=iReportName+"?PatientID="+iEpisodeID;
		open(lnk,"_blank",nwin);
		close();
}

function GetContrastWithLast()
{
	var obj;
	var iEpisodeID="";
	obj=document.getElementById("EpisodeID");
	if (obj) { iEpisodeID=obj.value; }
	//alert(iEpisodeID)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEContrastWithLast"
			+"&PAADM="+iEpisodeID
	
		var wwidth=1000;
	var wheight=600; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)	
	return true;
}
function PermissonSetting(){
	var PAAdmId, ChartId, SvrMethod
	PAAdmId=GetCtlValueById("EpisodeID", 0)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 1, ChartId)
	if (MyPermission=="R"){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
	    DisabledCtls("select",true);
		return "R";
	}
	return "W";
	
}
