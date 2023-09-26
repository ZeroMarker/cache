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
//if (window.PatientID) glb=glb+"&PatientID="+PatientID
//if (window.PatientID) glb=glb+"&PatientID="+PatientID
//+"&PatientID="+PatientID+"&mradm="+mradm+"&EpisodeID="+EpisodeID+
}

//Log 43415 15/04/04 PeterC: Set the workflow ID so the pop up page can access the ID
// Log 56985 YC - set workflow to orders popup workflow (not epr workflow) in component rather than js.
/*
var WFobj=document.getElementById("WorkFlowID")
if (WFobj) {
	try{
		WFobj.value=eprWorkFlowID;
		//alert("WorkFlowID:"+WFobj.value);
	} catch(e){}
}
*/

// Log 49191 02/02/05 YC: colour rows on OEOrdItem.ListEMR by priority colour
if (EpisodeID==null) {
	var EpisodeID=frm.elements['EpisodeID'].value;
}

colFieldName = "PrioColour";
if(ltbl&&frm&&colFieldName)
	DoRowCol(ltbl, frm, colFieldName);

function DoRowCol(tbl, frm, colFieldName) {
	if (tbl&&frm) {
		var EpisList = EpisodeID;
		// check for multiple episodes?
		var objEpisodeIDs=document.getElementById("EpisodeIDs");
		if (objEpisodeIDs && objEpisodeIDs.value!="") {
			EpisList =objEpisodeIDs.value;
		}
		for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
			var RowHexColour=frm.elements[colFieldName+"z" + curr_row].value;
			// colour..
			if (RowHexColour.value!="") {
				tbl.rows[curr_row].style.backgroundColor=RowHexColour;
			}
			var eSrc=frm.elements['EpisodeIDz'+curr_row];
				if (eSrc) {
					//var obj=getRow(eSrc);
					//var epid=frm.elements['EpisodeIDz'+curr_row].value;
					var epid=eSrc.value;
					// is this in the list of episodes?
					//if (epid!=EpisodeID) {
					//alert("^"+EpisList+"^"+'\n'+"^"+epid+"^"+'\n'+("^"+EpisList+"^").indexOf("^"+epid+"^"));
					if (("^"+EpisList+"^").indexOf("^"+epid+"^")==-1) {
						if ((curr_row%2)==1) {
							//tbl.rows[curr_row].className="EMROtherEpsOdd";
						} else {
							//tbl.rows[curr_row].className="EMROtherEpsEven";
						}
					}
				}
		}
	}
}
// END Log 49191 02/02/05 YC

function OEOrdItemListEMR_DrugAuthHandler() {
	websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdmDrugApproval.list'+glb,'DrugAuthorisation','scrollbar=yes');
}

