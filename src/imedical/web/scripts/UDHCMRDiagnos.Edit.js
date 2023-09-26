// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var MAXGROUPS=5;
var HospitalCode="";
var obj=document.getElementById("HospitalCode");
if (obj)HospitalCode=obj.value;

function ValidateUpdate() {
	var MRDIACDCodeDR = document.getElementById('MRDIAICDCodeDR');
	var MRDIASignSymDR = document.getElementById('MRDIASignSymDR');
	var MRDIADiagStatDR = document.getElementById('MRDIADiagStatDR');
	var MRDIADesc = document.getElementById('MRDIADesc');
	var msg=""; var focusfield=null;

	//if comments or signSymptoms entered, then diagnosis needs to be entered
	// now they can be entered with a diagnosis
	/*if (((MRDIADiagStatDR)&&(MRDIADiagStatDR.value != ""))&&
	 ((MRDIASignSymDR)&&(MRDIASignSymDR.value != ""))&&
	 ((MRDIADesc)&&(MRDIADesc.value != ""))) {
		//at least one of the three diagnosis fields needs to be entered
		if (!MRDIACDCodeDR) MRDIACDCodeDR = document.getElementById('MRDIAICDCodeDRDescOnly');
		if (!MRDIACDCodeDR) MRDIACDCodeDR = document.getElementById('MRDIAICDCodeDRAltDescAlias');
		if ((MRDIACDCodeDR)&&(MRDIACDCodeDR.value == "")) {
			//msg+="\'" + t['MRDIAICDCodeDR'] + "\' " + t['XMISSING'] + "\n";
			focusfield=MRDIACDCodeDR;
			msg+="\'" + t[focusfield.name] + "\' " + t['XMISSING'] + "\n";
		}
	}
	if (msg!="") {
		alert(msg);
		if (focusfield) focusfield.focus();
		return false;
	}
	*/
	//23.07.02 HP: Added line below to prevent error when this window is not open as happens in log#26876
	if (window.opener) { 
		//10.07.02 Log#26116 HP: Used for CSP page "paadm.diagnosis.csp" to reload the lower frame with "MRDiagnos.ListEMR"
		//26.07.02 Log#24836 HP: Used for CSP page "dischargediagnosis.csp" to reload top and lower frames
		// 3/9/02 Log#27280 cont. Log#24836 HP: Reload top frame of CSP page "dischargediagnosis.csp" by reloading lower frame first to get the changes to pass to top frame
		// 20/09/02 Log#27697 HP: Reload now called from MRDiagnos.ListEMR.js
		//if edit screen pop up from lower frame of CSP page "dischargediagnosis.csp", set flag to reload top frame
		if (window.opener.parent.frames["discharge_top"]) window.opener.parent.refreshTopRequired=1;
		
		
	}
	return true;
}

//因为还有许多附加信息要保存，原来通过组件update按钮保存方式无法满足,所以重写
function Update_click(){
	var MRCICDRowid=document.getElementById("MRDIAICDCodeID").value;

	var MRDIADesc="";
	var MRDIADescobj = document.getElementById('MRDIADesc');
	if (MRDIADescobj){MRDIADesc=MRDIADescobj.value}
	var LogDepRowid=session['LOGON.CTLOCID'];
	var LogUserRowid=session['LOGON.USERID'];

	var obj=document.getElementById("PARREF");
    	if (obj) var MRADMID=obj.value;

	var obj2=document.getElementById("MRDiagType");
	if (obj2) var MRDiagType=obj2.value
	
	var MRDIADiagStatDesc="";
	var obj2=document.getElementById("MRDIADiagStatDR");
	if (obj2) var MRDIADiagStatDesc=obj2.value


	var MRDIASignSymDesc="";
	var obj2=document.getElementById("MRDIASignSymDR");
	if (obj2) var MRDIASignSymDesc=obj2.value

	var MRDIADurationNum="";
	var obj2=document.getElementById("MRDIADurationNum");
	if (obj2) var MRDIADurationNum=obj2.value

	var MRDIADurationUnit="";
	var obj2=document.getElementById("MRDIADurationUnit");
	if (obj2) var MRDIADurationUnit=obj2.value

	var GetDetail=document.getElementById('InsertMRDiagnos');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	//alert(LogDepRowid+"^"+MRADMID+"^"+MRCICDRowid+"^"+LogUserRowid);
	
	var DHCMRDIASignSymDesc="";
	var MRDIADescobj = document.getElementById('MRDIASignSymDesc');
	if (MRDIADescobj){DHCMRDIASignSymDesc=MRDIADescobj.value}

	MRDiagnosRowid=cspRunServerMethod(encmeth,LogDepRowid,MRADMID,MRCICDRowid,LogUserRowid,MRDIADesc,MRDiagType,MRDIADiagStatDesc ,MRDIASignSymDesc,MRDIADurationNum,MRDIADurationUnit,DHCMRDIASignSymDesc);
	
	//update by zf
	//临床路径准入提示校验,提示是否入径
	ShowCPW(MRCICDRowid,MRDiagnosRowid);
	
	if(MRDiagnosRowid!='0') {
		
	}
}
function UpdateClickHandler() {
	if (ValidateUpdate()) {
		//document.forms['fMRDiagnos_Edit'].target=setTargetWindow(document.getElementById('ChartID').value);
		//return Update_click();
		var EpisodeID=""
		var obj=document.getElementById('EpisodeID');
		if (obj){EpisodeID=obj.value}
		
		var AdmReadm="A";
		var AdmReadmobj=document.getElementById('AdmReadm');
		if (AdmReadmobj){
			if (AdmReadmobj.checked==true){AdmReadm="R"}
		}
		
		var Specialist="";
		var obj=document.getElementById('Specialist');
		if (obj){
			if (obj.checked==true){Specialist="1"}			
		}
		
		var Subject="";
		var obj=document.getElementById('Subject');
		if (obj){
			if (obj.checked==true){Subject="1"}			
		}

		var Weight="";
		var obj=document.getElementById('Weight');
		if (obj){Weight=obj.value}


		var AdmPara=AdmReadm+"^"+Specialist+"^"+Subject+"^"+Weight;
		
		var PAPMIAddress="";
		var PAPMIAddressobj=document.getElementById('PAPMIAddress');
		if (PAPMIAddressobj){PAPMIAddress=PAPMIAddressobj.value}else{PAPMIAddress="Hidden"}

		var PAPMICompany="";
		var PAPMICompanyobj=document.getElementById('PAPMICompany');
		if (PAPMICompanyobj){PAPMICompany=PAPMICompanyobj.value}else{PAPMICompany="Hidden"}

	  var UpdatePA=document.getElementById('UpdatePA');
		//alert(EpisodeID+"^"+AdmReadm+"^"+PAPMIAddress+"^"+PAPMICompany);
		if (UpdatePA) {var encmeth=UpdatePA.value} else {var encmeth=''};
		if (encmeth!="") {
			if (cspRunServerMethod(encmeth,EpisodeID,AdmPara,PAPMIAddress,PAPMICompany)!='0') {
				alert('fail');
			}
		}
		
		UpdateArriveStatus();
		
		var DiagnosisObj = document.getElementById('MRDIAICDCodeDR');
		var MRDIADescobj = document.getElementById('MRDIADesc');
		if ((DiagnosisObj.value!="") || (MRDIADescobj.value!="")){
			Update_click();
		}
		if (window.opener){
			if (window.opener.parent.frames["patframe"]) {
				window.opener.parent.frames["patframe"].ChangPaadm();
			} else {
				window.opener.treload('websys.csp');
			}
			window.close();
		}else{
			if (window.parent){
				//alert(window.parent.location.href);
				window.parent.location.reload();
				//window.parent.treload('websys.csp');
			}else{
				//alert("0");
				window.treload('websys.csp');
			}
		}
	
	}
	return false;
}


