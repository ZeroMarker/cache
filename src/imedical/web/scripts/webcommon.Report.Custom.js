// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm=document.getElementById('fwebcommon_Report_Custom');
var maxprompts=9;
// Log 58223 - PJC - 07-02-2006 : Allow the lists to be "required" and not error when values are selected.
if (document.getElementById('custom1list')) document.getElementById('custom1list').tkItemPopulate=1;
if (document.getElementById('custom2list')) document.getElementById('custom2list').tkItemPopulate=1;
if (document.getElementById('custom3list')) document.getElementById('custom3list').tkItemPopulate=1;
if (document.getElementById('custom11list')) document.getElementById('custom11list').tkItemPopulate=1;
if (document.getElementById('custom12list')) document.getElementById('custom12list').tkItemPopulate=1;
// end Log 58223

function BodyLoadHandler() {

	//For all reports that are not previewed, disable hidden prompt(n) variables so it doesn't go into the cystal print areas
	//The below code ensures that the Report Manager parameters expressions are resolved in the websys.Report class.
	if (frm.elements["PrintPreview"].value!="1") {
		for (var i=0; i<maxprompts; i++) {
			var obj=frm.elements["prompt"+i];
			if (obj) obj.disabled=true;
		}
	}

	// Delete Custom Click Handlers
	var obj=document.getElementById("deletecustom1list");
	if ((obj)) obj.onclick=DeleteCustom1ClickHandler;
	var obj=document.getElementById("deletecustom2list");
	if ((obj)) obj.onclick=DeleteCustom2ClickHandler;
	var obj=document.getElementById("deletecustom3list");
	if ((obj)) obj.onclick=DeleteCustom3ClickHandler;
	var obj=document.getElementById("deletecustom11list");
	if ((obj)) obj.onclick=DeleteCustom11ClickHandler;
	var obj=document.getElementById("deletecustom12list");
	if ((obj)) obj.onclick=DeleteCustom12ClickHandler;


	// Date Change Handlers
	var obj=document.getElementById('date1');
	if (obj) obj.onchange=Date1ChangeHandler;
	var obj=document.getElementById('date2');
	if (obj) obj.onchange=Date2ChangeHandler;
	var obj=document.getElementById('date3');
	if (obj) obj.onchange=Date3ChangeHandler;
	var obj=document.getElementById('date4');
	if (obj) obj.onchange=Date4ChangeHandler;


	//Log 53632 - AI - 15-09-2005 : Change the initial function to be a time delay, THEN run the appropriate function after the delay.
	//var print=document.getElementById('Print');
	//if (print) print.onclick=PrintOptionclickhandler;
	//var preview=document.getElementById('Preview');
	//if (preview) preview.onclick=PreviewOptionclickhandler;
	var print=document.getElementById('Print');
	if (print) print.onclick=timedelayonPrint;
	var preview=document.getElementById('Preview');
	if (preview) preview.onclick=timedelayonPreview;
	// end Log 53632


	// Log 46802 - AI - 21-10-2004 : Add logic to clear all enabled fields on the screen.
	var objclear=document.getElementById('clear1');
	if (objclear) objclear.onclick=ClearClickHandler;
	// end Log 46802

	//  This function is called to allow custom scripts for reports using webcommon.Report.Custom
	ReportCustomScripts();
}

function ReportCustomScripts()
{

}

function Date1ChangeHandler(e) {
	// set hidden date element with internal cache date
	var objdate1=document.getElementById('date1');
	if (objdate1) {
		date1_changehandler();
		var obj=document.getElementById('datecache1');
		if (obj) obj.value=DateStringTo$H(objdate1.value)
	}
}

function Date2ChangeHandler(e) {
	// set hidden date element with internal cache date
	var objdate2=document.getElementById('date2');
	if (objdate2) {
		date2_changehandler();
		var obj=document.getElementById('datecache2');
		if (obj) obj.value=DateStringTo$H(objdate2.value)
	}
}


