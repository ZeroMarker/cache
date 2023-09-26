// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var objY1Type=document.getElementById('Y1AxisType');
var objY1Profile=document.getElementById('Y1AxisProfile');
var objY1ProfileLUIcon=document.getElementById('ld520iY1AxisProfile');
var objY2Type=document.getElementById('Y2AxisType');
var objY2Profile=document.getElementById('Y2AxisProfile');
var objY2ProfileLUIcon=document.getElementById('ld520iY2AxisProfile');
var GraphType_CHANGE=null;

function tk_DisableRowLink(tablename,linkcolumnname,criteriafield,criteriaexpr) {
	var tbl=document.getElementById(tablename);
	if (!tbl) return;
	//if no rows or the details column is not dispalying, don't have to do anything
	var colDetails=document.getElementById(linkcolumnname+"z1");
	if (!colDetails) return;
	for (var i=1; i<tbl.rows.length; i++) {
		var objCriteria=document.getElementById(criteriafield+"z"+i);
		var lnkDetails=document.getElementById(linkcolumnname+"z"+i);
		if (objCriteria.value==criteriaexpr) {
			var cell=websys_getParentElement(lnkDetails);
			cell.innerHTML = lnkDetails.innerHTML;
		}
	}
}

function BodyLoadHandler() {

	GraphTypeHandler();

	if (objY1Type) {
	  objY1Type.onchange=AxisType1FieldHandler;
	  AxisType1FieldHandler(); //to initialise field
	}
	if (objY2Type) {
	  objY2Type.onchange=AxisType2FieldHandler;
	  AxisType2FieldHandler(); //to initialise field
	}

	var objGraphType=document.getElementById('GRPHGraphType');
	if (objGraphType) {
		GraphType_CHANGE=objGraphType.onchange;
		objGraphType.onchange=GraphTypeHandler;
	}

	var tbl=document.getElementById("tepr_CTGraph_Edit");
	for (var i=1;i<tbl.rows.length;i++) {
		var hiddencolour = document.getElementById('CTGIColourz'+i);
		var colour = document.getElementById('Colourz'+i);
		if ((hiddencolour)&&(colour)) {
			var colourvalue = hiddencolour.value;
			colour.style.background = colourvalue;
			colour.disabled = true;
		}
		var hiddenrefcolour = document.getElementById('CTGIRefLineColourz'+i);
		var refcolour = document.getElementById('RefColourz'+i);
		if ((hiddenrefcolour)&&(refcolour)) {
			var colourvalue = hiddenrefcolour.value;
			refcolour.style.background = colourvalue;
			refcolour.disabled = true;
		}
	}
	var update = document.getElementById('update1');
	if (update) {
		update.onclick = UpdateClickHandler;
	}
	var objdelete = document.getElementById('delete1');
	if (objdelete) {
		objdelete.onclick = DeleteClickHandler;
	}
	//
	// Log 47281 - AI - 30-11-2004 : Handler for new button "Update and Refresh".
	var updaterefresh = document.getElementById('UpdateRefresh');
	if (updaterefresh) {
		var sysflag=document.getElementById("SystemFlag");
		if (sysflag.value=="Y") {
			updaterefresh.disabled=true;
			updaterefresh.onclick = "";
		} else {
			updaterefresh.onclick = UpdateRefreshClickHandler;
		}
	}
	// end Log 47281
	//
	// only allow 'new' items to be added once we have an ID (the graph code must be 'updated' first)
	// this does NOT apply to 'AdHoc' graphs - which have a 'sender' of 'ChartFX'
	var objNEW=document.getElementById("New");
	if (objNEW) {
		objNEW.onclick = NewClickHandler;
	}
	var objDel=document.getElementById("delete1");
	var objID=document.getElementById("ID");
	if (objID) {
		if (objID.value=="") {
			if (objNEW) {
				objNEW.disabled = true;
				objNEW.onclick = "";
			}
			if (objDel) {
				objDel.disabled = true;
				objDel.onclick = "";
			}
		}
	}
	var SystemFlag=document.getElementById("SystemFlag");
	var SystemGraph=document.getElementById("SystemGraph");
	if (SystemFlag&&SystemGraph) {
		if ((SystemFlag.value=="N")&&(SystemGraph.value=="Y")) {
			if (objNEW) {
				objNEW.disabled = true;
				objNEW.onclick = "";
			}
			if (objDel) {
				objDel.disabled = true;
				objDel.onclick = "";
			}
		}
	}

	var objFromCurr=document.getElementById("GRPHDateFromCurrent");
	if (objFromCurr) {
		if(objFromCurr.checked==true) DisableFromOffset();
		objFromCurr.onclick=DisableFromOffset;
	}
	var objToCurr=document.getElementById("GRPHDateToCurrent");
	if (objToCurr) {
		if(objToCurr.checked==true) DisableToOffset();
		objToCurr.onclick=DisableToOffset;
	}

	tk_DisableRowLink("tepr_CTGraph_Edit","ItemName","flags","NY");
	// DON'T allow code changes form the adhoc screen ('DontInitialise' will be set to 1)
	//var objDontInitialise=document.getElementById("DontInitialise");
	//var objGRPHCode=document.getElementById("GRPHCode");
	//if ((objGRPHCode)&&(objGRPHCode.value != "")) {
	//	if ((objDontInitialise)&&(objDontInitialise.value == 1)) {
	//		objGRPHCode.readOnly = true;
	//	}
	//}
}

