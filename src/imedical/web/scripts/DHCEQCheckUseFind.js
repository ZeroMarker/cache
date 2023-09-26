
function BodyLoadHandler(){		
	InitPage();
}


function InitPage()
{
	KeyUp("Equip^ManageLoc^UseLoc^Status");
	Muilt_LookUp("Equip^ManageLoc^UseLoc^Status");
}



function GetEquip (value)
{
    GetLookUpID("EquipDR",value);
}
function GetManageLoc (value)
{
    GetLookUpID("ManageLocDR",value);
}
function GetUseLoc (value)
{
    GetLookUpID("UseLocDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}


document.body.onload = BodyLoadHandler;