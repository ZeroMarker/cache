// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function DocumentLoadHandler() {
	var objPrescNo=document.getElementById('PrescNo');
	if (objPrescNo) { objPrescNo.onchange=PrescTab; }

	var Action="";
	var objAction=document.getElementById('Action');
	if (objAction) Action = objAction.value;

	var objScanPick=document.getElementById('ScanPick');
	if (objScanPick) { 
		objScanPick.onchange=ScanPickHandler;
		var objUDF=document.getElementById('PICKUDF');
		if ((Action!="Pack")||(objUDF && objUDF.value==0)||(!objUDF)) { objScanPick.disabled=true; }
	}

	DisableEnable("Enquire", Action);
	DisableEnable("Reject", Action);
	DisableEnable("Accept", Action);
	DisableEnable("UndoReject", Action);
	DisableEnable("UndoAccept", Action);
	DisableEnable("Pack", Action);
	DisableEnable("Collect", Action);
	DisableEnable("Check", Action);

	var objSkip=document.getElementById("Skip");
	if (objSkip) {
		objSkip.onclick = SkipClick;
	}

	// remove duplicate data items from rows (like patient details...)
	var Seltbl = document.getElementById("tPharmacy_Presc_Edit");
	if (Seltbl) {
		Seltbl.onclick = TableClick;
	}
	var SelForm = document.getElementById("fPharmacy_Presc_Edit");
	if (Seltbl&&SelForm) {
		var LastPNo = "";
		for (var curr_row=1; curr_row<Seltbl.rows.length; curr_row++) {
			var HIDDENPNo=SelForm.elements["HIDDENpnoz" + curr_row].value;
			var CanChgItem=SelForm.elements["CanChgItemz" + curr_row].value;
			var HasBatches=SelForm.elements["batchidz" + curr_row].value;
			// same as prev row - so blank out details..
			for (var CurrentCell=0; CurrentCell<Seltbl.rows[curr_row].cells.length; CurrentCell++) {
				var cellID = "";
				var NONForm=document.getElementById('NONFormularyz' + curr_row);
				if (NONForm)
	 				NONForm.onclick=BlankClick;

				if (Seltbl.rows[curr_row].cells[CurrentCell].children.length) {
					cellID = Seltbl.rows[curr_row].cells[CurrentCell].children[0].id.split("z");
				}
				if (cellID.length>0) {
					cellID=cellID[0];
					// blank out multiple patient details
					if ((",rego,PAPMIName,PAPMIName2,PAPMIDOB,".indexOf(","+cellID+",")!=-1) && (curr_row>1)){
						Seltbl.rows[curr_row].cells[CurrentCell].innerText = "";
					}
					// blank out multiple presc details
					if ((HIDDENPNo==LastPNo) && (",PrescNumber,".indexOf(","+cellID+",")!=-1)) {
						Seltbl.rows[curr_row].cells[CurrentCell].innerText = "";
					}
					//  log 47645 stock item is a LINK
					if ( (CanChgItem!="1") && (",StockItem,".indexOf(","+cellID+",")!=-1)) {
						var objStock = Seltbl.rows[curr_row].cells[CurrentCell].children[0];
						if (objStock) {
							var objParent = websys_getParentElement(objStock);
							objParent.innerHTML = objStock.innerHTML;

						}
					}

					// if there are batch IDs, we are showing batch details, so don't show as 'Auto-Pick' link....
					if ( (",batchdets,".indexOf(","+cellID+",")!=-1) && ((HasBatches!="") || (Action =='Enquire'))) {
						var objdets = Seltbl.rows[curr_row].cells[CurrentCell].children[0];
						if (objdets) {
							var objParent = websys_getParentElement(objdets);
							objParent.innerHTML = objdets.innerHTML;
						}
					}
					// remove 'modify' link if enquiring
					if ( (",Modify,".indexOf(","+cellID+",")!=-1) && (Action =='Enquire')) {
						var objdets = Seltbl.rows[curr_row].cells[CurrentCell].children[0];
						if (objdets) {
							var objParent = websys_getParentElement(objdets);
							objParent.innerHTML = objdets.innerHTML;
						}
					}

				}
			}
			LastPNo=HIDDENPNo;

		}
	}

}

