/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.List.js

AUTHOR: ZF , Microsoft
DATE  : 2007-3-18

COMMENT: DHC.WMR.WorkFlow.List

========================================================================= */
function BodyLoadHandler()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=Query_click;}
	iniForm();
}
function iniForm()
{
	var obj=document.getElementById("lsType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.selectedIndex=0;
		}
	
}
function Query_click()
{
	var cType="No",cActive="",cDate="";
	var obj=document.getElementById("lsType");
	if (obj){
		if (obj.options.length==0){return;}
		var Idx=obj.options.selectedIndex;
		if (Idx==-1){return;}
		var cType=obj.options[Idx].value;
		}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.WorkFlow.List" + "&Type=" +cType+"&Active="+cActive+"&Date="+cDate;
    location.href=lnk;
}

function SelectRowHandler()	{
	var txtRowid=""
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){return};
	var SelRowObj=document.getElementById('Rowidz'+selectrow);
	if (SelRowObj){txtRowid=SelRowObj.innerText;}
	else{txtRowid="";}
	var obj=document.getElementById("txtRowid");
	if (obj){
		obj.value=txtRowid;
		}
}
//BodyLoadHandler();
///document.body.onload = BodyLoadHandler();