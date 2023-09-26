var objPatient
var objPaAdm
var objInjuryReport   ///=new clsEpidemicReport("");
var objLogUser   ///=new clsLogUser("");
var objWebServer

function BodyLoadHandler() {
	iniForm();
	GetUser();
	
	SetData();
	//SetPower();
	//WriteCAB();
	}
function GetUser() {
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"),session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
    }
function iniForm() {
    var obj=document.getElementById("btnReport");
	if (obj){ obj.onclick=Report_click;}
    var obj=document.getElementById("btnAudit");
	if (obj){ obj.onclick=Audit_click;}
	var obj=document.getElementById("btnUpdate");
	if (obj){ obj.onclick=Correct_click;}
  var obj=document.getElementById("btnPrint");
	if (obj){ obj.onclick=Print_click;}
    var obj=document.getElementById("InjHuJi");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		}
	var obj=document.getElementById("InjEducation");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		}
	var obj=document.getElementById("InjCareer");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		}
	var obj=document.getElementById("InjReason");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=InjReason_change;
		}
	var obj=document.getElementById("InjSite");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=InjSite_change;
		}
	var obj=document.getElementById("InjActivity");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=InjActivity_change;
		}
	var obj=document.getElementById("InjIntentional");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		}
	var obj=document.getElementById("InjKind");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=InjKind_change;
		}
	var obj=document.getElementById("InjPosition");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=InjPosition_change;
		}
	var obj=document.getElementById("InjDegree");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		}
	var obj=document.getElementById("InjResult");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.onchange=InjResult_change;
		}
					
	AddInjHuJi();
	AddInjEducation();
	AddInjCareer();
	AddInjReason();
	AddInjSite();
	AddInjActivity();
	AddInjIntentional();
	AddInjKind();
	AddInjPosition();
	AddInjDegree();
	AddInjResult();
	gHiddenElement("InjReasonOther");
	gHiddenElement("InjSiteOther");
	gHiddenElement("InjActivityOther");
	gHiddenElement("InjKindOther");
	gHiddenElement("InjResultOther");
	gHiddenElement("InjPositionOther");
	
}

function SetICD(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("ICDRowId",TempPlist[0]);
	gSetObjValue("ICDCode",TempPlist[1]);
	gSetObjValue("ICDDesc",TempPlist[2]);
	gSetObjValue("DiagnoseDesc",TempPlist[2]);
	gSetObjValue("ICDInsDesc",TempPlist[3]);
	gSetObjValue("ICD9CM_Code",TempPlist[4]);
	}
	
function InjResult_change(){
	if(gGetObjValue("InjResult").indexOf(t['Other'])!=-1)
	{
		gVisibleElement("InjResultOther");
		gSetFocus("InjResultOther");
	}
	else
	{
		gHiddenElement("InjResultOther");
		gSetObjValue("InjResultOther","");
		}
}

function InjPosition_change(){
	if(gGetObjValue("InjPosition").indexOf(t['Other'])!=-1)
	{
		gVisibleElement("InjPositionOther");
		gSetFocus("InjPositionOther");
	}
	else
	{
		gHiddenElement("InjPositionOther");
		gSetObjValue("InjPositionOther","");
		}
}

function InjKind_change(){
	if(gGetObjValue("InjKind").indexOf(t['Other'])!=-1)
	{
		gVisibleElement("InjKindOther");
		gSetFocus("InjKindOther");
	}
	else
	{
		gHiddenElement("InjKindOther");
		gSetObjValue("InjKindOther","");
		}
}

function InjActivity_change(){
	if(gGetObjValue("InjActivity").indexOf(t['Other'])!=-1)
	{
		gVisibleElement("InjActivityOther");
		gSetFocus("InjActivityOther");
	}
	else
	{
		gHiddenElement("InjActivityOther");
		gSetObjValue("InjActivityOther","");
		}
}

function InjSite_change(){
	if(gGetObjValue("InjSite").indexOf(t['Other'])!=-1)
	{
		gVisibleElement("InjSiteOther");
		gSetFocus("InjSiteOther");
	}
	else
	{
		gHiddenElement("InjSiteOther");
		gSetObjValue("InjSiteOther","");
		}
}

