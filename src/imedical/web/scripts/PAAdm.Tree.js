// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var patid=document.getElementById('PatientID').value;

function SelectRowHandler2() {
	try {
		var returnValue=CustomSelectRowHandler();
		if (!returnValue) {
			//window.event.cancelBubble;
			return false;
		}
	} catch(e) {}
	
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var objTblSel=getTable(eSrc);

	//???just ignore if selected row is from nested component
	//TN 19-Nov-2004: don't override that selected from nested component rbapptepisode.list 
	if (objTblSel.id!="tPAAdm_Tree") return;
	
	var objRowSel=getRow(eSrc);
	var objFrm=getFrmFromTbl(objTblSel);
	var eSrcAry=eSrc.id.split("z");

	//reset menu header EpisodeID selected due to nested component RBApptEpisode.List also containing EpisodeID field
	var paadmrow=objRowSel.rowIndex;
	var episid=patid=mradmid=birth="";
	if (objRowSel.className=='clsRowSelected') {
		var arrfld=objRowSel.getElementsByTagName('INPUT');
		for (var j=0; j<arrfld.length; j++) {
			if (arrfld[j].id.indexOf("EpisodeIDz")==0) {
				episid=arrfld[j].value;
			}
			// ab 10.03.04 42688
			if (arrfld[j].id.indexOf("PatientIDz")==0) {
				patid=arrfld[j].value;
			}
			if (arrfld[j].id.indexOf("mradmz")==0) {
				mradmid=arrfld[j].value;
			}
			// ab 1.09.04 - 45977
			if (arrfld[j].id.indexOf("canGiveBirthz")==0) {
				birth=arrfld[j].value;
			}
			//Log 60540 Bo 15-08-2006: add hidden field "HidPAADMVisitStatusz" to check the visit status. Alert if it's cancelled.
			if (arrfld[j].id.indexOf("HidPAADMVisitStatusz")==0) {
				VisitStatus=arrfld[j].value;
				if ((VisitStatus=="C")&&(eSrc.id.indexOf("Orderz")!=0)) alert (t['CancelledEpisode']);
			}
		}
	}
	
	/* ab 28.09.07 64623 - this is not needed.. handled by websys.List.js i believe.. it's also causing TRELOAD variables to be cleared
	if ((window.top)&&(window.top.frames["eprmenu"])) {
		window.top.MainClearEpisodeDetails()
		
		window.top.SetSingleField("PatientID",patid);
		window.top.SetSingleField("EpisodeID",episid);
		window.top.SetSingleField("mradm",mradmid);
		window.top.SetSingleField("canGiveBirth",birth);
	}
	*/
	
	// ab 14.11.03 40677 - removed this because it doesnt seem to be useful, and it resets the other values in SetEpisodeDetails to blank
	// code in websys.List should get the correct id for nested components
	/* 
	JW: put it back - actually it's very useful...
	
	//reset menu header EpisodeID selected due to nested component RBApptEpisode.List also containing EpisodeID field
	var paadmrow=objRowSel.rowIndex;
	var arrPAAdmRow=new Array();
	arrPAAdmRow["EpisodeID"]="";arrPAAdmRow["mradm"]="";arrPAAdmRow["WaitingListID"]="";
	if (objRowSel.className=='clsRowSelected') {
		var arrfld=objRowSel.getElementsByTagName('INPUT');
		for (var j=0; j<arrfld.length; j++) {
			if (arrfld[j].id.indexOf("EpisodeIDz")==0) {
				arrPAAdmRow["EpisodeID"]=arrfld[j].value;
			}
			if (arrfld[j].id.indexOf("mradmz")==0) {
				arrPAAdmRow["mradm"]=arrfld[j].value;
			}
			if (arrfld[j].id.indexOf("WLRowIdz")==0) {
				arrPAAdmRow["WaitingListID"]=arrfld[j].value;
			}
		}
	}
	if ((window.top)&&(window.top.frames["eprmenu"])) {
		window.top.SetEpisodeDetails(patid,arrPAAdmRow["EpisodeID"],arrPAAdmRow["mradm"],"","",arrPAAdmRow["WaitingListID"],"","","","","","","","","","","","","","");
	} */

	if (eSrcAry.length>0) {
		var idxRow = eSrcAry[eSrcAry.length-1];

		if (eSrcAry[0]=="PAADM_ADMNo") {
			var currentlink=eSrc.href.split("?");
			var temp1=currentlink[1].split("&TWKFL");
			var temp2=currentlink[1].split("&ID");
			var flow=document.getElementById("TWKFL");
			if (flow) flow=flow.value;
			var url = "paadm.edit.csp?" + temp1[0] + "&ID" + temp2[1] +"&flow="+flow;
			websys_lu(url,false,"width=850,height=650,left=10,top=10")
			return false;
		}
		if (eSrcAry[0]=="PAADMAdmDate") {
			var currentlink=eSrc.href.split("?");
			var temp1=currentlink[1].split("&TWKFL")
			var temp2=currentlink[1].split("&ID")
			var url = "paadm.edit.csp?" + temp1[0] + "&ID" + temp2[1];
			//alert(url);
			
			// cjb 06/03/2006 56793 - if this is nested in panok csp, escape out of the frames
			if (window.name=="panok_list") eSrc.target='_parent';
			//self.location.href=url;
		  	//return false;
		}
		
		// LOG 30348 RC 28/02/03 Check to see if an Episode is discharged before making an order in either PAAdm.Tree or
		// RBApptEpisode.List.
		if (eSrcAry[0]=="Order") {
			// oeorder.custom.csp
			// "&PatientID="_%request.Get("PatientID")_"&EpisodeID="_rs.GetDataByName("EpisodeID")_"&mradm="_rs.GetDataByName("mradm")_"&PatientBanner=1"
			// height=720,width=800,top=5,left=5

			if (objTblSel.id.indexOf("tPAAdm_Tree")==0) {
				if (!ContinueIfDischargedEpisode(objRowSel,idxRow)) return false;
				if (!ContinueIfCancelledEpisode(objRowSel,idxRow)) return false;
			}
			if (objTblSel.id.indexOf("tRBApptEpisode_List")==0) {
				// Check if appt belongs to discharge episode
				var objRowPAAdm=objTblSel; var regex=/r\d+r613iAppointmentz\d+/; //eg. r24005755r613iAppointmentz4
				while (1) {
					objRowPAAdm=websys_getParentElement(objRowPAAdm);
					if ((objRowPAAdm.tagName=="TR")&&(regex.test(objRowPAAdm.id))) break;
				}
				if (!ContinueIfDischargedEpisode(objRowPAAdm,0)) return false;
				if (!ContinueIfCancelledEpisode(objRowPAAdm,0)) return false;

				// This was going to be used if an appointment was cancelled, but even though it is not needed at the
				// moment, I will keep it here in case it does need to be used at a later date.
				/*var arrRowFld=objRowSel.getElementsByTagName("INPUT");
				var statusObj=arrRowFld["APPT_StatusCodez"+idxRow];
				if ((statusObj)&&(statusObj.value=="X")) {
					var proceed=confirm(t['Cancelled'])
					if (!proceed) return false;
				}*/
			}
		}
		
		// open PAAdmDischarge.Edit or PAAdm.EditEmergency depending on adm type
		if (eSrcAry[0]=="Discharge") {
			var currentlink=eSrc.href.split("&ID=");
			
			var component="PAADMDischarge.Edit";
			var AdmType=document.getElementById("admtypez"+eSrcAry[1]);
			if (AdmType) AdmType=AdmType.value;
			if (AdmType=="E") component="PAADM.EditEmergency";
			//alert(currentlink[1]);
			var url = "websys.default.csp?WEBSYS.TCOMPONENT="+component+"&ID="+currentlink[1];
			
			websys_lu(url,false,"width=750,height=530,left=10,top=10")
			return false;
		}
	}
}

