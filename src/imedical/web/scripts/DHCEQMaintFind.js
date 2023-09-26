
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	SetElement("Status",GetElementValue("StatusDR"));
	var MaintTypeDR=GetElementValue("MaintTypeDR")
	if (GetElementValue("BussType")==2)
	{
		KeyUp("MaintUser^MaintLoc^Model^Equip");
		Muilt_LookUp("MaintUser^MaintLoc^Model^Equip");
		if (MaintTypeDR==4)
		{
			HiddenTableIcon("DHCEQInspectFind","TMaintPlanDR","TMaintPlan");   //add by czf 需求号：352468
		}
		if (MaintTypeDR==5)
		{
			HiddenTableIcon("DHCEQMeterageFind","TMaintPlanDR","TMaintPlan");   //add by czf 需求号：352468
		}
	}
	else
	{
		KeyUp("MaintUser^MaintType^MaintLoc^Model^Equip");
		Muilt_LookUp("MaintUser^MaintType^MaintLoc^Model^Equip");
		HiddenTableIcon("DHCEQMaintFind","TMaintPlanDR","TMaintPlan");	//add by czf 需求号：352468
	}
}

function GetMaintType(value){
	var user=value.split("^");
	var obj=document.getElementById('MaintTypeDR');
	obj.value=user[1];
}
function GetMaintUser(value){
	var user=value.split("^");
	var obj=document.getElementById('MaintUserDR');
	obj.value=user[1];
	//alertShow(obj.value)
}
function GetMaintLoc(value){
	var user=value.split("^");
	var obj=document.getElementById('MaintLocDR');
	obj.value=user[1];
}
function GetModel(value){
	var user=value.split("^");
	var obj=document.getElementById('ModelDR');
	obj.value=user[1];
}
function GetEquip(value){
	var user=value.split("^");
	var obj=document.getElementById('Equip');
	obj.value=user[0];
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
}
document.body.onload = BodyLoadHandler;