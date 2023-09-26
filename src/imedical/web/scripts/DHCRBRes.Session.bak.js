var SelectedRow=0;

document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {
	
	var obj=document.getElementById("ResDoc");
	if (obj){obj.onchange=ResDocchangehandler;}
	
	var obj=document.getElementById("ResEffectDate");
	if (obj){obj.onchange=ResEffectDatechangehandler;}
	
	var obj=document.getElementById("Add");
	if (obj){obj.onclick=AddClickHandler;}	
	
	var obj=document.getElementById("Delete");
	if (obj){obj.onclick=DeleteClickHandler;}	
	
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=UpdateClickHandler;}	
	
	var obj=document.getElementById("Service");
	if (obj){obj.onclick=ServiceClickHandler;}	

	var obj=document.getElementById("APPQty");
	if (obj){obj.onclick=AppQtyClickHandler;}	

	var obj=document.getElementById("NotAvail");
	if (obj){obj.onclick=NotAvailClickHandler;}	

	var obj=document.getElementById("SessNotAvail");
	if (obj){obj.onclick=SessNotAvailClickHandler;}	

	var obj=document.getElementById("AddEffDate");
	if (obj){obj.onclick=AddEffDateClickHandler;}	

	var obj=document.getElementById("DeleteEffDate");
	if (obj){obj.onclick=DeleteEffDateClickHandler;}	

	var obj=document.getElementById('Loc');
	if (obj) obj.onkeypress=DHCWeb_LookUpItemTransKeyPress;
	
	var obj=document.getElementById('ResEffectDate');
	if (obj) obj.onkeypress=keydownhandler;
	
	var obj=document.getElementById('PutTimeStart');
	if (obj) obj.onkeydown=keydownhandler;

	var obj=document.getElementById('PutTimeEnd');
	if (obj) obj.onkeydown=keydownhandler;

	var obj=document.getElementById('PutSlotLength');
	if (obj) obj.onkeydown=keydownhandler;


	var obj=document.getElementById('PutRoom');
	if (obj) obj.onkeypress=DHCWeb_LookUpItemTransKeyPress;

	var obj=document.getElementById('PutLoad');
	if (obj) obj.onkeydown=keydownhandler;
	
	var obj=document.getElementById('PutNoApptSlot');
	if (obj) obj.onkeydown=keydownhandler;

	var obj=document.getElementById('PutNoOverbookAll');
	if (obj) obj.onkeydown=keydownhandler;
	
	var obj=document.getElementById('PutNumberOfWeeks');
	if (obj) obj.onkeydown=keydownhandler;

	var obj=document.getElementById('PutDOW');
	if (obj) obj.onkeypress=keydownhandler;;

	var obj=document.getElementById('PutClinicGroup');
	if (obj) obj.onkeypress=keydownhandler;;

 //星期初始化
  var DOWStr="";
	var encmeth=DHCC_GetElementData('GetDOWMethod');
	if (encmeth!=''){DOWStr=cspRunServerMethod(encmeth);}
	ComboDOW=dhtmlXComboFromStr("PutDOW",DOWStr);
	ComboDOW.enableFilteringMode(true);
	ComboDOW.selectHandle=ComboDOWselectHandle;	
	//DHCC_SetListStyle("PutDOW",false);
	//DHCC_AddItemToListByStr("PutDOW",DOWStr)
	
	//出诊级别初始化
  var SessionTypeStr="";
	var encmeth=DHCC_GetElementData('GetSessionTypeStrMethod');
	if (encmeth!=''){SessionTypeStr=cspRunServerMethod(encmeth);}
	ComboType=dhtmlXComboFromStr("PutType",SessionTypeStr);
	ComboType.enableFilteringMode(true);
	ComboType.selectHandle=ComboTypeselectHandle;	

	//DHCC_SetListStyle("PutType",false);
	//DHCC_AddItemToListByStr("PutType",SessionTypeStr)
	//var obj=document.getElementById('PutType');
	//if (obj) obj.onkeypress=keydownhandler;

	var TimeRangeStr=DHCC_GetElementData('TimeRangeStr');
	PutTimeRange=dhtmlXComboFromStr("PutTimeRange",TimeRangeStr);
	PutTimeRange.enableFilteringMode(true);
    PutTimeRange.selectHandle=PutTimeRangeselectHandle;
 

	var DepStr=DHCC_GetElementData('DepStr');
	ComboLoc=dhtmlXComboFromStr("ComboLoc",DepStr);
	ComboLoc.enableFilteringMode(true);
	ComboLoc.selectHandle=ComboLocselectHandle;
	
	var RoomStr=DHCC_GetElementData('RoomStr');
	ComboRoom=dhtmlXComboFromStr("ComboRoom",RoomStr);
	ComboRoom.enableFilteringMode(true);
	
	/*
	//出诊时段初始化
  var SessionTimeRangeStr="";
	var encmeth=DHCC_GetElementData('GetSessionTimeRangeStrMethod');
	if (encmeth!=''){SessionTimeRangeStr=cspRunServerMethod(encmeth);}
	var obj=document.getElementById("PutSessNo");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
		obj.options[obj.length] = new Option("","")
		var ArrData=SessionTimeRangeStr.split("^");
		for (var i=0;i<ArrData.length;i++) {
		 var ArrData1=ArrData[i].split(String.fromCharCode(1));
		 obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
		}
		obj.selectedIndex=-1;
	}	
	*/
	
	ComboClinicGroup=dhtmlXComboFromStr("PutClinicGroup",'');
	ComboClinicGroup.enableFilteringMode(true);
	ComboClinicGroup.selectHandle=ComboClinicGroupselectHandle;
	
	
	//分时段就诊
	var obj=document.getElementById("TRFlag");
	if (obj) obj.onchange=TRFlag_change;
	if (obj) obj.onclick=TRFlag_click;
	SetTRDisabled(true);
	
		   
}
function TRFlag_click()
{ 
	var chkTRFlag=document.getElementById("TRFlag")
	if (chkTRFlag.checked){
		var ETimeStart=document.getElementById("PutTimeStart").value
		var ETimeEnd=document.getElementById("PutTimeEnd").value
		document.getElementById("TRStartTime").value=ETimeStart
		document.getElementById("TREndTime").value=ETimeEnd
		
	}else{
		document.getElementById("TRStartTime").value=""
		document.getElementById("TREndTime").value=""
	}
}

