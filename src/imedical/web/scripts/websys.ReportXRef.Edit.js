// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//KK 22/Oct/2002 Log 28993

function DocumentLoadHandler() {
	var print=document.getElementById('print');
	if (print) print.onclick=Print_clickhandler;
}

function Print_clickhandler(evt) {
	// pre-Submit validation
	if (fwebsys_ReportXRef_Edit_submit()) {
	    var frm;
	    var LinkUrl;
	    frm=document.getElementById('fwebsys_ReportXRef_Edit');
	    if (frm) {
		//KK 05/Mar/2003 Log-28993 - For Cache,Cache+Crystal and Other Reports
		if ((frm.elements["ReportType"].value=="Cache+Crystal")||(frm.elements["ReportType"].value=="Cache")||(frm.elements["ReportType"].value=="Other")) {
			var pvalue="";
			for (var i=0;i<frm.elements.length;i++) 	{
				if (frm.elements.tags("INPUT")) {
					if ((frm.elements[i].type=="text")||(frm.elements[i].type=="checkbox")) {
						elementid=frm.elements[i].id;
						obj=document.getElementById(elementid);
						pvalue+=AssignCacheParameterValue(elementid,obj,frm);
					}
				}
			}
			var objReportCode=document.getElementById("ReportCode");
			if (objReportCode) ReportCode=objReportCode.value;
			var myurl="websys.print.auto.csp?RF=1&ReportCode="+ReportCode+pvalue;
			//alert(myurl);
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(myurl,"TRAK_hidden","width=460,height=380,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
		}
		if ((frm.elements["ReportType"].value=="Crystal")||(frm.elements["ReportType"].value=="Word")) {
			var promptcnt=0;
			var obj;
			var elementid;
			//loop thru each text box on the page and assign the selected value to crystal parameters
			for (var i=0;i<frm.elements.length;i++) 	{
				if (frm.elements.tags("INPUT")) {
					if ((frm.elements[i].type=="text")||(frm.elements[i].type=="checkbox")) {
						elementid=frm.elements[i].id;
						//alert(elementid);
						obj=document.getElementById(elementid);
						promptcnt=AssignParameterValue(elementid,promptcnt,obj,frm);
					}
					//as the maximum number of parameters that can be passed to crystal is 8, exit the loop
					//when the count is 8. (remembering that the count starts at 0)
					if (promptcnt==8) break;
				}
			}
			//log 25298 - if the PrintPreview flag is set on the menu then preview report in Viewer
			if (frm.elements["PrintPreview"].value=="1") {
				//Create a new window
				LinkUrl=BuildLinkUrl();
				// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow(LinkUrl,"REPORTWINDOW","width=460,height=380,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//To the submit target to the new window
				frm.target="REPORTWINDOW"
			} else {
				//otherwise do not preview and add print request to the Print History Queue
	        		frm.action="websys.csp"
			}
		  }
	    }
	    //Submit
	    //print_click()
	} else {
	    return false;
	}
}

function AssignParameterValue(elementid,promptcnt,obj,frm) {
	//this function is called after the print button is clicked. it assigns the required value to the Crystal
	//parameter in the correct order, ie this function ensures that the order of fields on the pages is the order
	//of parameters being passed to Crystal.
	if (elementid=="Report") frm.elements["prompt"+promptcnt].value = obj.value;
	if (elementid=="Module1") frm.elements["prompt"+promptcnt].value = GetIdValue("Module1","Module1ID");
	if (elementid=="Location") frm.elements["prompt"+promptcnt].value = GetIdValue("Location","LocationID");
	if (elementid=="Location2") frm.elements["prompt"+promptcnt].value = GetIdValue("Location2","Location2ID");
	if (elementid=="Trust") frm.elements["prompt"+promptcnt].value = GetIdValue("Trust","TrustID");
	if (elementid=="Hospital") frm.elements["prompt"+promptcnt].value = GetIdValue("Hospital","HospitalID");
	if (elementid=="CareProvider") frm.elements["prompt"+promptcnt].value = GetIdValue("CareProvider","CareProviderID");
	if (elementid=="IntendedManagement") frm.elements["prompt"+promptcnt].value = GetIdValue("IntendedManagement","IntendedManagementID");
	if (elementid=="OrderItem") frm.elements["prompt"+promptcnt].value = GetIdValue("OrderItem","OrderItemID");
	if (elementid=="LetterType") frm.elements["prompt"+promptcnt].value = GetIdValue("LetterType","LetterTypeID");
	if (elementid=="ReportRef") frm.elements["prompt"+promptcnt].value = GetIdValue("ReportRef","ReportRefID");
	if (elementid=="ItemCategory") frm.elements["prompt"+promptcnt].value = GetIdValue("ItemCategory","ItemCategoryID");
	// Log 54141 YC - Adding 6 new fields
	if (elementid=="ApptCancelInitiator") frm.elements["prompt"+promptcnt].value = GetIdValue("ApptCancelInitiator","ApptCancelInitiatorID");
	if (elementid=="ApptStatus") frm.elements["prompt"+promptcnt].value = GetIdValue("ApptStatus","ApptStatusID");
	if (elementid=="Interpreter") frm.elements["prompt"+promptcnt].value = GetIdValue("Interpreter","InterpreterID");
	if (elementid=="RefStatus") frm.elements["prompt"+promptcnt].value = GetIdValue("RefStatus","RefStatusID");
	if (elementid=="RefStatusReason") frm.elements["prompt"+promptcnt].value = GetIdValue("RefStatusReason","RefStatusReasonID");
	if (elementid=="Transport") frm.elements["prompt"+promptcnt].value = GetIdValue("Transport","TransportID");
	// Log 53055 YC - Add Reason for Removal
	if (elementid=="ReasonForRemoval") frm.elements["prompt"+promptcnt].value = GetIdValue("ReasonForRemoval","ReasonForRemovalID");
	// Log 39853 - AI - 22-11-2005 : Add 2 new fields : Active Date From and Active Date To.
	if (elementid=="ActiveDateFrom") frm.elements["prompt"+promptcnt].value = GetIdValue("ActiveDateFrom","ActiveDateFrom");
	if (elementid=="ActiveDateTo") frm.elements["prompt"+promptcnt].value = GetIdValue("ActiveDateTo","ActiveDateTo");

	//uncomment the below to debug the parameters being passed to Crystal
	//alert(frm.elements["prompt"+promptcnt].value)

	//increment the prompt count so that the next field on the page is assigned to the next Crystal parameter.
	promptcnt++;
	return promptcnt;
}

function AssignCacheParameterValue(elementid,obj,frm) {
	//KK
	//this function is called after the print button is clicked. it assigns the required value to the Cache
	//parameter in the correct order, ie this function ensures that the correct fiels are passed with the field names and values.

	var prompt="";
	if (elementid=="Report") prompt="&" + elementid + "=" + obj.value;
	if (elementid=="Module1") prompt="&" + elementid + "ID=" + GetIdValue("Module1","Module1ID");
	if (elementid=="Location") prompt="&" + elementid + "ID=" + GetIdValue("Location","LocationID");
	if (elementid=="Location2") prompt="&" + elementid + "ID=" + GetIdValue("Location2","Location2ID");
	if (elementid=="Trust") prompt="&" + elementid + "ID=" + GetIdValue("Trust","TrustID");
	if (elementid=="Hospital") prompt="&" + elementid + "ID=" + GetIdValue("Hospital","HospitalID");
	if (elementid=="CareProvider") prompt="&" + elementid + "ID=" + GetIdValue("CareProvider","CareProviderID");
	if (elementid=="IntendedManagement") prompt="&" + elementid + "ID=" + GetIdValue("IntendedManagement","IntendedManagementID");
	if (elementid=="OrderItem") prompt="&" + elementid + "ID=" + GetIdValue("OrderItem","OrderItemID");
	if (elementid=="LetterType") prompt="&" + elementid + "ID=" + GetIdValue("LetterType","LetterTypeID");
	if (elementid=="ReportRef") prompt="&" + elementid + "ID=" + GetIdValue("ReportRef","ReportRefID");
	if (elementid=="ItemCategory") prompt="&" + elementid + "ID=" + GetIdValue("ItemCategory","ItemCategoryID");
	// Log 54141 YC - Adding 6 new fields
	if (elementid=="ApptCancelInitiator") prompt="&" + elementid + "ID=" + GetIdValue("ApptCancelInitiator","ApptCancelInitiatorID");
	if (elementid=="ApptStatus") prompt="&" + elementid + "ID=" + GetIdValue("ApptStatus","ApptStatusID");
	if (elementid=="Interpreter") prompt="&" + elementid + "ID=" + GetIdValue("Interpreter","InterpreterID");
	if (elementid=="RefStatus") prompt="&" + elementid + "ID=" + GetIdValue("RefStatus","RefStatusID");
	if (elementid=="RefStatusReason") prompt="&" + elementid + "ID=" + GetIdValue("RefStatusReason","RefStatusReasonID");
	if (elementid=="Transport") prompt="&" + elementid + "ID=" + GetIdValue("Transport","TransportID");
	// Log 53055 YC - Add Reason for Removal
	if (elementid=="ReasonForRemoval") prompt="&" + elementid + "ID=" + GetIdValue("ReasonForRemoval","ReasonForRemovalID");
	// Log 39853 - AI - 22-11-2005 : Add 2 new fields : Active Date From and Active Date To.
	if (elementid=="ActiveDateFrom") prompt="&" + elementid + "ID=" + GetIdValue("ActiveDateFrom","ActiveDateFrom");
	if (elementid=="ActiveDateTo") prompt="&" + elementid + "ID=" + GetIdValue("ActiveDateTo","ActiveDateTo");

	//alert(prompt);
	return prompt;
}


function GetIdValue(descstr,idstr) {
	//get the value of the hidden ID field that corresponds to the description field
	var objdesc=document.getElementById(descstr);
	if ((objdesc) && (objdesc.value!="")){
		var objid;
		objid=document.getElementById(idstr);
		if (objid) return objid.value;
	} else {
		return "";
	}
}

function ReportLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("ReportCode");
	if ((obj) && (lu[1])) obj.value=lu[1];
	var obj=document.getElementById('Report');
	if ((obj) && (lu[2])) obj.value=lu[2];
	var obj=document.getElementById('ReportID');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('ReportUrl');
	if ((obj) && (lu[3])) obj.value=lu[3];
	var obj=document.getElementById('ReportType');
	if ((obj) && (lu[4])) obj.value=lu[4];

}

