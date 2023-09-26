var chkStop  = null;
var midStop = null;
var chkRep = null;
var chkMax = null;
var chkAdd = null;
var chkRepair = null;
var chkTimeRange = null;
var trStop = null;
var trRep = null;
var trMax = null;
var trTimeRange=null;
var tbMax = null;
var mRepDoctorId = '';
var mId = null;
var mLocId = null;
var mLocAreaId = null;
var mDoctorId = null;
var mStopReasonId = '';
var mRepReasonId = '';
var mRepLocId = null;
var mRepLeaderId = '';
var mStopLeaderId = '';
var mGetAppQty = null;
var mStatus = '';
var mSelectedRow = null;
var mBtnRestore = null;
var mBtnSave = null;
var mBtnNew = null;
var mBtnFrozen=null;
var mBtnCancelFrozen=null;
var mSessionTypeId = null;
var mTimeRange = '';
var mClinicGroupId = null;


var doc1 = parent.frames[0].document;
var e=event;
function BodyLoadHandler(){
	try	{
	
		mId = document.getElementById('EId');
		mLocId=document.getElementById('ELocId');
		mLocAreaId=document.getElementById('ELocAreaId');
		mDoctorId=document.getElementById('EDoctorId');
		chkStop = document.getElementById("EChkStop");
		midStop = document.getElementById("MidStop");
		chkRep = document.getElementById("EChkRep");
		chkMax = document.getElementById("EChkMax");
		chkAdd = document.getElementById("ChkAdd");
		chkRepair = document.getElementById("ChkRepair");
		chkTimeRange = document.getElementById("TimeRangeFlag");
		mGetAppQty = document.getElementById("MGetAppQty");
		mRepLocId = document.getElementById("ERepLocId");
		mClinicGroupId=document.getElementById("EClinicGroupId");
		mSessionTypeId=document.getElementById("ESessionTypeId");

		mBtnRestore = document.getElementById("ERestoreStop");
		if (mBtnRestore){
			mBtnRestore.onclick = restore_click;
			mBtnRestore.style.display='none';			
		}
		
		mBtnFrozen = document.getElementById("Frozen");
		if (mBtnFrozen){
			//mBtnFrozen.onclick = restore_click;
			mBtnFrozen.style.display='none';			
		}		

		mBtnCancelFrozen = document.getElementById("CancelFrozen");
		if (mBtnCancelFrozen){
			//mBtnCancelFrozen.onclick = restore_click;
			mBtnCancelFrozen.style.display='none';			
		}	
				
		mBtnSave = document.getElementById("EbtnSave");
		if (mBtnSave) mBtnSave.onclick = save_click;
		
		mBtnNew = document.getElementById("EBtnNew");
		if (mBtnNew) mBtnNew.onclick = new_click;
		
			
		var obj = document.getElementById("EbtnUpdate");
		if (obj) obj.onclick = update_click;

		var obj = document.getElementById("EPositiveMax");
		if (obj) obj.onkeyup = EPositiveMax_ToNumeric;
		
		var obj = document.getElementById("EAddtionMax");
		if (obj) obj.onkeyup = EAddtionMax_ToNumeric;
		
		var obj = document.getElementById("EApptMax");
		if (obj) obj.onkeyup = EApptMax_ToNumeric;
		
		var obj = document.getElementById("EStartPrefix");
		if (obj) obj.onkeyup = EStartPrefix_ToNumeric;
		
		var obj=document.getElementById("AddMax");
		if (obj) obj.onclick=AddMax_Click;
		
		var objtbl=document.getElementById('tDHCApptSchedule_Edit');
		if (!objtbl) objtbl=document.getElementById('tDHCApptSchedule_Edit0');
		ClearInitRow(objtbl);

		var tables = document.getElementsByTagName("table");
		if (tables.length > 0){
			/*
			trRep = tables[3].parentElement.parentElement;
			trStop = tables[4].parentElement.parentElement;
			trMax = tables[5].parentElement.parentElement;
			trTimeRange = tables[2].parentElement.parentElement;
			tbMax = tables[6];
			*/
			
			trRep = tables[3].parentElement.parentElement;
			trStop = tables[4].parentElement.parentElement;
			trMax = tables[5].parentElement.parentElement;
			trTimeRange = tables[2].parentElement.parentElement;
			
			//if (tbMax) tbMax.onclick = setValue;
			if (trRep) trRep.style.display = 'none';
			if (trStop) trStop.style.display = 'none';
			if (trMax) trMax.style.display = 'none';
			if (trTimeRange) trTimeRange.style.display = 'none';
		}

		if (chkStop && trStop){
			chkStop.onclick = setStop;
			chkStop.disabled=true;
		}
		if (midStop && trStop){
			midStop.onclick = setStop;
			midStop.disabled=true;
		}
		if (chkRep && trRep){
			chkRep.onclick = setReplace;
			chkRep.disabled=true;
		}
		if (chkMax && trMax){
			chkMax.onclick = setMax;
			chkMax.disabled=true;
		}	
		
		if (chkAdd) chkAdd.onclick=chkAdd_click;
		if (chkRepair) chkRepair.onclick=chkAdd_click;
		if (chkTimeRange) chkTimeRange.onclick=chkTimeRange_click;
		if (document.getElementById('ELoc')){
			var DepStr=DHCC_GetElementData('DepStr');
			combo_ELoc=dhtmlXComboFromStr("ELoc",DepStr);
			combo_ELoc.enableFilteringMode(true);
			combo_ELoc.selectHandle=combo_ELocKeydownhandler;
		}		

		if (document.getElementById('ELocArea')){
			var RoomStr=DHCC_GetElementData('RoomStr');
			//alert(RoomStr)
			combo_ELocArea=dhtmlXComboFromStr("ELocArea",RoomStr);
			combo_ELocArea.enableFilteringMode(true);
			combo_ELocArea.selectHandle=combo_ELocAreaKeydownhandler;
		}		

		if (document.getElementById('ERepLoc')){
			var DepStr=DHCC_GetElementData('DepStr');
			combo_ERepLoc=dhtmlXComboFromStr("ERepLoc",DepStr);
			combo_ERepLoc.enableFilteringMode(true);
			combo_ERepLoc.selectHandle=combo_ERepLocKeydownhandler;
		}
		
		if (document.getElementById('ERepDoctor')){
			combo_ERepDoctor=dhtmlXComboFromStr("ERepDoctor",'');
			combo_ERepDoctor.enableFilteringMode(true);
			combo_ERepDoctor.selectHandle=combo_ERepDoctorKeydownhandler;
		}

		if (document.getElementById('EDoctor')){
			combo_EDoctor=dhtmlXComboFromStr("EDoctor",'');
			combo_EDoctor.enableFilteringMode(true);
			combo_EDoctor.selectHandle=combo_EDoctorKeydownhandler;
		}

		if (document.getElementById('EClinicGroup')){
			var ClinicStr=DHCC_GetElementData('ClinicStr');
			combo_EClinicGroup=dhtmlXComboFromStr("EClinicGroup",ClinicStr);
			combo_EClinicGroup.enableFilteringMode(true);
			combo_EClinicGroup.selectHandle=combo_EClinicGroupKeydownhandler;
		}

		if (document.getElementById('ESessionType')){
			var SessionTypeStr=DHCC_GetElementData('SessionTypeStr');
			combo_ESessionType=dhtmlXComboFromStr("ESessionType",SessionTypeStr);
			combo_ESessionType.enableFilteringMode(true);
			combo_ESessionType.selectHandle=combo_ESessionTypeKeydownhandler;
		}

		if (document.getElementById('ERepSessionType')){
			var SessionTypeStr=DHCC_GetElementData('SessionTypeStr');
			combo_ERepSessionType=dhtmlXComboFromStr("ERepSessionType",SessionTypeStr);
			combo_ERepSessionType.enableFilteringMode(true);
			combo_ERepSessionType.selectHandle=combo_ERepSessionTypeKeydownhandler;
		}

		if (document.getElementById('ETimeRange')){
			var TimeRangeStr=DHCC_GetElementData('TimeRangeStr');
			combo_ETimeRange=dhtmlXComboFromStr("ETimeRange",TimeRangeStr);
			combo_ETimeRange.enableFilteringMode(true);
			combo_ETimeRange.selectHandle=combo_ETimeRangeKeydownhandler;
			combo_ETimeRange.selectHandle=combo_ETimeRangeselectHandle;
		}			
			

		
		combo_ERepReason=""   //2008-05-08  guorongyong
		if (document.getElementById('ERepReason')){
			var ReasonStr=DHCC_GetElementData('ReasonStr');
			combo_ERepReason=dhtmlXComboFromStr("ERepReason",ReasonStr);
			combo_ERepReason.enableFilteringMode(true);
			combo_ERepReason.selectHandle=combo_ERepReasonKeydownhandler;
		}		
		
		if (document.getElementById('EStopReason')){
			var ReasonStr=DHCC_GetElementData('ReasonStr');
			combo_EStopReason=dhtmlXComboFromStr("EStopReason",ReasonStr);
			combo_EStopReason.enableFilteringMode(true);
			combo_EStopReason.selectHandle=combo_EStopReasonKeydownhandler;
		}		
	  combo_ERepLeader=""     //2008-05-08 guorongyong
		if (document.getElementById('ERepLeader')){
			var ScheduleApproverStr=DHCC_GetElementData('ScheduleApproverStr');
			combo_ERepLeader=dhtmlXComboFromStr("ERepLeader",ScheduleApproverStr);
			combo_ERepLeader.enableFilteringMode(true);
			combo_ERepLeader.selectHandle=combo_ERepLeaderKeydownhandler;
		}		
				
		if (document.getElementById('EStopLeader')){
			var ScheduleApproverStr=DHCC_GetElementData('ScheduleApproverStr');
			combo_EStopLeader=dhtmlXComboFromStr("EStopLeader",ScheduleApproverStr);
			combo_EStopLeader.enableFilteringMode(true);
			combo_EStopLeader.selectHandle=combo_EStopLeaderKeydownhandler;
		}
		if (document.getElementById('EMaxName')){
			var GetMethodStr=DHCC_GetElementData('GetMethodStr');
			combo_AppMethod=dhtmlXComboFromStr("EMaxName",GetMethodStr);
			combo_AppMethod.enableFilteringMode(true);
			combo_AppMethod.selectHandle=combo_AppMethodKeydownhandler;
		}							

		VisibleCtrl('none');
	}catch (e){
		alert(e.message);
	}
}
function combo_ERepSessionTypeKeydownhandler(e){
	websys_nexttab(combo_ERepSessionType.tabIndex);
}