function EnterKey(e)
{
	var AltKey=websys_getAlt(e);
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (AltKey && (keycode==65)){
		try {
			AddClickHandler();
		}
		catch(e) {}
	}
	if (AltKey && (keycode==75)){
		try {
			DeleteClickHandler();
		}
		catch(e) {}
	}
	if (AltKey && (keycode==85)){
		try {
			UpdateClickHandler();
		}
		catch(e) {}
	}
	if (AltKey && (keycode==83)){
		try {
			ServiceClickHandler();
		}
		catch(e) {}
	}
	if (AltKey && (keycode==80)){
		try {
			AppQtyClickHandler()
		}
		catch(e) {}
	}
}
document.body.onkeydown=EnterKey;
function TRFlag_change(){
	var obj=document.getElementById("TRFlag");
	if (obj){
		SetTRDisabled(!obj.checked);
	}
}
function SetTRDisabled(value){
	var obj=document.getElementById("TRStartTime");
	if (obj) obj.disabled=value;
	var obj=document.getElementById("TREndTime");
	if (obj) obj.disabled=value;
	var obj=document.getElementById("TRLength");
	if (obj) obj.disabled=value;
	var obj=document.getElementById("TRRegNum");
	if (obj) obj.disabled=value;
	var obj=document.getElementById("TRRegNumStr");
	if (obj) obj.disabled=value;
	var obj=document.getElementById("TRRegInfoStr");
	if (obj) obj.disabled=value;
}
function PutTimeRangeselectHandle()
{ 	
    var TRRowId=PutTimeRange.getSelectedValue();
	var TRDesc=PutTimeRange.getSelectedText();
	var encmeth=DHCC_GetElementData('GetTRTimeStrMethod');
	if (encmeth!=''){
		var ret=cspRunServerMethod(encmeth,TRRowId);
		var Arr=ret.split("^");
		var SessTimeStart=Arr[0];
		var SessTimeEnd=Arr[1];
		
	}
 	var obj=document.getElementById("PutTimeStart")
	if (obj){obj.value=SessTimeStart;}
	var obj=document.getElementById("PutTimeEnd")
	if (obj){obj.value=SessTimeEnd;	}
	var obj=document.getElementById("TRStartTime")
	if (obj){obj.value=SessTimeStart;}
	var obj=document.getElementById("TREndTime")
	if (obj){obj.value=SessTimeEnd;	}
	
}
	
function ComboDOWselectHandle(e){
	DHCC_Nextfoucs();
}
function ComboTypeselectHandle(e){
	DHCC_Nextfoucs();
}

function ComboLocselectHandle(){
	try {
		var LocID=ComboLoc.getSelectedValue();

		SetResDocList(LocID);
		InitClinicGroupStr(LocID);
		DHCC_Nextfoucs();
	}catch(e){
		alert(e.message);
	}
}
function keydownhandler(e){
	DHCC_Nextfoucs();
}

function Add_click(){
	AddClickHandler();
}
function Update_click(){
	UpdateClickHandler();
}
function Delete_click(){
	DeleteClickHandler();
}
function Service_click(){
	ServiceClickHandler();
}
function AppQt_click(){
	AppQtyClickHandler();
}
function AddEffDate_click(){
	AddEffDateClickHandler();
}

function DeleteEffDate_click(){
	DeleteEffDateClickHandler();
}
function CheckBeforeUpdate(){
	var SessLoad=DHCC_GetElementData("PutLoad");
	var SessNoSlots=DHCC_GetElementData("PutNoSlots");
	var SessNoApptSlot=DHCC_GetElementData("PutNoApptSlot");
	//var PutRoomRowId=ComboRoom.getSelectedValue();
	//var PutDOWRowId=DHCC_GetElementData("PutDOW");
	var PutRoomRowId=ComboRoom.getSelectedValue()
	var PutDOWRowId=ComboDOW.getSelectedValue()
	var PutNumberOfWeeks=DHCC_GetElementData("PutNumberOfWeeks");
	if (SessLoad==""){SessLoad=0}
	if (SessNoApptSlot==""){SessNoApptSlot=0}
	if (PutNumberOfWeeks==""){PutNumberOfWeeks=0}

	var TRValue=PutTimeRange.getSelectedValue();
	if (TRValue==""){
		alert(t['TimeRangeIsNull']);
		return false;
	}

	if (parseFloat(SessNoApptSlot)>(parseFloat(SessLoad)-parseFloat(PutNumberOfWeeks)+1)){
		alert(t['AppMorethanAppable']);
		return false;
	}

	if (parseFloat(SessNoApptSlot)>parseFloat(SessLoad)){
		alert(t['AppMorethanLoad']);
		return false;
	}

	
	var obj=document.getElementById("ResEffectDate");
	if (obj.selectedIndex==-1){
		alert(t['NotSelectResEffectDate']);
		return false;
	}

	if (PutDOWRowId=="") {
		alert(t['WeekIsNull']);
		ComboDOW.setfocus();
		return false;
	}	

	/*
	if (PutRoomRowId=="") {
		alert(t['RoomIsNull']);
		//websys_setfocus('ComobRoom');
		ComboRoom.setfocus();
		return false;
	}
	*/
	return true;
}

