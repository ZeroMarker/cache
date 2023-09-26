websys_closeWindows();
var glb=""
//This must be at top of page or error will occur clicking New link.
function searchHandler(PatientID,mradm,EpisodeID,ObsGrpID,itm,ObservationGroup,EpisodesAll,CurrentPregnancy,ReverseDateOrder,studentchart) {
	var url="websys.default.csp?WEBSYS.TCOMPONENT=MRObservations.FindEMR&PatientID="+PatientID+"&mradm="+mradm+"&EpisodeID="+EpisodeID+"&ID="+ObsGrpID+"&ObsGrpID="+ObsGrpID+"&itm="+itm+"&PatientBanner=1"+"&EpisodesAll="+EpisodesAll+"&ObservationGroup="+ObservationGroup+"&CurrentPregnancy="+CurrentPregnancy+"&ReverseDateOrder="+ReverseDateOrder+"&studentchart="+studentchart;
	websys_createWindow(url,'Search','top=30,left=30,width=700,height=500,scrollbars=yes');
}

//expand or collapse the epr chart items
function ExpandCollapse(divID,imgID) {
	var	div=document.getElementById(divID);
	var	img=document.getElementById(imgID);
	if (div) {
		if (div.style.display == "none") {
			div.style.display = "";
			img.src = "../images/websys/minus.gif";
		} else {
			div.style.display = "none";
			img.src = "../images/websys/plus.gif";
		}
	}
}
function NewMRPicturesPage(parref,PatientID,MultiEpisodes) {
	if (MultiEpisodes=="1") {
		alert(multiselect);
		return false;
	}

	if (document.readyState=="complete") {
		var url="mrpictures.new.csp?PARREF="+parref+"&PatientID="+PatientID;
                //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
		var features="top=30,left=20,width=600,height=650,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		//alert(url);
 		websys_createWindow(url, 'new', features)
 	}
}
function NewPage(addpage,id,parref,mradm,MultiEpisodes) {
	if (MultiEpisodes=="1") {
		alert(multiselect);
		return false;
	}
	if (document.readyState=="complete") {
		var url="websys.default.csp?WEBSYS.TCOMPONENT="+addpage+"&PatientBanner=1&ID="+id+"&PARREF="+parref+"&mradm="+mradm+glb;
		//Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
                var features="top=30,left=10,width=600,height=440,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		websys_createWindow(url, 'new', features)
 	}
}

function NewQuestionnairePage(addpage,id,parref,QuestionnaireGroups,MultiEpisodes,ConsultID,Context) {
	if (MultiEpisodes=="1") {
		alert(multiselect);
		return false;
	}
	if (document.readyState=="complete") {
		var url="websys.default.csp?WEBSYS.TCOMPONENT="+addpage+"&PatientBanner=1&HideInactive=1&ID="+id+"&mradm="+parref+"&PARREF="+parref+"&groups="+QuestionnaireGroups+"&QUESConsultDR="+ConsultID+glb+"&CONTEXT="+Context;
		//Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
                var features="top=30,left=10,width=600,height=440,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		websys_createWindow(url, 'new', features)
 	}
}

function NewAnaestheticsPage(parref) {
	if (document.readyState=="complete") {
		var url="oranaesthesiaedit.agentlist.csp?PARREF="+parref+glb;
                //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
		var features="top=30,left=20,width=600,height=650,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		//alert(url);
 		websys_createWindow(url, 'new', features)
 	}
}

