//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("LifeType^SourceType^Equip^Loc^EquipType");
	Muilt_LookUp("LifeType^SourceType^Equip^Loc^EquipType");
	initPanelHeaderStyle();		// MZY0151	2023-02-01
	$('#tDHCEQLifeInfo').datagrid({
		onClickRow:function(rowIndex, rowData){
			if (rowData.TSourceTypeDR=="35")
		    {
			    alertShow("折旧没有详细信息!");
			    websys_showModal("close");  
		    }
		}
	})
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}

function BClear_Click()
{
	SetElement("EndDate","");
	SetElement("StartDate","");
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("Loc","");
	SetElement("LocDR","");
	SetElement("LifeType","");
	SetElement("LifeTypeDR","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("SourceType","");
	SetElement("SourceTypeDR","");
}
function GetLifeType(value) {
	var user=value.split("^");
	var obj=document.getElementById("LifeTypeDR");
	obj.value=user[1];
}
function GetLifeSourceType(value) {
	var user=value.split("^");
	var obj=document.getElementById("SourceTypeDR");
	obj.value=user[1];
}
function GetEquip(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=user[1];
}
function GetEquipType(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipTypeDR");
	obj.value=user[1];
}
function GetLoc(value) {
	var user=value.split("^");
	var obj=document.getElementById("LocDR");
	obj.value=user[1];
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
