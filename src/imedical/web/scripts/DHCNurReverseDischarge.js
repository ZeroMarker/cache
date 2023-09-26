function BodyLoadHandler()
{
	var EpisodeID=document.getElementById("EpisodeID").value;
 var finalObj=document.getElementById("getFinalStat");
 if (finalObj)
 {
	 finalObj=finalObj.value
	 var resStr=cspRunServerMethod(finalObj,EpisodeID)
	 if(resStr!="0"){
		 alert(resStr)
		 var obj=document.getElementById("update1");
			if (obj) {
				obj.style.visibility="hidden";
			}
	 }
 }
}
document.body.onload = BodyLoadHandler;