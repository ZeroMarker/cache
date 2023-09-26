function BodyLoadHandler() 
{
	
}

function SetEmployeeInfo(val)
{
	alertShow(val);
	Test();
	var employinfolist;
	employinfolist=val.split("^");
	var obj=document.getElementById("EmployeeDR");
	if (obj) obj.value=employinfolist[1];
}

function Test()
{
	var oPYWB = new ActiveXObject("WChsToPYWBC.PYWBC");
	var strTest=oPYWB.CHS2PY("≤‚ ‘", 1)
	alertShow(strTest);
	    	///var papersize=paperset.GetPaperInfo("stock");
	    	///xlsheet.PageSetup.PaperSize = papersize;
}

document.body.onload = BodyLoadHandler;