function combo_ERepLeaderKeydownhandler(e){
	websys_nexttab(combo_ERepLeader.tabIndex);
}
function combo_EStopLeaderKeydownhandler(e){
	websys_nexttab(combo_EStopLeader.tabIndex);
}
function combo_AppMethodKeydownhandler()
{
	websys_nexttab(combo_AppMethod.tabIndex);
}
function combo_ERepReasonKeydownhandler(e){
	websys_nexttab(combo_ERepReason.tabIndex);
}

function combo_EStopReasonKeydownhandler(e){
	websys_nexttab(combo_EStopReason.tabIndex);
}

function combo_ETimeRangeKeydownhandler(e){
	
	websys_nexttab(combo_ETimeRange.tabIndex);
	
}
function combo_ETimeRangeselectHandle(e){

    var TRRowId=combo_ETimeRange.getSelectedValue();

	var TRDesc=combo_ETimeRange.getSelectedText();
	var encmeth=DHCC_GetElementData('GetTRTimeStrMethod');
	if (encmeth!=''){
		var ret=cspRunServerMethod(encmeth,TRRowId);
		var Arr=ret.split("^");
		var SessTimeStart=Arr[0];
		var SessTimeEnd=Arr[1];
		
	}
 	var obj=document.getElementById("ETimeStart")
	if (obj){obj.value=SessTimeStart;}
	var obj=document.getElementById("ETimeEnd")
	if (obj){obj.value=SessTimeEnd;	}	
}
function combo_ESessionTypeKeydownhandler(e){
	mSessionTypeId.value=DHCC_GetComboValue(combo_ESessionType);
	websys_nexttab(combo_ESessionType.tabIndex);	
}

function combo_EClinicGroupKeydownhandler(e){
	mClinicGroupId.value=DHCC_GetComboValue(combo_EClinicGroup);
	websys_nexttab(combo_EClinicGroup.tabIndex);	
	
}

function AddMax_Click()
{
	var QtySum=0,StartNum=0;
	var AddAppQty=document.getElementById("AddAppQty");
	var MethodId=combo_AppMethod.getSelectedValue();
	var AllCount=document.getElementById("EMaxValue").value;
	var StartNum=document.getElementById("StartNum").value;
	
	//alert(MethodId+"$$"+AddAppQty);

	var bookMax = document.getElementById("EApptMax").value;  //预约限额
	var StartMax = document.getElementById("EStartPrefix").value;  //预约起始号
	var obj=document.getElementById('tDHCApptSchedule_Edit');
	if (!obj) var obj=document.getElementById('tDHCApptSchedule_Edit0');
	if (obj){
		for(var j=2;j<obj.rows.length;j++)  {
				var rowitems=obj.rows[j].all; //IE only
				if (!rowitems) rowitems=obj.rows[j].getElementsByTagName("*"); //N6
				
				for(var i=0;i<rowitems.length;i++){
					if (rowitems[i].id)	{
						 if (rowitems[i].id == 'TMaxValuez'+obj.rows[j].rowIndex)	{
								QtySum =QtySum+parseInt(rowitems[i].innerText);
							}
						
					}
				}
		}
	}
	
	var strV = document.getElementById("EMaxValue");
	if (!strV) return;
	var strSV = document.getElementById("StartNum");
	if (!strSV) return;
	
	QtySum=QtySum+parseInt(strV.value);
  if (QtySum>bookMax){
  	alert(t['OverMaxAppQty']);
  	return;
  }
  if(parseInt(strSV.value)>(parseInt(bookMax)+parseInt(StartMax)-1)){
	  alert("起始号设置超过了预约范围!");
	  return;
  }	
  if (AddAppQty.value != '')
	{
		
		var ret = cspHttpServerMethod(AddAppQty.value,mId.value,MethodId,AllCount,StartNum);
		
		if(ret=="0"){
			alert("新增成功");
			ShowMax();
			ClearEMax();
		}else{alert("新增失败")};
	}
}


