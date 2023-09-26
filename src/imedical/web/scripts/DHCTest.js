function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('PatNo');	
	if (GetPatInfoObj) 
	GetPatInfoObj.onkeydown=GetPatInfo_Click
	else
	alert(t['01'])
}
function GetPatInfo_Click()
{
	if (window.event.keyCode==13) 
	{
		var PatNo=document.getElementById('PatNo').value
		var GetPatObj=document.getElementById('GetPatInfo');
        if (GetPatObj) {var encmeth=GetPatObj.value} else {var encmeth=''};
        
        
        var PatInfo=cspRunServerMethod(encmeth,PatNo)
       
        PatInfo=PatInfo.split("^")
        document.getElementById('PatName').value=PatInfo[0]
        document.getElementById('PatSex').value=PatInfo[1]
	}
}
document.body.onload = BodyLoadHandler;	