function RepeatClickHandler(evt)	{
	var elem = document.getElementById('Repeat');
	if ((elem)&&(elem.disabled)) return false;
	var frm=document.forms['fUDHCMRDiagnos_Edit'];
	return epr_RepeatClickHandler(evt,frm);
}

// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
function DeleteClickHandler() {
	var elem = document.getElementById('delete1');
	if ((elem)&&(elem.disabled)) return false;
	var frm=document.forms['fUDHCMRDiagnos_Edit'];
	return delete1_click();
}
// end Log 46427


function BodyLoadHandler() {
	var update = document.getElementById('Update');
	if (update) update.onclick = UpdateClickHandler;
	if (tsc['Update']) websys_sckeys[tsc['Update']]=UpdateClickHandler;
	var update = document.getElementById('Repeat');
	if (update) update.onclick = RepeatClickHandler;
	if (tsc['Repeat']) websys_sckeys[tsc['Repeat']]=RepeatClickHandler;
	var update = document.getElementById('delete1');
	//if (update) update.onclick = DeleteClickHandler;
	//if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;
	if (update) update.onclick = DeleteMRDiagnosClickHandler;
	var update = document.getElementById('MRDiagnoseList')
	if (update) update.onchange = MRDiagnoseListChangeHandler;
	var update = document.getElementById('UpdateNote')
	if (update) update.onclick = UpdateNoteClickHandler;

	//do not call this, sites can use the layout editor's set form size and position
	//if (self==top) websys_reSizeT();
	
    var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
    if (obj) obj.onblur=AltDescBlurHandler;
    var obj=document.getElementById("MRDIAICDCodeDR");
    if (obj) obj.onblur=DiagnosisBlurHandler;
    var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
    if (obj) obj.onblur=DiagnosisDescBlurHandler;
    var AddLocList=document.getElementById("AddLocList")
		if (AddLocList) AddLocList.onclick=AddLocListClickHandler;
		var obj=document.getElementById("DeleteLocList")
		if (obj) obj.onclick=DeleteLocListClickHandler;
    
    var obj=document.getElementById("LocID");
    if (obj) LocID=obj.value;

    var obj=document.getElementById("LocICDList");
    if (obj) obj.ondblclick=LocICDListDoubleClickHandler;
    var obj=document.getElementById("LocICDList2");
    if (obj) obj.ondblclick=LocICDListDoubleClickHandler;
    var obj=document.getElementById("LocICDList3");
    if (obj) obj.ondblclick=LocICDListDoubleClickHandler;    
		var obj=document.getElementById("LocICDList4");
    if (obj) obj.ondblclick=LocICDListDoubleClickHandler;   

	var obj=document.getElementById('ICDType');
	if (obj){var ICDType=obj.value}else{var ICDType=""}
  var GetLocICDList=document.getElementById('GetLocICDList');
	if (GetLocICDList) {var encmeth=GetLocICDList.value} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'SetLocICDList',LocID,ICDType)!='0') {
			alert(t['LocICDListError']);
		}
	}
	
	var obj=document.getElementById("mradm");
	if (obj) var MRADMID=obj.value;
	var obj=document.getElementById("PARREF");
	if (obj) {
	  if (obj.value=="") obj.value=MRADMID;
	}
    
	var obj=document.getElementById("MRDiagnoseList");
	var GetMRDiagnoseList=document.getElementById('GetMRDiagnoseList');
	if (GetMRDiagnoseList) {var encmeth=GetMRDiagnoseList.value} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'SetMRDiagnoseList',MRADMID,ICDType)!='0') {
			alert(t['MRDiagnoseListError']);
		}
	}

	var PatientID=document.getElementById('PatientID').value;
	var obj=document.getElementById('HistoryMRDiagnoseList');
	if (obj) obj.ondblclick=HistoryMRDiagnoseListDoubleClickHandler;
  	var GetHistoryMRDiagnoseList=document.getElementById('GetHistoryMRDiagnoseList');
	if (GetHistoryMRDiagnoseList) {var encmeth=GetHistoryMRDiagnoseList.value} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'SetHistoryMRDiagnoseList',PatientID,ICDType)!='0') {
		}
	}	
	
	var obj=document.getElementById("MRDIADurationUnit");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		//Days,Weeks,Months,Years
		obj.options[obj.length] = new Option("天","D");
		obj.options[obj.length] = new Option("星期","W");
		obj.options[obj.length] = new Option("月","M");
		obj.options[obj.length] = new Option("年","Y");
	}
	/*2005.10.17 by zhouzq because deleteMRDiagnos have choose,then the old window is designt to get one recorder
	// 4/9/02 Log# 27280 HP: Disable repeat button when open from edit button of MRDiagnos_ListEMR
	var objID = document.getElementById('ID');
	if ((objID)&&(objID.value!="")) {
		DisableFields();
	}
	else {
		EnableFields();
	}

	// Log 46427 - AI - 27-10-2004 : Delete button, but only available when CanUserDelete is 1, otherwise disable.
	var objDelete = document.getElementById('delete1');
	if (objDelete) {
		var objCanUserDelete = document.getElementById('CanUserDelete');
		if ((objCanUserDelete)&&(objCanUserDelete.value==1)) {
			objDelete.disabled=false;
			//objDelete.onclick=DeleteClickHandler;
			objDelete.onclick=DeleteMRDiagnosClickHandler;
		}
		else {
			objDelete.disabled=true;
			objDelete.onclick=LinkDisable;
		}
	}
	// end Log 46427*/
	var obj=document.getElementById("ListItemLeft");
	if (obj) obj.onclick=ShiftItemsLeft;
	var obj=document.getElementById("ListItemUnhighlight");
	if (obj) obj.onclick=UnhighlightItems;
	var obj=document.getElementById("ListItemRight");
	if (obj) obj.onclick=ShiftItemsRight;
	var obj=document.getElementById("ListItemUp");
	if (obj) obj.onclick=ShiftItemsUp;
	var obj=document.getElementById("ListItemDown");
	if (obj) obj.onclick=ShiftItemsDown;
	var obj=document.getElementById("UpdateSortid");
	if (obj) obj.onclick=UpdateSortid_Click;
}

