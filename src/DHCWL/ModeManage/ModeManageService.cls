Class DHCWL.ModeManage.ModeManageService Extends %RegisteredObject
{

//d ##class(DHCWL.ModeManage.ModeManageService).GetKpisByTabID("CYRS",mydata)

/// 名称: GetKpisByTabCode
/// 描述: 根据报表编码获取该报表下所有指标的指标编码，维度。
/// 参数: tabCode——字符串类型。报表编码
/// 	  kpiData——数组类型。用于存放报表所包含的指标或指标维度。
///       指标或维度的存放顺序与指标序号相同。数组中单个数据元素按下列各式存放数据：
///       kpi1:kpiDimCode1.dimPro1^kpiDimCode1.dimPro2^kpiDimCode2.dimPro1
/// 
/// 编写者： 王峥
/// 编写日期:2013-11-29
ClassMethod GetKpisByTabCode(tabCode As %String, ByRef kpiData)
{
	;&sql(select kpicfg_code, kpicfg_dimcfgrule into :kpicfgCode,:kpicfgdimcfgrule from DHCWL_MKPI.ModeMagKpiCfg where kpicfg_pcode = :tabCode)		
	;i +$g(SQLCODE)=0 w "{success:true,tip:'ok'}" 
	;^DHCWL.MKPI.ModeMagKpiCfgI("RptKpiIndex","CYRS",30)
	q:'$d(^DHCWL.MKPI.ModeMagKpiCfgI("RptKpiIndex",tabCode))
	k kpiData
	s kpiCfgRowID=0
	s defaultOrderNum=1000
	f  s kpiCfgRowID=$o(^DHCWL.MKPI.ModeMagKpiCfgI("RptKpiIndex",tabCode,kpiCfgRowID))  q:kpiCfgRowID=""  d
	.s kpiCode=$li(^DHCWL.MKPI.ModeMagKpiCfgD(kpiCfgRowID),2)
	.s KpiCfgDimCfgRule=$li(^DHCWL.MKPI.ModeMagKpiCfgD(kpiCfgRowID),3)
	.s KpiCfgOrderNum=$li(^DHCWL.MKPI.ModeMagKpiCfgD(kpiCfgRowID),5)
	.i $g(KpiCfgDimCfgRule)="" 	s kpiStr=kpiCode
	.else  d 
	..s KpiCfgDimCfgRule=$TRANSLATE(KpiCfgDimCfgRule,"%","^")
	..s kpiStr=kpiCode_":"_KpiCfgDimCfgRule
	.i +$g(KpiCfgOrderNum)=0  d
	..s KpiCfgOrderNum=defaultOrderNum
	..s defaultOrderNum=defaultOrderNum+1
	.s kpiData(KpiCfgOrderNum)=kpiStr
}

}
