// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// AmiN:Log 23608  on 08 May 2002 
		//made changes to  LookUpPathwaySelect, UpdateClickHandler,ClearFields,BodyLoadHandler
		//added ClearAllList

function MRCIDDescLookUpSelect(str) {
	var lu=str.split("^");	
	var idesc=lu[0].split(" | ");  
	var icode=lu[1];	
	var obj=document.getElementById("MRCIDDesc");	
	if (obj) {
		obj.value="";		
		AddDiagnosisToList(idesc,icode);		
	}	
	ClearField();	
}

function AddDiagnosisToList(desc,code) {	
	var obj=document.getElementById("DiagnosisList");
	if (obj) {
		obj.selectedIndex = -1;			
		obj.options[obj.length] = new Option(desc,code);
	}
}

function AddAllStepsClickHandler() {

	var Pathway=""; 	var mradm=""; 	var PathEpID="";	var StepID="";
	var patid="";		var epid="";	var stepobj="";
	
	var pidobj=document.getElementById("PathwayID");
	if (pidobj) PathwayID=pidobj.value;

	var mObj=document.getElementById("PARREF");
	if (mObj) mradm=mObj.value;

	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;

	var eobj=document.getElementById("EpisodeID");
	if (eobj) epid=eobj.value;
}	

function LookUpPathwaySelect(str) { 			 			//Used for Problem field lookup
	var strArr=str.split("^");								
	
	var probIdObj=document.getElementById("PathwayID");  	
	if (probIdObj) probIdObj.value=strArr[0];	
	
	var probdescObj=document.getElementById("CPWDesc");  
	if (probdescObj) probdescObj.value=strArr[1];	
															
	stepstring=strArr[2]; 	  								

	var secondArr=stepstring.split("&&");			
													
	for (var i=0;i<secondArr.length-1;i++) { 			 
													
		var thirdArr=secondArr[i].split("$$");			

		var outcomeComelistObj=document.getElementById("StepsList");
		if (outcomeComelistObj) outcomeComelistObj.options[outcomeComelistObj.options.length]=new Option(thirdArr[1],thirdArr[0]);   
	}														
}	

function LookUpStepSelect(str) {						//Used for Goal field lookup
	var strArr=str.split("^")

	var sidObj=document.getElementById("StepID");   	//Hidden
	if (sidObj) sidObj.value=strArr[0];

	var sObj=document.getElementById("DAYSDesc");
	if (sObj) sObj.value=strArr[1];

	var eidObj=document.getElementById("PathEpID");  	//Hidden
	if (eidObj) eidObj.value=strArr[2];

	var eObj=document.getElementById("EPDesc");   
	if (eObj) eObj.value=strArr[3];
}

function AddStepClickHandler() {
	var Pathway="";
	var Episode="";
	var Step="";
	var mradm="";
	var PathwayID="";
	var PathEpID="";
	var StepID="";
	var patid="";
	var epid="";

	var pidobj=document.getElementById("PathwayID");
	if (pidobj) PathwayID=pidobj.value;

	var eidObj=document.getElementById("PathEpID");
	if (eidObj) PathEpID=eidObj.value;

	var sidObj=document.getElementById("StepID");
	if (sidObj) StepID=sidObj.value;

	var mObj=document.getElementById("PARREF");
	if (mObj) mradm=mObj.value;

	var pobj=document.getElementById("PatientID");
	if (pobj) patid=pobj.value;

	var eobj=document.getElementById("EpisodeID");
	if (eobj) epid=eobj.value;
	var url="mrclinicalpathways.itemlist.csp?PathwayID="+PathwayID+"&PathEpID="+PathEpID+"&mradm="+mradm+"&StepID="+StepID+"&PatientID="+patid+"&EpisodeID="+epid;
	//Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"","left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

function ViewDetailsClickHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	var PathwayID="";
	var pidobj=document.getElementById("PathwayID");
	if (pidobj) PathwayID=pidobj.value;
	var lnk = eSrc.href + "&PathwayID=" + PathwayID;
	if (PathwayID!=""){
		var url="MRCClinicalPathways.ListAll.csp?PathwayID="+PathwayID;
		//Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url,"","left=100,width=400,height=480,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
	}
	return false;
}


