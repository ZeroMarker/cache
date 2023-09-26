/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.ContQueryArcim.Qry.js

AUTHOR: ZF , Microsoft
DATE  : 2007-7

COMMENT: DHC.WMR.ContQueryArcim.Qry

============================================================================ */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";
function initEvent()
{
	document.getElementById("txtAlias").onkeydown=AliasOnKeyDown;
	document.getElementById("cmdQuery").onclick=Query_click;
	document.getElementById("cmdAdd").onclick=Add_click;
	iniForm();
}

function AliasOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	DisplayResult();
	document.getElementById("txtAlias").focus();
}

function DisplayResult()
{
	var Alias=document.getElementById("txtAlias").value;
	var ContSubRowId=document.getElementById("ContSubRowId").value;
	
	var lnk="dhc.wmr.contsubarcim.csp?"+"&ContSubRowId="+ContSubRowId+"&Alias=" + Alias;
    parent.location.href=lnk;
}

function iniForm()
{
	var obj=document.getElementById("ContSubRowId");
	if (obj){obj.value=GetParam(parent,"ContSubRowId");}
}

function Add_click()
{
	var cContSubRowId="";
	
	var obj=document.getElementById("ContSubRowId");
	if (obj){cContSubRowId=obj.value;}
	else{cContSubRowId=""}
	if (cContSubRowId=="") return;
	
	var objtbl=document.getElementById("tDHC_WMR_ContQueryArcim_Qry");
	for (var i=1;i<objtbl.rows.length;i++)
	{
		var cArcimRowId="";
		var obj=document.getElementById("chkSelectz"+i)
		if (obj){
			if (obj.checked==true){
				cArcimRowId=document.getElementById("ArcimRowIdz"+i).value;
			}
		}
		if (cArcimRowId!=""){
			var Condition=cContSubRowId+"^^"+cArcimRowId;
	    	var obj=document.getElementById("MethodUpdateContSubArcim");
    		if (obj) {var encmeth=obj.value} else {var encmeth=''}
    		var Id=cspRunServerMethod(encmeth,Condition);
    		Temp=Id.split("||")
	    	if (Temp[0]=-3){
		    	//alert(t['AddDataFalse1']+"--"+cArcimRowId);
		    }else{
			    if ((Temp[0]<1)&&(Temp[0])!=-3){alert(t['AddDataFalse2']);}
			}
		}
	}
	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSubArcim.List" + "&ContSubRowId="+cContSubRowId;
	parent.RPtop.location.href=lnk;
}

function Query_click()
{
	var cAlias="";
	var obj=document.getElementById("txtAlias");
	if (obj){cAlias=Trim(obj.value);}
	else{cAlias=""}
	
	if (cAlias=="") return;
    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContQueryArcim.Qry" + "&Alias="+cAlias;
	parent.RPbottom.location.href=lnk;
}

initEvent();
