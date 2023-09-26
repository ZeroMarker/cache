// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//
var objQueryBuild=document.getElementById('QueryBuild');
var objRowItems=document.getElementById('RowItems');

//var objConRuleValue=document.getElementById('ConRuleValue');
//if (objConRuleValue) objConRuleValue.onchange=BuildQueryLine;
var objRowRuleValue=document.getElementById('RowRuleValue');
if (objRowRuleValue) objRowRuleValue.onchange=BuildQueryLine2;

var objRule=document.getElementById('Rule');
var objValMatch=document.getElementById('ValMatch');

var objDelLine=document.getElementById("DeleteLine");
if (objDelLine) objDelLine.onclick=DeleteLineClickHandler;

var objRowDelItm=document.getElementById("RowDeleteItem");
if (objRowDelItm) objRowDelItm.onclick=RowDeleteItemClickHandler;

var objValueAND=document.getElementById("ValueAND");
if (objValueAND) objValueAND.onclick=AndClickHandler;
//inserted by Hun Ly 20030122
var objValueOR=document.getElementById("ValueOR");
if (objValueOR) objValueOR.onclick=ORClickHandler;
//end Hun Ly

var objValueLEFT=document.getElementById("ValueLEFT");
if (objValueLEFT) objValueLEFT.onclick=LeftClickHandler;

var objValueRIGHT=document.getElementById("ValueRIGHT");
if (objValueRIGHT) objValueRIGHT.onclick=RightClickHandler;

var objValueBRACK=document.getElementById("ValueBRACK");
if (objValueBRACK) objValueBRACK.onclick=AddBrackets;


var objFindCrossTab=document.getElementById("FindCrossTab");
if (objFindCrossTab) objFindCrossTab.onclick=FindCrossTabClickHandler;
var objUpdate=document.getElementById("update1");
if (objUpdate) objUpdate.onclick=UpdateClickHandler;
var objCopyClipBoard=document.getElementById("CopyClipBoard");
if (objCopyClipBoard) objCopyClipBoard.onclick=CopytoClipBoard;

var f=document.getElementById("fwebsys_DSSQuery_Edit");

var QueryStr="";
var DisplayStr="";

function BuildSingleLine() {
	var ValMatch=objValMatch.value;
	if ((ValMatch=="")||(ValMatch=="E")) {
		ValMatch="Equals";
	}
	if (ValMatch=="C") {
		ValMatch="Contains";
	}
	if (ValMatch=="S") {
		ValMatch="StartsWith";
	}
	var vConUnit="VALUE"
	var objConUnit=document.getElementById('ConUnit');
	if (objConUnit){
		vConUnit=objConUnit.value
		vConUnit=vConUnit.toUpperCase()
	}
	if (vConUnit.length==0){
		vConUnit="VALUE"
	}
	
	var objConditionRuleID = document.getElementById('ConditionRuleID');
	var objConRuleValue = document.getElementById('ConRuleValue');
	if (QueryStr=="") {
		QueryStr="["+objConditionRuleID.value+","+objConRuleValue.value+","+"BUCKET"+","+vConUnit+"]";		
		DisplayStr="("+objRule.value+" "+ValMatch+" "+objConRuleValue.value;
	} else {
		QueryStr+="|["+objConditionRuleID.value+","+objConRuleValue.value+","+"BUCKET"+","+vConUnit+"]";
		if (DisplayStr.substr(DisplayStr.length-4,DisplayStr.length)==" AND") {
			DisplayStr=DisplayStr.substr(0,DisplayStr.length-4)
		}	
		DisplayStr+=" OR "+objConRuleValue.value;
	}
	DisplayStr+=")";
	//alert("QueryStr= "+QueryStr);
}

function BuildQueryLine() {
	var SingleLine=""
	var lstlen=objQueryBuild.length;
	QueryStr="";
	DisplayStr="";
	var objConRuleValue = document.getElementById('ConRuleValue');
	if (objConRuleValue.value=="") return true;
	var objConditionRuleID = document.getElementById('ConditionRuleID');
	if (objConditionRuleID.value=="") return true;
	SingleLine=BuildLine();
	if (QueryStr=="") return false;
	lstlen=objQueryBuild.length;
	objQueryBuild.options[lstlen] = new Option(DisplayStr,QueryStr);
	objQueryBuild.options[lstlen].selected=true;
	objConRuleValue.value=""
}


