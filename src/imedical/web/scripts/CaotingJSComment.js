var BillRowid=0
function BodyLoadHandler()
{
	var patNo = document.getElementById("PatNo");
	if(patNo) 
	   patNo.onkeydown=GetInfor;
	   
	var clickButton = document.getElementById("ClickShow");
	if(clickButton)
	   clickButton.onclick=showDetail
	
}

function GetInfor()
{
  	if(window.event.keyCode==13){
		var PatNo=document.getElementById('PatNo').value
		var GetPatObj=document.getElementById('GetPatInfo')
		if(GetPatObj){var encmeth=GetPatObj.value}else{var encmeth=''}
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
	
	var SelRowObj=document.getElementById("PatBillRowIdz"+selectrow);
	BillRowid = SelRowObj.innerText;
	//alert(BillRowid)
	
}

function showDetail()
{	
    //alert(BillRowid);
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCPatBillDetail&pbrowid='+BillRowid;
	window.open(str,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=600,top=100,left=100");
	
}

document.body.onload=BodyLoadHandler;