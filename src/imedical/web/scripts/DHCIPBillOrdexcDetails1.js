function BodyLoadHandler() 
{
	iniBgColor()
	
}
function SelectRowHandler()
{
var eSrc = window.event.srcElement
var rowObj=getRow(eSrc)
var selectrow=rowObj.rowIndex
var SelRowObj=document.getElementById('TBillOrdRowidz'+selectrow) //
//alert(SelRowObj.value)
parent.frames['DHCIPBillOrdItem'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdItem&PatBillOrd="+SelRowObj.innerText; 
}

function iniBgColor()
{
	var tableObj=document.getElementById('tDHCIPBillOrdexcDetails1');
	var rowNum=tableObj.rows.length
	
   
	for(var i=1;i<rowNum;i++)
	{
		var BillFlagObj=document.getElementById('TBillFlagz'+i)
        var BillFlag=BillFlagObj.innerText
        var Patamt=document.getElementById('Patamtz'+i).innerText
      
        if ((BillFlag=="未计费")||((BillFlag=="已计费")&(eval(Patamt)=="0.00")))
	    {
		   
		   BillFlagObj.style.color = "Red"
		   //tableObj.rows[i].cells[21].className="Red";
        }
        
	 }

}
document.body.onload = BodyLoadHandler;
