// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function MRCIDDescLookUpSelect(str) {
	var lu=str.split("^");
	var idesc=lu[0];
	var iID=lu[1];
	var icode=lu[2];

	var dlobj=document.getElementById("MRCIDDesc");
	if (dlobj) AddDiagnosisToList(idesc,icode,iID);

	var dobj=document.getElementById("MRCIDDesc");
	if (dobj) dobj.value="";
}

//Log 61687 PeterC 20/12/06
function HospLookUpHandler(str) {
		
	var lu=str.split("^");
	var idesc=lu[0];

	var hobj=document.getElementById("HOSPDesc");
	if (hobj) hobj.value=idesc;

	var lobj=document.getElementById("Location");
	if (lobj) lobj.value="";
}


function AddDiagnosisToList(desc,code,iID) {
	var obj=document.getElementById("DiagnosisList");
	if (obj) {
		obj.selectedIndex = -1;
		obj.options[obj.length] = new Option(desc,code);
		obj.options[obj.length-1].id=iID;
	}
}

//JD 57868
function InsertEpisodeDiagnoses(){
/* first attempt scratched
   misinterpreted specs.
	var diagbutton=document.getElementById("InsertDiagnos");
	if (diagbutton) {
		diagbutton.onclick="";
		diagbutton.disabled=true;
	}
	var EpisDiagObj=document.getElementById("EpisDiag");
	if (!EpisDiagObj) return;
	var EpisDiag=EpisDiagObj.value;
	if (EpisDiag=="") return;
	var lu=EpisDiag.split("||");

	var obj=document.getElementById("DiagnosisList");
	if (obj) ClearAllList(obj);
	for (var x=0; x<lu.length-1; x++){
		var diag=lu[x].split("^");
		AddDiagnosisToList(diag[2],diag[1],diag[0]);
	}
*/
	var obj=document.getElementById("DiagnosisList");
	if (obj) ClearAllList(obj);

	var itbl=document.getElementById("tMRClinicalPathways_CarePlanEdit");
	if (itbl) {
		for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var diagidobj, diagcodeobj, diagdescobj, diagid, diagcode, diagdesc="";
			var objSelectItem=document.getElementById("SelectItemz" + curr_row);
			if (objSelectItem && objSelectItem.checked==true) {
				var diagidobj=document.getElementById("IcdIDz" + curr_row);
				if (diagidobj) diagid=diagidobj.value;
				var diagcodeobj=document.getElementById("MRCIDCodez" + curr_row);
				if (diagcodeobj) diagcode=diagcodeobj.value;
				var diagdescobj=document.getElementById("MRCIDDesc1z" + curr_row);
				if (diagdescobj) diagdesc=diagdescobj.value;
				if (diagdesc!="" && diagcode!="" && diagid!="") AddDiagnosisToList(diagdesc,diagcode,diagid);
			}
		}
	}

	return;
}

function SelectAllClickHandler(evt) {
	var ifrm,itbl;

	var el=window.event.srcElement
	// Get the form that contains the element that initiated the event.
	if (el) ifrm=getFormName(el);
	// Get the table of the same name as the form.
	if (ifrm) itbl=document.getElementById("t"+ifrm.id.substring(1,ifrm.id.length));
	// Set each "SelectItem" checkboxes to the same value as the "SelectAll" checkbox.
	if (itbl) {
		for (var curr_row=1; curr_row<itbl.rows.length; curr_row++) {
			var objSelectItem=ifrm.elements["SelectItemz" + curr_row];
			if (!objSelectItem) objSelectItem=ifrm.elements["Selectz" + curr_row];
			if (objSelectItem) objSelectItem.checked=el.checked;
		}
	}

	return true;
}

function ClearField() {
	var pobj=document.getElementById("PathwayDesc");  //Problem
	if (pobj.value=="") {

		var stepObj=document.getElementById("GoalList");  //Goal  Listbox
		if (stepObj) ClearAllList(stepObj);
	}
}

function ClearAllFields() {

		var pobj=document.getElementById("PathwayDesc");  //Problem
		if (pobj) pobj.value="";

		var dobj=document.getElementById("DiagnosisList");  //Aetiology/Diagnosis
		if (dobj) ClearAllList(dobj);

		var stepObj=document.getElementById("GoalList");  //Goal  Listbox
		if (stepObj) ClearAllList(stepObj);
}

function ClearAllList(obj) {         //This function removes ALL the options from a listbox(obj)
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
}


