// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tPAAdmDischargeSummary_CopyList");

function BodyLoadHandler() {
	var objUpdate=document.getElementById("update");
	if (objUpdate) objUpdate.onclick = CheckEpisodes;

	// Log 52690 - AI - 15-07-2005 : Definition of new shortcut, ALT-"U". Omitted from initial logic.
	if (tsc['update']) websys_sckeys[tsc['update']]=CheckEpisodes;
}

function CheckEpisodes () {
	var tbl=document.getElementById("tPAAdmDischargeSummary_CopyList" );
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"selectedz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
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
		var objEpisodes = document.getElementById("SelectedEpIds");
		if (objEpisodes) {
			objEpisodes.value = episodes;
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

