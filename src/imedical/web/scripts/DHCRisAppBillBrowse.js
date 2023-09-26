
function BodyLoadHandler()
 {	
   
   var OEOrdItemID=document.getElementById("OEOrdItemID").value;
   var GetAppBillFunction=document.getElementById("GetAppBillContent").value;
	var Content=cspRunServerMethod(GetAppBillFunction,OEOrdItemID);
	
	var SplitCode=String.fromCharCode(1);
	var CRCode=String.fromCharCode(13)+String.fromCharCode(10)
	Content=Content.replace(SplitCode,CRCode);
	document.write(Content);
	document.close(); //
	if (Content=="")
	{
		alert(t["HaveNotApp"]);
	}

 }
 


document.body.onload = BodyLoadHandler;