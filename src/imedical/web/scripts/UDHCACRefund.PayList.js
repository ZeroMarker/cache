///UDHCACRefund.PayList.js

function BodyLoadHandler()
{
	document.onkeydown = DHCWeb_EStopSpaceKey;
}

function SelectRowHandler() {
	//fdfd
	//myrow+=1;
	
}

function SetACRefOrder(ReceipRowid)
{
	///ReceipRowid
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPRefund.Order&ReceipRowid=" + ReceipRowid;
	var PayOrdList=parent.frames["udhcOPRefund_Order"];
	PayOrdList.location.href=lnk;
}


document.body.onload=BodyLoadHandler;
