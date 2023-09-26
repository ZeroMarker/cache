function BodyLoadHandler(){
	var obj=document.getElementById('OPARoom');
	var objlc=document.getElementById('GetANOPRoom').value;
		var OPRRowid=document.getElementById('OPRRowid').value;
	  var ret=cspRunServerMethod(objlc,OPRRowid);
	  if (obj) obj.value=ret;
 }
 document.body.onload = BodyLoadHandler;