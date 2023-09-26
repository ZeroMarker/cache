function InitFrom()
{
	var obj=document.getElementById("ALocDesc");
	if (obj){obj.onchange=txtLocDesc_onChange;}
	var obj=document.getElementById("ADoctorDesc");
	if (obj){obj.onchange=txtDoctorDesc_onChange;}
	var obj=document.getElementById("btnSearch");
	if (obj){obj.onclick=btnSearch_onClick;}
}

function txtLocDesc_onChange()
{
	setElementValue("ALocID","");
	setElementValue("ADoctorID","");
	setElementValue("ADoctorDesc","");
}

function txtDoctorDesc_onChange()
{
	setElementValue("ADoctorID","");	
}

function GetLoc(str)
{
	var tmpList=str.split("^");
	setElementValue("ALocID",tmpList[0]);
	setElementValue("ALocDesc",tmpList[1]);
}

function GetDoctor(str)
{
	var tmpList=str.split("^");
	setElementValue("ADoctorID",tmpList[0]);
	setElementValue("ADoctorDesc",tmpList[2]);	
}

function btnSearch_onClick()
{
	var LocID=getElementValue("ALocID",null);
	//var LocDesc=getElementValue("ALocDesc",null);
	var DoctorID=getElementValue("ADoctorID",null);
	//var DoctorDesc=getElementValue("ADoctorDesc",null);
	var FromDate=getElementValue("AFromDate",null);
	var EndDate=getElementValue("AEndDate",null);
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.Message.List&ALocID="+LocID+"&ADoctorID="+DoctorID+"&AFromDate="+FromDate+"&AEndDate="+EndDate;
	parent.frames(1).location.href=lnk;	
}

InitFrom();