var SelectedRow = 0;
function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCPerState');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('code');
	var obj1=document.getElementById('name');
	var obj2=document.getElementById('memo');
	var obj3=document.getElementById('rid');
	if(SelectedRow ==selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.value="";	
		SelectedRow=0
		return
	}
	var SelRowObj=document.getElementById('Tcodez'+selectrow);
	var SelRowObj1=document.getElementById('Tnamez'+selectrow);
	var SelRowObj2=document.getElementById('Tmemoz'+selectrow);
	var SelRowObj3=document.getElementById('Tidz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.value;
	SelectedRow = selectrow;
}

function Bupdate_click()	//没
{
	selectrow=SelectedRow;
	var code=document.getElementById('code').value;
	if (code=="") {
		alert(t['01'])
		return;}
    var name=document.getElementById('name').value;
    if (name=="") {
		alert(t['02']);
		return;}
	
    var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['03']);
		return;}		
    var memo=document.getElementById('memo').value;
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	//alert(code+"!"+name+"!"+depid+"!"+memo);
	if (cspRunServerMethod(encmeth,'SetPid','',code,name,memo,rid)=='0') {
			}
}
function Badd_click()	//没
{
	selectrow=SelectedRow;
	var code=document.getElementById('code').value;
	if (code=="") {
		alert(t['01']);
		return;}
    var name=document.getElementById('name').value;
    if (name=="") {
		alert(t['02']);
		return;}

    var memo=document.getElementById('memo').value;
    var ins=document.getElementById('ins');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	//alert(code+"!"+name+"!"+depid+"!"+memo);
	if (cspRunServerMethod(encmeth,'SetPid','',code,name,memo)=='0') {
			}
}
function SetPid(value) //没
{
    //alert(value);
	if (value!="")
	{alert(t['04']);
	return;
		}
	try {	
	   
	    alert(t['05']);
	    window.location.reload();
		} catch(e) {};
}
document.body.onload = BodyLoadHandler;
