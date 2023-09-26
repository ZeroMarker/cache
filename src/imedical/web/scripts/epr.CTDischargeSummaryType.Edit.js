// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objDSTEpisodeType=document.getElementById("DSTEpisodeType");
var objSelectedEpisodeTypes=document.getElementById("SelectedEpisodeTypes");
var objDSTExcludeDoctor=document.getElementById("DSTExcludeDoctor");
var objSelectedDoctorTypes=document.getElementById("selectedDoctorTypes");

function DocumentLoadHandler() {

	if (objDSTEpisodeType) objDSTEpisodeType.onchange=SetAdmissionTypes;
	if (objDSTExcludeDoctor) objDSTExcludeDoctor.onchange=SetDoctorTypes;
	if ((objDSTEpisodeType)&&(objSelectedEpisodeTypes)) BuildAdmissionTypes();
	if ((objDSTExcludeDoctor)&&(objSelectedDoctorTypes)) BuildDoctorTypes();

}

// Build the initial selection from the hidden list.
function BuildAdmissionTypes() {
	var str=objSelectedEpisodeTypes.value;
	if (str!="") {
		var lu = str.split(",");
		for(j=0; j<lu.length; j++) {
			for(var k=0; k<objDSTEpisodeType.options.length; k++) {
				if (lu[j]==objDSTEpisodeType.options[k].value) {
					objDSTEpisodeType.options[k].selected=true;
				}
			}
		}
	}
}

// As changes are made to the selection, update the hidden list.
function SetAdmissionTypes() {
	var arrItems = new Array();
	var types="";
	var numberchosen=0;
	if (objDSTEpisodeType) {
		for (var j=0; j<objDSTEpisodeType.options.length; j++) {
			if (objDSTEpisodeType.options[j].selected) {
				numberchosen++;
				types = types + objDSTEpisodeType.options[j].value + ",";
			}
		}
		types=types.substring(0,(types.length-1));
		if (objSelectedEpisodeTypes) objSelectedEpisodeTypes.value=types;
	}
}

// Build the initial selection from the hidden list.
function BuildDoctorTypes() {
	var str=objSelectedDoctorTypes.value;
	if (str!="") {
		var lu = str.split(",");
		for(j=0; j<lu.length; j++) {
			for(var k=0; k<objDSTExcludeDoctor.options.length; k++) {
				if (lu[j]==objDSTExcludeDoctor.options[k].value) {
					objDSTExcludeDoctor.options[k].selected=true;
				}
			}
		}
	}
}

// As changes are made to the selection, update the hidden list.
function SetDoctorTypes() {
	var arrItems = new Array();
	var types="";
	var numberchosen=0;
	if (objDSTExcludeDoctor) {
		for (var j=0; j<objDSTExcludeDoctor.options.length; j++) {
			if (objDSTExcludeDoctor.options[j].selected) {
				numberchosen++;
				types = types + objDSTExcludeDoctor.options[j].value + ",";
			}
		}
		types=types.substring(0,(types.length-1));
		if (objSelectedDoctorTypes) objSelectedDoctorTypes.value=types;
	}
}


document.body.onload = DocumentLoadHandler;
