function BodyLoadHandler()
{    
	var obj=document.getElementById('BtUpdate');
	if (obj) {obj.onclick=BtUpdateClick;}
}
function BtUpdateClick()
{    
	var obj=document.getElementById('UpdateRejectStatus');
	if (obj)
	{
		var EpisodeID=document.getElementById('EpisodeID').value;
		var resStr=cspRunServerMethod(obj.value,EpisodeID);
		alert(resStr)
	  window.close();
	}
}
document.body.onload = BodyLoadHandler;