function PrescTab(){
	return EnquireClick();
}

function BlankClick(){
	return false;
}

//// 59227
function ScanPickHandler(){
	if (document.getElementById('ScanPick').value!="") {
		var pick=tkMakeServerCall("web.PAQue1","ScanPickBroker",document.getElementById('ScanPick').value);
		if (pick!=1) { 
			var msg1="";
			if (pick=="inci") msg1=t['INCICODE'];
			if (pick=="batch") msg1=t['BATCHCODE'];
			if (pick=="incil") msg1=t['INCILERR'];
			if (pick=="incib") msg1=t['INCIBERR'];
			if (pick=="avail") msg1=t['NILAVAIL'];
			if (pick=="exp") msg1=t['BATEXP'];
			if (msg1=="") msg1=t['NOMATCH'];

			alert(t['BARCODEINVALID'] + " " + msg1); 
		}
	 	else { Reload(); }
	}
	return false;
}
function Reload() {
	var objPNo=document.getElementById('PrescNo');
	var objOLDPrescNo=document.getElementById('OLDPrescNo');
	if (objPNo && objOLDPrescNo) {
		if (objPNo.value!="") {
			CallPrescScreen("Pack", objPNo.value, true);
		}
	}
	if (!objPNo && objOLDPrescNo) {
		if (objOLDPrescNo.value!="") {
			CallPrescScreen("Pack", objOLDPrescNo.value, true);
		}
	}

	return false;
}

function CallLink(link, newwin, ByPass) {
	// add presc number and call link...
	var tbl=document.getElementById("tPharmacy_Presc_Edit");
	var f=document.getElementById("fPharmacy_Presc_Edit");
	var aryfound=checkedCheckBoxes(f,tbl,"ActionOKz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
		return false;
	}
	var AryItems=new Array();
	var OEString="";
	var FailedString="";
	for (var i=0;i<aryfound.length;i++) {
		var count=aryfound[i];
		var OEItemID=f.elements["RowIDz"+count].value;
		//var Stat=f.elements["HIDDENOrdStatusz"+count].value;
		// only allow DISCONTINUED ITEMS..
		//if (Stat!="D") {
		// 61288 use pharm stat "J" as guide
		var Stat=f.elements["HIDDENPrescStatz"+count].value;
		if (Stat.indexOf("J")==-1) {
			// list of failed prescriptions
			var prescno=f.elements["HIDDENpnoz"+count].value;
			var drugname=f.elements["HIDDENdrugnamez"+count].value;

			if (FailedString.indexOf(prescno)==-1) {
				if (FailedString!="") FailedString += ", ";
				FailedString += prescno + " ["+drugname+"]";
			}
		} else {
			if (OEString!="") OEString += "^";
			OEString += OEItemID;
		}
	}

	if (OEString=="") {
		alert(t["NONERETURN"]);
		return false;
	} else {
		if (FailedString!="") {
			alert(t["SOMERETURN"]+": "+FailedString);
		}
	}

	link += "&OrderIDs="+OEString;
	var pat=document.getElementById("PatientID");
	if (pat) link += "&PatientID="+pat.value+"&PatientBanner=1";
	link += "&ByPass="+ByPass;
	if (document.getElementById("CONTEXT")) {var CONTEXT=document.getElementById("CONTEXT").value;} else { var CONTEXT="";}
	link += "&CONTEXT="+CONTEXT+ByPass;
	// allow to resize!
	newwin += ',scrollbars=yes,resizable=yes';
	websys_createWindow(link, 'ModifyBatch', newwin );
}

function PassPrescDetailsPart(lnk,newwin) {
	CallLink(lnk, newwin, "N");

}


function PassPrescDetailsPartByPass(lnk,newwin) {
	CallLink(lnk, newwin, "Y");

}


function PassPrescDetails(lnk,newwin) {
	CallLink(lnk, newwin, "");

}

