function BodyLoadHandler() {
	var close=document.getElementById("Close");
	if(close)	close.onclick=CloseClickHandler;
}

function CloseClickHandler() {
	var obsfldid=document.getElementById("ObsFldId");
	var obsval=document.getElementById("OBSValue");
	if(obsfldid && obsval && window.opener) {
		if(obsfldid!="") {
			var parobs=window.opener.document.getElementById(obsfldid.value);
			if(parobs) parobs.value=obsval.value;
		}
	}
	window.close();
}

document.onload=BodyLoadHandler();