function AddClickHandler(e){
	var check=CheckBeforeUpdate();
	if (!check) return websys_cancel();
	
   
	var TRRowId=PutTimeRange.getSelectedValue();
	var TRDesc=PutTimeRange.getSelectedText();
	 /*
	var encmeth=DHCC_GetElementData('GetTRTimeStrMethod');
	if (encmeth!=''){
		var ret=cspRunServerMethod(encmeth,TRRowId);
		var Arr=ret.split("^");
		var SessTimeStart=Arr[0];
		var SessTimeEnd=Arr[1];
	}
    */
    var SessTimeStart=DHCC_GetElementData("PutTimeStart");
	var SessTimeEnd=DHCC_GetElementData("PutTimeEnd");
	var Arr1=TRDesc.split("-");
	TRDesc=Arr1[0]; 
	SessNo=TRRowId+String.fromCharCode(1)+TRDesc;

	//var PutDOWRowId=DHCC_GetElementData("PutDOW");
	var PutDOWRowId=ComboDOW.getSelectedValue();
	var PutDOWDesc=ComboDOW.getSelectedText();
	var rows=sessobjtbl.rows.length;
	for (var i=1; i<rows; i++){
		//if (i==SelectedRow){continue}
		var Row=GetRow(sessobjtbl,i);
		var SessDOWRowid=GetColumnData("SessDOWRowid",Row);
		var SessRoomRowid=GetColumnData("SessRoomRowid",Row);
		var SessTRRowid=GetColumnData("SessNoCode",Row);
		if ((SessDOWRowid==PutDOWRowId)&&(SessTRRowid==TRRowId)){
			alert(t['SameWeekTimeRange']);
			return websys_cancel();
		}
	}		
	var TRFlag="N",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="";
	TRFlag=DHCC_GetElementData("TRFlag");
	if (TRFlag){
		TRFlag="Y";
		TRStartTime=DHCC_GetElementData("TRStartTime");
		TREndTime=DHCC_GetElementData("TREndTime");
		TRLength=DHCC_GetElementData("TRLength");
		TRRegNum=DHCC_GetElementData("TRRegNum");
		if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum)) return websys_cancel();
		TRRegNumStr=DHCC_GetElementData("TRRegNumStr");
		TRRegInfoStr=DHCC_GetElementData("TRRegInfoStr");
	}else{
		TRFlag="N";
	}
	//var SessDOW=GetValue("PutDOW");
	var SessDOW=PutDOWRowId+String.fromCharCode(1)+PutDOWDesc;
	
	//var SessNo=DHCC_GetElementData("PutSessNo");


	var SessSlotLength=DHCC_GetElementData("PutSlotLength");
	var SessLoad=DHCC_GetElementData("PutLoad");
	var SessNoSlots=DHCC_GetElementData("PutNoSlots");
	var SessNoApptSlot=DHCC_GetElementData("PutNoApptSlot");
	var SessNumberOfWeeks=DHCC_GetElementData("PutNumberOfWeeks");
	var SessNoOverbookAll=DHCC_GetElementData("PutNoOverbookAll");
	
	var SessRoomRowId=ComboRoom.getSelectedValue();
	var SessRoomDesc=ComboRoom.getSelectedText();
	var SessRoom=SessRoomRowId+String.fromCharCode(1)+SessRoomDesc;
	
	//var SessType=GetValue("PutType");
	var sessTypeRowId=ComboType.getSelectedValue();
	var sessTypeDesc=ComboType.getSelectedText();
	var SessType=sessTypeRowId+String.fromCharCode(1)+sessTypeDesc;
	
	//var SessClinicGroup=GetValue("PutClinicGroup");
	var SessClinicGroupRowId=ComboClinicGroup.getSelectedValue();
	var SessClinicGroupDesc=ComboClinicGroup.getSelectedText();
	var SessClinicGroup=SessClinicGroupRowId+String.fromCharCode(1)+SessClinicGroupDesc;

	var SessScheduleGenerFlag=DHCC_GetElementData("PutScheduleGenerFlag");
	if (SessScheduleGenerFlag) {SessScheduleGenerFlag="Y"}else{SessScheduleGenerFlag="N"}
	
	var SessPatientType="O";
	if (SessLoad==""){SessLoad=0}
	if (SessNoApptSlot==""){SessNoApptSlot=0}

	SessNoSlots=SessLoad-SessNoApptSlot;
	var InsertData=""+"^"+SessDOW+"^"+SessTimeStart+"^"+SessTimeEnd+"^"+SessSlotLength+"^"+SessLoad+"^"+SessNoSlots+"^"+SessNoApptSlot;
	InsertData=InsertData+"^"+SessNumberOfWeeks+"^"+SessNoOverbookAll+"^"+SessRoom+"^"+SessType+"^"+SessClinicGroup+"^"+SessPatientType+"^"+SessNo+"^"+SessScheduleGenerFlag;
    InsertData=InsertData+"^"+TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr
	var encmeth=DHCC_GetElementData('InsertMethod');
	if (encmeth!=''){
		var obj=document.getElementById("ResEffectDate");
		if (obj.selectedIndex!=-1){
			var ResDateRowid=obj.options[obj.selectedIndex].value;
			var ret=cspRunServerMethod(encmeth,ResDateRowid,InsertData);
			var temparr=ret.split("^");
			var retcode=temparr[0];
			if (retcode==0){
				var SessRowId=temparr[1];
				var temparr=InsertData.split("^");
				temparr[0]=SessRowId;
				InsertData=temparr.join("^");
				AddToResSessionTable(InsertData);
				ClearValue();
				var rowObj=sessobjtbl.rows[SelectedRow];
				rowObj.className=rowObj.PrevClassName;
				SelectedRow=0;
				try{
					if (SessRowId=="") return websys_cancel();
					if (SessNoApptSlot==0) return websys_cancel();
					var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.AppQty&ResSessRowId="+SessRowId;
					websys_lu(url,false,"status=1,scrollbars=1,top=50,left=100,width=400,height=400");
				}catch(e){
					alert(e.message)
				}
				SetResDocDetail(SessRowId.split('||')[0]);
				
				return websys_cancel();
			}else{
				if (retcode=="-201"){
					alert(t['SameTimeRangeRoom']+":"+temparr[1]);
				}else{
					alert(t['Fail_Insert']);
				}
				return websys_cancel();
			}
		}
	}	
}

