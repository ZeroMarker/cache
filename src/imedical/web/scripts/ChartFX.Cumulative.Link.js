// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function Init() {
	var obj=document.getElementById('CreateGraph');
	if (obj) obj.onclick=SubmitGraph;
	var obj=document.getElementById('Graph');
	// run the graph for the first time
	//if ((parent)&&(parent.frames)&&(parent.frames['chartfxlink'])) {
	//	parent.frames['chartfxlink'].SubmitGraph();
	//}
	//
	// Log 54822 YC - Add Print Link to Cumulative graph
	var objprint=document.getElementById('PrintGraph');
	if (objprint) objprint.onclick=ChartFXPrint;
}

function SubmitGraph() {
	// put the selected items into a hidden field
	var winf = "";
	if ((parent)&&(parent.frames)&&(parent.frames['TestItemsFrame'])) {
		winf = parent.frames['TestItemsFrame'];
	}
	if (winf) {
		var Selected = "";
		var SelectedDesc = "";
		var NumberSelected = 0;
		var tbl=winf.document.getElementById("tChartFX_Select_List");
		if (tbl) {
			for (var i=1;i<tbl.rows.length;i++) {
				var datarow = winf.document.getElementById("Selectz" + i);
				if (datarow && datarow.checked && !datarow.disabled) {
					var testitem = winf.document.getElementById("ItemCodez" + i);
					var testdesc = winf.document.getElementById("ItemDescz" + i);
					if ((testitem)&&(testdesc)) {
						Selected  = Selected + testitem.value + "^";
						SelectedDesc  = SelectedDesc + testdesc.value + "^";
						NumberSelected = NumberSelected + 1;
					}
				}
			}
		}
	}
	var objSelected = document.getElementById("Selected");
	if (objSelected) {
		objSelected.value = Selected;
	}
	var objNumberSelected = document.getElementById("NumberSelected");
	if (objNumberSelected) {
		objNumberSelected.value = NumberSelected;
	}
	var objSelectedDesc = document.getElementById("SelectedDesc");
	if (objSelectedDesc) {
		objSelectedDesc.value = SelectedDesc;
	}
	// the original window size is 620 high and 670 wide
	// the original GRAPH size is 350 high and 600 wide
	// calculate the differences, and expand the screen...
	var winHeight = document.getElementById("Height");
	var winWidth = document.getElementById("Width");
	var OrigWinHeight = 640;
	var OrigWinWidth = 1020;
	var OrigGraphHeight = 350;
	var OrigGraphWidth = 600;
	if ((winHeight)&&(winWidth)) {
		var newwidth = ((OrigWinWidth - OrigGraphWidth) + parseInt(winWidth.value));
		if (newwidth< 750) newwidth=750;
		// Log 52341 YC - window is bigger than width of screen, then make the window go to the edge of the screen
		if (window.screen.Width < (window.screenLeft + newwidth)) 
			newwidth = window.screen.Width - (window.screenLeft-10);
		var newheight = (OrigWinHeight - OrigGraphHeight + parseInt(winHeight.value));
		if (newheight< 500) newheight=500;
		// Log 52341 YC - window is bigger than height of screen, then make the window go to the edge of the screen
		if (window.screen.Height < (window.screenTop + newheight)) 
			newheight = window.screen.Height - (window.screenTop);
		window.parent.resizeTo(newwidth, newheight);
	}
	var frm = document.forms["fChartFX_Cumulative_Link"];
	frm.target = "graphcomponent";
	frm.action = "epr.EMRGraph.asp";
	//alert("submitting");
	var retval =  CreateGraph_click();
	// CreateGraph_click disables the link - so I'm gonna re-enable it...
	var obj=document.getElementById('CreateGraph');
	if (obj) {obj.disabled=false;obj.onclick=SubmitGraph};
	return retval;
}

// Log 54822 YC - Add prink link to cumulative graph
function ChartFXPrint() {
	if ((parent.graphcomponent)&&(parent.graphcomponent.document.getElementsByTagName("IMG").length>0)) {
		var objbanner=document.getElementById("dPAPerson_Banner");
		// if patient banner on screen - copy banner and grpah into hidden frame and print
		// otherwise just print from graph screen
		if (objbanner) {
			var winhidden=window.open("","Popup_TRAK_hidden");
			winhidden.document.writeln("<HTML><HEAD>");
			for (var i=0; i<document.styleSheets.length; i++) {
				winhidden.document.writeln("<LINK REL='stylesheet' TYPE='text/css' HREF='"+document.styleSheets[i].href+"'></LINK>");
			}
			winhidden.document.writeln("<SCRIPT>function DoPrint() {window.print();}</SCRIPT>");
			winhidden.document.writeln("</HEAD><BODY></BODY></HTML>");
			winhidden.document.close();
			if (document.all) { //IE
				winhidden.document.body.insertAdjacentHTML('beforeEnd',parent.graphcomponent.document.body.innerHTML);
				winhidden.document.getElementById('eprPatientBannerSlot').insertAdjacentHTML('beforeEnd',objbanner.outerHTML);
			} else { //N7 - untested
				var objprintdoc=parent.graphcomponent.document.body.cloneNode(true);
				if (objprintdoc) objprintdoc=winhidden.document.body.appendChild(objprintdoc);
				var objprintdocbanner=objbanner.cloneNode(true);
				if (objprintdocbanner) objprintdocbanner=winhidden.document.getElementById('eprPatientBannerSlot').appendChild(objprintdocbanner);
			}
			setTimeout("PrintNow();",220);
		} else {
			parent.graphcomponent.focus();
			parent.graphcomponent.print();
		}
	} else {
		//need to translate
		alert('no graph to print');
	}
	//document.focus();
	return false;
}
function PrintNow() {
			var winhidden=window.open("","Popup_TRAK_hidden");
			winhidden.focus();
			//winhidden.print();
			winhidden.DoPrint();
}
// END Log 54822

document.body.onload=Init
