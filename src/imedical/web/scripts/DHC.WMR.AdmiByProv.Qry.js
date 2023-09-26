function BodyLoadHandler()
{
    var obj=document.getElementById("cmdQuery");
	if (obj) obj.onclick=Query_click;
}

function Query_click()
{
	var FromDate="",ToDate=""
	var obj=document.getElementById("txtFromDate");
	if (obj){FromDate=obj.value;}
	var obj=document.getElementById("txtToDate");
	if (obj){ToDate=obj.value;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.AdmiByProv.List&FromDate="+FromDate+"&ToDate="+ToDate;
    parent.RPbottom.location.href=lnk;
}

document.body.onload = BodyLoadHandler;