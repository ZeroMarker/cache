//DHCMedPVMReport.js
//Add by cjb at 20090604 for DHCMedPVM
var objPVMReport   ///=new clsPVMReport("");
var objLogUser   ///=new clsLogUser("");
var objWebServer
var editActive

function BodyLoadHandler() {
	iniForm();
	GetUser();
	//alert(objLogUser.Name);
	
	SetData();
	SetPower();
	//WriteCAB();
	}
	
function AddRows(value)
{
	var TempPlist=value.split(CHR_Up);
	var objTable = document.getElementsByTagName("table")[1];
	//alert(objTable.rows.length);
  //objTable.rows[8].cells[0].appendChild(document.createElement(sObject));obj.rowIndex
  objTable.style.border="1px solid #9BC2E0";
  var newTr=objTable.insertRow(1);
  newTr.attachEvent("onmouseover",function(){newTr.style.backgroundColor='#CCCCCC';newTr.style.color='#FFFFFF';	newTr.style.cursor='#CCCCCC';});
  newTr.attachEvent("onmouseout",function(){newTr.style.backgroundColor='';newTr.style.color='';	newTr.style.cursor='';});
  //objTable.bgColor = '#33FFFF';
  for(i=0;i<4;i++)
  {
  	var objCol=newTr.insertCell();
  	}
  newTr.cells[0].innerText=TempPlist[1];
  newTr.cells[1].innerText=TempPlist[2];
  newTr.cells[2].innerText=TempPlist[3];
  newTr.cells[3].style.width="10%";
  //newTr.cells[3].innerHTML="<input type='button' style='background-image: url(../images/websys/delete.gif)' width='60' onclick='description_Cancel("+TempPlist[1]+")'>";
  newTr.cells[3].innerHTML="<img src='../images/websys/delete.gif' onclick='description_Cancel("+TempPlist[1]+")'>";
}	
function iniForm() {
	var obj=document.getElementById("btnSave");
	if (obj){ obj.onclick=Save_click;}
	var obj=document.getElementById("btnCorrect");
	if (obj){ obj.onclick=Correct_click;}
	var obj=document.getElementById("btnDelete");
	if (obj){ obj.onclick=Delete_click;}
	var obj=document.getElementById("btnReport");
	if (obj){ obj.onclick=Report_click;}
	var obj=document.getElementById("btnAudit");
	if (obj){ obj.onclick=Audit_click;}   
    var obj=document.getElementById("btnPrint");
	if (obj){ obj.onclick=Print_click;}
	
	var obj=document.getElementById("ReportType");
	if(obj){obj.onkeydown=ReportType_keydown;}

}

function Print_click()
{
    return;	
}
function ReportType_keydown(e)
{
	if (evtName=='ReportType') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==13))) {
		var url='websys.lookup.csp';
		url += "?ID=dDHCMedPVMReport";
		url += "&CONTEXT=Kweb.DHCMedDictoryCtl:QueryByType";
		url += "&TLUJSF=SetReportType";
		var obj=document.getElementById('sReportType');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('flagY');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
	}
	
