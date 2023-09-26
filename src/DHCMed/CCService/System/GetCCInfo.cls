/// 创建者：刘宇辉
/// 创建日期：2010-10-29
/// 作用：获取监控结果
Class DHCMed.CCService.System.GetCCInfo Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 描述： 传入监控明细，返回指定格式的监控结果
/// 调用方法: w ##Class(DHCMed.CCService.System.GetCCInfo).GetCCDetail("O"_$c(1)_"58467||4^2008-12-23^11:34:00^普食^2008-12-23^00:00:00^核实")
ClassMethod GetCCDetail(detail As %String) As %String
{
	s ret=""
	q:detail="" ret
	
	s FirstStr=$e(detail,0,1)
	s:FirstStr="O" ret=##Class(DHCMed.CCService.Lib.OrderTestLib).GetDetails(detail)
	s:FirstStr="R" ret=##Class(DHCMed.CCService.Lib.RisExamLib).GetDetails(detail)
	s:FirstStr="L" ret=##Class(DHCMed.CCService.Lib.LabTestLib).GetDetails(detail)
	s:FirstStr="T" ret=##Class(DHCMed.CCService.Lib.PatCompareLib).GetTempDetails(detail)
	s:FirstStr="D" ret=##Class(DHCMed.CCService.Lib.MRDiagnoseTestLib).GetDetails(detail)
	s:FirstStr="A" ret=##Class(DHCMed.CCService.Lib.PatCompareLib).GetAgeDetails(detail)
	s:FirstStr="S" ret=##Class(DHCMed.CCService.Lib.DeathLib).GetDetails(detail)
	q ret
}

Storage Default
{
<Data name="GetCCInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CCService81D.GetCCInfoD</DataLocation>
<DefaultData>GetCCInfoDefaultData</DefaultData>
<IdLocation>^DHCMed.CCService81D.GetCCInfoD</IdLocation>
<IndexLocation>^DHCMed.CCService81D.GetCCInfoI</IndexLocation>
<StreamLocation>^DHCMed.CCService81D.GetCCInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