// Called by Menu System.OEOrdItem.ListEMR.Admin.ChangeStatus
function XPassOrderDetails(lnk,newwin) {
	var tbl=getTableName(window.event.srcElement);
	var ItemSelected=OEOrdItemListEMR_ChangeStatusHandler();
	if (ItemSelected) {
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
		var AryItems=new Array();
		var OEString="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["IDz"+count].value;
			// Log 43116 - AI - 20-04-2004 : Use OrderNameHidden, instead of OrderName. Javascript can't access the
			//				 labels in the same way as the hidden fields, so OEItemName was always blank.
			if (f.elements["OrderNameHiddenz"+count]) {var OEItemName=f.elements["OrderNameHiddenz"+count].value} else {var OEItemName=""};
			var OEItemStatus=f.elements["StatusCodez"+count].value;
			var OEPaid=f.elements["Paidz"+count].value;
			if (OEString=="") {
				OEString=OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2)+OEPaid
			} else {
				OEString=OEString+String.fromCharCode(1)+OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2)+OEPaid
			}
		}
		lnk+= "&OrderString=" + escape(OEString);
		//lnk+= "&OrderString=" + OEString;

		websys_lu(lnk,0,newwin);
	}
}
//Replaced $c(1) with ^ and $c(2) with *
function PassOrderDetails(lnk,newwin) {
	var tbl=getTableName(window.event.srcElement);
	var ItemSelected=OEOrdItemListEMR_ChangeStatusHandler();
	if (ItemSelected) {
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
		var AryItems=new Array();
		var OEString="";
		//log60961 TedT
		newwin+=",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
		var doc=websys_createWindow("","",newwin);
		doc = doc.document;
		doc.open("text/html");
		doc.write("<html><head></head><body>\n");
		doc.writeln('<form name="changestatus" id="changestatus" method="POST" action="oeorder.changestatus.csp">');
		//doc.writeln('<font color="red">Loading...</font>');

		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["IDz"+count].value;
			//if (f.elements["OrderNameHiddenz"+count]) {var OEItemName=f.elements["OrderNameHiddenz"+count].value} else {var OEItemName=""}; log60961 TedT item desc not required
			var OEItemStatus=f.elements["StatusCodez"+count].value;
			var OEPaid=f.elements["Paidz"+count].value;
			OEString=OEItemID+"**"+OEItemStatus+"*"+OEPaid;
			//log60961 TedT
			doc.writeln('<input type="hidden" name="itemz'+(i+1)+'" value="'+OEString+'">');
			/*if (OEString=="") {
				OEString=OEItemID+"*"+OEItemName+"*"+OEItemStatus+"*"+OEPaid;
			} else {
				OEString+="^"+OEItemID+"*"+OEItemName+"*"+OEItemStatus+"*"+OEPaid;
			}*/
		}

		//log60961 TedT
		doc.writeln("</form>");
		doc.writeln("</body></html>");
		doc.close();
		var frm=doc.getElementById('changestatus');
		if (frm) frm.submit();
		/*
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["IDz"+count].value;
			if (f.elements["OrderNameHiddenz"+count]) {var OEItemName=f.elements["OrderNameHiddenz"+count].value} else {var OEItemName=""};
			var OEItemStatus=f.elements["StatusCodez"+count].value;
			var OEPaid=f.elements["Paidz"+count].value;
			if (OEString=="") {
				OEString=OEItemID+"*"+OEItemName+"*"+OEItemStatus+"*"+OEPaid
			} else {
				OEString=OEString+"^"+OEItemID+"*"+OEItemName+"*"+OEItemStatus+"*"+OEPaid
			}
		}
		lnk+= "&OrderString=" + escape(OEString);
		websys_lu(lnk,0,newwin);*/
	}
}

// Called by Menu System.OEOrdItem.ListEMR.Admin.ChangePayorPlanOverride - Log 48727 YC
function PassOrderOverrideDets(lnk,newwin) {
	var ItemSelected=OEOrdItemListEMR_ChangeStatusHandler();
	if (ItemSelected) {
		var eSrc=websys_getSrcElement();
		var tbl=getTableName(eSrc);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
		var AryItems=new Array();
		var OEString="";
		var OEString2="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OverrideRowID=f.elements["OverrideRowIDz"+count].value;
			var OEItemID=f.elements["IDz"+count].value;
			// Log 43116 - AI - 20-04-2004 : Use OrderNameHidden, instead of OrderName. Javascript can't access the
			//				 labels in the same way as the hidden fields, so OEItemName was always blank.
			//if (f.elements["OrderNameHiddenz"+count]) {var OEItemName=f.elements["OrderNameHiddenz"+count].value} else {var OEItemName=""};
			//var OEItemStatus=f.elements["StatusCodez"+count].value;
			//var OEPaid=f.elements["Paidz"+count].value;
			if (OEString=="" && OverrideRowID!="") {
				OEString=OverrideRowID;
				OEString2=OEItemID;
				oneitem = true;
			} else {
				//if(!OEString.match(String.fromCharCode(4))) { //second item
				//	OEString=OEString2+String.fromCharCode(4)+OEString+"^"+OEItemID+String.fromCharCode(4)+OverrideRowID+"^";
				//}
				//else
					OEString=OEString+OEItemID+String.fromCharCode(4)+OverrideRowID+"^";
				oneitem = false;
			}
		}
		//log60223 TedT
		var episode=document.getElementById("EpisodeID");
		if(episode) lnk+="&EpisodeID="+episode.value;

		if(oneitem)
			lnk+= "&ID=" + escape(OEString) + "&OEOrderItemID=" + escape (OEString2);
		else
			lnk+= "&OverrideRowIDs=" + escape(OEString);


		websys_lu(lnk,0,newwin);
	}
}

