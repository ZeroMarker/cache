// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 22.08.06 59768

function BodyLoadHandler() {
	var objlist=document.getElementById("FollowupOrderList");
	var objFollowup=document.getElementById("CONSFollowupOrderDR");
	var objOrderLink=document.getElementById("OrderDetails");
	var objdef=document.getElementById("FollowupDefaults");

	if (objOrderLink) {
		objOrderLink.disabled=true;
		objOrderLink.onclick=LinkDisable;
	}
	if (objlist) objlist.multiple=false;

	// disable fields if followup order already placed

	if ((objFollowup)&&(objFollowup.value!="")) {
		DisableField("FollowupIn");
		DisableField("FollowupUnit");
		DisableLookup("ld2241iFollowupUnit");
		if (objlist) objlist.disabled=true;
		if (objOrderLink) {
			objOrderLink.disabled=false;
			objOrderLink.onclick=FollowupOrderDetails;
		}
	}

	// select default followup order as defined in vb code table
 	if ((objdef)&&(objlist)&&(objdef.value!="")&&(!objlist.disabled)) {
		objdef=objdef.value.split("^");
		for (var i=0; i<objlist.length; i++) {
			if (objdef[i]=="Y") objlist.options[i].selected=true;
		}
	}

	var epId=document.getElementById("EpisodeID");
	var conEpId=document.getElementById("ConsultEpisodeID");
	if(epId && conEpId && conEpId.value!="" && conEpId.value!=epId.value){
		var objUpdate=document.getElementById("update1");
		if(objUpdate){
			objUpdate.disabled=true;
			objUpdate.onclick=LinkDisable;
		}
		if(objOrderLink){
			objOrderLink.disabled=true;
			objOrderLink.onclick=LinkDisable;
		}
	}
}

function FollowupOrderDetails()
{
	var orderId=document.getElementById("CONSFollowupOrderDR");
	var episodeId=document.getElementById("EpisodeID");
	var patientId=document.getElementById("PatientID");
	var arcim=document.getElementById("arcimid");
	var context=document.getElementById("Context");

	if (orderId && episodeId && patientId && arcim && context) {
		var linkUrl="oeorder.mainloop.csp?ID="+orderId.value+"&EpisodeID="+episodeId.value+"&OEORIItmMastDR="+arcim.value+"&PatientID="+patientId.value+"&CONTEXT="+context.value+"&Mode=READONLY&CantModifyToothFlag=Y";
		websys_lu(linkUrl);
		return false;
	}
	return false;
}  // FollowupOrderDetails

document.body.onload=BodyLoadHandler;
