
function BodyLoadHandler()
{
    

	//exedateobj.value=j;
}

 function SelectRowHandler()
 {
    var selrow=document.getElementById("selrow");
    var resList=new Array();
    selrow.value=DHCWeb_GetRowIdx(window);
    var objtbl=document.getElementById('tDHCNUROPEXEC');
	var SSGRPID=document.getElementById("SSGRPIDz"+selrow.value).innerText;

    var lnk;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurAccessDetail&ssgrp="+SSGRPID;
    
    parent.frames[1].location.href=lnk; 
    //parent.frames[1].location.reload();
   

    
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
document.body.onload = BodyLoadHandler;
