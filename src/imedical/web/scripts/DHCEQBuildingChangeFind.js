///Created By HZY 2013-7-15
///房屋改建,扩建

function BodyLoadHandler(){		
	InitPage();
	SetStatus();
	SetChangeType()
}

function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
function SetChangeType()
{
	SetElement("ChangeType",GetElementValue("GetChangeType"))
}
function InitPage()
{
}


document.body.onload = BodyLoadHandler;