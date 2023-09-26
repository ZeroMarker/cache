var doc = parent.frames[1].document;
var ELoc;
var ELocArea;
var EDoctor;
var EPositiveMax;
var EAddtionMax;
var EApptMax;
var Efee;
var EId;
var ELocId;
var EDoctorId;
var ELocAreaId;
var EScheduleDate;
var ESessionStartTime;
var ETimeRange;
var ESessionType;
var EClinicGroup;
var AllDocStr=""
	
document.body.onload = BodyLoadHandler;
var e=event;
function BodyLoadHandler(){
	var obj = document.getElementById("LocationName");
	if (obj) obj.onchange = ELoc_ChangeHandler;

	var obj = document.getElementById("btnNew");
	if (obj) obj.onclick = btnNew_click;

	var LocationName=DHCC_GetElementData('LocationName');
	var DoctorName=DHCC_GetElementData('DoctorName');
	if (document.getElementById('LocationName')){
		var DepStr=DHCC_GetElementData('DepStr');
		combo_Location=dhtmlXComboFromStr("LocationName",DepStr);
		combo_Location.enableFilteringMode(true);
		combo_Location.selectHandle=combo_LocationKeydownhandler;
		//combo_Location.attachEvent("onKeyPressed",combo_LocationKeyenterhandler)
		
		combo_Location.setComboText(LocationName)
	}
	websys_setfocus('DoctorName');

	if (document.getElementById('DoctorName')){
		var UserID=session["LOGON.USERID"];
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		AllDocStr=cspRunServerMethod(encmeth,"","","",UserID);
		combo_DoctorName=dhtmlXComboFromStr("DoctorName",AllDocStr);
		combo_DoctorName.enableFilteringMode(true);
		combo_DoctorName.selectHandle=combo_DoctorNameKeydownhandler;
		
		combo_DoctorName.setComboText(DoctorName);
		}

	if (document.getElementById('ClinicGroupName')){
		var ClinicStr=DHCC_GetElementData('ClinicStr');
		combo_ClinicGroupName=dhtmlXComboFromStr("ClinicGroupName",ClinicStr);
		combo_ClinicGroupName.enableFilteringMode(true);
		combo_ClinicGroupName.selectHandle=combo_ClinicGroupNameKeydownhandler;
	}
	
	var obj=document.getElementById('tDHCOPAdm_Reg_MarkList');
	if (obj) obj.ondblclick = MarkTableDblClickHandler;
	if (obj) obj.onkeydown = MarkTableKeyDownHandler;

	var obj=document.getElementById('ScheduleDate');
	if (obj) obj.onkeydown=ScheduleDateKeydownHandler;

	var obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
	
	InitStatus();
	setTimeout('SetComboText(\''+DoctorName+'\')',100);

}
function SetComboText(txt){
	combo_DoctorName.setComboText(txt);
}
function FindClickHandler(e){
	var LocationName=DHCC_GetElementData('LocationName');
	var DoctorName=DHCC_GetElementData('DoctorName');
	Find_click();
}
function ScheduleDateKeydownHandler(e){
	var obj= document.getElementById("ScheduleDate")
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(obj.tabIndex);
	}
}
/*
function combo_LocationKeyenterhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		combo_LocationKeydownhandler();
	}
}
*/
function combo_LocationKeydownhandler(){
	var DepRowId=combo_Location.getActualValue();
	var DepDesc=combo_Location.getSelectedText();
	if (combo_DoctorName){
		combo_DoctorName.clearAll();
		combo_DoctorName.setComboText("");
		var UserID=session["LOGON.USERID"];
		var encmeth=DHCC_GetElementData('GetResDocEncrypt');
		if ((encmeth!="")&&(DepRowId!="")){
			combo_DoctorName.addOption('');
			var DocStr=cspRunServerMethod(encmeth,DepRowId,"","",UserID);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				combo_DoctorName.addOption(Arr);
			}
		}
		
		if (DepRowId==""){
			var Arr=DHCC_StrToArray(AllDocStr);
			combo_DoctorName.addOption(Arr);
		}
		DHCC_SetElementData('LocationID',DepRowId)
	}

	websys_nexttab(combo_Location.tabIndex);

}
function combo_DoctorNameKeydownhandler(){
	var DoctorRowId=combo_DoctorName.getActualValue();
	websys_nexttab(combo_DoctorName.tabIndex);

}
function combo_ClinicGroupNameKeydownhandler(){
	var DoctorRowId=combo_ClinicGroupName.getActualValue();
	websys_nexttab(combo_ClinicGroupName.tabIndex);

}

