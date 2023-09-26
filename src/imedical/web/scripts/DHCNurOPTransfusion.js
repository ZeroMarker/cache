//DHCNurOPTransfusion.JS
function BodyLoadHandler()
{
	var LocId=session['LOGON.CTLOCID'];
	var obj=document.getElementById("CTLOCID");
	if (obj) obj.value=LocId;
	var objGetLocDesc=document.getElementById("getLocDesc");
	if (objGetLocDesc){
    	var retloc=cspRunServerMethod(objGetLocDesc.value,LocId);  
		var objCTLOC=document.getElementById("CTLOC");
		if (objCTLOC) objCTLOC.value=retloc; 
	}
}

document.body.onload = BodyLoadHandler;