var ordid
var guser

function BodyLoadHandler() {
   var ordnameobj=document.getElementById('ordername')
   var ordname;
   ordname=unescape(ordnameobj.value)
   ordnameobj.value=ordname
   ordid=document.getElementById('orditmid').value   
   guser=session['LOGON.USERID']
   var btnup=document.getElementById('BtnUp')
   if (btnup) btnup.onclick=update_click;
}
function update_click()
{  var newdateobj
   var newdate
   if (ordid==""){
      alert(t['01']);
      return;
    }
   newdateobj=document.getElementById('newdate1');
   newdate=newdateobj.value
   var olddate=document.getElementById('orderdate').value
   var oldstdate=document.getElementById('sttdate').value                                                                         
   if (newdate==""){
      alert(t['02']);
      return;
   }
  var str=oldstdate+"^"+olddate+"^"+newdate+"^"+guser
  var dateupobj=document.getElementById('dateup')
  if (dateupobj) {var encmeth=dateupobj.value} else {var encmeth=''};
  var ret=cspRunServerMethod(encmeth,ordid,str)
  if (ret=="0"){
	 alert(t['03']);
	 return; }
  else{
	 alert(t['04']);
	 return; }	     	
}
document.body.onload = BodyLoadHandler;