// Log 58361 YC - For the Unpack menu
function Unpack(lnk, newwin) {
	// add presc number and call link...
	var tbl=document.getElementById("tPharmacy_Presc_Edit");
	var f=document.getElementById("fPharmacy_Presc_Edit");
	var aryfound=checkedCheckBoxes(f,tbl,"ActionOKz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
		return false;
	}
	var AryItems=new Array();
	var OEString="";
	var FailedString="";
	for (var i=0;i<aryfound.length;i++) {
		var count=aryfound[i];
		var OEItemID=f.elements["RowIDz"+count].value;
		var Stat=f.elements["HIDDENPrescStatz"+count].value;
		// only allow collected and packed prescriptions
		if ((Stat.indexOf("C")==-1)&&(Stat.indexOf("M")==-1)) {
			// list of failed prescriptions
			var prescno=f.elements["HIDDENpnoz"+count].value;
			var drugname=f.elements["HIDDENdrugnamez"+count].value;

			if (FailedString.indexOf(prescno)==-1) {
				if (FailedString!="") FailedString += ", ";
				FailedString += prescno + " ["+drugname+"]";
			}
		} else {
			if (OEString!="") OEString += "^";
			OEString += OEItemID;
		}
	}

	if (OEString=="") {
		alert(t["NONE_TO_UNPACK"]);
		return false;
	} else {
		if (FailedString!="") {
			alert(t["SOMEUNPACK"]+": "+FailedString);
		}
	}

	lnk += "&OrderIDs="+OEString;
	var pat=document.getElementById("PatientID");
	if (pat) lnk += "&PatientID="+pat.value+"&PatientBanner=1";
	// allow to resize!
	newwin += ',scrollbars=yes,resizable=yes';
	if (document.getElementById("CONTEXT")) {var CONTEXT=document.getElementById("CONTEXT").value;} else { var CONTEXT="";}
	lnk += "&CONTEXT="+CONTEXT+"U";
	websys_createWindow(lnk, 'ModifyBatch', newwin );
}

