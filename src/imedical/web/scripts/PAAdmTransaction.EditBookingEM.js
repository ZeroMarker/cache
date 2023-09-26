//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
function BodyLoadHandler() {
	if (self==top) websys_reSizeT();

	setCheckBoxFlag()

	//ab 4.06.02 - Location is mandatory
	var obj=document.getElementById("Ward");
	if ((obj)&&(obj.value!="")) labelMandatory("NotifLoc");

	var obj=document.getElementById("TRANSBedDR");
	if (obj) obj.onblur=CheckForBlankBed;
	
	var obj=document.getElementById('PAADMInpatBedReqDate');
	if (obj) obj.onblur=StartDateBlurHandler;
	
	var obj=document.getElementById('HOSPITAL');
	if (obj) obj.onblur=HospBlurHandler;

 	var obj=document.getElementById('update1')
	if (obj) obj.onclick = UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
}

function DocLookUpSelect(str) {
	var lu=str.split("^");
	var obj=document.getElementById("NotifLoc");
	if ((obj)&&(lu[2]!="")) obj.value=lu[2];
	var obj=document.getElementById('NotifDoc');
	if (obj) obj.value=lu[0];
}

function setCheckBoxFlag() {
	var str=new Array();
	var IsOnForm=document.getElementById('HiddenCheckbox');
	var obj=document.getElementById('PAADM2CriteriaTypeC');
	if (obj) { str[0]="Y" } 
	IsOnForm.value=str.join("^");
	
}

function UpdateHandler() {
	var msg="";
	var obj=document.getElementById('Ward');
	var loc=document.getElementById('NotifLoc');
	var bed=document.getElementById('TRANSBedDR');
	if ((obj)&&(obj.value!="")&&(loc)&&(loc.value=="")) {
		msg += "\'" + t['NotifLoc'] + "\' " + t['XMISSING'] + "\n";
	}
	//lg31045

	if ((loc)&&(loc.className=="clsInvalid")) {
		msg += "\'" + t['NotifLoc'] + "\' " + t['XINVALID'] + "\n"
	}
	if ((obj)&&(obj.className=="clsInvalid")) {
		msg += "\'" + t['Ward'] + "\' " + t['XINVALID'] + "\n";
	}
	if ((bed)&&(bed.className=="clsInvalid")) {
		msg += "\'" + t['TRANSBedDR'] + "\' " + t['XINVALID'] + "\n";
	}
			
	if (msg != "") {alert(msg);return false;}
	CheckForOTBookings();
	return update1_click();

}

function CheckForOTBookings() {
	var objPatid=document.getElementById("PatientID");
	var objEpisodeID=document.getElementById("EpisodeID");
	var objstDate=document.getElementById("PAADMInpatBedReqDate");
	var objcpreadmin=document.getElementById("BedReady");
	if (objPatid&&objEpisodeID&&objstDate&&objcpreadmin&&objcpreadmin.checked) 
	{
		//alert(objcpreadmin.value);
		//alert(objcpreadmin.checked);
		//alert("objEpisodeID.value="+objEpisodeID.value+"objPatid.value="+objPatid.value+"objcpreadmin.value="+objcpreadmin.value+"objstDate.value="+objstDate.value);
		var preadmfromOT=tkMakeServerCall("web.PAAdm","CheckForOTBookingsOnEDBedR",objEpisodeID.value,objPatid.value,objcpreadmin.value,objstDate.value);
		//alert(preadmfromOT);
		var preadmfromOTparts=preadmfromOT.split("^");
		if (preadmfromOTparts[0]!=0)
			{
			 //alert(preadmfromOT);
			 if (confirm(t['LinkToLastPreadm']+preadmfromOTparts[1])) 
			    {
				var objlastpreadmin=document.getElementById("LastPreadm");
				if (objlastpreadmin) objlastpreadmin.value=preadmfromOTparts[0];
			     }
			}
	}
}

function mandatoryLocation() {
	var obj=document.getElementById("Ward");
	if (obj) {
		if (obj.value!="") { labelMandatory('NotifLoc') } else { labelNormal('NotifLoc'); }
	}
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) lbl=lbl.className = "clsRequired";
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld) 
	if (lbl) lbl=lbl.className = "";
}

function WardChangeHandler2(str) {
	var lu = str.split("^");
	var obj=document.getElementById('NotifLoc');
	if ((obj)&&(obj.disabled)) obj.value = "";
	var obj=document.getElementById('TRANSBedDR');
	if (obj) {
		obj.value = "";
		var obj=document.getElementById('BedID');
		if (obj) obj.value = "";
	}
	try {mandatoryLocation()} catch(e) {}
}

function LocationChangeHandler2(str) {
	var lu = str.split("^");
	if (lu[1]!="") {
		var obj1=document.getElementById('NotifLoc')
		if (obj1) obj1.value=lu[1];
		var obj2=document.getElementById('NotifDoc');
		if ((obj2)&&(obj2.value!="")) {
			var obj3=document.getElementById('CareProvLocDesc');
			if ((obj3)&&(obj1.value.indexOf(obj3.value)==-1)) obj2.value="";
		}
		var obj=document.getElementById("TRANSBedDR");
		if ((obj)&&(obj.disabled)) obj.value="";
		var obj=document.getElementById("Ward");
		if ((obj)&&(obj.disabled)) obj.value="";
	}
}

function CheckForBlankBed() {
    var obj=document.getElementById("TRANSBedDR");
	if ((obj)&&(obj.value=="")) {
		var obj=document.getElementById("BedID");
		if (obj) obj.value="";
	}
}

function StartDateBlurHandler(e) {
	var eobj=websys_getSrcElement(e);
	if (eobj) {
		var obj=document.getElementById("TRANSStartDateH");
		if ((obj)&&(eobj.value!="")) obj.value=DateStringTo$H(eobj.value);
		if ((obj)&&(eobj.value=="")) obj.value=obj.defaultValue;
	}
}

// ab 21.01.04
function HospLookupSelect (str) {
	var lu = str.split("^");
	var obj=document.getElementById("HospID");
	if (obj) obj.value=lu[1];
}

function HospBlurHandler() {
	var obj=document.getElementById("HOSPITAL");
	var objID=document.getElementById("HospID");
	if ((obj)&&(obj.value=="")) objID.value="";
}

document.body.onload=BodyLoadHandler;