function DisableToOffset() {
	var objToOffset=document.getElementById("GRPHDateToOffset");
	if (objToOffset) {
		objToOffset.value="";
		ToggleDisable(objToOffset);
	}
}

function DisableFromOffset() {
	var objFromOffset=document.getElementById("GRPHDateFromOffset");
	if (objFromOffset) {
		objFromOffset.value="";
		ToggleDisable(objFromOffset);
	}
}

function ToggleDisable(obj)
{
	if(obj.disabled==true) {
		obj.disabled=false;
		obj.className="";
	}
	else {
		obj.disabled=true;
		obj.className="disabledField";
	}
}

function NewClickHandler () {
	var ID = document.getElementById('ID');
	var graphType=document.getElementById('GRPHGraphTypeCode');
	var url="websys.default.csp?WEBSYS.TCOMPONENT=epr.CTGraphItemDefinition.Edit&GraphID=" + ID.value + "&GraphType=" + graphType.value;
	//Log: 59598, 03-07-2006 BC: add "status=yes"
	window.open(url,"GraphItemDefinition","top=50,left=100,width=800,height=600,scrollbars=yes,status=yes,resizable=yes");
}

function DeleteClickHandler () {
	var ret = delete1_click();

	// if we're called from the Graph page - just close ourselves on delete
	if (window.parent.name == 'ChartFX') {
		// Log 47281 - AI - 01-12-2004 : Before closing, reload the ChartFX.Link component AND the Graph to be blank.
		window.opener.treload('websys.csp');
		window.opener.SubmitGraph();
		// end Log 47281
		window.close();
	} else {
		return ret;
	}

	return ret;
}