function TableClick (evt) {
	var tbl = document.getElementById("tPharmacy_Presc_Edit");
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>1) {
		if (eSrcAry[0]=="ActionOK") return true;

		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var Action = "";
		var obj=document.getElementById("Action");
		if (obj) Action = obj.value;
		var CanChgItem=f.elements["CanChgItemz"+eSrcAry[1]].value;
		var CanChgBatch=f.elements["CanChgBatchz"+eSrcAry[1]].value;
		var CONTEXT=f.elements["CONTEXT"].value;
		var PatientID=f.elements["PatientID"].value;
		var AllScripts=f.elements["AllScripts"].value;
		var PatCounter=f.elements["PatCounter"].value;
		
		var feature='top=50,left=50,width=750,height=570,scrollbars=yes,resizable=yes';
		if ((eSrcAry[0]=="Modify") && ((CanChgBatch=="1") )) {
			var batchid=f.elements["batchidz"+eSrcAry[1]].value;
			var batchtaken=f.elements["batchtakenz"+eSrcAry[1]].value;
			var OrdItem=f.elements["RowIDz"+eSrcAry[1]].value;
			var ArcimDR=f.elements["ArcimDRz"+eSrcAry[1]].value;
			// dont just pass in whole quant - 58708
			var quant1=f.elements["HIDDENquanz"+eSrcAry[1]].value;
			var quant2=f.elements["HIDDENqtypackz"+eSrcAry[1]].value;
			var quant=quant1-quant2;
			var ExeIDs=f.elements["OEORIExecz"+eSrcAry[1]].value;
			// 59001
			var BatchPack="";
			var PackObj=f.elements["HIDDENbatchPACKz"+eSrcAry[1]];
			if (PackObj) BatchPack=PackObj.value
			//
			var url = "websys.default.csp?WEBSYS.TCOMPONENT=pharmacy.presc.modifybatch&OrderID="+OrdItem+"&ArcimDR="+ArcimDR+"&Quant="+quant+"&PatientBanner=1&ExeIDs="+ExeIDs+"&HIDDENQtyReq="+quant+"&BatchPack="+BatchPack;
			websys_createWindow(url, 'ModifyBatch', feature );
		}
		if ((CanChgItem=="1") && (eSrcAry[0]=="StockItem")) {
			var OrdItem=f.elements["RowIDz"+eSrcAry[1]].value;
			var inciDesc=f.elements["HIDDENStockItemz"+eSrcAry[1]].value;
			var ArcimDR=f.elements["ArcimDRz"+eSrcAry[1]].value;
			var url = "websys.default.csp?WEBSYS.TCOMPONENT=Pharmacy.StockItem.Edit&ArcimDR="+ArcimDR+"&OrdItem="+OrdItem+"&CurrentItem="+escape(inciDesc)+"&PatientBanner=1";
			websys_createWindow(url, 'ModifyStockItem', feature );
			//will load hidden field to kill ^TMP
			window.parent.frames["PharmacyHidden"].document.location.href="pharmacy.presc.hidden.csp"
		}
		if (eSrcAry[0]=="ordername") {
			var OrdItem=f.elements["RowIDz"+eSrcAry[1]].value;
			var ArcimDesc=f.elements["ArcimDescz"+eSrcAry[1]].value;
			var ArcimDR=f.elements["ArcimDRz"+eSrcAry[1]].value;
			var EpisodeID=f.elements["EpisodeIDz"+eSrcAry[1]].value;
			var mradm=f.elements["MRAdmz"+eSrcAry[1]].value;
			var PrescStat=f.elements["HIDDENPrescStatz"+eSrcAry[1]].value;

			var url = "oeorder.mainloop.csp?&ID="+OrdItem+"&EpisodeID="+EpisodeID+"&OEORIItmMastDR="+ArcimDR+"&PatientID="+PatientID+"&AN=&CONTEXT="+CONTEXT+"&mradm="+mradm+"&SummaryFlag="+"&UpdateFrom=Pharmacy.Presc.Edit";   
			// 60037
			if (PrescStat!="P") url =url + "&Mode=READONLY";
			websys_createWindow(url, 'ModifyStockItem', feature );
		}

		if (eSrcAry[0]=="batchdets") {
			var OrdItem=f.elements["RowIDz"+eSrcAry[1]].value;
			var ArcimDesc=f.elements["ArcimDescz"+eSrcAry[1]].value;
			var ArcimDR=f.elements["ArcimDRz"+eSrcAry[1]].value;
			var EpisodeID=f.elements["EpisodeIDz"+eSrcAry[1]].value;
			var mradm=f.elements["MRAdmz"+eSrcAry[1]].value;
			CallPrescScreen(Action, AllScripts, true, OrdItem)
		}


	}
	return false;
}

function DisableEnable(button, action) {
	var obj=document.getElementById(button);
	if (obj) {
		if (button!=action) {
			obj.onclick = LinkDisable;
			obj.disabled=true;
		} else {
			if (action=="Collect") {
				obj.onclick = CheckCollect;
			}
			if (action=="Accept") {
				obj.onclick = CheckAccept;
			}
			if (action=="Pack") {
				obj.onclick = CheckPack;
			}
			if (action=="Enquire") {
				obj.onclick = EnquireClick;
			}
			if (action=="Check") {
				obj.onclick = CheckCheck;
			}			
		}
	}

}

function CheckAccept(e) {
	if (Check("A")) {
		return Accept_click();
	}
	return false;
}

function CheckPack(e) {
	if (Check("P")) {
		if (document.getElementById('BarcodePack') && document.getElementById('CLOSEWIN') && (document.getElementById('CLOSEWIN').value=="N")) { document.getElementById('BarcodePack').value="1"; }
		return Pack_click();
	}
	return false;

}

function CheckCollect(e) {
	if (Check("C")) {
		return Collect_click();
	}
	return false;
}

function CheckCheck(e) {
	if (Check("K")) {
		return Check_click();
	}
	return false;
}

