
function BodyLoadHandler(){
	InitUserInfo();		
	InitPage();
	SetBEnable();
	SetStatus();
	//alertShow(document.title);
	//document.title="-adsfa"
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("Loc^OutType^ToDept","N");
	Muilt_LookUp("Loc^OutType^ToDept");
}
function LocDR(value)
{
	GetLookUpID("LocDR",value);
}

function GetToDept(value)
{
	GetLookUpID("ToDeptDR",value);
}

function GetOutType(value)
{
	GetLookUpID("OutTypeDR",value);
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