function UpdateClickHandler () {
	var code = document.getElementById('GRPHCode');
	var ID = document.getElementById('ID');
	if ((code)&&(code.value=="")) {
		// if no opener - we are called from the GraphDefinition page - which DEMANDS a graph code
		if (!window.opener) {
			//alert("Graph Code is mandatory");
			alert(t['GraphCodeMandatory']);
			return false;
		} else {
			//alert('The graph has not been given a code, so will be treated as an adhoc graph');
			alert(t['AdhocGraph']);
		}
	}

	// PJC - if graph is a partogram No of intervals is a required field
	var objNoOfInt=document.getElementById('GRPHNoOfIntervals');
	var objInc=document.getElementById('GRPHXAxisIncrement');
	var objIncU=document.getElementById('GRPHXAxisIncrementUnit');
	var objGraphType=document.getElementById('GRPHGraphTypeCode');
	if (objGraphType && objGraphType.value=="PG") {
		var alertmsg="";
		if (objNoOfInt){
			if(objNoOfInt.value=="") {
				//alert(t['GRPHNoOfIntervals']+ " " + t['RequiredForParto']);
				alertmsg=t['GRPHNoOfIntervals']+ " " + t['RequiredForParto'];
				//return false;
			}
		} else {
			alertmsg=t['GRPHNoOfIntervals']+ " " + t['RequiredForParto']+ " " + t['AddToLayout'];
		}
		if (objInc){
			if(objInc.value=="") {
				if(alertmsg!="") alertmsg=alertmsg+"\n";
				alertmsg=alertmsg+t['GRPHXAxisIncrement']+ " " + t['RequiredForParto'];
			}
		} else {
			if(alertmsg!="") alertmsg=alertmsg+"\n";
			alertmsg=alertmsg+t['GRPHXAxisIncrement']+ " " + t['RequiredForParto'] + " " + t['AddToLayout'];
		}
		if (objIncU){
			if(objIncU.value=="") {
				if(alertmsg!="") alertmsg=alertmsg+"\n";
				alertmsg=alertmsg+t['GRPHXAxisIncrementUnit']+ " " + t['RequiredForParto'];
			}
		} else {
			if(alertmsg!="") alertmsg=alertmsg+"\n";
			alertmsg=alertmsg+t['GRPHXAxisIncrementUnit']+ " " + t['RequiredForParto'] + " " + t['AddToLayout'];
		}
		if(alertmsg!="") {
			alert(alertmsg);
			return false;
		}
	}

	// Log 51476 YC - Check date to and from
	if(!SubmitDateCheck()) return false;
	var ret = update1_click();

	// if we're called from the Graph page AND we've already got a GraphID just close ourselves on update
	// otherwise, we are just getting an ID so we can add items, or we are called from GraphDefinition..
	// add the hidden graph code from THIS page to the parent frame and force a graph refresh
	// ONLY do this if we have chart items - else we are just updating to get a valid ID
	var tableitem = document.getElementById("ItemIDz1");
	if ((window.parent.name == 'ChartFX')&&(tableitem)&&(tableitem.value!="")) {
		var parentIncrement = window.opener.document.getElementById('Increment');
		var myIncrement = document.getElementById('GRPHXAxisIncrement');
		if (parentIncrement && myIncrement) parentIncrement.value = myIncrement.value;

		var parentIncUnit = window.opener.document.getElementById('IncrementUnit');
		var myIncUnit = document.getElementById('GRPHXAxisIncrementUnit');
		if (parentIncUnit && myIncUnit) parentIncUnit.value = myIncUnit.value;

		// Log 53368 YC - Ensuring that increment unit code gets passed to ChartFX.Link
		var parentIncUnitCode = window.opener.document.getElementById('IncrementUnitCode');
		var myIncUnitCode = document.getElementById('GRPHXAxisIncUnitCode');
		if (parentIncUnitCode && myIncUnitCode) parentIncUnitCode.value = myIncUnitCode.value;

		var parentIntType = window.opener.document.getElementById('IntervalType');
		var myIntType = document.getElementById('GRPHXAxisIntervalType');
		if (parentIntType && myIntType) parentIntType.value = myIntType.value;

		var parentDateFrom = window.opener.document.getElementById('DateFrom');
		if (parentDateFrom) {
			var DateFromCheck = document.getElementById('GRPHDateFromCurrent');
			var DateFromOffset = document.getElementById('GRPHDateFromOffset');
			if (DateFromCheck) {
				if (DateFromCheck.checked==true) parentDateFrom.value = "t";
				else if(DateFromOffset) if(DateFromOffset.value!="") parentDateFrom.value = DateFromOffset.value;
			}
			else if(DateFromOffset) if(DateFromOffset.value!="") parentDateFrom.value = DateFromOffset.value;
		}

		var parentDateTo = window.opener.document.getElementById('DateTo');
		if (parentDateTo) {
			var DateToCheck = document.getElementById('GRPHDateToCurrent');
			var DateToOffset = document.getElementById('GRPHDateToOffset');
			if (DateToCheck) {
				if (DateToCheck.checked==true) parentDateTo.value = "t";
				else if(DateToOffset) if(DateToOffset.value!="") parentDateTo.value = DateToOffset.value;
			}
			else if(DateToOffset) if(DateToOffset.value!="") parentDateTo.value = DateToOffset.value;
		}

		var parentGraph = window.opener.document.getElementById('Graph');
		//alert("parent graph: " + parentGraph.value);
		var parentHiddenGraph = window.opener.document.getElementById('HiddenGraph');
		//alert("parent hidden: " + parentHiddenGraph.value);
		var MyHiddenGraph = document.getElementById('HiddenGraph');
		//alert("my graph: " + MyHiddenGraph.value);
		//if ((parentGraph)&&(parentGraph.value=="")) {
			if ((parentHiddenGraph)&&(MyHiddenGraph)&&(MyHiddenGraph.value!="")) {
				parentHiddenGraph.value = MyHiddenGraph.value;
				//alert("will submit..."+parentHiddenGraph.value );
				window.opener.SubmitGraph();
				window.close();
			} else {
				return ret;
			}
		//} else {
		//	return ret;
		//}
	} else {
		return ret;
	}
	//return ret;
}
//
// Log 47281 - AI - 30-11-2004 : Handler for new button "Update and Refresh".
function UpdateRefreshClickHandler () {
	// Firstly ensure the link is enabled.
	var obj=document.getElementById('UpdateRefresh');
	if (obj) {
		if (obj.disabled==true) return false;
	}

	// PJC - if graph is a partogram No of intervals is a required field
	var objNoOfInt=document.getElementById('GRPHNoOfIntervals');
	var objInc=document.getElementById('GRPHXAxisIncrement');
	var objIncU=document.getElementById('GRPHXAxisIncrementUnit');
	var objGraphType=document.getElementById('GRPHGraphTypeCode');
	if (objGraphType && objGraphType.value=="PG") {
		if (objNoOfInt){
			if(objNoOfInt.value=="") {
				//alert(t['GRPHNoOfIntervals']+ " " + t['RequiredForParto']);
				alertmsg=t['GRPHNoOfIntervals']+ " " + t['RequiredForParto'];
				//return false;
			}
		} else {
			alertmsg=t['GRPHNoOfIntervals']+ " " + t['RequiredForParto']+ " " + t['AddToLayout'];
		}
		if (objInc){
			if(objInc.value=="") {
				if(alertmsg!="") alertmsg=alertmsg+"\n";
				alertmsg=alertmsg+t['GRPHXAxisIncrement']+ " " + t['RequiredForParto'];
			}
		} else {
			if(alertmsg!="") alertmsg=alertmsg+"\n";
			alertmsg=alertmsg+t['GRPHXAxisIncrement']+ " " + t['RequiredForParto'] + " " + t['AddToLayout'];
		}
		if (objIncU){
			if(objIncU.value=="") {
				if(alertmsg!="") alertmsg=alertmsg+"\n";
				alertmsg=alertmsg+t['GRPHXAxisIncrementUnit']+ " " + t['RequiredForParto'];
			}
		} else {
			if(alertmsg!="") alertmsg=alertmsg+"\n";
			alertmsg=alertmsg+t['GRPHXAxisIncrementUnit']+ " " + t['RequiredForParto'] + " " + t['AddToLayout'];
		}
		if(alertmsg!="") {
			alert(alertmsg);
			return false;
		}
	}

	var code = document.getElementById('GRPHCode');
	var ID = document.getElementById('ID');
	if ((code)&&(code.value=="")) {
		// if no opener - we are called from the GraphDefinition page - which DEMANDS a graph code
		if (!window.opener) {
			//alert("Graph Code is mandatory");
			alert(t['GraphCodeMandatory']);
			return false;
		} else {
			//alert('The graph has not been given a code, so will be treated as an adhoc graph');
			alert(t['AdhocGraph']);
		}
	}
	// Log 51476 YC - Check date to and from
	if(!SubmitDateCheck()) return false;
	var ret = UpdateRefresh_click();

	var currentGraphDesc = document.getElementById("GRPHDesc");
	var parentGraphDesc = window.opener.document.getElementById('Graph');
	//alert("parent graph desc: " + parentGraphDesc.value);
	parentGraphDesc.value = currentGraphDesc.value;

	var currentGraphCode = document.getElementById("GRPHCode");
	var parentGraphCode = window.opener.document.getElementById('GRPHCode');
	//alert("parent graph code: " + parentGraphCode.value);
	parentGraphCode.value = currentGraphCode.value;

	var parentHiddenGraph = window.opener.document.getElementById('HiddenGraph');
	//alert("parent hidden: " + parentHiddenGraph.value);
	var MyHiddenGraph = document.getElementById('HiddenGraph');
	//alert("my graph: " + MyHiddenGraph.value);
	parentHiddenGraph.value = MyHiddenGraph.value;
	//alert("will submit...");

	var parentIncrement = window.opener.document.getElementById('Increment');
	var myIncrement = document.getElementById('GRPHXAxisIncrement');
	if (parentIncrement && myIncrement) parentIncrement.value = myIncrement.value;

	var parentIncUnit = window.opener.document.getElementById('IncrementUnit');
	var myIncUnit = document.getElementById('GRPHXAxisIncrementUnit');
	if (parentIncUnit && myIncUnit) parentIncUnit.value = myIncUnit.value;

	// Log 53368 YC - Ensuring that increment unit code gets passed to ChartFX.Link
	var parentIncUnitCode = window.opener.document.getElementById('IncrementUnitCode');
	var myIncUnitCode = document.getElementById('GRPHXAxisIncUnitCode');
	if (parentIncUnitCode && myIncUnitCode) parentIncUnitCode.value = myIncUnitCode.value;

	var parentIntType = window.opener.document.getElementById('IntervalType');
	var myIntType = document.getElementById('GRPHXAxisIntervalType');
	if (parentIntType && myIntType) parentIntType.value = myIntType.value;

	var parentDateFrom = window.opener.document.getElementById('DateFrom');
	if (parentDateFrom) {
		var DateFromCheck = document.getElementById('GRPHDateFromCurrent');
		var DateFromOffset = document.getElementById('GRPHDateFromOffset');
		if (DateFromCheck) {
			if (DateFromCheck.checked==true) parentDateFrom.value = "t";
			else if(DateFromOffset) if(DateFromOffset.value!="") parentDateFrom.value = DateFromOffset.value;
		}
		else if(DateFromOffset) if(DateFromOffset.value!="") parentDateFrom.value = DateFromOffset.value;
	}

	var parentDateTo = window.opener.document.getElementById('DateTo');
	if (parentDateTo) {
		var DateToCheck = document.getElementById('GRPHDateToCurrent');
		var DateToOffset = document.getElementById('GRPHDateToOffset');
		if (DateToCheck) {
			if (DateToCheck.checked==true) parentDateTo.value = "t";
			else if(DateToOffset) if(DateToOffset.value!="") parentDateTo.value = DateToOffset.value;
		}
		else if(DateToOffset) if(DateToOffset.value!="") parentDateTo.value = DateToOffset.value;
	}

	window.opener.SubmitGraph();
	window.close();

	return ret;
}
// end Log 47281

