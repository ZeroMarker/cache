
///DHCEQEquipMeasure.js
///计量台帐
function BodyLoadHandler() 
{
	InitPage();
	fillData();
	RefreshData();
	initButtonWidth();	//modified by czf 20180821 HISUI改造
	//HiddenTableIcon("DHCEQEquipMeasure","TRowID","TEquip");	///add by lmm
	//add by lmm 2020-04-27	1282978
	//add by lmm 2020-05-06 1303731 begin
	SetElement("cEQTitle","计量设备台账");  
	if (GetElementValue("IsDisused")=="Y")
	{
		$('#tDHCEQEquipMeasure').datagrid('hideColumn','TName');	
		//$('#tDHCEQEquipMeasure').datagrid('hideColumn','TLastDate');	 //modify by lmm 2020-05-13
		$('#tDHCEQEquipMeasure').datagrid('hideColumn','TCycleNum');	
		$('#tDHCEQEquipMeasure').datagrid('hideColumn','TPreWarnDaysNum');	
		$('#tDHCEQEquipMeasure').datagrid('hideColumn','TNextDate');	
		SetElement("cEQTitle","已报废计量设备台账");  
		hiddenObj("cPlanName",1)
		hiddenObj("PlanName",1)
		hiddenObj("BAdd",1)   //add by lmm 2020-05-07
	}
	else
	{
	$('#tDHCEQEquipMeasure').datagrid('hideColumn','TDisuseDate');	
	}
	//add by lmm 2020-05-06 1303731 end
	//add by lmm 2020-04-27	1282978
}

function InitPage()
{
	KeyUp("UseLoc^PlanName");
	Muilt_LookUp("UseLoc^PlanName");
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	//add by lmm 2020-05-07
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
}

//add by lmm 2020-05-13
function BAdd_Click()
{
	url="dhceq.em.equipbymeasure.csp?"+"&SourceType=3"+"&ComputerFlag=N"+"&Planstatus=3"; 
	showWindow(url,"设备台账","","","icon-w-paper","modal","","","verylarge",BFind_Click)  //modify by lmm 2020-06-05 UI
	
}


function BFind_Click()
{
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipMeasure";	//modified by czf 20180815 HISUI改造
	lnk=lnk+"&Data="+GetData();
	lnk=lnk+"&QXType="+GetElementValue("QXType");
	lnk=lnk+"&ReadOnly="+GetElementValue("ReadOnly");
	lnk=lnk+"&IsDisused="+GetElementValue("IsDisused");   //add by lmm 2020-04-27 1282978
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