function BuildLine() {
	var ValMatch=objValMatch.value;
	if ((ValMatch=="")||(ValMatch=="E")) {
		ValMatch="Equals";
	}
	if (ValMatch=="C") {
		ValMatch="Contains";
	}
	if (ValMatch=="S") {
		ValMatch="StartsWith";
	}
	var vConUnit="VALUE"
	var objConUnit=document.getElementById('ConUnit');
	if (objConUnit){
		vConUnit=objConUnit.value
		vConUnit=vConUnit.toUpperCase()
	}
	if (vConUnit.length==0){
		vConUnit="VALUE"
	}
	var objConditionRuleID = document.getElementById('ConditionRuleID');
	var objConRuleValue = document.getElementById('ConRuleValue');
	if (QueryStr=="") {
		QueryStr="["+objConditionRuleID.value+","+objConRuleValue.value+","+"BUCKET"+","+vConUnit+"]";		
		DisplayStr="("+objRule.value+" "+ValMatch+" "+objConRuleValue.value;
	} else {
		QueryStr+="|["+objConditionRuleID.value+","+objConRuleValue.value+","+"BUCKET"+","+vConUnit+"]";
		if (DisplayStr.substr(DisplayStr.length-4,DisplayStr.length)==" AND") {
			DisplayStr=DisplayStr.substr(0,DisplayStr.length-4)
		}	
		DisplayStr+=" OR "+objConRuleValue.value;
	}
	DisplayStr+=")";
}

function UpdateClickHandler() {
	var objQueryText=document.getElementById("QueryText");
	var objQueryValue=document.getElementById("QueryValue");
	var objRowFilter=document.getElementById("RowFilter");
	if (objQueryText) {
		objQueryText.value=BuildQueryText(objQueryBuild);
	}
	if (objQueryValue) {
		objQueryValue.value=BuildQueryValue(objQueryBuild);
		//alert(objQueryValue.value);
	}
	if (objRowFilter) {
		//objRowFilter.value=BuildQueryValue(objRowItems);
		objRowFilter.value=BuildQueryText2(objRowItems);
	}
	return update1_click();
}

function BuildQueryLine2() {
	QueryStr="";
	DisplayStr="";
	var SingleLine=BuildSingleLine2();
	if (QueryStr=="") return false;

	if (objRowItems) {
		for (var i=0;i<objRowItems.length;i++) {
			//if (objRowItems.options[i].selected){
			if (objRowItems.options[i].value==QueryStr) return false;
				//objRowItems.options[i].text=DisplayStr;
				//objRowItems.options[i].selected=true;
			//	return false
			//}
		}
	}

	var lstlen=objRowItems.length;
	objRowItems.options[lstlen] = new Option(DisplayStr,QueryStr);
	objRowItems.options[lstlen].selected=true;
}


function BuildSingleLine2() {
	for (var i=0;i<objRowRuleValue.length;i++) {
		if (objRowRuleValue.options[i].selected) {
			if (QueryStr=="") {
				QueryStr=objRowRuleValue.options[i].text;
			} else {
				QueryStr+=";"+objRowRuleValue.options[i].text;
			}
		}
	}
	DisplayStr=QueryStr;
	//alert(DisplayStr);
}

function DeleteLineClickHandler() {
	//Delete items from listbox when a "Delete" button is clicked.

	if (objQueryBuild)
		RemoveFromList(objQueryBuild);
	return false;
}
function RemoveFromList(obj) {
	var frm=document.fwebsys_DSSQuery_Edit;
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}
function RowDeleteItemClickHandler() {
	//Delete items from listbox when a "Delete" button is clicked.

	if (objRowItems) RemoveFromList(objRowItems);

	return false;
}

