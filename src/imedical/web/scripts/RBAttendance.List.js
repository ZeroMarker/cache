// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl;

function ListBodyLoadHandler() {

	//tbl=document.getElementById["tRBAttendance_List"]; //getElementBy doesnt seem working here...
	var ary=document.getElementsByTagName("table");
	for (var i=0; i<ary.length; i++) {
		if(ary[i].id=="tRBAttendance_List") {
			tbl=ary[i];
			break;
		}
	}

	if (tbl) {
		for (var row=1;row<=tbl.rows.length;row++){
			var obj=document.getElementById("firstz"+row);
			if(obj) obj.onclick=function() {return false;}

			var attdate=document.getElementById("ATTDatez"+row);
			if(attdate) attdate.onclick=ATTDateClickHandler;

			var icon=document.getElementById("iconz"+row);
			if (icon) icon.onclick=function() {return false;}
		}
	}

	highlightOutcome();
	var obj=document.getElementById("find");
	if(obj) obj.onclick=findClickHandler;

	obj=document.getElementById("new");
	if(obj) obj.onclick=NewClickHandler;

}

function highlightOutcome() {
	var hidoutcome=document.getElementById("hidOutcome");
	var obj=document.getElementById("outcomes");
	if(!obj || !hidoutcome || hidoutcome.value=="") return;

	for(var i=0; i<obj.length; i++) {
		if(hidoutcome.value.indexOf(obj.options[i].value+"^")>=0)
			obj.options[i].selected=true;
	}
}

function buildOutcomeStr() {
	var hidoutcome=document.getElementById("hidOutcome");
	var obj=document.getElementById("outcomes");
	var str="";

	if(obj && hidoutcome) {
		for(var i=0; i<obj.length; i++) {
			if(obj.options[i].selected)
				str+=obj.options[i].value+"^";
		}
		hidoutcome.value=str;
	}
}

function findClickHandler() {
	buildOutcomeStr();
	var obj=document.getElementById("DiaryType")
	var rego=document.getElementById("RegistrationNo")
	var patid=document.getElementById("PatientID")
	if ((obj)&&(rego)&&(patid)) {
		if ((obj.value=="O")&&((rego.value=="")&&(patid.value!=""))) document.getElementById("PatientID").value=""
	}
	find_click();
}

function ATTDateClickHandler() {
	var row=this.id.substr(8);
	var ID="";
	var patientID="";
	var obj=document.getElementById("attendIDz"+row);
	if(obj) ID=obj.value;
	obj=document.getElementById("PatientIDz"+row);
	if(obj) patientID=obj.value;
	var url= "websys.default.csp?WEBSYS.TCOMPONENT=RBAttendance.Edit&ID="+ID+"&PatientID="+patientID;
	// 64049 RC added this as patient banner was displaying twice in the frames.
	if (self.frames.name!="rbattendancelist") url+="&PatientBanner=1"
	websys_createWindow(url,'rbattendanceedit',"toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

function NewClickHandler() {
	var ID="";
	var patientID=""; var newwkfl=""
	obj=document.getElementById("PatientID");
	if(obj) patientID=obj.value;
	obj=document.getElementById("newwkfl");
	if(obj) newwkfl=obj.value;
	var url= "websys.csp?TWKFL="+newwkfl+"&ID=&PatientID="+patientID;
	// 64049 RC added this as new and date links weren't displaying as expected in the frame.
	if (self.frames.name=="rbattendancelist") url="websys.default.csp?WEBSYS.TCOMPONENT=RBAttendance.Edit&ID=&PatientID="+patientID
	websys_createWindow(url,'rbattendanceedit',"toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

document.body.onload=ListBodyLoadHandler;