function MRDiagnoseListChangeHandler(){
	var MRDiagnosList=document.getElementById("MRDiagnoseList");
	var selIndex=MRDiagnosList.selectedIndex;
	if (selIndex==-1) return
	var MRDiagnosRowid=MRDiagnosList.options[selIndex].value;
	var GetDetail=document.getElementById('GetMRDiagnosNote');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	if (encmeth!="") {
		var ret=cspRunServerMethod(encmeth,MRDiagnosRowid);
		var UpdateNote=document.getElementById("DiagnoseNote");
		if (UpdateNote) UpdateNote.value=ret;
		//websys_setfocus('DiagnoseNote');
	}
}
function DeleteLocListClickHandler(){
	var LocICDList=document.getElementById("LocICDList");
	var obj2=document.getElementById("LocICDList2");
	var obj3=document.getElementById("LocICDList3");
	var obj4=document.getElementById("LocICDList4");

	if (!(LocICDList)) return;
	var selIndex=LocICDList.selectedIndex;
	if (selIndex==-1) return
	var MRCICDRowid=LocICDList.options[selIndex].value;

	var MRCICDDesc=LocICDList.options[selIndex].text;
	var MRCICDCode=LocICDList.options[selIndex].code;
	var LocDiaRowId=LocICDList.options[selIndex].LocDiaRowId;
	
	if (LocDiaRowId=="") return;
	
	var PrescCheck=confirm('确认删除常用诊断吗',true);
	if (PrescCheck==false) return ;

	var obj=document.getElementById('DeleteLocDiagnosMethod');
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	if (encmeth!=""){
		var ret=cspRunServerMethod(encmeth,LocDiaRowId);
		if(ret=='0') {
			LocICDList.options[selIndex]=null;
			LocICDList.selectedIndex=-1
			return;
		}
	}
}
//cjb 2006-11-10 + 添加常用诊断到模版
function AddLocListClickHandler(){
	var LogDepRowid=session['LOGON.CTLOCID'];
	var LogUserRowid=session['LOGON.USERID'];
	var obj1=document.getElementById("MRDIAICDCodeID");
	if (obj1) var ICDCode=obj1.value
	var obj2=document.getElementById("AddLocDiagones");
	if (obj2) var encmeth=obj2.value
	if (ICDCode==""){
		alert(t['AddICDCode'])
	}else{
		//alert(ICDCode+"^"+LogDepRowid+"^"+LogUserRowid);
		var ret=cspRunServerMethod(encmeth,ICDCode,LogDepRowid,LogUserRowid)
		if (ret==-1){
			alert(t['repeat']);
		}else{
			if (ret==0){
			  alert(t['succeed']);
			  window.location.reload();
			}
			if (ret!=0){
				alert(t['baulk']);
			}
		}
	}
}

