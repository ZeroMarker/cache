
function BodyLoadHandler() {
	var objtbl=document.getElementById('tDHC_Med_IPBook_List');
	for (var i=1;i<objtbl.rows.length;i++)
	{
	   var objReport=document.getElementById("Reportz"+i);
	   if(objReport) objReport.onclick=btnReportOnClick;
	}
	window.parent.frames["RPTop"].document.getElementById("opcardno").focus();
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
function btnReportOnClick()
{
	var selectrow=DHCWeb_GetRowIdx(window);
	var OPAdm=document.getElementById("OPAdmz"+selectrow).value;
	var state=document.getElementById("CurrentStatez"+selectrow).innerText
	if(state!="预约") 
	{
		alert("非预约,不能报到!");
		return;
	}
	/*var objChekCard=document.getElementById("CheckCardIsTemp")
	if(objChekCard)
	{
		var retStr=cspRunServerMethod(objChekCard.value,OPAdm)
		if(retStr=="1")
		{
			alert("临时卡不能报到!")
			return;
		}
	}*/
	var lnk="dhc.med.ipbooknew.csp?EpisodeID="+OPAdm+"&IPBKFlag=Register"
	window.open(lnk,"Register","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,top=50,left=50,width=1000,height=810");
}
document.body.onload = BodyLoadHandler;