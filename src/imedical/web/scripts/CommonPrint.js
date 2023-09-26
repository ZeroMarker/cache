function CommonPrint(ReportName)
{
	//alert(ReportName);
	var myxmlstr=(DHCDOM_WriteXMLInParameter());
	var myobj=document.getElementById("CPMReport");
	if (myobj)
	{
		myobj.PrintCommonReport(ReportName, myxmlstr);
	}
}