function UpdateNoteClickHandler(){
	var MRDiagnosList=document.getElementById("MRDiagnoseList");
	var selIndex=MRDiagnosList.selectedIndex;
	if (selIndex==-1) return
	var MRDiagnosRowid=MRDiagnosList.options[selIndex].value;
	var UpdateNote=document.getElementById("DiagnoseNote");
	if (UpdateNote) {
		var Note=UpdateNote.value;
		var GetDetail=document.getElementById('UpdateMRDiagnosNote');
		if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
		if (encmeth!="") {
			var ret=cspRunServerMethod(encmeth,MRDiagnosRowid,Note);
			MRDiagnosList.options[selIndex].text=ret;
			MRDiagnosList.options[selIndex].selected=true;
		}
	}
}

function LocICDListDoubleClickHandler(){
	var LocICDList=websys_getSrcElement();
	if (!(LocICDList)) return;
	
	//var LocICDList=document.getElementById("LocICDList");
	var selIndex=LocICDList.selectedIndex;
	if (selIndex==-1) return
	var MRCICDRowid=LocICDList.options[selIndex].value;
	var MRCICDDesc=LocICDList.options[selIndex].text;
	var MRCICDCode=LocICDList.options[selIndex].code;


	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value}

  var CheckMethod=document.getElementById('CheckDiagnosCatMethod');
	//alert(EpisodeID+"^"+AdmReadm+"^"+PAPMIAddress+"^"+PAPMICompany);
	if (CheckMethod) {var encmeth=CheckMethod.value} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,EpisodeID,MRCICDRowid)!=0) {
			alert(t['NotInDiagnosCat']);
		}
	}	
	//var str=MRCICDDesc+"^"+MRCICDRowid+"^"+MRCICDCode+"^"
	//LookUpDiagnos(str);
	var MRDIADesc="";
	var MRDIADescobj = document.getElementById('MRDIADesc');
	if (MRDIADescobj){MRDIADesc=MRDIADescobj.value}
	var LogDepRowid=session['LOGON.CTLOCID'];
	var LogUserRowid=session['LOGON.USERID'];
	
	var obj=document.getElementById("PARREF");
	if (obj) var MRADMID=obj.value;
	var obj2=document.getElementById("MRDiagType");
	if (obj2) {var MRDiagType=obj2.value;	}else{var MRDiagType=""}
	
	var obj=document.getElementById("HospitalCode");
	if (obj) {var HospitalCode=obj.value;	}else{var HospitalCode=""}

	if ((HospitalCode=="SG")&&(MRDiagType=="")){
		alert(t['NoMRDiagType']);
		return;
	}
	if (HospitalCode=="SG"){
		AddDiagnosToLookUp(MRCICDRowid,MRCICDCode,MRCICDDesc,MRDIADesc,MRDiagType);
		return;
	}
	var GetDetail=document.getElementById('InsertMRDiagnos');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	//alert(LogDepRowid+"^"+MRADMID+"^"+MRCICDRowid+"^"+LogUserRowid);
	MRDiagnosRowid=cspRunServerMethod(encmeth,LogDepRowid,MRADMID,MRCICDRowid,LogUserRowid,MRDIADesc,MRDiagType);
	
	//update by zf
	//临床路径准入提示校验,提示是否入径
	ShowCPW(MRCICDRowid,MRDiagnosRowid);
	
	if(MRDiagnosRowid!='0') {
		UpdateArriveStatus()
		SetMRDiagnoseList(MRCICDDesc,MRDiagnosRowid,MRCICDCode,MRDIADesc)
		if (MRDIADescobj){MRDIADescobj.value=""}
		LocICDList.selectedIndex=-1
		if (window.parent.frames["RPbottom"]){
			window.parent.frames["RPbottom"].location=window.parent.frames["RPbottom"].location;
		}
		
		return;
	}
}
function HistoryMRDiagnoseListDoubleClickHandler(e){
	var LocICDList=websys_getSrcElement();
	if (!(LocICDList)) return;
	var selIndex=LocICDList.selectedIndex;
	if (selIndex==-1) return
	var MRCICDRowid=LocICDList.options[selIndex].value;
	var MRCICDDesc=LocICDList.options[selIndex].text;
	var MRCICDCode="";
	var MRDIADesc="";
	var MRDIADescobj = document.getElementById('MRDIADesc');
	if (MRDIADescobj){MRDIADesc=MRDIADescobj.value}
	var LogDepRowid=session['LOGON.CTLOCID'];
	var LogUserRowid=session['LOGON.USERID'];
	var obj=document.getElementById("PARREF");
  if (obj) var MRADMID=obj.value;
	var obj2=document.getElementById("MRDiagType");
	if (obj2) var MRDiagType=obj2.value
	if (HospitalCode=="SG"){
		AddDiagnosToLookUp(MRCICDRowid,MRCICDCode,MRCICDDesc,MRDIADesc,MRDiagType);
		return;
	}
	var GetDetail=document.getElementById('InsertMRDiagnos');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	//alert(LogDepRowid+"^"+MRADMID+"^"+MRCICDRowid+"^"+LogUserRowid);
	MRDiagnosRowid=cspRunServerMethod(encmeth,LogDepRowid,MRADMID,MRCICDRowid,LogUserRowid,MRDIADesc,MRDiagType);
	
	//update by zf
	//临床路径准入提示校验,提示是否入径
	ShowCPW(MRCICDRowid,MRDiagnosRowid);
	
	if(MRDiagnosRowid!='0') {
		UpdateArriveStatus()
		SetMRDiagnoseList(MRCICDDesc,MRDiagnosRowid,MRCICDCode,MRDIADesc);
		var MRDIADescobj = document.getElementById('MRDIADesc');
		if (MRDIADescobj){MRDIADescobj.value=""}
		LocICDList.selectedIndex=-1;
		if (window.parent.frames["RPbottom"]){
			window.parent.frames["RPbottom"].location=window.parent.frames["RPbottom"].location;
		}
		return;
	}
}
function AddDiagnosToLookUp(MRCICDRowid,MRCICDCode,MRCICDDesc,MRDIADesc,MRDiagType){
	var obj=document.getElementById("MRDIAICDCodeDR");
	if (obj) obj.value=MRCICDDesc;
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=MRCICDRowid;
	var obj3=document.getElementById("MRCIDCode");
	if (obj3) obj3.value=MRCICDCode;
	var obj3=document.getElementById("MRDIADesc");
	if (obj3) {
		if (obj3.value=="")obj3.value=MRCICDDesc;
		else obj3.value=obj3.value+","+MRCICDDesc;
	}
}
function SetNotes(Notes){
	var obj=document.getElementById("MRDIADesc");
	if (obj){
		obj.value=Notes;
	}	
}
function SetHistoryMRDiagnoseList(Desc,Rowid,MRDesc){
	var obj=document.getElementById("HistoryMRDiagnoseList");
	if (obj){
		var NewIndex=obj.length;
		if (MRDesc!="") Desc=Desc+"**"+MRDesc;
		obj.options[NewIndex] = new Option(Desc,Rowid);
	}	
}
function SetLocICDList(Desc,Rowid,Code,LocDiaRowId){
	var obj=document.getElementById("LocICDList");
	var obj2=document.getElementById("LocICDList2");
	var obj3=document.getElementById("LocICDList3");
	var obj4=document.getElementById("LocICDList4");
	if ((obj)&&(obj2)&&(obj3)&&(obj4)){
		var NewIndex=obj.length+obj2.length+obj3.length+obj4.length;
		if (NewIndex<30){
			obj.options[NewIndex] = new Option(Desc,Rowid);
			obj.options[NewIndex].code=Code;
			obj.options[NewIndex].LocDiaRowId=LocDiaRowId;
		}

		if ((NewIndex>29)&&(NewIndex<60)){
			obj2.options[NewIndex-30] = new Option(Desc,Rowid);
			obj2.options[NewIndex-30].code=Code;
			obj.options[NewIndex].LocDiaRowId=LocDiaRowId;
		}
		if ((NewIndex>59)&&(NewIndex<90)){
			obj3.options[NewIndex-60] = new Option(Desc,Rowid);
			obj3.options[NewIndex-60].code=Code;
			obj.options[NewIndex].LocDiaRowId=LocDiaRowId;
		}	
		if (NewIndex>89){
			obj4.options[NewIndex-90] = new Option(Desc,Rowid);
			obj4.options[NewIndex-90].code=Code;
			obj.options[NewIndex].LocDiaRowId=LocDiaRowId;
		}	
	}else{
		var NewIndex=obj.length;
		obj.options[NewIndex] = new Option(Desc,Rowid);
		obj.options[NewIndex].code=Code;
		obj.options[NewIndex].LocDiaRowId=LocDiaRowId;
	}
}