function InjReason_change(){
	if(gGetObjValue("InjReason").indexOf(t['Other'])!=-1)
	{
		gVisibleElement("InjReasonOther");
		gSetFocus("InjReasonOther");
	}
	else
	{
		gHiddenElement("InjReasonOther");
		gSetObjValue("InjReasonOther","");
		}
}

function Correct_click(){
    if (objInjuryReport.Status.Code!="1") return;
	///构造
	objInjuryReport=BuildInjuryReport();
    objInjuryReport.Status.Code="1"
	objInjuryReport.RepUser.Rowid=objLogUser.Rowid;
	var ReportString=BuildInjuryReportString(objInjuryReport);	
	//alert(ReportString);
	var ReportDtlString=BuildInjuryReportDtlString();
	//alert(ReportDtlString);
	var encmeth=gGetObjValue("txtUpdateInj");
	var ret=UpdateInj(encmeth,ReportString,ReportDtlString)
	if (ret<="0"){
		alert(t['Filed']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedInjuryReport" + "&PatientID=" +objPatient.Rowid+"&MInjRowid=" + ret+"&EpisodeID="+objPaAdm.Rowid;
	location.href=lnk;
	}
	
function Report_click(){
	if (objInjuryReport.Status.Code!="") return;
	///构造
	objInjuryReport=BuildInjuryReport();	
    ///检查信息
  if (CheckInjInfomation()!=true){
	    alert(t['CheckInfo']);
	    return;
	    }
  var Identity=gGetObjValue("Identity");
  if (Identity!="")
  {
    var encmeth=gGetObjValue("txtUpdateIndentity");
    var ret=UpdateIdentity(encmeth,objPatient.Rowid,Identity);
    if (ret!="0")
    {
	    alert(t['Filed']);
	    return;
	  }
	}
	///上报
	objInjuryReport.Status.Code="1"
	objInjuryReport.RepUser.Rowid=objLogUser.Rowid;
	var ReportString=BuildInjuryReportString(objInjuryReport);	
	var ReportDtlString=BuildInjuryReportDtlString();
	var encmeth=gGetObjValue("txtUpdateInj");
	var ret=UpdateInj(encmeth,ReportString,ReportDtlString)
	if (ret<="0"){
		alert(t['Filed']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedInjuryReport" + "&PatientID=" +objPatient.Rowid+"&MInjRowid=" + ret+"&EpisodeID="+objPaAdm.Rowid;
	location.href=lnk;
}

function UpdateIdentity(encmeth,sPapmi,sIdentity){
	if (encmeth!=""&&sPapmi!=""&&sIdentity!=""){
		var ret=cspRunServerMethod(encmeth,sPapmi,sIdentity);
		return ret;
		}	
	}
	
function Audit_click(){
	if (objInjuryReport.Status.Code!="1") return;
	objInjuryReport.Status.Code="2"
	objInjuryReport.CheckUser.Rowid=objLogUser.Rowid;
	objInjuryReport.ResumeText=gGetObjValue("ResumeText");
	var encmeth=gGetObjValue("txtUpdateCheckInj");
	with(objInjuryReport){
		var ret=UpdateCheckInj(encmeth,Rowid,Status.Code,CheckUser.Rowid,"","",ResumeText)
		}	
	if (ret<="0"){
		alert(t['CheckFiled']);
		return;
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedInjuryReport" + "&PatientID=" +objPatient.Rowid+"&MInjRowid=" + ret+"&EpisodeID="+objPaAdm.Rowid;
	location.href=lnk;
	}
	
function AddInjResult(){
	gClearAllList("InjResult");
	s=gGetObjValue("txtGetInjResult");
	var objDic=BASE_GetDictionary(s,"InjResult","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjResult",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjResult",0);
	}
function AddInjDegree(){
	gClearAllList("InjDegree");
	s=gGetObjValue("txtGetInjDegree");
	var objDic=BASE_GetDictionary(s,"InjDegree","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjDegree",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjDegree",0);
	}
function AddInjPosition(){
	gClearAllList("InjPosition");
	s=gGetObjValue("txtGetInjPosition");
	var objDic=BASE_GetDictionary(s,"InjPosition","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjPosition",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjPosition",0);
	}
function AddInjKind(){
	gClearAllList("InjKind");
	s=gGetObjValue("txtGetInjKind");
	var objDic=BASE_GetDictionary(s,"InjKind","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjKind",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjKind",0);
	}
function AddInjIntentional(){
	gClearAllList("InjIntentional");
	s=gGetObjValue("txtGetInjIntentional");
	var objDic=BASE_GetDictionary(s,"InjIntentional","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjIntentional",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjIntentional",0);
	}
function AddInjActivity(){
	gClearAllList("InjActivity");
	s=gGetObjValue("txtGetInjActivity");
	var objDic=BASE_GetDictionary(s,"InjActivity","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjActivity",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjActivity",0);
	}
function AddInjSite(){
	gClearAllList("InjSite");
	s=gGetObjValue("txtGetInjSite");
	var objDic=BASE_GetDictionary(s,"InjSite","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjSite",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjSite",0);
	}
function AddInjReason(){
	gClearAllList("InjReason");
	s=gGetObjValue("txtGetInjReason");
	var objDic=BASE_GetDictionary(s,"InjReason","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjReason",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjReason",0);
	}
function AddInjHuJi(){
	gClearAllList("InjHuJi");
	s=gGetObjValue("txtGetInjHuji");
	var objDic=BASE_GetDictionary(s,"InjHuJi","Y");
	//if (objDic.Count>0){
	//	gSetListValue("cDep",tmpList[0],"");
	//	gSetListValue("cLoc",tmpList[1],"");
	//	} 
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjHuJi",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjHuJi",0);
	}
function AddInjEducation(){
	gClearAllList("InjEducation");
	s=gGetObjValue("txtGetInjEducation");
	var objDic=BASE_GetDictionary(s,"InjEducation","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjEducation",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjEducation",0);
	}
function AddInjCareer(){
	gClearAllList("InjCareer");
	s=gGetObjValue("txtGetInjCareer");
	var objDic=BASE_GetDictionary(s,"InjCareer","Y");
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjCareer",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjCareer",0);
	}
	
function SetData(){
	var R_Papmi,R_MinjRowid,R_PaAdm;
	R_Papmi=gGetObjValue("Papmi");    ///"51144"就诊号
	R_PaAdm=gGetObjValue("PaAdmID");
	//R_Papmi="51145";
	R_MinjRowid=gGetObjValue("MinjRowid");	///"2"
	objInjuryReport=new clsInjuryReport("");
		
	if (R_MinjRowid!=""){
		    gHiddenElement("btnReport");
	        GetInjInfo(R_MinjRowid);
	        //alert(objInjuryReport.Rowid);
	        DisplayPatInfo();
	        GetPaAdm(R_PaAdm);
			gSetObjValue("PaAdmDate",gFormatDate(objPaAdm.AdmDate));
			gSetObjValue("PaAdmTime",objPaAdm.AdmTime);
	        DisplayInjuryReport();
	        //待续txtGetMinjDtl
	        GetMinjDtl(R_MinjRowid);
	        
	}else if (R_Papmi!=""){
	        GetPatInfoByPapmi(R_Papmi)
	        DisplayPatInfo();
	        SetDefaultData();
	}
	
}

function DisplayInjuryReport(){
	if (objInjuryReport.Rowid==""){
		gSetObjValue("MinjRowid",Rowid);
	}else{
		with(objInjuryReport){
	    		gSetObjValue("MinjRowid",Rowid);
	    		gSetObjValue("Status",Status.Desc);
	    		gSetObjValue("InjDate",InjDate);
	    		gSetObjValue("InjTime",InjTime);
	    		gSetObjValue("DiagnoseDesc",Diagnose.Desc);
	    		gSetObjValue("ICDRowId",Diagnose.Rowid);
	    		gSetObjValue("ICDCode",Diagnose.Code);
	    		gSetObjValue("ReportUser",RepUser.Desc);
	    		gSetObjValue("ReportUserRowid",RepUser.Rowid);
	    		gSetObjValue("ReportDate",ReportDate);
	    		gSetObjValue("ReportTime",ReportTime);
	    		gSetObjValue("CheckUser1",CheckUser.Desc);
	    		gSetObjValue("CheckUser1Rowid",CheckUser.Rowid);
	    		gSetObjValue("CheckDate1",CheckDate);
	    		gSetObjValue("CheckTime1",CheckTime);
	    		gSetObjValue("ResumeText",ResumeText);
		}
	}
}
function SetDefaultData(){
	var R_PaAdm;
	R_PaAdm=gGetObjValue("PaAdmID");
	gSetObjValue("ReportUser",objLogUser.Name);
	GetPaAdm(R_PaAdm);
	gSetObjValue("PaAdmDate",gFormatDate(objPaAdm.AdmDate));
	gSetObjValue("PaAdmTime",objPaAdm.AdmTime);
	}

function GetInjInfo(sMInjRowid){
	//var obj=BASE_GetPatientInfo(gGetObjValue("txtGetPatInfo"),gGetObjValue("Papmi"));
	GetInjInfoByRowid(gGetObjValue("txtGetMInj"),sMInjRowid);
	}
function GetMinjDtl(sMInjRowid){
	GetInjDtlByRowid(gGetObjValue("txtGetMinjDtl"),sMInjRowid);
	
	}	
		
function GetPatInfoByPapmi(sPapmi){
	//var obj=BASE_GetPatientInfo(gGetObjValue("txtGetPatInfo"),gGetObjValue("Papmi"));
	objPatient=BASE_GetPatientInfo(gGetObjValue("txtGetPatInfo"),sPapmi);
	}
	
function GetPaAdm(PaAdmID){
	var encmeth=gGetObjValue("txtGetPaAdm");
	objPaAdm=new clsPaAdm("");
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,PaAdmID);
		if (ret!=""){
			var TempFileds=ret.split(CHR_Up)												
			objPaAdm.Rowid=TempFileds[0];
			objPaAdm.PatientID=TempFileds[5];
			objPaAdm.Type=TempFileds[1];
			objPaAdm.AdmDate=TempFileds[3];
			objPaAdm.AdmTime=TempFileds[4];
		}	
	}	
	}
		
function DisplayPatInfo(){
	//gSetObjValue("ResumeText", t["07"].replace(":",String.fromCharCode(65306)));
	if (objPatient==null){
		}
	else{
		with(objPatient){
	    		gSetObjValue("PatientNo",PatientNo);
	    		gSetObjValue("PatientName",PatientName);
	    		gSetObjValue("Sex",Sex);
	    		gSetObjValue("Age",Age);
	    		gSetObjValue("Identity",Trim(Identity));
		}
	}
}
				    	
function WriteCAB(){
    var encmeth=gGetObjValue("txtGetWebPackage");
    var sObject=cspRunServerMethod(encmeth);
    
    var objTable = document.getElementsByTagName("table")[0];
    objTable.rows[0].cells[0].appendChild(document.createElement(sObject));
	}
function Print_click(){
	  if (objInjuryReport.Rowid=="") return;
	  var sServer,sNameSpace,sFileName;
	
    var encmeth=gGetObjValue("txtGetServerInfo");
    objWebServer=BASE_GetWebConfig(encmeth)
    sServer=objWebServer.Server;
    sNameSpace=objWebServer.MEDDATA;
    sFileName=objWebServer.Path+"\\DHCMedInjuryCard.dot";

// 	sServer="CN_IPTCP:127.0.0.1[1972]";
// 	sNameSpace="meddata";
 	  //sFileName="C:\\trakcarelive\\app\\trak\\med\\Results\\Template\\DHCMedInjuryCard.dot";

    var Bar;  
    Bar= new ActiveXObject("DHCMedWebPackage.cls_DHCMedWebCommon");
    var flag=Bar.PrintInjReport(sServer,sNameSpace,sFileName,objInjuryReport.Rowid);
	}
	
document.body.onload=BodyLoadHandler;