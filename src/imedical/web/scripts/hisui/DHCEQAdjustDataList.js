///Created By HZY 2011-09-21 . HZY0012 
///Description:调整数据记录明细查询
///hisui 改造 add by wy 2019-10-30
function BodyLoadHandler()
{
	InitPage();
	Muilt_LookUp("FromLoc^FromEquipType^FromStatCat^ToLoc^ToEquipType^ToStatCat^Equip^RequestUser");
	fillData();
	SetValues();
	RefreshData();	
}

function SetValues()
{
	//SetElement("Status",GetElementValue("StatusDR"))
	SetElement("ReportFlag",GetElementValue("ReportFlagDR"))
	SetElement("AdjustType",GetElementValue("AdjustTypeDR"))
}

function InitPage()
{	
	KeyUp("FromLoc^FromEquipType^FromStatCat^ToLoc^ToEquipType^ToStatCat^Equip^RequestUser");	
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("AdjustType");
	if (obj) obj.onchange=AdjustType_Change;
	var obj=document.getElementById("ReportFlag");
	if (obj) obj.onchange=ReportFlag_Change;
	/*
	var obj=document.getElementById("Status");
	if (obj) obj.onchange=Status_Change;
	*/
}

function AdjustType_Change()
{
	SetElement("AdjustTypeDR",GetElementValue("AdjustType"));
}

function ReportFlag_Change()
{
	SetElement("ReportFlagDR",GetElementValue("ReportFlag"));
}
/*
function Status_Change()
{
	SetElement("StatusDR",GetElementValue("Status"));
}
*/
function GetLoc(value)
{
	GetLookUpID("FromLocDR",value);
}

function GetEquipType(value)
{
	GetLookUpID("FromEquipTypeDR",value);
}

function GetStatCat(value)
{
	GetLookUpID("FromStatCatDR",value);
}

function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}

function GetToEquipType(value)
{
	GetLookUpID("ToEquipTypeDR",value);
}

function GetToStatCat(value)
{
	GetLookUpID("ToStatCatDR",value);
}

function GetEquip(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=user[1];
}


function BFind_Click()
{
	var val="&vData="
	val=val+GetVData();
	//alertShow("vData="+val);
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQAdjustDataList"+val;  //hisui 改造 add by wy 2019-10-30
}


function GetVData()
{
	var val="^QXType="+GetElementValue("QXType");
	val=val+"^FromLocDR="+GetElementValue("FromLocDR");				//设备原库房
	val=val+"^StatusDR="+GetElementValue("StatusDR");		//状态
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	val=val+"^FromEquipTypeDR="+GetElementValue("FromEquipTypeDR");	//设备原类组
	val=val+"^RequestUser="+GetElementValue("RequestUser");
	val=val+"^FromStatCatDR="+GetElementValue("FromStatCatDR");
	val=val+"^ReportFlagDR="+GetElementValue("ReportFlag");		//Modify by yh
	val=val+"^AdjustTypeDR="+GetElementValue("AdjustType");		//Modify by yh
	val=val+"^ToLocDR="+GetElementValue("ToLocDR");
	val=val+"^ToEquipTypeDR="+GetElementValue("ToEquipTypeDR");	
	val=val+"^ToStatCatDR="+GetElementValue("ToStatCatDR");
	//alertShow(val);	//Test
	return val;
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR")+"^";
	val=val+"dept=FromLoc="+GetElementValue("FromLocDR")+"^";
	val=val+"statcat=FromStatCat="+GetElementValue("FromStatCatDR")+"^";
	val=val+"equiptype=FromEquipType="+GetElementValue("FromEquipTypeDR")+"^";
	val=val+"dept=ToLoc="+GetElementValue("ToLocDR")+"^";
	val=val+"statcat=ToStatCat="+GetElementValue("ToStatCatDR")+"^";
	val=val+"equiptype=ToEquipType="+GetElementValue("ToEquipTypeDR")+"^";
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function RefreshData()
{
	var vdata1=GetElementValue("vData");
	var vdata2=GetVData();
	if (vdata1!=vdata2) BFind_Click();
}

document.body.onload = BodyLoadHandler;