function SetLocValue(str)
{
	var obj = document.getElementById("LocationID");
	if (!obj) return ;
	if (!str) return ;
	var strArray = str.split("^")
	if (strArray.length>2) obj.value = strArray[2];
}
	
function InitStatus()
{
	var objtbl=document.getElementById('tDHCApptSchedule_List');
	if (!objtbl) objtbl=document.getElementById('tDHCApptSchedule_List0');
	if (objtbl)
	{
		var rows = objtbl.rows;
		var ts;
		for(var i=1;i<rows.length;i++)
		{
			ts = document.getElementById("TStatusz"+i);
			if (ts)
			{
				switch(ts.value)
				{
				
					case 'S':
						//alert(ts.value)
					 	//rows[i].className='ScheduleStop';
					 	rows[i].style.backgroundColor="red"	
					 	break;
					case 'PS':
						rows[i].style.backgroundColor="red"	
					 	//rows[i].className='ScheduleStop';	
					 	break;
					case 'TR':
					 	//rows[i].className='SqueezedIn';
					 	rows[i].style.backgroundColor="Thistle"		
					 	break;
					case 'R':
					 	rows[i].className='ScheduleReplace';
					 	rows[i].style.backgroundColor="yellow"		
					 	break;
					case 'X':
						//rows[i].className='RowSeparator';
						break;
				}
				var IrregularFlag = DHCC_GetColumnData("IrregularFlag",i);
				if ((IrregularFlag=="A")&&(ts.value=="N")) {
				 	rows[i].style.backgroundColor="purple"	
				}
			}
		}	
	}
}
function SelectRowHandler()
{
	//try
	//{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCApptSchedule_List');
	//var tables = document.getElementsByTagName("table");
	if (!objtbl) objtbl = document.getElementById('tDHCApptSchedule_List0');;
	if (!objtbl) return ;

	var rows=objtbl.rows.length;

	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (!doc) return ;

	 ELoc=doc.getElementById('ELoc');
	 ELocArea=doc.getElementById('ELocArea');
	 EDoctor=doc.getElementById('EDoctor');
	 EPositiveMax=doc.getElementById('EPositiveMax');
	 EAddtionMax = doc.getElementById('EAddtionMax');
	 EApptMax=doc.getElementById('EApptMax');
	 Efee=doc.getElementById('Efee');
	 EId = doc.getElementById('EId');
	 ELocId = doc.getElementById('ELocId');
	 EDoctorId = doc.getElementById("EDoctorId");
	 ELocAreaId = doc.getElementById("ELocAreaId");
	 EScheduleDate = doc.getElementById("EScheduleDate");
	 ESessionStartTime = doc.getElementById("ESessionStartTime");
	 //ESessionStartTime = doc.getElementById("ETimeStart");
	 ETimeEnd = doc.getElementById("ETimeEnd");
	 ETimeStart = doc.getElementById("ETimeStart");
	 EStartPrefix=doc.getElementById("EStartPrefix");
	 //ETimeRangeId=doc.getElementById("ETimeRangeId");
	 ESessionType	=doc.getElementById('ESessionType');
	 EClinicGroup	=doc.getElementById('EClinicGroup');
	 ESessionTypeId	=doc.getElementById('ESessionTypeId');
	 EClinicGroupId	=doc.getElementById('EClinicGroupId');
	 ETimeRange=doc.getElementById('ETimeRange');
	 ELockFlag=doc.getElementById('LockFlag');
	 
	var Sel_ELoc=document.getElementById("TLocz"+selectrow);
	var Sel_ELocArea=document.getElementById('TLocAreaz'+selectrow);
	var Sel_EDoctor=document.getElementById('TDoctorz'+selectrow);
	var Sel_EDoctorId=document.getElementById('TDoctorIdz'+selectrow);
	var Sel_EPositiveMax=document.getElementById('TPositiveMaxz'+selectrow);
	var Sel_EAddtionMax=document.getElementById('TAddtionMaxz'+selectrow);
	var Sel_EApptMax=document.getElementById('TApptMaxz'+selectrow);
	var Sel_Efee=document.getElementById('Tfeez'+selectrow);
	var Sel_EId = document.getElementById('TIdz'+selectrow);
	var Sel_ELocAreaId = document.getElementById('TLocAreaIdz'+selectrow);
	var Sel_ELocId = document.getElementById('TLocIdz'+selectrow);
	var Sel_EScheduleDate = document.getElementById('TScheduleDatez'+selectrow);
	var Sel_EStatus = document.getElementById('TStatusz'+selectrow);
	var Sel_ESessionStartTime = document.getElementById('TSessionStartTimez'+selectrow);
	var Sel_ESessionEndTime = document.getElementById('TSessionEndTimez'+selectrow);
	var Sel_EStartPrefix = document.getElementById('TStartPrefixz'+selectrow);
	var Sel_ESessionType = document.getElementById('TSseionTypez'+selectrow);
	var Sel_EClinicGroup = document.getElementById('TClinicGroupz'+selectrow);
	var Sel_ESessionTypeId = document.getElementById('TSessionTypeIdz'+selectrow);
	var Sel_EClinicGroupId = document.getElementById('TClinicGroupIdz'+selectrow);
	var Sel_ETimeRange = document.getElementById('TDateDiffz'+selectrow);

	if (rowObj.className != "clsRowSelected")
	{    
		if (parent.frames[1]){parent.frames[1].ClearNormal();}	
		
	}	else	{  
		ELoc.value = Sel_ELoc.innerText;
		ELocArea.value = Sel_ELocArea.innerText;
		EDoctor.value = Sel_EDoctor.innerText;
		EPositiveMax.value = Trim(Sel_EPositiveMax.innerText);
		EAddtionMax.value = Trim(Sel_EAddtionMax.innerText);
		EApptMax.value = Trim(Sel_EApptMax.innerText);
		Efee.value = Sel_Efee.innerText;
		EId.value = Sel_EId.value;
		EDoctorId.value = Sel_EDoctorId.value;
		ELocAreaId.value = Sel_ELocAreaId.value;
		ELocId.value = Sel_ELocId.value;
		EScheduleDate.value = Sel_EScheduleDate.innerText;
		ESessionStartTime.value = Sel_ESessionStartTime.value;
		ETimeEnd.value =Sel_ESessionEndTime.value;
		ETimeStart.value =Sel_ESessionStartTime.value;
		EStartPrefix.value=Trim(Sel_EStartPrefix.innerText);
		ESessionType.value=Sel_ESessionType.innerText;
		EClinicGroup.value=Sel_EClinicGroup.value;
		ETimeRange.value=Sel_ETimeRange.innerText;
		ESessionTypeId.value=Sel_ESessionTypeId.value;
		EClinicGroupId.value=Sel_EClinicGroupId.value;
		//alert(ETimeEnd.value+"$$$"+ETimeStart.value)
		if (ELockFlag){
			var LockFlag=DHCC_GetColumnData('TLockFlag',selectrow);
			ELockFlag.checked=LockFlag;
		}	 
				
		if (parent.frames[1])
		{
			parent.frames[1].LoadMax(Sel_EStatus.value);
		}		
		var obj=doc.getElementById('TimeRangeFlag');
		if (obj) obj.checked=DHCC_GetColumnData('TTRFlag',selectrow);
		if (parent.frames[1]) parent.frames[1].chkTimeRange_click();
		var obj=doc.getElementById('TRStartTime');
		if (obj) obj.value=DHCC_GetColumnData('TTRStartTime',selectrow);
		var obj=doc.getElementById('TREndTime');
		if (obj) obj.value=DHCC_GetColumnData('TTREndTime',selectrow);
		var obj=doc.getElementById('TRLength');
		if (obj) obj.value=DHCC_GetColumnData('TTRLength',selectrow);
		var obj=doc.getElementById('TRRegNum');
		if (obj) obj.value=DHCC_GetColumnData('TTRRegNum',selectrow);
		var obj=doc.getElementById('TRRegNumStr');
		if (obj) obj.value=DHCC_GetColumnData('TTRRegNumStr',selectrow);
		var obj=doc.getElementById('TRRegInfoStr');
		if (obj) obj.value=DHCC_GetColumnData('TTRRegInfoStr',selectrow);
		var obj=doc.getElementById('AddRegNum');
		if (obj) obj.value=DHCC_GetColumnData('TAddRegNum',selectrow);
		//alert(EScheduleDate.value+':'+ETimeEnd.value+':'+ETimeStart.value);
	}
	SelectedRow = selectrow;
	
	
		
/**
	}
	catch (e)
	{
		alert(e.message);
	}
**/
}
function ELoc_ChangeHandler()
{
	var obj = document.getElementById("LocationName");
		if (obj) 
		{
			var locId = document.getElementById("LocationID");
			if (!locId) return ;
			locId.value = '';
			}
	}

function ResetRowStatus(obj)
{
		if (!obj) return ;
		var rows = obj.all;
		if (!rows) return ;
		var o;
		for(var i=0;i<rows.length;i++)
		{
		  	o = document.getElementById('TLocz'+(i+1));
		  	if (!0) continue;
		  	o.parentElement.style='background-color:red';	
		}
}

function btnNew_click()
{
		if (parent.frames[1])
		{
		
			parent.frames[1].InitNew();
		}
}