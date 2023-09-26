// DHCPEPreIADM.Find.js
var TFORM="tDHCPEPreIADM_Find";
var CurrentSel=0;
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById(TFORM);
	if (obj) { obj.ondblclick=PreIADM_click; }

	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }

	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	obj=document.getElementById("Name");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	// 预约
	obj=document.getElementById("Status_PREREG");
	if (obj){ obj.onclick=Status_PREREG_click; }
	
	
	// 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 需审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj){ obj.onclick=Status_PREREG_NoALL; }
	
	// 修改预约信息
	obj=document.getElementById("Update");
	if (obj){
		obj.onclick=Update_click;
		obj.disabled=true;
	}
	obj=document.getElementById("BAudit");
	if (obj){
		obj.onclick=BAudit_click;
	
	}
	// 放弃预约
	obj=document.getElementById("CancelADM");
	if (obj){
		obj.onclick=CancelADM_click;
		obj.disabled=true;
	}

	// 放弃预约
	obj=document.getElementById("BPreOver");
	if (obj){
		obj.onclick=CancelADM_click;
		obj.disabled=true;
	}
	//修改项目
	//BModifyTest
	obj=document.getElementById("BModifyTest");
	if (obj){ 
	     //BModifyTest_click
		//BModifyTest_click
		obj.onclick=BModifyTest_click
		obj.disabled=true;
	}
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_KeyDown;}


	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

	
	obj=document.getElementById("GroupDesc")
	if (obj) { obj.onchange=GroupDesc_Change; }
	
	obj=document.getElementById("TeamDesc");
	if (obj) { obj.onchange=TeamDesc_Change; }

	// 打印 打印单
	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	iniForm();
	initialReadCardButton()
   	Muilt_LookUp('GroupDesc'+'^'+'TeamDesc');
   	
   //document.getElementById("Status_PREREG").checked=true;
   //document.getElementById("Status_REGISTERED").checked=true;  //add
   //document.getElementById("Status_ARRIVED").checked=true;
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
}


function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}

function BAudit_click()
{
	var iRowId=""
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
	if (iRowId=="") return;
	var Ins=document.getElementById('AuditClass');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,iRowId)
	if (flag==0)
	{
		alert("更新成功")
	}
}
function iniForm(){
	var obj;
	obj=document.getElementById("Status");
	if (obj) { SetStatus(obj.value); }
	ShowCurRecord(0);
	
}
function RegNo_KeyDown(){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

function BFind_click() {
	
	var obj;
	var iRegNo="";
	var iName="";
	var iPEDate="";
	var iPETime="";
	var iStatus="";
	var iPEEndDate=""
	var iGroupID=""
	var iTeamID=""
	
	
	
	obj=document.getElementById("TFORM");
	if (obj){ var tForm=obj.value; }
	else { return false; }
	
	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
		if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo); }
	}

	obj=document.getElementById("Name");
	if (obj){ iName=obj.value; }

	obj=document.getElementById("PEDate");
	if (obj){ iPEDate=obj.value; }

	obj=document.getElementById("PETime");
	if (obj){ iPETime=obj.value; }	

	iStatus=GetStatus();
	iChargedStatus=GetChargedStatus();
	iCheckedStatus=GetCheckedStatus();
	if (""!=iCheckedStatus) { iStatus=iStatus+"^PREREG"; }
	
	obj=document.getElementById("EndDate");
	if (obj) iPEEndDate=obj.value;
	obj=document.getElementById("GroupID");
	if (obj) iGroupID=obj.value;
	obj=document.getElementById("TeamID");
	if (obj) iTeamID=obj.value;
	
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+tForm
			+"&RegNo="+iRegNo
			+"&Name="+iName
			+"&PEDate="+iPEDate
			+"&PETime="+iPETime
			+"&Status="+iStatus
			+"&ChargedStatus="+iChargedStatus
			+"&CheckedStatus="+iCheckedStatus
			+"&EndDate="+iPEEndDate
			+"&GroupID="+iGroupID
			+"&TeamID="+iTeamID
			+"&RFind=1"
	;
	location.href=lnk;
}
function SelectGruop(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("GroupDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=ValueArr[1];
}
function SelectTeam(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value=ValueArr[0];
	var obj=document.getElementById("TeamID");
	if (obj) obj.value=ValueArr[1];
}
function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
	var obj=document.getElementById("TeamDesc");
	if (obj) obj.value="";
}
function TeamDesc_Change()
{
	var obj=document.getElementById("TeamID");
	if (obj) obj.value="";
}


