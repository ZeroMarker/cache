// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var f=document.getElementById("fRBDeptFuncPreferences_Custom");
var today=document.getElementById("today").value.split("^");

function docLoaded() {
	var obj=document.getElementById("Preference1");
	obj.multiple=false;
	websys_reSize();
	var obj=document.getElementById("defaultCP");
	if (obj) obj.onblur=DefaultCPBlurHandler;
}

function LookUpExtraClinic(val) {
	f.ExtraClinic.value="";
	var ary=val.split("^")
	var txt=ary[1]+" - "+ary[0]+" ("+today[1]+")";
	var val=ary[3]
	AddItemSingle(f.ExtraClinicSelect,val,txt);
	setExtraClinicDetails("","","");
}

function LookUpDefaultCPHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById("defaultCP");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("defaultCPID");
	if (obj) obj.value=lu[0];
}

function DefaultCPBlurHandler() {
	var obj=document.getElementById("defaultCP");
	if (obj&&obj.value=="") {
		var obj1=document.getElementById("defaultCPID");
		if (obj1) obj1.value="";
	}
}

function setExtraClinicDetails(id,dfrom,dto) {
	var obj=document.getElementById("ExtraClinicSelect");
	var aryD=document.getElementById("ExtraClinicDetails").value.split(",");
	if (obj) {
		var ary=returnValues(obj);
		var newary=new Array()
		for (var i=0; i<ary.length; i++) {
			var details=getExtraClinicDetail(ary[i],id,dfrom,dto,aryD).split("$");
			if (details[0]=="") {
				details[0]=ary[i];details[1]=today[0];details[2]=today[0];
			} else {
				if (obj.options[details[3]]) {
					if (obj.options[details[3]].value==id) {
						var txt=obj.options[details[3]].text.split("(");
						//obj.options[details[3]].text=txt[0]+"("+details[1]+" to "+details[2]+")";
						obj.options[details[3]].text=txt[0]+"("+dfrom+" to "+dto+")";
					}
				}
			}
			newary[i]=details.join("$");
		}
		document.getElementById("ExtraClinicDetails").value=newary.join(",");
	}
}
function getExtraClinicDetail(val,id,dfrom,dto,aryD) {
	var details="";
	for (var i=0; i<aryD.length; i++) {
		var Bary=aryD[i].split("$");
		if (val==Bary[0]) {
			details=aryD[i]+"$"+i;
			if (val==id) details=id+"$"+dfrom+"$"+dto+"$"+i;
		}
	}
	return details;
}

function deleteHandler() {
	var delobj=document.getElementById("deletedExtraClinics");
	var obj=document.getElementById("ExtraClinicSelect");
	if (obj) {
		if (delobj.value=="") {
			delobj.value=obj.value
		} else {
			delobj.value=delobj.value+"^"+obj.value
		}
		//document.getElementById("deletedExtraClinics").value=delobj.value
		//alert(delobj.value);
		ClearSelectedList(obj);
		setExtraClinicDetails("","","");
	}
	return false;
}

function DatesHandler(id,dfrom,dto) {
	setExtraClinicDetails(id,dfrom,dto);
}

function changeDatesHandler() {
	var obj=document.getElementById("ExtraClinicSelect");
	if (obj) {
		if (obj.selectedIndex>-1) {
			var aryD=document.getElementById("ExtraClinicDetails").value.split(",");
			var val=getExtraClinicDetail(obj.options[obj.selectedIndex].value,"","","",aryD);
			var ary=val.split("$");
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=webcommon.DateRange&ID='+ary[0]+'&dfrom='+ary[1]+'&dto='+ary[2],'dates','top=0,left=0,width=400,height=150');
		}
	}
	return false;
}

function updateHandler() {
	//Clear RBSession variables incase of changes.
	var win=window.opener.top.frames['eprmenu'];
	if (win) {
		if (win.RBSessID) win.RBSessID="";
		if (win.RBSessIDs) win.RBSessIDs="";
	}
	//alert(window.opener.top.frames[1].frames[1].name);
	//alert(window.opener.location);
	//alert(window.opener.name);
	var obj=document.getElementById("fRBDeptFuncPreferences_Custom")
	alert(window.opener.top.frames[1].name);
	if (obj) obj.target=window.opener.top.frames[1].name;
	//window.opener.location.reload();
	//window.close();
	return update1_click();
}
//LOG 27666 BC 11-9-2002 Enable the use of Location lists to limit the clinics shown based on value of SESS_Clinic_DR
function setClinList(str) {
	//introduced to allow possible blanking of fields if necessary
}

var obj=document.getElementById("delete1");
if (obj) obj.onclick=deleteHandler;
var obj=document.getElementById("updateDates");
if (obj) obj.onclick=changeDatesHandler;
//var obj=document.getElementById("update1");
//if (obj) obj.onclick=updateHandler;

window.onload=docLoaded;

