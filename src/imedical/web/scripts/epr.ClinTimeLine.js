//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

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
	window.parent.ResizeEPsPABanner();
}

function SelectEps(strEps,ColID) {
	if (strEps=="") {
		alert(t['NOEPS']);
		return false;	
	}
	// first unselect ALL eps
	var objAllEpis=document.getElementById("AllEpisodes");
	if (objAllEpis) {
		var aryAllEps=objAllEpis.value.split("^");
		for (var EpsIX=0; EpsIX<aryAllEps.length; EpsIX++) {
			SelectOneEp(aryAllEps[EpsIX],"-1");
		}
	}

	// unselect all date selector columns
	var aryTDs=document.getElementsByTagName("TD");
	for (var TDIX=0; TDIX<aryTDs.length; TDIX++) {
		// while we're here - unselect ANY columns marked as 'selected'
		if (aryTDs[TDIX].id.indexOf("COL")==0) {
			var objCOL=document.getElementById(aryTDs[TDIX].id);
			if (objCOL) objCOL.className= "EMREpisTimeLineCol";
		}
	}
	// select each episode vertically
	var aryEps=strEps.split("^");
	for (var EpsIX=0; EpsIX<aryEps.length; EpsIX++) {
		SelectOneEp(aryEps[EpsIX],"1");
	}

	// colour column
	var objCOL=document.getElementById(ColID);
	if (objCOL) {
		if (objCOL.className=="EMREpisTimeLineCol") {
			objCOL.className= "EMREpisTimeLineColSelect";
		} else {
			objCOL.className= "EMREpisTimeLineCol";
		}
	}
	refreshEPR(strEps);
}
function SelectOneEp(ep,SelectMe) {
	// 'SelectMe' is either 
	//	1 (select it)
	//	-1 (unselect it)
	//	"" (toggle it)
	var EpisodeID = document.getElementById("EpisodeID");
	var DefaultEpisodeID=EpisodeID.value;

	// select/unselect episode
	var className = "";
	var objEpis=document.getElementById("Epis"+ep);
	if (objEpis) {
		if (SelectMe=="") {
			if (objEpis.className=="EMREpisTimeLine") {
				className = "EMREpisTimeLineSelect";
			} else if (objEpis.className=="EMREpisTimeLineCANCEL") {
				className = "EMREpisTimeLineCANCELSelect";
			} else if (objEpis.className=="EMREpisTimeLineSelect") {
				className = "EMREpisTimeLine";
			} else if (objEpis.className=="EMREpisTimeLineCANCELSelect") {
				className = "EMREpisTimeLineCANCEL";
			}

		} else if (SelectMe=="1") {
			if (objEpis.className=="EMREpisTimeLine") {
				className = "EMREpisTimeLineSelect";
			} else if (objEpis.className=="EMREpisTimeLineCANCEL") {
				className = "EMREpisTimeLineCANCELSelect";
			}
		} else if (SelectMe=="-1") {
			if (objEpis.className=="EMREpisTimeLineSelect") {
				className = "EMREpisTimeLine";
			} else if (objEpis.className=="EMREpisTimeLineCANCELSelect") {
				className = "EMREpisTimeLineCANCEL";
			}
		}
		if (className!="") objEpis.className = className;
	}

	// update EPR ONLY if we clicked a single episode
	// otherwise - 'SelectEps' will do this call after each call to 'SelectOneEp'
	if (SelectMe=="") {
		var episString = "";
		var aryTDs=document.getElementsByTagName("TD");
		for (var TDIX=0; TDIX<aryTDs.length; TDIX++) {
			// only grab TDs starting with 'Epis'
			if (aryTDs[TDIX].id.indexOf("Epis")==0) {
				var obj=document.getElementById(aryTDs[TDIX].id);
				if (obj && (obj.className!="EMREpisTimeLineSelect")&& (obj.className!="EMREpisTimeLineCANCELSelect")) continue;
				var aryTmp=aryTDs[TDIX].id.split("Epis");
				var epid=aryTmp[1];
				if (episString!="") {
					episString +="^";
				}
				episString += epid;
			}
			// while we're here - unselect ANY columns marked as 'selected'
			if (aryTDs[TDIX].id.indexOf("COL")==0) {
				var objCOL=document.getElementById(aryTDs[TDIX].id);
				if (objCOL) objCOL.className= "EMREpisTimeLineCol";
			}
		}
		// we MUST select something!
		if (episString=="") {
			var objEpis=document.getElementById("Epis"+DefaultEpisodeID);
			if (objEpis) {
				if (objEpis.className=="EMREpisTimeLine") {
					objEpis.className = "EMREpisTimeLineSelect";
				} else if (objEpis.className=="EMREpisTimeLineCANCEL") {
					objEpis.className = "EMREpisTimeLineCANCELSelect";
				}			
			}
			episString = DefaultEpisodeID;
		}
		// update EPR
		refreshEPR(episString)
	}
}
function refreshEPR(epis) {
	var eprfrm = window.parent.document.getElementById("bookframeset");
	var mainlnk = document.getElementById("mainlnk");
	var leftlnk = document.getElementById("leftlnk");
	if (eprfrm) {
		if (leftlnk&&leftlnk.value!="") {
			//var data=eprfrm.document.frames['dataframeset'];
			var data=eprfrm.document.frames['leftdata'];
			data.location=leftlnk.value+"&EpisodeIDs="+epis;
		}
		if (mainlnk) {
			var data=eprfrm.document.frames['maindata'];
			var selectedChart = data.selected;
			var strlink = mainlnk.value+"&EpisodeIDs="+epis;
			if (selectedChart) {
				strlink += "&SelectedChart=" + selectedChart;
			}
			//alert(strlink);
			data.location = strlink;
		}	
	}

}