// Log 51476 YC - Check date to and from
function SubmitDateCheck() {
	var DateFromVal="";
	var DateToVal="";
	var DateFrom = document.getElementById('GRPHDateFromOffset');
	var DateTo = document.getElementById('GRPHDateToOffset');
	var DateFromCurr = document.getElementById('GRPHDateFromCurrent');
	var DateToCurr = document.getElementById('GRPHDateToCurrent');
	if (DateFromCurr)
		if(DateFromCurr.checked==true) DateFromVal=0;
	if (DateToCurr)
		if(DateToCurr.checked==true) DateToVal=0;
	if (DateFrom) {
		if(DateFromVal==="") DateFromVal=parseFloat(DateFrom.value);
		if(!isNaN(DateFromVal)) DateFrom.value=DateFromVal;
	}
	if (DateTo) {
		if(DateToVal==="") DateToVal=parseFloat(DateTo.value);
		if(!isNaN(DateToVal)) DateTo.value=DateToVal;
	}
	if ((!isNaN(DateFromVal))&&(!isNaN(DateToVal))) {
		if (DateFromVal > DateToVal) {
			alert(t['NOTLATER']);
				return false;
		}
	}
	return true;
}

// Log 46461 YC - Lookup Handler for GraphType
function GraphTypeLookUpHandler(str)
{
	var objGraphTypeCode=document.getElementById('GRPHGraphTypeCode');
	if (objGraphTypeCode) {
		var lu = str.split("^");
		objGraphTypeCode.value=lu[2];
		GraphTypeHandler(true);
	}
}

