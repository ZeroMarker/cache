function GetPatDepositFeeInfo(Adm)
{   
    var PatDepositFeeObj=document.getElementById('GetDepositFee');
  
	if (PatDepositFeeObj) 
	   {
		var encmeth=PatDepositFeeObj.value}
	else {
		 var encmeth=''};
		
	var PatDepositFee=cspRunServerMethod(encmeth,Adm)
	PatDepositFee=PatDepositFee.split("^")

	document.getElementById('DepositSelf').value=PatDepositFee[0]
	document.getElementById('DepositInsu').value=PatDepositFee[1]
	document.getElementById('PatFeeSelf').value=PatDepositFee[2]
	document.getElementById('PatFeeInsu').value=PatDepositFee[3]
	document.getElementById('RemainSelf').value=PatDepositFee[4]
	document.getElementById('RemainInsu').value=PatDepositFee[5]
	if (eval(PatDepositFee[4])<0)
	{  document.getElementById("RemainSelf").style.color="red"   }
	if (eval(PatDepositFee[5])<0)
	{  document.getElementById("RemainInsu").style.color="red"   }
}