///Created By HZY 2013-7-15
///���ݸĽ�,����

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