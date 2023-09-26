// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.
  */
var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length;ltbl.name=ltbl.id;ltbl.tCompName=df[df.length-1].id.substring(1,df[df.length-1].id.length);}
var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (mtbl) {mtbl.id=mtbl.id+df.length;mtbl.name=mtbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));


//Procedure for when user has clicks on the 'display EPR for patients previous episode.
//1. We still want all the menubar options to apply to the originally viewed episode.
//TN:11-Sep-02:displaying previous chart does not necessarily mean we are opening a different episode in a new window
if ((window.PrevEpisode==1)&&(window.opener)) {
	var EpisodeID=window.opener.EpisodeID;
}
//2. Must pass the following variables to previous episode window so that menubar options function correctly.
var glb="";
if (window.ChartID) {
	glb="&ChartID="+ChartID+"&PatientID="+PatientID+"&mradm="+mradm+"&EpisodeID="+EpisodeID+"&winName="+window.name;
} else {
 	if (document.getElementById("PatientID")) glb=glb+"&PatientID="+document.getElementById("PatientID")
	if (document.getElementById("EpisodeID")) glb=glb+"&EpisodeID="+document.getElementById("EpisodeID")
	if (document.getElementById("mradm")) glb=glb+"&mradm="+document.getElementById("mradm")
}
/*
colFieldName = "RowColour";
if(ltbl&&frm&&colFieldName)
	DoRowCol(ltbl, frm, colFieldName);

function DoRowCol(tbl, frm, colFieldName)
{
	if (tbl&&frm){
		for (var curr_row=1; curr_row<tbl.rows.length; curr_row++){
			var RowHexColour=frm.elements[colFieldName+"z" + curr_row].value;
			// colour..
			if (RowHexColour.value!=""){
				tbl.rows[curr_row].style.backgroundColor=RowHexColour;
			}
		}
	}
}
*/
function MRMedicationsListEMR_ConvertToOrder() {
	var tbl=getTableName(window.event.srcElement);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.length));
	var aryFound=checkedCheckBoxes(f,tbl,"SelectItemz");
	if(aryFound.length==0){
		alert(t['NOITEMSSELECTED']);
	}else if(aryFound.length>1){
		alert(t['TOMANYSELECTED']);
	}else{
		i=aryFound[0];

		if((f.elements["ARCIMIDz"+i].value=="")||(f.elements["EpisodeIDz"+i].value=="")) {
			alert(t['CONVERT_ERR']);
			return false;
		}
		// ab 13.07.06 - no orders on medication profile anymore
		/*
		if(f.elements["OrderIDz"+i].value!=""){
			alert(t['ORDER_EXIST']);
			return false;
		}
		*/

		var url='oeorder.convert.csp?EpisodeID='+f.elements["EpisodeIDz"+i].value+'&PatientID='+f.elements["PatientIDz"+i].value+'&ARCIMDR='+f.elements["ARCIMIDz"+i].value+'&MRMedicationID='+f.elements["MRMedicationIdz"+i].value;
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
		websys_createWindow(url,"",'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
	}
}  // MRMedicationsListEMR
function MRMedicationsListEMR_ChangeStatus(lnk,newwin) {
	// ab 13.07.06 - no orders on medication profile anymore
	return false;
	var tbl=getTableName(window.event.srcElement);
	var ItemSelected=MRMedictaionsListEMR_ChangeStatusHandler();
	if (ItemSelected) {
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
		var AryItems=new Array();
		var OEString="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["OrderIDz"+count].value;
			if ( OEItemID=="" ) {
				alert(t['ORDERSONLY']);
				return false;
			}
			//if (f.elements["OrderNameHiddenz"+count]) {var OEItemName=f.elements["OrderNameHiddenz"+count].value} else {var OEItemName=""};
			var OEItemStatus=f.elements["StatusCodez"+count].value;
			//var OEPaid=f.elements["Paidz"+count].value;
			if (OEString=="") {
				OEString=OEItemID+"**"+OEItemStatus+"*"
			} else {
				OEString=OEString+"^"+OEItemID+"**"+OEItemStatus+"*"
			}
		}
		lnk+= "&OrderString=" + escape(OEString);
		websys_lu(lnk,0,newwin);
	}
}

function MRMedictaionsListEMR_ChangeStatusHandler(e) {
	var tbl=getTableName(window.event.srcElement);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
	if (aryfound.length==0) alert(t['NOITEMSSELECTED']);
		if (aryfound.length>0) {
			//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.ChangeStatus&formID='+f.id,'Prompt','');
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.ChangeStatus&formID='+f.id,'Prompt','top=0,width=300,height=200,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
			return true;
		}
}

