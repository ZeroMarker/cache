////UDHCACFinBR.AccINVUnPrintQuery.js

function DocumentLoadHandler() {
	var obj=document.getElementById("Clear");
	if (obj){
		obj.onclick=Refresh;
	}
	
}

function Refresh(){
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACFinBR.AccINVUnPrintQuery";
}

document.body.onload=DocumentLoadHandler;

