var cashierPaymode;
var cashierMin;


function BodyLoadHandler()
{
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=BOK_Click;
	obj=document.getElementById("BCancel");
	if (obj) obj.onclick=BCancel_Click;
	obj=document.getElementById("PayMode");
	if (obj) 
	{	obj.onkeydown=PayMode_KeyDown;
		obj.onchange=PayMode_KeyUp;
	}
	var list=GetCtlValueById("CashierInfo");
	list=list.split("^");
	cashierPaymode=list[0];
	cashierMin=list[1];
}

function PayMode_KeyUp()
{
	var objDR=document.getElementById("PayModeDR");
	objDR.value="";	
}

function PayMode_KeyDown()
{
	if (event.keyCode==13)
	{
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.Cashier:GetPayMode&P1=1";
		url += "&TLUJSF=SetPayMode";
		websys_lu(url,1,'');
		return websys_cancel();
	}
}

function BOK_Click()
{
	var result=GetResult();
	if (result=="") return;
	window.returnValue=result;
	window.close();
}

function GetResult()
{
	var payamout=GetCtlValueById("PayAmount");
	var paymodedr=GetCtlValueById("PayModeDR");
	var payno=GetCtlValueById("PayModeNo");
	
	if ((""==paymodedr)||(""==GetCtlValueById("PayMode")))
	{
		alert(t['NoPayMode']);
		return "";
	}
	if (paymodedr==cashierPaymode)
	{
		if (parseFloat(payamout)>parseFloat(cashierMin))
		{
			alert (t['ExtraAmount']);
			return "";
		}
	}
	payamout=(-1)*payamout;
	
	return paymodedr+","+payamout+","+payno;
}

function BCancel_Click()
{
	window.returnValue="";
	window.close();
}

function SetPayMode(value)
{
	var list=value.split("^");
	SetCtlValueById("PayMode",list[0],0);
	SetCtlValueById("PayModeDR",list[1],0);
}

document.body.onload = BodyLoadHandler;