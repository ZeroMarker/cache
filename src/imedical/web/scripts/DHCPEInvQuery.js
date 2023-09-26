//“≥√Ê≥ı ºªØ

function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("Find");
	if (obj) obj.onclick=Find_Click;
	obj=document.getElementById("Refund");
	if (obj) obj.onclick=Refund_Click;
}



function Find_Click()
{	
	RefreshInvList();	
}

function Refund_Click()
{	
alert ('b');
	
}

function RefreshInvList()
{
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCPEInvList';
	var lnk=lnk+"&InvNo="+GetCtlValueById("InvNo")
	parent.frames["DHCPEInvList"].location.href=lnk;
}


document.body.onload = BodyLoadHandler;