function LookUpPathwaySelect(str) {
	var NewObj=document.getElementById("NewClinPathWays");
	if((NewObj)&&(NewObj.value=="Y")) LookUpPathwaySelectNew(str);
	else {LookUpPathwaySelectOld(str);}
}

function LookUpPathwaySelectNew(str) {
	var strArr=str.split("^");
	var GoalString="";

	var probIdObj=document.getElementById("PathwayID");
	if (probIdObj&&strArr[0]) probIdObj.value=strArr[0];
	//alert("pathwayid  "+strArr[0])

	var probdescObj=document.getElementById("PathwayDesc");
	if (probdescObj&&strArr[1]) probdescObj.value=strArr[1];
	//alert(strArr[1]);
	if ((strArr)&&(strArr[2]))		 {
		//BM Log 35608 Clear the Goal List
		var stepObj=document.getElementById("GoalList");  //Goal  Listbox
		if (stepObj) ClearAllList(stepObj);
		GoalString=strArr[2];
		var secondArr=GoalString.split("$$");			//String.fromCharCode(1)
		//alert("secondArr  "+secondArr);
		for (var i=0;i<secondArr.length-1;i++) {
			var thirdArr=secondArr[i].split("~~");
			//alert("thirdArr[1]  "+thirdArr[1]);
			//Log 61687 PeterC 04/12/06
			var CurrCycleDesc="";
			var CurrCycleDesc=thirdArr[5];
			if(CurrCycleDesc!="") CurrCycleDesc=CurrCycleDesc+" - ";
			var CPWPathWays="";
			var CPWPObj=document.getElementById("CPWPathWays");
			if((CPWPObj)&&(CPWPObj.value!="")) CPWPathWays=CPWPObj.value;
			var OutcomeListObj=document.getElementById("GoalList");
			if (OutcomeListObj) {
					var found="";
					//alert("Init:"+thirdArr[0]+",,,"+found);
					for (var ii=0;ii<OutcomeListObj.length;ii++) {
						var CurrPathEpID=OutcomeListObj.options[ii].value
						var CurrDayDesc=OutcomeListObj.options[ii].text
						if(((mPiece(CurrPathEpID,"||",0))==(mPiece(thirdArr[0],"||",0)))&&((mPiece(CurrPathEpID,"||",1))==(mPiece(thirdArr[0],"||",1)))&&(CurrDayDesc==CurrCycleDesc+thirdArr[1])) {
							//alert("Found:"+thirdArr[0]);
							OutcomeListObj.options[ii].value=OutcomeListObj.options[ii].value+"^"+thirdArr[0];
							found="Y";
							break;
						}
					}
					//if(found=="Y") break;
					//alert("Not Found:"+thirdArr[0]);
					if(found=="") {
					OutcomeListObj.options[OutcomeListObj.options.length]=new Option(CurrCycleDesc+thirdArr[1],thirdArr[0]);
					if((thirdArr[0])&&(thirdArr[0]!="")&&(CPWPathWays.indexOf("^"+thirdArr[0]+"^")>-1)) OutcomeListObj.options[OutcomeListObj.options.length-1].style.color="Blue";
					var ssObj=document.getElementById("savedStepString")
					if (ssObj&&ssObj.value!="") {
						var ssString=ssObj.value
						var ssARR=ssString.split(",")
						//alert(ssARR.length+"JJJJ")
						for (var k=0;k<ssARR.length-1;k++) {
							var ARRss=ssARR[k].split("^");
							//alert("ARRss[2]"+ARRss[2]+"thirdArr[0]"+thirdArr[0]);
							if (ARRss[2]==thirdArr[0]) OutcomeListObj.options[OutcomeListObj.options.length-1].selected=true;
						}
					}
					OutcomeListObj.options[OutcomeListObj.options.length-1].PathEpID=thirdArr[4];
					var PathEpIDobj=document.getElementById("PathEpID");
					if (PathEpIDobj) PathEpIDobj.value=thirdArr[4];
					//alert(PathEpIDobj.value+" "+thirdArr[4]);
					}
					//Log 62816 PeterC 19/03/07
					var ssObj=document.getElementById("AllEpDaysIDs")
					if ((ssObj)&&(ssObj.value!="")) {
						var ssString=ssObj.value
						var ssARR=ssString.split("^")
						for (var k=0;k<ssARR.length-1;k++) {
							var ARRss=ssARR[k];
							for (var ii=0;ii<OutcomeListObj.length;ii++) {
								var CurrPathEpID=OutcomeListObj.options[ii].value
								if(CurrPathEpID.indexOf(ARRss)>-1) OutcomeListObj.options[ii].selected=true;
							}
						}
					}
			}
		}
	}
}