// Copy of PassOrderDetails
// Called by Menu System.OEOrdItem.ListEMR.Admin.AddDocuments
// Log 43116 - AI - 20-04-2004 : Add PARREF, as this is now used by Menu System.OEOrdItem.ListEMR.Admin.AddDocuments.
function PassOrderAddDocDetails(lnk,newwin) {
	var ItemSelected=OEOrdItemListEMR_ChangeStatusHandler();
	if (ItemSelected) {
		var eSrc=websys_getSrcElement();
		var tbl=getTableName(eSrc);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
		var AryItems=new Array();
		var OEString="";
		var selectionmradm="";
		var multiepisode=false;
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["IDz"+count].value;
			// Log 43116 - AI - 20-04-2004 : Use OrderNameHidden, instead of OrderName. Javascript can't access the
			//				 labels in the same way as the hidden fields, so OEItemName was always blank.
			if (f.elements["OrderNameHiddenz"+count]) {var OEItemName=f.elements["OrderNameHiddenz"+count].value} else {var OEItemName=""};
			//var OEItemStatus=f.elements["StatusCodez"+count].value;
			//var OEPaid=f.elements["Paidz"+count].value;
			if (OEString=="") {
				OEString=OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2); //+OEItemStatus+String.fromCharCode(2)+OEPaid
			} else {
				OEString=OEString+String.fromCharCode(1)+OEItemID+String.fromCharCode(2)+OEItemName; //+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2)+OEPaid
			}
			var currentmradm=f.elements["mradmz"+count].value;
			if (selectionmradm=="") selectionmradm=currentmradm;
			if (currentmradm!=selectionmradm) multiepisode=true;
		}
		lnk+= "&OrderString=" + escape(OEString);

		// Log 43116 - AI - 20-04-2004 : Add PARREF, as this is now used by Menu System.OEOrdItem.ListEMR.Admin.AddDocuments.
		if (multiepisode==true) {
			alert(t['DIFFERENT_EPISODES'])
			return false;
		}
		lnk+= "&PARREF=" + currentmradm;
		// end Log 43116

		websys_lu(lnk,0,newwin);
	}
}

