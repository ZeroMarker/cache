//Create by MLH
//DHCPERisResultItemEdit.js
var ComponentID=""
var gLastRow=0
document.write("<OBJECT ID='DealExe' CLASSID='CLSID:C9B2EA7D-EF39-4824-9C66-7CABD28DA6CE' CODEBASE='../addins/client/DealExe.CAB#version=1,0,0,6'></OBJECT>");

function LoadHandler() { 
	var tbl=document.getElementById("tDHCPERisResultItemEdit");
	if(tbl) tbl.ondblclick=DHC_SelectTmp;
	//var obj=document.getElementById("DealExe");
	//if (obj) obj.onclick=DealExe_click;
}
function DealExe_click()
{
	var DealExe=new ActiveXObject("DealExeP.DealExe");
	//Exe名称  参数  Exe's Title名称
	//DealExe.OpenExe("D:\ExeTest\\工程1.exe","aaaaa","ExeTest");
	
	var PIADM="";
	var obj=document.getElementById("PIADM");
	if (obj) PIADM=obj.value;
	//alert("D:\\pb90\\主程序.exe")
	DealExe.OpenExe("D:\\pb90\\主程序.exe",PIADM,"图文信息管理系统");
}
function DHC_SelectTmp()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc); 
	var selectrow=rowObj.rowIndex;  
	if (!selectrow) return;
	if (selectrow !=0) { 
		var TClinicInfoObj=document.getElementById("TClinicInfoz"+selectrow);
		var TExamDescObj=document.getElementById("TExamDescz"+selectrow);
		var TExamResultObj=document.getElementById("TExamResultz"+selectrow);  
		var ClinicInfoobj=document.getElementsByName('ClinicInfo')[gLastRow];
		var ExamDescobj=document.getElementsByName('ExamDesc')[gLastRow];
		var ExamResultobj=document.getElementsByName('ExamResult')[gLastRow]; 
		if ((ClinicInfoobj)&&(TClinicInfoObj)) ClinicInfoobj.value=ClinicInfoobj.value+TClinicInfoObj.innerText;
		if ((ExamDescobj)&&(TExamDescObj)) ExamDescobj.value=ExamDescobj.value+TExamDescObj.innerText;
		if ((ExamResultobj)&&(TExamResultObj)) ExamResultobj.value=ExamResultobj.value+TExamResultObj.innerText;
		return true; 
	}
}
function InitMe()	{
	var UpdateArr=document.getElementsByName('BSave');
	var BSaveTemplateArr=document.getElementsByName('BSaveTemplate');
	var ExamDesc=document.getElementsByName('ExamDesc');
	var ExamResult=document.getElementsByName('ExamResult');
	var ClinicInfo=document.getElementsByName('ClinicInfo');
	var ItemArr=document.getElementsByName('OEORIRowId');
	var DealExe=document.getElementsByName("BDealExe");
	//if (DealExe) DealExe.onclick=DealExe_click;
	//alert(DealExe.length)
	
	for (var i=0; i<UpdateArr.length; i++)	{
		if (UpdateArr[i].id=='BSave') {
			UpdateArr[i].id=UpdateArr[i].id;
			UpdateArr[i].name=ItemArr[i].value+"^"+i;
			UpdateArr[i].onclick=Update_Click;
			//UserLookUpObj[i].onclick=UserLookUpObj[0].onclick;
		}
	}
	//var UpdateArr=document.getElementsByName('BSaveTemplate');
	for (var i=0; i<BSaveTemplateArr.length; i++)	{
		if (BSaveTemplateArr[i].id=='BSaveTemplate') {
			BSaveTemplateArr[i].id=BSaveTemplateArr[i].id;
			BSaveTemplateArr[i].name=ItemArr[i].value+"^"+i;
			BSaveTemplateArr[i].onclick=BSaveTemplate_Click;
			//UserLookUpObj[i].onclick=UserLookUpObj[0].onclick;
		}
	}
	//var UpdateArr=document.getElementsByName('BDealExe');
	for (var i=0; i<DealExe.length; i++)	{
		if (DealExe[i].id=='BDealExe') {
			DealExe[i].id=DealExe[i].id;
			DealExe[i].name=ItemArr[i].value+"^"+i;
			DealExe[i].onclick=DealExe_click;
			//UserLookUpObj[i].onclick=UserLookUpObj[0].onclick;
		}
	}
	var UpdateArr=document.getElementsByName('BGetTem');
	for (var i=0; i<UpdateArr.length; i++)	{
		if (UpdateArr[i].id=='BGetTem') {
			UpdateArr[i].id=UpdateArr[i].id;
			UpdateArr[i].name=ItemArr[i].value+"^"+i;
			UpdateArr[i].onclick=GetTemp_Click;
			
		}
	}
	var UpdateArr=document.getElementsByName('BGetCheckTemp');
	for (var i=0; i<UpdateArr.length; i++)	{
		if (UpdateArr[i].id=='BGetCheckTemp') {
			UpdateArr[i].id=UpdateArr[i].id;
			UpdateArr[i].name=ItemArr[i].value+"^"+i;
			UpdateArr[i].onclick=GetCheckTemp_Click;
			
		}
	}
	var UserLookUpObj=document.getElementsByName('UserName');
	for (var i=0; i<UserLookUpObj.length; i++)	{
		if (UserLookUpObj[i].id=='UserName') {
			UserLookUpObj[i].id=UserLookUpObj[i].id;
			UserLookUpObj[i].name=ItemArr[i].value+"^"+i;
			UserLookUpObj[i].onkeydown=UserKeyDown;
			
		}
	}
		var ReportUserLookUpObj=document.getElementsByName('ReportUserName');
		for (var i=0; i<ReportUserLookUpObj.length; i++)	{
		if (ReportUserLookUpObj[i].id=='ReportUserName') {
			ReportUserLookUpObj[i].id=ReportUserLookUpObj[i].id;
			ReportUserLookUpObj[i].name=ItemArr[i].value+"^"+i;
			ReportUserLookUpObj[i].onkeydown=ReportUserKeyDown;
			
		}
	}
	//谢绝检查
	var refuseArr=document.getElementsByName("Refuse");
	for (var i=0; i<refuseArr.length; i++)	{
		if (refuseArr[i].id=='Refuse') {
			refuseArr[i].id=refuseArr[i].id+ItemArr[i].id;
		
			refuseArr[i].name=ItemArr[i].value;
			//alert(refuseArr[i].name);
			refuseArr[i].onclick=RefuseClick;
			
		}
	}
	///PermissonSetting();
}
function UserKeyDown(){
	var key=websys_getKey(e);
	if (13==key) {
		var ButtId=window.event.srcElement.name;
		var i=ButtId.split("^")[1];
		gLastRow=i
		var name=document.getElementsByName('UserName')[i].value;
		ShowUser(name);
		return false;
		}
}
function ShowUser(Arg)
{
	var method="web.DHCPE.PreIADM:UserList"
	var jsfunction="GetUserID"
	var url='websys.lookup.csp';
		url += "?ID=";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ Arg;
	websys_lu(url,1,'');
	return websys_cancel();	
}
function GetUserID(value)
{
	var Data=value.split("^");
	var name=document.getElementsByName('UserID')[gLastRow];
	if (name) name.value=Data[1];
	var name=document.getElementsByName('UserName')[gLastRow];
	if (name) name.value=Data[0];
}
function ReportUserKeyDown(){
	var key=websys_getKey(e);
	if (13==key) {
		var ButtId=window.event.srcElement.name;
		var i=ButtId.split("^")[1];
		gLastRow=i
		var name=document.getElementsByName('ReportUserName')[i].value;
		ShowReportUser(name);
		return false;
		}
}
function ShowReportUser(Arg)
{
	var method="web.DHCPE.PreIADM:UserList"
	var jsfunction="GetReportUserID"
	var url='websys.lookup.csp';
		url += "?ID=";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ Arg;
	websys_lu(url,1,'');
	return websys_cancel();	
}
function GetReportUserID(value)
{
	var Data=value.split("^");
	var name=document.getElementsByName('ReportUserID')[gLastRow];
	if (name) name.value=Data[1];
	var name=document.getElementsByName('ReportUserName')[gLastRow];
	if (name) name.value=Data[0];
}
function GetTemp_Click(){
	var ButtId=window.event.srcElement.name;
	//var i=ButtId.split("^")[1];
	gLastRow=ButtId.split("^")[1];
	//var gLastRow=ButtId.split("^")[1]; 
	var OEORDItemID=ButtId.split("^")[0]; 
	var obj=document.getElementsByName('TemplateAlias')[gLastRow];
	if (obj){var TemplateAlias=obj.value}
	var method="web.DHCPE.ResultEdit:ODSRisTemplate"
	var jsfunction="GetTempSub"
	var url='websys.lookup.csp';
		url += "?ID=";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ OEORDItemID;
		url += "&P2="+ TemplateAlias; 
	websys_lu(url,1,'');
	return websys_cancel();	
	
	var ExamDescobj=document.getElementsByName('ExamDesc')[i];
	var ExamResultobj=document.getElementsByName('ExamResult')[i];
	var ClinicInfoobj=document.getElementsByName('ClinicInfo')[i];
	var UpdateMothod=document.getElementById("GetTemp");
	var encmeth="";
	if (UpdateMothod) encmeth=UpdateMothod.value;
	var ReturnStr=cspRunServerMethod(encmeth,OEOrdItemID);
	ReturnStr=ReturnStr.split("^")
	var ExamDesc=ReturnStr[1],ExamResult=ReturnStr[2],ClinicInfo=ReturnStr[0];
	if (ExamDescobj) ExamDescobj.value=ExamDesc;
	if (ExamResultobj) ExamResultobj.value=ExamResult;
	if (ClinicInfoobj) ClinicInfoobj.value=ClinicInfo;
}
function GetRisTemplate_Click(){
	var ButtId=window.event.srcElement.name;
	//var i=ButtId.split("^")[1];
	gLastRow=ButtId.split("^")[1];
	//var gLastRow=ButtId.split("^")[1];
	var OEORDItemID=ButtId.split("^")[0];
	var method="web.DHCPE.ResultEdit:ODSRisTemplate"
	var jsfunction="GetTempSub"
	var url='websys.lookup.csp';
		url += "?ID=";
		url += "&CONTEXT=K"+method;
		url += "&TLUJSF="+jsfunction;	
		url += "&P1="+ OEORDItemID;
	websys_lu(url,1,'');
	return websys_cancel();	
	
	var ExamDescobj=document.getElementsByName('ExamDesc')[i];
	var ExamResultobj=document.getElementsByName('ExamResult')[i];
	var ClinicInfoobj=document.getElementsByName('ClinicInfo')[i];
	var UpdateMothod=document.getElementById("GetTemp");
	var encmeth="";
	if (UpdateMothod) encmeth=UpdateMothod.value;
	var ReturnStr=cspRunServerMethod(encmeth,OEOrdItemID);
	ReturnStr=ReturnStr.split("^")
	var ExamDesc=ReturnStr[1],ExamResult=ReturnStr[2],ClinicInfo=ReturnStr[0];
	if (ExamDescobj) ExamDescobj.value=ExamDesc;
	if (ExamResultobj) ExamResultobj.value=ExamResult;
	if (ClinicInfoobj) ClinicInfoobj.value=ClinicInfo;
}
function GetTempSub(value)
{ 
	if (value=="") return;
	valueSplit=value.split("^");
	var Leng=valueSplit.length
	if (Leng=="2") {var value="^"+value}
	if (Leng=="1") {var value="^^"+value}
    value=value.split("^");
    
	var ExamDescobj=document.getElementsByName('ExamDesc')[gLastRow];
	var ExamResultobj=document.getElementsByName('ExamResult')[gLastRow];
	var ClinicInfoobj=document.getElementsByName('ClinicInfo')[gLastRow];
	if (ExamDescobj) ExamDescobj.value=ExamDescobj.value+","+value[1];
	if (ExamResultobj) ExamResultobj.value=ExamResultobj.value+","+value[2];
	if (ClinicInfoobj) ClinicInfoobj.value=ClinicInfoobj.value+","+value[0];
}
function BSaveTemplate_Click(){
	var ButtId=window.event.srcElement.name;
	var i=ButtId.split("^")[1];
	var OEOrdItemID=ButtId.split("^")[0];
	var ResultStr=GetResultInfo(i);
	var encmeth="";
	var UpdateMothod=document.getElementById("SaveTemplateClass");
	if (UpdateMothod) encmeth=UpdateMothod.value;
	var ReturnStr=cspRunServerMethod(encmeth,OEOrdItemID,ResultStr)
	if (ReturnStr==0){
		alert("保存成功!")
		return false;
	}
	alert(ReturnStr);
}
function Update_Click()	{
	var ButtId=window.event.srcElement.name;
	var i=ButtId.split("^")[1];
	var OEOrdItemID=ButtId.split("^")[0];
	
	var ResultStr=GetResultInfo(i);
	var UserName="";
	var name=document.getElementsByName('UserID')[i];
	if (name) UserName=name.value;
	var name=document.getElementsByName('ReportUserID')[i];
	if (name) UserName=UserName+"^"+name.value;
	var encmeth="";
	var UpdateMothod=document.getElementById("UpdateSrc");
	if (UpdateMothod) encmeth=UpdateMothod.value;
	var EpisodeIDobj=document.getElementsByName('EpisodeID')[i];
	
	if (EpisodeIDobj) EpisodeID=EpisodeIDobj.value;
	var ReturnStr=cspRunServerMethod(encmeth,EpisodeID,OEOrdItemID,ResultStr,UserName)
	if (ReturnStr==0){alert("保存成功!")}
	
	return false;
	
}
function GetResultInfo(i)
{
	var ExamDescobj=document.getElementsByName('ExamDesc')[i];
	var ExamResultobj=document.getElementsByName('ExamResult')[i];
	var ClinicInfoobj=document.getElementsByName('ClinicInfo')[i];
	var ExamDesc="",ExamResult="",ClinicInfo="";
	if (ExamDescobj) ExamDesc=ExamDescobj.value;
	if (ExamResultobj) ExamResult=ExamResultobj.value;
	if (ClinicInfoobj) ClinicInfo=ClinicInfoobj.value;
	var ResultStr="临床诊断:"+ClinicInfo
	ResultStr=ResultStr+";检查所见:"+ExamDesc
	ResultStr=ResultStr+";诊断意见:"+ExamResult
	return ResultStr;
}
function RefuseClick(){
	//得到出发事件的对象
	var objSrc=window.event.srcElement;
	var OEORIRowid=objSrc.name;
	var RefuseMethod=document.getElementById("RefuseBox");
	if(RefuseMethod){
		var encmeth=RefuseMethod.value;
	}
	var RefuseCode=cspRunServerMethod(encmeth,OEORIRowid);
	
	if (RefuseCode=='0') {alert("谢绝成功");}
	else if(RefuseCode=="-1")
	{
		alert("已经有检查?不能谢绝");
	}
	else
	 {alert("谢绝错误");}
	return false;
}

function GetCheckTemp_Click(){
    detailStandard()
}
function PermissonSetting(){
	var UserId, PAAdmId, ChartId, SvrMethod
	UserId=session['LOGON.USERID'];
	PAAdmId=GetCtlValueById("EpisodeID", 0)
	ChartId=GetCtlValueById("ChartID", 1)
	SvrMethod=GetCtlValueById("methodResultPermission", 1)
	var MyPermission=cspRunServerMethod(SvrMethod,UserId, PAAdmId, 0, ChartId)
	if (MyPermission=="R"){
		DisabledCtls("A",true);
		DisabledCtls("input",true);
	    DisabledCtls("select",true);
		return "R";
	}
	return "W";
	
}
function BDeleteTemplate()
{
	var objSrc=window.event.srcElement;
	var ID=objSrc.id;
	var obj=document.getElementById("DeleteTemplateClass");
	var encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,ID);
	window.location.reload();
	
}
document.body.onload=LoadHandler;
