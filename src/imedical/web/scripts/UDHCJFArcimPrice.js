//UDHCJFArcimPrice
var typeobj
function BodyLoadHandler() {
	typeobj=document.getElementById('OrdType');
	typeobj.onkeydown=gettype;
	
	var tbl=document.getElementById("tUDHCJFArcimPrice");
	if(tbl) tbl.ondblclick=TblDblClick;
	
}
function TblDblClick()	{
	
	var eSrc=window.event.srcElement;
	Objtbl=document.getElementById('tUDHCJFArcimPrice');
	Rows=Objtbl.rows.length;
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	var SelRowObj=document.getElementById('TArcimz'+selectrow);
	var curarcim=SelRowObj.value;
	var UserGroupID=session['LOGON.GROUPID'];
	var ret=tkMakeServerCall('web.DHCDocOrderEntry','AddControl',curarcim,UserGroupID);
    if (ret==1)
	{
		alert("护士没有此项权限，请重新选择")
		return false;
	}
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFItmPrice&arcim='+curarcim;
	if (parent.frames['UDHCJFItmPrice']) parent.frames['UDHCJFItmPrice'].location.href=lnk;
	
	if (window.name=="UDHCJFArcimPrice"){
		var Parobj=window.opener
		Parobj.PACSArcimFun(curarcim);
	}
}
function gettype()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  OrdType_lookuphandler();
	
		}
	}
document.body.onload=BodyLoadHandler;