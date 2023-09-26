function BPrint1_Clicked()
{
	UserDefinedPrint("DHCEQ0001","DHCEQArgumentation1.xls")
}
function OtherSet()
{
	var obj=document.getElementById("FundsOrigin4");
	if (obj.checked)
	{
		DisableElement("A_OFundsTypeName",false);
	}
	else
	{
		DisableElement("A_OFundsTypeName",true);
		SetElement("A_OFundsTypeName","");
	}
}
function CheckData()
{
	return 0;
}