var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("UseLoc^Equip^Model^Service^ConsumableItem^Item");
	Muilt_LookUp("UseLoc^Equip^Model^Service^ConsumableItem^Item");
	fillData();
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
	val=val+"dept=UseLoc="+GetElementValue("UseLocDR")+"^";
	val=val+"service=Service="+GetElementValue("ServiceDR")+"^";
	val=val+"masteritem=Item="+GetElementValue("ItemDR")+"^";
	val=val+"consumableitem=ConsumableItem="+GetElementValue("ConsumableItemDR")+"^";
	val=val+"model=Model="+GetElementValue("ModelDR");
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()
{
	var val="&vData="
	val=val+"^Year="+GetElementValue("Year");
	val=val+"^Month="+GetElementValue("Month");
	val=val+"^EquipDR="+GetElementValue("EquipDR");
	val=val+"^ServiceDR="+GetElementValue("ServiceDR");
	val=val+"^ModelDR="+GetElementValue("ModelDR");
	val=val+"^UseLocDR="+GetElementValue("UseLocDR");
	val=val+"^PatientInfo="+GetElementValue("PatientInfo");
	val=val+"^ConsumableItemDR="+GetElementValue("ConsumableItemDR");
	val=val+"^ItemDR="+GetElementValue("ItemDR");	
	val=val+"&StartDate="+GetElementValue("StartDate");
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&QXType="+GetElementValue("QXType");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQUseConsumableFind"+val;
}

function GetModel(value) {
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
	obj.value=type[1];
}

function GetServiceItem(value) {
	var type=value.split("^");
	var obj=document.getElementById("ServiceDR");
	obj.value=type[1];
}

function GetSourceID(value)
{
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetUseLoc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("UseLocDR");
	obj.value=type[1];
}

function GetConsumableItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ConsumableItemDR");
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
