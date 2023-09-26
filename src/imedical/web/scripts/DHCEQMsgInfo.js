var tmp=1;
var counter=0;
var times=0;

function BodyLoadHandler()
{
	while(tmp){
    	setTimeout("Run",50);
    	times=times+1;
    	if (times>100) tmp=0;
    }
}

function SetInfo()
{
	SetCElement("cEQTitle",GetElementValue("GetTitle"))
	SetCElement("cInfo",GetElementValue("GetInfo"))
}

function Run()
{
	if (counter<10)
	{ 
		counter=counter+1;
		SetCElement("cRunning",GetCElementValue("cRunning")+".")
	}
	else
	{
		counter=0;
		SetCElement("cRunning","")
	}
}



document.body.onload = BodyLoadHandler;