function SetMRDiagnoseList(Desc,Rowid,Code,MRDesc){
	var obj=document.getElementById("MRDiagnoseList");
	//alert(MRDesc)
	if (obj){
		var NewIndex=obj.length;
		//if ((Desc=="")&&(MRDesc!="")) 
		if (MRDesc!="") Desc=Desc+"**"+MRDesc;
		obj.options[NewIndex] = new Option(Desc,Rowid);
		obj.options[NewIndex].code=Code
	}
}
function DeleteMRDiagnosClickHandler(){
	var MRDiagnosList=document.getElementById("MRDiagnoseList");
	var selIndex=MRDiagnosList.selectedIndex;
	if (selIndex==-1) return
	MRDiagnosRowid=MRDiagnosList.options[selIndex].value;
	MRDiagnosRowid=MRDiagnosList.options[selIndex].value;
	var GetDetail=document.getElementById('GetMRDiagnosCreateUser');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	if (GetDetail!="") {
		var CreatUser=cspRunServerMethod(encmeth,MRDiagnosRowid)
		//if (CreatUser!=session['LOGON.USERID']) {  //lgl 暂时注释
			//alert(t['NotCreatUser'])
			//return;
		//}
	}
	var GetDetail=document.getElementById('DeleteMRDiagnos');
	if (GetDetail) {var encmeth=GetDetail.value} else {var encmeth=''};
	if(cspRunServerMethod(encmeth,MRDiagnosRowid)=='0') {
		//alert(selIndex);
		MRDiagnosList.options[selIndex]=null;
		if (window.parent.frames["RPbottom"]){
			window.parent.frames["RPbottom"].location=window.parent.frames["RPbottom"].location;
		}

	}else{
		alert(t['DELERROR'])
	}
}
function CloseWindow() {
	window.close();
}

function DisableFields() {
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=true;
		objRepeat.onclick=LinkDisable;
	}
}

function EnableFields()	{
	var objRepeat = document.getElementById('Repeat');
	if (objRepeat) {
		objRepeat.disabled=false;
		objRepeat.onclick=RepeatClickHandler;
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled==true) {
		return false;
	}
	return true;
}