function combo_ELocKeydownhandler(e){
	var DepRowId=DHCC_GetComboValue(combo_ELoc);
	DHCC_SetElementData('ELocId',DepRowId);

	if (combo_ELoc){
		combo_EDoctor.clearAll();
		combo_EDoctor.setComboText("");
		var UserID=session["LOGON.USERID"];
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_EDoctor.addOption('');
			var DocStr=cspRunServerMethod(encmeth,"",DepRowId,"",UserID,"DocID");
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_EDoctor.addOption(Arr);
			}
		}
		InitClinicGroupStr(DepRowId);
		
	}	
	websys_nexttab(combo_ELoc.tabIndex);
}

function InitClinicGroupStr(LocRowId){
	//专业初始化
  var ClinicGroupStr=""
	var encmeth=DHCC_GetElementData('GetClinicGroupStrMethod');
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){ClinicGroupStr=cspRunServerMethod(encmeth,LocRowId);}
	combo_EClinicGroup.clearAll();
	if (ClinicGroupStr!=""){
		var Arr=DHCC_StrToArray(ClinicGroupStr);
		combo_EClinicGroup.addOption(Arr);
	}
	combo_EClinicGroup.setComboText("");
}

function combo_EDoctorKeydownhandler(e){
	var DocRowId=DHCC_GetComboValue(combo_EDoctor);
	var DepRowId=DHCC_GetElementData('ELocId')
	DHCC_SetElementData('EDoctorId',DocRowId);
	SetResDocDetail(DepRowId,DocRowId);
	websys_nexttab(combo_EDoctor.tabIndex);
}

function SetResDocDetail(DepRowId,DocRowId){
	if ((DocRowId=="")||(DepRowId=="")){
		return;
	}
	var encmeth=DHCC_GetElementData('GetResDocDetailMethod');
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,DepRowId,DocRowId);

		var Arr=retDetail.split('^');
		var ResClinicGroupRowId=Arr[0];
		var ResSessionTypeRowId=Arr[1];
		var Load=Arr[2];
		var AppLoad=Arr[3];
		var AppStart=Arr[4];
		var AddLoad=Arr[5];
		var TRFlag=Arr[6];
		var TRLength=Arr[7];
		var TRRegNum=Arr[8];
		if (ResClinicGroupRowId!=""){
			combo_EClinicGroup.setComboValue(ResClinicGroupRowId);
			mClinicGroupId.value=ResClinicGroupRowId;
		}else{
			combo_EClinicGroup.setComboText('');
		}
		if (ResSessionTypeRowId!=""){
			combo_ESessionType.setComboValue(ResSessionTypeRowId);
			mSessionTypeId.value=ResSessionTypeRowId;
			
		}else{
			combo_ESessionType.setComboText('');
		}
		//var Load=
		DHCC_SetElementData("EPositiveMax",Load);
		DHCC_SetElementData("EApptMax",AppLoad);
		DHCC_SetElementData("EAddtionMax",AddLoad);
		DHCC_SetElementData("EStartPrefix",AppStart);
		DHCC_SetElementData("TimeRangeFlag",TRFlag);
		DHCC_SetElementData("TRLength",TRLength);
		DHCC_SetElementData("TRRegNum",TRRegNum);
		chkTimeRange_click();
	}	
}
function combo_ELocAreaKeydownhandler(e){
	var LocAreaRowId=DHCC_GetComboValue(combo_ELocArea);
	DHCC_SetElementData('ELocAreaId',LocAreaRowId);
	websys_nexttab(combo_ELocArea.tabIndex);
	
}

function combo_ERepLocKeydownhandler(e){
	var DepRowId=DHCC_GetComboValue(combo_ERepLoc);
	DHCC_SetElementData('ERepLocId',DepRowId);

	if (combo_ERepDoctor){
		combo_ERepDoctor.clearAll();
		combo_ERepDoctor.setComboText("");
		var encmeth=DHCC_GetElementData('GetNoScheduleDocStrMethod');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_ERepDoctor.addOption('');
			var AdmDate=DHCC_GetElementData('EScheduleDate');
			var TRRowId=DHCC_GetElementData('ETimeRangeId')
			//alert(AdmDate+" "+DepRowId+" "+TRRowId)
			var DocStr=cspRunServerMethod(encmeth,AdmDate,DepRowId,TRRowId);

			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_ERepDoctor.addOption(Arr);
			}
		}
	}	
	websys_nexttab(combo_ERepLoc.tabIndex);
}

function combo_ERepDoctorKeydownhandler(e){
	var DepRowId=DHCC_GetElementData('ERepLocId')
	var DocRowId=DHCC_GetComboValue(combo_ERepDoctor);
	mRepDoctorId=DocRowId;
	SetRepDocDetail(DepRowId,DocRowId);
	websys_nexttab(combo_ERepDoctor.tabIndex);
	
}
function SetRepDocDetail(DepRowId,DocRowId){
	if ((DocRowId=="")||(DepRowId=="")){
		return;
	}
	var encmeth=DHCC_GetElementData('GetResDocDetailMethod');
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,DepRowId,DocRowId);
		var Arr=retDetail.split('^');
		var ResClinicGroupRowId=Arr[0];
		var ResSessionTypeRowId=Arr[1];
		if (ResSessionTypeRowId!=""){
			combo_ERepSessionType.setComboValue(ResSessionTypeRowId);
		}else{
			combo_ERepSessionType.setComboText('');
		}
	}	
}
function EPositiveMax_ToNumeric(oId)
{
	var obj = document.getElementById("EPositiveMax");
	if (obj && obj.value.length>0) obj.value = obj.value.replace(/[^\d]/g,'');
}

function EAddtionMax_ToNumeric(oId)
{
	var obj = document.getElementById("EAddtionMax");
	//obj.value = obj.value.replace();
	if (obj && obj.value.length>0) obj.value = obj.value.replace(/[^\d]/g,'');
}

function EApptMax_ToNumeric(oId)
{
	var obj = document.getElementById("EApptMax");
	if (obj && obj.value.length>0) obj.value = obj.value.replace(/[^\d]/g,'');
}

function EStartPrefix_ToNumeric(oId)
{
	var obj = document.getElementById("EStartPrefix");
	if (obj && obj.value.length>0) obj.value = obj.value.replace(/[^\d]/g,'');
}


