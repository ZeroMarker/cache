

function BodyLoadHandler(){		
	InitPage();	
	var Type=GetElementValue("Type");
	var WaitAD=GetElementValue("WaitAD");
	InitPage();
	SetBEnable();
	var GetStatu=GetElementValue("GetStatu");
	SetStatus();
	var Status=GetElementValue("Status");

	Muilt_LookUp("WashLoc^Washer");
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"));
	//alertShow(Status);
}
function InitPage()
{
	KeyUp("WashLoc^Washer");
}

function GetWasher (value)//2014-05-23 qw lookup 可以自己写
{
    //GetLookUpID("WasherDR",value);
    var val=value.split("^");
	var obj=document.getElementById("WasherDR");
	if (obj)	
	{	obj.value=val[6];
	    var Washer=document.getElementById("Washer");
	    Washer.value=val[2];
	}
	else {alertShow(ename);}
}

function GetLoc(value)//2014-05-23 qw
{
	GetLookUpID("WashLocDR",value);
}

function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}

document.body.onload = BodyLoadHandler;