/* function receiveNewStatus(f,newOEItemStatus,newVarReason,UserCode,PIN,goAhead) {
	//websys_closeWindows();  //This line required to close child window and transfer focus to any error messages generated by this function.
	var aryfound=checkedCheckBoxes(document.getElementById(f),document.getElementById("t"+f.substring(1,f.length)),"SelectItemz");
	var AryItems=new Array();
	var newStatus="";
	for (var i=0;i<aryfound.length;i++) {AryItems=checkNewStatus(document.getElementById(f),aryfound[i],newOEItemStatus,AryItems);}
	if (AryItems.length>0) {
		//goAhead=0;
		//if (newOEItemStatus=="D") if (confirm(t['OE_DISCONTINUE'])) goAhead=1;
		//if (newOEItemStatus=="E") if (confirm(t['OE_EXECUTE'])) goAhead=1;
		//if (newOEItemStatus=="H") if (confirm(t['OE_HOLDCONFIRM'])) goAhead=1;
		//if (newOEItemStatus=="V") if (confirm(t['OE_VERIFY'])) goAhead=1;
		if (goAhead==1) {
			newStatus='oechangestatus.csp?OEItemIDs='+AryItems.join(",")+"&newOEItemStatus="+newOEItemStatus+"&newVarReason="+newVarReason+glb+"&UserCode="+UserCode+"&PIN="+PIN;
		}
		//window.treload('websys.csp');
	}
	return newStatus;
}

function checkNewStatus(f,count,newOEItemStatus,AryItems) {
	var OEItemID=f.elements["IDz"+count].value;
	if (f.elements["OrderNamez"+count]) {var OEItemName=f.elements["OrderNamez"+count].value} else {var OEItemName=""};
	var currentOEItemStatus=f.elements["StatusCodez"+count].value;
	var paid=f.elements["Paidz"+count].value;
	var goAhead=true;
	var Allow="";
	var Aobj=document.getElementById("AllowToDiscont");
	if (Aobj) Allow=Aobj.value;
	if (newOEItemStatus=='E') {
		if (currentOEItemStatus=="E") {alert(t['OE_EXECUTED']);goAhead=false;}
		//if (paid!="P") {alert(t['OE_EXECUTEUNPAID']);goAhead=false;}  //TODO: Needed for Indian settings
	}
	//if (newOEItemStatus=='H') if (paid=='P'){if (!confirm(t['OE_HOLDPAID'])) goAhead=false;} //Log 17482 for india
	if (newOEItemStatus=='V') {
		if (currentOEItemStatus=="E") {alert(t['OE_EXECUTED']);goAhead=false;}
		if (currentOEItemStatus=="V") {alert(t['OE_VERIFIED']);goAhead=true;}
	}
	if (newOEItemStatus=='D') {
		if ((currentOEItemStatus=="E") && (Allow!="Y")) {alert(t['OE_NOTALLOWDISC']);goAhead=false}
		//if ((currentOEItemStatus=="E") && (Allow!="Y")) {alert("The system does not allow the user to DISCONTINUE executed order(s).");goAhead=false}
		if (currentOEItemStatus=="D") {alert(t['OE_DISCONTINUED']);goAhead=false;}
		if (paid=='D'){if (!confirm(t['OE_DISCONTINUEPAID'])) goAhead=false;} //Log 17482
	}
	if (newOEItemStatus=='H') {
		if (currentOEItemStatus=="E") {alert(t['OE_NOTALLOWHOLD']);goAhead=false}
		if (currentOEItemStatus=="H") {alert(t['OE_HELD']);goAhead=false;}
	}
	//if (currentOEItemStatus=="E") {
	//	alert(t['OE_NOTALLOWED']); // One common message while tryin to modify Executed Items.
	//	goAhead=false;
	//}
	if (goAhead==true) {AryItems[AryItems.length]=OEItemID; }
	return AryItems;
}
*/