function MRDIADesc_keydownhandler(encmeth) {
	var obj=document.getElementById("MRDIADesc");
	//lookupqryNURN,jsfuncNURN defined in epr.js
	LocateCode(obj,encmeth,0,lookupqryNURN,jsfuncNURN);
}
function MRDIADesc_lookupsel(value) {
}
function MRDIAICDCodeDR_lookuphandler(e) {
	if (evtName=='MRDIAICDCodeDR') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);

	if ((type=='click')||((type=='keydown')&&((key==117)||(key==13)))) {
		var url='websys.lookup.csp';
		url += "?ID=d50016iMRDIAICDCodeDR";
		//url += "&CONTEXT=Kweb.MRCICDDx:LookUpWithAlias";
		url += "&CONTEXT=Kweb.DHCMRDiagnos:LookUpWithAlias";
		url += "&TLUJSF=LookUpDiagnos";
		var obj=document.getElementById('MRDIAICDCodeDR');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		//var obj=document.getElementById('LocID');
		//if (obj) url += "&P2=" + websys_escape(obj.value);
		//url += "&P2=";
		//url += "&P3=" + '1';
		var obj=document.getElementById('ICDType');
		url += "&P5=" + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('MRDIAICDCodeDR');
	if (obj) obj.onkeydown=MRDIAICDCodeDR_lookuphandler;

function LookUpDiagnos(str) {
	//alert(str);
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDR");
	if (obj) obj.value=ary2[0];
	// Log 27059 - AI - 19-08-2002 : Get the RowID to pass to the Lookup.
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if (obj3) obj3.value=ary[2];
    var obj4=document.getElementById("MRCIDCodeDisplay");
    if (obj4) obj4.innerText=ary[2];    
	PrimaryDiagnChangeHandler();
	if (HospitalCode=="SG")SetNotes(ary2[0]);
}

// Log 27059 - AI - 15-08-2002 : Create the following two functions, to cater for the two new versions of Diagnosis.
// 			They are called by the relevant Items in the Component (The Item name is the Element name).
function LookUpDiagnosDescOnly(str) {
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if ((obj3)&&(obj3.value=="")) {obj3.value=ary[2];}
    var obj4=document.getElementById("MRCIDCodeDisplay");
    if (obj4) obj4.innerText=ary[2];    
	PrimaryDiagnChangeHandler();
}

function LookUpDiagnosAltDescAlias(str) {
	var ary=str.split("^");
	var ary2=ary[0].split(" | ");
	var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
	if (obj) obj.value=ary2[0];
	var obj2=document.getElementById("MRDIAICDCodeID");
	if (obj2) obj2.value=ary[1];
	var obj3=document.getElementById("MRCIDCode");
	if ((obj3)&&(obj3.value=="")) {obj3.value=ary[2];}
    var obj4=document.getElementById("MRCIDCodeDisplay");
    if (obj4) obj4.innerText=ary[2];
	PrimaryDiagnChangeHandler();
}
// end Log 27059

// ab 20.04.05 - 51254 - also changed MRDIAICDCodeID valueget in component
function AltDescBlurHandler(e) {
    // if clearing value, clear the id
    // if just updating where alt desc is blank, dont clear id
    var objprev=document.getElementById("AltDescPrevValue");
    if ((objprev)&&(objprev.value!="")) {
        var obj=document.getElementById("MRDIAICDCodeDRAltDescAlias");
        var obj2=document.getElementById("MRDIAICDCodeID");
        var obj3=document.getElementById("MRCIDCodeDisplay");
        if ((obj)&&(obj2)&&(obj.value=="")) {
            obj2.value="";
            if (obj3) obj3.innerText="";
        }
    }
}

function DiagnosisBlurHandler() {
    var obj=document.getElementById("MRDIAICDCodeDR");
    var obj2=document.getElementById("MRCIDCodeDisplay");
    if ((obj)&&(obj2)&&(obj.value=="")) {
        obj2.innerText="";
    }
}

function DiagnosisDescBlurHandler() {
    var obj=document.getElementById("MRDIAICDCodeDRDescOnly");
    var obj2=document.getElementById("MRCIDCodeDisplay");
    if ((obj)&&(obj2)&&(obj.value=="")) {
        obj2.innerText="";
    }
}

function PrimaryDiagnChangeHandler() {
	//dummy fn for custom script
}

// Log 38654 - AI - 15-04-2004 : Function to use the Description (1) for the field value, not the Code (0).
function HRGLookUp(str) {
	var lu = str.split("^");
	var obj = document.getElementById('HRGDesc')
	if (obj) obj.value=lu[1];
}

function UpdateArriveStatus(){
	var EpisodeID=""
	var obj=document.getElementById('EpisodeID');
	if (obj){EpisodeID=obj.value}
	var obj=document.getElementById('DocID');
	if (obj) {
		var	DocID=obj.value;
		var SetArrivedStatus=document.getElementById('SetArrivedStatus');
		//alert(EpisodeID+"^"+AdmReadm+"^"+PAPMIAddress);
		if (SetArrivedStatus) {var encmeth=SetArrivedStatus.value} else {var encmeth=''};
		if (encmeth!="") {
			var LogonUserID=session['LOGON.USERID']
			if (cspRunServerMethod(encmeth,EpisodeID,DocID,session['LOGON.CTLOCID'],session['LOGON.USERID'])!='1') {
				//alert('fail');
			}
		}
	}
}
function ShowOtherselectHandle()
 {
 var ShowOtherRowid=ShowOther.getSelectedValue();
 if (ShowOtherRowid==""){return;}
 
  var obj=document.getElementById("LocICDList1");
	var obj2=document.getElementById("LocICDList2");
	var obj3=document.getElementById("LocICDList3");
	var obj4=document.getElementById("LocICDList4");
	obj.options.length = 0;
	obj2.options.length = 0;
	obj3.options.length = 0;
	obj4.options.length = 0;
  var obj=document.getElementById('ICDType');
	if (obj){var ICDType=obj.value}else{var ICDType=""}
  var GetOtherLocICDList=document.getElementById('GetOtherLocICDList');
	if (GetOtherLocICDList) {var encmeth=GetOtherLocICDList.value} else {var encmeth=''};
	if (encmeth!="") {
		if (cspRunServerMethod(encmeth,'SetLocICDList',ShowOtherRowid,ICDType)!='0') {
			alert(t['LocICDListError']);
		}
 	}
 	
 }
 
 function DelLocDiagnosClickHandler()
 {
 	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LocICDList" + i);
		if (lst) DHCClearSelectedList(lst) 

	}
	return false;
 	}