function UpdateClickHandler(e){
	if (SelectedRow==0){return websys_cancel();}
	try{
		var check=CheckBeforeUpdate();
		if (!check) return websys_cancel();
		var PutRoomRowId=ComboRoom.getSelectedValue();
		//var PutDOWRowId=DHCC_GetElementData("PutDOW");
		
		var PutDOWRowId=ComboDOW.getSelectedValue();
		var PutDOWDesc=ComboDOW.getSelectedText();
		
		var TRRowId=PutTimeRange.getSelectedValue();
		var TRDesc=PutTimeRange.getSelectedText();

		var rows=sessobjtbl.rows.length;
		for (var i=1; i<rows; i++){
			if (i==SelectedRow){continue}
			var Row=GetRow(sessobjtbl,i);
			var SessDOWRowid=GetColumnData("SessDOWRowid",Row);
			var SessRoomRowid=GetColumnData("SessRoomRowid",Row);
			var SessTRRowid=GetColumnData("SessNoCode",Row);
			if ((SessDOWRowid==PutDOWRowId)&&(SessTRRowid==TRRowId)){
				alert(t['SameWeekTimeRange']);
				return websys_cancel();
			}
		}		
		var TRFlag="N",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="";
		TRFlag=DHCC_GetElementData("TRFlag");
		if (TRFlag){
			TRFlag="Y";
			TRStartTime=DHCC_GetElementData("TRStartTime");
			TREndTime=DHCC_GetElementData("TREndTime");
			TRLength=DHCC_GetElementData("TRLength");
			TRRegNum=DHCC_GetElementData("TRRegNum");
			if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum)) return websys_cancel();
			TRRegNumStr=DHCC_GetElementData("TRRegNumStr");
			TRRegInfoStr=DHCC_GetElementData("TRRegInfoStr");
		}else{
			TRFlag="N";
		}
	  	var Row=GetRow(sessobjtbl,SelectedRow);	
		var SessRowid=GetColumnData("SessRowid",Row);
	
		//var SessDOW=GetValue("PutDOW");
		var SessDOW=PutDOWRowId+String.fromCharCode(1)+PutDOWDesc;
        /*
		var encmeth=DHCC_GetElementData('GetTRTimeStrMethod');
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,TRRowId);
			var Arr=ret.split("^");
			var SessTimeStart=Arr[0];
			var SessTimeEnd=Arr[1];
		}
		*/
	    var SessTimeStart=DHCC_GetElementData("PutTimeStart");
	    var SessTimeEnd=DHCC_GetElementData("PutTimeEnd");
		var Arr1=TRDesc.split("-");
		TRDesc=Arr1[0];
		SessNo=TRRowId+String.fromCharCode(1)+TRDesc;
		
		//var SessTimeStart=GetValue("PutTimeStart");
		//var SessTimeEnd=GetValue("PutTimeEnd");
		//var SessNo=GetValue("PutSessNo");
		var SessSlotLength=GetValue("PutSlotLength");
		var SessLoad=GetValue("PutLoad");
		var SessNoSlots=GetValue("PutNoSlots");
		var SessNoApptSlot=GetValue("PutNoApptSlot");
		var SessNumberOfWeeks=GetValue("PutNumberOfWeeks");
		var SessNoOverbookAll=GetValue("PutNoOverbookAll");

		var SessRoomRowId=ComboRoom.getSelectedValue();
		var SessRoomDesc=ComboRoom.getSelectedText();
		var SessRoom=SessRoomRowId+String.fromCharCode(1)+SessRoomDesc;

		//var SessType=GetValue("PutType");
		var sessTypeRowId=ComboType.getSelectedValue();
		var sessTypeDesc=ComboType.getSelectedText();
		var SessType=sessTypeRowId+String.fromCharCode(1)+sessTypeDesc;
	
		//var SessClinicGroup=GetValue("PutClinicGroup");
		var SessClinicGroupRowId=ComboClinicGroup.getSelectedValue();
		var SessClinicGroupDesc=ComboClinicGroup.getSelectedText();
		var SessClinicGroup=SessClinicGroupRowId+String.fromCharCode(1)+SessClinicGroupDesc;
		
		var SessPatientType="O";
		
		SessNoSlots=SessLoad-SessNoApptSlot;

		var SessScheduleGenerFlag=DHCC_GetElementData("PutScheduleGenerFlag");
		if (SessScheduleGenerFlag) {SessScheduleGenerFlag="Y"}else{SessScheduleGenerFlag="N"}

		var UpdateData=SessRowid+"^"+SessDOW+"^"+SessTimeStart+"^"+SessTimeEnd+"^"+SessSlotLength+"^"+SessLoad+"^"+SessNoSlots+"^"+SessNoApptSlot;
		UpdateData=UpdateData+"^"+SessNumberOfWeeks+"^"+SessNoOverbookAll+"^"+SessRoom+"^"+SessType+"^"+SessClinicGroup+"^"+SessPatientType+"^"+SessNo+"^"+SessScheduleGenerFlag;
		UpdateData=UpdateData+"^"+TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr
	
		var encmeth=DHCC_GetElementData('UpdateMethod');
		if (encmeth!=''){
			var obj=document.getElementById("ResEffectDate");
			if (obj.selectedIndex!=-1){
				var ResDateRowid=obj.options[obj.selectedIndex].value;
				var ret=cspRunServerMethod(encmeth,UpdateData);
				var temparr=ret.split("^");
				var retcode=temparr[0];
				if (retcode==0){
					UpdateToResSessionTable(Row,UpdateData)
					ClearValue();
					var rowObj=sessobjtbl.rows[SelectedRow];
					//rowObj.className=rowObj.PrevClassName;
					selectedRowObj=new Object();
					selectedRowObj.rowIndex="";
					SelectedRow=0;
					return websys_cancel();
				}else{
					if (retcode=="-201"){
						alert(t['SameTimeRangeRoom']+":"+temparr[1]);
					}else{
						alert(t['Fail_Update']);
					}
					return websys_cancel();
				}
			}
		}
	}catch(e){
		alert(e.message)
	}
}

function DeleteClickHandler(e){
	if (SelectedRow==0){return websys_cancel();}
	try{
	  var Row=GetRow(sessobjtbl,SelectedRow);	
		var SessRowid=GetColumnData("SessRowid",Row);
	
		var obj=document.getElementById('DeleteMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
			var obj=document.getElementById("ResEffectDate");
			if (obj.selectedIndex!=-1){
				var ResDateRowid=obj.options[obj.selectedIndex].value;
				var retcode=cspRunServerMethod(encmeth,SessRowid);
				if (retcode==0){
					DeleteTabRow(sessobjtbl,SelectedRow)
					ClearValue();
					SelectedRow=0;
					return websys_cancel();
				}else{
					alert(t['Fail_Delete']);
					return websys_cancel();
				}
			}
		}
	}catch(e){
		alert(e.message)
	}
}


function AddEffDateClickHandler(e){
	var ResEffectDate=GetValue("EffectDate");
	if (ResEffectDate==""){
		alert(t['EffectDateIsNull']);
		return websys_cancel();
	}
	
	var ResRowid="";
	var obj=document.getElementById("ResDoc");
	if (obj.selectedIndex!=-1){ResRowid=obj.options[obj.selectedIndex].value;}
	if (ResRowid==""){
		alert(t['ResourceIsNull']);
		return websys_cancel();
	}

	var InsertData=ResEffectDate;
	
	var obj=document.getElementById('InsertEffDateMethod');
	if (obj) {var encmeth=obj.value;}else{var encmeth=""}
	//alert("encmeth:"+encmeth);
	//alert("ResEffectDate:"+ResEffectDate);
	if (encmeth!=''){
		var retcode=cspRunServerMethod(encmeth,ResRowid,InsertData);
		if (retcode.split('^')[0]==0){
				ResDocchangehandler();
		}else{
			alert(t['Fail_Insert']);
			return websys_cancel();
		}
	}	
}