function LookUpPathwaySelectOld(str) {
//alert(str);			 			//Used for Problem field lookup
	var strArr=str.split("^");
	var GoalString="";

	var probIdObj=document.getElementById("PathwayID");
	if (probIdObj&&strArr[0]) probIdObj.value=strArr[0];
	//alert("pathwayid  "+strArr[0])

	var probdescObj=document.getElementById("PathwayDesc");
	if (probdescObj&&strArr[1]) probdescObj.value=strArr[1];
	//alert(strArr[1]);
	if ((strArr)&&(strArr[2]))		 {
		//BM Log 35608 Clear the Goal List
		var stepObj=document.getElementById("GoalList");  //Goal  Listbox
		if (stepObj) ClearAllList(stepObj);

		GoalString=strArr[2];
		var secondArr=GoalString.split("$$");			//String.fromCharCode(1)
		//alert("secondArr  "+secondArr);
		for (var i=0;i<secondArr.length-1;i++) {
			var thirdArr=secondArr[i].split("~~");
			//alert("thirdArr[1]  "+thirdArr[1]);
			var OutcomeListObj=document.getElementById("GoalList");
			if (OutcomeListObj) {
					OutcomeListObj.options[OutcomeListObj.options.length]=new Option(thirdArr[1],thirdArr[0]);
					var ssObj=document.getElementById("savedStepString")
					if (ssObj&&ssObj.value!="") {
						var ssString=ssObj.value
						var ssARR=ssString.split(",")
						//alert(ssARR.length+"JJJJ")
						for (var k=0;k<ssARR.length-1;k++) {
							var ARRss=ssARR[k].split("^");
							//alert("ARRss[2]"+ARRss[2]+"thirdArr[0]"+thirdArr[0]);
							if (ARRss[0]==thirdArr[0]) OutcomeListObj.options[OutcomeListObj.options.length-1].selected=true;
						}
					}
					OutcomeListObj.options[OutcomeListObj.options.length-1].PathEpID=thirdArr[4];
					var PathEpIDobj=document.getElementById("PathEpID");
					if (PathEpIDobj) PathEpIDobj.value=thirdArr[4];
					//alert(PathEpIDobj.value+" "+thirdArr[4]);
			}
		}

	}
}

function mPiece(s1,sep,n) {
	//Getting wanted piece, passing (string,separator,piece number)
	//First piece starts from 0
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) return delimArray[n];
}

function GetStepPathIds() {
	var stringids="";
	var Pathwayid="";
	var stringidstemp="";
	var stringidstempArr="";
	var probIdObj=document.getElementById("PathwayID");


	if (probIdObj) Pathwayid=probIdObj.value;
	//alert(probIdObj.value);
	var goalListObj=document.getElementById("GoalList");
	//alert(goalListObj.options[0].selected);
	//denise


	for (var ii=0;ii<goalListObj.length;ii++) {
		//alert(goalListObj.length);
		if (goalListObj.options[ii].selected==true) {
			//alert(goalListObj.options[ii].selected);
			//alert(goalListObj.options[ii].value);
			//alert(mPiece(goalListObj.options[ii].value,"||",1));
			//stringids=stringids+Pathwayid+"^"+"^"+goalListObj.options[ii].value+"^"+",";
			stringidstemp=stringidstemp+goalListObj.options[ii].value+"^";
		}
	}
	var stringidstempArr=stringidstemp.split("^");
	for (var i=0;i<stringidstempArr.length-1;i++) {
		stringids=stringids+Pathwayid+"^"+"^"+stringidstempArr[i]+"^"+",";
	}

	var sobj=document.getElementById("StepPathIds");
	if (sobj) sobj.value=stringids;
	//alert(stringids);
}