function Audit_click(){
	if (objPVMReport.Status.Code!="3") return;
	objPVMReport.Status.Code="4"
	objPVMReport.CheckUser.Rowid=objLogUser.Rowid;
	objPVMReport.ResumeText=gGetObjValue("ResumeText");
	var encmeth=gGetObjValue("txtUpdateCheckPVM");
	with(objPVMReport){
		var ret=UpdateCheckPVM(encmeth,Rowid,Status.Code,CheckUser.Rowid,"","",ResumeText)
		}	
	if (ret<="0"){
		alert(t['AuditFiled']);
		return;
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMReport" + "&MPVMRowid=" + ret;
	location.href=lnk;
	}
	
function Report_click()
{
	if (objPVMReport.Status.Code!="1") return;
	objPVMReport=BuildPVMReport();
	objPVMReport.Status.Code="3";
	var ReportString=BuildPVMReportString(objPVMReport);
	var encmeth=gGetObjValue("txtUpdatePVM");
	var ret=UpdatePVM(encmeth,ReportString);
	if (ret<="0"){
		alert(t['ReportFiled']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMReport" + "&MPVMRowid=" + ret;
	location.href=lnk;
}

function Delete_click(){
	if (objPVMReport.Status.Code!="1") return;
	var ret=confirm(t['DeleteOK'])
	if (!ret){return;}

	objPVMReport=BuildPVMReport();
	objPVMReport.Status.Code="2";
	var ReportString=BuildPVMReportString(objPVMReport);
	var encmeth=gGetObjValue("txtUpdatePVM");
	var ret=UpdatePVM(encmeth,ReportString);
	if (ret<="0"){
		alert(t['DeleteFiled']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMReport" + "&MPVMRowid=" + ret;
	location.href=lnk;
	}
	
function Correct_click(){
    if (objPVMReport.Status.Code!="1") return;
    
    objPVMReport=BuildPVMReport();
    ///检查信息
    if (CheckInfomation()!=true){
		    alert(t['CheckInfoErr']);
		    return;
		    }	
    var ReportString=BuildPVMReportString(objPVMReport);
  var ReportDtlString=BuildPVMReportDtlString(objPVMReport);
  
	var encmeth=gGetObjValue("txtUpdatePVM");
	var ret=UpdatePVM(encmeth,ReportString);
	if (ret<="0"){
		alert(t['CorrentFiled']);
		return;		
		}    
		var encmeth=gGetObjValue("txtMethodOpinionDtl");
		var retDtl=UpdatePVM(encmeth,ReportDtlString);   
		if (retDtl=="0"){
		alert(t['CorrentFiled']);
		return;		
		}    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMReport" + "&MPVMRowid=" + ret;
	location.href=lnk;
}

function Save_click()
{
	if (objPVMReport.Status.Code!="") return;
	///构造
	objPVMReport=BuildPVMReport();
	if (CheckInfomation()!=true){
		    alert(t['CheckInfoErr']);
		    return;
		    }
	objPVMReport.Status.Code="1";
	objPVMReport.RepUser.Rowid=objLogUser.Rowid;
	var ReportString=BuildPVMReportString(objPVMReport);
	var encmeth=gGetObjValue("txtUpdatePVM");
	var ret=UpdatePVM(encmeth,ReportString);
	if (ret<="0"){
		alert(t['SaveFiled']);
		return;		
		}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMReport" + "&MPVMRowid=" + ret;
	location.href=lnk;
}
function SetData(){
	var R_MPVMRowid;
	R_MPVMRowid=gGetObjValue("MPVMRowid");
	objPVMReport=new clsPVMReport("");
	if (R_MPVMRowid!=""){
	        GetPVMInfo(R_MPVMRowid);  //GetPVMInfoByRowid
	        DisplayPVMReport();
	}else{
	        SetDefaultData();
	}
}

function DisplayPVMReport(){
	if (objPVMReport.Rowid==""){
		gSetObjValue("MPVMRowid",Rowid);
	}else{
		with(objPVMReport){
	    		gSetObjValue("MPVMRowid",Rowid);
	    		gSetObjValue("ReportType",ReportType.Desc);
	    		gSetObjValue("ReportTypeCode",ReportType.Code);
	    		gSetObjValue("ReportStatus",Status.Desc);
	    		gSetObjValue("ReportStatusCode",Status.Code);
	    		gSetObjValue("INCItmBatID",INCItmBat.Rowid);
	    		gSetObjValue("INCItmBatNo",INCItmBat.INCItmBatNo);
	    		gSetObjValue("INCItmNa",INCItmBat.INCItmName);
	    		var tmpRowidBt=INCItmBat.Rowid;
	    		var tmpList=tmpRowidBt.split("||");
	    		gSetObjValue("INCItmID",tmpList[0]);
	    		gSetObjValue("ReportQty",ReportQty);
	    		gSetObjValue("InStockQty",InStockQty);
	    		gSetObjValue("StockQty",StockQty);
	    		//gSetObjValue("Description",Description.Desc);
	    		gSetObjValue("DescriptionCode",Description.Code);
	    		gSetObjValue("ResumeText",ResumeText);
	    		gSetObjValue("Opinion",Opinion.Desc);
	    		gSetObjValue("OpinionCode",Opinion.Code);
          gSetObjValue("ReportLocation",ReportLocation.Desc);
	    		gSetObjValue("ctloc",ReportLocation.Rowid);
	    		gSetObjValue("ReportPlace",ReportPlace.Desc);
	    		gSetObjValue("ReportPlaceCode",ReportPlace.Code);
	    		gSetObjValue("ReportUser",RepUser.Code);
	    		gSetObjValue("ReportUserRowid",RepUser.Rowid);
	    		gSetObjValue("ReportDate",gFormatDate(ReportDate));
	    		gSetObjValue("ReportTime",ReportTime);
	    		gSetObjValue("CheckUser",CheckUser.Code);
	    		gSetObjValue("CheckUserRowid",CheckUser.Rowid);
	    		gSetObjValue("CheckDate",gFormatDate(CheckDate));
	    		gSetObjValue("CheckTime",CheckTime);
	    		
	    		gSetObjValue("TEXT1",TEXT1);
	    		gSetObjValue("TEXT2",TEXT2);
	    		//cjb 2009-08-18
	    		if(Description.Desc!="")
	    		{
	    		  var stplitArr=Description.Desc.split(CHR_1);
	    		  for(k=0;k<stplitArr.length;k++)
	    		  {
	    			  stplitArr[k]=stplitArr[k].replace(/\//g,CHR_Up);
	    			  AddRows(stplitArr[k]);
	    		  }
	    	  }
	    	 top.moveTo(0,0);
	       //top.resizeTo(1100,1000);
		}
	}
}

function GetPVMInfo(sPVMRowid)
{
	GetPVMInfoByRowid(gGetObjValue("txtGetMPVM"),sPVMRowid);
	}
	
function SetDefaultData(){
	gSetObjValue("ReportLocation",objLogUser.CtLoc.Desc);
	gSetObjValue("ctloc",objLogUser.CtLoc.Rowid);	
	}

function GetUser() {
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"),session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
    }
    
function SetReportType(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("ReportType",TempPlist[2]);
	gSetObjValue("ReportTypeCode",TempPlist[1]);
	websys_setfocus("INCItmNa");
	//websys_nextfocusElement(event.srcElement);
	}
	
function SetDescription(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("Description",TempPlist[2]);
	gSetObjValue("DescriptionCode",TempPlist[1]);
	//在表格中动态加行
	var CodeStr=GetTableString();
	if(CodeStr.indexOf(TempPlist[1])>-1)
	{alert(t['DescExist']);return;}
	AddRows(value);
	}
function GetTableString()
{
	var ret="";
	var objTable = document.getElementsByTagName("table")[1];
	var rowCount=objTable.rows.length;
	if(rowCount==2)return "";
	for(i=1;i<rowCount-1;i++)
	{
		tmpVal=objTable.rows[i].cells[0].innerText;
		if(ret=="")
			ret=tmpVal;
		else
			ret=ret+"/"+tmpVal;
	}
	return ret;
	}

function description_Cancel(value)
{
	var obj=event.srcElement.parentElement;
	//if(obj.tagName=="TD")
	var objTable = document.getElementsByTagName("table")[1];
	objTable.deleteRow(obj.parentElement.rowIndex);
	}
function SetOpinion(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("Opinion",TempPlist[2]);
	gSetObjValue("OpinionCode",TempPlist[1]);
	}
function SetINCItmName(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("INCItmNa",TempPlist[2]);
	gSetObjValue("INCItmID",TempPlist[0]);
	}
	
function SetReportPlace(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("ReportPlace",TempPlist[2]);
	gSetObjValue("ReportPlaceCode",TempPlist[1]);
	}
function SetBatNo(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("INCItmBatNo",TempPlist[1]);
	gSetObjValue("INCItmBatID",TempPlist[0]);
	}	

function SetPower(){	
	var encmeth=gGetObjValue("txtUserFunction");
	var sModule="DHCMedPVM";
	var TempStatusCode=objPVMReport.Status.Code;
	var SuperCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"Super");
	var RepCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"ReportPVM");
	var EditCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"AuditPVMReport");
	gHiddenElement("btnPrint");
	SuperCode="0";
	if (SuperCode=="0"){
		return;
		}
	else if (RepCode=="0"){
		gHiddenElement("btnAudit");
		return;
		}
	else if (EditCode=="0"){
		//alert("E");
		gHiddenElement("btnReport");
		gHiddenElement("btnDelete");
		gHiddenElement("btnCorrect");  
		gHiddenElement("btnSave");  	
		return;
		}
	else{
		//alert("D");
		gHiddenElement("btnReport");
		gHiddenElement("btnDelete");
		gHiddenElement("btnCorrect");
		gHiddenElement("btnAudit");
		return;
		}
	}
			
document.body.onload=BodyLoadHandler;