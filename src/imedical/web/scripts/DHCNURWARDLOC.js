var funadd=document.getElementById('funadd').value;
var DelWardLoc=document.getElementById('DelWardLoc').value;
var UpWardLoc=document.getElementById('UpWardLoc').value;
var wardid=document.getElementById('WardId');
var locid=document.getElementById('LocId');
var PacWard=document.getElementById('PacWard');
var Loc=document.getElementById('Loc');

function BodyLoadHandler()
{
	var Add=document.getElementById('Add');
	if (Add) {Add.onclick=Add_click;}
	var BtDel=document.getElementById('BtDel');
	if (BtDel) {BtDel.onclick=Del_click;}
	var BtUpdate=document.getElementById('BtUpdate');
	if (BtUpdate) {BtUpdate.onclick=UpDate_click;}
	var BtClear=document.getElementById('btclear');
	if (BtClear) {BtClear.onclick=clear_click;}
	var SearSch=document.getElementById('SearSch');
	if (SearSch) {SearSch.onclick=SearSch_click;}
	//exedateobj.value=j;butexcut
}
function clear_click()
{
	window.location.reload();
}
function SearSch_click()
{
	if (PacWard.value=="") {wardid.value="";}
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNURWARDLOCLIST"+"&ward="+wardid.value;
    parent.frames[1].location.href=lnk; 
}
function Add_click()
{
	
 if ((PacWard.value=="")||(Loc.value=="")) return;
 var ret=cspRunServerMethod(funadd,wardid.value,locid.value);
 if (ret==0)
 {
	 alert("OK!");
 }
 if (ret==1)
 {
	 alert("record already!");
 }
 parent.frames[1].location.reload();
}
function Del_click()
{
 selrow=parent.frames[1].document.getElementById("SelRow").value;
 if (selrow=="") return;
 var rw=parent.frames[1].document.getElementById("Noz"+selrow).innerText;
 var ret=cspRunServerMethod(DelWardLoc,rw,wardid.value,locid.value);
 if (ret==0)
 {
	 alert("OK!");
 }
    //alert(parent.frames[0].window.frames[0].window.frames[0].name);
 parent.frames[1].location.reload();

}
function UpDate_click()
{
 var selrow=parent.frames[1].document.getElementById("SelRow").value;
 if (selrow=="") return;
 var rw=parent.frames[1].document.getElementById("Noz"+selrow).innerText;
 
 if ((PacWard.value=="")||(Loc.value=="")) return;
 var ret=cspRunServerMethod(UpWardLoc,rw,wardid.value,locid.value);
 if (ret==0)
 {
	 alert("OK!");
 }
    //alert(parent.frames[0].window.frames[0].window.frames[0].name);
 parent.frames[1].location.reload();

}
function GetLoc(str)
{
		var loc=str.split("^");
		var obj=document.getElementById("LocId");
		obj.value=loc[1];

}
function GetWard(str)
{
		var loc=str.split("^");
		var obj=document.getElementById("WardId");
		obj.value=loc[1];

}
document.body.onload = BodyLoadHandler;
