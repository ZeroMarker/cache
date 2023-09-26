// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tPAAdmDischargeSummary_EpisodesEdit");
var StartAry=document.getElementById("StartAry");
var UpdAry=document.getElementById("UpdAry");

function BodyLoadHandler() {
	var tbl=document.getElementById("tPAAdmDischargeSummary_EpisodesEdit" );
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var objdoctype=document.getElementById("doctype");
	var objDischID=document.getElementById("DischID");
//alert(objDischId.value);
	var objSummDocTypes=document.getElementById("SummDocDesc");
	// 'SummDocDesc' is a variable populated by paadm.discharge.Edit.csp - it is non-null ONLY if there is 1 doc type
	if (objdoctype && objSummDocTypes) {
		if (objSummDocTypes.value!="") {
			objdoctype.value = objSummDocTypes.value;
		}
		if (objDischID && objDischID.value!="") {
			objdoctype.disabled = true;
			// KB - Log 63128
			var objLookupImg=document.getElementById("ld1945idoctype")
			if (objLookupImg) objLookupImg.disabled = true;
			// Log Finished
		}
	}
	var objUpdate=document.getElementById("update");
	if (objUpdate) objUpdate.onclick = CheckEpisodes;

	// Log 52690 - AI - 15-07-2005 : Definition of new shortcut, ALT-"U". Omitted from initial logic.
	if (tsc['update']) websys_sckeys[tsc['update']]=CheckEpisodes;


	if (tbl) {
		tbl.onclick=ListSelectRowHandler;
	}

	// Initialise the two Episode Lists.
	StartAry.value="";
	UpdAry.value="";
	// Store the List of selected Episodes at the Start of this update.
	var aryfound=checkedCheckBoxes(f,tbl,"selectedz");
	if (aryfound.length!=0) {
		var episodes = "";
		for (var i = 0; i < aryfound.length; i++) {
			var count = aryfound[i];
			var episode = document.getElementById("episodeidz" + count);
			if (episode) {
				if (episodes!="") { episodes = episodes + "^";}
				episodes = episodes + episode.value;
			}
		}
		var objEpisodes = document.getElementById("DischEpisodes");
		if (objEpisodes) {
			objEpisodes.value = episodes;

			// Store the List of selected Episodes at the Start of this update.
			StartAry.value=objEpisodes.value;
		}
	}

	// ab 23.08.06 59768 - if opened from consult screen, default episode and disable other episode checkboxes
	var obj=document.getElementById("ConsultID");
	var obj2=document.getElementById("EpisodeID");
	if ((f)&&(tbl)&&(obj)&&(obj2)&&(obj.value!="")&&(obj2.value!="")) {
		for (var i=1;i<tbl.rows.length;i++) {
			var objep=document.getElementById("episodeidz"+i);
			var objsel=document.getElementById("selectedz"+i);
			if ((objep)&&(objsel)) {
				if (objep.value==obj2.value) {
					objsel.checked=true;
				} else {
					objsel.disabled=true;
				}
			}
		}
	}
}

function ListSelectRowHandler(evt) {
	var tbl=document.getElementById("tPAAdmDischargeSummary_EpisodesEdit" );
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	if (eSrcAry[0]=="PADSDocType") {
		// if authorised - just show the document - else go to the chart.
		var DocName=f.elements["DocNamez"+eSrcAry[1]].value;
		var Status=f.elements["Statusz"+eSrcAry[1]].value;
		if (Status=="A") {
			//alert(Status+DocName);
			window.open(DocName, 'DischargeSummary', 'top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
			//alert(DocName);
			return false;
		} else {
			// allow the workflow to continue with discharge summary chart
			return true;
		}
	}
	// allow episode number to pass the click - it should carry on with the paadm.edit lookup...
	if (eSrcAry[0]=="PADSEpisNo") {
		return false;
	}
	// cancel the not required link - it's just there to show an image...
	if (eSrcAry[0]=="notreq") {
		return false;
	}



}

function CheckEpisodes () {
	var tbl=document.getElementById("tPAAdmDischargeSummary_EpisodesEdit" );
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var objdoctype=document.getElementById("doctype");
	var aryfound=checkedCheckBoxes(f,tbl,"selectedz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else if (objdoctype && (!objdoctype.disabled) && (objdoctype.value=="")) {
		alert(t['NODOCTYPESELECTED']);
	} else {
		var episodes = "";
		for (var i = 0; i < aryfound.length; i++) {
			var count = aryfound[i];
			var episode = document.getElementById("episodeidz" + count);
			if (episode) {
				if (episodes!="") { episodes = episodes + "^";}
				episodes = episodes + episode.value;
			}
		}
		var objEpisodes = document.getElementById("DischEpisodes");
		if (objEpisodes) {
			objEpisodes.value = episodes;

			// Store the List of selected Episodes at the end of this update.
			UpdAry.value=objEpisodes.value;
		}
		var retval= update_click();
		return retval;

	}

}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}


document.body.onload = BodyLoadHandler;

