var ssrowid
function BodyLoadHandler()
{
	var GetPatNoObject=document.getElementById('PatNo');
	if(GetPatNoObject) GetPatNoObject.onkeydown=GetPatInfo_Click
	var clickButton = document.getElementById("findbilldetails");
	clickButton.onclick=GetBillorder
	
}
function GetPatInfo_Click()
{ 
   if(window.event.keyCode==13)
   { 
     var GetPatInfoMethodObj=document.getElementById('GetPatInfo')
     if(GetPatInfoMethodObj){var encmeth=GetPatInfoMethodObj.value}
     else{var encmeth=''}
     var PatNo=document.getElementById('PatNo').value
     var PatInfo=cspRunServerMethod(encmeth,PatNo)
     PatInfo=PatInfo.split("^")
     document.getElementById('PatName').value=PatInfo[0]
     document.getElementById('PatSex').value=PatInfo[1]
   }
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	
	var SelRowObj=document.getElementById("patbilldetailsz"+selectrow);
	ssrowid = SelRowObj.innerText;
	alert(ssrowid)
	
}

function GetBillorder()
{
 var str='websys.default.csp?WEBSYS.TCOMPONENT=details&aarowid='+ssrowid+'&deposittype='+t['01']
 window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
}
document.body.onload=BodyLoadHandler