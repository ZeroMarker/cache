//DHCOutPhUnReasCode
var SelectedRow = 0;
function BodyLoadHandler() {
	var baddobj=document.getElementById("BInsert");
	if (baddobj) baddobj.onclick=Badd_click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=Bupdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=Bdelete_click;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhUnReasCode');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	var obj=document.getElementById('CUnReason');
	var SelRowObj=document.getElementById('TUnReasDescz'+selectrow);
	var SelRowObj1=document.getElementById('TUnReasIDz'+selectrow);
	  
	obj.value=SelRowObj.innerText;
	SelectedRow = selectrow;
}

function Bupdate_click()	
{
	selectrow=SelectedRow;
    var desc=document.getElementById('CUnReason').value;
    var reasid=document.getElementById('TUnReasIDz'+selectrow).innerText
     if (desc=="") {alert(t['01']);	return;}
		
    var up=document.getElementById('update');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	
	var retval=cspRunServerMethod(encmeth,desc,reasid)
	if (retval=="-9999"){alert("名称重复，不能添加");return;}
    if (retval==0){ alert(t['05']); window.location.reload();
      }
    else {alert(t['04']);return ;}
	
}
function Bdelete_click()	
{
	selectrow=SelectedRow;
    var desc=document.getElementById('CUnReason').value;
    var reasid=document.getElementById('TUnReasIDz'+selectrow).innerText
     if (desc=="") {alert(t['01']);	return;}
		
    var up=document.getElementById('delete');
	if (up) {var encmeth=up.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,desc,reasid)
	
    if (retval==0){ alert("删除成功!"); window.location.reload();}
    else if (retval=="-1") {alert("该原因已被使用,不允许删除!");return ;}
    else {alert("删除失败!错误代码:"+retval);return ;}
	
}

function Badd_click()	
{
	selectrow=SelectedRow;
	var desc=document.getElementById('CUnReason').value;
	if (desc=="") {	alert(t['01']);	return;}
    var pid=document.getElementById('insert');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,desc)
    if (retval=="-9999"){alert("名称重复，不能添加");return;}
    if (retval==0){ alert(t['03']); window.location.reload();
      }
    else {alert(t['02']);return ;}
	
	

}

document.body.onload = BodyLoadHandler;