function AddEpisodeOnClick() {
	// pat faves 53639
	// get a list of selected episodes..
	var episString = "";
	var aryTDs=document.getElementsByTagName("TD");
	for (var TDIX=0; TDIX<aryTDs.length; TDIX++) {
		// only grab TDs starting with 'Epis'
		if (aryTDs[TDIX].id.indexOf("Epis")==0) {
			var obj=document.getElementById(aryTDs[TDIX].id);
			if (obj && (obj.className!="EMREpisTimeLineSelect") && (obj.className!="EMREpisTimeLineCANCELSelect")) continue;
			var aryTmp=aryTDs[TDIX].id.split("Epis");
			var epid=aryTmp[1];
			if (episString!="") {
				episString +="^";
			}
			episString += epid;
		}
	}
	if (episString=="") {
		alert(t['NOEPSSEL']);
		return false;
	}
	
	var hidden=window.top.document.frames['TRAK_hidden'];
	var strlink = "epr.favadd.csp?EpisodeID="+episString;
	hidden.location = strlink;
	return false;
}

function AddPatientOnClick() {
	// pat faves 53639
	var PatientID = document.getElementById("PatientID");
	if (PatientID) {
		PatientID= PatientID.value;
		var hidden=window.top.document.frames['TRAK_hidden'];
		var strlink = "epr.favadd.csp?PatientID="+PatientID;
		hidden.location = strlink;		
	}
	return false;
}

function bodyload(ALLEpisodes) {
	var EpisodeID = document.getElementById("EpisodeID");

	var addepis = document.getElementById("AddEpisode");
	if (addepis) {
		addepis.onclick = AddEpisodeOnClick;
	}
	var addpat = document.getElementById("AddPatient");
	if (addpat) {
		addpat.onclick = AddPatientOnClick;
	}
	// 59418 allow all episodes to be selected
	if (ALLEpisodes == "1") {	
		var objAllEpis=document.getElementById("AllEpisodes");
		if (objAllEpis) {
			var aryAllEps=objAllEpis.value.split("^");
			for (var EpsIX=0; EpsIX<aryAllEps.length; EpsIX++) {
				SelectOneEp(aryAllEps[EpsIX],"1");
			}
		refreshEPR(objAllEpis.value);
		}
	} else {
		SelectOneEp(EpisodeID.value,"1");
		refreshEPR(EpisodeID.value);
	}
}