function UpdateClickHandler() {
//alert("here");
	var arry="";
	var AllowToUpdate=false;

	var DiagnosisIDs=SelectedDiagnosisList();
	var diagobj=document.getElementById("DiagnosisIDs");
	if (diagobj) diagobj.value=DiagnosisIDs;
	var CPWDescobj=document.getElementById("PathwayDesc")
	if ((CPWDescobj)&&(CPWDescobj.value=="")) {
		alert("select a problem");
		AllowToUpdate=false;
	} else if ((CPWDescobj)&&(CPWDescobj.value!="")) {
		AllowToUpdate=true;
		var Outcome=SelectedOutcomeList();
		if ((DFobj)&&(DFobj.value!="1")&&(Outcome=="")) {
			alert(t['PickaGoal']);
			AllowToUpdate=false;
		} else if (Outcome!=""||DiagnosisIDs!="") {
			AllowToUpdate=true;
			var arry=Outcome.split("*");  
			var GoalIDs=arry[0];
			var PathEpIDs=arry[1];
			var GoalText=arry[2];
			var sobj=document.getElementById("GoalIDs");	
			if (sobj) sobj.value=GoalIDs;
			var epObj=document.getElementById("PathEpIDs");
			if (epObj) epObj.value=PathEpIDs;
			var GoalTextobj=document.getElementById("CPWGoalText");
			if (GoalTextobj) GoalTextobj.value=GoalText
			//alert("steps "+sobj.value+" epids "+epObj.value+" goal "+GoalTextobj.value);
		}	
	}

	//denise
	GetStepPathIds();
	//Log 61693 PeterC 20/12/06
	var NewObj=document.getElementById("NewClinPathWays");
	if((NewObj)&&(NewObj.value=="Y")) {

		var RepeatDetails="";
		var PatientID="";
		var EpisodeID="";
		var mradm="";

		var PRDObj=document.getElementById("RepeatDetails");
		if(PRDObj) PRDObj.value="";

		var PObj=document.getElementById("PatientID");
		if((PObj)&&(PObj.value!="")) PatientID=PObj.value;
		var EObj=document.getElementById("EpisodeID");
		if((EObj)&&(EObj.value!="")) EpisodeID=EObj.value;
		var MObj=document.getElementById("mradm");
		if((MObj)&&(MObj.value!="")) mradm=MObj.value;
		var RepeatIDs=",";
		var goalListObj=document.getElementById("GoalList");
		for (var ii=0;ii<goalListObj.length;ii++) {
			if ((goalListObj.options[ii].selected==true) && (goalListObj.options[ii].style.color=="blue")) {
				var CurrDayID=goalListObj.options[ii].value;
				var CurrEpID="";
				if(CurrDayID!="") CurrEpID=mPiece(CurrDayID,"||",0)+"||"+mPiece(CurrDayID,"||",1)
				if((CurrEpID!="")&&(RepeatIDs.indexOf(","+CurrEpID+",")==-1)) RepeatIDs=RepeatIDs+CurrEpID+",";
			}
		}
		if (RepeatIDs!=",") {
			var url="mrclinicalpathways.careplanrepeat.csp?RepeatIDs="+RepeatIDs+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&PatientBanner=1&RepeatDetails=";
			//alert(url);
			websys_lu(url,false,"");
			return false;
		}
	}
	
	if (AllowToUpdate) return Update_click();
}

function SelectedDiagnosisList() {
	var DiagnosisAccumSelected="";
	var Outcome ="";
	var OutObj=document.getElementById("DiagnosisList");	
	if (OutObj) {
		for (var i=0;i<OutObj.length;i++) {
			if (OutObj.options[i]) {
				DiagnosisAccumSelected=DiagnosisAccumSelected+OutObj.options[i].id+"^"; 
			}			
		}
	}
	//alert("diagnosis"+DiagnosisAccumSelected);
	return DiagnosisAccumSelected;
}

function SelectedOutcomeList() {

	var AccumSelected="";
	var PathEpIDs="";
	var PathEpID="";
	var Outcome ="";
	var GoalListFlag="false";
	
	var OutObj=document.getElementById("GoalList");	
	if (OutObj) {
		for (var i=0;i<OutObj.length;i++) {
			if (OutObj.options[i].selected==true) {
				GoalListFlag="true";
				AccumSelected+=OutObj.options[i].value+"^"; 
				PathEpIDs+=OutObj.options[i].PathEpID+"^";
			}			
		}
	}
	var CPWGoalTextobj=document.getElementById("CPWGoalText");			
	var CPWGoalText=""
	if ((CPWGoalTextobj)&&(CPWGoalTextobj.value!="")){
		CPWGoalText=CPWGoalTextobj.value;		
		GoalListFlag="true";
		//AccumSelected=AccumSelected+CPWGoalText;
		//PathEpID+="^";
	}
	if (GoalListFlag == "true") {
		Outcome=AccumSelected+"*"+PathEpIDs+"*"+CPWGoalText;
	}/*else {
		if (DFobj&&DFobj.value!="1") {
			alert(t['PickaGoal']);
		}
	}*/
	return Outcome;
}

