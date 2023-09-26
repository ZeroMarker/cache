// DHCPEWarnInfoFind.js
var CurrentSel=0;
function BodyLoadHandler() {

	var obj;


	obj=document.getElementById("BFind");
	if (obj){ obj.onclick=BFind_click; }

	
}

function BFind_click() {
	
	var obj;
	var iDateFrom="";
	var iDateTo="";
	var iLevel="";


	obj=document.getElementById("DateFrom");
	if (obj){ iDateFrom=obj.value; }

	obj=document.getElementById("DateTo");
	if (obj){ iDateTo=obj.value; }

	obj=document.getElementById("ILLLevel");
	if (obj){ iLevel=obj.value; }	

	alert(iLevel)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+'DHCPEWarnInfoFind'
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&ILLLevel="+iLevel
		
	;
	location.href=lnk;
}

document.body.onload = BodyLoadHandler;




