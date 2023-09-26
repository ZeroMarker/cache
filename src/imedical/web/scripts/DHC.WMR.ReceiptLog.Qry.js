/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.ReceiptLog.Qry.JS

AUTHOR: liuxuefeng , DHCC
DATE  : 2009-8

COMMENT: DHC.WMR.ReceiptLog.Qry
 
========================================================================= */
window.onload = BodyLoadHandler;
function BodyLoadHandler()
{
   InitForm();
   InitEvent();
}

function InitForm(){
	var obj=document.getElementById("OpeType");
	if (obj){
		obj.size=1;
		obj.multiple=false;
		obj.length=0;
		var objItm1=document.createElement("OPTION");
		obj.options.add(objItm1);
		objItm1.innerText ="接诊";
		objItm1.value = 1;
		var objItm2=document.createElement("OPTION");
		obj.options.add(objItm2);
		objItm2.innerText ="取消接诊";
		objItm2.value = 2;
		var objItm3=document.createElement("OPTION");
		obj.options.add(objItm3);
		objItm3.innerText ="全部";
		objItm3.value = "";
	}
}
function InitEvent()
{
	document.getElementById("cmdQuery").onclick = cmdQueryOnClick;

}

function cmdQueryOnClick()
{
	var MrType="",OpeFromDate="",OpeToDate="",OpeUserIn="",OpeTypeIn="",MrNoIn="";
	MrType=getElementValue("MrType");
	OpeFromDate=getElementValue("OpeFromDate");
	OpeToDate=getElementValue("OpeToDate");

	var obj=document.getElementById("OpeUser");
	if (Trim(obj.value)!=""){
				OpeUserIn=getElementValue("OpeUserID");
	}
	
	OpeTypeIn=getElementValue("OpeType");
	MrNoIn=getElementValue("MrNoIn");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ReceiptLog.List" + "&OpeFromDate=" +OpeFromDate+ "&OpeToDate=" +OpeToDate + "&MrType=" +MrType+"&OpeUserIn=" +OpeUserIn+"&OpeTypeIn="+OpeTypeIn+"&MrNoIn="+MrNoIn;
  //alert(lnk);
  parent.RPbottom.location.href=lnk;
}
function LookUpOpeUser(str){
	var objOpeUser=document.getElementById('OpeUser');
	var objOpeUserID=document.getElementById('OpeUserID');
	var tem=str.split("^");
	objOpeUserID.value=tem[0];
	objOpeUser.value=tem[2];
}