function OEOrdItemListEMR_ChangeStatusHandler(e) {
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

function OEOrdItemListEMR_RepeatHandler(e) {

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

		//Log 43415 15/04/04 PeterC: Set the glb variable and workflow ID
		if (window.opener) {
			glb="";
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
		}
		  //Log 43415 15/04/04 PeterC: Allow repeat order on pop up page
		  /*
		  else if (window.opener) {
			// do NOT allow repeat orders from an epr popup screen
			alert(t['NOREPEATORDERS'])
		  }
		  */
		else {
			var AryOE=new Array();
			var s=String.fromCharCode(4);
			for (var j=0;j<aryfound.length;j++) {
				i=aryfound[j];
				//Must be sent in order (code,desc,subcatcode,ordertype,alias,data,setid,ordcatID,dur,Message,itmMast)
				AryOE[AryOE.length]=f.elements["IDz"+i].value+s+f.elements["OrderNameHiddenz"+i].value+s+f.elements["OrderTypez"+i].value+s+"ARCIM"+s+s+s+s+f.elements["OrderCatz"+i].value+s+f.elements["DefDurIDz"+i].value+s+f.elements["OrderMsgz"+i].value+s+f.elements["OEItemMstIDz"+i].value;
			}
			var repeatorders=escape(AryOE.join(String.fromCharCode(6)));
			// Log 56985 YC - use orders workflow.
		  	if(repWorkFlowID=="") {
		  		repWorkFlowID=eprWorkFlowID;
			  	//Log 61471 PeterC 01/11/06: Now pass repeatorders with tmp global
			  	if(repeatorders!="") var serverupdate=tkMakeServerCall("web.OEOrder","SetRepeatOrderGlb",repeatorders);
				repeatorders="Y";
				var url = 'oeorder.entry.frames.csp?WEBSYS.TCOMPONENT=OEOrder.Custom&RepeatOrders='+repeatorders+glb+ "&TWKFL=" + repWorkFlowID + "&TWKFLI=1";
			}
			else {
				//Log 61471 PeterC 01/11/06: Now pass repeatorders with tmp global
				if(repeatorders!="") var serverupdate=tkMakeServerCall("web.OEOrder","SetRepeatOrderGlb",repeatorders);
				repeatorders="Y";
 				var url = "websys.csp?&TWKFL=" + repWorkFlowID +"&RepeatOrders="+repeatorders+ glb;
			}
                  //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(url,"",'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		}
	}
}

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
                        //Log 59598 - BOC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			var hiddenwin=websys_createWindow("","TRAK_hidden","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			//var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="LabEpisNoHidden,EpisodeID,OEOrdItemID">');
				// for each row selected
				//KK 1/10/03 L:39433 - passing OEOrdItemID as well to the report.
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["LabEpisNoHiddenz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if (!f.elements["IDz"+row]) continue;
					//KK 5/11/03 L:39967 - Check for values in the hidden fields changed from 'and' to 'or'.
					if ((f.elements["EpisodeIDz"+row].value!="")||(f.elements["LabEpisNoHiddenz"+row].value!="")||(f.elements["IDz"+row].value!="")) {
						document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
						document.writeln('<INPUT NAME="LabEpisNoHidden" VALUE="' + f.elements["LabEpisNoHiddenz"+row].value + '">');
						document.writeln('<INPUT NAME="OEOrdItemID" VALUE="' + f.elements["IDz"+row].value + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				// Log 44250 - AI - 26-07-2004 : Some sites are getting stack errors when the Print menu is called after selecting a row.
				//document.close();
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["LabEpisNoHiddenz"+row]) continue;
				if (!f.elements["IDz"+row]) continue;
				//alert(f.elements["EpisodeIDz"+row].value + "," + f.elements["LabEpisNoHiddenz"+row].value + "," + f.elements["IDz"+row].value);
				//KK 5/11/03 L:39967 - Check for values in the hidden fields changed from 'and' to 'or'.
				if ((f.elements["EpisodeIDz"+row].value!="")||(f.elements["LabEpisNoHiddenz"+row].value!="")||(f.elements["IDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["LabEpisNoHiddenz"+row].value,f.elements["IDz"+row].value);
				}
			}
		}
	}
}


// Log 39227 - AI - 26-11-2003 : New function created from PrintSelectedRowsHandler (above) to only send one of each Lab Episode Number selected.
function PrintUniqueLabEpisodeIDRowsHandler(tblname,lnk,newwin) {

	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"SelectItemz");
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		// Log 39227 - AI - 26-11-2003 : declare previous Lab Episode Numbers string.
		var prevLabEpisNos="";
		if (newwin=="TRAK_hidden") {
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			var hiddenwin=websys_createWindow("","TRAK_hidden","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			//var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="LabEpisNoHidden,EpisodeID,OEOrdItemID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["LabEpisNoHiddenz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if (!f.elements["IDz"+row]) continue;
					// Log 39227 - AI - 26-11-2003 : only continue if it is a new (different to all previous) Lab Episode Number.
					var pos=prevLabEpisNos.indexOf("," + f.elements["LabEpisNoHiddenz"+row].value + ",");
					if (pos==-1) {
						if (prevLabEpisNos!="") prevLabEpisNos=(prevLabEpisNos + f.elements["LabEpisNoHiddenz"+row].value + ",");
						if (prevLabEpisNos=="") prevLabEpisNos=("," + f.elements["LabEpisNoHiddenz"+row].value + ",");

						//KK 5/11/03 L:39967 - Check for values in the hidden fields changed from 'and' to 'or'.
						if ((f.elements["EpisodeIDz"+row].value!="")||(f.elements["LabEpisNoHiddenz"+row].value!="")||(f.elements["IDz"+row].value!="")) {
							document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
							document.writeln('<INPUT NAME="LabEpisNoHidden" VALUE="' + f.elements["LabEpisNoHiddenz"+row].value + '">');
							document.writeln('<INPUT NAME="OEOrdItemID" VALUE="' + f.elements["IDz"+row].value + '">');
						}
					}
				}
				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
				// Log 44250 - AI - 26-07-2004 : Some sites are getting stack errors when the Print menu is called after selecting a row.
				document.close();
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["LabEpisNoHiddenz"+row]) continue;
				if (!f.elements["IDz"+row]) continue;
				// Log 39227 - AI - 26-11-2003 : only continue if it is a new (different to all previous) Lab Episode Number.
				var pos=prevLabEpisNos.indexOf("," + f.elements["LabEpisNoHiddenz"+row].value + ",");
				if (pos==-1) {
					if (prevLabEpisNos!="") prevLabEpisNos=(prevLabEpisNos + f.elements["LabEpisNoHiddenz"+row].value + ",");
					if (prevLabEpisNos=="") prevLabEpisNos=("," + f.elements["LabEpisNoHiddenz"+row].value + ",");

					//KK 5/11/03 L:39967 - Check for values in the hidden fields changed from 'and' to 'or'.
					if ((f.elements["EpisodeIDz"+row].value!="")||(f.elements["LabEpisNoHiddenz"+row].value!="")||(f.elements["IDz"+row].value!="")) {
						// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
						PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["LabEpisNoHiddenz"+row].value,f.elements["IDz"+row].value);
					}
				}
			}
		}
	}
}


