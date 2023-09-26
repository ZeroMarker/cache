
function BodyLoadHandler() 
{
	SetElement("IsForcedFlag",GetElementValue("IsForcedFlagValue"));
	InitPage();
}
function InitPage()
{
	//KeyUp("Equip^InspectType^ManageLoc^MeasureDept");
	//Muilt_LookUp("Equip^InspectType^ManageLoc^MeasureDept");
}
function GetEquip (value)
{
    GetLookUpID("EquipDR",value);
}
function GetInspectType (value)
{
    GetLookUpID("InspectTypeDR",value);
}
function GetManageLoc (value)
{
    GetLookUpID("ManageLocDR",value);
}
function GetMeasureDept (value)
{
    GetLookUpID("MeasureDeptDR",value);
}

document.body.onload = BodyLoadHandler;