function ContinueIfDischargedEpisode(objRow,idxRow) {
	if (!idxRow) {
		var arr=objRow.id.split("z");
		idxRow=arr[arr.length-1];
	}
	//may need to do something else in case there are multiple PAAdm.Tree lists, but for now
	var disDateObj=document.getElementById("PAADMDischgDateCachez"+idxRow);
	if ((disDateObj)&&(disDateObj.value!="")) {
		return confirm(t['Discharged'])
	}
	return true;
}

//log 60540 Bo
function ContinueIfCancelledEpisode(objRow,idxRow) {
	var found=true;
	if (!idxRow) {
		var arr=objRow.id.split("z");
		idxRow=arr[arr.length-1];
	}
	//may need to do something else in case there are multiple PAAdm.Tree lists, but for now
	var obj=document.getElementById("HidPAADMVisitStatusz"+idxRow);
	if ((obj)&&(obj.value=="C")) {
		alert(t['CancelledEpisode'])
		found=false;
	}
	return found;
}

function BodyLoadHandler() {
	try {
		CustomBodyLoadHandler();
	} catch (e) {}

	if ((window.name=='tree_list')&&(parent.frames['tree_top'])) {
		try {
			parent.InitTree();
		} catch(err) {}
	}
	assignClickHandler();
}


function assignClickHandler() {
	//ez added 29/03/07 log 62735 to disable new button 
	var newDisobj=document.getElementById("NewBtnDisabled").value;
	var newLink=document.getElementById("new");
	if (newDisobj==1) {
		newLink.disabled=true
		newLink.onclick=LinkDisable
	}
	//end 62735 (also LinkDisable function copied from other script)
	
	var tbl=document.getElementById("tPAAdm_Tree");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("GroupNumberz"+i)
		var obj1=document.getElementById("EpID1z"+i)
		if ((obj)&&(obj1)) {
		var val=obj.innerHTML;
		var arylink=new Array();
		if (val!="&nbsp;") { //if val does not contain data it contains &nbsp; 
			var ary=val.split("(");
			val=ary.join("");
			ary=val.split(")");
			val=ary.join("");
			ary=val.split(",");
			val=ary.join(" ");
			multimerge=obj1.value;
			
			
			for (var j=0;j<ary.length;j++) {
				arylink[j]="<A HREF='javascript:goToLinkItB("+'"'+ary[j]+'","'+multimerge+'"'+")'>"+ary[j]+"</A>";
				
			}
			obj.innerHTML=arylink.join(",");
		}
		}
	}
	return;
}

function goToLinkItB(val,val2) {
	var patid=document.getElementById("PatientID").value;
	//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.ListEMR&&EpisodeID='+val2+'&GroupNumber='+val+'&EpisodeIDs='+val2+'&PatientID='+patid+'&PatientBanner=1','merge','top=20,left=20,width=500,height=300');
	websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.ListEMR&&EpisodeID='+val2+'&GroupNumber='+val+'&EpisodeIDs='+val2+'&PatientID='+patid+'&PatientBanner=1',false);			
	
}
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}

document.body.onload = BodyLoadHandler;