function DHCClearSelectedList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) {
		if (obj.options[i].selected) {
	    MRCICDRowid=obj.options[i].value;
	    //alert(MRCICDRowid);
	    var encmeth=document.getElementById('DelLocDiagnoseMethod').value;
	    ret=cspRunServerMethod(encmeth,session['LOGON.CTLOCID'],MRCICDRowid);
	    //alert(ret)
			obj.options[i] = null;
			}
	}
}

function ShiftItemsLeft() {
	var maxlimit=MAXGROUPS+1;
	for (var i=2; i<maxlimit; i++) {
		var lstFrom = document.getElementById("LocICDList" + i);
		if (lstFrom) {
			var lstTo = null;
			var j=i-1;
			//find the next list on the screen (by number order)
			while ((!lstTo) && (j>0)) {
				lstTo = document.getElementById("LocICDList" + j);
				j--;
			}
			if (lstTo) SwapToList(lstFrom,lstTo,1);
		}
	}
	return false;
}
function ShiftItemsRight() {
	var maxlimit=MAXGROUPS+1;
	for (var i=MAXGROUPS-1; i>0; i--) {
		var lstFrom = document.getElementById("LocICDList" + i);
		if (lstFrom) {
			var lstTo = null;
			var j=i+1;
			//find the next list on the screen (by number order)
			while ((!lstTo) && (j<maxlimit)) {
				lstTo = document.getElementById("LocICDList" + j);
				j++;
			}
			if (lstTo) SwapToList(lstFrom,lstTo,1);
		}
	}
	return false;
}
function ShiftItemsUp() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LocICDList" + i);
		if (lst) {
			for (var j=1; j<lst.options.length; j++) {
				if ((lst.options[j].selected)&&(!lst.options[j-1].selected)) Swap(lst,j,j-1);
			}
		}
	}
	return false;
}
function ShiftItemsDown() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LocICDList" + i);
		if (lst) {
			for (var j=(lst.options.length-2); j>=0; j--) {
				if ((lst.options[j].selected)&&(!lst.options[j+1].selected)) Swap(lst,j,j+1);
			}
		}
	}
	return false;
}
function UnhighlightItems() {
	var maxlimit=MAXGROUPS+1;
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LocICDList" + i);
		if (lst) {
			lst.selectedIndex=-1;
		}
	}
	return false;
}
function UpdateSortid_Click()
{
	var maxlimit=MAXGROUPS+1;
	var LoopSort=1;
	var SortidStr="";
	var obj=document.getElementById("UpdateAllSortid");
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
  if(encmeth=="")
  {
  	alert("not hidden element");
  	return;
  }	
	for (var i=1; i<maxlimit; i++) {
		var lst = document.getElementById("LocICDList" + i);
		if (lst) {
			for (var j=0; j<lst.options.length; j++) {
				//if ((lst.options[j].selected)&&(!lst.options[j-1].selected)) Swap(lst,j,j-1);
				if(SortidStr=="")SortidStr=lst.options[j].value+"!"+LoopSort;
				else SortidStr=SortidStr+"^"+lst.options[j].value+"!"+LoopSort;
				LoopSort=LoopSort+1;
			}
		}
	}
	var ret=cspRunServerMethod(encmeth,SortidStr)
	if(ret=="0"){
	alert(t['UpdateSccess']);
	window.location.reload();
  }
	else {
		alert(ret);
	}

}

