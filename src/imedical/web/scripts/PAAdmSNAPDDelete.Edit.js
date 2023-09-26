// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SNAPDeleteLoadHandler() {
	alert("body loader3");
	
}

function Delete3ClickHandler() {
	alert("delete3");
	var TWKFL=document.getElementById('TWKFL').value;
	var TWKFLI=document.getElementById('TWKFLI').value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var PatientID=document.getElementById('PatientID').value;
        //Log 59598 - BC - 30-06-2006 : Change statusbar variable (status=) to display the status bar (=yes).
	if (TWKFL=="") {window.location('paadmsnapepnew.csp?PatientID="+PatientID+"&PARREF="+EpisodeID+"&EpisodeID="+EpisodeID','','"top=30,left=20,width=800,height=600,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"');}
	if (TWKFL!="") {
	window.location('websys.csp?PatientID="+PatientID+"&PARREF="+EpisodeID+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI','','"top=30,left=20,width=800,height=600,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes"');
			}
	return false;
}

document.body.onload=SNAPDeleteLoadHandler;
