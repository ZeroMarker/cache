var statCode="";
var ctcpId="";
var regNo="";
var EpisodeID="";
function BodyLoadHandler()
{
    var startDate=document.getElementById("startDate");
    var endDate=document.getElementById("endDate");
    var today=document.getElementById("getToday").value; //ypz 061127
    if (startDate.value=="") {startDate.value=today;}
    if (endDate.value=="") {endDate.value=today;}
    
    var obj=document.getElementById("schbtn");
    if (obj) {obj.onclick=SchClick;}
    
}
function SchClick()
{
	var startDate=document.getElementById("startDate").value;
	var endDate=document.getElementById("endDate").value;
	var sessloc=session['LOGON.CTLOCID'];
	var regNo="";
	var obj=document.getElementById("regNo");
	if (obj) { regNo=obj.value;	}
	var ctlocDesc="";
	var obj=document.getElementById("ctlocDesc")
	if (obj) ctlocDesc=obj.value;
	
	var userLocId=session['LOGON.CTLOCID']
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCICUStat&startDate="+startDate+"&endDate="+endDate+"&ctlocId="+userLocId+"&regNo="+regNo+"&ctcpId="+ctcpId+"&ctlocDesc="+ctlocDesc;
 	window.location.href=lnk; 
}

 function SelectRowHandler()
 {
    var i;
    var selrow=document.getElementById("selrow");
    if (selrow<1) return;
 }
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
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

function GetCtcp(str)
{
	var strList=str.split("^");
	ctcpId=strList[1];
}
document.body.onload = BodyLoadHandler;