function Date3ChangeHandler(e) {
	// set hidden date element with internal cache date
	var objdate3=document.getElementById('date3');
	if (objdate3) {
		date3_changehandler();
		var obj=document.getElementById('datecache3');
		if (obj) obj.value=DateStringTo$H(objdate3.value)
	}
}

function Date4ChangeHandler(e) {
	// set hidden date element with internal cache date
	var objdate4=document.getElementById('date4');
	if (objdate4) {
		date4_changehandler();
		var obj=document.getElementById('datecache4');
		if (obj) obj.value=DateStringTo$H(objdate4.value)
	}
}


function DeleteCustom1ClickHandler() {
	//Delete items from listbox when "Delete" button is clicked.
	var obj=document.getElementById("custom1list");
	if (obj) {
		RemoveFromList(obj);
		var lstField='custom1list';
		var IDField='custom1ID';
		UpdatewithIDs(lstField,IDField);
	}
	return false;
}

function DeleteCustom2ClickHandler() {
	//Delete items from listbox when "Delete" button is clicked.
	var obj=document.getElementById("custom2list");
	if (obj) {
		RemoveFromList(obj);
		var lstField='custom2list';
		var IDField='custom2ID';
		UpdatewithIDs(lstField,IDField);
	}
	return false;
}
function DeleteCustom3ClickHandler() {
	//Delete items from listbox when "Delete" button is clicked.
	var obj=document.getElementById("custom3list");
	if (obj) {
		RemoveFromList(obj);
		var lstField='custom3list';
		var IDField='custom3ID';
		UpdatewithIDs(lstField,IDField);
	}
	return false;
}

function DeleteCustom11ClickHandler() {
	//Delete items from listbox when "Delete" button is clicked.
	var obj=document.getElementById("custom11list");
	if (obj) {
		RemoveFromList(obj);
		var lstField='custom11list';
		var IDField='custom11ID';
		UpdatewithIDs(lstField,IDField);
	}
	return false;
}
function DeleteCustom12ClickHandler() {
	//Delete items from listbox when "Delete" button is clicked.
	var obj=document.getElementById("custom12list");
	if (obj) {
		RemoveFromList(obj);
		var lstField='custom12list';
		var IDField='custom12ID';
		UpdatewithIDs(lstField,IDField);
	}
	return false;
}


function custom1LookUpSelect(str) {
	var objList=document.getElementById('custom1list');
	if (objList) {
		var txtField='custom1';
		var lstField='custom1list';
		LookupSelectforList(txtField,lstField,str);
		var IDField='custom1ID';
		UpdatewithIDs(lstField,IDField);
	}
}

function custom2LookUpSelect(str) {
	var objList=document.getElementById('custom2list');
	if (objList) {
		var txtField='custom2';
		var lstField='custom2list';
		LookupSelectforList(txtField,lstField,str);
		var IDField='custom2ID';
		UpdatewithIDs(lstField,IDField);
	}
}

function custom3LookUpSelect(str) {
	var objList=document.getElementById('custom3list');
	if (objList) {
		var txtField='custom3';
		var lstField='custom3list';
		LookupSelectforList(txtField,lstField,str);
		var IDField='custom3ID';
		UpdatewithIDs(lstField,IDField);
	}
}
function custom11LookUpSelect(str) {
	var objList=document.getElementById('custom11list');
	if (objList) {
		var txtField='custom11';
		var lstField='custom11list';
		LookupSelectforList(txtField,lstField,str);
		var IDField='custom11ID';
		UpdatewithIDs(lstField,IDField);
	}
}
function custom12LookUpSelect(str) {
	var objList=document.getElementById('custom12list');
	if (objList) {
		var txtField='custom12';
		var lstField='custom12list';
		LookupSelectforList(txtField,lstField,str);
		var IDField='custom12ID';
		UpdatewithIDs(lstField,IDField);
	}
}


function LOOKUP1LookUpSelect(str) {

}

