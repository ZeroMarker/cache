var SelectedRow = 0;
var bottomFrame;
var topFrame;
  if(parent.name=='TRAK_main') {
		topFrame=parent.frames['work_top'];
		bottomFrame=parent.frames['work_bottom'];
	} else {
		if(parent.frames['TRAK_main']){
			topFrame=parent.frames['TRAK_main'].frames['work_top'];
		    bottomFrame=parent.frames['TRAK_main'].frames['work_bottom'];
		}
	}
//var subtblobj=bottomFrame.document.getElementById('tDHCExaRoom');//
//var objtbl=topFrame.document.getElementById('tDHCExaBorough');//

function BodyLoadHandler() {
	var obj=document.getElementById("Badd");
	if (obj) obj.onclick=Badd_click;
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("Bdel");
	if (obj) obj.onclick=Bdel_click;
	
}
function deplook(str) {
var obj=document.getElementById('depid');
var tem=str.split("^");
//alert(tem[1]);
obj.value=tem[1];

}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var objtbl=document.getElementById('tDHCExaBorough');
//	var rows=objtbl.rows.length;
//	var lastrowindex=rows - 1;
//	var rowObj=getRow(eSrc);
//	var selectrow=rowObj.rowIndex;
//	if (!selectrow) return;
//	var obj=topFrame.document.getElementById('code');
    var obj=document.getElementById('code');
	var obj1=document.getElementById('name');
	var obj3=document.getElementById('memo');
	var obj4=document.getElementById('Checkin');
	var obj5=document.getElementById('rid');
	var obj6=document.getElementById('CallFilePath');
	var obj7=document.getElementById('WaitFilePath');
	if(SelectedRow == selectrow){
		obj.value=""
		obj1.value=""
		obj3.value=""
		obj4.checked=false
		obj5.value=""
		obj6.value=""
		obj7.value=""
		SelectedRow=0
		return
	}
	SelectedRow = selectrow;
	var SelRowObj=document.getElementById('Tcodez'+selectrow);
	var SelRowObj1=document.getElementById('Tnamez'+selectrow);
	var SelRowObj3=document.getElementById('Tmemoz'+selectrow);
	var SelRowObj4=document.getElementById('TCheckinz'+selectrow);
	var SelRowObj5=document.getElementById('Tidz'+selectrow);
	var SelRowObj6=document.getElementById('TCallFilePathz'+selectrow);
	var SelRowObj7=document.getElementById('TWaitFilePathz'+selectrow);

	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj3.value=SelRowObj3.innerText;
	obj5.value=SelRowObj5.value;
	obj6.value=SelRowObj6.innerText;
	obj7.value=SelRowObj7.innerText;
	
	if (SelRowObj4.innerText=="Y"){
		obj4.checked=true
	}else{
		obj4.checked=false
	}
	
	//var ss=obj5.value;//
    //var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCExaRoom&borid="+ss;//
 	//bottomFrame.location.href=lnk;//
	SelectedRow = selectrow;
}

function Bupdate_click()	
{   var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['04']);
		return;
	}
	selectrow=SelectedRow;
	var code=document.getElementById('code').value;
	if (code=="") {
		alert(t['01']);
		return;}
    var name=document.getElementById('name').value;
    if (name=="") {
		alert(t['02']);
		return;}
		
    var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['04']);
		return;}
			
	var memo=document.getElementById('memo').value;
	var CallFilePath=document.getElementById('CallFilePath').value;
    var WaitFilePath=document.getElementById('WaitFilePath').value;
    
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
	//alert(code+"!"+name+"!"+depid+"!"+memo);
	if (cspRunServerMethod(encmeth,'SetPid','',code,name,memo,rid,Checkin,CallFilePath,WaitFilePath)=='0') {
			}
}
function Bdel_click()	
{
	selectrow=SelectedRow;
	
	var rid=document.getElementById('rid').value;
    if (rid=="") {
		alert(t['04']);
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
	selectrow=SelectedRow;
	var code=document.getElementById('code').value;
	if (code=="") {
		alert(t['01'])
		return;}
    var name=document.getElementById('name').value;
    if (name=="") {
		alert(t['02']);
		return;}
    
    var memo=document.getElementById('memo').value;
    var CallFilePath=document.getElementById('CallFilePath').value;
    var WaitFilePath=document.getElementById('WaitFilePath').value;
    
    var objCheckin=document.getElementById('Checkin');
    if  (objCheckin.checked)
    {var Checkin="Y";
    }
    else
    {
    var Checkin="N";
    }
    var pid=document.getElementById('pid');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'SetPid','',code,name,memo,Checkin,CallFilePath,WaitFilePath)=='0') {
			}
}
function SetPid(value) 
{ 
    //alert(value);
	if (value!="")
	{
	   alert(t['07']+","+"代码重复");
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