function InitNew()
{
	var obj = document.getElementById("EBtnSave");
	if (obj) obj.style.display = 'none';
	
	var obj = document.getElementById("ERestoreStop");
	if (obj) obj.style.display = 'none';

	
	
	chkStop.disabled=true;
	if (midStop) midStop.disabled=true;
	chkRep.disabled=true;
	chkMax.disabled=true;
	InitAttribute();
	VisibleCtrl('');
	ClearNormal();
	
}
function ClearNormal(){
	 if (combo_ELoc) combo_ELoc.setComboText('');
	 if (combo_ELocArea) combo_ELocArea.setComboText('');
	 if (combo_EDoctor) combo_EDoctor.setComboText('');
	 if (combo_ETimeRange) combo_ETimeRange.setComboText('');
	 if (combo_EClinicGroup) combo_EClinicGroup.setComboText('');
	 if (combo_ESessionType) combo_ESessionType.setComboText('');
	 DHCC_SetElementData('EPositiveMax','')
	 DHCC_SetElementData('EAddtionMax','')
	 DHCC_SetElementData('EApptMax','')
	 DHCC_SetElementData('EStartPrefix','')
	 DHCC_SetElementData('Efee','')
	 DHCC_SetElementData('EId','')
	 DHCC_SetElementData('ELocId','')
	 DHCC_SetElementData('EDoctorId','')
	 DHCC_SetElementData('ELocAreaId','')
	 DHCC_SetElementData('EScheduleDate','')
	 DHCC_SetElementData('ETimeRangeId','')
	 DHCC_SetElementData('EClinicGroupId','')
	 DHCC_SetElementData('ESessionTypeId','')
	 DHCC_SetElementData('ETimeStart','')
	 DHCC_SetElementData('ETimeEnd','')
	 if (combo_ERepDoctor) combo_ERepDoctor.setComboText('');
	 if (combo_ERepLoc) combo_ERepLoc.setComboText('');
	 if (combo_ERepSessionType) combo_ERepSessionType.setComboValue('');
	 
	 if (combo_EClinicGroup) combo_EClinicGroup.setComboText('');
	 if (combo_ERepReason) combo_ERepReason.setComboText('');
	 if (combo_ERepLeader) combo_ERepLeader.setComboText('');
	 
	 if (combo_EStopReason) combo_EStopReason.setComboText('');
	 if (combo_EStopLeader) combo_EStopLeader.setComboText('');
	 
	var obj = document.getElementById("LockFlag");
	if (obj) obj.checked= false;
	DHCC_SetElementData("TimeRangeFlag",'');
	DHCC_SetElementData("TRStartTime",'');
	DHCC_SetElementData("TREndTime",'');
	DHCC_SetElementData("TRLength",'');
	DHCC_SetElementData("TRRegNum",'');
	DHCC_SetElementData("TRRegNumStr",'');
	DHCC_SetElementData("TRRegInfoStr",'');
	chkTimeRange_click();
	 
}

function VisibleCtrl(style)
{
	var prefix = 'ld50462i';	
	var disable = (style=="none");
	//var obj = document.getElementById("ELoc");
	//if (obj) obj.disabled = disable;
	if (combo_ELoc){combo_ELoc.disable(disable)}
		
	//var obj = document.getElementById("EDoctor");
	//if (obj) obj.disabled = disable;
	if (combo_EDoctor){combo_EDoctor.disable(disable)}
		
	var obj = document.getElementById("EScheduleDate");
	if (obj) obj.disabled = disable;
	
	var obj = document.getElementById("Efee");
	if (obj) obj.disabled = true;

	//var obj = document.getElementById("EStartPrefix");
	//if (obj) obj.disabled = disable;
		
	var obj = document.getElementById(prefix+'ELoc');
	if (obj) obj.style.display = style;
	
	var obj = document.getElementById(prefix+'EScheduleDate');
	if (obj) obj.style.display = style;
	
	var obj = document.getElementById(prefix+'EDoctor');
	if (obj) obj.style.display = style;

	//if (combo_EClinicGroup){combo_EClinicGroup.disable(disable)}
	//if (combo_ESessionType){combo_ESessionType.disable(disable)}
	if (combo_ETimeRange) {combo_ETimeRange.disable(disable)}
	//if (combo_EClinicGroup) combo_EClinicGroup.show(!disable);
	//if (combo_ESessionType) combo_ESessionType.show(!disable);
	//if (combo_ETimeRange) combo_ETimeRange.show(!disable);
	
	//var obj = document.getElementById('cEClinicGroup');
	//if (obj) obj.style.display = style;	
	//var obj = document.getElementById('EClinicGroup');
	//if (obj) obj.style.display = style;	
	//var obj = document.getElementById(prefix+'EClinicGroup');
	//if (obj) obj.style.display = style;
	

	//var obj = document.getElementById('cESessionType');
	//if (obj) obj.style.display = style;	
	//var obj = document.getElementById('ESessionType');
	//if (obj) obj.style.display = style;	
	//var obj = document.getElementById(prefix+'ESessionType');
	//if (obj) obj.style.display = style;
	
	//var obj = document.getElementById('cETimeRange');
	//if (obj) obj.style.display = style;	
	//var obj = document.getElementById('ETimeRange');
	//if (obj) obj.style.display = style;	
	//var obj = document.getElementById(prefix+'ETimeRange');
	//if (obj) obj.style.display = style;
	
	//var obj = document.getElementById('cEStartPrefix');
	//if (obj) obj.style.display = style;
	//var obj = document.getElementById('EStartPrefix');
	//if (obj) obj.style.display = style;
	
	var obj = document.getElementById("EBtnNew");
	if (obj) obj.style.display = style;
	
	var obj = document.getElementById("ChkAdd");
	if (obj) obj.style.display = style;
	var obj = document.getElementById("cChkAdd");
	if (obj) obj.style.display = style;
	var obj = document.getElementById("ChkRepair");
	if (obj) obj.style.display = style;
	var obj = document.getElementById("cChkRepair");
	if (obj) obj.style.display = style;
}
function SelectRowHandler()
{
	//try
	//{	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCApptSchedule_Edit');
	if (!objtbl) objtbl=document.getElementById('tDHCApptSchedule_Edit0');
	//var tables = document.getElementsByTagName("table");
	//if (!objtbl) objtbl = tables[5];
	if (!objtbl) return ;
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var rowitems=rowObj.all;
	if (!rowitems) rowitems=rowObj.getElementsByTagName("*");
	
	if (!selectrow) return;

	var EMaxId = document.getElementById('EMaxId');
	var EMaxName=document.getElementById('EMaxName');
	var EMaxValue=document.getElementById('EMaxValue');
	var StartNumValue=document.getElementById('StartNum');
	for(var i=0;i<rowitems.length;i++)
	{
			if(rowitems[i].id)
			{
				if (rowitems[i].id == 'TMaxIdz'+selectrow)
				{
					Sel_EMaxId = rowitems[i];
				}
		
				if (rowitems[i].id == 'TMaxz'+selectrow)
				{
					Sel_EMaxName = rowitems[i];
				}
				
				if (rowitems[i].id == 'TMaxValuez'+selectrow)
				{
					Sel_EMaxValue = rowitems[i];
				}
				if (rowitems[i].id == 'TStartNumz'+selectrow)
				{
					Sel_StartNumValue = rowitems[i];
				}
				
			}
		}
		
	if (rowObj.className != "clsRowSelected")
	{
		  EMaxName.disabled=false;
		  //setReadOnly(EMaxName);
		  EMaxId.value = '';
			EMaxName.value = '';
			EMaxValue.value = '';
			StartNumValue.value='';
			
		
	}
	else
	{
		
		EMaxName.disabled=true;
		  EMaxId.value = Sel_EMaxId.value;
			EMaxName.value = Sel_EMaxName.innerText;
			EMaxValue.value = Sel_EMaxValue.innerText;
			StartNumValue.value=Sel_StartNumValue.innerText;
	}
	
	SelectedRow = selectrow;
	mSelectedRow = rowObj;
	
	
}