function LOOKUP2LookUpSelect(str) {

}

function LOOKUP3LookUpSelect(str) {

}

function LOOKUP4LookUpSelect(str) {

}

function LOOKUP5LookUpSelect(str) {

}

function LOOKUP6LookUpSelect(str) {

}


//Log 53632 - AI - 15-09-2005 : Change the initial function to be a time delay, THEN run the appropriate function after the delay.
//function to allow time out for validation on Print.
function timedelayonPrint() {
	setTimeout("PrintOptionclickhandler()",1500);
	return false;
}

//function to allow time out for validation on Preview.
function timedelayonPreview() {
	setTimeout("PreviewOptionclickhandler()",1500);
	return false;
}
// end Log 53632


//KK 18/Dec/2002 Log 30023 User Print Options
//KK 06/Feb/2004 Log 40045
//KK 18/Mar/2005 Log 45244 check for ReportType = Other for printoptions
function PrintOptionclickhandler(){
	var printopt=document.getElementById('PrintOption');
	var PrintPreview=document.getElementById('PrintPreview');
	var ReportType=document.getElementById("ReportType");
	//alert(printopt.value + "^" + PrintPreview.value + "^" + ReportType.value);
	if ((printopt) && (printopt.value=="1") && (PrintPreview.value=="0")&&(ReportType.value!="Other")){
		// Log 53632 - AI - 13-09-2005 : Check that fields aren't clsInvalid before printing or previewing.
		//    logic initially done in Log 48398 by YC in W650 webcommon.DateFromTo.Custom.js.
		if (!InvalidCheck()) return false;
		// end Log 53632
		var objReportCode=document.getElementById('ReportCode');
		if (objReportCode) ReportCode=objReportCode.value;
		var frmparent;
		frmparent=document.getElementById('fwebcommon_Report_Custom');
		var url="";
		if (frmparent) url=frmparent.action;
		url=url+'&ReportCode='+ ReportCode;
		//alert("url=" + url);
		websys_print('1',url,'','','Print_clickhandler');
	} else {
		//alert("2");
		//Print_clickhandler("",true);
		Print_clickhandler();
	}
}

function PreviewOptionclickhandler(){
	Print_clickhandler("",true);
}