var mobj=document.getElementById("Modify");
if (mobj) mobj.onclick=alert("click");
// if (self==top) websys_reSize()

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

var objClicked=document.getElementById('Clicked');
if (objClicked.value>=1) {
	  var searchobj=document.getElementById('SearchPref');
	  if(searchobj) {
	  	searchobj.disabled=true;
	  	searchobj.onclick=LinkDisable;
	  }
}

if (EpisodeID==null) {
	var EpisodeID=frm.elements['EpisodeID'].value;
}



function getRow(eSrc) {
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break;eSrc=eSrc.parentElement;}
	return eSrc;
}

function OEOrdItem_ListEMR_SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	//var eSrcAry=eSrc.name.split("z");
	var eSrcAry=eSrc.id.split("z"); //// 65489
	if (eSrcAry[0]=="Delete") {
		var DelOrderID="";
		var OrderIDobj=document.getElementById("IDz"+eSrcAry[1]);
		if (OrderIDobj) DelOrderID=OrderIDobj.value;
		var DelStatus="";
		var Statusobj=document.getElementById("StatusCodez"+eSrcAry[1]);
		if (Statusobj) DelStatus=Statusobj.value;
		// DO NOT CHANGE CONDITION - JD 09/11/07 - 65489
		if ((DelOrderID!="")&&(DelStatus=="I")) {
			var OEOrdItemIDObj=document.getElementById("OEOrdItemIDs");
			var OrdItems="";
			var NewOrdItems="";
			if (OEOrdItemIDObj) OrdItems=OEOrdItemIDObj.value;
			var OrdLen=OrdItems.split("^").length;
			for (var bm78=0;bm78<OrdLen;bm78++) {
				if (mPiece(mPiece(OrdItems,"^",bm78),"*",1)!=DelOrderID) {
					NewOrdItems=NewOrdItems+mPiece(OrdItems,"^",bm78)+"^";
				}
			}
			if (OEOrdItemIDObj) OEOrdItemIDObj.value=NewOrdItems;
			var EpisodeID="";
			var eobj=document.getElementById("EpisodeID");
			if (eobj) EpisodeID=eobj.value;
			var mradm="";
			var mobj=document.getElementById("mradm");
			if (mobj) mradm=mobj.value;
			var PatientID="";
			var pobj=document.getElementById("PatientID");
			if (pobj) PatientID=pobj.value;
			var TWKFL="";
			var objTWKFL=document.getElementById("TWKFL");
			if (objTWKFL) TWKFL=objTWKFL.value;
			var TWKFLI="";
			var objTWKFLI=document.getElementById("TWKFLI");
			if (objTWKFLI) TWKFLI=objTWKFLI.value;
			var CONTEXT="";
			var objCONTEXT=document.getElementById("CONTEXT");
			if (objCONTEXT) CONTEXT=objCONTEXT.value;
			var TRELOADID="";
			var objTRELOADID=document.getElementById("TRELOADID");
			if (objTRELOADID) TRELOADID=objTRELOADID.value;
			if (NewOrdItems=="") NewOrdItems="^";
			var url="oeorder.summaryscreen.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&TRELOADID="+TRELOADID+"&EpisodeID="+EpisodeID+"&OEOrdItemIDs="+NewOrdItems+"&DelOrderID="+DelOrderID+"&mradm="+mradm+"&PatientID="+PatientID+"&CONTEXT="+CONTEXT;
			//websys_createWindow(url,window.name,"");
			window.location.href=url;
		}
		return false;
	}
	// don't return false here at the end of the func or else select boxes won't select.
}