function SelectedOutcomeListOptions() {

	var AccumSelected="";
	var Outcome ="";
	var OutObj=document.getElementById("StepsList");	
	if (OutObj) {
		for (var i=0;i<OutObj.length;i++) {
			if (OutObj.options[i].selected==true) {
				AccumSelected=AccumSelected+OutObj.options[i].value+"^"; 
			}			
		}
	}
	return AccumSelected;
}

function UpdateClickHandler() {
	var StepsList=SelectedOutcomeListOptions();
	var stepobj=document.getElementById("StepsList");	
	if (stepobj) stepobj.value=StepsList;	
	
	var StepsIDs=SelectedOutcomeList();
	var sobj=document.getElementById("StepsIDs");	
	if (sobj) sobj.value=StepsIDs;
	
	var DiagnosisIDs=SelectedDiagnosisList();
	var diagobj=document.getElementById("DiagnosisIDs");
	if (diagobj) diagobj.value=DiagnosisIDs;
	
	Update_click();
	value = StepIDs+"$$"+DiagnosisIDs	
	return value;
}

function SelectedDiagnosisList() {
	var DiagnosisAccumSelected="";
	var Outcome ="";
	var OutObj=document.getElementById("DiagnosisList");	
	if (OutObj) {
		for (var i=0;i<OutObj.length;i++) {
			if (OutObj.options[i]) {
				DiagnosisAccumSelected=DiagnosisAccumSelected+OutObj.options[i].value+"^"; 
			}			
		}
	}
	//alert("DiagnosisAccumSelected== "+DiagnosisAccumSelected);	
}

function SelectedOutcomeList() {
	var AccumSelected="";
	var Outcome ="";
	var OutObj=document.getElementById("StepsList");	
	if (OutObj) {
		for (var i=0;i<OutObj.length;i++) {
			if (OutObj.options[i].selected==true) {
				AccumSelected=AccumSelected+OutObj.options[i].value+"^"; 
			}			
		}
	}
	return AccumSelected;
}

function ClearFields() {
	var pobj=document.getElementById("CPWDesc");

	if (pobj.value=="") {
		var eObj=document.getElementById("EPDesc");
		if (eObj) eObj.value="";
	
		var sObj=document.getElementById("DAYSDesc");
		if (sObj) sObj.value="";
		
		var stepObj=document.getElementById("StepsList");
		if (stepObj) ClearAllList(stepObj);		
	}
}

function ClearAllList(obj) {         //This function removes ALL the options from a listbox(obj)
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}

function RequiredFields(){  //AmiN log 27569  have to select a Problem with a goal. 
	var CPWDescobj=document.getElementById("CPWDesc");
	if ((CPWDescobj) && (CPWDescobj.value=="")) {		
		alert(t['ProblemMandatory']);
		return;
	}
	return AddAllSteps_click();
}

function CheckAddAllFields(){  //AmiN log 27569  have to select a Problem with a goal. 
	var CPWDescobj=document.getElementById("CPWDesc");
	if ((CPWDescobj) && (CPWDescobj.value=="")) {		
		alert(t['ProblemMandatory']);
		return;
	}
	return AddStep_click();
}

function BodyLoadHandler() {

// ANA 19 August 2002 AddStep and AddAllStep are now dealt with in the workflow.
	// Hardcoding of URL's not done anymore. Avoid them as far as possible.	
	
	var AddAllStepsobj=document.getElementById("AddAllSteps");  //AmiN log 27569  have to select a Problem with a goal. 
	if (AddAllStepsobj) AddAllStepsobj.onclick=RequiredFields;	
	
	var AddStepobj=document.getElementById("AddStep");  //AmiN log 27569  have to select a Problem with a goal. 
	if (AddStepobj) AddStepobj.onclick=CheckAddAllFields;	
	//if (self==top) websys_reSizeT();
	
	//var pobj=document.getElementById("CPWDesc"); // *****  Log# 30485; AmiN ; 18/Nov/2002  In Problem field added Broker and allow to work *****  
	//if (pobj) pobj.onchange=ClearFields;	

	var uobj=document.getElementById("Update");
	if (uobj) uobj.onclick=UpdateClickHandler;
		
	var allobj=document.getElementById("VPathwayDetails");
	if (allobj)  allobj.onclick=ViewDetailsClickHandler;	
	
	var stepObj=document.getElementById("StepsList");
	if (stepObj) ClearAllList(stepObj);	
}

document.body.onload=BodyLoadHandler;
