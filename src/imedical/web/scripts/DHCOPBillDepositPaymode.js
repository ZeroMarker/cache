 
function BodyLoadHandler() {
    var Printobj=document.getElementById("Print");
    if (Printobj) Printobj.onclick=Print_click;	
   
}

function Print_click()
{
	//CommonPrint("DHCOPDeptPrt");
	var EndDate=document.getElementById("EndDate").value
	var StartDate=document.getElementById("StartDate").value
	if((!StartDate)||(!EndDate)) {alert("ÇëÑ¡ÔñÊ±¼ä¶Î");return}
	if(StartDate.indexOf("/")>0){
		
		StartDate=StartDate.split("/")[2]+"-"+StartDate.split("/")[1]+"-"+StartDate.split("/")[0];
		EndDate=EndDate.split("/")[2]+"-"+EndDate.split("/")[1]+"-"+EndDate.split("/")[0];
		//alert(StartDate+"="+EndDate);
	}
	
	
	var fileName1="DHCOPBILLDHCOPBillDepositPaymode.raq&StartDate="+StartDate+"&EndDate="+EndDate;
	 DHCCPM_RQPrint(fileName1);		
}
document.body.onload = BodyLoadHandler;