// ab 2.11.05 54067
function UpdateClickHandler() {
	/*
	var alldone=0;

	for (var i=1;!alldone;i++) {
		var frm = document.forms["fOEOrdItem_ListEMR"+i];
		if ((!frm)||(!frm.id)) alldone=1;
		if ((frm)&&(frm.id)) {
			if ((frm)&&(frm.elements['TFRAME'])) frm.elements['TFRAME'].value="TRAK_main";
		}
	}
	return update2_click();
	*/
	// need to do below because if there are multiple OEOrdItm.ListEMR on the same page, cant override the click handlers

	var TWKFL="";
	var objTWKFL=document.getElementById("TWKFL");
	if (objTWKFL) TWKFL=objTWKFL.value;
	var TWKFLI="";
	var objTWKFLI=document.getElementById("TWKFLI");
	if (objTWKFLI) TWKFLI=objTWKFLI.value;
	var EpisodeID="";
	var eobj=document.getElementById("EpisodeID");
	if (eobj) EpisodeID=eobj.value;
	var PatientID="";
	var pobj=document.getElementById("PatientID");
	if (pobj) PatientID=pobj.value;
	var CONTEXT="";
	var objCONTEXT=document.getElementById("CONTEXT");
	if (objCONTEXT) CONTEXT=objCONTEXT.value;
	var TRELOADID="";
	var objTRELOADID=document.getElementById("TRELOADID");
	if (objTRELOADID) TRELOADID=objTRELOADID.value;
	var mradm="";
	var mobj=document.getElementById("mradm");
	if (mobj) mradm=mobj.value;

	var url="websys.csp?TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&TRELOADID="+TRELOADID+"&CONTEXT="+CONTEXT+"&mradm="+mradm;
	websys_createWindow(url,"TRAK_main","");
}

var objAry=document.getElementsByName("update2");
for (var i=0;i<objAry.length;i++) {
	if (objAry[i]) objAry[i].onclick=UpdateClickHandler;
}

// Log 55973 - PC - 19-12-2005 : New functions to Select All rows for use by the 'Reports' menu.
function OEORIDSReportFlagLinkDisable(evt) {
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

//
//This function is no longer in use
//Log 65388
//
function DisableReportFlagLinks() {
	var ary=ltbl.getElementsByTagName("A")
	for (var curr_fld=0; curr_fld<ary.length; curr_fld++) {
		var obj=ary[curr_fld];
		if (obj) {
			if (obj.id.substring(0,18) == "OEORIDSReportFlagz") {
				DisableLink(obj);
			}
		}
	}

	return false;
}

//DisableReportFlagLinks();


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
function OEOrdItemListEMR_PassSelected(lnk,newwin) {
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
			var RowID=f.elements["IDz"+count].value;
			if (RowIDs=="") {
				RowIDs=RowID;
			} else {
				RowIDs=RowIDs+"^"+RowID;
			}
		}

		lnk+= "&RowIDs=" + RowIDs;
	}

	//alert(lnk);
	window.location = lnk;
}

// end Log 55973

