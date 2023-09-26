var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("EquipType^StatCat^EquipCat^UseLoc");
	Muilt_LookUp("EquipType^StatCat^EquipCat^UseLoc");
	fillData();
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("IsDisUse");
	if (obj) obj.onchange=BIsDisUse_change;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
}

function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
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
				case "ContactSub":
					SetChkElement("ContactSub",Detail[1]);
				case "IsDisUseDR":
					SetElement("IsDisUseDR",Detail[1]);
					SetElement("IsDisUse",Detail[1]);
					break;
				default :
					SetElement(Detail[0],Detail[1]);
					break;
			}
		}
	}
}

function BIsDisUse_change()
{
	SetElement("IsDisUseDR",GetElementValue("IsDisUse"))
}

function BFind_Click()
{
	var StartDate=GetElementValue("StartDate");
	if (StartDate!="")
	{
		var encmeth=GetElementValue("IsMonth");
		var IsMonth=cspRunServerMethod(encmeth,StartDate);
		if (IsMonth=="1")
		{
			alertShow(t["01"]);
			return;
		}
	}
	var EndDate=GetElementValue("EndDate");
	if (EndDate!="")
	{
		var encmeth=GetElementValue("IsMonth");
		var IsMonth=cspRunServerMethod(encmeth,EndDate);
		if (IsMonth=="1")
		{
			alertShow(t["01"]);
			return;
		}
	}
	var ContactSub=0
	if (GetChkElementValue("ContactSub")==true)
	{
		var ContactSub=1
	}
	var EquipType=""
	if (GetElementValue("EquipTypeDR")!="")
	{
		var EquipType=GetElementValue("EquipType")
	}
	var StatCat=""
	if (GetElementValue("StatCatDR")!="")
	{
		var StatCat=GetElementValue("StatCat")
	}
	var EquipCat=""
	if (GetElementValue("EquipCatDR")!="")
	{
		var EquipCat=GetElementValue("EquipCat")
	}
	var UseLoc=""
	if (GetElementValue("UseLocDR")!="")
	{
		var UseLoc=GetElementValue("UseLoc")
	}
	var Item=""
	if (GetElementValue("ItemDR")!="")
	{
		var Item=GetElementValue("Item")
	}
	var val="&vData=";
	val=val+"^Equip="+GetElementValue("Equip");
	val=val+"^EquipNo="+GetElementValue("EquipNo");
	val=val+"^EquipCode="+GetElementValue("EquipCode");
	val=val+"^EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"^EquipType="+EquipType;
	val=val+"^StatCatDR="+GetElementValue("StatCatDR");
	val=val+"^StatCat="+StatCat;
	val=val+"^EquipCatDR="+GetElementValue("EquipCatDR");
	val=val+"^EquipCat="+EquipCat;
	val=val+"^ContactSub="+ContactSub;
	val=val+"^StartDate="+GetElementValue("StartDate");
	val=val+"^EndDate="+GetElementValue("EndDate");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^UseLoc="+UseLoc;
	val=val+"^StartOriginalFee="+GetElementValue("StartOriginalFee");
	val=val+"^EndOriginalFee="+GetElementValue("EndOriginalFee");
	val=val+"^InStockStartDate="+GetElementValue("InStockStartDate");
	val=val+"^InStockEndDate="+GetElementValue("InStockEndDate");
	val=val+"^IsDisUseDR="+GetElementValue("IsDisUseDR");
	val=val+"^ItemDR="+GetElementValue("ItemDR");
	val=val+"^Item="+GetElementValue("Item");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInvestCallBackTime"+val;
}

function GetEquipType(value) {
	var type=value.split("^");
	var obj=document.getElementById("EquipTypeDR");
	obj.value=type[1];
}

function GetStatCat(value) {
	var type=value.split("^");
	var obj=document.getElementById("StatCatDR");
	obj.value=type[1];
}

function GetCatID(value) {
	var type=value.split("^");
	var obj=document.getElementById("EquipCatDR");
	obj.value=type[1];
}

function GetUseLocID(value) {
	var type=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=type[1];
}
function GetItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ItemDR");
	obj.value=type[1];
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
