// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/
var df=document.forms;

// Log 51189 - AI - 22-03-2005 : Get the following definitions right again.
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length;ltbl.name=ltbl.id;ltbl.tCompName=df[df.length-1].id.substring(1,df[df.length-1].id.length);}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));

if (false && ltbl) {
	for (var row=0;row<=ltbl.rows.length;row++) {
		var summ=document.getElementById('PADSSummDescz'+row);
		var loc=document.getElementById('PADSLocationDescz'+row);
		var epistyp=document.getElementById('PADSEpisodeTypez'+row);
		if ((summ)&&(loc)&&(epistyp)) {
			switch (epistyp.value) {
				case 'O': var epTyp="Outpatients"; break;
				case 'I': var epTyp="Inpatients"; break;
				default : var epTyp="Emergency";
			}
			summ.innerHTML=loc.value+" "+epTyp+" D/C Summary";
		}
	}
}

function tk_DisableRowLink(tablename,linkcolumnname,criteriafield,criteriaexpr) {
	var tbl=document.getElementById(tablename);

	if (!tbl) return;
	//if no rows or the details column is not displaying, don't have to do anything
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
// Log 54164 - AI - 19-07-2005 : Use ltbl.id instead of .name or .Name, in case either is not defined.
//    NOTE: .Name property DOES exist and is the same value, but it is better to use id.
tk_DisableRowLink(ltbl.id,"PADSDocType","HasResult","N");

function PrintSelectedDischSumm(lnk, newwin) {
	//var tbl=getTableName(window.event.srcElement);
	var f=frm;  //document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,ltbl,"Selectz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else if (aryfound.length>1) {
		alert(t['TOOMANYSELECTED']);
	} else {
		var count=aryfound[0];
		if (f.elements["Statusz"+count].value!="A") {
			alert(t['NOTAUTHORISED']);
			return false;
		}
		lnk+= "&Reprint=1&ID=" + f.elements["ReqIDz"+count].value;
		websys_lu(lnk,0,newwin);
	}
}

function SelectRowHandler(evt) {
	//window.open("//bilby/Developers/medtrak/m6.21/Results/20040324/14664.rtf", 'DischargeSummary', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	// Log 60658 - AI - 08-09-2006 : Re-define the form to use the Source Element's table name.
	// NOTE: var f=frm will NOT work where another .List component exists on the Chart (eg. EPR Chart).
	//   'frm' is defined first at the top of this file, but may well be overwritten as stated above.
	//var f=frm;
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>1) {
		var NewWorkFlow=document.getElementById("NewWorkFlow");
		if (NewWorkFlow) { NewWorkFlow = NewWorkFlow.value;}
		var PatientID=document.getElementById("PatientID");
		if (PatientID) { PatientID = PatientID.value;}
		var CONTEXT=document.getElementById("CONTEXT");
		if (CONTEXT) { CONTEXT = CONTEXT.value;}
		var DocType=escape(f.elements["doctypez"+eSrcAry[1]].value);
		var CurrID=f.elements["IDz"+eSrcAry[1]].value;
		var tp = 0;  //window.screen.height-window.screen.availHeight;
		var lft = 0;  //window.screen.Width-window.screen.availWidth;
		var wid = screen.availWidth-(0.1*screen.availWidth);
		var hght = screen.availHeight-(0.1*screen.availHeight);
		var feature='top='+tp+',left='+lft+',width='+wid+',height='+hght + ',scrollbars=yes,resizable=yes';
		if (eSrcAry[0]=="PADSDocType") {
			// if authorised - just show the document - else go to the chart.
			var DocName=f.elements["DocNamez"+eSrcAry[1]].value;
			var Status=f.elements["Statusz"+eSrcAry[1]].value;
			//alert("top: " + tp + '\nLeft: ' +lft + '\nwid:' + wid + '\nheight: ' + hght);
			websys_createWindow(DocName, 'DischargeSummary', feature );
			//alert(DocName);
			return false;
		}
		// allow episode number to pass the click - it should carry on with the paadm.edit lookup...
		if (eSrcAry[0]=="PADSEpisNo") {
			return false;
		}
		// new version
		if (eSrcAry[0]=="CanDoNew") {
			var url = "websys.csp?TWKFL=" + NewWorkFlow + "&PatientID=" + PatientID + "&DischID=&CurrDischID=" + CurrID + "&doctype=" + DocType + "&CONTEXT=" + CONTEXT + "&PatientBanner=1";
			websys_createWindow(url, 'DischargeSummary', feature);
			return false;
		}
	}
}


function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}


function NewClick(evt) {
	var patid=document.getElementById("PatientID");
	var workflowid=document.getElementById("NewWorkFlow");
	if (patid && workflowid) {
		var url = "websys.csp?TWKFL=" + workflowid.value + "&PatientID=" + patid.value;
		websys_createWindow(url, 'NewDischargeSummary', 'top=0,left=0,width='+(screen.availWidth-(0.1*screen.availWidth))+',height='+(screen.availHeight-(0.1*screen.availHeight))+',scrollbars=yes,resizable=yes');

	}
	return false;
}


var objNew=document.getElementById("New")
if (objNew) {
	objNew.onclick = NewClick;
}

var objSummDocTypes=document.getElementById("SummDocTypes");
// 'SummDocTypes' is a variable populated by paadm.discharge.list.csp
if (objNew && (objSummDocTypes) && (objSummDocTypes.value=="")) {
	objNew.onclick = LinkDisable;
	objNew.disabled = true;
}


// Log 57664 - AI - 03-03-2005 : Delete DS.
function DelClick(evt) {
	if (frm) aryfound=checkedCheckBoxes(frm,ltbl,"Selectz");
	if (aryfound.length==0) {
		// NOITEMSSELECTED already exists for "Print DS" menu logic.
		alert(t['NOITEMSSELECTED']);
		return false;
	}
	var ret=true;
	ret=confirm(t['AreYouSureDeleteDS']+"\n"+t['OK_CANCEL']);
	if (ret==false) {
		return false;
	} else {
		var RowIDs="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var RowID=frm.elements["IDz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}
	}
	var obj=document.getElementById("SelectedIDs");
	if (obj) obj.value=RowIDs;
	return DeleteDS_click();
}

var objDel=document.getElementById("DeleteDS")
if (objDel) {
	objDel.onclick = DelClick;
}
// end Log 57664


if (ltbl) ltbl.onclick=SelectRowHandler;

//websys_lu('websys.print.auto.csp?PrintedExpression=DSUM999PC&RF=1&ReportCode=SHOWPARAMS&prompt0=phil&prompt1=DS&prompt2=12345&prompt3=&prompt4=&prompt5=&prompt6=&prompt7=&prompt8=',false,'')
