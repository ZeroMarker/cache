// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//log 56840

function CareProvLookUpHandler(txt) {
	if (txt) {
		//alert (txt);
		var adata=txt.split("^");
		var obj=document.getElementById("CareProviderDR");
		if (obj) obj.value=adata[1];
	}
}

var ExecutedByObj=document.getElementById("CTPCPDesc");
if (ExecutedByObj) ExecutedByObj.onclick=CareProvLookUpHandler;