function Print_clickhandler(param,preview) {
  	// pre-Submit validation
  	if (fwebcommon_Report_Custom_submit()) {
	    // Log 53632 - AI - 13-09-2005 : Check that fields aren't clsInvalid before printing or previewing.
	    //    logic initially done in Log 48398 by YC in W650 webcommon.DateFromTo.Custom.js.
	    if (!InvalidCheck()) return false;
	    // end Log 53632
	    if (frm) {
		// Log 54152 - AI - 22-09-2005 : Store the frm's action. When not previewing, reset the action back to this initial value.
		var holdaction;
		holdaction=frm.action;
		// end Log 54152
		// Log 54415 - AI - 18-08-2005 : Before anything else, clear any IDs for custom fields with no list, if the custom field is blank.
		CheckCustomFields();
		// end Log 54415
		// Build ID strings for all lists that are on the layout
		BuildIDsfromList();
		var promptcnt=0;
		var obj;
		var elementid;
		//loop thru each textbox/checkbox on the page and assign the selected value to crystal parameters and prepare values
		for (var i=0;i<=frm.elements.length+1;i++) {
			if (frm.elements[i]) {
				if (frm.elements[i].type=="text"||(frm.elements[i].type=="checkbox")) {
					elementid=frm.elements[i].id;
					obj=document.getElementById(elementid);
					if ((frm.elements["ReportType"].value=="Crystal")||(frm.elements["ReportType"].value=="Word")) {
						promptcnt=AssignParameterValue(elementid,promptcnt,obj,frm);
					}else {	// Perform conversion on Cache values for Report Types Cache, Cache+Crystal & Other
						promptcnt=AssignCacheValue(elementid,promptcnt,obj,frm);
					}
				}
			}
			//as the maximum number of parameters that can be passed to crystal is 9, exit the loop
			//when the count is 8. (remembering that the count starts at 0)
			if (promptcnt==maxprompts) break;
		}
		//log 25298 - if the PrintPreview flag is set on the menu then preview report in Viewer
		if ((frm.elements["ReportType"].value=="Crystal")&&((frm.elements["PrintPreview"].value=="1")||(preview))) {
			var previewpvalue="";
			var multipval="";
			var crystalras="";
			var objCrystalRAS=document.getElementById("CrystalReportsRAS");
			//alert(objCrystalRAS.value);
			if ((objCrystalRAS)&&(objCrystalRAS.value=="Disable")) {
				alert("Previewing of Crystal Reports Disabled!");
				return false;
			}
			for (var i=0; i<maxprompts; i++) {
				var strpval=mPiece(frm.elements["prompt"+i].value,'"',1);
				multipval="";
				if (strpval!=""){
					previewpvalue+="&promptex-prompt" + i + "=" + frm.elements["prompt"+i].value;
				}else{
					previewpvalue+="&prompt" + i + "=" + frm.elements["prompt"+i].value;
				}
			}
			var previewurl="";
			previewpvalue=previewpvalue.substring(1,(previewpvalue.length));
			var objVT=document.getElementById('ViewerType');
			//alert(objVT.value);
			if ((objVT) && (objVT.value!="")){
				previewurl=frm.action+"?init="+objVT.value+"&"+previewpvalue;
			}else{
				previewurl=frm.action+"?"+previewpvalue;
			}
			//alert("1^" + previewurl);
			//KK 28/May/2004 L:43422
			if ((objCrystalRAS)&&(objCrystalRAS.value=="RAS")){
				var RASPreviewURL="";
				RASPreviewURL=GetRASURL(frm.action);
				previewurl=RASPreviewURL+"&"+previewpvalue;
			}
			previewurl=previewurl+"&viewer=0"
			//alert(previewurl);
			// Log 52857 - AI - 31-03-2006 : Open the window in MAXIMISED size, regardless of screen resolution.
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			//websys_createWindow(previewurl,"REPORTWINDOW","width=460,height=380,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			websys_createWindow(previewurl,"REPORTWINDOW","top=0,left=0,width="+screen.availWidth+",height="+screen.availHeight+",toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			// end Log 52857
			frm.target="REPORTWINDOW";
			//Print_click(); //KK L:35708 - to override Print_click in the scripts_gen which disables the print button once its clicked.
			//frm.submit();
			return false;
		} else {
			//otherwise do not preview and add print request to the Print History Queue
			frm.target="TRAK_hidden";
			// Log 53547 - AI - 19-08-2005 : Pass the number of copies back to the target frame. This is picked up in websys.csp, see line   <csp:method name=Report arguments="">   and below that.
			var noofcopies=1;
			if ((param)&&(param!="")) {
				var str1=param.split("&noofcopies=");
				if (str1[1]) var str2=str1[1].split("&");
				if (str2[0]) noofcopies=str2[0];
			}
			frm.action="websys.csp?noofcopies="+noofcopies;
			// end Log 53547
			frm.submit();
			// Log 54152 - AI - 22-09-2005 : After submitting, reset the action back to the initial value.
			frm.action=holdaction;
			// end Log 54152
			return false;
		}
		//Submit
		frm.target="TRAK_hidden";
		frm.action="websys.csp";
		frm.submit();
		// Log 54152 - AI - 22-09-2005 : After submitting, reset the action back to the initial value.
		frm.action=holdaction;
		// end Log 54152
		return false;
	    }
  	} else {
	    return false;
  	}
}


