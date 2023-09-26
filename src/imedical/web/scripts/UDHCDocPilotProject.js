///  UDHCDocPilotProject.js
document.body.onload = BodyLoadHandler;
var SelectedRow=0;
var m_PilotExpression="";
var m_SuperDepRowId="";
var m_PilotProReg="";
var m_PilotProSubCatStr="";
var m_ProCodeLenght="";
var m_AutoProCode="0";
var myCombAry=new Array();
function BodyLoadHandler(){
	//
	//PrintECAPPRRecord(30)
	//PrintZXLCAPPRRecord(30)
	var obj=document.getElementById("PPCode");
	if (obj) obj.onblur=PPCodeBlurHander;
	var obj=document.getElementById("Create");
	if (obj) obj.onclick=CreateClickHander;
	var obj=document.getElementById("Clear");
	if (obj) obj.onclick=ClearClickHander;
	var obj=document.getElementById("JoinUser");
	if (obj) obj.onclick=JoinUserClickHander;
	var obj=document.getElementById("ChangeState");
	if (obj) obj.onclick=ChangeStateClickBlurHander;
	var obj=document.getElementById("RemRecord");
	if (obj) obj.onclick=RemRecordClickBlurHander;
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateClickHander;
	var obj=document.getElementById("PrintPJ");
	if (obj) obj.onclick=PrintPJClickHander;
	var obj=document.getElementById("BtnPrintYXB");
	if (obj) obj.onclick=BtnPrintYXBClickHander;
	var obj=document.getElementById("OtherDep");
	if (obj) obj.onclick=OtherDepClickHander;
	var obj=document.getElementById('PPStartUser');
	if(obj) obj.onchange=PPStartUserChangeHandler;
	var obj=document.getElementById("PPStartUser"); 
	if (obj) 
	{	
		obj.onkeydown=PPStartUserClinic;
	 	
	} 
	
	///document.onkeydown=Doc_OnKeyDown;
	LoadDepartment();
	//LoadStartUser();
    //LoadIndication();
    LoadPilotCategory();
    LoadSubPilotCategory();
    //LoadEthicsFilesNextState();
   // LoadEthicsFilesState();
    //LoadProjectFilesState();
    LoadIsHeadman();
    LoadApplyMatter();
    loadApplyStage();
	//InitTextItem();
	//IntListItem();
	GetConfig();
	Init()
	var PilotCategoryRowId=combo_PilotCategory.getSelectedValue();
	var GetSubPilotCategoryStr=DHCC_GetElementData("GetSubPilotCategoryStr")
	if (GetSubPilotCategoryStr!=""){
		var SubPilotCategoryStr=cspRunServerMethod(GetSubPilotCategoryStr,PilotCategoryRowId);
		if (SubPilotCategoryStr!=""){
			var Arr=DHCC_StrToArray(SubPilotCategoryStr);
			myCombAry["SubPilotCategory"].clearAll();
			myCombAry["SubPilotCategory"].addOption(Arr);
		}
	}	
	
}
function Init(){
	
	var Flag=DHCC_GetElementData("Flag");
	var PPRowId=DHCC_GetElementData("PPRowId");
	if (Flag=="Other"){
		var obj=document.getElementById("Create")
		if(obj) obj.style.visibility="hidden"
	
	}else{
		var obj=document.getElementById("Update")
		if(obj) obj.style.visibility="hidden"
		var obj=document.getElementById("BtnPrintYXB")
		if(obj) obj.style.visibility="hidden"
		var obj=document.getElementById("PPRemark")
		if(obj) obj.style.visibility="hidden"
		var obj=document.getElementById("cPPRemark")
		if(obj) obj.style.visibility="hidden"
	
	}
	var ArchivesFilesNoSt=DHCC_GetElementData("ArchivesFilesNoStart");
	if (ArchivesFilesNoSt!=0){
		var obj=document.getElementById("ArchivesFilesNo")
		if(obj) obj.style.visibility="hidden"
		var obj=document.getElementById("cArchivesFilesNo")
		if(obj) obj.style.visibility="hidden"
	}
	
	if (Flag=="Other" && PPRowId!=""){
	
		var encmeth=DHCC_GetElementData("GetProjectInfoByID");
		if (encmeth!=""){
			var myXml=cspRunServerMethod(encmeth,PPRowId);
			if (myXml!=""){
				 //ClearClickHander();
				 SetProInfoByXML(myXml);
				}
		}
	}
	
	if (m_AutoProCode=="1") {
		var obj=document.getElementById("PPCode")
		if(obj) obj.style.visibility="hidden"
		var obj=document.getElementById("cPPCode")
		if(obj) obj.style.visibility="hidden"
	}else{
		var obj=document.getElementById("PPCode")
		if(obj) obj.style.visibility=""
		var obj=document.getElementById("cPPCode")
		if(obj) obj.style.visibility=""
	}
}
function LookUpPPStartUser(value){
	var obj=document.getElementById('PPStartUserDr');
	var tem=value.split("^");
	obj.value=tem[1];
	
}
function PPStartUserChangeHandler(){
	var obj=document.getElementById('PPStartUser');
	if (obj.value==""){
		var obj=document.getElementById('PPStartUserDr');
		obj.value=""
	}
}
function PPStartUserClinic(){
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  PPStartUser_lookuphandler();
	}
}
function GetConfig(){
	var encmeth=DHCC_GetElementData("GetConfigEncrypt");
	if (encmeth!=""){
		var myrtnStr=cspRunServerMethod(encmeth);
		var myAry=myrtnStr.split("^");
		m_PilotExpression=myAry[0];
		m_SuperDepRowId=myAry[1];
		m_PilotProReg=myAry[2];
		m_PilotProSubCatStr=myAry[3];
		m_ProCodeLenght=myAry[4];
		m_AutoProCode=myAry[9];
	}
}
function LoadDepartment(){
	var PPCreateDepartmentName=DHCC_GetElementData('PPCreateDepartment');
	if (document.getElementById('PPCreateDepartment')){
		var DepStr=DHCC_GetElementData('DepStr');
		combo_Dep=dhtmlXComboFromStr("PPCreateDepartment",DepStr);
		myCombAry["PPCreateDepartment"]=combo_Dep;
		combo_Dep.enableFilteringMode(true);
		var obj=document.getElementById('PPCreateDepartment')
		obj.onchange=combo_LocationChangehandler;
		combo_Dep.selectHandle=combo_LocationKeydownhandler;
		combo_Dep.setComboText(PPCreateDepartmentName)
	}
}
function combo_LocationChangehandler(){
	var PPCreateDepartment=document.getElementById('PPCreateDepartment').value
	if(PPCreateDepartment=="")  DHCC_SetElementData('PPCreateDepartmentDr',"");
}
function LoadStartUser(){
	var PPStartUser=DHCC_GetElementData('PPStartUser');
	if (document.getElementById('PPStartUser')){
		var StartUsrStr=DHCC_GetElementData('StartUsrStr');
		combo_StartUser=dhtmlXComboFromStr("PPStartUser",StartUsrStr);
		myCombAry["PPStartUser"]=combo_StartUser;
		combo_StartUser.enableFilteringMode(true);
		combo_StartUser.selectHandle=combo_StartUserKeydownhandler;
		combo_StartUser.setComboText(PPStartUser)
	}
}
function LoadIndication(){
	var Indication=DHCC_GetElementData('Indication');
	if (document.getElementById('Indication')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var IndicationStr=cspRunServerMethod(encmeth,"科研药理","适应症")
		combo_Indication=dhtmlXComboFromStr("Indication",IndicationStr);
		myCombAry["Indication"]=combo_Indication;
		combo_Indication.enableFilteringMode(true);
		combo_Indication.selectHandle=combo_IndicationKeydownhandler;
		combo_Indication.setComboText(Indication)
		}
	}
}

