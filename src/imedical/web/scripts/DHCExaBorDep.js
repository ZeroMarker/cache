var SelectedRow = 0;

function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Bcancel");
	if (obj) obj.onclick=Bdel_click;
	
	var obj=document.getElementById("BordBordesc");
	if (obj) obj.onchange=BordBordesc_change;
	
}
function BordBordesc_change(){
	var obj=document.getElementById("BordBordesc");
	if ((obj)&&(obj.value=="")){
		var obj=document.getElementById('BordBorDr');
		obj.value="";
	}
}
function deplook(str) {
var obj=document.getElementById('BordDepDr');
var tem=str.split("^");
//alert(tem[1]);
if(obj) obj.value=tem[1];

}

function borlook(str) {
var obj=document.getElementById('BordBorDr');
var tem=str.split("^");
//alert(tem[1]);
if(obj) obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
    var objtbl=document.getElementById('DHCExaBorDep');

    var obj=document.getElementById('BordBorDr');
	var obj1=document.getElementById('BordDepDr');
	var obj2=document.getElementById('ID');
	var obj3=document.getElementById('BordMemo');
	var obj4=document.getElementById('BordBordesc');
	var obj5=document.getElementById('BordDepdesc');
	if(SelectedRow == selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
		obj5.value="";
		SelectedRow=0
		return	
	}
	var SelRowObj=document.getElementById('TBordBorDrz'+selectrow);
	var SelRowObj1=document.getElementById('TBordDepDrz'+selectrow);
	var SelRowObj2=document.getElementById('TIDz'+selectrow);
	var SelRowObj3=document.getElementById('TBordMemoz'+selectrow);
	var SelRowObj4=document.getElementById('TBordBordescz'+selectrow);
	var SelRowObj5=document.getElementById('TBordDepdescz'+selectrow);

	obj.value=SelRowObj.value;
	obj1.value=SelRowObj1.value;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.innerText;
	obj5.value=SelRowObj5.innerText;
	//alert(obj.value+","+obj1.value+","+obj2.value+","+obj3.value+","+obj4.value+","+obj5.value)
	//var ss=obj5.value;//
    //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCExaRoom&borid="+ss;//
 	//bottomFrame.location.href=lnk;//
	SelectedRow = selectrow;
}

function Bupdate_click()	//
{   var ID=document.getElementById('ID').value
 	if (ID=="") {
		alert(t['04']);
		return;}
	var Bor=document.getElementById('BordBordesc').value;
	if (Bor=="") {
		alert(t['01'])
		return;}
    var dep=document.getElementById('BordDepdesc').value;
    if (dep=="") {
		alert(t['02']);
		return;}

    var BordBorDr=document.getElementById('BordBorDr').value;
    var BordDepDr=document.getElementById('BordDepDr').value;    
    var BordMemo=document.getElementById('BordMemo').value

    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	//alert(BordBorDr+","+BordDepDr+","+BordMemo+","+encmeth);
	if (cspRunServerMethod(encmeth,'SetPid','',BordBorDr,BordDepDr,BordMemo,ID)=='0') {
			}
}
function Bdel_click()	//
{
	var ID=document.getElementById('ID').value
 	if (ID=="") {
		alert(t['04']);
		return;}
		
    var del=document.getElementById('del');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'Setdel','',ID)=='0') {
			}
}
function Setdel(value) //
{ 
    //alert(value);
	if (value!="0")
	{alert(t['05']);
	return;
		}
	try {	
	   
	    alert(t['06']);
	    window.location.reload();
		} catch(e) {};
}
function Badd_click()	
{
	var Bor=document.getElementById('BordBordesc').value;
	if (Bor=="") {
		alert(t['01'])
		return;}
    var dep=document.getElementById('BordDepdesc').value;
    if (dep=="") {
		alert(t['02']);
		return;}

    var BordBorDr=document.getElementById('BordBorDr').value;
    var BordDepDr=document.getElementById('BordDepDr').value;  
    
    var BordMemo=document.getElementById('BordMemo').value;
    var add=document.getElementById('add');
	if (add) {var encmeth=add.value} else {var encmeth=''};
	//alert(BordBorDr+","+BordDepDr+","+BordMemo)
	if (cspRunServerMethod(encmeth,'SetPid','',BordBorDr,BordDepDr,BordMemo)=='0') {
			}
}
function SetPid(value) 
{ 
    //alert(value);
	if (value!="")
	{alert(t['07']);
	return;
		}
	try {	
	   
	    alert(t['08']);
	    window.location.reload();
		} catch(e) {};
}
function CleartDHCOPAdm()
{
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex+1;j++) {
		objtbl.deleteRow(1);
	//alert(j);
	}
}
document.body.onload = BodyLoadHandler;