function Update_click() {

	var obj;
	
	obj=document.getElementById("Update");
	if (obj && obj.disabled){ return false; }
	
	var iRowId="";
	
	obj=document.getElementById("RowId");
	if (obj){ iRowId=obj.value; }
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIADM.Edit"
			+"&ID="+iRowId
			
			
	//var PreOrAdd="PRE"
	//var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
	//		+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
	;
	location.href=lnk;

}

function CancelADM_click() {
	var Src=window.event.srcElement;
	//var Src=document.getElementById("CancelADM");
	if (Src.disabled) { return false; }
	Src.disabled=true;
	var obj;
	var iRowId="",iStatus="PREREG",iUpdateUserDR="";
	var Instring="";
	var Type=Src.innerHTML.substr(Src.innerHTML.length-4,4)
	if (Type=="预约完成") iStatus="PREREGED"
	if (Type=="放弃预约") iStatus="CANCELPREREG"
	obj=document.getElementById("RowId");
	if (obj && ""!=obj.value) { iRowId=obj.value; }
	
	iUpdateUserDR==session['LOGON.USERID'];
	
	Instring=iRowId+"^"+iStatus+"^"+iUpdateUserDR;
	
	var Ins=document.getElementById('CancelADMBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)
	if ("NoItem"==flag)
	{
		alert(t[flag]);
		return;
	}else if (('Err 01'==flag)||('100'==flag)) {
		alert(t['Err 01']);
		return;
	}else if ('Err 02'==flag) {
		alert(t['Err 02']);
		return;
	}else if ('Err 03'==flag) {
		alert(t['Err 03']);
		return;
	}else if ('Err 04'==flag) {
		alert(t['Err 04']);
		return;
	}	
	else if ('0'==flag) {
		//alert("Update Success!");
		location.reload();
	}
	
	Src.disabled=false;
	
}

/// 调用项目预约页面
//function ModifyTest_click() {
 function BModifyTest_click() {
	
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false;}
	var iRowId="";
		
	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	
	var PreOrAdd="PRE"
	///如果是团体中的个人当作额外加项
	var obj=document.getElementById("TGNamez"+CurrentSel);
	if (obj)
	{
		if ((obj.innerText!="")&&(obj.innerText!=" ")) PreOrAdd="ADD"
	}
	var lnk="dhcpepreitemlist.main.csp"+"?AdmType=PERSON"
			+"&AdmId="+iRowId+"&PreOrAdd="+PreOrAdd
			;
		
	var wwidth=1000;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	alert(lnk)
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function SetStatus(Status) {
	var obj;
	var values=Status.split(":");
	var value=values[0];
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj) {
		if (value.indexOf("^ARRIVED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj) {
		if (value.indexOf("^REGISTERED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}

	// CANCELPREREG 取消预约
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj) {
		if (value.indexOf("^CANCELPREREG^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// CANCELArrive 取消到达
	obj=document.getElementById("Status_CANCELArrive");
	if (obj) {
		if (value.indexOf("CANCELARRIVED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	//CANCELPE  取消体检
	obj=document.getElementById("Status_CANCELPE");
	if (obj) {
		if (value.indexOf("CANCELPE^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// PREREG 预约
	obj=document.getElementById("Status_PREREG");
	if (obj && ""==values[2]) {
		if (value.indexOf("^PREREG^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// PREREGED 完成预约
	obj=document.getElementById("Status_PREREGED");
	if (obj && ""==values[2]) {
		if (value.indexOf("^PREREGED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	var value=values[2];
	if (""==value) { return ;}
	// UNCHECKED 未审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj) {
		if (value.indexOf("^UNCHECKED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
		
	// CHECKED 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj) {
		if (value.indexOf("^CHECKED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
	// NOCHECKED 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj) {
		if (value.indexOf("^NOCHECKED^")>-1) { obj.checked=true; }
		else { obj.checked=false; }
	}
	
		
}

function GetChargedStatus()
{
	var iStatus="";
	return iStatus;
}
// 获取 审核状态
function GetCheckedStatus()
{
	var obj;
	var iStatus="";
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ return ""; }
		
	// UNCHECKED 未审核
	obj=document.getElementById("Status_UNCHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"UNCHECKED"; }
		
	// CHECKED 已审核
	obj=document.getElementById("Status_CHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CHECKED"; }
	
	// NOCHECKED 不需审核
	obj=document.getElementById("Status_NOCHECKED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"NOCHECKED"; }
	
	return iStatus;
}

function GetStatus() {
	var obj;
	var iStatus="";

	// PREREG 预约
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREG"; }
	// PREREGED 完成预约
	obj=document.getElementById("Status_PREREGED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"PREREGED"; }
	// REGISTERED 登记
	obj=document.getElementById("Status_REGISTERED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"REGISTERED"; }
	
	// REGISTERED 到达
	obj=document.getElementById("Status_ARRIVED");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"ARRIVED"; }

	// CANCELPREREG 取消预约
	obj=document.getElementById("Status_CANCELPREREG");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPREREG"; }
	
	// CANCELArrive 取消到达
	obj=document.getElementById("Status_CANCELArrive");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELARRIVED"; }
	//CANCELPE  取消体检
	obj=document.getElementById("Status_CANCELPE");
	if (obj && obj.checked){ iStatus=iStatus+"^"+"CANCELPE"; }
	iStatus=iStatus+"^"
	return iStatus;
}

function Status_PREREG_click() {
	obj=document.getElementById("Status_PREREG");
	if (obj && obj.checked){
		// UNCHECKED 未审核
		obj=document.getElementById("Status_UNCHECKED");
		if (obj){  obj.checked=false; }
		
		// CHECKED 已审核
		obj=document.getElementById("Status_CHECKED");
		if (obj){  obj.checked=false; }
		
		// NOCHECKED 不需审核
		obj=document.getElementById("Status_NOCHECKED");
		if (obj){  obj.checked=false; }
	}
}
	
function Status_PREREG_NoALL() {
	var src=window.event.srcElement;
	if (src && src.checked){
		obj=document.getElementById("Status_PREREG");
		if (obj){  obj.checked=false; }
	}
}

function Clear_click() {


}

		
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	/*
	if (selectrow==CurrentSel)
	{	    
	
	    Clear_click();
	    CurrentSel=0;
	    return;
	}
	*/
	if (CurrentSel==selectrow)
	{
		CurrentSel=0;
	}
	else
	{
		CurrentSel=selectrow;
	}
	ShowCurRecord(CurrentSel);

}

function PreIADM_click() {

	var eSrc=window.event.srcElement;
	
	var obj=document.getElementById(TFORM);
	if (obj){ var tForm=obj.value; }
	
	var objtbl=document.getElementById(tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	/*
	if (selectrow==CurrentSel)
	{
	    CurrentSel=0;
	    return;
	}
	*/
	CurrentSel=selectrow;
 	ShowCurRecord(CurrentSel);
}

function ShowCurRecord(CurrentSel) {

	//站点编码 显示	    
	var SelRowObj;
	var obj;
	var iRowId="";
	if (CurrentSel==0)
	{
		obj=document.getElementById("RowId");
		if (obj) obj.value=iRowId
		obj=document.getElementById("Update");
		if (obj) obj.disabled=true;
		obj=document.getElementById("CancelADM");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=true;
		return false;
	}
	SelRowObj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	obj=document.getElementById("RowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	SelRowObj=document.getElementById('PIADM_Status'+'z'+CurrentSel);
	if (SelRowObj) var Status=SelRowObj.value;
	if (Status=="PREREG")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>放弃预约"}
		obj=document.getElementById("Update");
		if (obj) obj.disabled=false;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=false;
		obj=document.getElementById("BPreOver");
		if (obj) obj.disabled=false;
	}
	if (Status=="PREREGED")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>取消完成"}
		obj=document.getElementById("Update");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=false;
		obj=document.getElementById("BPreOver");
		if (obj) obj.disabled=true;
	}
	if (Status=="ARRIVED")
	{
		obj=document.getElementById("CancelADM");
		if (obj) obj.disabled=true;
		obj=document.getElementById("Update");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=false;
		obj=document.getElementById("BPreOver");
		if (obj) obj.disabled=true;
	}
	if (Status=="CANCELPREREG")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=false;
		obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约"}
		obj=document.getElementById("Update");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BPreOver");
		if (obj) obj.disabled=true;
	}
	if (Status=="CANCELARRIVED")
	{
		obj=document.getElementById("CancelADM");
		if (obj){obj.disabled=true;}
		//obj.innerHTML="<img SRC='../images/websys/update.gif' BORDER='0'>预约"}
		obj=document.getElementById("Update");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BPreOver");
		if (obj) obj.disabled=true;
	}
		if (Status=="REGISTERED")
	{
		obj=document.getElementById("CancelADM");
		if (obj) obj.disabled=true;
		obj=document.getElementById("Update");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BModifyTest");
		if (obj) obj.disabled=false;
		obj=document.getElementById("BPreOver");
		if (obj) obj.disabled=true;
	}
}
// 菜单 查询预约项目
function PreIADMItemList() {

	var iRowId="";

	var obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (""==iRowId) { return false;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreItemList.List"
			+"&AdmType=PERSON"
			+"&AdmId="+iRowId
			;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes';
	window.open(lnk,"_blank",nwin)	

	return true;
}
function UpdatePreAudit()
{
	var Type="I";
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { ID=obj.value; }
	if (""==ID) { return false;}
	//obj=document.getElementById("PIADM_RowId");
	//if (obj){ var ID=obj.value;}
	//else{return false;}
	if (ID=="") return false;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreAudit.Edit"
	//		+"&CRMADM="+ID+"&ADMType="+Type+"&GIADM=";
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
function ModifyDelayDate()
{
	var Type="Pre";
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { ID=obj.value; }
	if (""==ID) { return false;}
	//obj=document.getElementById("PIADM_RowId");
	//if (obj){ var ID=obj.value;}
	//else{return false;}
	//if (ID=="") return false;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPreModifyDelayDate"
			+"&ID="+ID+"&Type="+Type;
	
	var wwidth=250;
	var wheight=150;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
// 打印导检单

function PatItemPrint() {
	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrint");
	if (CurrentSel==0) return;
	obj=document.getElementById("RowId");  //  ??
	if (obj){ CRMId=obj.value; }
    var Page="A4"
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM";
		
	var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	Print(value);
		
}


function PatItemPrintA4()  
{

	//DHCP_GetXMLConfig("InvPrintEncrypt","OEItemPrintA4");
	var Page="A4"
	obj=document.getElementById("RowId");  
	if (obj){ CRMId=obj.value; }
	if (CRMId=="") return;
	var DietFlag="TRUE"
	var Diet=document.getElementById('DietFlag');
	if (Diet) DietFlag=Diet.checked;
	var Instring=CRMId+"^"+DietFlag+"^CRM"+"^"+Page;

    var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);

	 Print(value,Page);
}
		
	
	


function CancelPE()
{
	CancelPECommon('PIADM_RowIdz',"I",CurrentSel)
}
function CancelPECommon(ElementName,Type,CurRow)
{
	var obj=document.getElementById(ElementName+CurRow);
	if (obj)
	{
		var Id=obj.value;
	}
	else
	{
		return false;
	}
	
	var obj=document.getElementById("CancelPEClass");
	if (obj)
	{
		var encmeth=obj.value;
	}
	else
	{
		return false;
	}
	var Ret=cspRunServerMethod(encmeth,Id,Type);
	Ret=Ret.split("^");
	alert(Ret[1]);
}
function UpdateAsCharged()
{
	var Type="I";
	var obj;
	if (CurrentSel==0) return;
	obj=document.getElementById("TGNamez"+CurrentSel);
	var Group=""
	if (obj) Group=obj.innerText;
	if ((Group!="")&&(Group!=" "))
	{
		alert("团体中的客户,请操作团体");
		return;
	}
	obj=document.getElementById("RowId");  //  ??
	if (obj){ ID=obj.value; }
	if (ID=="") return false;
	obj=document.getElementById("UpdateAsCharged");
	if (obj) var encmeth=obj.value;
	var Return=cspRunServerMethod(encmeth,ID,Type)
	if (Return==""){alert("Status Err");}
	else if (Return=="SQLErr"){alert("Update Err");}
	else{alert("Update Success!");}
}
//打印检查项目信息 2008-06-30
//create by  zhouli
function PrintRisRequest()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintRisRequestApp(PreIADMDR,"","PreIADM");
	return false;
}
function GetRisInfo()
{  
	if (CurrentSel==0) return;
   var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	
	
    var Ins=document.getElementById('GetRisItemInfo');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,PreIADMDR);
	var String=value.split(";");
	alert(String)
  
		for (var i=0;i<String.length;i++)
		{
			var str=String[i].split("^");
            var ItemDesc=str[0]
            var Regno=str[1]
            var SexDesc=str[2]
            var Age=str[3]
            var Name=str[4]
            var InfoStr=ItemDesc+"^"+Regno+"^"+SexDesc+"^"+Age+"^"+Name
               alert(InfoStr)
	        PrintRisInfo(InfoStr);
	        //if (LocID=="165")  PrintRisInfo(InfoStr);
	    }
			
	}

		
function PrintRisInfo(InfoStr)   
{   
   var LocID=session['LOGON.CTLOCID']
	var Info=InfoStr.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfoNew.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
    xlsheet.cells(2,1).Value=ItemDesc ;
    //if (LocID=="165"){xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  医务部体检"; }
	//if (LocID=="579"){xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
	xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  医务部体检";
	//xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;
	xlsheet.cells(3,1).Value="*"+Regno+"*";
    //if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    //if (LocID=="579") {xlsheet.printout;}
    xlsheet.printout(1,1,1,false,"tiaoma");
    xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	}
function PrintRisInfoOld(InfoStr)   
{   
   var LocID=session['LOGON.CTLOCID']
    
    var Info=InfoStr.split("^")       
    var ItemDesc=Info[0]
    var Regno=Info[1]
    var SexDesc=Info[2]
    var Age=Info[3]
    var Name=Info[4]
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
	
    xlsheet.cells(3,1).Value=ItemDesc ;
    if (LocID=="165"){xlsheet.cells(2,1).Value="医务查体"+"  "+Regno; }
	if (LocID=="579") {xlsheet.cells(2,1).Value="医保查体"+"  "+Regno;} 
    xlsheet.cells(1,1).Value=Name+"  "+SexDesc+"  "+Age ;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	}

function printBaseInfo(Name,SexDesc)
{   var LocID=session['LOGON.CTLOCID']
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPrintRisItemInfo.xls';
	}else{
		alert("无效模板路径");
		return;
	}

	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Templatefilepath);
    xlsheet = xlBook.WorkSheets("Sheet1") 
	xlsheet.cells(2,1).Value=Name+"   "+SexDesc;
    xlsheet.Rows(2).Font.Size=16;
    if (LocID=="165") {xlsheet.printout(1,1,1,false,"tiaoma");}
    if (LocID=="579") {xlsheet.printout;}
    //xlsheet.printout;
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
}
function PECashier()
{
	var obj=document.getElementById('PIADM_RowId'+'z'+CurrentSel);
	if (!obj) return;
	var PADM=obj.value;
	var obj=document.getElementById('PIADM_PIBI_DR_RegNo'+'z'+CurrentSel);
	if (obj) var RegNo=obj.innerText;
	var sURL="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAdvancePayment"
				+"&RegNo="+RegNo+"&PADM="+PADM+"&Type=R";
	window.showModalDialog(sURL,"","dialogWidth=600px;dialogHeight=450px");
}
//预约到达日期
function AppointArrivedDate()

{
	
	var obj;
	var obj=document.getElementById("RowId");  
	if (obj) { var ID=obj.value; }
	if (""==ID) { return false;}
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEAppointArrivedDate"
			+"&ID="+ID+"&Type="+Type
	
	var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
	
function PrintCashierNotes()

{
	
	var obj;
	var obj=document.getElementById("RowId");
	if (obj) { var ID=obj.value; }
	if (""==ID) { 
	alert(t["NoRecord"])
	return false;}
	var obj=document.getElementById('PIADM_PIBI_DR_Name'+'z'+CurrentSel);
	if (obj) var Name=obj.innerText;
	var Type="I"
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPrintCashierNotes"
			+"&ID="+ID+"&Name="+Name+"&Type="+Type
		var wwidth=350;
	var wheight=200;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
	}
function CancelCashierNotes()    
{     	
        var obj=""
        obj=document.getElementById('RowId');
		if(obj){
			var PIADM=obj.value
			if (PIADM=="")
			{alert(t["NoRecord"])
			  return;}
			
			}
		
         var Ins=document.getElementById('Cancel');
		 if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
		 var Flag=cspRunServerMethod(encmeth,"I",PIADM,"");
         if (Flag==""){alert(t["CancelSuccess"])}
         if (Flag=="NoCashier"){alert(t["NoCashier"])} 
	
	
	}
 function PrintIOEFeeDetail()   
   {   
   	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }

	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) 
	{
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGOEFeeDetailPrint.xls';
	}else
	{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");  //固定
	xlBook = xlApp.Workbooks.Add(Templatefilepath);  //固定
	xlsheet = xlBook.WorkSheets("明细")     //Excel下标的名称
       var Ins=document.getElementById('GetIOEFeeDetail');
       if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var Returnvalue=cspRunServerMethod(encmeth,PreIADMDR);
	if (Returnvalue==""){
		alert("无已交费的个人明细!")
		return;}
	var String=Returnvalue.split("#");
	var PatName=String[0]
	var ARCIMStr=String[1]
	var ARCIM=ARCIMStr.split("$");
	xlsheet.cells(2,1).Value=PatName+""+"体检项目费用明细";
	for(i=0;i<(ARCIM.length);i++)
	{  
	var ARCIMDesc=ARCIM[i].split("^")[0]
	var ARCIMNum=ARCIM[i].split("^")[1]
	var ARCIMAmount=ARCIM[i].split("^")[2]

       xlsheet.Range(xlsheet.Cells(3+i,1),xlsheet.Cells(3+i,3)).mergecells=true; //合并单元格
	xlsheet.Range(xlsheet.Cells(3+i,4),xlsheet.Cells(3+i,5)).mergecells=true; //合并单元格
	xlsheet.Range(xlsheet.Cells(3+i,6),xlsheet.Cells(3+i,7)).mergecells=true; //合并单元格
	//xlsheet.Range(xlsheet.Cells(3+i,4),xlsheet.Cells(3+i,5)).HorizontalAlignment =-4108;//居中
       xlsheet.Range(xlsheet.Cells(3+i,1),xlsheet.Cells(3+i,7)).Borders.LineStyle=1;
	 xlsheet.cells(3+i,1).Value=ARCIMDesc
        xlsheet.cells(3+i,4).Value=ARCIMNum
        xlsheet.cells(3+i,6).Value=ARCIMAmount
	 }
 		xlsheet.SaveAs("d:\\"+PatName+"体检项目费用明细.xls");
		//xlBook.Close (savechanges=false);
		//xlApp=null;
		//xlsheet=null;
	   xlApp.Visible = true;
	   xlApp.UserControl = true;
	}
function PrintReportRJ()
{
	var obj=document.getElementById("RowId");  
	if (obj){ PreIADMDR=obj.value; }
	PrintReportRJApp(PreIADMDR,"PreIADM");
}
document.body.onload = BodyLoadHandler;