//update by zf
//临床路径准入提示校验,提示是否入径
function ShowCPW(MRCICDRowid,MRDiagnosRowid){
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value}
	if (EpisodeID=='') return;
	var cpwInfo=tkMakeServerCall("web.DHCCPW.MR.Interface","CheckCPWICD",EpisodeID,MRDiagnosRowid);
	if (cpwInfo){
		var arryFields = cpwInfo.split(String.fromCharCode(1));
		
		//update By chengpeng  2014/8/26 如果 一条诊断对应多个路径 默认取第一个路径
		//update start
		var VersionIDS=arryFields[1];
		var VersionDescS=arryFields[1];
		var VSIDArry=VersionIDS.split(String.fromCharCode(2));
		var VSDescArry=VersionDescS.split(String.fromCharCode(2));
		var VersionID=VSIDArry[0];
		var VersionDesc=VSIDArry[0];
		//update end
		
		var inputStr = "";                                //Rowid
		inputStr += "^" + EpisodeID;                      //Paadm
		inputStr += "^" + "";                             //PathWayID
		inputStr += "^" + "";                             //Date
		inputStr += "^" + "";                             //Time
		inputStr += "^" + session['LOGON.USERID'];        //DoctorID
		inputStr += "^" + MRCICDRowid;                    //MRCICDRowid;
		inputStr += "^" + VersionID;                      //VersionID
		inputStr += "^" + "";
		var ret=tkMakeServerCall("web.DHCCPW.MR.ClinPathWayInPathLogSrv","Update",inputStr);
		if(confirm(arryFields[0]+"是否入径?"))
		{
			var path="dhccpw.mr.clinpathway.csp?EpisodeID=" + EpisodeID + 
				"&LogID=" + ret + 
				"&CpwVerID=" + VersionID + 
				"&CpwDesc=" + VersionDesc;
			var posn="height="+top.screen.height+"px,width="+top.screen.width+"px,top=" + numTop + ",left=" + numLeft + ",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			websys_createWindow(path,false,posn);
		}else{
			var path="dhccpw.mr.notinpathway.csp?EpisodeID=" + EpisodeID +
				"&VersionID=" + VersionID;
			var numHeigth=400;
			var numWidth=400;
			var numTop=(screen.availHeight-numHeigth)/2;
			var numLeft=(screen.availWidth-numWidth)/2;
			var posn="height="+ numHeigth +",width="+ numWidth +",top=" + numTop + ",left=" + numLeft + ",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			websys_createWindow(path,false,posn);
		}
	}
}
 /*function ShowCPW(MRCICDRowid,MRDiagnosRowid){
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value}
	if (EpisodeID=='') return;
	var cpwInfo=tkMakeServerCall("web.DHCCPW.MR.Interface","CheckCPWICD",EpisodeID,MRDiagnosRowid);
	if (cpwInfo){
		var arryFields = cpwInfo.split(String.fromCharCode(1));
		var VersionID=arryFields[1];
		
		var inputStr = "";                                //Rowid
		inputStr += "^" + EpisodeID;                      //Paadm
		inputStr += "^" + "";                             //PathWayID
		inputStr += "^" + "";                             //Date
		inputStr += "^" + "";                             //Time
		inputStr += "^" + session['LOGON.USERID'];        //DoctorID
		inputStr += "^" + MRCICDRowid;                    //MRCICDRowid;
		inputStr += "^" + VersionID;                      //VersionID
		inputStr += "^" + "";
		var ret=tkMakeServerCall("web.DHCCPW.MR.ClinPathWayInPathLogSrv","Update",inputStr);
		if(confirm(arryFields[0]+"是否入径?"))
		{
			var path="dhccpw.mr.clinpathway.csp?EpisodeID=" + EpisodeID + 
				"&LogID=" + ret + 
				"&CpwVerID=" + VersionID + 
				"&CpwDesc=" + arryFields[2];
			var posn="height="+top.screen.height+"px,width="+top.screen.width+"px,top=" + numTop + ",left=" + numLeft + ",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			websys_createWindow(path,false,posn);
		}else{
			var path="dhccpw.mr.notinpathway.csp?EpisodeID=" + EpisodeID +
				"&VersionID=" + VersionID;
			var numHeigth=400;
			var numWidth=400;
			var numTop=(screen.availHeight-numHeigth)/2;
			var numLeft=(screen.availWidth-numWidth)/2;
			var posn="height="+ numHeigth +",width="+ numWidth +",top=" + numTop + ",left=" + numLeft + ",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			websys_createWindow(path,false,posn);
		}
	}
}*/

document.body.onload = BodyLoadHandler;


function CheckDisease(MRDiagnosRowid){
	var obj=document.getElementById('EpisodeID');
	if (obj){var EpisodeID=obj.value};
	var obj=document.getElementById('PatientID');
	if (obj){var PatientID=obj.value};
	if (EpisodeID=='') return;
	var icdInfo=tkMakeServerCall("DHCMed.EPDService.Service","CheckDiagnosToEpd",EpisodeID);
	if (icdInfo){
		var tmpList=icdInfo.split("^");
		if (tmpList.length>=1){
			//alert(tmpList[0]);//测试
			if (tmpList[0]=='0'){
				//提示报卡
				var ret=window.confirm(tmpList[2]);
				if (ret){
					var strUrl = "./dhcmed.epd.report.csp?" + 
						"PatientID=" + PatientID +
						"&EpisodeID=" + EpisodeID +
						"&IFRowID=" + tmpList[1] +
						"&LocFlag=0";
					//window.open(strUrl, "_blank" ,"height=600,width=850,left=50,top=50,status=yes,toolbar=no,menubar=no,location=no");
					var retValue = window.showModalDialog(
							strUrl,
							"",
							"dialogHeight: 620px; dialogWidth: 900px");
					if (!retValue){
						//传染病保存失败,删除传染病
						//CheckDisease();
						DeleteMRDiagnos(MRDiagnosRowid);
					}
				}
			}else if (tmpList[0]=='1'){
				//强制报卡
				alert(tmpList[2]);
				var strUrl = "./dhcmed.epd.report.csp?" + 
					"PatientID=" + PatientID +
					"&EpisodeID=" + EpisodeID +
					"&IFRowID=" + tmpList[1] +
					"&LocFlag=0";
				//window.open(strUrl, "_blank" ,"height=600,width=850,left=50,top=50,status=yes,toolbar=no,menubar=no,location=no");
				var retValue = window.showModalDialog(
						strUrl,
						"",
						"dialogHeight: 620px; dialogWidth: 900px");
				if (!retValue){
					//传染病保存失败,删除传染病
					//CheckDisease();
					DeleteMRDiagnos(MRDiagnosRowid);
				}
			}else if (tmpList[0]=='2'){ //add by liuxuefeng 2011-10-17 提示报卡alert模式
				//提示报卡
				var ret=window.alert(tmpList[2]);
				return
			}
		}
	}
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       