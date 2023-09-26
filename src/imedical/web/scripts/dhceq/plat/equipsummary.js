var Columns=getCurColumnsInfo('EM.G.EquipSummary','','','')
var queryParams={ClassName:"web.DHCEQ.Plat.CTChartsDefine",QueryName:"EquipSummary"}

jQuery(document).ready(function()
{
	defindTitleStyle();
	initEquipSummary();
	initEchartsObjMap();
	initChartsDefine("EQLocEquipAmount1^EQLocEquipNum1^EQEquipTypeNumPercent","");
});
function initEchartsObjMap()
{
	EchartsObjMap["EQLocEquipNum1"]="LocEquipNumAmount"
	EchartsObjMap["EQLocEquipAmount1"]="LocEquipNumAmount"
	EchartsObjMap["EQEquipTypeNumPercent"]="EquipTypePercent"
}
function initEquipSummary()
{
	$HUI.datagrid("#EquipSummary",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTChartsDefine",
			QueryName:"EquipSummary",
			EJob:getElementValue("EJob")
		},
		border:true,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:Columns,
		pagination:true,
		pageSize:8,
		pageList:[8]
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}
///描述：列表成功加载时调用，不写方法影响列表分页栏及列表数据显示
function LoadSuccess()
{
}