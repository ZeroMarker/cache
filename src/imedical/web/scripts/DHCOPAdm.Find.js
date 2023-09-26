document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {
	//¶Á¿¨
	var obj=document.getElementById('InvoiceNo');
	if (obj) obj.onkeydown=InvoiceNoKeydownHandler;
}

function InvoiceNoKeydownHandler(e){
	var keycode=websys_getKey(e)
	if (keycode==13){
		var InvoiceNo=DHCC_GetElementData('InvoiceNo');
		if (InvoiceNo!=""){Find_click();}
	}
}

document.onkeydown=documentkeydown;
function documentkeydown(e) { 
	var keycode;
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	//F9
	if (keycode==118){
		Find_click();
	}else{
		websys_sckey(e)
	}
}