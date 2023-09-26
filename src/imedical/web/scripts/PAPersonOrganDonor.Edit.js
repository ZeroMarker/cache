// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 27.11.03


function DocumentLoadHandler() {
	// update to reload in the parent frame
	if ((parent)&&(parent.frames)&&(parent.frames["PAPersonOrganDonor_List"])) {
		var frame=document.getElementById("TFRAME");
		if (frame) frame.value=window.parent.name;
	}
	
	var RemoveDonor=document.getElementById("RemoveDonor");
	if (RemoveDonor) RemoveDonor.onclick=RemoveDonorLink;
}

function RemoveDonorLink() {
	var ORGPAPERDR=document.getElementById("ORGPAPERDR");
	if (ORGPAPERDR) ORGPAPERDR.value="";
	var PAPERName=document.getElementById("PAPERName");
	if (PAPERName) PAPERName.innerText="";
	var PAPERName2=document.getElementById("PAPERName2");
	if (PAPERName2) PAPERName2.innerText="";
	var DonorUR=document.getElementById("DonorUR");
	if (DonorUR) DonorUR.innerText="";
}

document.body.onload=DocumentLoadHandler;