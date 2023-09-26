function BodyLoadHandler() {
	var tbl=document.getElementById("tMRDiagnos_Snomed_List");
	for (var i=1;i<tbl.rows.length;i++) {	
		var obj=document.getElementById("Editz"+i);
		if (obj) obj.onclick=EditClickHandler;
		var objDel=document.getElementById("delete1z"+i);
		if (objDel) objDel.onclick=DelClickHandler;
	}
}

function EditClickHandler(evt) {
	var evtSrcElm=websys_getSrcElement(evt);
	var ary=evtSrcElm.parentElement.id.split("Editz");
	var IsICD=0;
	var CONTEXT="";
	var mradm="";
	var id="";
	if(ary[1]!="") {
		var mradmobj=document.getElementById("mradmz"+ary[1]);
		if(mradmobj) mradm=mradmobj.value;
		var isicdobj=document.getElementById("IsICDz"+ary[1]);
		if (isicdobj) IsICD=isicdobj.value;
		var CONTEXTObj=document.getElementById("CONTEXT");
		if (CONTEXTObj) CONTEXT=CONTEXTObj.value;
		var Patientobj=document.getElementById("PatientID");
		if(Patientobj) PatientID=Patientobj.value;
		var obj=document.getElementById("IDz"+ary[1]);
		if(obj) {
			if ((obj.value!="") && (mradm!="")) id=mradm+"||"+obj.value;
			if (IsICD==0) {
				var url="pacsnomed.edit.csp?SNOeditcomp=MRDiagnos.Snomed.Edit&ID="+id+"&PARREF="+mradm+"&SNQglob=Diag";
				websys_createWindow(url,"snomed_main");
			}
			// Log 64253 YC - If the Diagnosis is an ICD diagnosis then open MRDiagnos.Edit
			if(IsICD==1&&id!="") {
				var url="websys.default.csp?WEBSYS.TCOMPONENT=MRDiagnos.Edit&ID="+id+"&PARREF="+mradm+"&mradm="+mradm+"&CONTEXT="+CONTEXT+"&PatientBanner=1&PatientID="+PatientID;
				websys_createWindow(url,'EditDiagnosis','scrollbars=yes,toolbar=no,resizable=yes');
			}
		}
	}
	
	return false;
}

function DelClickHandler() {
	if(!confirm(t['CONFIRM_DELETE'])) return false;
}

document.body.onload=BodyLoadHandler;