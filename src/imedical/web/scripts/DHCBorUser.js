var SelectedRow = 0;
function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Bdel");
	if (obj) obj.onclick=Bdel_click;
	var myobj=document.getElementById('borname');
	if (myobj){
		myobj.onchange=borname_OnChange;
	}
	var myobj=document.getElementById('username');
	if (myobj){
		myobj.onchange=username_OnChange;
	}
}
function borname_OnChange()
{
	var myobj=document.getElementById('borname');
	if (myobj){
		if(myobj.value==""){
			var myobj=document.getElementById('borid');
			myobj.value=""
		}
	}
}
function username_OnChange()
{
	var myobj=document.getElementById('username');
	if (myobj){
		if(myobj.value==""){
			var myobj=document.getElementById('userid');
			myobj.value=""
		}
	}
}

function Bdel_click() {
	selectrow=SelectedRow;

	var rid=document.getElementById('rid').value;
	//alert(rid);
    if (rid=="") {
		alert(t['07']);
		return;}
		
    var del=document.getElementById('del');

	if (del) {var encmeth=del.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'Setdel','',rid)=='0') {
		
			}
}
function Setdel(value) 
{
    //alert(value);
	if (value!="0")
	{alert(t['09']);
	return;
		}
	try {	
	   
	    alert(t['08']);
	    window.location.reload();
		} catch(e) {};
}
function borlook(str) {

var obj=document.getElementById('borid');
var tem=str.split("^");
obj.value=tem[1];

}
function uselook(str) {
var obj=document.getElementById('userid');
var tem=str.split("^");
obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCBorUser');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('borname');
	var obj1=document.getElementById('username');
	var obj2=document.getElementById('borid');
	var obj3=document.getElementById('userid');
	var obj4=document.getElementById('rid');
	if(SelectedRow == selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
		SelectedRow=""
		return
	}
	var SelRowObj=document.getElementById('Tbornamez'+selectrow);
	var SelRowObj1=document.getElementById('Tusenamez'+selectrow);
	var SelRowObj2=document.getElementById('Tboridz'+selectrow);
	var SelRowObj3=document.getElementById('Tuseidz'+selectrow);
	var SelRowObj4=document.getElementById('Tidz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.value;
	obj3.value=SelRowObj3.value;
	obj4.value=SelRowObj4.value;
    //alert(obj4.value);
	SelectedRow = selectrow;
}

function Bupdate_click()	//
{   var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['03']);
		return;
	}
	selectrow=SelectedRow;
	var use=document.getElementById('userid').value;
	if (use=="") {
		alert(t['01']);
		return;
	}
    var bor=document.getElementById('borid').value;
    if (bor=="") {
		alert(t['02']);
		return;
	}
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPid','',use,bor,rid)=='0') {}
}
function Badd_click()	//
{
	selectrow=SelectedRow;
	var use=document.getElementById('userid').value;
	if (use=="") {
		alert(t['01']);
		return;
	}
    var bor=document.getElementById('borid').value;
    if (bor=="") {
		alert(t['02']);
		return;
	}
    var ins=document.getElementById('ins');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPid','',use,bor)=='0') {
			}
	//var Formobj=document.getElementById('fDHCOPReturn');
	//Formobj.ACTION="websys.csp";
	//Formobj.method="post";
	//if (Formobj) Formobj.submit();	
	//window.close();
	//return true;
}
function SetPid(value) //
{
	//alert(value);
	if (value!="")
	{
		alert(t['06']);
		return;
	}
	try {	
	    alert(t['05']);
	    window.location.reload();
	} catch(e) {};
}

document.body.onload = BodyLoadHandler;
