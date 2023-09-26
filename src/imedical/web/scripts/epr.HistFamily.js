// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));

function DocumentLoadHandler() {
	assignClickHandler();

	for (var curr_row=1; curr_row<ltbl.rows.length; curr_row++)	{
		var onsetDate=document.getElementById('OnsetDatez'+curr_row);
		var approxOnset=document.getElementById('ApproxOnsetDatez'+curr_row);
		if ( approxOnset && approxOnset.value=="Y" ) {
			if (onsetDate) onsetDate.className="EstOnsetDate";
		}
	}

	obj=document.getElementById("new1")
	if (obj) obj.onclick=ClearFields;

	var obj=document.getElementById("update1");
	if (obj) {
		obj.onclick=UpdateHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	}

	var field=document.getElementById("PADurationDesc")
	if (field) field.multiple=false;

	LoadDiagParams();
}

// pjc 20.10.06 60087
function LoadDiagParams() {

	var params="";
	var obj=document.getElementById("DiagParams");
	if (obj) params=obj.value;

	if (params!="") {
		params=params.split(String.fromCharCode(1));
		var obj=document.getElementById("DiagDesc1");
		if (obj) obj.innerText=params[0];
		var obj=document.getElementById("DiagDesc2");
		if (obj) obj.innerText=params[1];
	}
}

function SetMultiDiag() {
	var DiagString="";

	var lists = new Array("DiagList1","DiagList2");
	for (var j=0;j<lists.length; j++) {
		var obj=document.getElementById(lists[j]);
		if (obj) {
			for (var i=0; i<obj.length; i++) {
				if (obj.options[i].selected==true) {
					if (DiagString!="") DiagString=DiagString+"^";
					DiagString=DiagString+obj.options[i].value;
				}
			}
		}
	}

	var obj=document.getElementById("MultiDiag");
	if (obj) obj.value=DiagString;
}

function SetMultiRelation(){
	var relationString=""

	var obj=document.getElementById("RelationList");
		if (obj) {
			for (var i=0; i<obj.length; i++) {
				if (obj.options[i].selected==true) {
					if (relationString!="") relationString=relationString+"^";
					relationString=relationString+obj.options[i].value;
				}
			}
		}

		var obj=document.getElementById("Relations");
		if (obj) obj.value=relationString;
}  // SetMultiRelation

function UpdateHandler() {
	SetMultiDiag();
	SetMultiRelation();
	return update1_click();
}

function ClearFields() {
	var field=document.getElementById("HistoryID")
	if (field) field.value="";

	field=document.getElementById("FAMMRCBodySys")
	if (field) field.value="";

	field=document.getElementById("FAMMRCBodySysProb")
	if (field) field.value="";

	field=document.getElementById("FAMMRCBodSysProbSub")
	if (field) field.value="";

	field=document.getElementById("RelationList")
	if (field) field.value="";

	field=document.getElementById("PAFamilyDisease")
	if (field) field.value="";

	field=document.getElementById("PAOnSetDate")
	if (field) field.value="";

	field=document.getElementById("ApproxOnset")
	if (field) field.onclick="";

	field=document.getElementById("PAComments")
	if (field) field.value="";

	// Log 58610 - GC - 26-04-2006 : New Field FAMDSReportFlag
	field=document.getElementById("FAMDSReportFlag")
	if (field) field.checked=false;
	// end Log 58610

	field=document.getElementById("PADuration")
	if (field) field.value="";

	field=document.getElementById("PADurationDesc")
	if (field) field.value="";

	field=document.getElementById("DiagList1")
	if (field) {
		field.value="";
		field.disabled = false;
	}

	field=document.getElementById("DiagList2")
	if (field) {
		field.value="";
		field.disabled = false;
	}

	field=document.getElementById("ApproxOnset")
	if (field) field.checked=false;

	setApproxOnsetDateFontColour();

	return false;
}

function assignClickHandler() {
	var tbl=document.getElementById("tepr_HistFamily");
	for (var i=1;i<tbl.rows.length;i++) {
		var objEdit=document.getElementById("Amend1z"+i)
		if (objEdit) objEdit.onclick=ClickHandler;
	}
	var approxOnset=document.getElementById("ApproxOnset")
	if (approxOnset) approxOnset.onclick=setApproxOnsetDateFontColour;

	return false;
}