function Module1LookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Module1');
	if ((obj) && (lu[0])) obj.value=lu[0];
	var obj=document.getElementById('Module1ID');
	if ((obj) && (lu[2])) obj.value=lu[2];
}

function LocationLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Location");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("LocationID");
	if (obj) obj.value=lu[1];
}
function Location2LookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Location2");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("Location2ID");
	if (obj) obj.value=lu[1];
}

function TrustLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("Trust");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("TrustID");
	if (obj) obj.value=lu[1];
}

function HospitalLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Hospital');
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('HospitalID');
	if (obj) obj.value=lu[1];
}

function CareProviderLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("CareProvider");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("CareProviderID");
	if (obj) obj.value=lu[1];
}

function IntendedManagementLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("IntendedManagement");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("IntendedManagementID");
	if (obj) obj.value=lu[1];
}

function OrderItemLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("OrderItem");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("OrderItemID");
	if (obj) obj.value=lu[1];
}

function LetterTypeLookUpSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("LetterType");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("LetterTypeID");
	if (obj) obj.value=lu[2];
}

function ReportRefLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("ReportRef");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("ReportRefID");
	if (obj) obj.value=lu[1];
}

//KK 23/Apr/2003 Log 34592
function ItemCategoryLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("ItemCategory");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("ItemCategoryID");
	if (obj) obj.value=lu[1];
}