// Log 46461 YC - Change handler for GraphType
function GraphTypeHandler(InLookUp)
{
	if (GraphType_CHANGE && !InLookUp) {
		GraphType_CHANGE();
	}
	var objGraphTypeCode=document.getElementById('GRPHGraphTypeCode');
	var objGraphType=document.getElementById('GRPHGraphType');
	if (objGraphType&&objGraphTypeCode)
	{
		var objNoOfInt=document.getElementById('cGRPHNoOfIntervals');
		if (objNoOfInt) objNoOfInt.className="";
		var objInc=document.getElementById('cGRPHXAxisIncrement');
		var objIncU=document.getElementById('cGRPHXAxisIncrementUnit');
		// ensures that code is blank if graph type has not been entered
		if (objGraphType.value=="")
			objGraphTypeCode.value="";
		if ( objGraphTypeCode.value=="PG" ) {
			if (objNoOfInt) objNoOfInt.className="clsRequired";
			if (objInc) objInc.className="clsRequired";
			if (objIncU) objIncU.className="clsRequired";
		}
		// disable Y axis attributes for Dancis
		if(objGraphTypeCode.value=="DC")
		{
			var objY1Max=document.getElementById('GRPHY1AxisMax');
			if(objY1Max) { objY1Max.disabled=true; objY1Max.className="disabledField"; }
			var objY1Min=document.getElementById('GRPHY1AxisMin');
			if(objY1Min) { objY1Min.disabled=true; objY1Min.className="disabledField"; }
			var objY1Step=document.getElementById('GRPHY1AxisStep');
			if(objY1Step) { objY1Step.disabled=true; objY1Step.className="disabledField"; }
			var objY2Max=document.getElementById('GRPHY2AxisMax');
			if(objY2Max) { objY2Max.disabled=true; objY2Max.className="disabledField"; }
			var objY2Min=document.getElementById('GRPHY2AxisMin');
			if(objY2Min) { objY2Min.disabled=true; objY2Min.className="disabledField"; }
			var objY2Step=document.getElementById('GRPHY2AxisStep');
			if(objY2Step) { objY2Step.disabled=true; objY2Step.className="disabledField"; }
			var objIntType=document.getElementById('GRPHXAxisIntervalType');
			if(objIntType) { objIntType.disabled=true; objIntType.className="disabledField"; }
			var objDateFrom=document.getElementById('GRPHDateFromOffset');
			if(objDateFrom) { objDateFrom.disabled=true; objDateFrom.className="disabledField"; }
			var objDateFromCurr=document.getElementById('GRPHDateFromCurrent');
			if(objDateFromCurr) { objDateFromCurr.disabled=true; objDateFromCurr.className="disabledField"; }
			var objDateTo=document.getElementById('GRPHDateToOffset');
			if(objDateTo) { objDateTo.disabled=true; objDateTo.className="disabledField"; }
			var objDateToCurr=document.getElementById('GRPHDateToCurrent');
			if(objDateToCurr) { objDateToCurr.disabled=true; objDateToCurr.className="disabledField"; }
		}
		// undisable Y axis attributes if not Dancis
		else
		{
			var objY1Max=document.getElementById('GRPHY1AxisMax');
			if(objY1Max) { objY1Max.disabled=false; objY1Max.className=""; }
			var objY1Min=document.getElementById('GRPHY1AxisMin');
			if(objY1Min) { objY1Min.disabled=false; objY1Min.className=""; }
			var objY1Step=document.getElementById('GRPHY1AxisStep');
			if(objY1Step) { objY1Step.disabled=false; objY1Step.className=""; }
			var objY2Max=document.getElementById('GRPHY2AxisMax');
			if(objY2Max) { objY2Max.disabled=false; objY2Max.className=""; }
			var objY2Min=document.getElementById('GRPHY2AxisMin');
			if(objY2Min) { objY2Min.disabled=false; objY2Min.className=""; }
			var objY2Step=document.getElementById('GRPHY2AxisStep');
			if(objY2Step) { objY2Step.disabled=false; objY2Step.className=""; }
			var objIntType=document.getElementById('GRPHXAxisIntervalType');
			if(objIntType) { objIntType.disabled=false; objIntType.className=""; }
			var objDateFrom=document.getElementById('GRPHDateFromOffset');
			if(objDateFrom) { objDateFrom.disabled=false; objDateFrom.className=""; }
			var objDateFromCurr=document.getElementById('GRPHDateFromCurrent');
			if(objDateFromCurr) { objDateFromCurr.disabled=false; objDateFromCurr.className=""; }
			var objDateTo=document.getElementById('GRPHDateToOffset');
			if(objDateTo) { objDateTo.disabled=false; objDateTo.className=""; }
			var objDateToCurr=document.getElementById('GRPHDateToCurrent');
			if(objDateToCurr) { objDateToCurr.disabled=false; objDateToCurr.className=""; }
		}
	}
	return true;
}

