var SelectedRow = 0;
function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Bdel");
	if (obj) obj.onclick=Bdel_click;
}
function Bdel_click()	
{
	selectrow=SelectedRow;
	var rid=document.getElementById('rid').value;
    if (rid==""){
		alert(t['01']);
		return;
	}
    var del=document.getElementById('del');
	if (del) {var encmeth=del.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'Setdel','',rid)=='0'){
	}
}
function Setdel(value) //没
{
	if (value!="0")
	{
		alert(t['02']);
		return;
	}
	try {	
	    alert(t['03']);
	    window.location.reload();
	} catch(e) {};
}
function roomlook(str) {
	var obj=document.getElementById('roomid');
	var tem=str.split("^");
	obj.value=tem[1];
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCRoomComp');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('code');
	var obj1=document.getElementById('name');
	var obj2=document.getElementById('IP');
	var obj3=document.getElementById('room');
	var obj4=document.getElementById('roomid');
	var obj5=document.getElementById('rid');
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
	var SelRowObj=document.getElementById('Tcodez'+selectrow);
	var SelRowObj1=document.getElementById('Tnamez'+selectrow);
	var SelRowObj2=document.getElementById('Tipz'+selectrow);
	var SelRowObj3=document.getElementById('Troomz'+selectrow);
	var SelRowObj4=document.getElementById('Troomidz'+selectrow);
	var SelRowObj5=document.getElementById('Tidz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.value;
	obj5.value=SelRowObj5.value;
	SelectedRow = selectrow;
}

function Bupdate_click()	//没
{
	var rid=document.getElementById('rid').value;
    if (rid==""){
		alert(t['01']);
		return;
	}
	selectrow=SelectedRow;
	var code=document.getElementById('code').value;
	if (code=="") {
		alert(t['04'])
		return;
	}
    var name=document.getElementById('name').value;
    if (name=="") {
		alert(t['05']);
		return;
	}
    var roomid=document.getElementById('roomid').value;
    if (roomid=="") {
		alert(t['06']);
		return;
	}
	var ip=document.getElementById('IP').value;
    if (ip=="") {
		alert(t['07']);
		return;
	}	
    var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['01']);
		return;
	}		
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	var retvalue=cspRunServerMethod(encmeth,'SetPid','',code,name,ip,roomid,rid)
	if(retvalue==0)
	{
		alert("更新成功!");
	}
	else
	{
		//alert(retvalue);
	 if(retvalue==-120){
		//alert("更新失败,请检查修改项!");
		alert("修改项目已存在!");
		}
	 else
	 {
	   alert("更新失败,请检查修改项!");	 
	 }	
	}
	window.location.reload();
}
function Badd_click()	//没
{
	selectrow=SelectedRow;
	var code=document.getElementById('code').value;
	if (code=="") {
		alert(t['04'])
		return;}
    var name=document.getElementById('name').value;
    if (name=="") {
		alert(t['05']);
		return;}
    var roomid=document.getElementById('roomid').value;
    if (roomid=="") {
		alert(t['06']);
		return;}
	var ip=document.getElementById('IP').value;
    if (ip=="") {
		alert(t['07']);
		return;
	}	
    var ins=document.getElementById('ins');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	//if (cspRunServerMethod(encmeth,'','',code,name,ip,roomid)=='0') {}
	var rel=cspRunServerMethod(encmeth,'SetPid','',code,name,ip,roomid)
	//alert("rel"+rel);
	if (rel=='0') {
		alert("保存成功!")
		}
	else{
		//alert(rel);
		alert("数据存在冲突!");
		}
	window.location.reload();
}
function SetPid(value) //没
{
	window.location.reload();
	return;
	alert("SetPid"+value);
	if (value!="")
	{
		alert(t['08']);
		return;
	}
	try {	
		alert(t['09']);
		window.location.reload();
	} catch(e) {};
}
document.body.onload = BodyLoadHandler;