function LoadPilotCategory(){
	var PilotCategory=DHCC_GetElementData('PilotCategory');
	if (document.getElementById('PilotCategory')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var PilotCategoryStr=cspRunServerMethod(encmeth,"科研药理","类别")
		combo_PilotCategory=dhtmlXComboFromStr("PilotCategory",PilotCategoryStr);
		myCombAry["PilotCategory"]=combo_PilotCategory;
		combo_PilotCategory.enableFilteringMode(true);
		combo_PilotCategory.selectHandle=combo_PilotCategoryKeydownhandler;
		combo_PilotCategory.setComboText(PilotCategory)
		}
	}
	
}
function LoadSubPilotCategory(){
	var SubPilotCategory=DHCC_GetElementData('SubPilotCategory');
	if (document.getElementById('SubPilotCategory')){
		var SubPilotCategoryStr=DHCC_GetElementData('SubPilotCategory');
		combo_SubPilotCategory=dhtmlXComboFromStr("SubPilotCategory",SubPilotCategoryStr);
		myCombAry["SubPilotCategory"]=combo_SubPilotCategory;
		combo_SubPilotCategory.enableFilteringMode(true);
		combo_SubPilotCategory.selectHandle=combo_SubPilotCategoryKeydownhandler;
		combo_SubPilotCategory.setComboText(SubPilotCategory)
	}

}
function LoadEthicsFilesNextState(){
	var EthicsFilesNextState=DHCC_GetElementData('EthicsFilesNextState');
	if (document.getElementById('EthicsFilesNextState')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var EthicsFilesNextStateStr=cspRunServerMethod(encmeth,"科研药理","伦理资料去向")
		combo_EthicsFilesNextState=dhtmlXComboFromStr("EthicsFilesNextState",EthicsFilesNextStateStr);
		myCombAry["EthicsFilesNextState"]=combo_EthicsFilesNextState;
		combo_EthicsFilesNextState.enableFilteringMode(true);
		combo_EthicsFilesNextState.selectHandle=combo_EthicsFilesNextStateKeydownhandler;
		combo_EthicsFilesNextState.setComboText(EthicsFilesNextState)
		}
	}
}
function LoadEthicsFilesState(){
	var EthicsFilesState=DHCC_GetElementData('EthicsFilesState');
	if (document.getElementById('EthicsFilesState')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var EthicsFilesStateStr=cspRunServerMethod(encmeth,"科研药理","伦理委员会档案情况")
		combo_EthicsFilesState=dhtmlXComboFromStr("EthicsFilesState",EthicsFilesStateStr);
		myCombAry["EthicsFilesState"]=EthicsFilesState;
		combo_EthicsFilesState.enableFilteringMode(true);
		combo_EthicsFilesState.selectHandle=combo_EthicsFilesStateKeydownhandler;
		combo_EthicsFilesState.setComboText(EthicsFilesState)
		}
	}
}
//LoadProjectFilesState();
function LoadProjectFilesState(){
	var ProjectFilesState=DHCC_GetElementData('ProjectFilesState');
	if (document.getElementById('ProjectFilesState')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var ProjectFilesStateStr=cspRunServerMethod(encmeth,"科研药理","试验资料情况")
		combo_ProjectFilesState=dhtmlXComboFromStr("ProjectFilesState",ProjectFilesStateStr);
		myCombAry["ProjectFilesState"]=combo_ProjectFilesState;
		combo_ProjectFilesState.enableFilteringMode(true);
		combo_ProjectFilesState.selectHandle=combo_ProjectFilesStateKeydownhandler;
		combo_ProjectFilesState.setComboText(ProjectFilesState)
		}
	}
}
//IsHeadman
function LoadIsHeadman(){
	var IsHeadman=DHCC_GetElementData('IsHeadman');
	if (document.getElementById('IsHeadman')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var IsHeadmanStr=cspRunServerMethod(encmeth,"科研药理","是否是组长")
		combo_IsHeadman=dhtmlXComboFromStr("IsHeadman",IsHeadmanStr);
		myCombAry["IsHeadman"]=combo_IsHeadman;
		combo_IsHeadman.enableFilteringMode(true);
		combo_IsHeadman.selectHandle=combo_IsHeadmanKeydownhandler;
		combo_IsHeadman.setComboText(IsHeadman)
		}
	}
}
//ApplyMatter
function LoadApplyMatter(){
	var ApplyMatter=DHCC_GetElementData('ApplyMatter');
	if (document.getElementById('ApplyMatter')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var ApplyMatterStr=cspRunServerMethod(encmeth,"科研药理","申请事项")
		combo_ApplyMatter=dhtmlXComboFromStr("ApplyMatter",ApplyMatterStr);
		myCombAry["ApplyMatter"]=combo_ApplyMatter;
		combo_ApplyMatter.enableFilteringMode(true);
		combo_ApplyMatter.selectHandle=combo_ApplyMatterKeydownhandler;
		combo_ApplyMatter.setComboText(ApplyMatter)
		}
	}
}
//ApplyStage
function loadApplyStage(){
	var ApplyStage=DHCC_GetElementData('ApplyStage');
	if (document.getElementById('ApplyStage')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
		var encmeth=GetDefineDataStr.value
		var ApplyStageStr=cspRunServerMethod(encmeth,"科研药理","申请期")
		combo_ApplyStage=dhtmlXComboFromStr("ApplyStage",ApplyStageStr);
		myCombAry["ApplyStage"]=combo_ApplyStage;
		combo_ApplyStage.enableFilteringMode(true);
		combo_ApplyStage.selectHandle=combo_ApplyStageKeydownhandler;
		combo_ApplyStage.setComboText(ApplyStage)
		}
	}
}
function combo_LocationKeydownhandler(){
	var DepRowId=combo_Dep.getSelectedValue();
	DHCC_SetElementData('PPCreateDepartmentDr',DepRowId);
	
}
function combo_StartUserKeydownhandler(){
	var StartUserRowId=combo_StartUser.getSelectedValue();
	DHCC_SetElementData('PPStartUserDr',StartUserRowId);
}
function combo_IndicationKeydownhandler(){
	var IndicationRowId=combo_Indication.getSelectedValue();
	DHCC_SetElementData('IndicationDr',IndicationRowId);
}
function combo_PilotCategoryKeydownhandler(){
	var PilotCategoryRowId=combo_PilotCategory.getSelectedValue();
	DHCC_SetElementData('PilotCategoryDr',PilotCategoryRowId);
	var GetSubPilotCategoryStr=DHCC_GetElementData("GetSubPilotCategoryStr")
	if (GetSubPilotCategoryStr!=""){
		var SubPilotCategoryStr=cspRunServerMethod(GetSubPilotCategoryStr,PilotCategoryRowId);
		if (SubPilotCategoryStr!=""){
			var Arr=DHCC_StrToArray(SubPilotCategoryStr);
			myCombAry["SubPilotCategory"].clearAll();
			myCombAry["SubPilotCategory"].addOption(Arr);
		}
	}
	DHCC_SetElementData('SubPilotCategory',"");
	DHCC_SetElementData('SubPilotCategoryDr',"");
		
}
function combo_SubPilotCategoryKeydownhandler(){
	var SubPilotCategoryRowId=combo_SubPilotCategory.getSelectedValue();
	DHCC_SetElementData('SubPilotCategoryDr',SubPilotCategoryRowId);	
}
function combo_EthicsFilesNextStateKeydownhandler(){
	var EthicsFilesNextStateRowId=combo_EthicsFilesNextState.getSelectedValue();
	DHCC_SetElementData('EthicsFilesNextStateDr',EthicsFilesNextStateRowId);
}
function combo_EthicsFilesStateKeydownhandler(){
	var EthicsFilesStateRowId=combo_EthicsFilesState.getSelectedValue();
	DHCC_SetElementData('EthicsFilesStateDr',EthicsFilesStateRowId);
	}
