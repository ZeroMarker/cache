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
	var aryfound=checkedCheckBoxes(f,tbl,"selectz");
	// HitCount is only required for preview reports when data is not being refresh automatically.
	var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		//alert(t['NOITEMSSELECTED']);
	} else {
		for (i in aryfound) {
			var row=aryfound[i];
			//alert(row);
			// check for specific values - these values must be hidden in the component
			if (!f.elements["RowIdz"+row]) continue;
			if (f.elements["RowIdz"+row].value!="") {
				// when the report is not preview i.e. will be inserted in the PrintHistory for the TPS
				if (newwin=="TRAK_hidden") {
					var newlnk=lnk;
					// concatenate specific row parameter values to lnk. this is necessary because the %request
					// variables are lost when the menu is selected. These parameter values will be resolved in 
					// the Report Manager definition.
					newlnk=newlnk+"&RowId="+f.elements["RowIdz"+row].value;
					websys_createWindow(newlnk,"TRAK_hidden");
					// time delaying function to allow proper loading of the TRAK_hidden frame
					CompleteReportLoading();
				} else { 	// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["RowIdz"+row].value);
				}
			}
		}
	}
}
