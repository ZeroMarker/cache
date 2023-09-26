//DHCRisQueryRejectReason.JS
//
var HL7Obj;
function BodyLoadHandler()
{
	var EpisodeID=document.getElementById("EpisodeID").value;
    var OEOrdItemID=document.getElementById("OEOrdItemID").value;
    var GetRejectAppInfoFunction=document.getElementById("QueryRejectAppInfo").value;
    var value=cspRunServerMethod(GetRejectAppInfoFunction,OEOrdItemID);
	if (value!="")
	{
		//OeOrditemID_"^"_LocName_"^"_User_"^"_Reason_"^"_$g(RJDate)_"^"_$g(RJTime)
		var item=value.split("^");
		document.getElementById("LocName").value=item[1];
		document.getElementById("RejAppUser").value=item[2];
		document.getElementById("Reason").value=item[3];
		document.getElementById("RJDate").value=item[4];
		document.getElementById("RJTime").value=item[5];
	}
	
}



document.body.onload = BodyLoadHandler;