function NewObsPage(PatientID,mradm,EpisodeID,ObsGroup,StudentChart,MultiEpisodes,ConsultID) {
	if (MultiEpisodes=="1") {
		alert(multiselect);
		return false;
	}
	if (document.readyState=="complete") {
		var url="mrobservations.entry.csp?PatientID="+PatientID+"&PatientBanner=1&EpisodeID="+EpisodeID+"&mradm="+mradm+"&ObsGrpID="+ObsGroup+"&studentchart="+StudentChart+"&OBSConsultDR="+ConsultID;
		//Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
                var features="top=30,left=10,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		websys_createWindow(url, 'new', features)
 	}
}
function NewDischarge(PatientID,workflow) {
	if (document.readyState=="complete") {
		var url="websys.csp?PatientID="+PatientID+"&TWKFL="+workflow;
                //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
		var features="top=0,left=0,width="+(screen.availWidth-(0.1*screen.availWidth))+",height="+(screen.availHeight-(0.1*screen.availHeight))+",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		websys_createWindow(url, 'new'+PatientID, features)
 	}
}
function ClearAndNewQuest(url,MultiEpisodes) {
	if (MultiEpisodes=="1") {
		alert(multiselect);
		return false;
	}
	window.open(url, window.name, "");

	/*var frm = document.getElementById("f"+ListComponent);
	if (frm) {
		var iNumElems = frm.elements.length;
  		for (var i=0; i<iNumElems; i++) {
   			var eElem = frm.elements[i];
   			//alert("Before " + '\n'+ eElem.id.substring(0,1) + '\n'+ eElem.tagName + '\n'+ eElem.type +'\n' + eElem.id + '\n' + eElem.value);
   			if (eElem.id=="ID") {
   				eElem.value = "";
   				//alert("Changed "+ eElem.tagName + '\n' + eElem.id + '\n' + eElem.value);
   			}
   			if ((eElem.type != "hidden") && (eElem.id.substring(0,1)=="Q") ) {
   				if (eElem.tagName=="TEXTAREA") {
   					eElem.innerText = "";
   				} else if (eElem.tagName == "INPUT"){
					if (eElem.type == "checkbox") {
						eElem.checked = false;
					} else {
						eElem.value = "";
					}
   				} else if (eElem.tagName == "SELECT") {
					for (var ix=0; ix<eElem.options.length; ix++) {
						eElem.options[ix].selected = false;
					}
				}
    		}
    	}
	}
	*/
	//window.treload('websys.csp');
}

function graphHandler(Graph,mradm,mradmlist){
	var url="epr.displaygraph.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm+"&mradmlist="+mradmlist+"&Graph="+Graph;
	websys_createWindow(url,'Graph','top=0,left=0,width=670,height=620,scrollbar=yes,resizable=yes');
	return false;
}
function CumulativeGraph(chartitemid, PatientID, itemid,CumulativeItemIDs) {
	// Log 37905 - AI - 04-09-2003 : As we are coming from Cumulative profile, we have an ItemID. Send across a blank CumulativeItemIDs parameter (for Tabular to Cumulative logic).
	var url = "epr.displaygraph.csp?PatientID="+PatientID+ "&EpisodeID="+EpisodeID+"&mradm="+mradm+"&ChartItemID="+chartitemid+"&OrderItemID="+itemid+"&CumulativeItemIDs="+CumulativeItemIDs;
	//alert(url);
	websys_createWindow(url,'Graph','top=0,left=0,width=1020,height=640,scrollbar=yes,resizable=yes');
	return false;
}

// 27.02.03 Log 26672: Changed link to paadm.contactcareprov.csp
// 27-06-2002 LOG 23601 AI: Add "Episode Contact" link
function EpisodeContact(PatientID,EpisodeID,eprchartCONTEXT,MultiEpisodes) {
	if (MultiEpisodes=="1") {
		alert(multiselect);
		return false;
	}
	if (document.readyState=="complete") {
		//var url="panok.list.csp?PatientID="+PatientID+"&PARREF="+PatientID;
		var url="paadm.contactcareprov.csp?PatientID="+PatientID+"&PARREF="+PatientID+"&EpisodeID="+EpisodeID+"&CONTEXT="+eprchartCONTEXT+"&PatientBanner=1";
		var features="top=30,left=10,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		websys_createWindow(url, 'new', features)
 	}
}
function LinkedEpisodes(PatientID,DischID,eprchartCONTEXT) {
	if (document.readyState=="complete") {
		var url="paadm.discharge.edit.csp?DischID="+DischID+"&PatientID="+PatientID+"&CONTEXT="+eprchartCONTEXT;
                //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
		var features="top=30,left=10,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
 		websys_createWindow(url, 'new', features)
 		//alert("do this: " + DischID);
 	}
}
function QuestUpdate(evt) {

	var eSrc = websys_getSrcElement(evt);
	while(eSrc.tagName != "FORM") {
		eSrc=eSrc.parentElement;
	}
	var frmName = eSrc.id;
	var frmEdit = document.forms[frmName];
	
	if ((window.parent.parent!=top)&&(window.name=="dataframe")) {
		frmEdit.elements['TFRAME'].value=window.name;
		// ab 29.08.06 60491 - on update, reload chart, don't go through workflow (eg. don't go back to start page)
		frmEdit.elements['TWKFL'].value="";
	} else if ((window.parent!=top)&&(window.name=="maindata")) {
		// if a single chart it sits in the manidata frame...
		frmEdit.elements['TFRAME'].value=window.name;
	} else {
		frmEdit.elements['TWKFL'].value="";
	}

	if (self!=top) {
		if (frmEdit.elements['refresh']) {
			frmEdit.elements['refresh'].value = frmEdit.elements['TRELOADID'].value;
		}
	}

	// do generic update
	update1_click();

}
