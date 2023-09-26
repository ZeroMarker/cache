function BodyLoadHandler()
{
	var obj=document.getElementById("SaveSel");
	if (obj) {obj.onclick=Save_click;}

	var objtbl=document.getElementById('tDHCTEMPBCORD');
 	var GetOrdChecked=document.getElementById("GetOrdChecked").value;
 	var i;
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=document.getElementById("selz"+i);
	   var oeori=document.getElementById("Rowidz"+i).innerText
	   var ret=cspRunServerMethod(GetOrdChecked,oeori)
	   if (ret==1)
       {
	     item.checked="on";
       }
       
	}
	
	 //obj.options[i]=new Option(myarray[1],myarray[0]);
	
   //
}
function Save_click()
{
	var objtbl=document.getElementById('tDHCTEMPBCORD');
  	var oeoriIdStr;
 	var savord=document.getElementById("SaveHBord").value;
 	var i;
	oeoriIdStr="";
	for (i=1;i<objtbl.rows.length;i++)
	{
	   var item=document.getElementById("selz"+i);
	   var oeori=document.getElementById("Rowidz"+i).innerText
	   if (item.checked==true)
       {
	       if (oeoriIdStr.length==0){oeoriIdStr=oeori}
           else{oeoriIdStr=oeoriIdStr+"^"+oeori}

       }
       var oer=oeori;
       
	}
	if (oeoriIdStr.length!=0)
	{
		var ret=cspRunServerMethod(savord,oeoriIdStr);
		alert("OK");
	}
	else
	{
		var ret=cspRunServerMethod(savord,"Clear"+"^"+oer);
		alert("OK");

	}
}
document.body.onload = BodyLoadHandler;