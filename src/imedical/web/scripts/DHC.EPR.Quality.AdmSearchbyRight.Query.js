function InitFrom()
{
	InitLocID();
	var obj=document.getElementById("ALocDesc");
	if (obj){obj.onchange=txtLocDesc_onChange;}
	var obj=document.getElementById("AWardDesc");
	if (obj){obj.onchange=txtWardDesc_onChange;}
	var obj=document.getElementById("ADoctorDesc");
	if (obj){obj.onchange=txtDoctorDesc_onChange;}
	var obj=document.getElementById("btnSearch");
	if (obj){obj.onclick=btnSearch_onClick;}
}

function InitLocID()
{ 
	var msLocobj = document.getElementById('MethodGetMsLocByCode');
	if (msLocobj) { var encmeth = msLocobj.value } else { var encmeth = '' }
    var msLoc = cspRunServerMethod(encmeth, "MRSSGroup");
	var obj = document.getElementById("LOGON.CTLOCID");
	if (obj.value != msLoc)
	{
        var currentLocobj = document.getElementById('MethodGetLocbyID');
	    if (currentLocobj) { var cencmeth = currentLocobj.value } else { var cencmeth = '' }
        var currentLoc = cspRunServerMethod(cencmeth,obj.value);
		setElementValue("ALocID",obj.value);
		setElementValue("ALocDesc",currentLoc);
        document.getElementById("ALocDesc").disabled = true;
        document.getElementById("IsAllLocs").disabled = true;
	}
}

function txtLocDesc_onChange()
{
	setElementValue("ALocID","");
	setElementValue("AWardID","");
	setElementValue("AWardDesc","");
	setElementValue("ADoctorID","");
	setElementValue("ADoctorDesc","");
}

function txtWardDesc_onChange()
{
	setElementValue("AWardID","");
	setElementValue("ADoctorID","");
	setElementValue("ADoctorDesc","");
}

function txtDoctorDesc_onChange()
{
	setElementValue("ADoctorID","");	
}

function GetLoc(str)
{
	var tmpList=str.split("^");
	setElementValue("ALocID",tmpList[0]);
	setElementValue("ALocDesc",tmpList[1]);
}

function GetWard(str)
{
	var tmpList=str.split("^");
	setElementValue("AWardID",tmpList[0]);
	setElementValue("AWardDesc",tmpList[1]);
}

function GetDoctor(str)
{
	var tmpList=str.split("^");
	setElementValue("ADoctorID",tmpList[0]);
	setElementValue("ADoctorDesc",tmpList[2]);	
}

function btnSearch_onClick()
{
	var LocID=getElementValue("ALocID",null);
	var WardID=getElementValue("AWardID",null);
	var DoctorID=getElementValue("ADoctorID",null);
	var RegNo=getElementValue("ARegNo",null);
	var PatientName=getElementValue("APatientName",null);
	var RuleCode = getElementValue("ARuleCode", null);
	var IsMultiSummary = getElementValue("AIsMultiSummary",null);
	var IsAllLocs = getElementValue("IsAllLocs",null);

	if (LocID==""&&WardID==""&&RegNo==""&&PatientName==""&&IsAllLocs=="N")
	{
	    alert("为保证查询效率，请选择科室、病区或者患者登记号、姓名之一进行检索！");
	    return;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.AdmSearchbyRight.List&ALocID="+LocID+"&AWardID="+WardID+"&ADoctorID="+DoctorID+"&ARegNo="+RegNo+"&APatientName="+PatientName+"&ARuleCode="+RuleCode+"&AIsMultiSummary="+IsMultiSummary+"&AIsAllLocs="+IsAllLocs;
	parent.frames(1).location.href=lnk;	
}

InitFrom();