function Check(Act) {
	// check every order item selected in table
	// check if it has a mandatory override that isn't filled in...
	Altbl=document.getElementById("tPharmacy_Prescription_Alert");
	Alfrm=document.getElementById("fPharmacy_Prescription_Alert");
	var Seltbl = document.getElementById("tPharmacy_Presc_Edit");
	var SelForm = document.getElementById("fPharmacy_Presc_Edit");

	//Log 58765 BoC 07-09-2006: alert if no item selected.
	var aryfound=checkedCheckBoxes(SelForm,Seltbl,"ActionOKz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
		return false;
	}

	if (Seltbl) {
		var BadOrders = "";
		var BadPacks = "";
		for (var seli=1; seli<Seltbl.rows.length; seli++) {
			var SelObj=Seltbl.document.getElementById("ActionOKz"+seli);
			if (SelObj && (SelObj.checked)) {
				var ORDIDObj=SelForm.elements["RowIDz"+seli];
				if (Altbl) {
					for (var i=1; i<Altbl.rows.length; i++) {
						var ChkORDIDObj=Alfrm.elements["RowIdz"+i];
						if (ChkORDIDObj && ORDIDObj && (ChkORDIDObj.value==ORDIDObj.value)) {
							var AAReasObj=Alfrm.elements["HIDDENOVERREASz"+i];
							//var AAReasIDObj=document.getElementById("OVERREASIDz"+i);
							var sevOVRIDEObj=Alfrm.elements["sevOVRIDEz"+i];
							if ((sevOVRIDEObj)&&(sevOVRIDEObj.value=="Y")) {
								if ((AAReasObj)&&(AAReasObj.value=="")) {
									// mandatory override required, but none entered...
									var drugname = SelForm.elements["HIDDENdrugnamez"+seli];
									if (drugname) {
										if (BadOrders!="") BadOrders += ', ';
										BadOrders += drugname.value;
									}
								}
							}
						}
					}
				}
				// check if trying to pack with no batches
				if (Act=="P") {
					//var objBatchID=SelForm.elements["batchidz"+seli];
					var objBatchTaken=SelForm.elements["batchtakenz"+seli];
					var drugname = SelForm.elements["HIDDENdrugnamez"+seli];
					if ((objBatchTaken.value=="") && drugname) {
						if (BadPacks!="") BadPacks += ', ';
						BadPacks += drugname.value;
					}
				}
				// LOG 56965 - Also check if skipping Pack Action and trying to collect.
				if (Act=="C") {
					//var objBatchID=SelForm.elements["batchidz"+seli];
					var objcheckPack=SelForm.elements["checkPackz"+seli];
					var objBatchTaken=SelForm.elements["batchtakenz"+seli];
					var drugname = SelForm.elements["HIDDENdrugnamez"+seli];
					if ((objcheckPack.value=="Y") && (objBatchTaken.value=="") && drugname) {
						if (BadPacks!="") BadPacks += ', ';
						BadPacks += drugname.value;
					}
				}
			}
		}
		var BadString = "";
		if (BadOrders!="") BadString = t['OVERREQUIRED'] + ' ' + BadOrders;
		if (BadPacks!="") {
			if (BadString!="") BadString += '\n';
			BadString += t['NOTPACKED'] + ' ' + BadPacks;
		}
		if (BadString!="") {
			alert(BadString);
			return false;
		}
	}

	// otherwise, build a string of items over-ridden - for update to the db...
	//OEORIID_$c(1)_ReasonID_^_OEORIID2_$c(1)_ReasonID2
	if (Altbl) {
		var tmpstr="";
		for (var i=1; i<Altbl.rows.length; i++) {
			var ChkORDIDObj=Altbl.document.getElementById("RowIDz"+i);
			var AAReasIDObj=Altbl.document.getElementById("OVERREASIDz"+i);
			//alert(i+'\n'+ChkORDIDObj.value+'\n'+AAReasIDObj.value);
			if (ChkORDIDObj && AAReasIDObj && (AAReasIDObj.value!="")) {
				if (tmpstr!="") tmpstr+="^";
				tmpstr+=ChkORDIDObj.value + String.fromCharCode(1) + AAReasIDObj.value;
			}
		}
		var objReasons = document.getElementById("Reasons");
		if (objReasons) objReasons.value = tmpstr;
	}

	return true;

}



