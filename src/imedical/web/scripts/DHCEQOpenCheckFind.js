
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	KeyUp("Equip^ManuFactory^Provider^ManageLoc^UseLoc^Status");
	Muilt_LookUp("Equip^ManuFactory^Provider^ManageLoc^UseLoc^Status");
	var Type=GetElementValue("Type")
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
}
function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}
function GetEquip(value){
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
}
function GetManageLoc(value){
	var user=value.split("^");
	var obj=document.getElementById('ManageLocDR');
	obj.value=user[1];
}
function GetUseLoc(value){
	var user=value.split("^");
	var obj=document.getElementById('UseLocDR');
	obj.value=user[1];
}
function GetStatus(value){
	var user=value.split("^");
	var obj=document.getElementById('StatusDR');
	obj.value=user[1];
}
function GetProvider(value){
	var user=value.split("^");
	var obj=document.getElementById('ProviderDR');
	obj.value=user[1];
}
function GetManuFactory(value){
	var user=value.split("^");
	var obj=document.getElementById('ManuFactoryDR');
	obj.value=user[1];
}

document.body.onload = BodyLoadHandler;