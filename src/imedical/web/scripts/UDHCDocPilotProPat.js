document.body.onload = BodyLoadHandler;

var m_PAPMINOLength=8;
 var myCombAry=new Array();
function BodyLoadHandler(){
	var Obj=document.getElementById("Save");
	if (Obj) Obj.onclick=SaveClick;
	var Obj=document.getElementById("Cancel");
	if (Obj) Obj.onclick=CancelClick;
	var Obj=document.getElementById("Exit");
	if (Obj) Obj.onclick=ExitClick;
	var Obj=document.getElementById("Complete");
	if (Obj) Obj.onclick=CompleteClick;
	var Obj=document.getElementById("ProjectList");
	if (Obj) Obj.onchange=ProjectListChangeHander;
	var Obj=document.getElementById("PapmiNo");
	if (Obj) Obj.onkeydown=PapmiNoKeyDownHander;
	var Obj=document.getElementById("ProPatList");
	if (Obj) Obj.onchange=ProPatListChangeHander;
	var Obj=document.getElementById("AgreementDate");
	if (Obj){Obj.disabled=true}
	//LoadCancelReason()
	HiddenCancelReason("hidden");
	HiddenExitDate("hidden");
	HiddenPatOperButton("hidden");
	//alert(11)
	AddPatientInfo();
	LoadProjectList();
	var Obj=document.getElementById('FindProjectList');
	if (Obj){
	  Obj.onkeyup =FindProjectListChange;
	}
	//InitHealthCareProvider();
	//var begin=new Date($("#begin").val().replace(/-/g,"/"));
     // var end=new Date($("#end").val().replace(/-/g,"/"));
      //js判断日期
     // if(begin-end>0){
        // alert("开始日期要在截止日期之前!");  
        // return false;
      //}
}
var TimeOutDept;
function FindProjectListChange(){
	var FindProjectStr=DHCC_GetElementData('FindProjectList');
	var tmp=document.getElementById('ProjectList');
	if(FindProjectStr==""){
		tmp.selectedIndex=-1
		return 	
	}
	if(TimeOutDept){
		clearTimeout(TimeOutDept)    
	}
	TimeOutName=setTimeout("FindDept()",500)
}
function FindDept(){
	var FindProjectStr=DHCC_GetElementData('FindProjectList');	
	FindProjectStr=FindProjectStr.toUpperCase()
	var tmp=document.getElementById('ProjectList');
	var len=tmp.length
	var ProjectId=""
	for(var i=0;i<len;i++){
		var selItem=tmp.options[i];	
		var selText=selItem.text
		var selTextArr=selText.split("-")
		if ((selTextArr[0].toUpperCase().indexOf(FindProjectStr)>=0)||(selTextArr[1].toUpperCase().indexOf(FindProjectStr)>=0)){
			tmp.selectedIndex=i;
			ProjectListChangeHander();
			ProjectId=selItem.value
			break;
		}
	}
	if(ProjectId==""){
		tmp.selectedIndex=-1;
		ProjectListChangeHander();
	}
}
//CancelReason
function LoadCancelReason(){
	var CancelReason=DHCC_GetElementData('CancelReason');
	if (document.getElementById('CancelReason')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var CancelReasonStr=cspRunServerMethod(encmeth,"科研药理","取消原因")
		combo_CancelReason=dhtmlXComboFromStr("CancelReason",CancelReasonStr);
		myCombAry["CancelReason"]=combo_CancelReason;
		combo_CancelReason.enableFilteringMode(true);
		combo_CancelReason.selectHandle=combo_CancelReasonKeydownhandler;
		combo_CancelReason.setComboText(CancelReason)
		}
	}
}
function combo_CancelReasonKeydownhandler(){
	var CancelReasonRowId=combo_CancelReason.getSelectedValue();
	DHCC_SetElementData('CancelReasonDr',CancelReasonRowId);
	}
