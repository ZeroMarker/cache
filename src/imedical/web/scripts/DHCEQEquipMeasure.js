///DHCEQEquipMeasure.js
///¼ÆÁ¿Ì¨ÕÊ
function BodyLoadHandler() 
{
	InitPage();
	fillData();
	RefreshData();
	HiddenTableIcon("DHCEQEquipMeasure","TRowID","TEquip");	///add by lmm
}
function InitPage()
{
	KeyUp("UseLoc^PlanName");
	Muilt_LookUp("UseLoc^PlanName");
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}
function BFind_Click()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipMeasure";
	lnk=lnk+"&Data="+GetData();
	lnk=lnk+"&QXType="+GetElementValue("QXType");
	lnk=lnk+"&ReadOnly="+GetElementValue("ReadOnly");
	location.href=lnk;
}

function GetInspectType (value)
{
    GetLookUpID("InspectTypeDR",value);
}
function GetManageLoc (value)
{
    GetLookUpID("ManageLocDR",value);
}
function GetPlanNameID (value)
{
    GetLookUpID("PlanNameDR",value);
}
function GetUseLocID (value)
{
    GetLookUpID("UseLocDR",value);
}
function RefreshData()
{
	var data1=GetElementValue("Data");
	var data2=GetData();
	
	if (data1!=data2) BFind_Click();
}
function GetData()
{
	var	val="^No="+GetElementValue("No");
	val=val+"^Equip="+GetElementValue("Equip");
	val=val+"^PlanNameDR="+GetElementValue("PlanNameDR");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	
	return val;
}
function fillData()
{
	var Data=GetElementValue("Data");
	if (Data!="")
	{
		var list=Data.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				case "ReduceFilter":
				    SetChkElement(Detail[0],Detail[1]);
				    break;
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"MaintPlan=PlanName="+GetElementValue("PlanNameDR")+"^";
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^";
	
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}
document.body.onload = BodyLoadHandler;