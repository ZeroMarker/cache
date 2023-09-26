///  UDHCDocPilotProjectFind.js
document.body.onload = BodyLoadHandler;
var SelectedRow=0
var PPRowId=""
var myCombAry=new Array();
function BodyLoadHandler(){
	//;
	//var obj=document.getElementById("BFind");
	//if (obj) obj.onclick=BFindClickHander;
    //var obj=document.getElementById("Print");
	//if (obj) obj.onclick=PrintClickHander;
	LoadDepartment();     //科室
	//LoadStartUser();     //主要研究者
	LoadPilotCategory();  //类别
	LoadIsHeadman();      //多中心状态
    LoadApplyMatter();   //申请事项
    loadApplyStage();    //申请期别
    loadStatus(); //状态
	InitStatus();
	LoadCheckFreq(); //跟踪审查频率 ;add by nk
	//
	//InitTextItem()
	//IntListItem();
	var Flag=DHCC_GetElementData("Flag")
	if ((Flag=="ProApprove")||(Flag=="CPRCApprove")||(Flag=="Sign")||(Flag=="SignModify")){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProPreApprove&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}else if (Flag=="EcApprove"){
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProECApprove&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if (Flag=="ConfirmPay"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProConfirmPay&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if (Flag=="SAE"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProSAE&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if (Flag=="FileManage"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProFileManage&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if (Flag=="Exam"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProDrugExam&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if (Flag=="Settle"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProAllSettle&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="YearCheck"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProYearCheck&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="Other"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProject&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="QCYW"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProQCYW&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="QCDA"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProQCDA&PPRowId=&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="QCZYZ"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProQCZYZ&PPRowId=&Flag="+Flag;
		parent.frames['RPbottom'].document.location.href=lnk;
	}
	var Obj=document.getElementById('PPCode');
	if (Obj) Obj.onkeydown = PPCodeclick;
	var Obj=document.getElementById('Clear');
	if (Obj) Obj.onclick = Clear_OnClick;
	websys_setfocus("PPDesc");
	
}
function Clear_OnClick(){
	ClearComb()
} 
function BFindClickHander(){	
}
function PPCodeclick(e) {
	//这边要与卡处理一致
	if (evtName=='PPCode') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
			var PPCode=document.getElementById('PPCode').value
		if (PPCode=="") return;
		var PPCodeLength=6;
		if ((PPCode.length<PPCodeLength)&&(PPCodeLength!=0)) {
			for (var i=(PPCodeLength-PPCode.length-1); i>=0; i--) {
				PPCode="0"+PPCode;
				//alert(CardNo)
			}
		}
		document.getElementById('PPCode').value=PPCode
		BFind_click()
	}
}
function ClearValue(){
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){
		SelectedRow=0;
		ClearValue()
		return;
	}
	
	selectrow=GetRow(selectrow);
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		PPRowId=DHCC_GetColumnData("TPPRowId",selectrow)
		var encmeth=DHCC_GetElementData("GetProjectInfoByID");
		if (encmeth!=""){
			var myXml=cspRunServerMethod(encmeth,PPRowId);
			if (myXml!=""){
				 ClearClickHander();
				// SetProInfoByXML(myXml);
				}
		}
	
		SelectedRow = selectrow;
		
	}else{
		//alert("2")
		SelectedRow=0;
		PPRowId=""
		ClearClickHander()
	}
	
	RowChanged();
}

function GetRow(Rowindex){
	var objtbl=document.getElementById('tUDHCDocPilotProjectFind');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
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
function ClearClickHander(){
	try{
		ClearComb();
		/*var myCount=m_TextItemName.length;
		for (var myIdx=0;myIdx<myCount;myIdx++){
			if (myCombAry.indexOf(m_TextItemName[myIdx])==-1){
				var myobj=document.getElementById(m_TextItemName[myIdx]);
				if (myobj){
					myobj.value = "";
				}else{
					
				}
			}
		}*/
		
	}catch(E){
		alert(E.message);
		return;
	}
}
function ClearComb(){
	DHCC_SetElementData("PilotCategory","");
	DHCC_SetElementData("PilotCategoryDr","");
	DHCC_SetElementData("ApplyStage","");
	DHCC_SetElementData("ApplyStageDr","");
	DHCC_SetElementData("IsHeadman","");
	DHCC_SetElementData("IsHeadmanDr","");
	DHCC_SetElementData("ApplyMatter","");
	DHCC_SetElementData("ApplyMatterDr","");
	DHCC_SetElementData("ApplyMatterDr","");
	DHCC_SetElementData("PPStartUser","");
	DHCC_SetElementData("PPStartUserDr","");
	DHCC_SetElementData("PPCreateDepartment","");
	DHCC_SetElementData("PPCreateDepartmentDr","");
	DHCC_SetElementData("PPCode","");
	DHCC_SetElementData("PPDesc","");
	DHCC_SetElementData("PlanName","");
	DHCC_SetElementData("PlanNo","");
	DHCC_SetElementData("ApplicationUnit","");
	DHCC_SetElementData("ApprovalNo","");
	DHCC_SetElementData("Indication","");
	DHCC_SetElementData("ApplicationUnit","");
	DHCC_SetElementData("ApplicationUnit","");
	DHCC_SetElementData("ArchivesFilesNo","");
	DHCC_SetElementData("CF","");
	DHCC_SetElementData("CFDr","");
	DHCC_SetElementData("Status","");
	DHCC_SetElementData("StatusID","");
	//myCombAry["PilotCategory"].setComboValue("");
	//myCombAry["PPCreateDepartment"].setComboText("");
	
	//myCombAry["ApplyStage"].setComboValue("")
	//myCombAry["IsHeadman"].setComboValue("")
	//myCombAry["ApplyMatter"].setComboValue("")
	
}
function RowChanged(){
	var Flag=DHCC_GetElementData("Flag")
	var PPDesc=DHCC_GetColumnData("TPPDesc",SelectedRow)
	if ((Flag=="ProApprove")||(Flag=="CPRCApprove")||(Flag=="Sign")||(Flag=="SignModify")){
	var EthicsMeetAduitDate=DHCC_GetColumnData("TEthicsMeetAduitDate",SelectedRow)
	var CPRCApproveResult=DHCC_GetColumnData("TCPRCApproveResult",SelectedRow)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProPreApprove&PPRowId="+PPRowId+"&Flag="+Flag+"&EthicsMeetAduitDate="+EthicsMeetAduitDate+"&CPRCApproveResult="+CPRCApproveResult;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	var ApproveResult=DHCC_GetColumnData("TApproveResult",SelectedRow)
	if (Flag=="EcApprove"){
	if (ApproveResult=="Y")  var PrePass=1  
	else PrePass=0
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProECApprove&PPRowId="+PPRowId+"&PrePass="+PrePass+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="Pay"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProRem&PPRowId="+PPRowId+"&Flag="+Flag+"&PPDesc="+PPDesc;
		parent.frames['RPbottom'].document.location.href=lnk;
		
	}
	else if(Flag=="ConfirmPay"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProConfirmPay&PPRowId="+PPRowId+"&Flag="+Flag;
		parent.frames['RPbottom'].document.location.href=lnk;
		
	}
	else if (Flag=="SAE"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProSAE&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
}
else if (Flag=="FileManage"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProFileManage&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
}
else if (Flag=="Exam"){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProDrugExam&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
}
else if ((Flag=="Settle")&&(PPRowId=="")){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProAllSettle&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
}
else if ((Flag=="Settle")&&(PPRowId!="")){
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProSettle&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
}
else if(Flag=="YearCheck"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProYearCheck&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="Other"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProject&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="QCYW"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProQCYW&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="QCDA"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProQCDA&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}
	else if(Flag=="QCZYZ"){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=UDHCDocPilotProQCZYZ&PPRowId="+PPRowId+"&Flag="+Flag;
	parent.frames['RPbottom'].document.location.href=lnk;
	}

}
function InitStatus()

{
	var Flag=DHCC_GetElementData("Flag")
	var objtbl=document.getElementById('tUDHCDocPilotProjectFind');
	if (!objtbl) objtbl=document.getElementById('tUDHCDocPilotProjectFind0');
	if (objtbl)
	{
		var rows = objtbl.rows;
		for(var i=1;i<rows.length;i++)
		{
			var ApproveResult=DHCC_GetColumnData("TApproveResult",i)
			
			//alert(CDD+"-"+QT+"-"+N+TS)
			if((ApproveResult=="N")){
			rows[i].style.backgroundColor="#BEBEBE"}
				}
		}	
		
}

//add by  nk--start,跟踪审查频率

function LoadCheckFreq(){
	
	var CF=DHCC_GetElementData('CF');
	if (document.getElementById('CF')){
		var GetDefineDataStr=document.getElementById('GetDefineDataStr')
		if(GetDefineDataStr){
			var encmeth=GetDefineDataStr.value
			var CFStr=cspRunServerMethod(encmeth,"科研药理","跟踪审查频率")
			combo_CF=dhtmlXComboFromStr("CF",CFStr);
			myCombAry["CF"]=combo_CF;
			combo_CF.enableFilteringMode(true);
			combo_CF.selectHandle=combo_CFKeydownhandler;
			combo_CF.setComboText(CF)
		}
	}
}

function combo_CFKeydownhandler(){
	var CFRowId=combo_CF.getSelectedValue();
	//alert(CFRowId)
	DHCC_SetElementData('CFDr',CFRowId);
		
}

//----end
	
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
//loadStatus
function loadStatus(){
	var Status=DHCC_GetElementData('Status');
	var Dem=String.fromCharCode(1)
//["","预审未通过"],["I", "审批中"], ["U", "未批准"]["A","暂停"],["S","终止"],["B","中止"]];
	if (document.getElementById('Status')){
		//var StatusStr="V"+Dem+"在研^P"+Dem+"发补后在研^H"+Dem+"未进行^F"+Dem+"已完成^N"+Dem+"立项^C"+Dem+"预审未通过^U"+Dem+"未批准"
		var StatusStr="N"+Dem+"立项^H"+Dem+"未进行^V"+Dem+"在研^P"+Dem+"发补后在研^F"+Dem+"已完成^A"+Dem+"暂停^S"+Dem+"终止^B"+Dem+"中止^I"+Dem+"审批中^D"+Dem+"上会未通过"
		combo_Status=dhtmlXComboFromStr("Status",StatusStr);
		myCombAry["Status"]=combo_Status;
		combo_Status.enableFilteringMode(true);
		combo_Status.selectHandle=combo_StatusKeydownhandler;
		combo_Status.setComboText(Status)
		}
}
function combo_StatusKeydownhandler(){
	var StatusRowId=combo_Status.getSelectedValue();
	DHCC_SetElementData('StatusID',StatusRowId);
}
function combo_LocationChangehandler(){
	var PPCreateDepartment=document.getElementById('PPCreateDepartment').value
	if(PPCreateDepartment=="")  DHCC_SetElementData('PPCreateDepartmentDr',"");
}
function combo_LocationKeydownhandler(){
	var DepRowId=combo_Dep.getSelectedValue();
	DHCC_SetElementData('PPCreateDepartmentDr',DepRowId);
	/*var StartUsrStrMethod=DHCC_GetElementData("GetStartUsrStrMethod")
	if (StartUsrStrMethod!=""){
		var DocStr=cspRunServerMethod(StartUsrStrMethod,DepRowId);
		if (DocStr!=""){
			var Arr=DHCC_StrToArray(DocStr);
			myCombAry["PPStartUser"].clearAll();
			myCombAry["PPStartUser"].addOption(Arr);
		}
	}*/
}
function combo_StartUserKeydownhandler(){
	var StartUserRowId=combo_StartUser.getSelectedValue();
	DHCC_SetElementData('PPStartUserDr',StartUserRowId);
}
function combo_PilotCategoryKeydownhandler(){
	var PilotCategoryRowId=combo_PilotCategory.getSelectedValue();
	DHCC_SetElementData('PilotCategoryDr',PilotCategoryRowId);	
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
function LookUpPPStartUser(value){
	var obj=document.getElementById('PPStartUserDr');
	var tem=value.split("^");
	obj.value=tem[1];
	
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