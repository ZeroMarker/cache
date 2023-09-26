

function initForm()
{
	var objtbl=document.getElementById("tDHC_WMR_AdmitIP_List");
	for (var i=1;i<objtbl.rows.length;i++){
		document.getElementById("AdmitIPz"+i).onclick = AdmitIP_click;
	}
}


function AdmitIP_click()
{
	var Paadm="",BregRowid="";
	var Ind=window.event.srcElement.id.replace("AdmitIPz", "");
	var objAdm=document.getElementById("lsPaadmz" + Ind);
	if (objAdm){
		var Idx=objAdm.options.selectedIndex;
		if (Idx==-1){return;}
		Paadm=objAdm.options[Idx].value;
	}
	var objBreg=document.getElementById("BregRowidz" + Ind);
	if (objBreg){
		BregRowid=objBreg.value;
	}
	
	if ((Paadm=="")||(BregRowid=="")) {
		//alert("Err:Paadm is null");
		return false;
	}
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmitVisit" + "&EpisodeID="+Paadm + "&BregRowid="+BregRowid;
	window.open(lnk,null,'height=600,width=850,status=yes,toolbar=no,menubar=no,location=no'); 
	return false;
}

initForm();