function DeleteEffDateClickHandler(e){
	var ResEffectDate=GetValue("ResEffectDate");
	if (ResEffectDate==""){
		return websys_cancel()
	}
	var ContiuCheck=confirm((t['ConfirmDelResEffectDate']),false);
	if (ContiuCheck==false) return websys_cancel();		

	var InsertData=ResEffectDate;
	
	var obj=document.getElementById('DeleteEffDateMethod');
	if (obj) {var encmeth=obj.value;}else{var encmeth=""}
	if (encmeth!=''){
		var retcode=cspRunServerMethod(encmeth,InsertData);
		if (retcode==0){
				ResDocchangehandler();
		}else{
			alert(t['Fail_Insert']);
			return websys_cancel();
		}
	}	
}

function ServiceClickHandler(e){
	try{
	  var Row=GetRow(sessobjtbl,SelectedRow);	
		var SessRowid=GetColumnData("SessRowid",Row);
		if (SessRowid=="") {
			alert("请选择有效的排班记录.");
			return websys_cancel();
		}
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.Services&ResSessRowId="+SessRowid;
		websys_lu(url,false,"status=1,scrollbars=1,top=50,left=10,width=400,height=400");
	}catch(e){
		alert(e.message)
	}
}

function AppQtyClickHandler(e){
	try{
	  var Row=GetRow(sessobjtbl,SelectedRow);	
		var SessRowid=GetColumnData("SessRowid",Row);
		if (SessRowid=="") {
			alert("请选择有效的排班记录.");
			return websys_cancel();
		}
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.AppQty&ResSessRowId="+SessRowid;
		websys_lu(url,false,"status=1,scrollbars=1,top=50,left=100,width=400,height=400");
	}catch(e){
		alert(e.message)
	}
	
	return websys_cancel();
}