//ProjectFilesState
function combo_ProjectFilesStateKeydownhandler(){
var ProjectFilesStateRowId=combo_ProjectFilesState.getSelectedValue();
DHCC_SetElementData('ProjectFilesStateDr',ProjectFilesStateRowId);
}
//IsHeadman
function combo_IsHeadmanKeydownhandler(){
var IsHeadmanRowId=combo_IsHeadman.getSelectedValue();
DHCC_SetElementData('IsHeadmanDr',IsHeadmanRowId);
}
//ApplyMatter
function combo_ApplyMatterKeydownhandler(){
var ApplyMatterRowId=combo_ApplyMatter.getSelectedValue();
DHCC_SetElementData('ApplyMatterDr',ApplyMatterRowId);
}
//ApplyStage
function combo_ApplyStageKeydownhandler(){
var ApplyStageRowId=combo_ApplyStage.getSelectedValue();
DHCC_SetElementData('ApplyStageDr',ApplyStageRowId);
}
function IntListItem()
{
	var myCount=m_ListItemName.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		var myobj=document.getElementById(m_LookUpTextItemName[myIdx]);
 		if ((myobj)){
			myobj.onkeydown = nextfocus;
			myobj.size=1;
			myobj.multiple=false;
			if ((myobj.length>0)&&(myobj.selectedIndex=-1)){
				myobj.selectedIndex=0;
			}
		}
	}
}