function ClickHandler(e) {
	var obj=websys_getSrcElement(e);
	if ((obj)&&(obj.tagName=="IMG")) obj=websys_getParentElement(obj);
	if (obj) {
		var rowid=obj.id;
		var rowAry=rowid.split("z");
		var HIDDEN=document.getElementById("HIDDENz"+rowAry[1]).value;
		var temp=HIDDEN.split("^");

		var field=document.getElementById("HistoryID")
		if (field) field.value=temp[0];

		field=document.getElementById("PAFamilyDisease")
		if (field) {
			field.disabled=false;
			field.value=temp[1];
		}

		field=document.getElementById("PAOnsetDate")
		if (field) field.value=temp[3];

		field=document.getElementById("PAComments")
		if (field) field.value=temp[4];

		field=document.getElementById("RelationList")
		if (field) field.value=temp[5];

		field=document.getElementById("FAMMRCBodySys")
		if (field) field.value=temp[6];

		field=document.getElementById("FAMMRCBodySysProb")
		if (field) field.value=temp[7];

		field=document.getElementById("FAMMRCBodSysProbSub")
		if (field) field.value=temp[8];

		// Log 58610 - GC - 26-04-2006 : New field
 		field=document.getElementById("FAMDSReportFlag")
		if (field) {
			field.checked=false;
			if (temp[9]=="Y") field.checked=true;
		}
		// end Log 58610

		field=document.getElementById("PADuration")
		if (field) field.value=temp[10];

		field=document.getElementById("PADurationDesc")
		if (field) field.value=temp[11];

		field=document.getElementById("DiagList1")
		if (field) field.value="";

		field=document.getElementById("DiagList2")
		if (field) field.value="";

		field=document.getElementById("ApproxOnset")
		if (field) {
			field.checked=false;
			if (temp[12]=="Y")
			{
				field.checked=true;
			}
		}
		setApproxOnsetDateFontColour();
		DisableListHandler();
	}
	return false;
}

function  problemFillBodyPart( str )
{
	var lu = str.split("^");

	var field=document.getElementById("FAMMRCBodySys")
	if (field) field.value=lu[2];

	var field=document.getElementById("FAMMRCBodySysProb")
	if (field) field.value=lu[0];
}

function  subproblemFillProblemBodyPart( str )
{
	var lu = str.split("^");

	var field=document.getElementById("FAMMRCBodySys")
	if (field) field.value=lu[2];

	var field=document.getElementById("FAMMRCBodySysProb")
	if (field) field.value=lu[1];

	var field=document.getElementById("FAMMRCBodSysProbSub")
	if (field) field.value=lu[0];
}

var list1Obj=document.getElementById("DiagList1");
if (list1Obj) list1Obj.onchange=DisableLookUpHandler;

var list2Obj=document.getElementById("DiagList2");
if (list2Obj) list2Obj.onchange=DisableLookUpHandler;

var diseaseObj=document.getElementById("PAFamilyDisease");
if (diseaseObj) diseaseObj.onblur=DisableListHandler;

function DisableListHandler(){
	var diseaseObj=document.getElementById("PAFamilyDisease");
	var list1Obj=document.getElementById("DiagList1");
	var list2Obj=document.getElementById("DiagList2");
	if (diseaseObj && diseaseObj.value!=""){
		if (list1Obj) list1Obj.disabled = true;
		if (list2Obj) list2Obj.disabled = true;
	}
	else{
		if (list1Obj) list1Obj.disabled = false;
 		if (list2Obj) list2Obj.disabled = false;
	}
}

function DisableLookUpHandler(){
	var selList="";
	var list1Obj=document.getElementById("DiagList1");
	var list2Obj=document.getElementById("DiagList2");
	var diseaseObj=document.getElementById("PAFamilyDisease");
	var diseaseImg=document.getElementById("ld2153iPAFamilyDisease");
	if (list1Obj) selList=selList+list1Obj.value;
	if (list2Obj) selList=selList+list2Obj.value;

	if (selList!="") {
		if (diseaseObj) DisableLookup(diseaseObj,diseaseImg);
	} else {
		if (diseaseObj) EnableLookup(diseaseObj,diseaseImg);
	}

}

function DisableLookup( objLookUp, imgLookup )
{
	objLookUp.disabled = true;
	objLookUp.value="";
	imgLookup.disabled = true;
}  // DisableLookup

function EnableLookup( objLookUp, imgLookup )
{
	objLookUp.disabled = false;
	imgLookup.disabled = false;
}  // EnableLookup

function setApproxOnsetDateFontColour() {
	var approxDate=document.getElementById('ApproxOnset');
	var onsetDate=document.getElementById('PAOnsetDate');
	if ((onsetDate)&&(approxDate)) {
		if (approxDate.checked) {
			onsetDate.className="EstOnsetDate";
		} else {
			onsetDate.className="";
		}
	}
}

document.body.onload = DocumentLoadHandler;