function restore_click()
{
		if (mId.value=='') 
		{
			alert(t['selectMsg']);
			return ;	
		}
		var mRestore = document.getElementById("MRestore");
		if (!mRestore) return ;			
		var ret1 = cspHttpServerMethod(mRestore.value,mId.value);
		var temparr=ret1.split("^");
		var ret=temparr[0];
		if (ret < 0 || ret==null){
				alert(t['restoreFailedMsg']+temparr[1]);
		}else{
				alert(t['restoreSuccessMsg']);	
				refreshList(mId.value);		
		}
	
}
function refreshList(ASRowId){
		var doc1 = parent.frames[0].document;
		var obj=doc1.getElementById("ASRowId");
		if (obj) obj.value=ASRowId;
		var obj = doc1.getElementById("Find");
		if (obj) obj.click();
	
}
function ValidateInput()
{
	var ASDate=DHCC_GetElementData('EScheduleDate');
	if (ASDate==""){
		alert(t['ASDateIsNull']);
		websys_setfocus("EScheduleDate");
		return false;
	}
	//正号限额
	var EPositiveMax=DHCC_GetElementData('EPositiveMax');
	//预约限额
	var EApptMax=DHCC_GetElementData('EApptMax');
	//加号限额
	var EAddtionMax=DHCC_GetElementData('EAddtionMax');
	//预约起始号
	var EStartPrefix = DHCC_GetElementData("EStartPrefix");
	
	var EStartPrefixobj=document.getElementById("EStartPrefix");
        var ESessionType = document.getElementById("ESessionType");
	if (ESessionType.value==''){
		alert(t['EpSessionTypeIsNull']);
		return false;
		}	
	if (EPositiveMax==''){
		alert(t['EPositiveMaxIsNull']);
		return false;
	}

	/*if (EApptMax==''){   
		alert(t['EApptMaxIsNull']);
		return false;
	}*/   //预约限额不能为空

	/*if (EAddtionMax==''){
		alert(t['EAddtionMaxIsNull']);
		return false;
	}*/

	/*if ((EStartPrefixobj.style.display!='none')&&(EStartPrefix=='')&&(EApptMax!="0")&&(EApptMax!="")){
		alert(t['EStartPrefixIsNull']);
		return false;
	}*/ //预约起始号不能为空

	if ((parseInt(EPositiveMax))<(parseInt(EApptMax))){
		alert(t['EPositiveMaxLessEApptMax']);
		return false;
	}
	//alert(EPositiveMax+"^"+EStartPrefix+"^"+EApptMax)
	if (parseInt(EApptMax)!=0){
		if ((parseInt(EPositiveMax)-parseInt(EStartPrefix)+1)<(parseInt(EApptMax))){
			alert(t['EPositiveMaxIsLarger']);
			return false;
		}
	}
	
	if (parseInt(EPositiveMax)>999){
		alert('正号限额不能超过999');	
		return false;
	}
	
	
	if (parseInt(EApptMax)>99){
		alert('预约限额不能超过99');	
		return false;
	}	
	
	/*
	var ElocAreaRowId="";
	if (combo_ELocArea.getSelectedText()!=""){	var ElocAreaRowId=combo_ELocArea.getActualValue();}
	if (ElocAreaRowId==''){
		alert(t['ElocAreaIsNull']);
		return false;
	}
	mLocAreaId.value=ElocAreaRowId;
	*/
	/*if (mLocAreaId.value==''){
		alert(t['ElocAreaIsNull']);
		return false;
	}*/   //guorongyong 2008-03-18 可不添诊室修改

	//var ERepLocRowId=DHCC_GetComboValue(combo_ERepLoc);
	if (mRepLocId==''){
		alert(t['ERepLocIsNull']);
		return false;
	}
	//mRepLocId.value=ERepLocRowId;
	return true;	
}
function checkbeforeupdate(){

	
}
function new_click()
{
	
	var obj = document.getElementById("MNew");
	if (obj)
	{
			
		//if (!fDHCApptSchedule_Edit_submit()) return;
		if (!ValidateInput()) return ;
		var scheduleDate = document.getElementById("EScheduleDate");
		var total = document.getElementById("EPositiveMax");
		var over = document.getElementById("EAddtionMax");
		var book = document.getElementById("EApptMax");
		var startNum = document.getElementById("EStartPrefix");
		if (mDoctorId.value==""){
			alert ("请选择医生！")
			return 
		}
		if (mLocId.value==""){
			alert("请选择科室！")
			return 
		}
		if (mClinicGroupId.value==""){
			//alert("请选择亚专业！")
			//return
		}
		if (mSessionTypeId.value==""){
			alert("请选择挂号职称！")
			return 
		}
		if (mLocAreaId.value==""){
			//alert("请选择诊室！")
			//return
		}

				
		var TRRowId=DHCC_GetComboValue(combo_ETimeRange);
		if (TRRowId==""){
			alert(t['TimeRangeIsNull']);
			return
		}
	    var TimeStart = document.getElementById("ETimeStart");//出诊时段开始时间
	    var TimeEnd = document.getElementById("ETimeEnd");  //
		var StatusCode="N";
		if (chkAdd.checked) StatusCode="A";
		if (chkRepair.checked) StatusCode="AR";
		if (StatusCode=="N"){
			alert(t["NoSelectAddType"]);
			return false;
		}
		//分时段就诊
		var TRFlag="N",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="";
		TRFlag=DHCC_GetElementData("TimeRangeFlag");
		if (TRFlag){
			TRFlag="Y";
			TRStartTime=DHCC_GetElementData("TRStartTime");
			TREndTime=DHCC_GetElementData("TREndTime");
			TRLength=DHCC_GetElementData("TRLength");
			TRRegNum=DHCC_GetElementData("TRRegNum");
			if(+TRRegNum>+(total.value)){
					alert("分时段时段号数不能大于正号限额")
					return false;
		    }
			if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum)) return false;
			TRRegNumStr=DHCC_GetElementData("TRRegNumStr");
			TRRegInfoStr=DHCC_GetElementData("TRRegInfoStr");
		}else{
			TRFlag="N";
		}
		var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
		var ret1 = cspHttpServerMethod(obj.value,scheduleDate.value,mDoctorId.value,mLocId.value,TRRowId,total.value,book.value,over.value,mLocAreaId.value,mSessionTypeId.value,mClinicGroupId.value,startNum.value,TimeStart.value,TimeEnd.value,StatusCode,TimeRangeStr);
		var temparr=ret1.split("^");
		var ret=temparr[0];
		if (ret){
			//alert(ret);
			if (ret=="0")	{
				//new success.
				mId.value = temparr[1];
				mBtnNew.style.display='none';
				mBtnSave.style.display='';
				chkMax.disabled = false;
				chkMax.click();
				alert(t['newSuccessMsg']);
				//ShowMax();
			}else{
				switch(ret)	{
					case '-201':
						alert(t['OneDayDDocTRRepeat']+temparr[1]);
						break;
					case '-202':
						alert(t['OneDayTRRoomRepeat']+temparr[1]);
						break;
					case '300':
						alert(t['doctorNoResourceMsg']);	
						break;
					case '200':	
					  alert(t['doctorBusyMsg']);	
						break;
					default:
						alert(t['newFailedMsg']);
						break;
				}
			}
		}
	}
}

