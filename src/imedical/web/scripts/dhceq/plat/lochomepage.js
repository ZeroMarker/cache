jQuery(document).ready(function()
{
	defindTitleStyle();
	initEchartsObjMap();
	initChartsDefine("EQNumAmount^EQOverNumAmount^DPPreMonthDepre^MAPreMonthMaint^BYPreMonthAdd^MPCurMonthWorkLoad^EQEquipTypeAmount^EQEquipTypeNumPercent^EQEndOriginalNet^EQLastYearInStock","1");
});
function initEchartsObjMap()
{
	EchartsObjMap["EQEquipTypeAmount"]="LocEquipNumAmount"
	EchartsObjMap["EQEquipTypeNumPercent"]="EquipTypePercent"
	EchartsObjMap["EQEndOriginalNet"]="EndControl"
	EchartsObjMap["EQLastYearInStock"]="YearControl"
}