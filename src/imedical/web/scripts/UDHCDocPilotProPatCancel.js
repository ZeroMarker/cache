//UDHCDocPilotProPatCancel.js
document.body.onload = BodyLoadHandler;

var m_PAPMINOLength=8;
 var myCombAry=new Array();
function BodyLoadHandler(){
	var Obj=document.getElementById("Cancel");
	if (Obj) Obj.onclick=CancelClick;
	var Obj=document.getElementById("Exit");
	if (Obj) Obj.onclick=ExitClick;
	var Obj=document.getElementById("Complete");
	if (Obj) Obj.onclick=CompleteClick;
	LoadCancelReason()
	AddPatientInfo();
	
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
function CancelClick(){
		var PPRowId=DHCC_GetElementData("PPRowId");
		var CancelReason=DHCC_GetElementData("CancelReason");
		if (CancelReason==""){
			alert("取消病人必须填写取消原因!");
			return;
		}
			var PatientID=DHCC_GetElementData("PatientID");
			var PPPCancelUserDr=session['LOGON.USERID'];
			var CancelVisitStatus="C";
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
	
}
function SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus){
	try{
		//var myProPatInfo=getProPatInfo();
		var encmeth=DHCC_GetElementData("CancelMethod");
		var ExitDate=DHCC_GetElementData("ExitDate");
		if (encmeth!=""){
			//alert(PPRowId+"^"+PatientID+"^"+PPPCancelUserDr+"^"+CancelReason+"^"+CancelVisitStatus)
			var rtn=cspRunServerMethod(encmeth,PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus,"",ExitDate);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				if (CancelVisitStatus=="C") {alert("病人取消成功!");}
				else if (CancelVisitStatus=="R"){alert("病人退出成功!");}
				else {alert("保存成功!");}
				//var EpisodeID=DHCC_GetElementData("EpisodeID");
				//var PatientID=DHCC_GetElementData("PatientID");
				//var PatientLimit=DHCC_GetElementData("PPPPatientLimit");
				//var ReMark=DHCC_GetElementData("PPPReMark");
				//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProPat&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&PPPPatientLimit="+PatientLimit+"&PPPReMark="+ReMark;
				window.close()
				window.opener.location.reload();
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
		var PPRowId=DHCC_GetElementData("PPRowId");
		var CancelReason=DHCC_GetElementData("CancelReason");
		if (CancelReason==""){
			alert("退出病人必须填写退出原因!");
			return;
		}
		
			var PatientID=DHCC_GetElementData("PatientID");
			var PPPCancelUserDr=session['LOGON.USERID'];
			//var CancelReason="";
			var CancelVisitStatus="R";
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
}
function CompleteClick() {
			var PPRowId=DHCC_GetElementData("PPRowId");
			var PatientID=DHCC_GetElementData("PatientID");
			var PPPCancelUserDr=session['LOGON.USERID'];
			var CancelReason="";
			var CancelVisitStatus="O";
			SaveDelDataToServer(PPRowId,PatientID,PPPCancelUserDr,CancelReason,CancelVisitStatus);
}
function SetPatInfo(){
	var obj=document.getElementById('PapmiNo');
	if (obj){
		var encmeth=DHCC_GetElementData("GetPatInfoMethod");
		if (encmeth!=""){
			var rtnStr=cspRunServerMethod(encmeth,obj.value);
			if (rtnStr!=""){
				var rtnStrTemp=rtnStr.split("^");
				var myStr="登记号:"+rtnStrTemp[1]+",姓名:"+rtnStrTemp[2]+",性别:"+rtnStrTemp[3]+",年龄:"+rtnStrTemp[4];
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
