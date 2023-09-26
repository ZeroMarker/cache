var objPatient
var objEpidemicReport   ///=new clsEpidemicReport("");
var objLogUser   ///=new clsLogUser("");
var objWebServer
var editActive

function BodyLoadHandler() {
	iniForm();
	GetUser();
	SetData();
	SetPower();
	WriteCAB();
	}
function iniForm() {
    var obj=document.getElementById("btnReport");
	if (obj){ obj.onclick=Report_click;}
    var obj=document.getElementById("btnDelete");
	if (obj){ obj.onclick=Delete_click;}
    var obj=document.getElementById("btnCorrect");
	if (obj){ obj.onclick=Correct_click;}
    var obj=document.getElementById("btnAudit");
	if (obj){ obj.onclick=Audit_click;}
    var obj=document.getElementById("btnReturn");
	if (obj){ obj.onclick=Return_click;}
    var obj=document.getElementById("btnAppendixCard");
	if (obj){ obj.onclick=AppendixCard_click;}
    var obj=document.getElementById("btnPrint");
	if (obj){ obj.onclick=Print_click;}
    var obj=document.getElementById("cmdHomeAddress");
    if (obj){
		var objAddr=document.getElementById("NowAddress");
		if (objAddr){
			objAddr.disabled=true;
		}
	    obj.onclick=cmdHomeAddress_OnClick;
	}
	
	//Add By LiYang 2010-07-25增加保存草稿的按钮单击事件
	var obj=document.getElementById("btnDraft");
	if (obj){ obj.onclick=SaveDraft;}
}

function cmdHomeAddress_OnClick()
{
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHCMedHomeAddress";
	var arr =window.showModalDialog(strUrl);
	if (arr!= null){
		var obj=document.getElementById("NowAddress");
		if (obj){
			obj.value=arr
		}
	}
}
	
function GetUser() {
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"),session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
    }
function SetData(){
	var R_Papmi,R_MepdRowid;
	R_Papmi=gGetObjValue("Papmi");    ///"51144"
	//R_Papmi="51145";
	R_MepdRowid=gGetObjValue("MepdRowid");	///"2"
	//R_MepdRowid="2";
	//alert(R_Papmi+"-"+R_MepdRowid);
	objEpidemicReport=new clsEpidemicReport("");
	editActive="";
	if (R_MepdRowid!=""){
	        GetEpdInfo(R_MepdRowid);
	        DisplayPatInfo();
	        DisplayEpidemicReport();
		   var objAddr=document.getElementById("NowAddress");
		   if (objAddr.value!==""){
			objAddr.disabled=false;
		   }
	}else if (R_Papmi!=""){
	        GetPatInfoByPapmi(R_Papmi)
	        DisplayPatInfo();
	        SetDefaultData();
	}
}
function SetPower(){	
	var encmeth=gGetObjValue("txtUserFunction");
	var sModule="DHCMedEpidemic";
	var TempStatusCode=objEpidemicReport.Status.Code;
	//alert(TempStatusCode);
	//alert(BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"Super"));
	var SuperCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"Super");
	var RepCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"ReportEpidemic");
	var EditCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"AuditEpidemicReport");

	if (SuperCode=="0"){
		if (TempStatusCode=="1") editActive="1";
		return;
		}
	else if (RepCode=="0"){
		gHiddenElement("btnAudit");
		gHiddenElement("btnReturn");

		switch (TempStatusCode) {
            case  "":{      
		       gHiddenElement("btnDelete");
		       gHiddenElement("btnCorrect");
		       break;
	            }
            case  "1":{
		       gHiddenElement("btnCorrect");
		       gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		       editActive="1";
		       break;
	            }
            case  "2":{
		       gHiddenElement("btnDelete");
		       gHiddenElement("btnCorrect");
		       gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		       editActive="1";
		       break;
	            }
            case  "3":{	
	           gHiddenElement("btnReport");
		       gHiddenElement("btnDelete");
		       break;
							}
	        case  "4":{	 //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
	        		//gHiddenElement("btnDelete");
							//gHiddenElement("btnReport");
							gHiddenElement("btnCorrect");
							editActive="1";
							break;
	        		}  		       
            case  "9":{
		       gHiddenElement("btnCorrect");
		       gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		       break;
	            }
            case  "10":{	
	           gHiddenElement("btnReport");
		       gHiddenElement("btnDelete");
		       gHiddenElement("btnCorrect");
		       gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		       break;
	            }
            case  "00":{	
	           gHiddenElement("btnReport");
		       gHiddenElement("btnDelete");
		       gHiddenElement("btnCorrect");
		       gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		       break;
	            }
            default:{	
		       break;
	            }
			}
		return;
		}
	else if (EditCode=="0"){
		//alert("E");
		gHiddenElement("btnReport");
		gHiddenElement("btnDelete");
		gHiddenElement("btnCorrect");
		gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		switch (TempStatusCode) {
            case  "":{
		        gHiddenElement("btnAudit");
		        gHiddenElement("btnReturn");
		        break;
	            }
            case  "1":{
		        break;
	            }
            case  "2":{
		        break;
	            }
            case  "3":{
		        gHiddenElement("btnAudit");
		        gHiddenElement("btnReturn");
		        gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		        break;
	            }
	          case  "4":{
	          	gHiddenElement("btnDelete");
							gHiddenElement("btnReport");
	          	break;
	          	}
            case  "9":{
		        gHiddenElement("btnAudit");
		        gHiddenElement("btnReturn");
		        gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		        break;
	            }
            case  "10":{
		        gHiddenElement("btnAudit");
		        gHiddenElement("btnReturn");
		        gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		        break;
	            }
            case  "00":{
		        gHiddenElement("btnAudit");
		        gHiddenElement("btnReturn");
		        gHiddenElement("btnDraft"); //Add By LiYang 2010-07-25 处理'草稿'状态的权限问题
		        break;
	            }
            default:{
		        gHiddenElement("btnAudit");
		        gHiddenElement("btnReturn");
		        break;
	            }
			}
		return;
		}
	else{
		//alert("D");
		gHiddenElement("btnReport");
		gHiddenElement("btnDelete");
		gHiddenElement("btnCorrect");
		gHiddenElement("btnAudit");
		gHiddenElement("btnReturn");
		return;
		}
	}
		
