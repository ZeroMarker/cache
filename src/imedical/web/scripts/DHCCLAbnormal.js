var EpisodeID=document.getElementById("EpisodeID").value;
function BodyLoadHandler()
{	
	if (EpisodeID!="")
    { 
		var objGetPNameRegNo=document.getElementById("GetPNameRegNo");
        if (objGetPNameRegNo){
			var retVal=cspRunServerMethod(objGetPNameRegNo.value,EpisodeID);  
			var tmpRetVal=retVal.split("^");
			var objpatRegNo=document.getElementById("patRegNo");
			if (objpatRegNo){objpatRegNo.value=tmpRetVal[1];}
        }
    }
    if (EpisodeID=="") return;
    var userId=session['LOGON.USERID'];
    var GetUserType=document.getElementById("GetUserType").value;
    var UserType=cspRunServerMethod(GetUserType,userId);
    if(UserType=="DOCTOR"){					
		var objWardID=document.getElementById("WardID");
		var objGetPatWard=document.getElementById("GetPatWard");
		if (objGetPatWard){
			var retStr=cspRunServerMethod(objGetPatWard.value,EpisodeID);
			var tempStr=retStr.split("^");
			if (tempStr[0]!="") objWardID.value=tempStr[0];
			}	
	}
	var objtbl=document.getElementById('tDHCCLAbnormal');
    for (i=1;i<objtbl.rows.length;i++)
	{
    	var item=document.getElementById("ordStatDescz"+i);
		if(item.innerText.indexOf("ֹͣ")!=-1)
	   	{
		   item.style.color="red";
	   	}
 	}
}
function GetPatRegNo(Str)
{
	var tempStr=Str.split("^");			
	var objEpisodeID=document.getElementById("EpisodeID");
	if (tempStr[3]!=""){objEpisodeID.value=tempStr[3];}
	var objpatRegNo=document.getElementById("patRegNo");
	if (tempStr[0]!=""){objpatRegNo.value=tempStr[0];}
}
document.body.onload = BodyLoadHandler;