// Log 54415 - AI - 18-08-2005 : Clear any IDs for custom fields with no list, if the custom field is blank.
function CheckCustomFields() {
	var i;
	var txtobjname;
	var txtobj;
	var idobjname;
	var idobj;
	var listobjname;
	var listobj;
	;
	for (i=1;i<15;i++) {
		txtobjname="custom"+i;
		txtobj=document.getElementById(txtobjname);
		idobjname=txtobjname+"ID";
		idobj=document.getElementById(idobjname);
		listobjname=txtobjname+"list";
		listobj=document.getElementById(listobjname);
		// IF text object AND id object AND NOT list object AND text object value is blank.
		if ((txtobj)&&(idobj)&&(!listobj)&&(txtobj.value=="")) idobj.value="";
	}
}
// end Log 54415


// Log 46802 - AI - 21-10-2004 : Add logic to clear all enabled fields on the screen.
function ClearClickHandler() {
	// 'frm' set up at the top of this file, as a "global".
	var iNumElems = frm.elements.length;
	for (var i=0; i<iNumElems; i++)	{
		var eElem = frm.elements[i];
		if ((eElem.tagName=="INPUT")&&(eElem.type!="hidden")) {
			eElem.value="";
			if (eElem.type=="checkbox") eElem.checked=false;
		}
		if ((eElem.tagName=="SELECT")&&(eElem.type!="hidden")) {
			for (var j=eElem.length;j>0;j--) {
				eElem.remove(j-1);
			}
		}
	}
}
// end Log 46802

// KK 28/May/2004 L:43422
// Log 51261 - AI - 30-08-2005 : Change to include reportmanagerdsn and configmanagerdsn on the link.
function GetRASURL(actionurl){
	var rname="";
	var raspreviewurl="";
	var returnstring="";
	var viewertype="";
	var pathtoreports="";
	var pathtoscripts="";
	var reportmanagerdsn="";
	var configmanagerdsn="";

	var urltocrystal=document.getElementById('URLToCrystal');
	var objviewertype=document.getElementById('ViewerType');
	if (objviewertype) viewertype=objviewertype.value;
	var objpathtoreports=document.getElementById('PathToReports');
	if (objpathtoreports) pathtoreports=objpathtoreports.value;
	var objpathtoscripts=document.getElementById('PathToScripts');
	if (objpathtoscripts) pathtoscripts=objpathtoscripts.value;
	var objreportmanagerdsn=document.getElementById('reportmanagerdsn');
	if (objreportmanagerdsn) reportmanagerdsn=objreportmanagerdsn.value;
	var objconfigmanagerdsn=document.getElementById('configmanagerdsn');
	if (objconfigmanagerdsn) configmanagerdsn=objconfigmanagerdsn.value;
	var ID=document.getElementById("TREPORT");
	if (ID) ID=ID.value;

	for (var i=actionurl.length;i>=0;i--) {
		rname=mPiece(actionurl,"/",i);
		if (rname!="") {
			//raspreviewurl=actionurl.substring(0,(actionurl.length)-(rname.length));  //../csp/
			// ab 6.11.06 60603 - now done in crystalpreview.csp
			/*
			if ((urltocrystal)&&(urltocrystal.value!="")) {
				raspreviewurl=urltocrystal.value;
				var trasurl=raspreviewurl.substring(raspreviewurl.length-1,raspreviewurl.length);
				if (trasurl!="/") raspreviewurl=raspreviewurl+"/";
			}else{
				raspreviewurl="../csp/";
			}
			*/
			raspreviewurl="../csp/";
			urltocrystal=websys_escape(urltocrystal.value);
			
			//returnstring=raspreviewurl+"crystalpreview.asp?a=a&report="+rname+"&init="+viewertype+"&pathtoreports="+pathtoreports+"&pathtoscripts="+pathtoscripts+"&reportmanagerdsn="+reportmanagerdsn+"&configmanagerdsn="+configmanagerdsn;
			returnstring=raspreviewurl+"crystalpreview.csp?a=a&ID="+ID+"&report="+rname+"&init="+viewertype+"&pathtoreports="+pathtoreports+"&pathtoscripts="+pathtoscripts+"&reportmanagerdsn="+reportmanagerdsn+"&configmanagerdsn="+configmanagerdsn+"&urltocrystal="+urltocrystal;
			//alert(returnstring);
			return returnstring;
		}
	}
	return returnstring;
}