function NotAvailClickHandler(e){
	try{
		var obj=document.getElementById("ResDoc");
		if (obj.selectedIndex==-1) {
			alert("请选择医生.");
			return websys_cancel();
		}
		var ResRowid=obj.options[obj.selectedIndex].value;
		//alert(ResRowid);
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.NotAvail&ResRowId="+ResRowid;
		websys_lu(url,false,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
	}catch(e){
		alert(e.message)
	}
	return websys_cancel();
}

function SessNotAvailClickHandler(e){
	try{
	  var Row=GetRow(sessobjtbl,SelectedRow);	
		var SessRowid=GetColumnData("SessRowid",Row);
		if (SessRowid=="") {
			alert("请选择有效的排班记录.");
			return websys_cancel();
		}
		var url="websys.default.csp?WEBSYS.TCOMPONENT=DHCRBRes.Session.NotAvail&ResSessRowId="+SessRowid;
		websys_lu(url,false,"status=1,scrollbars=1,top=50,left=10,width=1000,height=530");
	}catch(e){
		alert(e.message)
	}
	return websys_cancel();
}

function ResEffectDatechangehandler(e){
	var obj=document.getElementById("ResEffectDate");
	var ResDateRowid=obj.options[obj.selectedIndex].value;
	SetSessionTable(ResDateRowid);
}

function SetSessionTable(ResDateRowid){
	var obj=document.getElementById('GetResSessionMethod');
	if (obj) {
		var encmeth=obj.value;
		//alert("encmeth:"+encmeth);
		if (encmeth!=''){
			ClearTable(sessobjtbl);
			var retDetail=cspRunServerMethod(encmeth,"AddToResSessionTable",ResDateRowid);
			if (retDetail==1) return websys_cancel();
		}
	}	
}

function UpdateToResSessionTable(Row,val){
	try{
		var Split_Value=val.split("^");
		var SessRowid=Split_Value[0];
		
		var TempArr=Split_Value[1].split(String.fromCharCode(1));
		var SessDOWRowid=TempArr[0];
		var SessDOW=TempArr[1];
		
		var SessTimeStart=Split_Value[2];
		var SessTimeEnd=Split_Value[3];
		var SessSlotLength=Split_Value[4];
		var SessLoad=Split_Value[5];
		var SessNoSlots=Split_Value[6];
		var SessNoApptSlot=Split_Value[7];
		var SessNumberOfWeeks=Split_Value[8];
		var SessNoOverbookAll=Split_Value[9];
		
		var TempArr=Split_Value[10].split(String.fromCharCode(1));;
		var SessRoomRowid=TempArr[0];
		var SessRoom=TempArr[1];
		
		var TempArr=Split_Value[11].split(String.fromCharCode(1));;
		var SessTypeRowid=TempArr[0];
		var SessType=TempArr[1];

		var TempArr=Split_Value[12].split(String.fromCharCode(1));;
		var SessClinicGroupRowid=TempArr[0];
		var SessClinicGroup=TempArr[1];

		var SessPatientType=Split_Value[13];
	
		var TempArr=Split_Value[14].split(String.fromCharCode(1));;
		var SessNoCode=TempArr[0];
		var SessNo=TempArr[1];
		
		var SessScheduleGenerFlag=Split_Value[15]
		
		var TRFlag=Split_Value[16]
		var TRStartTime=Split_Value[17]
		var TREndTime=Split_Value[18]
		var TRLength=Split_Value[19]
		var TRRegNum=Split_Value[20]
		var TRRegNumStr=Split_Value[21]
		var TRRegInfoStr=Split_Value[22]
		
		SetColumnData("SessRowid",Row,SessRowid);
		SetColumnData("SessDOW",Row,SessDOW);
		SetColumnData("SessTimeStart",Row,SessTimeStart);
		SetColumnData("SessTimeEnd",Row,SessTimeEnd);
		SetColumnData("SessSlotLength",Row,SessSlotLength);
		SetColumnData("SessLoad",Row,SessLoad);
		SetColumnData("SessNoSlots",Row,SessNoSlots);
		SetColumnData("SessNoApptSlot",Row,SessNoApptSlot);
		SetColumnData("SessNumberOfWeeks",Row,SessNumberOfWeeks);
		SetColumnData("SessNoOverbookAll",Row,SessNoOverbookAll);
		SetColumnData("SessRoom",Row,SessRoom);
		SetColumnData("SessType",Row,SessType);
		SetColumnData("SessClinicGroup",Row,SessClinicGroup);
		SetColumnData("SessRoomRowid",Row,SessRoomRowid);
		SetColumnData("SessTypeRowid",Row,SessTypeRowid);
		SetColumnData("SessClinicGroupRowid",Row,SessClinicGroupRowid);
		SetColumnData("SessDOWRowid",Row,SessDOWRowid);
		SetColumnData("SessNo",Row,SessNo);
		SetColumnData("SessNoCode",Row,SessNoCode);
		if (SessScheduleGenerFlag=="N"){SessScheduleGenerFlag=false}else{SessScheduleGenerFlag=true}
		SetColumnData("SessScheduleGenerFlag",Row,SessScheduleGenerFlag);		
		if (TRFlag=="Y"){TRFlag=true}else{TRFlag=false}
		SetColumnData("TTRFlag",Row,TRFlag);
		SetColumnData("TTRStartTime",Row,TRStartTime);
		SetColumnData("TTREndTime",Row,TREndTime);
		SetColumnData("TTRLength",Row,TRLength);
		SetColumnData("TTRRegNum",Row,TRRegNum);
		SetColumnData("TTRRegNumStr",Row,TRRegNumStr);
		SetColumnData("TTRRegInfoStr",Row,TRRegInfoStr);
		if (!SessScheduleGenerFlag){
			sessobjtbl.rows[Row].className="clsRowAlert";
		}else{
			if ((Row)%2==0) {sessobjtbl.rows[Row].className="RowEven";} else {sessobjtbl.rows[Row]}
		}
	}catch(e){
		alert(e.message)
	}
}
function AddToResSessionTable(val){
	try{
		//alert(val);
		var rows=sessobjtbl.rows.length;
		if (rows==2) {
			var SessRowid=GetColumnData("SessRowid",1);
			if (SessRowid!=""){AddRowToTable(sessobjtbl);}
		}else{
			AddRowToTable(sessobjtbl);
		}
		rows=sessobjtbl.rows.length;
		var AddRow=rows-1;
	  var Row=GetRow(sessobjtbl,AddRow);
	  
		UpdateToResSessionTable(Row,val)
	}catch(e){
		alert(e.message);
	}
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=sessobjtbl;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
	  var Row=GetRow(objtbl,selectrow);	
		var SessRowid=GetColumnData("SessRowid",Row);
		var SessDOW=GetColumnData("SessDOW",Row);
		var SessTimeStart=GetColumnData("SessTimeStart",Row);
		var SessTimeEnd=GetColumnData("SessTimeEnd",Row);
		var SessSlotLength=GetColumnData("SessSlotLength",Row);
		var SessLoad=GetColumnData("SessLoad",Row);
		var SessNoSlots=GetColumnData("SessNoSlots",Row);
		var SessNoApptSlot=GetColumnData("SessNoApptSlot",Row);
		var SessNumberOfWeeks=GetColumnData("SessNumberOfWeeks",Row);
		var SessNoOverbookAll=GetColumnData("SessNoOverbookAll",Row);
		var SessRoom=GetColumnData("SessRoom",Row);
		var SessType=GetColumnData("SessType",Row);
		var SessClinicGroup=GetColumnData("SessClinicGroup",Row);
		var SessRoomRowid=GetColumnData("SessRoomRowid",Row);
		var SessTypeRowid=GetColumnData("SessTypeRowid",Row);
		//alert(SessTypeRowid);
		var SessClinicGroupRowid=GetColumnData("SessClinicGroupRowid",Row);
		var SessDOWRowid=GetColumnData("SessDOWRowid",Row);
		var SessNoCode=GetColumnData("SessNoCode",Row);
		var SessScheduleGenerFlag=GetColumnData("SessScheduleGenerFlag",Row);
		
		var TRFlag=GetColumnData("TTRFlag",Row);
		var TRStartTime=GetColumnData("TTRStartTime",Row);
		var TREndTime=GetColumnData("TTREndTime",Row);
		var TRLength=GetColumnData("TTRLength",Row);
		var TRRegNum=GetColumnData("TTRRegNum",Row);
		var TRRegNumStr=GetColumnData("TTRRegNumStr",Row);
		var TRRegInfoStr=GetColumnData("TTRRegInfoStr",Row);
		
		//SetValue("PutDOW",SessDOWRowid);
		ComboDOW.setComboValue(SessDOWRowid);
		
		SetValue("PutTimeStart",SessTimeStart);
		SetValue("PutTimeEnd",SessTimeEnd);
		SetValue("PutSlotLength",SessSlotLength);
		SetValue("PutLoad",SessLoad);
		SetValue("PutNoSlots",SessNoSlots);
		SetValue("PutNoApptSlot",SessNoApptSlot);
		SetValue("PutNumberOfWeeks",SessNumberOfWeeks);
		SetValue("PutNoOverbookAll",SessNoOverbookAll);
		
		ComboRoom.setComboValue(SessRoomRowid);
		if(SessRoomRowid=="") ComboRoom.setComboText('');
		//SetValue("PutRoom",SessRoom);
		//SetValue("PutRoomRowid",SessRoomRowid);
		
		ComboType.setComboValue(SessTypeRowid);
		SetComboValue(ComboType,SessTypeRowid);
		//SetValue("PutType",SessTypeRowid);
		
		ComboClinicGroup.setComboValue(SessClinicGroupRowid);
		if(SessClinicGroupRowid=="") ComboClinicGroup.setComboText(''); 
		//SetValue("PutClinicGroup",SessClinicGroupRowid);

		//SetValue("PutSessNo",SessNoCode);
		PutTimeRange.setComboValue(SessNoCode);
		DHCC_SetElementData("PutScheduleGenerFlag",SessScheduleGenerFlag);
		DHCC_SetElementData("TRFlag",TRFlag);
		SetValue("TRStartTime",TRStartTime);
		SetValue("TREndTime",TREndTime);
		SetValue("TRLength",TRLength);
		SetValue("TRRegNum",TRRegNum);
		SetValue("TRRegNumStr",TRRegNumStr);
		SetValue("TRRegInfoStr",TRRegInfoStr);
		TRFlag_change();

		SelectedRow = selectrow;
	}else{
		SelectedRow=0;
		ClearValue();
		//ResetButton(0)
	}
}
function SetComboValue(obj,val){
	if (obj) {
		var ind=obj.getIndexByValue(val);
		if (ind==-1){obj.setComboText("");return;}
		obj.selectOption(ind)
	}
}


