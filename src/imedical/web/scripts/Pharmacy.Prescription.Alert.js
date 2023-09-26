// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/
var df=document.forms;
Altbl=document.getElementById("tPharmacy_Prescription_Alert");
Alfrm=document.getElementById("fPharmacy_Prescription_Alert");

function DoColour() {
	var Curr_PNo = "";
	var Curr_RowID = "";
	for (var curr_row=1; curr_row<Altbl.rows.length; curr_row++) {
		var RowHexColour=Alfrm.elements["sevCOLz" + curr_row].value;
		var HIDDEN_PNo=Alfrm.elements["HIDDENpnoz" + curr_row].value;
		var HIDDEN_RowID=Alfrm.elements["RowIdz" + curr_row].value;
		var HIDDEN_InteractARCIMID=Alfrm.elements["interactArcimDRz" + curr_row].value;
		var HIDDEN_MonoGraph=Alfrm.elements["MonoGraphz" + curr_row].value;
		if (RowHexColour.value!="") {
			//Log 57298 PeterC 16/10/06
			RowHexColour=RowHexColour.replace("#","");
			Altbl.rows[curr_row].style.backgroundColor=RowHexColour;
		}
		for (var CurrentCell=0; CurrentCell<Altbl.rows[curr_row].cells.length; CurrentCell++) {
			// same as prev row - so blank out details..
			var cellID = Altbl.rows[curr_row].cells[CurrentCell].children[0].id.split("z");
			if (cellID.length>0) {
				cellID=cellID[0];
				// blank out pat details from 2nd row onwards
				if ((",rego,PAPMIName,PAPMIName2,PAPMIDOB,".indexOf(","+cellID+",")!=-1) && (curr_row>1)) {
					Altbl.rows[curr_row].cells[CurrentCell].innerText = "";
				}
				// blank out multiple presc details
				if ((HIDDEN_PNo==Curr_PNo) && (",pno,".indexOf(","+cellID+",")!=-1)) {
					Altbl.rows[curr_row].cells[CurrentCell].innerText = "";
				}
				// blank out multiple order item details..
				if ((HIDDEN_RowID==Curr_RowID) && (",drugname,ordname,Select,".indexOf(","+cellID+",")!=-1)) {
					Altbl.rows[curr_row].cells[CurrentCell].innerText = "";
				}
				// if NO monograph- remove the link from 'category' field
				if (",typ,".indexOf(","+cellID+",")!=-1) {
					var objCategory = Altbl.rows[curr_row].cells[CurrentCell].children[0];
					if (objCategory) {
						if (HIDDEN_MonoGraph=="" ) {
							var objParent = websys_getParentElement(objCategory);
							objParent.innerHTML = objCategory.innerHTML;	
						} else {
							objCategory.onclick = InteractionClick;
						}
					}	
				}
				// if NO interacting rowID- remove the link from 'desc' field
				if (",desc,".indexOf(","+cellID+",")!=-1) {
					var objMessage = Altbl.rows[curr_row].cells[CurrentCell].children[0];
					if (objMessage) {
						if (HIDDEN_InteractARCIMID=="" ) {
							var objParent = websys_getParentElement(objMessage);
							objParent.innerHTML = objMessage.innerHTML;	
						} else {
							objMessage.onclick = MessageClick;
						}
					}	
				}
				
			}
		}
		Curr_PNo=HIDDEN_PNo;
		Curr_RowID=HIDDEN_RowID;

	}
}

function SelectReasonLookUp(str){
	var strArry=str.split("^");
	var SelectedRowID = "";
//alert(str);
	for (var i=1; i<Altbl.rows.length; i++) {
		var AAHIDReasObj=Alfrm.elements["HIDDENOVERREASz"+i];
		var RowID=Alfrm.elements["RowIdz"+i];
		var AAReasIDObj=Alfrm.elements["OVERREASIDz"+i];

		var AAReasObj=document.getElementById("OVERREASz"+i);
		var SelObj=document.getElementById("Selectz"+i);
		if ((SelObj)&&(SelObj.checked) ) {
			SelectedRowID = RowID.value;
			SelObj.checked=false;
		}
		if ((RowID) && (SelectedRowID==RowID.value)) {
			if (AAReasObj) AAReasObj.innerText=strArry[0];
			if (AAReasIDObj) AAReasIDObj.value=strArry[1];
			if (AAHIDReasObj) AAHIDReasObj.value=strArry[0];
		}
	}
	var objReas = document.getElementById("OverReas");
	if (objReas) objReas.value = "";

}

function InteractionClick(evt) {
	var tbl = document.getElementById("tPharmacy_Prescription_Alert");  
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>1) {
		var objIntMonograph=Alfrm.elements["MonoGraphz"+eSrcAry[1]].value;
		var feature='top=50,left=50,width=750,height=570,scrollbars=yes,resizable=yes';
		var url = "websys.default.csp?WEBSYS.TCOMPONENT=Pharmacy.Interaction&MonoGraphID="+objIntMonograph;
		websys_createWindow(url, 'InteractionMonograph', feature );
	}

	return false;
}

function MessageClick(evt) {
	var tbl = document.getElementById("tPharmacy_Prescription_Alert");  
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));

	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>1) {
		var CONTEXT=f.elements["CONTEXT"].value;
		var PatientID=f.elements["PatientIDz"+eSrcAry[1]].value;
		var OrdItem=f.elements["oeorirowidz"+eSrcAry[1]].value;
		var ArcimDR=f.elements["interactArcimDRz"+eSrcAry[1]].value;
		var EpisodeID=f.elements["EpisodeIDz"+eSrcAry[1]].value;
		var mradm=f.elements["MRAdmz"+eSrcAry[1]].value;
		var url = "oeorder.mainloop.csp?&ID="+OrdItem+"&EpisodeID="+EpisodeID+"&OEORIItmMastDR="+ArcimDR+"&PatientID="+PatientID+"&AN=&CONTEXT="+CONTEXT+"&mradm="+mradm+"&SummaryFlag="+"&UpdateFrom=Pharmacy.Presc.Edit&Mode=READONLY";
		var feature='top=50,left=50,width=750,height=570,scrollbars=yes,resizable=yes';
		
		websys_createWindow(url, 'ModifyItem', feature );
	}
	return false;
}


if (Altbl) DoColour();
