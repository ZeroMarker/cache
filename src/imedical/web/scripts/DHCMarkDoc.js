var SelectedRow = 0;
function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Delete")
	if(obj) obj.onclick=Delete_click;
}
function marklook(str) {

var obj=document.getElementById('markid');
var tem=str.split("^");
obj.value=tem[1];
}
function doclook(str) {

var obj=document.getElementById('docid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];
}
function deplook(str) {
var obj=document.getElementById('depid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCMarkDoc');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
	if (!selectrow) return;
	var obj=document.getElementById('depname');
	var obj1=document.getElementById('markname');
	var obj2=document.getElementById('docname');
	var obj3=document.getElementById('rid');
	var obj4=document.getElementById('depid');	
	var obj5=document.getElementById('markid');	
	var obj6=document.getElementById('docid');	
	if(SelectedRow == selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";
		obj4.value="";
		obj5.value="";
		obj6.value="";
		SelectedRow=0
		return
	}
	var SelRowObj=document.getElementById('Tdepnamez'+selectrow);
	var SelRowObj1=document.getElementById('Tmarknamez'+selectrow);
	var SelRowObj2=document.getElementById('Tdocnamez'+selectrow);
	var SelRowObj3=document.getElementById('Tidz'+selectrow);
	var SelRowObj4=document.getElementById('Tdepidz'+selectrow);
	var SelRowObj5=document.getElementById('Tmarkidz'+selectrow);
	var SelRowObj6=document.getElementById('Tlocidz'+selectrow);	
	obj.value=SelRowObj.innerText;
	
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;

	obj3.value=SelRowObj3.value;
	obj4.value=SelRowObj4.value;

	obj5.value=SelRowObj5.value;

	obj6.value=SelRowObj6.value;

	SelectedRow = selectrow;
	
}

function Bupdate_click()	//û
{   var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['04']);
		return;}
	selectrow=SelectedRow;
    var depid=document.getElementById('depid').value;
	if (depid=="") {
		alert(t['01'])
		return;}
    var markid=document.getElementById('markid').value;
    if (markid=="") {
		alert(t['02']);
		return;}
	
	var docid=document.getElementById('docid').value;
    if (docid=="") {
		alert(t['03']);
		return;}
    var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['04']);
		return;}		
	
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'SetPid','',depid,markid,docid,rid)=='0') {
			}
}
function Delete_click(){
	selectrow=SelectedRow;
	var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['04']);
		return;}
	var del=document.getElementById('del')
	if(del){var encmeth=del.value} else { var encmeth=""}
	if( cspRunServerMethod(encmeth,'SetPid','',rid)=='0'){}
		
}
function Badd_click()	//û
{
	selectrow=SelectedRow;
    var depid=document.getElementById('depid').value;
	if (depid=="") {
		alert(t['01'])
		return;}
    var markid=document.getElementById('markid').value;
    if (markid=="") {
		alert(t['02']);
		return;}
	
	var docid=document.getElementById('docid').value;
    if (docid=="") {
		alert(t['03']);
		return;}

    var ins=document.getElementById('ins');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	//alert(code+"!"+name+"!"+depid+"!"+memo);
	if (cspRunServerMethod(encmeth,'SetPid','',depid,markid,docid)=='0') {
			}
}
function SetPid(value) //û
{
    //alert(value);
    if(value=="delete"){
		alert(t['delete']);
		window.location.reload();
		return;
	}
	if (value!="")
	{alert(t['05']);
	return;
		}
	try {	
	   
	    alert(t['06']);
	    window.location.reload();
		} catch(e) {};
}
document.body.onload = BodyLoadHandler;
