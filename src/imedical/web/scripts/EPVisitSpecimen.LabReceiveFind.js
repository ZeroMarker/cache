// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// PLEASE NOTE: For Log 30322, I have just done a COPY of the existing work, without any common functions.
// 		This was done because problems arose when creating common functions, and log was Critical for Site.

// Log 27900 - AI - 25-10-2002 : Gloal string for the string of characters (Lab Episode ID).
var chstring="";
// end Log 27900

// Log 30322 - AI - 25-11-2002 : Gloal string for the string of characters (Placer ID).
var plstring="";
// end Log 30322

// Log 27900 - AI - 25-10-2002 : Created function to accept each character and evaluate accordingly.
function LabEpKeyPressHandler(key) {
	// char 13 = carriage return
	if (websys_getKey(key)==13) {
		GetLabEpisodeNumberFromLabEpisodeID();
		ResetString();
	}
	else {
		chstring=chstring+String.fromCharCode(websys_getKey(key));
	}
}
// end Log 27900

// Log 30322 - AI - 25-11-2002 : Created function to accept each character and evaluate accordingly.
function PlacKeyPressHandler(key) {
	// char 13 = carriage return
	if (websys_getKey(key)==13) {
		GetLabEpisodeNumberFromPlacerID();
		ResetPlString();
	}
	else {
		plstring=plstring+String.fromCharCode(websys_getKey(key));
	}
}
// end Log 30322

// Log 27900 - AI - 25-10-2002 : Created function to reset the character string.
function ResetString() {
	chstring="";
}
// end Log 27900

// Log 30322 - AI - 25-11-2002 : Created function to reset the character string.
function ResetPlString() {
	plstring="";
}
// end Log 30322

// Log 27900 - AI - 25-10-2002 : Added function to get the Lab Episode Number from the scanned-in LabEpisodeID.
function GetLabEpisodeNumberFromLabEpisodeID() {
	var labepid="";
	var labepisodeid=document.getElementById("LabEpisodeID");
	if (chstring!="") {
		labepid=chstring+"|";
	}
	// we want the 2nd piece, delimited by "REQID=". Counting starts at 0.
	if (labepid!="") {
		var labepnostr=mPiece(labepid,"REQID=",1);
		// then we want the 1st piece, delimited by "|". Counting starts at 0.
		if (labepnostr!="") {
			var labepno=mPiece(labepnostr,"|",0);
			if (labepno!="") {
				labepisodeid.value=labepno;
			}
		}
	}
}
// end Log 27900.

// Log 30322 - AI - 25-11-2002 : Added function to get the Lab Episode Number from the scanned-in PlacerID.
function GetLabEpisodeNumberFromPlacerID() {
	var placid="";
	var placerid=document.getElementById("PlacerID");
	if (plstring!="") {
		placid=plstring+"|";
	}
	// we want the 2nd piece, delimited by "REQID=". Counting starts at 0.
	if (placid!="") {
		var placerstr=mPiece(placid,"REQID=",1);
		// then we want the 1st piece, delimited by "|". Counting starts at 0.
		if (placerstr!="") {
			var placno=mPiece(placerstr,"|",0);
			if (placno!="") {
				placerid.value=placno;
			}
		}
	}
}
// end Log 30322.

// Log 27900 - AI - 25-10-2002 : mPiece function copied from other js files to do the splitting of the string.
function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
	delimArray = s1.split(sep);
	//If out of range, return a blank string
	if ((n <= delimArray.length-1) && (n >= 0)) {
		return delimArray[n];
	} else {
		return "";
	}
}
// end Log 27900.


function BodyLoadHandler() {
	// Log 27900 - AI - 17-10-2002 : Set up an OnKeyPress event for the LabEpisodeID field.
	var obj=document.getElementById("LabEpisodeID")
	if (obj) obj.onkeypress = LabEpKeyPressHandler;
	// end Log 27900.
	// Log 30322 - AI - 25-11-2002 : Set up an OnKeyPress event for the PlacerID field.
	var obj=document.getElementById("PlacerID")
	if (obj) obj.onkeypress = PlacKeyPressHandler;
	// end Log 30322.
}

document.body.onload = BodyLoadHandler;