function DeleteClickHandler() {    //Delete items from lstOrders listbox when a "Delete" button is clicked.
	var obj=document.getElementById("DiagnosisList");
	if (obj) RemoveFromList(document.fMRClinicalPathways_CarePlanEdit,obj);
}

function RemoveFromList(f,obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function BodyLoadHandler() {
	//if (self==top) websys_reSizeT();
	//var sobj=document.getElementById("StepPathIds")
	//if (sobj) alert("StepPathIds "+sobj.value);
		
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteClickHandler;
	
	//var pobj=document.getElementById("PathwayDesc"); //problem  // *****  Log# 30485; AmiN ; 18/Nov/2002  In Problem field added Broker and allow to work *****  
	//if (pobj) pobj.onchange=ClearField;
	
	var uobj=document.getElementById("Update");
	if (uobj) uobj.onclick=UpdateClickHandler;
	//if (uobj) uobj.onclick=RepeatClickHandler;
	
	//var robj=document.getElementById("Update1");
	//if (robj) robj.onclick=RepeatClickHandler;
	var code=""; var id=""; var desc=""; var MRCIDDesc="";
	var diagObj=document.getElementById("MRCIDDesc")
	if (diagObj) MRCIDDesc=diagObj.value;
	// JD - Have to use hidden item for new DEV 57868
	// MRCIDDesc shouldn't really be used on screen anymore.
	var HiddiagObj=document.getElementById("HiddenDiagnosisList")
	if (HiddiagObj) HidMRCIDDesc=HiddiagObj.value;
	var diagArray=HidMRCIDDesc.split("$$");
	for (var diagCount=0; diagCount<diagArray.length-1; diagCount++ ){
		var array=diagArray[diagCount].split("^");
		//alert(array[0]);
		code=array[0];
		id=array[1];
		desc=array[2];
		AddDiagnosisToList(desc,code,id);
		if (diagObj) diagObj.value="";
		if (HiddiagObj) HiddiagObj.value="";
		
	}



	//ANA 05 JUN 02 This is to fill up the details on the steps and problems fields.
	var Descobj=document.getElementById("pathwayString");
	var DFobj=document.getElementById("disableFlag");
	var pobj=document.getElementById("PathwayDesc");  //Problem

	if ((DFobj&&DFobj.value=="1")&&pobj) {
		//alert(DFobj.value);
		pobj.disabled=true;
		pobj.className = "";
		IMGobj=document.getElementById("ld1367iPathwayDesc");
		if (IMGobj) IMGobj.style.visibility="hidden"
	}

	if (Descobj&&Descobj.value!="") {
			//alert("Descobj.value"+Descobj.value);
			LookUpPathwaySelect(Descobj.value);
	}
	
	var ClinPathDesc="";
	var clnDescObj=document.getElementById("ClinPathDesc");
	if (clnDescObj) ClinPathDesc=clnDescObj.value;
	if (ClinPathDesc!="") Clin_DisplayPathway;
	
	// assign click handlers
	// JPD 57868
	var diagbutton=document.getElementById("InsertDiagnos");
	if (diagbutton) diagbutton.onclick=InsertEpisodeDiagnoses;
	var objSelectAll=document.getElementById("SelectAll");
	if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;

	pobj.onchange();
	//var lnk = "mrclinicalpathways.cp.defaults.csp?CPWRowId="+document.getElementById("CPWRowId").value+"&mradm="+document.getElementById("mradm").value;
	//alert(lnk);
	//websys_createWindow(lnk,"TRAK_hidden");
	
	obj=document.getElementById('CPWProblemEndDate');
	if (obj) obj.onchange = CPWProblemEndDateChanger;
	
	obj=document.getElementById('CPWProblemReviewDate');
	if (obj) obj.onchange = CPWProblemReviewDateChanger;
	
	obj=document.getElementById('CPWProblemStartDate');
	if (obj) obj.onchange = CPWProblemStartDateChanger;

	//Log 62631 PeterC 05/03/07
	obj=document.getElementById('CycleDetails');
	if (obj) obj.onclick = CycleDetailsClickHandler;
	
}

function CycleDetailsClickHandler() {
	var SelStr="";
	var lu="";
	var CycleID="";
	var DayIDs="^";
	var PatientID="";
	var EpisodeID="";
	var Context="";
	var pobj=document.getElementById("PatientID");
	if ((pobj)&&(pobj.value!="")) PatientID=pobj.value;
	var eobj=document.getElementById("EpisodeID");
	if ((eobj)&&(eobj.value!="")) EpisodeID=eobj.value;
	var cobj=document.getElementById("CONTEXT");
	if ((cobj)&&(cobj.value!="")) Context=cobj.value;

	GetStepPathIds();
	var sobj=document.getElementById("StepPathIds");
	if (sobj) SelStr=sobj.value;
	if(SelStr=="") {
		alert(t["SINGLE_CYCLE"]);
			return false;
	}
	if (SelStr!="") lu=SelStr.split(",");
	
	for (var x=0; x<lu.length-1; x++){
		var StepDet=lu[x].split("^");
		var CurrStep=mPiece(StepDet[2],"||",0)+"||"+mPiece(StepDet[2],"||",1);
		if ((CurrStep!="")&&(CycleID=="")) CycleID=CurrStep;
		if (CurrStep!=CycleID) {
			alert(t["SINGLE_CYCLE"]);
			return false;
		}
		DayIDs=DayIDs+StepDet[2]+"^";
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=MRClinicalPathways.CycleDayList&&EPRowId="+CycleID+"&DayIDs="+DayIDs+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&CONTEXT="+Context+"&PatientBanner=1";
	websys_createWindow(url,"lookup","top=30,left=20,width=620,height=420,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes");
	return false;
}

// cjb 31/05/2006 59454
function CPWProblemEndDateChanger() {
  var msg=""
	CPWProblemEndDate_changehandler();
	var obj=document.getElementById('CPWProblemEndDate');
	var obj1=document.getElementById('CPWProblemStartDate');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value!="")) {
		if (DateStringCompare(obj.value,obj1.value)==-1) msg = t['CPWProblemEndDate'] +" "+ t["BEFORE"] +" "+ t["CPWProblemStartDate"];
		if (msg!="") {
			alert(msg);
			obj.value="";
			websys_setfocus("CPWProblemEndDate");
			return false;
		}
	}
	return true;
}

