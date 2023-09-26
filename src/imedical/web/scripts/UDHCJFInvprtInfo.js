var SelectedRow = 0;
var papnoobj,nameobj
function BodyLoadHandler()
{
   papnoobj=document.getElementById("Regno")
   nameobj=document.getElementById("name") 	
}
 function SelectRowHandler()	
{  	
   var eSrc=window.event.srcElement;
   Objtbl=document.getElementById('tUDHCJFInvprtInfo');
   Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   SelRowObj=document.getElementById('Tpatfeez'+selectrow);
   var patfee=SelRowObj.innerText
   SelRowObj=document.getElementById('Tdepositz'+selectrow);
   var deposit=SelRowObj.innerText
   SelRowObj=document.getElementById('Tinvnoz'+selectrow);
   var invno=SelRowObj.innerText
   SelRowObj=document.getElementById('TInvprtRowidz'+selectrow);
   var InvprtRowid=SelRowObj.innerText
   SelRowObj=document.getElementById('TAdmRowidz'+selectrow);
   var Admrowid=SelRowObj.innerText
   var papno=papnoobj.value
   var name=nameobj.value
   window.opener.document.getElementById("Regno").value=papno
   window.opener.document.getElementById("name").value=name
   window.opener.document.getElementById("fee").value=patfee
   window.opener.document.getElementById("yjamt").value=deposit
   window.opener.document.getElementById("rcptno").value=invno
   window.opener.document.getElementById("Admrowid").value=Admrowid
   window.opener.document.getElementById("InvprtRowid").value=InvprtRowid
   //window.opener.Find_click()
   window.close();
}	
document.body.onload = BodyLoadHandler;