///Init Text Type Operate
function InitTextItem()
{
	try{
		var myCount=m_TextItemName.length;
		for (var myIdx=0;myIdx<myCount;myIdx++){
			//if ((m_TextItemName[myIdx]!="PPCreateDepartment")&&(m_TextItemName[myIdx]!="PPStartUser")){
			if (!myCombAry[m_TextItemName[myIdx]]){
				var myobj=document.getElementById(m_TextItemName[myIdx]);
				if (myobj){
					myobj.onkeydown = nextfocus;
				}
			}
		}
	}catch(E){
		alert(E.message);
		return;
	}
}
function Doc_OnKeyDown(){
	//alert(event.keyCode);
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	
	if (key==13) {
	}
}
function nextfocus() {
	var eSrc=window.event.srcElement;
	//alert(eSrc.tabIndex);
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
}
function PPCodeBlurHander(){
	var obj=document.getElementById("PPCode");
	if(obj.value!=""){
		if((m_ProCodeLenght!="")&&(obj.value.length!=m_ProCodeLenght)){
			alert("项目代码长度应为:"+m_ProCodeLenght+"位");
			websys_setfocus("PPCode");
			return false;
		}
		var encmeth=DHCC_GetElementData("CheckPPCodeRlue");
		var myrtn=cspRunServerMethod(encmeth,obj.value);
		var myArray=myrtn.split("^");
		if (myArray[0]!="0"){
			alert(myArray[1]);
			return false;
		}
	}
	
}
function UpdateClickHander(){
	
	UpdateDataToServer();
}
function UpdateDataToServer(){
	try{
		var myProjecctInfo=getProjecctInfo();
		//alert(myProjecctInfo)
		var PPRowId=DHCC_GetElementData("PPRowId");
		if (PPRowId==""){
			alert("请选择一行")
			return false;
		}
		var encmeth=DHCC_GetElementData("UpdateMethod");
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth, myProjecctInfo, PPRowId);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				alert("修改成功!");
				var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProject&PPRowId="+PPRowId+"&Flag=Other";
				//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProject";
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
function CreateClickHander(){
	//PrintECAPPRRecord(67)
	var myrtn=CheckBeforeSave();
	if (myrtn==false){
		//alert()
		return;
	}
	
	SaveDataToServer();
	
}
function CheckBeforeSave(){
	var Obj=document.getElementById("PPCode");
	if (Obj){
		var PPCode=DHCC_GetElementData("PPCode");
		if ((m_AutoProCode!=1)&&(PPCode=="")){alert("请录入项目编码");return false;}
		if (PPCode!=""){
			var CheckBlur=PPCodeBlurHander();
			if (CheckBlur==false){
			return false;
			}
		}
		PPCode=PPCode.replace(/(^\s*)|(\s*$)/g,'');
	}
	var ArchivesFilesNo=DHCC_GetElementData("ArchivesFilesNo");
	var ArchivesFilesNoSt=DHCC_GetElementData("ArchivesFilesNoStart");
	var ArchivesFilesNoSt=ArchivesFilesNoSt.replace(/(^\s*)|(\s*$)/g,'');
	if ((ArchivesFilesNoSt==0)&&(ArchivesFilesNo=="")){alert("档案文件夹编号不能为空");return false; }
	
	var PPDesc=DHCC_GetElementData("PPDesc");
	if (PPDesc==""){
		alert("药物/医疗器械名称不能为空.");
		websys_setfocus("PPDesc")
		return false;
	}
	var PlanNo=DHCC_GetElementData("PlanNo");
	if (PlanNo==""){
		alert("方案编号不能为空.");
		websys_setfocus("PlanNo")
		return false;
	}
	var PlanName=DHCC_GetElementData("PlanName");
	if (PlanName==""){
		alert("方案名称不能为空.");
		websys_setfocus("PlanName")
		return false;
	}
	var ApplicationUnit=DHCC_GetElementData("ApplicationUnit");
	if (ApplicationUnit==""){
		alert("申请人不能为空.");
		websys_setfocus("ApplicationUnit")
		return false;
	}
	var ApplicationUnit=DHCC_GetElementData("ApplicationUnit");
	if (ApplicationUnit==""){
		alert("申请人不能为空.");
		websys_setfocus("ApplicationUnit")
		return false;
	}
	var PilotCategoryDr=DHCC_GetElementData("PilotCategoryDr");
	if (PilotCategoryDr==""){
		alert("类别不能为空.");
		websys_setfocus("PilotCategoryDr")
		return false;
	}
	var ApprovalNo=DHCC_GetElementData("ApprovalNo");
	if (ApprovalNo==""){
		alert("批件号不能为空.");
		websys_setfocus("ApprovalNo")
		return false;
	}
	var ApplyMatterDr=DHCC_GetElementData("ApplyMatterDr");
	if (ApplyMatterDr==""){
		alert("申请事项不能为空.");
		websys_setfocus("ApplyMatterDr")
		return false;
	}
	var ApplyStageDr=DHCC_GetElementData("ApplyStageDr");
	if (ApplyStageDr==""){
		alert("申请期不能为空.");
		websys_setfocus("ApplyStageDr")
		return false;
	}
	var IsHeadmanDr=DHCC_GetElementData("IsHeadmanDr");
	if (IsHeadmanDr==""){
		alert("多研究中心状态不能为空.");
		websys_setfocus("IsHeadmanDr")
		return false;
	}
	var PPCreateDepartmentDr=DHCC_GetElementData("PPCreateDepartmentDr");
	if (PPCreateDepartmentDr==""){
		alert("立项科室不能为空.");
		websys_setfocus("PPCreateDepartmentDr")
		return false;
	}
	var PPStartUserDr=DHCC_GetElementData("PPStartUserDr");
	if (PPStartUserDr==""){
		alert("主要研究者不能为空.");
		websys_setfocus("PPStartUserDr")
		return false;
	}
	var ArchivesFilesNo=DHCC_GetElementData("ArchivesFilesNo");
	if (ArchivesFilesNo==""){
		//alert("档案文件夹编号不能为空.");
		//websys_setfocus("ArchivesFilesNo")
		//return false;
	}
}
function SaveDataToServer(){
	try{
		//var PPCode=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","GetMaxCodeNo");
		//DHCC_SetElementData('PPCode',PPCode);
		var myProjecctInfo=getProjecctInfo();
		var myExpStr="";
		var OtherDepStr=DHCC_GetElementData("OtherDepStr")
		var encmeth=DHCC_GetElementData("CreateMethod");
		if (encmeth!=""){
			
			var rtn=cspRunServerMethod(encmeth, myProjecctInfo, myExpStr,OtherDepStr);
			var myArray=rtn.split("^");
			if (myArray[0]=='0')
			{
				alert("立项成功!");
				 var check=confirm("是否打印预审表?",false)
    			if(check==true) {
	    			var ret=ShowMessage("伦理委员会审批记录","临床药理中心审批记录","全部","<br>","","");
					if ((ret==null)){
						//return false;
					}
					if (ret==1) {PrintECAPPRRecord(myArray[1])}
					if (ret==2) {PrintZXLCAPPRRecord(myArray[1]);}
					if (ret==3){
						PrintECAPPRRecord(myArray[1]);
		   				PrintZXLCAPPRRecord(myArray[1]);
		   			}
					//PrintECAPPRRecord(myArray[1]);
					//PrintZXLCAPPRRecord(myArray[1]);
    			}
				var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProject";
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
function getProjecctInfo(){
	var myxml="";
	var myparseinfo = DHCC_GetElementData("InitProjectEntity");
	var myxml=GetEntityClassInfoToXML(myparseinfo)

	return myxml;
}
function ClearClickHander(){
	try{
		var myCount=m_TextItemName.length;
		for (var myIdx=0;myIdx<myCount;myIdx++){
			if (myCombAry.indexOf(m_TextItemName[myIdx])==-1){
				var myobj=document.getElementById(m_TextItemName[myIdx]);
				if (myobj){
					myobj.value = "";
				}else{
					ClearComb();
				}
			}
		}
	}catch(E){
		alert(E.message);
		return;
	}
}
function ClearComb(){
	myCombAry["PPCreateDepartment"].setComboText("");
	myCombAry["PPStartUser"].setComboValue("");
	myCombAry["Indication"].setComboValue("")
}
function JoinUserClickHander(){
	if (SelectedRow==0){
		alert("请先选择项目!");
		return;
	}
	var PPRowId=DHCC_GetColumnData('TPPRowId',SelectedRow);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProCare&PPRowId="+PPRowId;
	win=window.open(lnk,"JoinUser","status=1,scrollbars=1,top=100,left=100,width=760,height=680");	
}
function ChangeStateClickBlurHander(){
	
	var PPRowId=DHCC_GetElementData("PPRowId");
	if (PPRowId==0){
		alert("请先选择项目!");
		return;
	}
	//alert(PPRowId)
	var PPDesc=DHCC_GetElementData("PPDesc");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProState&PPRowId="+PPRowId+"&PilotProject="+PPDesc;
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProState&PPRowId="+PPRowId;
	win=window.open(lnk,"ChangeState","status=1,scrollbars=1,top=100,left=100,width=760,height=600");	
}
function RemRecordClickBlurHander(){
	if (SelectedRow==0){
		alert("请先选择项目!");
		return;
	}
	var PPRowId=DHCC_GetColumnData('TPPRowId',SelectedRow);
	var PPDesc=DHCC_GetColumnData('TPPDesc',SelectedRow);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProRem&PPRowId="+PPRowId+"&PilotProject="+PPDesc;
	win=window.open(lnk,"RemRecord","status=1,scrollbars=1,top=100,left=100,width=760,height=600");	
}
function OtherDepClickHander(){
	
	var PPRowId=DHCC_GetElementData("PPRowId");
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProDept&PPRowId="+PPRowId;
	win=window.open(lnk,"OtherDep","status=1,scrollbars=1,top=100,left=100,width=600,height=600");
	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tUDHCDocPilotProject');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if ((SelectedRow!=0)&&(selectrow==SelectedRow)){
		ClearClickHander();
		SelectedRow=0;
		return;
	}
	var TPPRowId=DHCC_GetColumnData('TPPRowId',selectrow);

	var encmeth=DHCC_GetElementData("GetProjectInfoByID");
	if (encmeth!=""){
		var myXml=cspRunServerMethod(encmeth,TPPRowId);
		if (myXml!=""){
			 ClearClickHander();
			 SetProInfoByXML(myXml);
			}
	}
	
	SelectedRow = selectrow;
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

//预审表-中心临床试验审批记录表打印
function PrintZXLCAPPRRecord(PPRowId){
	var TemplatePath
	var getpath=document.getElementById('printpath');
	     if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	     TemplatePath=cspRunServerMethod(encmeth,'','')
        var ApplicationUnit,PPDesc,PilotCategory,ApplyStage,ApplyMatter,PlanName,ArchivesFilesNo,ApplyContact,ApplyContactTel,PPStartUser
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        var xlApp,xlsheet,xlBook
	    TemplatePath=TemplatePath+"DHCDOCZXLCAPPRECORD.xlsx";
	    xlApp = new ActiveXObject("Excel.Application");
	     xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  
	    xlsheet.PageSetup.RightMargin=0;
	     var ret=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","GetProjectByID",PPRowId);
	     if (ret!=""){
		   var arr=ret.split("^")
		   var PPCode=arr[1]
		   var PPDesc=arr[2]
		   var PlanName=arr[4]
		   var ApplicationUnit=arr[5]
		   var PPCreateDepartment=arr[6]
		   var PPStartUser=arr[7]
		   var PilotCategory=arr[8]
		   var ApplyMatter=arr[9]
		   var ApprovalNo=arr[10]
		   var ApplyStage=arr[11]
		   var ApplyContact=arr[12]
		   var ApplyContactTel=arr[13]
		   var SubPilotCategory=arr[15]
		   if (SubPilotCategory!=""){
			   PilotCategory=SubPilotCategory
		   }
	   }
	
	       xlsheet.cells(3,3)=ApplicationUnit;
	      xlsheet.cells(3,8)=ApplyContact+" "+ApplyContactTel;
	    
	    xlsheet.cells(4,3)=PPDesc;
	    
		xlsheet.cells(4,5)=PilotCategory;
	       
		xlsheet.cells(4,7)=ApplyMatter+ApplyStage;
		  
		xlsheet.cells(4,9)=PPStartUser;
	         xlsheet.cells(5,3)=PlanName;
	    var HospName=document.getElementById("HospName").value;
	    if (HospName!="") xlsheet.cells(1,2)=HospName+"临床药理研究中心";
	         //var obj=document.getElementById("ArchivesFilesNo");
	   // if (obj){
		    //var ArchivesFilesNo=obj.value;
	         //}
	         //xlsheet.cells(5,8)=ArchivesFilesNo;
	    xlsheet.printout;
	   xlBook.Close (savechanges=false);
	   xlApp.Quit();
	   xlApp=null;
	   xlsheet=null;
	
}
//预审表-EC临床试验审批记录表打印
function PrintECAPPRRecord(PPRowId){
		var TemplatePath
	var getpath=document.getElementById('printpath');
	     if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	     TemplatePath=cspRunServerMethod(encmeth,'','')
        var ApplicationUnit,PPDesc,PilotCategory,ApplyStage,ApplyMatter,PlanName,ArchivesFilesNo,ApplyContact,ApplyContactTel,PPStartUser
        var myTotlNum=0;
        var CashNUM=0;
        var myencmeth="";
        var xlApp,xlsheet,xlBook
	    TemplatePath=TemplatePath+"DHCDOCETHICSAPPRRECORD.xlsx";
	    xlApp = new ActiveXObject("Excel.Application");
	     xlBook = xlApp.Workbooks.Add(TemplatePath);
	    
	    xlsheet = xlBook.ActiveSheet;
	    xlsheet.PageSetup.LeftMargin=0;  
	    xlsheet.PageSetup.RightMargin=0;
	     var ret=tkMakeServerCall("web.PilotProject.DHCDocPilotProject","GetProjectByID",PPRowId);
	     if (ret!=""){
		   var arr=ret.split("^")
		   var PPCode=arr[1]
		   var PPDesc=arr[2]
		   var PlanName=arr[4]
		   var ApplicationUnit=arr[5]
		   var PPCreateDepartment=arr[6]
		   var PPStartUser=arr[7]
		   var PilotCategory=arr[8]
		   var ApplyMatter=arr[9]
		   var ApprovalNo=arr[10]
		   var ApplyStage=arr[11]
		   var ApplyContact=arr[12]
		   var ApplyContactTel=arr[13]
		   var SubPilotCategory=arr[15]
		   if (SubPilotCategory!=""){
			   PilotCategory=SubPilotCategory
		   }
	   }
	    xlsheet.cells(3,3)=ApplicationUnit;
	    xlsheet.cells(4,3)=PPDesc;

		xlsheet.cells(4,6)=PilotCategory;
		xlsheet.cells(4,8)=ApplyMatter+ApplyStage
	    xlsheet.cells(5,3)=PlanName;
	      xlsheet.cells(3,9)=ApplyContact+" "+ApplyContactTel;
	
		xlsheet.cells(4,10)=PPStartUser;
	    var HospName=document.getElementById("HospName").value;
	    if (HospName!="") xlsheet.cells(1,2)=HospName+"药物临床试验伦理委员会";
	        // var obj=document.getElementById("ArchivesFilesNo");
	    //if (obj){
		  // var ArchivesFilesNo=obj.value;
	        // }
	        // xlsheet.cells(5,7)=ArchivesFilesNo;
	    xlsheet.printout;
	   xlBook.Close (savechanges=false);
	   xlApp.Quit();
	   xlApp=null;
	   xlsheet=null;
}
function PrintPJClickHander(){
	if (SelectedRow==0){
		alert("请先选择项目!");
		return;
	}
	var PPRowId=DHCC_GetColumnData('TPPRowId',SelectedRow);
	//alert(PPRowId)
	var PPDesc=DHCC_GetColumnData('TPPDesc',SelectedRow);
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProInsPrint&PPRowId="+PPRowId+"&PilotProject="+PPDesc;
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProState&PPRowId="+PPRowId;
	win=window.open(lnk,"ChangeState","status=1,scrollbars=1,top=300,left=300,width=500,height=300");
	
}
function BtnPrintYXBClickHander(){
	var PPRowId=DHCC_GetElementData("PPRowId");
	if (PPRowId==""){
		alert("请先选择项目!");
		return;
	}
		
	var ret=ShowMessage("伦理委员会审批记录","临床药理中心审批记录","全部","<br>","","");
				if ((ret==null)){return false;}
				
				if (ret==1) {PrintECAPPRRecord(PPRowId)}
				if (ret==2) {PrintZXLCAPPRRecord(PPRowId);}
				if (ret==3){
					PrintECAPPRRecord(PPRowId);
	   				PrintZXLCAPPRRecord(PPRowId);
	   			}
		
}
function ShowMessage(Button1,Button2,Button3,Message,Name,PrescriptTypeStr)
{
	var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCMessageBox&Button1="+Button1+"&Button2="+Button2+"&Button3="+Button3+"&Message="+Message+"&PrescriptTypeStr="+PrescriptTypeStr; 
	var ret=window.showModalDialog(url,Name,"dialogwidth:34em;dialogheight:12em;center:1;status:no");
	//var ret=window.open(url,"test");
	return ret;
}