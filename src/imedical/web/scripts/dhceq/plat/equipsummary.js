var Columns=getCurColumnsInfo('EM.G.EquipSummary','','','')
var queryParams={ClassName:"web.DHCEQ.Plat.CTChartsDefine",QueryName:"EquipSummary"}

jQuery(document).ready(function()
{
	defindTitleStyle();
	//initEquipSummary();
	initEchartsObjMap();
	initChartsDefine("EQLocEquipNum1^EQLocEquipAmount1^EQStatCatNumPercent^EQYearNum^EQYearAmount^EQEquipTypeNumPercent","");
});
function initEchartsObjMap()
{
	EchartsObjMap["EQYearNum"]="YearEquipNumAmount"
	EchartsObjMap["EQYearAmount"]="YearEquipNumAmount"
	EchartsObjMap["EQLocEquipNum1"]="LocEquipNumAmount"
	EchartsObjMap["EQLocEquipAmount1"]="LocEquipNumAmount"
	EchartsObjMap["EQStatCatNumPercent"]="EQStatCatNumPercent"
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
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:Columns,
		pagination:true,
		pageSize:8,
		pageList:[8]
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}
///�������б�ɹ�����ʱ���ã���д����Ӱ���б��ҳ�����б�������ʾ
function LoadSuccess()
{
}