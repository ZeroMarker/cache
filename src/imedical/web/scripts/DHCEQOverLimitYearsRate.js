
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("UseLoc^MasterItem^EquipType^StatCat^EquipCat");	//清空选择	
	Muilt_LookUp("UseLoc^MasterItem^EquipType^StatCat^EquipCat");
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById(GetLookupName("EquipCat"));
	if (obj) obj.onclick=EquipCat_Click;
}

function BClear_Click() //清空按钮
{
	SetElement("MasterItem","");  
	SetElement("MasterItemDR","");
	SetElement("MinValue","");
	SetElement("MaxValue","");
	SetElement("StatCat","");
	SetElement("StatCatDR","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("BeginInStockDate","");
	SetElement("EndInStockDate","");
	SetElement("UseLoc","");
	SetElement("UseLocDR","");
	SetElement("EquipCat","");
	SetElement("EquipCatDR","");
	SetElement("IncludeFlag","");
}
///取得设备项rowid
function GetMasterItem(value)
{
	GetLookUpID("MasterItemDR",value);
}
///取得设备类组rowid
function GetEquipType (value)
{
    GetLookUpID("EquipTypeDR",value);
}
///取得设备类型rowid
function GetStatCat(value) 
{
	GetLookUpID("StatCatDR",value);
}
function GetEquipCat(value)
{
	GetLookUpID("EquipCatDR",value);
}
///取得设备使用科室rowid
function GetUseLoc(value)
{
	GetLookUpID("UseLocDR",value);
}
function EquipCat_Click()
{
	var CatName=GetElementValue("EquipCat")
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
}

function SetEquipCat(id,text)
{
	SetElement("EquipCat",text);
	SetElement("EquipCatDR",id);
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
