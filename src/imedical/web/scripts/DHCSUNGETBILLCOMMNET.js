document.body.onload = BodyLoadHandler;	

function BodyLoadHandler(){
 var	selectvalue=document.getElementById("selectvalue")
	selectvalue.onclick=getbilldetail;	
	}
function	getbilldetail(){
	
	var eSrc=window.event.srcElement
	var rowObj=getRow(eSrc);
    var selectrow=rowObj.rowIndex;
    var SelRowObj=document.getElementById('PbRowidz'+selectrow);	
    var buyrowid=SelRowObj.innerText;
var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCSUNGETBILLDETAILC&PBRowId='+buyrowid
window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')

	}