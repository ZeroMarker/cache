//add by lfb for bug1998
var m_RegNoLength=10

function InitFrom()
{
	var obj=document.getElementById("ALocDesc");
	if (obj){obj.onchange=txtLocDesc_onChange;}
	var obj=document.getElementById("AWardDesc");
	if (obj){obj.onchange=txtWardDesc_onChange;}
	var obj=document.getElementById("ADoctorDesc");
	if (obj){obj.onchange=txtDoctorDesc_onChange;}
	var obj=document.getElementById("btnSearch");
	if (obj){obj.onclick=btnSearch_onClick;}
	var obj = document.getElementById("ARegNo")
	if (obj){
		obj.onkeydown=RegNo_OnKeyDown;
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
		//add by lfb for bug1998
	SetRegNoLength()
	var PatientName=getElementValue("APatientName",null);
	var RuleCode = getElementValue("ARuleCode", null);
	if (LocID==""&&WardID==""&&RegNo==""&&PatientName=="")
	{
	    alert("为保证查询效率，请选择科室、病区或者患者登记号、姓名之一进行检索！");
	    return;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.AdmSearch.List&ALocID="+LocID+"&AWardID="+WardID+"&ADoctorID="+DoctorID+"&ARegNo="+RegNo+"&APatientName="+PatientName+"&ARuleCode="+RuleCode;
	//parent.frames(1).location.href=lnk;
	window.parent.RPbottom.location.href=lnk;	
}
//add by lfb for bug1998
function SetRegNoLength(){
	var obj=document.getElementById('ARegNo');
	if (obj.value!='') 
	{
		if ((obj.value.length<m_RegNoLength)&&(m_RegNoLength!=0)) 
		{
			for (var i=(m_RegNoLength-obj.value.length-1); i>=0; i--)
			{
				obj.value="0"+obj.value;
			}
		}
	}
}
function RegNo_OnKeyDown()
{
	if(window.event.keyCode != 13)
	return;
	SetRegNoLength();
	 //var RegNo=getElementValue("ARegNo",null);
	obj.onkeydown=btnSearch_onClick;
}
InitFrom();