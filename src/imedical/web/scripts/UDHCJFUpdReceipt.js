var SelectedRow = 0;
var prtflag,gusername,Guser,oldrcptno,prtrowid
var oldrcptobj
function BodyLoadHandler() {
   Guser=session['LOGON.USERID']
   gusername=session['LOGON.USERNAME']
   var obj=document.getElementById("Upd");
   if (obj) obj.onclick=Upd_click;
   oldrcptobj=document.getElementById("oldreceipt");
   oldrcptobj.readOnly=true
   oldrcptno=""
}
function Upd_click()
{
	var newno=document.getElementById("newreceipt").value
	
	if (!oldrcptno)
	{  alert(t['03'])
	   return;}
	if (newno=="")
	{
		alert(t['04'])
		return
	}
  
   var update=document.getElementById('update');
   if (update) {var encmeth=update.value} else {var encmeth=''};
  
   var retval=(cspRunServerMethod(encmeth,prtrowid,newno))
   if (retval!="0")
	{alert(t['05']);
	return;}
	else{	
	    alert(t['06']);
	    window.location.reload();
		} ;
}
	


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var Objtbl=document.getElementById('tUDHCJFUpdReceipt');
	var Rows=Objtbl.rows.length;
	
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	var SelRowObj=document.getElementById('Trowidz'+selectrow);
    prtrowid=SelRowObj.innerText;

    SelRowObj=document.getElementById('Trcptnoz'+selectrow);
    oldrcptno=SelRowObj.innerText;
    oldrcptobj.value=oldrcptno
	//var lastrowindex=rows - 1;
	//var rowObj=getRow(eSrc);
	//var selectrow=rowObj.rowIndex;
	SelectedRow = selectrow;
}
function LookUpUser(str)
{
	var obj=document.getElementById('Guser');
	var tem=str.split("^");
	obj.value=tem[1];
}
document.body.onload = BodyLoadHandler;