function AssignParameterValue(elementid,promptcnt,obj,frm) {
	//This function is called after the print button is clicked. It assigns the required value to the Crystal
	//parameters (i.e. the promptn variables) in the correct order, i.e. this function ensures that the order of
	//fields on the pages is the order of parameters being passed to Crystal.

	//Custom Textbox Lookups
	if (elementid=="custom1") {
		//If the list is in the form then get the list of ids
		var objList=document.getElementById('custom1list');
		if (objList) {
			var idval = document.getElementById("custom1ID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("custom1","custom1ID");}
	}
	if (elementid=="custom2") {
		//If the list is in the form then get the list of ids
		var objList=document.getElementById('custom2list');
		if (objList) {
			var idval = document.getElementById("custom2ID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("custom2","custom2ID");}
	}
	if (elementid=="custom3") {
		//If the list is in the form then get the list of ids
		var objList=document.getElementById('custom3list');
		if (objList) {
			var idval = document.getElementById("custom3ID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("custom3","custom3ID");}
	}
	if (elementid=="custom11") {
		//If the list is in the form then get the list of ids
		var objList=document.getElementById('custom11list');
		if (objList) {
			var idval = document.getElementById("custom11ID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("custom11","custom11ID");}
	}
	if (elementid=="custom12") {
		//If the list is in the form then get the list of ids
		var objList=document.getElementById('custom12list');
		if (objList) {
			var idval = document.getElementById("custom12ID");
			if (idval) frm.elements["prompt"+promptcnt].value = idval.value;
		} else {frm.elements["prompt"+promptcnt].value = GetIdValue("custom12","custom12ID");}
	}
	if (elementid=="custom4") frm.elements["prompt"+promptcnt].value=GetValue("custom4","custom4ID");
	if (elementid=="custom5") frm.elements["prompt"+promptcnt].value=GetValue("custom5","custom5ID");
	if (elementid=="custom6") frm.elements["prompt"+promptcnt].value=GetValue("custom6","custom6ID");
	if (elementid=="custom7") frm.elements["prompt"+promptcnt].value=GetValue("custom7","custom7ID");
	if (elementid=="custom8") frm.elements["prompt"+promptcnt].value=GetValue("custom8","custom8ID");
	if (elementid=="custom9") frm.elements["prompt"+promptcnt].value=GetValue("custom9","custom9ID");
	if (elementid=="custom10") frm.elements["prompt"+promptcnt].value=GetValue("custom10","custom10ID");

	//Checkboxes
	// convert prompt variables from 'on' to 'Y' for preview
	if (elementid=="checkbox1") frm.elements["prompt"+promptcnt].value=CheckBoxToValue(obj.checked);
	if (elementid=="checkbox2") frm.elements["prompt"+promptcnt].value=CheckBoxToValue(obj.checked);
	if (elementid=="checkbox3") frm.elements["prompt"+promptcnt].value=CheckBoxToValue(obj.checked);
	if (elementid=="checkbox4") frm.elements["prompt"+promptcnt].value=CheckBoxToValue(obj.checked);
	if (elementid=="checkbox5") frm.elements["prompt"+promptcnt].value=CheckBoxToValue(obj.checked);
	if (elementid=="checkbox6") frm.elements["prompt"+promptcnt].value=CheckBoxToValue(obj.checked);
	//If checkbox, change the actual value of the hidden value from 'on' to 'Y' direct reporting
	if (elementid.indexOf("checkbox")==0) {
		frm.elements[elementid].value=CheckBoxToValue(obj.checked);
	}

	//Lookups
	if (elementid=="lookup1") frm.elements["prompt"+promptcnt].value=obj.value;
	if (elementid=="lookup2") frm.elements["prompt"+promptcnt].value=obj.value;
	if (elementid=="lookup3") frm.elements["prompt"+promptcnt].value=obj.value;
	if (elementid=="lookup4") frm.elements["prompt"+promptcnt].value=obj.value;
	if (elementid=="lookup5") frm.elements["prompt"+promptcnt].value=obj.value;
	if (elementid=="lookup6") frm.elements["prompt"+promptcnt].value=obj.value;


	//Dates
	if (elementid=="date1") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="date2") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="date3") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);
	if (elementid=="date4") frm.elements["prompt"+promptcnt].value=DateHtmlToCrystal(obj.value);

	//Times
	if (elementid=="time1") frm.elements["prompt"+promptcnt].value=TimeHtmlToCrystal(obj.value);
	if (elementid=="time2") frm.elements["prompt"+promptcnt].value=TimeHtmlToCrystal(obj.value);
	if (elementid=="time3") frm.elements["prompt"+promptcnt].value=TimeHtmlToCrystal(obj.value);
	if (elementid=="time4") frm.elements["prompt"+promptcnt].value=TimeHtmlToCrystal(obj.value);


	//uncomment the below to debug the parameters being passed to Crystal
	//alert("prompt"+promptcnt+"="+frm.elements["prompt"+promptcnt].value);

	//increment the prompt count so that the next field on the page is assigned to the next Crystal parameter.
	promptcnt++;
	return promptcnt;
}


function BuildIDsfromList(){
	//custom1list
	var objList=document.getElementById('custom1list');
	if (objList) {
		var IDfield='custom1ID';
		var lstfield='custom1list';
		UpdatewithIDs(lstfield,IDfield);
	}
	//custom2list
	var objList=document.getElementById('custom2list');
	if (objList) {
		var IDfield='custom2ID';
		var lstfield='custom2list';
		UpdatewithIDs(lstfield,IDfield);
	}
	//custom3list
	var objList=document.getElementById('custom3list');
	if (objList) {
		var IDfield='custom3ID';
		var lstfield='custom3list';
		UpdatewithIDs(lstfield,IDfield);
	}
	//custom11list
	var objList=document.getElementById('custom11list');
	if (objList) {
		var IDfield='custom11ID';
		var lstfield='custom11list';
		UpdatewithIDs(lstfield,IDfield);
	}
	//custom12list
	var objList=document.getElementById('custom12list');
	if (objList) {
		var IDfield='custom12ID';
		var lstfield='custom12list';
		UpdatewithIDs(lstfield,IDfield);
	}
}

function UpdatewithIDs(lstfield,IDfield) {
	var arrItems = new Array();
	var lst = document.getElementById(lstfield);
	var objPrintPreview=document.getElementById("PrintPreview");
	var objReportType=document.getElementById("ReportType");
	var SlectedIDs="";
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			if ((objPrintPreview)&&(objPrintPreview.value=="1")&&(objReportType)&&(objReportType.value=="Crystal")){
				SlectedIDs=SlectedIDs + ''+ lst.options[j].value + ''+ ',';
			}else{
				SlectedIDs=SlectedIDs + lst.options[j].value + ",";
			}
		}
		SlectedIDs=SlectedIDs.substring(0,(SlectedIDs.length-1));
		var el = document.getElementById(IDfield);
		if (el) el.value = SlectedIDs;
	}
}


function AssignCacheValue(elementid,promptcnt,obj,frm) {
	//Some variables are required to be converted/adjusted when the report type is Cache, Cache+Crystal or Other.

	//If checkbox, change the actual value of the hidden value from 'on' to 'Y' direct reporting
	if (elementid.indexOf("checkbox")==0) {
		frm.elements[elementid].value=CheckBoxToValue(obj.checked);
	}
	//increment the prompt count so that the next field on the page is assigned
	promptcnt++;
	return promptcnt;
}

function DateHtmlToCrystal(datestr) {
	//output Crystal Date format i.e. date(yyyy,mm,dd)
	//KK 15/09/03 L:38879 - If date format is DMMMY set the dtseparator value to a single blank space
	if (dtformat=="DMMMY") dtseparator=" ";
	var dx=datestr.split(dtseparator);
	//invalid date string
	if (dx.length<=1) return '';
	switch (dtformat) {
		case "DMY":
			return 'Date(' + dx[2] + ',' + dx[1] + ',' + dx[0] + ')';
			break;
		case "MDY":
			return 'Date(' + dx[2] + ',' + dx[0] + ',' + dx[1] + ')';
			break;
		case "YMD":
			return 'Date(' + dx[0] + ',' + dx[1] + ',' + dx[2] + ')';
			break;
		case "DMMMY":
			dx[1]=MonthsShortToNum(dx[1]);
			return 'Date(' + dx[2] + ',' + dx[1] + ',' + dx[0] + ')';
			break;
		case "HIJRA":
			var ddx=dx[2].split(" ");
			return 'Date(' + ddx[0] + ',' + dx[1] + ',' + dx[0] + ')';
			break;
	}
	//invalid format
	return '';
}

function TimeHtmlToCrystal(timestr) {
	//output time(HH,MM,SS)
	var dx=timestr.split(tmseparator);
	//invalid time string
	if (dx.length<=1) return '';
	return 'Time(' + dx[0] + ',' + dx[1] + ',00)';
	//invalid format
	return '';
}
function GetValue(descstr,idstr) {
	//Get the value of the hidden ID field that corresponds to the description field.
	//If there is no hidden id value then return the contents of the text box.
	var objdesc=document.getElementById(descstr);
	if ((objdesc) && (objdesc.value!="")){
		var objid;
		objid=document.getElementById(idstr);
		if ((objid) && (objid.value!="")) {
			return objid.value;
		} else {
			return objdesc.value;
		}
	} else {
		var objid1=document.getElementById(idstr);
		if (objid1) objid1.value="";
		return "";
	}
}

function CheckBoxToValue(chkvalue) {
	//return either 'Y' or ''
	if (chkvalue) return 'Y';
	return '';
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}
}

function LookupSelectforList(tfield,lfield,txt) {
	//Add an item to List when an item is selected from
	//the Lookup, then clears the text field.
	var adata=txt.split("^");
	var obj=document.getElementById(lfield);  //Listbox
	if (obj) {
		//Need to check if item already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);  //Textbox with lookup
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert( adata[0] + " has already been selected");
				var obj=document.getElementById(tfield);
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);
	var obj=document.getElementById(tfield);
	if (obj) obj.value="";
}


function GetIdValue(descstr,idstr) {
	//get the value of the hidden ID field that corresponds to the description field
	var objdesc=document.getElementById(descstr);
	if ((objdesc) && (objdesc.value!="")){
		var objid;
		objid=document.getElementById(idstr);
		if (objid) return objid.value;
	} else {
		var objid1=document.getElementById(idstr);
		if (objid1) objid1.value="";
		return "";
	}
}

function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

// Log 53632 - AI - 13-09-2005 : Check that fields aren't clsInvalid before printing or previewing.
//    logic initially done in Log 48398 by YC in W650 webcommon.DateFromTo.Custom.js.
function InvalidCheck() {
	var frm;
	frm=document.getElementById('fwebcommon_Report_Custom');
	if (frm) {
		for (var i=0;i<=frm.elements.tags("INPUT").length+1;i++) {
			if (frm.elements[i]) {
				if (frm.elements[i].type=="text"||(frm.elements[i].type=="checkbox")) {
					if(frm.elements[i].className=="clsInvalid") {
						alert(t[frm.elements[i].id]+": "+t['XINVALID']);
						frm.elements[i].focus();
						return false;
					}
				}
			}
		}
	}
	return true;
}
// end Log 53632


document.body.onload = BodyLoadHandler
