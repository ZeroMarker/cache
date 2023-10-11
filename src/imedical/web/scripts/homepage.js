jQuery(document).ready(function()
{
	initUserInfo();
	defindTitleStyle();
	initEchartsObjMap();
	initChartsDefine("EQNumAmount^EQOverNumAmount^DPPreMonthDepre^MAPreMonthMaint^BYPreMonthAdd^MPCurMonthWorkLoad^EQLocEquipAmount1^EQLocEquipNum1^EQStatCatNumPercent^EQEndOriginalNet^EQOverYearInStock","");
	initChartsDefine("EQOriginNumPercent",",2")	//czf 2021-04-25 1874218
	// MZY0148	3163818		2023-1-3
	if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite"))
	{
		$("#EQNumAmount").css({color:"#05A489",background:"#E6FFFB"});
		$("#EQOverNumAmount").css({color:"#AC5919",background:"#FFF3E1"});
		$("#DPPreMonthDepre").css({color:"#8C07BB",background:"#F4E5F9"});
		$("#MAPreMonthMaint").css({color:"#0052A7",background:"#E8F3FF"});
		$("#BYPreMonthAdd").css({color:"#000000",background:"#ECECEC"});
	}
});
function initEchartsObjMap()
{
	EchartsObjMap["EQLocEquipNum1"]="LocEquipNumAmount"
	EchartsObjMap["EQLocEquipAmount1"]="LocEquipNumAmount"
	EchartsObjMap["EQStatCatNumPercent"]="EquipTypePercent"
	EchartsObjMap["EQEndOriginalNet"]="EndControl"
	EchartsObjMap["EQOverYearInStock"]="YearControl"		//czf 2021-04-25 1874218
	EchartsObjMap["EQOriginNumPercent"]="FaOriginAnaly"
}