function SetOccupation(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("Occupation",TempPlist[2]);
	gSetObjValue("OccupationCode",TempPlist[1]);
	}
function SetArea(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("Area",TempPlist[2]);
	gSetObjValue("AreaCode",TempPlist[1]);
	}
function SetIntimate(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("Intimate",TempPlist[2]);
	gSetObjValue("IntimateCode",TempPlist[1]);
	}
function SetSickKind(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("SickKind",TempPlist[2]);
	gSetObjValue("SickKindCode",TempPlist[1]);
	}
function SetDiagDegree(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("DiagDegree",TempPlist[2]);
	gSetObjValue("DiagDegreeCode",TempPlist[1]);
	}
function SetReportPlace(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("ReportPlace",TempPlist[2]);
	gSetObjValue("ReportPlaceCode",TempPlist[1]);
	}
function SetICD(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("ICDRowid",TempPlist[0]);
	gSetObjValue("ICDCode",TempPlist[1]);
	gSetObjValue("ICD",TempPlist[2]);
	gSetObjValue("ICDType",TempPlist[3]);
	gSetObjValue("ICDRank",TempPlist[4]);
	gSetObjValue("ICDAppendix",TempPlist[5]);
	gSetObjValue("ICDMulti",TempPlist[6]);
	gSetObjValue("ICDDependence",TempPlist[7]);
	gSetObjValue("ICDTimeLimit",TempPlist[8]);
	}
function SetDefaultData(){
	gSetObjValue("ReportLocation",objLogUser.CtLoc.Desc);
	gSetObjValue("ctloc",objLogUser.CtLoc.Rowid);	
	}

function GetPatInfoByPapmi(sPapmi){
	//var obj=BASE_GetPatientInfo(gGetObjValue("txtGetPatInfo"),gGetObjValue("Papmi"));
	objPatient=BASE_GetPatientInfo(gGetObjValue("txtGetPatInfo"),sPapmi);
	}


