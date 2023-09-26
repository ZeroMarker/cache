document.body.onload = BodyLoadHandler;

var SelectedRow=0;
var m_PAPMINOLength=8;
var myCombAry=new Array();
var e=event;
function BodyLoadHandler(){
	/*
	var Obj=document.getElementById("Save");
	if (Obj) Obj.onclick=SaveClick;
	var Obj=document.getElementById("Cancel");
	if (Obj) Obj.onclick=CancelClick;
	var Obj=document.getElementById("Exit");
	if (Obj) Obj.onclick=ExitClick;
	var Obj=document.getElementById("ProjectList");
	if (Obj) Obj.onchange=ProjectListChangeHander;
	var Obj=document.getElementById("PapmiNo");
	if (Obj) Obj.onkeydown=PapmiNoKeyDownHander;
	
	AddPatientInfo();
	*/
	var Obj=document.getElementById("PatientNo");
	if (Obj) Obj.onkeydown=PapmiNoKeyDownHander;
	var Obj=document.getElementById("PatName");
	if (Obj) {
	 Obj.onkeydown=PatNameKeyDownHander;
	 Obj.onchange=PatNameChange;
	}
	LoadProjectList();
	InitStatus()
	//进入科研病人列表清除头菜单的选择信息
	var frm=dhcsys_getmenuform();
	if (frm){
		frm.PPRowId.value="";
		frm.EpisodeID.value="";
		frm.PatientID.value="";
	}
	
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
function LoadProjectList(){
	var ProjectListObj=document.getElementById("ProjectList");
	
	var Str=DHCC_GetElementData("GetProjectStr");
	var myArray=DHCC_StrToArray(Str);
	for (var i=0;i<myArray.length;i++){
		var myArrayTemp=myArray[i];
		ProjectListObj.options[i]=new Option(myArrayTemp[1],myArrayTemp[0])
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
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		SetProPatList(PPRowId);
	}
}
function SaveClick(){
	var ProjectListObj=document.getElementById("ProjectList");
	for (var i=0;i<ProjectListObj.length;i++){
		if (ProjectListObj.options[i].selected!=true) continue;
		var PPRowId=ProjectListObj.options[i].value;
		
		var myrtn=CheckBeforeSave();
		if (myrtn==false)retrun;
		
		SaveDataToServer(PPRowId);
	}
	
}
function CheckBeforeSave(){
	//todo check
	return true;
}
function SaveDataToServer(PPRowId){
	try{
		var myProPatInfo=getProPatInfo();
		var encmeth=DHCC_GetElementData("SaveMethod");
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth, myProPatInfo, PPRowId);
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
		/*
		var myrtn=CheckBeforeSave();
		if (myrtn==false)retrun;
		*/
		var PatListObj=document.getElementById("ProPatList");
		for (var j=0;j<PatListObj.length;j++){
			if (PatListObj.options[j].selected!=true) continue;
			var PatientID=PatListObj.options[j].value;
			var PPPCancelUserDr=session['LOGON.USERID'];
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr);
		}
	}
}
function SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr){
	try{
		//var myProPatInfo=getProPatInfo();
		var encmeth=DHCC_GetElementData("CancelMethod");
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,PPRowId,PatientID,PPPCancelUserDr);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				alert("删除成功!");
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
		Search_click();
	}
}
function ExitClick(){
	window.close();
}
function SetPatInfo(){
	var obj=document.getElementById('PatientNo');
	if (obj){
		var encmeth=DHCC_GetElementData("GetPatInfoMethod");
		if (encmeth!=""){
			var rtnStr=cspRunServerMethod(encmeth,obj.value);
			if (rtnStr!=""){
				var rtnStrTemp=rtnStr.split("^");
				var myStr=rtnStrTemp[1]+","+rtnStrTemp[2]+","+rtnStrTemp[3]+","+rtnStrTemp[4];
				DHCC_SetElementData("PatientID",rtnStrTemp[0]);
				//DHCC_SetElementData("PatInfo",myStr);
				DHCC_SetElementData("PatName",rtnStrTemp[2]);
			}
			else{
				DHCC_SetElementData("PatName","");
				DHCC_SetElementData("PatientID","");
				}
		}
	}
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCDocProPatientList');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
  if ((SelectedRow!=0)&&(selectrow==SelectedRow)){
		SelectedRow=0;
		return;
	}
	
	var PPRowId=document.getElementById('PPRowIdz'+selectrow).value;
	var frm=dhcsys_getmenuform();
	if (frm){
		frm.PPRowId.value=PPRowId;
	}
	/*
	var win=top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
        if (frm) {
					frm.PPRowId.value=PPRowId;
        }
	}
	*/
}
function SetPapmiNoLenth()
{
	// Set PAPMINo and CardNO Refer
	var m_PAPMINOLength=8;
	var obj=document.getElementById('PatientNo');
	var objLen=document.getElementById('m_PAPMINOLength');
	if (objLen) m_PAPMINOLength=objLen.value
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
function LoadProjectList(){
	var PPDesc=DHCC_GetElementData('PPDesc');
	if (document.getElementById('PPDesc')){
		var GetDefineDataStr=document.getElementById('GetProjectStr')
		if(GetDefineDataStr){
		//var encmeth=
		var PPDescStr=GetDefineDataStr.value
		combo_PPDesc=dhtmlXComboFromStr("PPDesc",PPDescStr);
		myCombAry["PPDesc"]=combo_PPDesc;
		combo_PPDesc.enableFilteringMode(true);
		combo_PPDesc.selectHandle=combo_PPDescKeydownhandler;
		combo_PPDesc.setComboText(PPDesc)
		}
	}

}
	function combo_PPDescKeydownhandler(){
	var PPRowId=combo_PPDesc.getSelectedValue();
	DHCC_SetElementData('PPRowId',PPRowId);
	}
function InitStatus()

{
	
	var objtbl=document.getElementById('tUDHCDocProPatientList');
	if (!objtbl) objtbl=document.getElementById('tUDHCDocProPatientList0');
	if (objtbl)
	{
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			
			var PatStatus=DHCC_GetColumnData("PatStatus",i);
			//alert(CDD+"-"+QT+"-"+N+TS)
			if (PatStatus=="退出"){
			rows[i].style.backgroundColor="#BEBEBE"}
			}
						
		}		
}

function PatNameKeyDownHander()
{	var key=websys_getKey(e);
	if (key==13){
		
		PatNameChange()
	}
}
function PatNameChange()
{
	var Obj=document.getElementById("PatientNo");
	if(Obj){Obj.value=""}
}