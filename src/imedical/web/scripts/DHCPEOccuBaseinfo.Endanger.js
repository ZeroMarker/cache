//DHCPEOccuBaseinfo.Endanger.js
function BodyLoadHandler() {
		
}
function SaveEndanger()
{
	var Str="",StrDesc=""
	var inputs = document.getElementsByTagName("input");
	for(var i=0;i<inputs.length;i++){
  		var obj = inputs[i];
  		if(obj.type=='checkbox'){
	  		if(obj.checked) { 
	  		Str=Str+"^"+obj.id;
	  		if(StrDesc=="") StrDesc=obj.name;
	  		else StrDesc=StrDesc+","+obj.name;
	  		}
  		}
	}
	
	var PreIADM=""
	obj=document.getElementById("PreIADM");
	if (obj) {PreIADM=obj.value;}
	var info=tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccu",PreIADM,Str);
	if(info<=0)
	{alert(info);}
	else
	{
		var obj=opener.document.getElementById("HarmInfo")
		
		if(obj) obj.value=StrDesc
		window.close()
	}
}
document.body.onload = BodyLoadHandler;