function DisplayPatInfo(){
	//del by zf 2008-11-08
	//gSetObjValue("ResumeText", t["07"].replace(":",String.fromCharCode(65306))); //Modified By LiYang 2008-09-14
	if (objPatient==null){
		}
	else{
		with(objPatient){
	    		gSetObjValue("PatientNo",PatientNo);
	    		gSetObjValue("PatientName",PatientName);
	    		gSetObjValue("MedRecNo",MedRecNo);
	    		gSetObjValue("Sex",Sex);
	    		gSetObjValue("Birthday",gFormatDate(Birthday));
	    		gSetObjValue("Age",Age);
	    		gSetObjValue("Identity",Trim(Identity));
	    		gSetObjValue("Occupation",Occupation);
	    		gSetObjValue("RelativeName",RelativeName);
	    		gSetObjValue("Telephone",Telephone);
	    		gSetObjValue("Company",Company);
	    		gSetObjValue("Papmi",Rowid);
	    		//update by zf 2008-11-08
	    		gSetObjValue("NowAddress","");                  //现住址
	    		gSetObjValue("IDAddress",NowAddress);           //户籍地址
		}
	}
}

function GetEpdInfo(sMedpRowid){
	//var obj=BASE_GetPatientInfo(gGetObjValue("txtGetPatInfo"),gGetObjValue("Papmi"));
	GetEpdInfoByRowid(gGetObjValue("txtGetMepd"),sMedpRowid);
	}

