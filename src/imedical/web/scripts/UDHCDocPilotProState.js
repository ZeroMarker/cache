document.body.onload = BodyLoadHandler;

var myCombAry=new Array();

function BodyLoadHandler(){
	init()
	var Obj=document.getElementById("Abort");
	if (Obj) Obj.onclick=AbortClick;
	var Obj=document.getElementById("AbortResume");
	if (Obj) Obj.onclick=AbortResumeClick;
	var Obj=document.getElementById("Strike");
	if (Obj) Obj.onclick=StrikeClick;
	var Obj=document.getElementById("Update");
	if (Obj) Obj.onclick=UpdateClick;

	/*var PilotProject=DHCC_GetElementData('PilotProject');
	//alert(PilotProject);
	if (Trim(PilotProject)!=""){
		var encmeth=DHCC_GetElementData("getCreateDepartment");
		if (encmeth!=""){
			var PPRowId=DHCC_GetElementData('PPRowId');
			//alert(PPRowId);
			var CreateDepartmentID=cspRunServerMethod(encmeth,PPRowId);
			DHCC_SetElementData('CreateDepartmentID',CreateDepartmentID);
		}
		document.getElementById("PilotProject").readOnly=true;
	}else{
		var obj=document.getElementById('PilotProject');
		if (obj)obj.onchange=PilotProjectChangeHander;
	}
	
	LoadStartUser();*/
}
function init(){
	loadstatus()
	var PPRowId=DHCC_GetElementData('PPRowId');
	if (PPRowId=="") return false;
		var ret=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","GetProjectByID",PPRowId);
	if (ret=="") return;
	 var arr=ret.split("^")
	var StatusDr=arr[21]
	var Status=arr[22]
	DHCC_SetElementData('Status',Status);
	DHCC_SetElementData('StatusDr',StatusDr);
	
}
function loadstatus(){
	//Normal,Abort��ͣ,Strike��ֹ,Verify����,UnApprovedδ��׼,InApprove������,Finish�����,Hangδ���У�Break��ֹ,
	var Status=DHCC_GetElementData('Status');
	if (document.getElementById('Status')){
		var Dem=String.fromCharCode(1)
	
		var StatusStr="N"+Dem+"����^H"+Dem+"δ����^V"+Dem+"����^P"+Dem+"����������^F"+Dem+"�����^A"+Dem+"��ͣ^S"+Dem+"��ֹ^B"+Dem+"��ֹ^I"+Dem+"������^D"+Dem+"�ϻ�δͨ��"
		
		combo_Status=dhtmlXComboFromStr("Status",StatusStr);
		myCombAry["Status"]=combo_Status;
		combo_Status.enableFilteringMode(true);
		combo_Status.selectHandle=combo_StatusKeydownhandler;
		combo_Status.setComboText(Status)
	}
}
function combo_StatusKeydownhandler(){
	var StatusRowId=combo_Status.getSelectedValue();
	DHCC_SetElementData('StatusDr',StatusRowId);	
}
function AbortClick(){
	var status="A";
	var ret=ChangeStatus(status);
	if (ret=="0"){
		alert("��ͣ�ɹ�!");
	}
}
function AbortResumeClick(){
	var status="N";
	var ret=ChangeStatus(status);
	if (ret=="0"){
		alert("��ͣ�ָ��ɹ�!");
	}
}
function StrikeClick(){
	var status="S";
	var ret=ChangeStatus(status);
	if (ret=="0"){
		alert("��ֹ�ɹ�!");
	}
}
function ChangeStatus(status){
	var ret=CheckData();
	if (ret==false)return;
	var ret="";
	var PPRowId=DHCC_GetElementData('PPRowId');
	var AuthUserRowId=DHCC_GetElementData('AuthUserRowId');
	var UpdateReason=DHCC_GetElementData('UpdateReason');
	var UserRowId=session['LOGON.USERID'];
	var encmeth=DHCC_GetElementData('StatusChangeMethod');
	if (encmeth!=""){
		var Para=PPRowId+"^"+AuthUserRowId+"^"+UpdateReason+"^"+UserRowId;
		var ret=cspRunServerMethod(encmeth,Para,status);
	}
	
	return ret;
}
function CheckData(){
	var PPRowId=DHCC_GetElementData('PPRowId');
	var AuthUserRowId=DHCC_GetElementData('AuthUserRowId');
	var UpdateReason=DHCC_GetElementData('UpdateReason');
	if (PPRowId==""){
		alert("��������Ŀ!");
		return false;
	}
	if (AuthUserRowId==""){
		alert("��������׼��!");
		return false;
	}
	if (UpdateReason==""){
		alert("�ı�ԭ����Ϊ��!");
		return false;
	}
	return true;
}
function LoadStartUser(){
	var AuthUser=DHCC_GetElementData('AuthUser');
	if (document.getElementById('AuthUser')){
		var AuthUserStr=getAuthUserStr();
		combo_AuthUser=dhtmlXComboFromStr("AuthUser",AuthUserStr);
		//myCombAry["PPStartUser"]=combo_AuthUser;
		combo_AuthUser.enableFilteringMode(true);
		combo_AuthUser.selectHandle=combo_AuthUserKeydownhandler;
		combo_AuthUser.setComboText(AuthUser)
	}
}
function combo_AuthUserKeydownhandler(){
	var AuthUserRowId=combo_AuthUser.getSelectedValue();
	DHCC_SetElementData('AuthUserRowId',AuthUserRowId);
}
function PilotProjectChangeHander(){
	//����ǲ�������Ķ���ѡ����Ŀ��ҳ��
}
function getAuthUserStr(){
	var encmeth=DHCC_GetElementData("AuthUserStr");
	if (encmeth!=""){
		var CreateDepartmentID=DHCC_GetElementData('CreateDepartmentID');
		var retStr=cspRunServerMethod(encmeth,CreateDepartmentID);
		return retStr;
	}
	return "";
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function UpdateClick(){
	var PPRowId=DHCC_GetElementData('PPRowId');
	var StatusDr=DHCC_GetElementData('StatusDr');
	var encmeth=DHCC_GetElementData('StatusChangeMethod');
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,PPRowId,StatusDr);
	}
	if (ret==0){
		alert("�޸ĳɹ�")
	}
	else{
		alert("�޸�ʧ�ܣ�")
	}
	window.location.reload();
}