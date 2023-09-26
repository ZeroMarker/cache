////UDHCACFinBR.AccFootQuery.js

function DocumentLoadHandler() 
{
	var obj=document.getElementById("BClear");
	if (obj)
	{
		obj.onclick=Refresh;
	}

}


function Refresh(){
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCACFinBR.AccFootQuery";
}

document.body.onload=DocumentLoadHandler;