// ab 13.12.06 - 61161
function AddBrackets() {
	if (objQueryBuild) {
		// find the first and last selected condition rows
		var FirstSelected=-1;
		var LastSelected=-1;
		for (var i=0;i<objQueryBuild.length;i++) {
			if (objQueryBuild.options[i].selected) {
				if (FirstSelected==-1) FirstSelected=i;
				LastSelected=i;
			}
		}
		
		// check if any bracket overlaps and display error msg
		// you can add brackets to any single line, or any multiple lines where the existing brackets cancel each other out
		var NumBrackets=0;
		if ((FirstSelected!=-1)&&(LastSelected!=-1)&&(FirstSelected!=LastSelected)) {
			for (var i=FirstSelected;i<(LastSelected+1);i++) {
				var strValue=objQueryBuild.options[i].value;
				for (var j=0;j<strValue.length;j++) {
					if (strValue.charAt(j)=="(") NumBrackets++;
					if (strValue.charAt(j)==")") NumBrackets--;
				}
			}
			if (NumBrackets!=0) {
				alert(t['BrackOverlap']);
				return false;
			}
		}
		
		// add brackets to first and last condition rows
		if (FirstSelected!=-1) {
			objQueryBuild.options[FirstSelected].text="("+objQueryBuild.options[FirstSelected].text;
			objQueryBuild.options[FirstSelected].value="("+objQueryBuild.options[FirstSelected].value;
		}
		if (LastSelected!=-1) {
			// TODO: add the bracket before any "AND" or "OR"
			var strText=objQueryBuild.options[LastSelected].text;
			var strValue=objQueryBuild.options[LastSelected].value;
			var strOper=objQueryBuild.options[LastSelected].value.substr(objQueryBuild.options[LastSelected].value.length-1,objQueryBuild.options[LastSelected].value.length);

			if ((strOper=="|")||(strOper=="&")) {
				// add before " OR" or " AND"
				//objQueryBuild.options[LastSelected].value=strValue.substr(0,strValue.length-2)+")"+strOper;
				if (strOper=="|") {
					objQueryBuild.options[LastSelected].text=strText.substr(0,strText.length-3)+") OR";
					objQueryBuild.options[LastSelected].value=strValue.substr(0,strValue.length-1)+")|";
				} else {
					objQueryBuild.options[LastSelected].text=strText.substr(0,strText.length-3)+") AND";
					objQueryBuild.options[LastSelected].value=strValue.substr(0,strValue.length-1)+")&";
				}
			} else {
				objQueryBuild.options[LastSelected].text=objQueryBuild.options[LastSelected].text+")";
				objQueryBuild.options[LastSelected].value=objQueryBuild.options[LastSelected].value+")";
			}
			//alert(objQueryBuild.options[LastSelected].value);
		}
		
	}
}

function AndClickHandler() {
	//ClearSelectedList(objConRuleValue);
	if (objQueryBuild) {
		for (var i=0;i<objQueryBuild.length;i++) {
			if (objQueryBuild.options[i].selected){

				var strText=objQueryBuild.options[i].text;
				var strValue=objQueryBuild.options[i].value;
				var strOper=strValue.substr(strValue.length-1,strValue.length)

				if ((strOper!="|") && (strOper!="&")) {
					objQueryBuild.options[i].text+=" AND";
					objQueryBuild.options[i].value+="&";
				}
				else{

					if (strOper=="|") objQueryBuild.options[i].text=strText.substr(0,strText.length-3)+" AND";
					objQueryBuild.options[i].value=strValue.substr(0,strValue.length-1)+"&";
				}

				objQueryBuild.options[i].selected=false;
				return false;
			}
		}
	}
}

function ORClickHandler() {
	//ClearSelectedList(objConRuleValue);
	if (objQueryBuild) {
		for (var i=0;i<objQueryBuild.length;i++) {
			if (objQueryBuild.options[i].selected){

				var strText=objQueryBuild.options[i].text;
				var strValue=objQueryBuild.options[i].value;
				var strOper=strValue.substr(strValue.length-1,strValue.length)
				if ((strOper!="|") && (strOper!="&")) {
					objQueryBuild.options[i].text+=" OR";
					objQueryBuild.options[i].value+="|";
				}
				else{

					if (strOper=="&") objQueryBuild.options[i].text=strText.substr(0,strText.length-4)+" OR";
					objQueryBuild.options[i].value=strValue.substr(0,strValue.length-1)+"|";
				}
				objQueryBuild.options[i].selected=false;
				return false;
			}
		}
	}
}