function update_click(){
	if (!mSelectedRow){
		alert(t['selectMaxFailMsg']);	
		return ;
	}
	var QtySum=0,StartNum=0;
	var bookMax = document.getElementById("EApptMax").value;  //预约限额
	var StartMax = document.getElementById("EStartPrefix").value;  //预约起始号
	var obj=document.getElementById('tDHCApptSchedule_Edit');
	if (!obj) var obj=document.getElementById('tDHCApptSchedule_Edit0');
	if (obj){
		for(var j=2;j<obj.rows.length;j++)  {
				var rowitems=obj.rows[j].all; //IE only
				if (!rowitems) rowitems=obj.rows[j].getElementsByTagName("*"); //N6
				
				for(var i=0;i<rowitems.length;i++){
					if ((rowitems[i].id)&&(obj.rows[j].rowIndex!=mSelectedRow.rowIndex))	{
						 if (rowitems[i].id == 'TMaxValuez'+obj.rows[j].rowIndex)	{
								QtySum =QtySum+parseInt(rowitems[i].innerText);
							}
						
					}
				}
		}
	}
	
	var strV = document.getElementById("EMaxValue");
	if (!strV) return;
	var strSV = document.getElementById("StartNum");
	if (!strSV) return;
	
	QtySum=QtySum+(parseInt(strV.value)-QtySum);
  if (QtySum>bookMax){
  	alert(t['OverMaxAppQty']);
  	return;
  }
  if(parseInt(strSV.value)>(parseInt(bookMax)+parseInt(StartMax)-1)){
	  alert("起始号设置超过了预约范围!");
	  return;
  }
  

	SetRowValue(strV.value,strSV.value);
	ClearEMax();
}
function save_click()
{
	//alert(mLocId.value+':'+mLocAreaId.value+':'+mDoctorId.value+':'+mId.value);	
	if (mId.value=='') 	{
		alert(t['selectMsg']);
		return ;	
	}
	var Title="";	
	try	{
		//判断当前号源是否过时的号源
		var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",mId.value)
		if (ret<0){ //<0过时了 >0中途停诊 
			alert(t["ApptScheduleIsLater"]);
			return false;
		}
		if (chkStop.checked||midStop.checked)
		{
			var StatusCode="S"
			if (midStop.checked) StatusCode="PS";  //中途停诊
			if (ret==1) StatusCode="PS";
			var IsAudit="0";
			if (ret==2) IsAudit="1";
			
			if (ret>0){
				Title="停诊记录单";
			}else{
				Title="停诊申请单";
			}
			ReasonDesc=combo_EStopReason.getSelectedText();
			//Stop Doctor
			var mStop = document.getElementById("MStop");
			if (!mStop) return ;
			/*
			var mLeader = document.getElementById("EStopLeader");
			if (!mLeader) return ;
			*/
			
			mStopLeaderId=DHCC_GetComboValue(combo_EStopLeader);
			mStopReasonId=DHCC_GetComboValue(combo_EStopReason);
			var ret = cspHttpServerMethod(mStop.value,mId.value,mStopReasonId,mStopLeaderId,StatusCode,IsAudit);
			if (ret!= 0) {
					alert(t['stopFailedMsg']+ret);
					return
			}	else{
					alert(t['updateSuccessMsg']);				
			}
		}
		else if(chkRep.checked)
		{

			var mRep = document.getElementById("MRep");
			if (!mRep) return ;
			/*
			var mLeader = document.getElementById("ERepLeader");
			if (!mLeader) return ;
			*/
			
			var mRepDoctorId=DHCC_GetComboValue(combo_ERepDoctor);
			if (mRepDoctorId==""){
				alert(t['RepDoctorIsNull']);
				return;
			}
			var RepLocRowId=DHCC_GetComboValue(combo_ERepLoc);
			if (RepLocRowId==""){
				alert(t['RepLocIsNull']);
				return;
			}
			
			var RepSessionTypeRowId=DHCC_GetComboValue(combo_ERepSessionType);
			if (RepSessionTypeRowId==""){
				alert(t['RepSessionTypeIsNull']);
				return;
			}
						
			mRepReasonId=DHCC_GetComboValue(combo_ERepReason);
			mRepLeaderId=DHCC_GetComboValue(combo_ERepLeader);
			var IsAudit="0";
			var ret=tkMakeServerCall("web.DHCRBApptSchedule","ApptScheduleIsLater",mId.value)
			if (ret<0){ //<0过时了 >0中途停诊 
				alert(t["ApptScheduleIsLater"]);
				return false;
			}
			if (ret>0){
				IsAudit="1";
				Title="替诊记录单";
			}else{
				Title="替诊申请单";
			}
			ReasonDesc=combo_ERepReason.getSelectedText()
			//alert(mId.value+':'+mRepDoctorId+':'+mRepLocId.value+':'+mRepReasonId+':'+mRepLeaderId+':'+RepSessionTypeRowId);
			var ret1 = cspHttpServerMethod(mRep.value,mId.value,mRepDoctorId,mRepLocId.value,mRepReasonId,mRepLeaderId,RepSessionTypeRowId,IsAudit);
			var temparr=ret1.split("^");
			var ret=temparr[0];
			if (ret==0){
				alert(t['updateSuccessMsg']);
				//return;
			}else{
				switch(parseInt(ret))
				{
				case 300:
					alert(t['doctorNoResourceMsg']);
					return;	
			 		break;
				case 200:	
			  		alert(t['doctorBusyMsg']);	
					return;
					break;
				case 100:
			  		alert(t['repFailedMsg']);
			  		return;	
					break;
				case 101:
					alert(t['repCopyAppFailedMsg']);			
					return;
			  		break;
				default:
					alert(ret);
					break;	
	 	 		}
			}
		}else{
				//存贮修改预约机构预约限额的数据
				if (chkMax.checked){
					var mMax = document.getElementById("MMax");
					if (!mMax) return;
					var mMaxValue = getMax();
					if (mMaxValue==""){
						alert("请添加预约机构和预约限额，或者取消预约机构选中框");
						return;
					}
					//alert(mId.value+"$$"+mMaxValue);
					var ret = cspHttpServerMethod(mMax.value,mId.value,mMaxValue);
					//alert(ret)
					if (ret > 0 || ret==null)	{
						alert(t['updateFailedMsg']);
						return;
					}
				}
				//base info
				if (!ValidateInput()) return;
				var mBase = document.getElementById("MBase");
				if (!mBase) return ;
				var total = document.getElementById("EPositiveMax");
				var over = document.getElementById("EAddtionMax");
				var book = document.getElementById("EApptMax");  //预约限额
				var AppQtySum=tkMakeServerCall("web.DHCRBApptScheduleAppQty","GetAppQtySumByApptSchedule",mId.value)
				if(+AppQtySum>+(book.value)){
					alert("预约限额不能小于各个预约机构预约限额总和！")
					return false;
				}
				var startNum = document.getElementById("EStartPrefix");  //预约起始号
				var LockFlag=DHCC_GetElementData('LockFlag');
				if (LockFlag){LockFlag="Y"}else{LockFlag="N"}

				//DHCC_SetElementData('ELocAreaId',DHCC_GetComboValue(combo_ELocArea));
                var TimeStart = document.getElementById("ETimeStart");//出诊时段开始时间
				var TimeEnd = document.getElementById("ETimeEnd");  //
				//分时段就诊
				var TRFlag="N",TRStartTime="",TREndTime="",TRLength="",TRRegNum="",TRRegNumStr="",TRRegInfoStr="";
				TRFlag=DHCC_GetElementData("TimeRangeFlag");
				if (TRFlag){
					TRFlag="Y";
					TRStartTime=DHCC_GetElementData("TRStartTime");
					TREndTime=DHCC_GetElementData("TREndTime");
					TRLength=DHCC_GetElementData("TRLength");
					TRLength=TRLength.replace(" ","") 
					TRRegNum=DHCC_GetElementData("TRRegNum");
					TRRegNum=TRRegNum.replace(" ","")
					if(+TRRegNum>+(total.value)){
					  alert("分时段时段号数不能大于正号限额")
					  return false;
				    }
					if (!TRInfoCalculate(TRStartTime,TREndTime,TRLength,TRRegNum)) return false;
					TRRegNumStr=DHCC_GetElementData("TRRegNumStr");
					TRRegInfoStr=DHCC_GetElementData("TRRegInfoStr");
				}else{
					TRFlag="N";
				}
				var TimeRangeStr=TRFlag+"^"+TRStartTime+"^"+TREndTime+"^"+TRLength+"^"+TRRegNum+"^"+TRRegNumStr+"^"+TRRegInfoStr;
		
				if (total && over && mId && book)
				{
					
					var ret1 = cspHttpServerMethod(mBase.value,mId.value,mLocAreaId.value,total.value,over.value,book.value,startNum.value,mClinicGroupId.value,mSessionTypeId.value,LockFlag,TimeStart.value,TimeEnd.value,TimeRangeStr);
					var temparr=ret1.split("^")
					var ret=temparr[0];
					if (ret == 0) 	{
						alert(t['updateSuccessMsg']);	
					}	else {
					  if (ret=="-201"){alert(t['OneDayDDocTRRepeat']+temparr[1]);return;}
					  if (ret=="-202"){alert(t['OneDayTRRoomRepeat']+temparr[1]);return;}
					  if (ret=="-203"){alert(t['EPositiveMaxLessThanReged']);return;}
					  if (ret=="-204"){alert(t['EApptLessThanReged']);return;}
					  if (ret=="-205"){alert(t['EAddtionLessThanReged']);return;}
						alert(t['updateFailedMsg']+ret);
						return
					}
				}
		}
		/*
		//打印单据
		if (Title!=""){
			var Templatefilepath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")+'DHCApptScheduleEdit.xls'; // 模板文件
			xlApp = new ActiveXObject("Excel.Application"); 
			xlBook = xlApp.Workbooks.Add(Templatefilepath); 
			xlsheet = xlBook.WorkSheets("Sheet1");
			xlsheet.cells(1, 1).value = Title
			xlsheet.cells(2, 2).value = DHCC_GetElementData("EScheduleDate");
			xlsheet.cells(2, 5).value = DHCC_GetElementData("ELoc");
			xlsheet.cells(3, 2).value = DHCC_GetElementData("ETimeRange");
			xlsheet.cells(3, 5).value = DHCC_GetElementData("EDoctor");
			xlsheet.cells(4, 2).value = combo_ESessionType.getSelectedText();
			xlsheet.cells(4, 5).value = DHCC_GetElementData("EPositiveMax");
			xlsheet.cells(5, 2).value = ReasonDesc;
			xlsheet.cells(6, 2).value = combo_ERepLoc.getSelectedText();
			xlsheet.cells(6, 5).value = combo_ERepDoctor.getSelectedText();
			xlsheet.cells(7, 2).value = combo_ERepSessionType.getSelectedText();
			xlsheet.printout;
			xlBook.Close (savechanges=false);
			xlApp.Quit();
			xlApp=null;
			xlsheet=null;
	
			idTmr   =   window.setInterval("Cleanup();",1); 
		}
		**/
		refreshList(mId.value);

	}
	catch (e)
	{
		alert(e.message);	
	}
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
}
function InitAttribute()
{
	//mSessionTypeId = '';
	mTimeRange = '';
	//mClinicGroupId.value = '';
	//alert();
	var LocId=mLocId.value;
	var ClinicGroupId=mClinicGroupId.value;
	InitClinicGroupStr(LocId);
	combo_EClinicGroup.setComboValue(ClinicGroupId);
	var SessionTypeId=mSessionTypeId.value;
	combo_ESessionType.setComboValue(SessionTypeId);
	
	if (trRep && chkRep)
	{
		chkRep.checked = false;
		trRep.style.display = 'none';
	}
	if (trStop && chkStop)
	{
		 chkStop.checked = false;
		 trStop.style.display = 'none';
	}
	if (trStop && midStop)
	{
		 midStop.checked = false;
		 trStop.style.display = 'none';
	}
	if (trMax && chkMax)
	{
		 chkMax.checked = false;
		 trMax.style.display = 'none';
	}
	if (chkAdd)
	{
		 chkAdd.checked = false;
		 
	}
	if (chkRepair)
	{
		 chkRepair.checked = false;
		 
	}	
}
function LoadMax(status)
{
  //alert("Ddd");
	if (!mId) return ;
	if (mId.value=='') return ;
	if (!status) return ;
	VisibleCtrl('none');
	InitAttribute();
	//alert(status)
	switch(status)
	{
		case 'S':
		  chkStop.disabled=true;
		  midStop.disabled=true;
		  chkRep.disabled=false;
			chkMax.disabled=true;
			mBtnSave.style.display='none';
			mBtnRestore.style.display='';
			break;
		case 'PS':
		  chkStop.disabled=true;
		  midStop.disabled=true;
		  chkRep.disabled=false;
			chkMax.disabled=true;
			mBtnSave.style.display='none';
			mBtnRestore.style.display='';
			break;		
		case 'TR':
			chkRep.disabled=true;
			mBtnSave.style.display='';
			mBtnRestore.style.display='none';
			chkStop.disabled=true;
		  	midStop.disabled=true;
		  	chkMax.disabled=true;
		  	mBtnSave.style.display='none';
			break;
		default:
			chkStop.disabled=false;
			midStop.disabled=false;
			chkRep.disabled=false;
			chkMax.disabled=false;
			mBtnSave.style.display='';
			mBtnRestore.style.display='none';
			break;
	}	
}

