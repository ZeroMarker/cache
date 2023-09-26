//Éè±¸Ê×Ò³
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
  InitUserInfo();
	InitEvent();	
}
function InitEvent()
{
	var obj=document.getElementById("BEquip");
	if (obj) obj.onclick=BEquip_Click;
	var obj=document.getElementById("BContractMaint");
	if (obj) obj.onclick=BContractMaint_Click;
	var obj=document.getElementById("BMaintRequest");
	if (obj) obj.onclick=BMaintRequest_Click;
	var obj=document.getElementById("BMeasure");
	if (obj) obj.onclick=BMeasure_Click;
	var obj=document.getElementById("BEvaluate");
	if (obj) obj.onclick=BEvaluate_Click;
}
function BEquip_Click() 
{
	val="dhceqequipfind.csp?&ReadOnly=&UseLocDR="	//+curLocID;
  window.location.href=val;
}
function BContractMaint_Click()
{
	val='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQContractForMaint&StatusDR=0&Type=0&QXType=1&WaitAD=off';
  window.location.href=val;
}
function BMaintRequest_Click() 
{
	window.location.href= "dhceqmmaintrequest.csp?RowID=&Status=0&ExObjDR=";
}
function BMeasure_Click() 
{
	var val="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipMeasure&BussType=2&QXType=1&ReadOnly=1&UseLocDR="+curLocID;
  window.location.href=val;
}
function BEvaluate_Click()
{
	val="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBusinessForEvaluate&CurRole=21&EvaluateGroup=02&CheckEvaluate=1&ChkFlag=";
  window.location.href=val;
}
document.body.onload = BodyLoadHandler;