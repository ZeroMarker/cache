//DHCST.PIVA.ORDGRP
//
function BodyLoadHandler()
{
	var obj = document.getElementById("tPatNo");
	if (obj) {
		obj.onkeydown = RegNoKeyDown;
	}
	
	var obj=document.getElementById("tWardDesc");
	if (obj){
		obj.onkeydown=WardKeyDown;
		obj.onblur=WardLostFocus;
		obj.onfocus=WardOnFocus;
	}
	
	var obj=document.getElementById("DispLoc"); 
	if (obj) 
	{obj.onkeydown=popDispLoc;
	obj.onblur=DispLocCheck;
	}
	
	
}

function RegNoKeyDown()
{
	if (window.event.keyCode!=13)return;
	var regno;
	var objregno=document.getElementById("tPatNo");
	if (objregno) regno=objregno.value;
	
	regno=getRegNo(regno);
	if (objregno) objregno.value=regno
	alert(regno)
		
}

/// tWardID
function WardLookUpSelect(str)
{
	var ward=str.split("^");
	var obj=document.getElementById("tWardID");
	if (obj){
		if (ward.length>0)   obj.value=ward[1];
		else  obj.value="" ;
	 }
}
function WardKeyDown()
{
	if (window.event.keyCode==13){
		window.event.keyCode=117;
		tWardDesc_lookuphandler();
	}
}
function WardLostFocus()
{
	var obj=document.getElementById("tWard");
	if (obj){
		if (obj.value == ""){
			var obj=document.getElementById("tWardID");
			if (obj) obj.value = ""
		}
	}
}
function WardOnFocus()
{
	var obj=document.getElementById("tWard");
	if (obj) obj.select();
}

function DispLocCheck()
{

	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}
function popDispLoc()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}



function SelectRowHandler() {

	var row=selectedRow(window);

	//RowChange(row);
	
}

function RowChange(row)
{
	var oeori="" ;
	var obj=document.getElementById("tbMoeoriz"+row) ;
	if (obj) var oeori=obj.value;
	if (oeori=="") return;
	var grp="" ;
	var objgrp=document.getElementById("tbGrpNoz"+row) ;
	if (objgrp) var grp=objgrp.value;
	if (grp=="") return; 
	var tmp=oeori.split("||")
	var ord=tmp[0]
	var itm=tmp[1]
	var barcode=ord+"-"+itm+"-"+grp


	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcst.piva.ordgrptrans&tBarCode="+barcode ;
	parent.frames['dhcst.piva.ordgrptrans'].location.href=lnk;
}




document.body.onload=BodyLoadHandler;