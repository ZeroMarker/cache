
function BodyLoadHandler(){		
	InitPage();
}

function InitPage()
{
	//KeyUp("ManageLoc^InspectType^Model^Equip");
	//Muilt_LookUp("ManageLoc^InspectType^Model^Equip");
}

function GetInspectType(value){
	var user=value.split("^");
	var obj=document.getElementById('InspectTypeDR');
	obj.value=user[1];
}
function GetManageLoc(value){
	var user=value.split("^");
	var obj=document.getElementById('ManageLocDR');
	obj.value=user[1];
}
function GetModel(value){
	var user=value.split("^");
	var obj=document.getElementById('ModelDR');
	obj.value=user[1];
}
function GetEquip(value){
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
}
document.body.onload = BodyLoadHandler;