function CPWProblemReviewDateChanger() {
  var msg=""
	CPWProblemReviewDate_changehandler();
	var obj=document.getElementById('CPWProblemReviewDate');
	var obj1=document.getElementById('CPWProblemStartDate');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value!="")) {
		if (DateStringCompare(obj.value,obj1.value)==-1) msg = t['CPWProblemReviewDate'] +" "+ t["BEFORE"] +" "+ t["CPWProblemStartDate"];
		if (msg!="") {
			alert(msg);
			obj.value="";
			websys_setfocus("CPWProblemReviewDate");
			return false;
		}
	}
	return true;
}

function CPWProblemStartDateChanger() {
  var msg=""
	CPWProblemStartDate_changehandler();
	var obj=document.getElementById('CPWProblemReviewDate');
	var obj1=document.getElementById('CPWProblemStartDate');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value!="")) {
		if (DateStringCompare(obj.value,obj1.value)==-1) msg = t['CPWProblemReviewDate'] +" "+ t["BEFORE"] +" "+ t["CPWProblemStartDate"];
	}
	var obj=document.getElementById('CPWProblemEndDate');
	var obj1=document.getElementById('CPWProblemStartDate');
	if ((obj)&&(obj.value!="")&&(obj1)&&(obj1.value!="")) {
		if (DateStringCompare(obj.value,obj1.value)==-1) {
			if (msg=="") {
				msg = t['CPWProblemEndDate'] +" "+ t["BEFORE"] +" "+ t["CPWProblemStartDate"];
			} else {
				msg = msg+ "\n"+ t['CPWProblemEndDate'] +" "+ t["BEFORE"] +" "+ t["CPWProblemStartDate"];
			}
		}
	}
	
	if (msg!="") {
		alert(msg);
		obj1.value="";
		websys_setfocus("CPWProblemStartDate");
		return false;
	}
	return true;
}


function Clin_DisplayPathway() {
	 

}

function BodyUnLoadHandler() {
	// SB 21/06/05 (50285): This was done for questionaire / careplan stuff... no longer needed.
	//var obj=document.getElementById("TWKFL");
	//if (obj && obj.value=="627") window.location.href="websys.reload.csp"
}

//var pobj=document.getElementById("CPWDesc");
var DFobj=document.getElementById("disableFlag");
document.body.onload=BodyLoadHandler;
//document.body.onunload=BodyUnLoadHandler;

