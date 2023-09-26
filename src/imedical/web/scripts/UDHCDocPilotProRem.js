document.body.onload = BodyLoadHandler;

var myCombAry=new Array();

function BodyLoadHandler(){
	var Obj=document.getElementById("Save");
	if (Obj) Obj.onclick=SaveClick;
	var Obj=document.getElementById("PPRReceiverLook");
	if (Obj) Obj.onkeyup=Receiverkeyup;
	if (window.name=="RemRecord"){
		//var PilotProject=DHCC_GetElementData('PilotProject');
		//var PPRowId=DHCC_GetElementData('PPRowId');
		var obj=document.getElementById("PilotProject");
		if (obj)obj.readOnly=true;
		websys_setfocus("PPRDate");
	}else{
		LoadDepartment();
	}
	var Obj=document.getElementById("PPRRemUserDr");
	if (Obj){if (Obj.value==""){Obj.value=session['LOGON.USERID']}}
}

function Receiverkeyup()
{
	var Obj=document.getElementById("PPRReceiverLook");
	if (Obj.value==""){
		var ObjPPRReceiver=document.getElementById("PPRReceiver");
		if (ObjPPRReceiver){ObjPPRReceiver.value=""}
	}
}
function LookUpReceive(Str)
{
	if (Str!=""){
		var Receivedr=Str.split("^")[1]
		var Obj=document.getElementById("PPRReceiver");
		if (Obj){Obj.value=Receivedr}
	}
}
function LoadDepartment(){
	var PilotProjectName=DHCC_GetElementData('PilotProject');
	if (document.getElementById('PilotProject')){
		var ProStr=DHCC_GetElementData('ProStr');
		combo_Pro=dhtmlXComboFromStr("PilotProject",ProStr);
		myCombAry["PilotProject"]=combo_Dep;
		combo_Pro.enableFilteringMode(true);
		combo_Pro.selectHandle=combo_ProKeydownhandler;
		combo_Pro.setComboText(PilotProjectName)
	}
}

function combo_ProKeydownhandler(){
	var PPRowId=combo_Pro.getSelectedValue();
	DHCC_SetElementData('PPRowId',PPRowId);
}

function SaveClick(){
	var PPRowId=DHCC_GetElementData("PPRowId");
	var myrtn=CheckBeforeSave();
	if (myrtn==false)retrun;
	SaveDataToServer(PPRowId);
}
function CheckBeforeSave(){
	var PPRowId=DHCC_GetElementData("PPRowId");
	if (PPRowId==""){
		alert("未找到项目,请重新选择项目再操作.");
		return false;
	}
	var PPRDate=DHCC_GetElementData("PPRDate");
	PPRDate=PPRDate.replace(/(^\s*)|(\s*$)/g,'');
	if (PPRDate==""){alert("请选择汇款日期");return false;}
	var sd=PPRDate.split("/");
    var IDateCompare = new Date(sd[2],sd[1]-1,sd[0]);
    var TodayDate=new Date()
    if (IDateCompare>TodayDate){
		alert("汇款日期大于操作日期，请重新选择"); return false; 
	}
	return true;
}
function SaveDataToServer(PPRowId){
	try{
		var myProRemInfo=getProRemInfo();
		if (myProRemInfo==""){alert("保存信息为空");return}
		var Rtn=confirm("是否确认保存记录信息正确？保存后将不可修改删除！")
		if (!Rtn){return false}
		var encmeth=DHCC_GetElementData("SaveMethod");
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth, myProRemInfo, PPRowId);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				alert("保存成功!");
				//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProRem&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PPPPatientLimit="+PatientLimit+"&PPPReMark="+ReMark;
				//window.location.href=lnk;
				window.location.reload();
			}else{
				alert("错误: "+myArray[1]);
			}
		}
	}catch(E){
		alert(E.message);
		return;
	}
}
function getProRemInfo(){
	var myxml="";
	var myparseinfo = DHCC_GetElementData("InitProRemEntity");
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
function ExitClick(){
	window.close();
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