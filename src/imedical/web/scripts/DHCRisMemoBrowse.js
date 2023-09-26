//DHCRisMemoBrowse.js
//sunyi 2012-03-19

function BodyLoadHandler()
{
    var OEOrdItemID=document.getElementById("OEOrdItemID").value;
    var GetMemoFun=document.getElementById("GetMemoFun").value;
    var value=cspRunServerMethod(GetMemoFun,OEOrdItemID);
    
    if(value!="")
    {
	    value=ReplaceInfo(value);
	}
	
	document.getElementById("Memo").value=value;

}

function ReplaceInfo(Strtmp)
{
   Info=Strtmp.replace(new RegExp("X000b","g"),"\r");
   Info=Info.replace(new RegExp("X000a","g"),"\n");
   return Info ;
}

document.body.onload = BodyLoadHandler;