function ClearValue(){
	var CFAppQtyDefault=GetValue('CFAppQtyDefault');
	var CFAppStartNoDefault=GetValue('CFAppStartNoDefault');
	
	SetValue("PutTimeStart","");
	SetValue("PutTimeEnd","");
	SetValue("PutSlotLength","");
	SetValue("PutNoSlots","");

	ComboRoom.setComboText('');
	PutTimeRange.setComboText('');
	ComboDOW.setComboText('');
	
	var ResClinicGroupRowId=DHCC_GetElementData("ResClinicGroupRowId");
	var ResSessionTypeRowId=DHCC_GetElementData("ResSessionTypeRowId");

  if (ResClinicGroupRowId!=""){
		ComboClinicGroup.setComboValue(ResClinicGroupRowId);
	}else{
		ComboClinicGroup.setComboText('');
	}
	
  if (ResSessionTypeRowId!=""){
		ComboType.setComboValue(ResSessionTypeRowId);
	}else{
		ComboType.setComboText('');
	}	
	var ResLoad=DHCC_GetElementData('ResLoad');
	var ResAppLoad=DHCC_GetElementData('ResAppLoad');
	var ResAddLoad=DHCC_GetElementData('ResAddLoad');
	var ResAppStartNum=DHCC_GetElementData('ResAppStartNum');

	//SetValue("PutNoApptSlot",CFAppQtyDefault);
	//SetValue("PutNumberOfWeeks",CFAppStartNoDefault);
	SetValue("PutLoad",ResLoad);
	SetValue("PutNoApptSlot",ResAppLoad);
	SetValue("PutNumberOfWeeks",ResAppStartNum);
	SetValue("PutNoOverbookAll",ResAddLoad);	
	DHCC_SetElementData("PutScheduleGenerFlag",true);
	
	DHCC_SetElementData('TRFlag',"")
	DHCC_SetElementData('TRLength',"")
	DHCC_SetElementData('TRRegNum',"")
	DHCC_SetElementData('TRStartTime',"")
	DHCC_SetElementData('TREndTime',"")
	DHCC_SetElementData('TRRegNumStr',"")
	DHCC_SetElementData('TRRegInfoStr',"")
		
	//SetValue("PutRoom","");
	//SetValue("PutDOW","");
	//SetValue("PutType","");
	//SetValue("PutClinicGroup","");
}

function SetResDocDetail(ResRowId){
	var encmeth=DHCC_GetElementData('GetResDocDetailMethod');
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,ResRowId);
		//亚专业^号别^正号限额^预约限额^预约开始号^加号限额^分时段标志^时常^时段号数
		var Arr=retDetail.split('^');
		var ResClinicGroupRowId=Arr[0];
		var ResSessionTypeRowId=Arr[1];
		var ResLoad=Arr[2];
		var ResAppLoad=Arr[3];
		var ResAppStartNum=Arr[4];
		var ResAddLoad=Arr[5];
		var TRFlag=Arr[6];
		var TRLength=Arr[7];
		var TRRegNum=Arr[8];
		//DHCC_SetElementData('ResClinicGroupRowId',ResClinicGroupRowId)
		//DHCC_SetElementData('PutClinicGroup',ResClinicGroupRowId)
		ComboClinicGroup.setComboValue(ResClinicGroupRowId)
		//DHCC_SetElementData('ResSessionTypeRowId',ResSessionTypeRowId)
		//DHCC_SetElementData('PutType',ResSessionTypeRowId)
		ComboType.setComboValue(ResSessionTypeRowId)
		//DHCC_SetElementData('ResLoad',ResLoad)
		DHCC_SetElementData('PutLoad',ResLoad)
		//DHCC_SetElementData('ResAppLoad',ResAppLoad)
		DHCC_SetElementData('PutNoApptSlot',ResAppLoad)
		//DHCC_SetElementData('ResAddLoad',ResAddLoad)
		DHCC_SetElementData('PutNoOverbookAll',ResAddLoad)
		//DHCC_SetElementData('ResAppStartNum',ResAppStartNum)
		DHCC_SetElementData('PutNumberOfWeeks',ResAppStartNum)
		DHCC_SetElementData('TRFlag',TRFlag)
		DHCC_SetElementData('TRLength',TRLength)
		DHCC_SetElementData('TRRegNum',TRRegNum)
		TRFlag_change()
	}	
}

function ResDocchangehandler(e){
	var obj=document.getElementById("ResDoc");
	var ResRowid=obj.options[obj.selectedIndex].value;
	var ResDesc=obj.options[obj.selectedIndex].text;
	
	DHCC_SetElementData("DocDesc",ResDesc)
	SetEffectDateList(ResRowid);
	ClearTable(sessobjtbl);
	ClearValue();
	var obj=document.getElementById("ResEffectDate");
	if (obj.length>0){
		obj.options[obj.length-1].selected=true;
		var ResDateRowid=obj.options[obj.length-1].value;
		SetSessionTable(ResDateRowid);
	}
	SetResDocDetail(ResRowid);
		
}

function SetEffectDateList(ResRowid){
	var obj=document.getElementById('ResEffectDate');
	ClearAllList(obj)

	var encmeth=DHCC_GetElementData('GetResEffectDateMethod');
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,"AddToResEffectDateList",ResRowid);
		if (retDetail==1) return true;
	}
}

function AddToResEffectDateList(val){
	var obj=document.getElementById('ResEffectDate');
	ClearAllList(obj)
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}	
}

function ComboClinicGroupselectHandle(e){
	DHCC_Nextfoucs();
}
function InitClinicGroupStr(LocRowId){
	//专业初始化
  var ClinicGroupStr=""
	var encmeth=DHCC_GetElementData('GetClinicGroupStrMethod');
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){ClinicGroupStr=cspRunServerMethod(encmeth,LocRowId);}

	ComboClinicGroup.clearAll();
	if (ClinicGroupStr!=""){
		var Arr=DHCC_StrToArray(ClinicGroupStr);
		ComboClinicGroup.addOption(Arr);
	}
	ComboClinicGroup.setComboText("");

	/*
	var obj=document.getElementById("PutClinicGroup");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
		obj.length=0;
		obj.options[obj.length] = new Option("","")
		var ArrData=ClinicGroupStr.split("^");
		for (var i=0;i<ArrData.length;i++) {
		 var ArrData1=ArrData[i].split(String.fromCharCode(1));
		 obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
		}
		obj.selectedIndex=-1;
	} 
	*/
}

