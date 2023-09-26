//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	// HitCount is only required for reports when data is not being refresh automatically due to problems with
	// the Crystal Web Server. See Crystal KnowledgeBase Article c2002771.
	var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		var cnt=0
		// for each row selected
		for (i in aryfound) {
			var row=aryfound[i];
			// check for specific values - these values must be hidden in the component
			if (!f.elements["PatientIDz"+row]) continue;
			if (!f.elements["EpisodeIDz"+row]) continue;
			if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")) {
				// when the report is not preview i.e. will be inserted in the PrintHistory for the TPS
				if (newwin=="TRAK_hidden") {
					var newlnk=lnk;
					// concatenate specific row parameter values to lnk. this is necessary because the %request
					// variables are lost when the menu is selected. These parameter values will be resolved in 
					// the Report Manager definition.
					newlnk=newlnk+"&PatientID="+f.elements["PatientIDz"+row].value;
					newlnk=newlnk+"&EpisodeID="+f.elements["EpisodeIDz"+row].value;
					// send report to hidden page, i.e. print report
					websys_createWindow(newlnk,"TRAK_hidden");
					// time delaying function to allow proper loading of the TRAK_hidden frame
					CompleteReportLoading();
				} else { 	// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
					//alert(lnk);
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value);
				}
			}
		}
	}
}