function CallPrescScreen(action, scripts, ResetCounter, AutoPickID) {
	var PatBanner= 1;
	var ADMINDateTo = "";
	var ADMINDateFrom  = "";
	var ADMINTimeTo = "";
	var ADMINTimeFrom  = "";
	var obj=document.getElementById('ADMINDateFrom');
	if (obj) ADMINDateFrom=obj.value;
	var obj=document.getElementById('ADMINDateTo');
	if (obj) ADMINDateTo=obj.value;
	var obj=document.getElementById('ADMINTimeFrom');
	if (obj) ADMINTimeFrom=obj.value;
	var obj=document.getElementById('ADMINTimeTo');
	if (obj) ADMINTimeTo=obj.value;
	var CONTEXT=document.getElementById("CONTEXT").value;
	var PatientID=document.getElementById("PatientID").value;
	// either use current patient counter - or subtract 1 if enquiring
	// this is because enquiry or auto-pick we want to loop BACK to the same presc number
	// (pharmacy.presc.edit.csp adds 1 to the counter upon load..)
	var PatCounter=""
	PatCounter = document.getElementById("PatCounter").value;
	if (ResetCounter) PatCounter -= 1;
	// either use all scripts on the page (if looping through many for packing, etc)
	//or use the one sent (if enquiring)
	var AllScripts=document.getElementById("AllScripts").value;
	if (scripts!="") AllScripts = scripts;
	
	// Log 49198 YC - Date and Time when the page loaded
	var DateNow="",TimeNow="";
	var DateNowObj=document.getElementById("DateNow");
	if(DateNowObj) if(typeof(DateNowObj.value)!="undefined") DateNow=DateNowObj.value; 
	var TimeNowObj=document.getElementById("TimeNow");
	if(TimeNowObj) if(typeof(TimeNowObj.value)!="undefined") TimeNow=TimeNowObj.value;

	// DON'T kill the temp packing global if auto-pick - we might want to auto-pick for >1 item
	var KillTemp = 1;
	if (AutoPickID!="") KillTemp = 0;

	// For barcoding screen  59227
	if (document.getElementById('CLOSEWIN')) { var CLOSEWIN=document.getElementById('CLOSEWIN').value; } else { var CLOSEWIN=""; }
	//if (CLOSEWIN=="N") { PatCounter -= 1; }

	var url = "pharmacy.presc.edit.csp?AutoPickID="+AutoPickID+"&KillTemp="+KillTemp+"&PatCounter="+PatCounter+"&Action=" + action + "&PatientBanner=" + PatBanner + "&CONTEXT=" + CONTEXT + "&AllScripts=" + AllScripts+"&ADMINDateTo="+ADMINDateTo+"&ADMINDateFrom="+ADMINDateFrom+"&ADMINTimeTo="+ADMINTimeTo+"&ADMINTimeFrom="+ADMINTimeFrom+"&DateNow="+DateNow+"&TimeNow="+TimeNow+"&CLOSEWIN="+CLOSEWIN;
	window.location.href= url;


}

function SkipClick() {
	// used to check if we've changed the prescription number - if so, refresh the page...
	var objAction=document.getElementById('Action');
	if (objAction) {
		CallPrescScreen(objAction.value, "", "");
	}
	return false;

}

function EnquireClick() {
	// used to check if we've changed the prescription number - if so, refresh the page...
	var objPNo=document.getElementById('PrescNo');
	var objOLDPrescNo=document.getElementById('OLDPrescNo');
	if (objPNo && objOLDPrescNo) {
		if (objPNo.value=="") {
			alert(t['NOPRESC']);
		}
		if (objPNo.value!=objOLDPrescNo.value) {
			if (document.getElementById('Action') && (document.getElementById('Action').value=="Pack")) { var Action="Pack"; } else { var Action="Enquire"; }
			CallPrescScreen(Action, objPNo.value, true);
		}
	}
	return false;

}

function LinkDisable(e) {
	var el = websys_getSrcElement(e);
	if (el.disabled) {
		return false;
	}
	return true;
}

// 63101
function DisableAllAction() {
	var Action="Enquire";
	DisableEnable("Enquire", Action);
	DisableEnable("Reject", Action);
	DisableEnable("Accept", Action);
	DisableEnable("UndoReject", Action);
	DisableEnable("UndoAccept", Action);
	DisableEnable("Pack", Action);
	DisableEnable("Collect", Action);
	return;
}

document.body.onload = DocumentLoadHandler;


