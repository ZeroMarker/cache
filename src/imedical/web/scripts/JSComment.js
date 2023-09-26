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
  	if(window.event.keyCode==13)
  	{
	  	var patNo = document.getElementById("PatNo").value;
	  	var hideEle = document.getElementById("hideEle");
	  	if(hideEle)
	  	{
		  	var encmeth = hideEle.value
	  	}
	  	else
	  	{
		  	var encmeth=""
	  	}
	  	alert(encmeth);
	  	var patName=cspRunServerMethod(encmeth,patNo);
	  	document.getElementById("PatName").value=patName
	  	
  	}
}

function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	
	var SelRowObj=document.getElementById("pbRowidz"+selectrow);
	BillRowid = SelRowObj.innerText;
	//alert(BillRowid)
	
}

function showDetail()
{	
    //alert(BillRowid);
	var str='websys.default.csp?WEBSYS.TCOMPONENT=BillDetailComment&BillRowid='+BillRowid;
	window.open(str,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=600,top=100,left=100");
	
}

document.body.onload=BodyLoadHandler;