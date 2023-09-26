/// DHCEQAInMoveFind.js
function BodyLoadHandler()
{
	SetElement("Type",GetElementValue("GetType"));
	if (GetElementValue("GetType")=="") SetElement("Type",0);
}

document.body.onload = BodyLoadHandler;