function ClearSelectedList(obj) {
	for (var i=obj.options.length-1; i>=0; i--) {
		if (obj.options[i].selected) obj.options[i].selected=false;
	}
}

function BuildQueryValue(obj) {
	var FullQueryStr="";
	if (obj) {
		for (var i=0;i<obj.length;i++) {
			//alert(obj.options[i].value);
			if (FullQueryStr=="") {
				FullQueryStr=obj.options[i].value;
			} else {
				var strOper=FullQueryStr.substr(FullQueryStr.length-1,FullQueryStr.length)
				//set default value to "|" don't forget to make the change in BuildQueryText to reflex this condition
				if ((strOper!="|") && (strOper!="&")) {
					//FullQueryStr+="&;"+obj.options[i].value;
					FullQueryStr+="|;"+obj.options[i].value;
				}
				else{
					FullQueryStr+=";"+obj.options[i].value;
				}
			}
			
		}
	}
	return FullQueryStr;
}

function BuildQueryText2(obj) {
	var FullQueryStr="";
	if (obj) {
		for (var i=0;i<obj.length;i++) {
			if (FullQueryStr=="") {
				FullQueryStr=obj.options[i].text;
			} else {
				FullQueryStr+=";"+obj.options[i].text;
			}
		}
	}
	return FullQueryStr;
}

function BuildQueryText(obj) {
	var FullQueryStr="";
	if (obj) {
		for (var i=0;i<obj.length;i++) {

			if (FullQueryStr=="") {
				FullQueryStr=obj.options[i].text;
			} else {
				var strTemp=FullQueryStr.substr(FullQueryStr.length-5,FullQueryStr.length)
				var lu=strTemp.split(" ")
				var strOper=lu[1]
				//set default value to "OR" don't forget to make the change in BuildQueryValue to reflex this condition
				if ((strOper!="AND") && (strOper!="OR")) {
					//FullQueryStr+=" AND;"+obj.options[i].text;
					FullQueryStr+=" OR;"+obj.options[i].text;
				}
				else{
					FullQueryStr+=";"+obj.options[i].text;
				}
			}
		}
	}
	return FullQueryStr;
}

function CopytoClipBoard() {
	var obj=document.getElementById("Querytbl");
	if (obj) {
		window.clipboardData.setData("text",obj.outerHTML);
	}
	return false;
}

//This block of code is inserted by Hun Ly 04/11/2002//

function SetTXTStatus(obj,blnStatus) {
//This function changes the status of text box to either enable or disable mode
	if (!blnStatus) {
		obj.value='';
		obj.readOnly=!blnStatus;
		obj.className='disabledField';
	}
	else{
		obj.readOnly=!blnStatus;
		obj.className='enabledField';
	}
}
function SetCMDStatus(obj,blnStatus) {
//This function changes the lookup button to either enable or disable
	obj.disabled=!blnStatus
}

function ScreenControl() {
	var objRowUnit=document.getElementById('RowUnit');
	var objRowUnitButt=document.getElementById('ld1486iRowUnit');
	var x
	if (objRowUnit) {
		x=objRowUnit.value
		if (x.length==0) {
		SetTXTStatus(objRowUnit,false);

		if (objRowUnitButt) SetCMDStatus(objRowUnitButt,false);
		}
	}
	var objColUnit=document.getElementById('ColUnit');
	var objColUnitButt=document.getElementById('ld1486iColUnit');
	var x
	if (objColUnit) {
		x=objColUnit.value
		if (x.length==0) {
		SetTXTStatus(objColUnit,false);

		if (objColUnitButt) SetCMDStatus(objColUnitButt,false);
		}
	}
	var objConUnit=document.getElementById('ConUnit');
	var objConUnitButt=document.getElementById('ld1486iConUnit');
	var x
	if (objConUnit) {
		x=objConUnit.value
		if (x.length==0) {
		SetTXTStatus(objConUnit,false);

		if (objConUnitButt) SetCMDStatus(objConUnitButt,false);
		}
	}

}
function BodyLoadHandler() {

	ScreenControl()
}

window.document.body.onload=BodyLoadHandler;

//End Hun Ly////////////////////////////////////////
