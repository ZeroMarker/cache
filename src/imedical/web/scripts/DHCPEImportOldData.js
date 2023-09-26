///DHCPEImportOldData.js

function BodyLoadHandler() 
{
	//alert('d');
	obj=document.getElementById("BIMP");
	if (obj){ obj.onclick=Import_click; }

}


function Import_click()
{
	
	var obj=document.getElementById("IDBegin");
	if(obj) {var IDBeg=obj.value;}
	var obj=document.getElementById("IDEnd");
	if(obj) {var IDEnd=obj.value;}
	
	
	var Ret=tkMakeServerCall("web.DHCPE.PreGBaseInfo","Test",IDBeg,IDEnd);
	alert(Ret);
}
document.body.onload=BodyLoadHandler;