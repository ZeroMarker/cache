function BodyLoadHandler()
{

	var obj=document.getElementById("Find");
	if(obj) obj.onclick=Find_Onclick;
}

function Find_Onclick()
{
	var EDate="",SDate="";
	var obj=document.getElementById("EDate");
	if (obj) EDate=obj.value;                
	
	var obj=document.getElementById("SDate");   
	if (obj) SDate=obj.value;                   
	
	var obj=document.getElementById("BedId");
	if (obj) Bed=obj.value;
	
	var obj=document.getElementById("WardId");
	if (obj) Ward=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedICURepList" + "&SDate=" + SDate+"&EDate="+EDate+"&Ward="+Ward+"&Bed="+Bed;
  parent.frames[1].location.href=lnk;	
	
}

function SetWardRoomId(Str)
{
	var WardId=document.getElementById('WardId');
	var tem=Str.split("^");
	WardId.value=tem[1];
}

function SetBedId(Str)
{
	var BedId=document.getElementById('BedId');
	var tem=Str.split("^");
	BedId.value=tem[1];
}
document.body.onload=BodyLoadHandler;