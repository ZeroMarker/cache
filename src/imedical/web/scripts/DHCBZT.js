function BodyLoadHandler() {
	var GetPatInfoObj=document.getElementById('patno');	
	if (GetPatInfoObj) GetPatInfoObj.onkeydown=GetPatInfo_Click
	
}
function GetPatInfo_Click()
{

	
	if (window.event.keyCode==13) 
	{
	
		var PatNo=document.getElementById('patno').value
		//var GetPatObj=document.getElementById('GetInfo1');
		var GetPatObj=document.getElementById('GetInfo');
        if (GetPatObj) { var encmeth=GetPatObj.value} else { var encmeth=''};
        
        
        //var PatInfo=cspRunServerMethod(encmeth,PatNo)
       cspRunServerMethod(encmeth,'RetVal',PatNo)
        //PatInfo=PatInfo.split("^")
       //
        //document.getElementById('patname').value=PatInfo[0]
     
        //document.getElementById('patsex').value=PatInfo[1]
        //alert(4)
        
	}

}
function RetVal(value)
{
	//alert(value)
	var PatInfo=value.split("^")	
	document.getElementById('patname').value=PatInfo[0]
     
    document.getElementById('patsex').value=PatInfo[1]
}
	//alert(5)
document.body.onload = BodyLoadHandler;	
