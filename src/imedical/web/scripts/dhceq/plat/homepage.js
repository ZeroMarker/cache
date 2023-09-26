jQuery(document).ready(function()
{
	defindTitleStyle();
	initEchartsObjMap();
	initChartsDefine("EQNumAmount^EQOverNumAmount^DPPreMonthDepre^MAPreMonthMaint^BYPreMonthAdd^MPCurMonthWorkLoad^EQLocEquipAmount1^EQLocEquipNum1^EQStatCatNumPercent^EQEndOriginalNet^EQOverYearInStock","");
});
function initEchartsObjMap()
{
	EchartsObjMap["EQLocEquipNum1"]="LocEquipNumAmount"
	EchartsObjMap["EQLocEquipAmount1"]="LocEquipNumAmount"
	EchartsObjMap["EQStatCatNumPercent"]="EquipTypePercent"
	EchartsObjMap["EQEndOriginalNet"]="EndControl"
	EchartsObjMap["EQOverYearInStock"]="YearControl"
}