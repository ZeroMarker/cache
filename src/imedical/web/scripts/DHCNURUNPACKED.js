var selrow; 
selrow="" 
function BodyLoadHandler() {
	var objPack=document.getElementById("Dispensing");
	if (objPack) objPack.onclick=PackClick;
}
function PackClick()
{     if (selrow!=""){
	
	  var Pack=document.getElementById("Pack").value ;
	  var PrescNo=document.getElementById("prescNoz"+selrow);
	  if (PrescNo!=""){
	   var ret
		ret=cspRunServerMethod(Pack,PrescNo.innerText);
		var tem;
		tem=ret.split("^");
		}
		
		  else{alert("Prescno not null!");}
      }
      else{
	      alert("select a record");
	      }
	 window.location.reload();
}
 function SelectRowHandler()
{
    selrow=DHCWeb_GetRowIdx(window);
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
