//DHCRisToDayOrder.JS
//

function BodyLoadHandler()
{
	var EpisodeID=document.getElementById("EpisodeID").value;
    var GetPatientInfoFunction=document.getElementById("GetPatientInfo").value;
    var value=cspRunServerMethod(GetPatientInfoFunction,EpisodeID);
	if (value!="")
	{
		var item=value.split("^");
		document.getElementById("Name").value=item[0];
		document.getElementById("Sex").value=item[1];
		document.getElementById("RegNo").value=item[2];
		document.getElementById("DOB").value=item[3];
	}   document.getElementById("Age").value=item[4];
    
}



document.body.onload = BodyLoadHandler;