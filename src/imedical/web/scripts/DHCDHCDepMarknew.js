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
	var myobj=document.getElementById('depname');
	if (myobj){
		myobj.onchange=depname_OnChange;
	}
	var myobj=document.getElementById('markname');
	if (myobj){
		myobj.onchange=markname_OnChange;
	}
}
function borname_OnChange()
{
	var myobj=document.getElementById('borname');
	if (myobj){
		if(myobj.value==""){
			var myobj=document.getElementById('roomid');
			myobj.value=""
		}
	}
}

function depname_OnChange()
{
	var myobj=document.getElementById('depname');
	if (myobj){
		if(myobj.value==""){
			var myobj=document.getElementById('depid');
			myobj.value=""
		}
	}
}

function markname_OnChange()
{
	var myobj=document.getElementById('markname');
	if (myobj){
		if(myobj.value==""){
			var myobj=document.getElementById('markid');
			myobj.value=""
		}
	}
}
function Bdel_click()	
{
	selectrow=SelectedRow;
	var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['01']);
		return;}
		
    var del=document.getElementById('del');

	if (del) {var encmeth=del.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'Setdel','',rid)=='0') {
		
			}
}
function Setdel(value) //没
{
    //alert(value);
	if (value!="0")
	{alert(t['02']);
	return;
		}
	try {	
	   
	    alert(t['03']);
	    window.location.reload();
		} catch(e) {};
}
function roomlook(str) {
//alert(str);
var obj=document.getElementById('borname');
var tem=str.split("^");
obj.value=tem[0];
var obj1=document.getElementById('roomid');
obj1.value=tem[1];

var obj=document.getElementById('depid');
if(obj)obj.value="";
var obj1=document.getElementById('depname');
if(obj1) obj1.value="";
var obj=document.getElementById('markid');
if(obj)obj.value="";
var obj=document.getElementById('markname');
if(obj)obj.value="";
}
function comlook(str) {
var obj=document.getElementById('depid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];

var obj1=document.getElementById('depname');
obj1.value=tem[0];
var obj=document.getElementById('markid');
if(obj)obj.value="";
var obj=document.getElementById('markname');
if(obj)obj.value="";
}
function loclook(str) {

var obj=document.getElementById('markid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCDHCDepMarknew');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('borname');
	var obj1=document.getElementById('depname');
	var obj2=document.getElementById('markname');
	var obj3=document.getElementById('st');
	var obj4=document.getElementById('si');
    var obj5=document.getElementById('roomid');
	var obj6=document.getElementById('depid');
	var obj7=document.getElementById('markid');
	var obj8=document.getElementById('rid');	
	var obj9=document.getElementById('Checkin');
	if(SelectedRow==selectrow){
		obj.value="";
		obj1.value="";
		obj2.value="";
		obj3.checked=false;
		obj4.checked=false;
		obj5.value=""
		obj6.value="";
		obj7.value="";
		obj8.value="";
		obj9.checked=false;
		SelectedRow=0
		return
	}
	var SelRowObj=document.getElementById('Tbornamez'+selectrow);
	var SelRowObj1=document.getElementById('Tdepnamez'+selectrow);
	var SelRowObj2=document.getElementById('Tmarknamez'+selectrow);
	var SelRowObj3=document.getElementById('Tstz'+selectrow);
	var SelRowObj4=document.getElementById('Tsiz'+selectrow);
	var SelRowObj5=document.getElementById('Tboridz'+selectrow);
	var SelRowObj6=document.getElementById('Tdepidz'+selectrow);
	var SelRowObj7=document.getElementById('Tmarkidz'+selectrow);
	var SelRowObj8=document.getElementById('Tidz'+selectrow);
	var SelRowObj9=document.getElementById('TCheckinz'+selectrow);
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;

	//''''''
	// var status=obj3.checked
    //Clear_Click();
    //AppSelectobj.checked=status;
 
	obj3.value=SelRowObj3.innerText;

    if  (obj3.value==t['07'])//
    {
    obj3.checked=true;
    }
    else
    {
    obj3.checked=false;
    }
	
	obj4.value=SelRowObj4.innerText;
	if  (obj4.value==t['08'])//
    {
    obj4.checked=true;
    }
    else
    {
    obj4.checked=false;
    }
	obj5.value=SelRowObj5.value;
	obj6.value=SelRowObj6.value;
	obj7.value=SelRowObj7.value;
	obj8.value=SelRowObj8.value;
	
	obj9.value=SelRowObj9.value;
	if (SelRowObj9.innerText=="Y"){
		obj9.checked=true
	}else{
		obj9.checked=false
	}
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
	if(SelectedRow==0){alert("请选择一条记录！");return;}
	selectrow=SelectedRow;
	var roomid=document.getElementById('roomid').value;
	if (roomid=="") {
		alert(t['04']);
		return;}

    var comid=document.getElementById('depid').value;
    var comname=document.getElementById('depname').value;
    if (comname=="") {
		comid="";}
	
	var markid=document.getElementById('markid').value;
    if (markid=="") {
		alert(t['05']);
		return;}
    var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['01']);
		return;}		
	var mState=document.getElementById('st')
    if  (mState.checked)
    {var st="2";
    }
    else
    {
    var st="1";
    }
    var mSign=document.getElementById('si')
    if  (mSign.checked)
    {var si="Y";
    }
    else
    {
    var si="N";
    }
    var objCheckin=document.getElementById('Checkin');
    if  (objCheckin.checked)
    {var Checkin="Y";
    }
    else
    {
    var Checkin="N";
    }
    var up=document.getElementById('up');
	if (up) {var encmeth=up.value} else {var encmeth=''};

	if (cspRunServerMethod(encmeth,'SetPid','',roomid,comid,markid,st,si,rid,Checkin)=='0') {
			}
}
function Badd_click()	//
{
	selectrow=SelectedRow;
    var borid=document.getElementById('roomid').value;
	if (borid=="") {
		alert(t['04'])
		return;}
    var depid=document.getElementById('depid').value;

	
	var markid=document.getElementById('markid').value;
    if (markid=="") {
		alert(t['05']);
		return;}
   	
	var mState=document.getElementById('st')
    if  (mState.checked)
    {var st="2";
    }
    else
    {
    var st="1";
    }
    var mSign=document.getElementById('si')
    if  (mSign.checked)
    {var si="Y";
    }
    else
    {
    var si="N";
    }
	
	var objCheckin=document.getElementById('Checkin');
    if  (objCheckin.checked)
    {var Checkin="Y";
    }
    else
    {
    var Checkin="N";
    }
    var ins=document.getElementById('ins');
	if (ins) {var encmeth=ins.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPid','',borid,depid,markid,st,si,Checkin)=='0') {
			}
}
function SetPid(value) //
{
    //alert(value);
	if (value!="")
	{alert(t['06']);
	return;
		}
	try {	
	   
	    alert(t['09']);
	    window.location.reload();
		} catch(e) {};
}
document.body.onload = BodyLoadHandler;
