///DHCPISSpecimen.js
var paadmdr=""

function BodyLoadHandler()
{	
	//paadmdr=document.getElementById("EpisodeID").value
	//alert(paadmdr)
	/*var FunObj=document.getElementById("ReasonFun").value
	var ReasonINFO=cspRunServerMethod(FunObj,paadmdr)
	//alert(ReasonINFO)
	if(ReasonINFO!="")
	{
		var item=ReasonINFO.split("^")
		document.getElementById("TMROWID").value=item[0]
		document.getElementById("AppDoc").value=item[1]
		document.getElementById("OrderName").value=item[2]
		document.getElementById("Reason").value=item[3]
		document.getElementById("exeDoc").value=item[4]
		document.getElementById("exeDateTime").value=item[5]
	}*/
	
}

document.body.onload = BodyLoadHandler;