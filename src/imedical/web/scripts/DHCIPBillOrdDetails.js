function BodyLoadHandler() 
{
	
	
}
function SelectRowHandler()
{
var eSrc = window.event.srcElement
var rowObj=getRow(eSrc)
var selectrow=rowObj.rowIndex
var SelRowObj=document.getElementById('Toerowidz'+selectrow) //
parent.frames['DHCIPBillOrdexcDetails'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdexcDetails&Oeordrowid="+SelRowObj.value; 
}


document.body.onload = BodyLoadHandler;