function Loclookupsel(val) {
	var Split_Value=val.split("^");
	try {
		var LocID=Split_Value[2];
		DHCC_SetElementData("Loc",Split_Value[0]);
		DHCC_SetElementData("LocID",Split_Value[2]);

		SetResDocList(LocID);
		InitClinicGroupStr(LocID);
	}catch(e){
		alert(e.message);
	}
}

function SetResDocList(LocID){
	var obj=document.getElementById('ResDoc');
	ClearAllList(obj)
	if (LocID=="") return;
	var obj=document.getElementById('GetResDocMethod');
	var UserID=session['LOGON.USERID'];
	if (obj) {
		var encmeth=obj.value;
		//alert("encmeth:"+encmeth);
		if (encmeth!=''){
			var retDetail=cspRunServerMethod(encmeth,"AddToResDocList",LocID,"",UserID);
			if (retDetail==1) return true;
		}
	}	
}

function AddToResDocList(val){
	var obj=document.getElementById('ResDoc');
	//ClearAllList(obj)
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
}

function RoomLookupSelect(val) {
	var Split_Value=val.split("^");
	try {
		var PutRoom=Split_Value[0];
		var PutRoomRowid=Split_Value[2];
		var obj=document.getElementById("PutRoomRowid");
		if (obj){obj.value=PutRoomRowid;}
		var obj=document.getElementById("PutRoom");
		if (obj){obj.value=PutRoom;}
	}catch(e){
		alert(e.message);
	}
}
function ClearAllList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

var sessobjtbl=document.getElementById('tDHCRBRes_Session_bak');

function AddRowToTable(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			//rowitems[j].value="";
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
		}
	}
	objtbody=tk_getTBody(objlastrow);
	objnewrow=objtbody.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function ClearTable(objtbl){
	var rows=objtbl.rows.length;
	for (var i=1; i<rows; i++){
		DeleteTabRow(objtbl,1);
	}
}
function DeleteTabRow(objtbl,selectrow){
	var rows=objtbl.rows.length;
	if (rows>2){
		objtbl.deleteRow(selectrow);
	}else{
		var objlastrow=objtbl.rows[rows-1];
		var rowitems=objlastrow.all; //IE only
		if (!rowitems) rowitems=objlastrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				arrId[arrId.length-1]=1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			if (rowitems[j].tagName=='LABEL'){rowitems[j].innerText=""}else{rowitems[j].value=""}
			}
		}
		objlastrow.className="RowOdd";
	}
}

function SetColumnData(ColName,Row,Val){
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
}

function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}

function GetRow(objtbl,Rowindex){
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

function SetValue(name,value){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {obj.innerText=value;} else {obj.value=value}
	}
}

function GetValue(name){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {
			return obj.innerText;
		} else {
			if (obj.type=="select-one"){
				var Rowid="";
				var Desc="";
				if (obj.selectedIndex!=-1){
					Rowid=obj.value;
					Desc=obj.options[obj.selectedIndex].text;
				}
				return Rowid+String.fromCharCode(1)+Desc;
			}else{
				return obj.value
			}
		}
	}
	return "";
}
////Look Up Item Trans Keypress event
function DHCWeb_LookUpItemTransKeyPress()
{
	var type=websys_getType(e);
	var key=websys_getKey(e);
	///alert(type+ "  "+key);
	///evtName
	if ((type=='keypress')&&(key==13)){
		var eSrc=window.event.srcElement;
		var myobj=document.getElementById(eSrc.name);
		if ((myobj)&&(myobj.onkeydown)) {
			var myNewEvent=document.createEventObject();
			myNewEvent.keyCode = 117;
			myobj.fireEvent("onkeydown",myNewEvent);
			event.cancleBubble=true;
		}
	}
}
function TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum){
	var obj=document.getElementById("TRStartTime");
	if ((obj)&&((obj.className=='clsInvalid')||(obj.value==""))){
		alert("分时段开始时间格式不正确")
		websys_setfocus("TRStartTime");
		return false;
	}
	var obj=document.getElementById("TREndTime");
	if ((obj)&&((obj.className=='clsInvalid')||(obj.value==""))){
		alert("分时段结束时间格式不正确")
		websys_setfocus("TREndTime");
		return false;
	}
	var obj=document.getElementById("TRLength");
	if ((obj)&&((obj.className=='clsInvalid')||(obj.value=="")||(obj.value<0))){
		alert("分时段时间间隔格式不正确")
		websys_setfocus("TRLength");
		return false;
	}
	var obj=document.getElementById("TRRegNum");
	if ((obj)&&((obj.className=='clsInvalid')||(obj.value=="")||(obj.value<0))){
		alert("分时段号源数量格式不正确")
		websys_setfocus("TRRegNum");
		return false;
	}
	var ret=tkMakeServerCall("web.DHCRBResSession","TRInfoCalculate",TRStartTime,TREndTime,TRLength,TRRegNum)
	var arr=ret.split("^");
	if (arr[0]!="0"){
		alert(arr[1]);
		return false;
	}else{
		var RegNumStr="",RegInfoStr="";
		var RegNumStrobj=document.getElementById("TRRegNumStr");
		var RegInfostrobj=document.getElementById("TRRegInfoStr");
		if (RegNumStrobj) RegNumStr=RegNumStrobj.value;
		if (RegInfostrobj) RegInfoStr=RegInfostrobj.value;
		if ((RegNumStr!=""&&RegNumStr!=arr[1])||(RegInfoStr!=""&&RegInfoStr!=arr[2]))
		{
			if (!(confirm("旧号段信息"+RegNumStr+"\n新号段信息"+arr[1]+"\n旧时段信息"+RegInfoStr+"\n新时段信息"+arr[2]+"\n是否替换?"))) return true;
		}
		if (RegNumStrobj) RegNumStrobj.value=arr[1];
		if (RegInfostrobj) RegInfostrobj.value=arr[2];
		//return false;
		return true;
	}
	
}