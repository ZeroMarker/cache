//add by zy 2015-08-25 ZY0136
function BodyLoadHandler() 
{
	InitUserInfo();	
	var StatusDR=GetElementValue("StatusDR");
	if (StatusDR>0)
	{
		HiddenObj("BNew",1)
	}
}

document.body.onload = BodyLoadHandler;