function ShowMax()
{
	var obj=document.getElementById('tDHCApptSchedule_Edit');
	if (!obj) obj=document.getElementById('tDHCApptSchedule_Edit0');
	
	if (!obj) return ;
	
	DHCC_ClearTable("tDHCApptSchedule_Edit");
	DHCC_ClearTable("tDHCApptSchedule_Edit0");
	
	if (mGetAppQty.value != '')
	{
		ClearInitRow(obj);
		var ret = cspHttpServerMethod(mGetAppQty.value,mId.value);
		if (!ret) return ;
		//var str = "1^1^3";
		var retArray = ret.split(",");
		for(var i=0;i<retArray.length;i++)
		{
			AddMax(obj,retArray[i]);
		}
	}
}
function ClearInitRow(objtbl)
{
	try
	{
		if (!objtbl.rows) return;
		var rlen = objtbl.rows.length;
		if (rlen==1){return;}
		for(var i=1;i<rlen-1;i++)
		{
			if (objtbl.rows[i])	objtbl.deleteRow(i);
		}
		rowitems = objtbl.rows[1].getElementsByTagName('*');
		for(var i=0;i<rowitems.length;i++)
		{
			if(rowitems[i].id)
			{
			  var Id=rowitems[i].id;
				var arrId=Id.split("z");
				arrId[arrId.length-1]=1;
				rowitems[i].id=arrId.join("z");
		}
		}
		objtbl.rows[1].style.display = 'none';
	}
	catch (e)
	{
		alert(e.message);
	}
	
}

function AddMax(objtbl,value) 
{
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6

	var lbl = objnewrow.getElementsByTagName("label");
	if (!lbl) return ;

	var array = value.split("^");
	if (array.length<1) return ;
	
	var i=0;
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value=array[i];
			rowitems[j].innerText=array[i];
			i++;
		}
	}
	objnewrow.style.display = '';
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}

