function BodyLoadHandler()
{
	var objtbl=document.getElementById("tDHCLONGPATBED");
	if (objtbl) {objtbl.ondblclick=tb_dbclick;}
	

	
	 //obj.options[i]=new Option(myarray[1],myarray[0]);
	
   //
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}

function tb_dbclick()
{
  var selrow=DHCWeb_GetRowIdx(window);
  var adm=document.getElementById("EpisodeIDz"+selrow).value;
  var lnk="dhcoeordsch.csp?EpisodeID="+adm;	 
  parent.frames[1].document.location.href=lnk;
}
document.body.onload = BodyLoadHandler;