function HiddenPatOperButton(flag) {
	var Obj=document.getElementById("Cancel");
	if (Obj) Obj.style.visibility=flag;
	var Obj=document.getElementById("Exit");
	if (Obj) Obj.style.visibility=flag;
	var Obj=document.getElementById("Complete");
	if (Obj) Obj.style.visibility=flag;
}
function HiddenCancelReason(flag){
	var Obj=document.getElementById("CancelReason");
	if (Obj) Obj.style.visibility=flag;
	var Obj=document.getElementById("cCancelReason");
	if (Obj) Obj.style.visibility=flag;
}
function HiddenExitDate(flag){
	var Obj=document.getElementById("ExitDate");
	if (Obj) {
		Obj.style.visibility=flag;
		if (Obj.nextSibling.tagName.toLowerCase()=="img") {
			Obj.nextSibling.style.visibility=flag;
		}
	}
	var Obj=document.getElementById("cExitDate");
	if (Obj) Obj.style.visibility=flag;
}
function ProPatListChangeHander(){
	//HiddenCancelReason("");
	//HiddenExitDate("");
	//HiddenPatOperButton("");
	//LoadCancelReason()
	var PPRowId=GetSelectedPPRowId();
	var encmeth=DHCC_GetElementData("GetProPatInfo");
	if (encmeth!="") {
		ClearProPatInfo();
		var SelPatientID=GetSelectedProPatId();
		if (SelPatientID!="") {
			var myXML=cspRunServerMethod(encmeth,SelPatientID,PPRowId);
			//alert(myXML)
			SetProInfoByXML(myXML);
		}
	}
}
function ClearProPatInfo() {
	DHCC_SetElementData("HealthCareProviderDr","");
	DHCC_SetElementData("HealthCareProvider","");
	DHCC_SetElementData("PPPReMark","");
	DHCC_SetElementData("PPPPatientLimit","");
	DHCC_SetElementData("AgreementDate","");
	DHCC_SetElementData("CancelReason","");
	DHCC_SetElementData("ExitDate","");
}
function GetSelectedPPRowId() {
	var SelectedPPRowId="";
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		SelectedPPRowId=PPRowId;
		break;
	}
	return SelectedPPRowId;
}
function GetSelectedProPatId() {
	var SelectedProPatId="";
	var PatListObj=document.getElementById("ProPatList");
	for (var j=0;j<PatListObj.length;j++){
		if (PatListObj.options[j].selected!=true) continue;
		var PatientID=PatListObj.options[j].value;
		SelectedProPatId=PatientID;
	}
	return SelectedProPatId;
}
function AddPatientInfo(){
	var EpisodeID=DHCC_GetElementData("EpisodeID");
	var PatientID=DHCC_GetElementData("PatientID");
	var PatNo=DHCC_GetElementData("GetPatNoByID");
	var obj=document.getElementById('PapmiNo');
	if (obj){
		obj.value=PatNo;
	}else{
		alert("请联系管理员添加PapmiNo元素.");
		return;
	}
	SetPatInfo();
}
function DHCC_StrToArrayLocal(str) {
    var x = new Array();
    var Arr = str.split('^');
    for (var i = 0; i < Arr.length; i++) {
        var Arr1 = Arr[i].split(String.fromCharCode(1));
        var label = Arr1[1];
        var val = Arr1[0];
        var otherInfo = Arr1[2];
        if ((typeof (val) == "undefined") || (val === null)) val = label;
        x[i] = [val, label, otherInfo];
    }
    return x;
}
function LoadProjectList(){
	var ProjectListObj=document.getElementById("ProjectList");
	
	var Str=DHCC_GetElementData("GetProjectStr");
	var myArray = DHCC_StrToArrayLocal(Str);
	for (var i=0;i<myArray.length;i++){
	    var myArrayTemp = myArray[i];
		ProjectListObj.options[i] = new Option(myArrayTemp[1], myArrayTemp[0])
		ProjectListObj.options[i].title = myArrayTemp[2];
	}	
}
function SetProPatList(PPRowId){
	/*   //1??每次对一个项目的病人列表赋值
	DHCC_ClearList("ProPatList");
	var PatListObj=document.getElementById("ProPatList");
	var encmeth=DHCC_GetElementData("GetProPatStrByProID");
	if (encmeth!=""){
		var rtnStr=cspRunServerMethod(encmeth,PPRowId);
		var rtnArray=rtnStr.split("^");
		for (var i=0;i<rtnArray.length;i++){
			var rtnArrayTemp=rtnArray[i].split(String.fromCharCode(1))
			PatListObj.options[i]=new Option(rtnArrayTemp[1],rtnArrayTemp[0])
		}
	}*/
	//2??每次对所有已经选择的项目的病人列表赋值
	var PatListObj=document.getElementById("ProPatList");
	var PatListLen=PatListObj.length;
	var encmeth=DHCC_GetElementData("GetProPatStrByProID");
	if (encmeth!=""){
		var rtnStr=cspRunServerMethod(encmeth,PPRowId);
		var rtnArray=rtnStr.split("^");
		for (var i=PatListLen;i<PatListLen+rtnArray.length;i++){
			var rtnArrayTemp=rtnArray[i-PatListLen].split(String.fromCharCode(1))
			PatListObj.options[i]=new Option(rtnArrayTemp[1],rtnArrayTemp[0])
		}
	}
}
function ProjectListChangeHander(){
	DHCC_ClearList("ProPatList");
	HiddenCancelReason("hidden");
	HiddenExitDate("hidden");
	HiddenPatOperButton("hidden");
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		if ((PPRowId=="")||(PPRowId=="undefined")){continue}
		SetProPatList(PPRowId);
		var UserDr=session['LOGON.USERID'];
		var ret=tkMakeServerCall("web.PilotProject.DHCDocPilotProCommon", "GetStartUserByUserID", PPRowId,UserDr);
		//alert(ret)
		var arr=ret.split("^")
		 DHCC_SetElementData("HealthCareProviderDr",arr[0]);
		 DHCC_SetElementData("HealthCareProvider",arr[1]);
		
	}
}
function SaveClick(){
	var ProjectListObj=document.getElementById("ProjectList");
	if (ProjectListObj.selectedIndex==-1){
		alert("请选择项目!");
		return false;
	}
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		
		var myrtn=CheckBeforeSave(PPRowId);
		if (myrtn==false) return;
		
		SaveDataToServer(PPRowId);
	}
	window.close();

}
function CheckBeforeSave(PPRowId){
	//todo check
	if (Trim(PPRowId)=="") {
		alert("请选择有效项目.");
		return false;
	}
	var AgreementDate=DHCC_GetElementData("AgreementDate");
	if (AgreementDate=="") {
		alert("签署知情同意书日期不能为空.");
		return false;
	}
	var AgDate=AgreementDate.split("/")
	var myDate = new Date();
	var objDate = new Date(myDate.getFullYear(),myDate.getMonth()+1,myDate.getDate(),0,0,0);
	var minDate = new Date(AgDate[2],AgDate[1],AgDate[0],0,0,0);
	if (minDate.getTime() > objDate.getTime()) {
			alert("签署知情同意书日期不能晚于当前日期！");
			return false;
	}
	return true;
}
function SaveDataToServer(PPRowId){
	try{
		var myProPatInfo=getProPatInfo();
		var encmeth=DHCC_GetElementData("SaveMethod");
		if (encmeth!=""){
			//alert(myProPatInfo+","+PPRowId)
			var rtn=cspRunServerMethod(encmeth, myProPatInfo, PPRowId,session['LOGON.USERID']);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				alert("保存成功!");
				var EpisodeID=DHCC_GetElementData("EpisodeID");
				var PatientID=DHCC_GetElementData("PatientID");
				var PatientLimit=DHCC_GetElementData("PPPPatientLimit");
				var ReMark=DHCC_GetElementData("PPPReMark");
				var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProPat&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PPPPatientLimit="+PatientLimit+"&PPPReMark="+ReMark;
				window.location.href=lnk;
			}else{
				alert("错误: "+myArray[1]);
			}
		}
	}catch(E){
		alert(E.message);
		return;
	}
}
function getProPatInfo(){
	var myxml="";
	var myparseinfo = DHCC_GetElementData("InitProPatEntity");
	var myxml=GetEntityClassInfoToXML(myparseinfo)

	return myxml;
}
function CancelClick(){
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		var CancelReason=DHCC_GetElementData("CancelReason");
		if (CancelReason==""){
			alert("取消病人必须填写取消原因!");
			return;
		}
		/*
		var myrtn=CheckBeforeSave();
		if (myrtn==false)retrun;
		*/
		var PatListObj=document.getElementById("ProPatList");
		for (var j=0;j<PatListObj.length;j++){
			if (PatListObj.options[j].selected!=true) continue;
			var PatientID=PatListObj.options[j].value;
			var PPPCancelUserDr=session['LOGON.USERID'];
			var CancelVisitStatus="C";
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
		}
	}
}
function SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus){
	try{
		//var myProPatInfo=getProPatInfo();
		var encmeth=DHCC_GetElementData("CancelMethod");
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				if (CancelVisitStatus=="C") {alert("病人取消成功!");}
				else if (CancelVisitStatus=="R"){alert("病人退出成功!");}
				else {alert("保存成功!");}
				var EpisodeID=DHCC_GetElementData("EpisodeID");
				var PatientID=DHCC_GetElementData("PatientID");
				var PatientLimit=DHCC_GetElementData("PPPPatientLimit");
				var ReMark=DHCC_GetElementData("PPPReMark");
				var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProPat&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PPPPatientLimit="+PatientLimit+"&PPPReMark="+ReMark;
				window.location.href=lnk;
			}else{
				alert("错误: "+myArray[1]);
			}
		}
	}catch(E){
		alert(E.message);
		return;
	}
}
function PapmiNoKeyDownHander(){
	var key=websys_getKey(e);
	if (key==13){
		SetPapmiNoLenth();
		SetPatInfo();
	}
}
function ExitClick(){
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		var CancelReason=DHCC_GetElementData("CancelReason");
		if (CancelReason==""){
			alert("退出病人必须填写退出原因!");
			return;
		}
		/*
		var myrtn=CheckBeforeSave();
		if (myrtn==false)retrun;
		*/
		var PatListObj=document.getElementById("ProPatList");
		for (var j=0;j<PatListObj.length;j++){
			if (PatListObj.options[j].selected!=true) continue;
			var PatientID=PatListObj.options[j].value;
			var PPPCancelUserDr=session['LOGON.USERID'];
			var CancelReason="";
			var CancelVisitStatus="R";
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
		}
	}
}
function CompleteClick() {
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		/*
		var myrtn=CheckBeforeSave();
		if (myrtn==false)retrun;
		*/
		var PatListObj=document.getElementById("ProPatList");
		for (var j=0;j<PatListObj.length;j++){
			if (PatListObj.options[j].selected!=true) continue;
			var PatientID=PatListObj.options[j].value;
			var PPPCancelUserDr=session['LOGON.USERID'];
			var CancelReason="";
			var CancelVisitStatus="O";
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
		}
	}
}
function SetPatInfo(){
	var obj=document.getElementById('PapmiNo');
	if (obj){
		var encmeth=DHCC_GetElementData("GetPatInfoMethod");
		if (encmeth!=""){
			var rtnStr=cspRunServerMethod(encmeth,obj.value);
			if (rtnStr!=""){
				var rtnStrTemp=rtnStr.split("^");
				var myStr=rtnStrTemp[1]+","+rtnStrTemp[2]+","+rtnStrTemp[3]+","+rtnStrTemp[4];
				DHCC_SetElementData("PatientID",rtnStrTemp[0]);
				DHCC_SetElementData("PatInfo",myStr);
			}
		}
	}
}
function SetPapmiNoLenth()
{
	// Set PAPMINo and CardNO Refer
	var obj=document.getElementById('PapmiNo');
	if (obj.value!='') {
		if ((obj.value.length<m_PAPMINOLength)&&(m_PAPMINOLength!=0)) {
			for (var i=(m_PAPMINOLength-obj.value.length-1); i>=0; i--) {
				obj.value="0"+obj.value
			}
		}	
	}
}
function GetEntityClassInfoToXML(ParseInfo)
{
	var myxmlstr="";
	try
	{
		var myary=ParseInfo.split("^");
		
		var xmlobj=new XMLWriter();
		xmlobj.BeginNode(myary[0]);
		for(var myIdx=1;myIdx<myary.length;myIdx++){
			
			xmlobj.BeginNode(myary[myIdx]);
			/*
			var myTagIdx=m_CombXmlTagAray.indexOf(myary[myIdx]);
			var myCombName=myary[myIdx];
			if(myTagIdx>-1){
				var myCombName=myCombNameAry[myTagIdx];
			}
			*/
			if (myCombAry[myary[myIdx]]){
				var myval =myCombAry[myary[myIdx]].getSelectedValue();
				myval=myval.split("^")[0];
			}else{
				var myval = DHCWebD_GetObjValueXMLTransA(myary[myIdx]);
			}
			xmlobj.WriteString(myval);
			
			xmlobj.EndNode();
		}
		xmlobj.Close();
		myxmlstr = xmlobj.ToString();
	}catch(Err)
	{
		alert("Error: " + Err.description);
	}	
	return myxmlstr;
	
}
function SetProInfoByXML(XMLStr)
{
	xMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{ 
		alert(xmlDoc.parseError.reason); 
		return; 
	}
	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboText(myItemValue);
		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function LookUpHCP(str){
	var tem = str.split("^");
	DHCC_SetElementData("HealthCareProviderDr",tem[1]);
	DHCC_SetElementData("HealthCareProvider",tem[0]);
}
function InitHealthCareProvider(){
	var obj=document.getElementById('GetHealthCareProviderByDoc')
	if(obj){
		var encmeth=obj.value
	 var ret=cspRunServerMethod(encmeth);
	 if (ret!=""){
		 var arr=ret.split('^')
		 DHCC_SetElementData("HealthCareProviderDr",arr[0]);
		 DHCC_SetElementData("HealthCareProvider",arr[1]);
	 }
	}	
}