function SetRowValue(value,value1)
{
	if (!mSelectedRow){
		alert(t['selectMaxFailMsg']);	
		return ;
	}
	var rowitems=mSelectedRow.all; //IE only
	if (!rowitems) rowitems=mSelectedRow.getElementsByTagName("*"); //N6
	
	for(var i=0;i<rowitems.length;i++)
	{
		if (rowitems[i].id)	
		{
			if (rowitems[i].id == 'TMaxValuez'+mSelectedRow.rowIndex)
			{
				rowitems[i].innerText = value;
				//break;
			}
			if (rowitems[i].id == 'TStartNumz'+mSelectedRow.rowIndex)
			{
				rowitems[i].innerText = value1;
				//break;
			}
		}
	}
}

function checkMax(){
	var obj=document.getElementById('tDHCApptSchedule_Edit');
	if (!obj) obj=document.getElementById('tDHCApptSchedule_Edit0');
	
	if (!obj) return 0;
	
	if (!obj.rows) return 0;
	var ret = 0;
	for(var j=2;j<obj.rows.length;j++)  {
			var rowitems=obj.rows[j].all; //IE only
			if (!rowitems) rowitems=obj.rows[j].getElementsByTagName("*"); //N6
			
			for(var i=0;i<rowitems.length;i++)
			{
				if (rowitems[i].id)	
				{
					 if (rowitems[i].id == 'TMaxValuez'+obj.rows[j].rowIndex)	{
							ret =ret+parseInt(rowitems[i].innerText);
						}
				}
			}
	}
	return ret;	
}

function getMax()
{
	var obj=document.getElementById('tDHCApptSchedule_Edit');
	if (!obj) obj=document.getElementById('tDHCApptSchedule_Edit0');
	if (!obj) return ;
	
	if (!obj.rows) return ;
	var ret = '';
	for(var j=2;j<obj.rows.length;j++)  //first row hidden;
	{
			var rowitems=obj.rows[j].all; //IE only
			if (!rowitems) rowitems=obj.rows[j].getElementsByTagName("*"); //N6
			
			for(var i=0;i<rowitems.length;i++)
			{
				if (rowitems[i].id)	
				{
					 if (rowitems[i].id == 'TMaxIdz'+obj.rows[j].rowIndex)
						{
							ret +=rowitems[i].value+'^';
						}
					 if (rowitems[i].id == 'TMaxz'+obj.rows[j].rowIndex)
						{
							ret +=rowitems[i].innerText+'^';
						}
					 if (rowitems[i].id == 'TMaxValuez'+obj.rows[j].rowIndex)
						{
							ret +=rowitems[i].innerText+'^';
						}
					if (rowitems[i].id == 'TStartNumz'+obj.rows[j].rowIndex)
						{
							ret +=rowitems[i].innerText+'^';
						}
				}
			}
			if (ret.length>0) ret = ret.substring(0,ret.length-1);
			ret += ",";
	}
	if (ret.length>0) ret = ret.substring(0,ret.length-1);
	
	return ret;	
}
function setStop()
 {
	if (chkStop.checked&&midStop.checked){
		alert(t['stopSelected'])
		return false;
	}
	 
	if (trStop && chkRep) {
		if (chkRep.checked)
		{
			alert(t['stopErrMsg']);
			chkStop.checked = false;
			midStop.checked = false;
			return ;
		}
		if (trStop.style.display == '') {
			trStop.style.display = 'none';
			//mBtnSave.style.display='none'
		} else {
			trStop.style.display = '';
			mBtnSave.style.display=''
		}
		
	}
}
function setReplace()
 {
	if (chkStop && trRep) {
		if (chkStop.checked){
			alert(t['repErrMsg']);
			chkRep.checked = false;
			return ;
		}
		if (midStop.checked){
			alert(t['repErrMsg']);
			chkRep.checked = false;
			return ;
		}
		if (trRep.style.display == '') {
			trRep.style.display = 'none';
			//mBtnSave.style.display='none'
		} else {
			mBtnRestore.style.display='none'
			mBtnSave.style.display=''
			trRep.style.display = '';
			var LocId=mLocId.value;
			if ((combo_ERepLoc)&&(LocId!="")) {
				combo_ERepLoc.setComboValue(LocId);
				combo_ERepLocKeydownhandler()
			}
		}
		
	}
}

function setMax()
 {
	 if(mId.value==""){
		 alert("请先选中排版!")
		 return false;
	 }
	if (chkStop && trMax) {
		if (chkStop.checked)
		{
			alert(t['stopWarning']);
			chkMax.checked = false;
			return ;
		}
		if (midStop.checked)
		{
			alert(t['stopWarning']);
			chkMax.checked = false;
			return ;
		}
		if (trMax.style.display == '') {
			trMax.style.display = 'none';
			mBtnSave.style.display=''
		} else {
			var EMaxName=document.getElementById('EMaxName');
			if (EMaxName) EMaxName.disabled=false;
			ClearEMax();
			ShowMax();
			trMax.style.display = '';
			mBtnSave.style.display=''
			
		}
		
	}
}

function SetRepValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mRepReasonId = strArray[2];
}

function SetStopValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mStopReasonId = strArray[2];
}
function SetRepLocValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mRepLocId.value = strArray[2];
}

function SetLocValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mLocId.value = strArray[2];
}

function SetDoctorValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mDoctorId.value = strArray[2];
}

function SetLocAreaValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mLocAreaId.value = strArray[2];
	
}

function SetRepDoctorValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mRepDoctorId = strArray[2];
}


function SetStopLeaderValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mStopLeaderId = strArray[2];
}

function SetRepLeaderValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mRepLeaderId = strArray[2];
}

function SetSessionTypeValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) mSessionTypeId.value = strArray[2];	
}

function SetTimeRangeValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>4) mTimeRange = strArray[3]+'^'+strArray[4];	
}

function SetClinicGroupValue(str)
{
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>1) mClinicGroupId.value = strArray[1];	
}
// select readonly   
function setReadOnly(obj){   
    obj.onmouseover = function(){   
        obj.setCapture();   
    }   
    obj.onmouseout = function(){   
        obj.releaseCapture();   
    }   
    obj.onfocus = function(){   
        obj.blur();   
    }   
    obj.onbeforeactivate = function(){   
        return false;   
    }    
}
function chkAdd_click()
{
	if (chkAdd.checked&&chkRepair.checked){
		alert(t['chkAddErr'])
		return false;
	}
}
function chkTimeRange_click(){
	if ( chkTimeRange.checked){
		trTimeRange.style.display = '';
		var ETimeStart=document.getElementById("ETimeStart").value
		var ETimeEnd=document.getElementById("ETimeEnd").value
		document.getElementById("TRStartTime").value=ETimeStart
		document.getElementById("TREndTime").value=ETimeEnd
		
	}else{
		trTimeRange.style.display = 'none';
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
function GetRow(Rowindex){
	var objtbl=document.getElementById('tDHCApptSchedule_Edit');
	if (!objtbl) var objtbl=document.getElementById('tDHCApptSchedule_Edit0');
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
function ClearEMax()
{
	var EMaxId = document.getElementById('EMaxId');
	var EMaxName=document.getElementById('EMaxName');
	var EMaxValue=document.getElementById('EMaxValue');
	var StartNumValue=document.getElementById('StartNum');
	EMaxId.value = '';
	EMaxName.value = '';
	EMaxValue.value = '';
	StartNumValue.value='';
}
document.body.onload = BodyLoadHandler;