function DisplayEpidemicReport(){
	if (objEpidemicReport.Rowid==""){
		gSetObjValue("MepdRowid",Rowid);
	}else{
		with(objEpidemicReport){
	    		gSetObjValue("MepdRowid",Rowid);
	    		gSetObjValue("Occupation",Occupation.Desc);
	    		gSetObjValue("OccupationCode",Occupation.Code);
	    		gSetObjValue("RelativeName",FamName);
	    		gSetObjValue("Company",Company);
	    		gSetObjValue("Telephone",Telphone);
	    		gSetObjValue("NowAddress",Address);
	    		gSetObjValue("Area",Area.Desc);
	    		gSetObjValue("AreaCode",Area.Code);		
	    		gSetObjValue("ICD",ICD.Desc);
	    		gSetObjValue("ICDRowid",ICD.Rowid);
	    		gSetObjValue("ICDCode",ICD.Code);
	    		gSetObjValue("ICDType",ICD.Type);
	    		gSetObjValue("ICDRank",ICD.Rank);
	    		gSetObjValue("ICDAppendix",ICD.Appendix);
	    		gSetObjValue("ICDMulti",ICD.Multi);
	    		gSetObjValue("ICDDependence",ICD.Dependence);
	    		gSetObjValue("ICDTimeLimit",ICD.TimeLimit);		
	    		gSetObjValue("Intimate",Intimate.Desc);
	    		gSetObjValue("IntimateCode",Intimate.Code);
	    		gSetObjValue("SickDate",gFormatDate(SickDate));		
	    		gSetObjValue("SickKind",SickKind.Desc);
	    		gSetObjValue("SickKindCode",SickKind.Code);
	    		var TempPlist=DiagnoseDate.split(" ");
	    		gSetObjValue("DiagnoseDate",gFormatDate(TempPlist[0]));
	    		gSetObjValue("DiagnoseTime",TempPlist[1]);
	    		gSetObjValue("DeathDate",gFormatDate(DeathDate));
	    		gSetObjValue("ReportLocation",ReportLocation.Desc);
	    		gSetObjValue("ctloc",ReportLocation.Rowid);
	    		gSetObjValue("ReportPlace",ReportPlace.Desc);
	    		gSetObjValue("ReportPlaceCode",ReportPlace.Code);		
	    		gSetObjValue("Status",Status.Desc);
	    		gSetObjValue("StatusCode",Status.Code);
	    		gSetObjValue("ReportUser",ReportUser.Desc);
	    		gSetObjValue("ReportUserRowid",ReportUser.Rowid);
	    		gSetObjValue("ReportDate",gFormatDate(ReportDate));
	    		gSetObjValue("ReportTime",ReportTime);
	    		gSetObjValue("CheckUser1",CheckUser1.Desc);
	    		gSetObjValue("CheckUser1Rowid",CheckUser1.Rowid);
	    		gSetObjValue("CheckDate1",gFormatDate(CheckDate1));
	    		gSetObjValue("CheckTime1",CheckTime1);
	    		gSetObjValue("DiagDegree",DiagDegree.Desc);
	    		gSetObjValue("DiagDegreeCode",DiagDegree.Code);
	    		gSetObjValue("ResumeText",ResumeText);
	    		gSetObjValue("DeleteReason",DeleteReason);
	    		gSetObjValue("CorrectedReportRowID",CorrectedReportRowID);
	    		//add by zf 2008-11-08
	    		gSetObjValue("IDAddress",IDAddress);
	    		gSetObjValue("TEXT1",TEXT1);
	    		gSetObjValue("TEXT2",TEXT2);
		}
	}
}
function Report_click(){
	if (objEpidemicReport.Status.Code!=""
	  &&objEpidemicReport.Status.Code!="1"
	  &&objEpidemicReport.Status.Code!="4" //Add By LiYang 2010-07-25 增加草稿状态
	  &&objEpidemicReport.Status.Code!="9") return;
	///构造
	objEpidemicReport=BuildEpidemicReport();	
	var OldIdentity=objPatient.Identity
    objPatient=BuildPatient(objPatient);
    ///检查信息
    if (CheckInfomation()!=true){
		    alert(t['01']);
		    return;
		    }
    ///更新身份证号		    
    if (objPatient.Identity!=OldIdentity){
	    var encmeth=gGetObjValue("txtUpdateIdentity");
	    var ret=UpdateIdentity(encmeth,objPatient.Rowid,objPatient.Identity);
	    if (ret!="0"){
		    alert(t['02']);
		    return;		
		    }	
		}
		
	/*
	if (objPatient.Identity!=gGetObjValue("Identity")){
	    objPatient=BuildPatient(objPatient);
	    if (CheckInfomation()!=true){
		    alert(t['01']);
		    return;
		    }
	    var encmeth=gGetObjValue("txtUpdateIdentity");
	    var ret=UpdateIdentity(encmeth,objPatient.Rowid,objPatient.Identity);
	    if (ret!="0"){
		    alert(t['02']);
		    return;		
		    }	
		}
	*/
	///上报
	objEpidemicReport.Status.Code="1"
	objEpidemicReport.ReportUser.Rowid=objLogUser.Rowid;
	var ReportString=BuildEpidemicReportString(objEpidemicReport);
	//alert(ReportString);
	var encmeth=gGetObjValue("txtUpdateEPD");
	var ret=UpdateEPD(encmeth,ReportString)
	if (ret<="0"){
		alert(t['03']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport" + "&PatientID=" +objPatient.Rowid+"&MepdRowid=" + ret;
	location.href=lnk;
	}
function Correct_click(){
    if (objEpidemicReport.Status.Code!="3") return;
    ///构造
    var objOldEpidemicReport=objEpidemicReport
    objEpidemicReport=BuildEpidemicReport();
    var OldIdentity=objPatient.Identity
    objPatient=BuildPatient(objPatient);
    ///检查信息
    if (CheckInfomation()!=true){
		    alert(t['01']);
		    return;
		    }		
	///更新身份证号	        
    if (objPatient.Identity!=OldIdentity){
	    var encmeth=gGetObjValue("txtUpdateIdentity");
	    var ret=UpdateIdentity(encmeth,objPatient.Rowid,objPatient.Identity);
	    if (ret!="0"){
		    alert(t['02']);
		    return;		
		    }	
		}
	///被订	
    objOldEpidemicReport.Status.Code="10";
    var ReportString=BuildEpidemicReportString(objOldEpidemicReport);
	var encmeth=gGetObjValue("txtUpdateEPD");
	var retold=UpdateEPD(encmeth,ReportString)
	if (retold<="0"){
		alert(t['03']);
		return;		
		}    
    ///订
    objEpidemicReport.CorrectedReportRowID=objEpidemicReport.Rowid;
    objEpidemicReport.Rowid="";
    objEpidemicReport.Status.Code="2";
    var ReportString=BuildEpidemicReportString(objEpidemicReport);
	var encmeth=gGetObjValue("txtUpdateEPD");
	var ret=UpdateEPD(encmeth,ReportString)
	if (ret<="0"){
		alert(t['03']);
		return;
		}
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport" + "&PatientID=" +objPatient.Rowid+"&MepdRowid=" + ret;
	location.href=lnk;
	}
function Delete_click(){
	if (objEpidemicReport.Status.Code!="1"
	  &&objEpidemicReport.Status.Code!="9") return;
	var ret=confirm(t['05'])
	if (!ret){return;}
	
	var DeleteReasonString=window.prompt(t['04'],"")
	if ((DeleteReasonString=="")||(DeleteReasonString==null)){
		alert(t['06']);
		return;
		}
	objEpidemicReport=BuildEpidemicReport();
	objEpidemicReport.Status.Code="00";
	objEpidemicReport.DeleteReason=DeleteReasonString
	var ReportString=BuildEpidemicReportString(objEpidemicReport);
	//alert(ReportString);
	var encmeth=gGetObjValue("txtUpdateEPD");
	var ret=UpdateEPD(encmeth,ReportString)
	if (ret<="0"){
		alert(t['03']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport" + "&PatientID=" +objPatient.Rowid+"&MepdRowid=";
	location.href=lnk;
	}
function Audit_click(){
	if (objEpidemicReport.Status.Code!="1") return;
	objEpidemicReport.Status.Code="3"
	objEpidemicReport.CheckUser1.Rowid=objLogUser.Rowid;
	objEpidemicReport.ResumeText=gGetObjValue("ResumeText");
	var encmeth=gGetObjValue("txtUpdateCheckEPD");
	with(objEpidemicReport){
		var ret=UpdateCheckEPD(encmeth,Rowid,Status.Code,CheckUser1.Rowid,"","",ResumeText)
		}	
	if (ret<="0"){
		alert(t['03']);
		return;
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport" + "&PatientID=" +objPatient.Rowid+"&MepdRowid=" + ret;
	location.href=lnk;
	}
function Return_click(){
	if (objEpidemicReport.Status.Code!="1") return;
	objEpidemicReport.Status.Code="9";
	objEpidemicReport.CheckUser1.Rowid=objLogUser.Rowid;
	objEpidemicReport.ResumeText=gGetObjValue("ResumeText");
	//update by zf 2008-08-18
	var ReportString=BuildEpidemicReportString(objEpidemicReport);
	var encmeth=gGetObjValue("txtUpdateEPD");
	var ret=UpdateEPD(encmeth,ReportString)
	/*
	var encmeth=gGetObjValue("txtUpdateCheckEPD");
	with(objEpidemicReport){
		var ret=UpdateEPD(encmeth,Rowid,Status.Code,CheckUser1.Rowid,"","",ResumeText)
		}
	*/
	if (ret<="0"){
		alert(t['03']);
		return;
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport" + "&PatientID=" +objPatient.Rowid+"&MepdRowid=" + ret;
	location.href=lnk;
	}
function AppendixCard_click(){
	var ret=gGetObjValue("MepdRowid");
	//editActive="1";
	//var flag=CheckAppendixCard(ret,editActive)
	//alert("flag="+flag);
	//if (flag=="0") return;
	//var Active=editActive;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdAppendixCard" + "&MepdRowid=" + ret + "&Active=" +editActive;
	open(lnk,"","scrollbars=yes,resizable=no,top=160,left=160,width=600,height=600");
	//location.href=lnk;
	}
function Print_click(){
	if (objEpidemicReport.Rowid=="") return;
	var sServer,sNameSpace,sFileName;
	
    var encmeth=gGetObjValue("txtGetServerInfo");
    objWebServer=BASE_GetWebConfig(encmeth)
    sServer=objWebServer.Server;
    sNameSpace=objWebServer.MEDDATA;
    sFileName=objWebServer.Path+"\\DHCMedEpidemicReport.dot";

// 	sServer="CN_IPTCP:127.0.0.1[1972]";
// 	sNameSpace="meddata";
// 	sFileName="D:\\trakcarelive\\app\\trak\\med\\Results\\Template\\DHCMedEpidemicReport.dot";

    var Bar;  
    Bar= new ActiveXObject("DHCMedWebPackage.cls_DHCMedWebCommon");
    var flag=Bar.PrintEpdReport(sServer,sNameSpace,sFileName,objEpidemicReport.Rowid);
	}


function WriteCAB(){
    var encmeth=gGetObjValue("txtGetWebPackage");
    var sObject=cspRunServerMethod(encmeth)
    
    var objTable = document.getElementsByTagName("table")[0];
    objTable.rows[0].cells[0].appendChild(document.createElement(sObject));
	}
	/*
	var Temp
	Temp="////";
	alert(Temp);
	/*
	var obj=document.getElementById("cls_WebCommon");
	if (obj){
		alert("--");
		//Temp=obj.ShowMsg(Temp);
		}
	*/
	//Temp=cls_DHCMedWebCommon.ShowMsg(Temp);
	//alert(Temp);
	
	//alert(objEpidemicReport.Rowid);
	
	//var xxx=new clsBody("100")
	
    //xxx.show();
    //document.write("1111111111111");
	///3

//var Temp='../addins/client/DHCMedWebPackage.CAB'
//alert(Temp);
//sObject="<OBJECT ID='cls_WebCommon' CLASSID='CLSID:18934F41-CB3F-48FF-9B0F-E15FF7DCD65C' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,0,0,3' VIEWASTEXT>  </OBJECT>"
//sObject="<OBJECT ID='cls_WebCommon' CLASSID='CLSID:18934F41-CB3F-48FF-9B0F-E15FF7DCD65C' CODEBASE='http://127.0.0.1/trakcare/web/addins/client/DHCMedWebPackage.CAB#version=1,0,0,0' VIEWASTEXT> </OBJECT>"
//sObject="<OBJECT ID='cls_DHCMedWebCommon' CLASSID='CLSID:C57D3A0B-E47B-413E-A012-84D25F733286' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,1' VIEWASTEXT> </OBJECT>"
//sObject="<OBJECT ID='cls_DHCMedWebCommon' CLASSID='CLSID:C57D3A0B-E47B-413E-A012-84D25F733286' CODEBASE='../addins/client/DHCMedWebPackage.CAB#version=1,1,0,19' VIEWASTEXT> </OBJECT>"
//document.write(sObject);


function SaveDraft(){

	if ((objEpidemicReport.Status.Code!="4") && (objEpidemicReport.Status.Code!=""))
	{
		window.alert("只有'草稿'状态的报告才能保存为草稿！");	
		return;
	}
	
	
	///构造
	objEpidemicReport=BuildEpidemicReport();	
	var OldIdentity=objPatient.Identity
    objPatient=BuildPatient(objPatient);
    ///检查信息
    //if (CheckInfomation()!=true){
		//    alert(t['01']);
		//    return;
		//    }
    ///更新身份证号		    
    if (objPatient.Identity!=OldIdentity){
	    var encmeth=gGetObjValue("txtUpdateIdentity");
	    var ret=UpdateIdentity(encmeth,objPatient.Rowid,objPatient.Identity);
	    if (ret!="0"){
		    alert(t['02']);
		    return;		
		    }	
		}

	///保存为草稿
	objEpidemicReport.Status.Code="4";//草稿状态是4
	objEpidemicReport.ReportUser.Rowid=objLogUser.Rowid;
	var ReportString=BuildEpidemicReportString(objEpidemicReport);
	//alert(ReportString);
	var encmeth=gGetObjValue("txtUpdateEPD");
	var ret=UpdateEPD(encmeth,ReportString)
	if (ret<="0"){
		alert(t['03']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReport" + "&PatientID=" +objPatient.Rowid+"&MepdRowid=" + ret;
	location.href=lnk;
}
document.body.onload = BodyLoadHandler;