// Log 54141 YC - Adding 6 new fields
function ApptCancelInitiatorLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("ApptCancelInitiator");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("ApptCancelInitiatorID");
	if (obj) obj.value=lu[1];
}

// Log 54141 YC - Adding 6 new fields
function ApptStatusLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("ApptStatus");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("ApptStatusID");
	if (obj) obj.value=lu[1];
}

// Log 54141 YC - Adding 6 new fields
function InterpreterLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("Interpreter");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("InterpreterID");
	if (obj) obj.value=lu[1];
}

// Log 54141 YC - Adding 6 new fields
function RefStatusLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("RefStatus");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("RefStatusID");
	if (obj) obj.value=lu[1];
}

// Log 54141 YC - Adding 6 new fields
function TransportLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("Transport");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("TransportID");
	if (obj) obj.value=lu[1];
}

// Log 54141 YC - Adding 6 new fields
function TransportLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("Transport");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("TransportID");
	if (obj) obj.value=lu[1];
}


// Log 53055 YC - Adding Reason For Removal
function ReasonForRemovalLookUpSelect(str) {
	//alert(str);
	var lu = str.split("^");
	var obj=document.getElementById("ReasonForRemoval");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("ReasonForRemovalID");
	if (obj) obj.value=lu[1];
}

function BuildLinkUrl(){
	var lnkurl="";
	var site;
	var rpt;
	var p0=""; var p1=""; var p2=""; var p3=""; var p4=""; var p5=""; var p6=""; var p7=""; var p8="";
	var mystr="";
	var obj=document.getElementById('SITECODE');
	if (obj) site=obj.value;
	var obj=document.getElementById('ReportUrl');
	if (obj) rpt=obj.value;
	var obj=document.getElementById('SITECODE');
	if (obj) site=obj.value;
	var obj=document.getElementById("prompt0");
	if ((obj) && (obj.value)) p0=obj.value;
	var obj=document.getElementById("prompt1");
	if ((obj) && (obj.value)) p1=obj.value;
	var obj=document.getElementById("prompt2");
	if ((obj) && (obj.value)) p2=obj.value;
	var obj=document.getElementById("prompt3");
	if ((obj) && (obj.value)) p3=obj.value;
	var obj=document.getElementById("prompt4");
	if ((obj) && (obj.value)) p4=obj.value;
	var obj=document.getElementById("prompt5");
	if ((obj) && (obj.value)) p5=obj.value;
	var obj=document.getElementById("prompt6");
	if ((obj) && (obj.value)) p6=obj.value;
	var obj=document.getElementById("prompt7");
	if ((obj) && (obj.value)) p7=obj.value;
	var obj=document.getElementById("prompt8");
	if ((obj) && (obj.value)) p8=obj.value;
	mystr="&prompt0="+p0+"&prompt1="+p1+"&prompt2="+p2+"&prompt3="+p3+"&prompt4="+p4+"&prompt5="+p5+"&prompt6="+p6+"&prompt7="+p7+"&prompt8="+p8;
	lnkurl="../custom/"+site+"/reports/"+rpt+"?RF=1"+mystr;
	//alert(lnkurl);
	return lnkurl;
}

document.body.onload = DocumentLoadHandler;

