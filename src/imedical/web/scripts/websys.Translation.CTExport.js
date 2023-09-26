// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 14.02.07

function DocumentLoadHandler() {
    var obj=document.getElementById('Import');
    if (obj) obj.onclick=ImportClickHandler;
    var obj=document.getElementById('Export');
    if (obj) obj.onclick=ExportClickHandler;
}

function ImportClickHandler() {
	var output=document.getElementById("output")
	if (output) output.innerText=t["Importing"];
	var obj=document.getElementById("Export");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	Import_click();
}

function ExportClickHandler() {
	var output=document.getElementById("output")
	if (output) output.innerText=t["Exporting"];
	var obj=document.getElementById("Import");
	if (obj) {
		obj.disabled=true;
		obj.onclick=LinkDisable;
	}
	Export_click();
}

function LinkDisable() {
	return false;
}

document.body.onload=DocumentLoadHandler;