function MRMedicationsListEMR_RepeatHandler(e) {
	// ab 13.07.06 - no orders on medication profile anymore
	return false;

	// Log 53626 - AI - 18-07-2005 : Stop the "Repeat Orders" Menu if OEOrdItemIDs has a value. Indent existing logic to form the ELSE.
	var obj=document.getElementById("OEOrdItemIDs");
	if ((obj)&&(obj.value!="")) {
		alert(t['NOTEPRLIST']);
	}
	else {
		// Log 56985 YC - get workflow id (use default order popup workflow rather than epr workflow)
		var repWorkFlowID="";
		var repWorkFlowObj=document.getElementById("WorkFlowID");
		if(repWorkFlowObj) {
			if(repWorkFlowObj.value) repWorkFlowID=repWorkFlowObj.value;
		}

		if (window.opener) {
			var wobj=window.opener.document.getElementById("WorkFlowID");
			repWorkFlowID=""
			if ((wobj)&&(wobj.value!="")) repWorkFlowID=wobj.value
			if (document.getElementById("PatientIDz1")) glb=glb+"&PatientID="+document.getElementById("PatientIDz1").value
			if (document.getElementById("EpisodeIDz1")) glb=glb+"&EpisodeID="+document.getElementById("EpisodeIDz1").value
			if (document.getElementById("mradmz1")) glb=glb+"&mradm="+document.getElementById("mradmz1").value
		}


		var tbl=getTableName(window.event.srcElement);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");


		if (aryfound.length==0) {
			alert(t['NOITEMSSELECTED']);
		}	else {
			var AryOE=new Array();
			var s=String.fromCharCode(4);
			for (var j=0;j<aryfound.length;j++) {
				i=aryfound[j];
				//Must be sent in order (code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,Message,itmMast)
				var orderid=f.elements["OrderIDz"+i].value;
				if ( orderid=="" ) {
					alert(t['ORDERSONLY']);
					return false;
				}else{
					AryOE[AryOE.length]=orderid+s+""+s+""+s+""+s+"ARCIM"+s+""+s+""+s+""+s+""+s+""+s+f.elements["ARCIMIDz"+i].value;
				}
				//+f.elements["OrderNameHiddenz"+i].value+s+f.elements["OrderTypez"+i].value+s+"ARCIM"+s+s+s+s+f.elements["OrderCatz"+i].value+s+f.elements["DefDurIDz"+i].value+s+f.elements["OrderMsgz"+i].value+s+f.elements["OEItemMstIDz"+i].value;
			}
			var repeatorders=escape(AryOE.join(String.fromCharCode(6)));
			// Log 56985 YC - use orders workflow.
		  if(repWorkFlowID=="") {
			  repWorkFlowID=eprWorkFlowID;
				//alert(glb);
				var url = 'oeorder.entry.frames.csp?WEBSYS.TCOMPONENT=OEOrder.Custom&RepeatOrders='+repeatorders+glb+"&TWKFL=" + repWorkFlowID + "&TWKFLI=1";
			} else{
				var url = "websys.csp?&TWKFL=" + repWorkFlowID +"&RepeatOrders="+repeatorders+ glb;
			}
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"",'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
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


function getRow(eSrc) {
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break;eSrc=eSrc.parentElement;}
	return eSrc;
}



// Log 55973 - PC - 19-12-2005 : New functions to Select All rows for use by the 'Reports' menu.
function MRMedDSReportFlagLinkDisable(evt) {
	return false;
}

function DisableLink(fld) {
	if (fld) {
		fld.value = "";
		fld.disabled = true;
		fld.onclick=OEORIDSReportFlagLinkDisable
		fld.className = "disabledLink";
	}
}

function DisableReportFlagLinks() {
	var ary=ltbl.getElementsByTagName("A")
	for (var curr_fld=0; curr_fld<ary.length; curr_fld++) {
		var obj=ary[curr_fld];
		if (obj) {
			if (obj.id.substring(0,18) == "MRMedDSReportFlagz") {
				DisableLink(obj);
			}
		}
	}

	return false;
}

DisableReportFlagLinks();


var objSelectAll = frm.elements["SelectAll"];
if (objSelectAll) objSelectAll.onclick=SelectAllClickHandler;


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
// Function called from the Component Menus.
function  MRMedicationsListEMR_PassSelected(lnk,newwin) {

	var f,aryfound;
	var tbl=getTableName(window.event.srcElement);

	if (tbl) f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	if (f) aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");

	if (aryfound.length==0) {
		alert(t['NONE_SELECTED']);
		return;
	} else {
		var AryItems=new Array();
		var RowIDs="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var RowID=f.elements["MRMedicationIdz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}
		lnk+= "&RowIDs=" + RowIDs;
	}
	window.location = lnk;
}

// end Log 55973