function AxisType1LookUpSelect() {
	AxisType1FieldHandler();
}

function AxisType2LookUpSelect() {
	AxisType2FieldHandler();
}

function AxisType1FieldHandler() {
	//alert(objY1Type.value)
	if ((objY1Type.value=="")&&(objY1Profile)) {
	  //Disable Y1 Profile field and lookup
	  objY1Profile.value="";
	  objY1Profile.disabled=true;
	  objY1Profile.className = "disabledField";
	  if (objY1ProfileLUIcon) objY1ProfileLUIcon.onclick='';
	} else {
	  //Enable Y1 Profile field and lookup
	  objY1Profile.disabled=false;
	  objY1Profile.className = "";
	  if (objY1ProfileLUIcon) objY1ProfileLUIcon.onclick=Y1AxisProfile_lookuphandler;
	}
}

function AxisType2FieldHandler() {
	//alert(objY2Type.value)
	if ((objY2Type.value=="")&&(objY2Profile)) {
	  //Disable Y2 Profile field and lookup
	  objY2Profile.value="";
	  objY2Profile.disabled=true;
	  objY2Profile.className = "disabledField";
	  if (objY2ProfileLUIcon) objY2ProfileLUIcon.onclick='';
	} else {
	  //Enable Y2 Profile field and lookup
	  objY2Profile.disabled=false;
	  objY2Profile.className = "";
	  if (objY2ProfileLUIcon) objY2ProfileLUIcon.onclick=Y2AxisProfile_lookuphandler;
	}
}

// Log 53368 YC - Lookup handler for Increment Unit. Populates GRPHXAxisIncUnitCode field.
function IncUnitLookupHandler(str)
{
	var lu = str.split("^");
	var obj=document.getElementById("GRPHXAxisIncUnitCode");
	if ((obj)&&(lu[2]!="")) {
		obj.value=lu[2];
	}
}

document.body.onload=BodyLoadHandler;
