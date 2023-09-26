// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var epId=document.getElementById("EpisodeID");
var conEpId=document.getElementById("ConsultEpisodeID");
if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
	var objNew=document.getElementById("compnew1");
	if(objNew){
		objNew.disabled=true;
		objNew.onclick=LinkDisable;
	}
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) {
		return false;
	}
	return true;
}
