function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('patno');	
	if (GetPatInfoObj) GetPatInfoObj.onkeydown=GetPatInfo_Click
	
}
function GetPatInfo_Click()
{

	
	if (window.event.keyCode==13) 
	{
	
		var PatNo=document.getElementById('patno').value
		var GetPatObj=document.getElementById('patnameno');
        if (GetPatObj) { var encmeth=GetPatObj.value} else { var encmeth=''};
        
 
       cspRunServerMethod(encmeth,'RetVal',PatNo)

        
	}

}
function RetVal(value)
{

	var PatInfo=value.split("^")	
	document.getElementById('patname').value=PatInfo[0]
     
    document.getElementById('patsex').value=PatInfo[1]
}
document.body.onload = BodyLoadHandler;	
