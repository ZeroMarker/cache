/// 名称: web.DHCMedClinicalReport.ReportInterface
/// 描述: 临床上报的接口
/// 编写者：zhufei
/// 编写日期: 2010-08-19
Class web.DHCMedClinicalReport.ReportInterface Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-08-19
/// Description:  增加到电子病历可重复模板“表头列”字符串
///               提供给电子病历的接口
/// Table：       
/// Input：       argTemplateID 模板ID
/// Return：      return 电子病历可重复模板“表头列”字符串
/// w ##class(web.DHCMedClinicalReport.ReportInterface).GetTHCellsString(argTemplateID)
ClassMethod GetTHCellsString(argTemplateID As %String) As %String
{
	New (argTemplateID)
	Set return=##class(DHCMed.CRService.Interface).GetTHCellsString(argTemplateID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  根据InstanceID取医政组附件单元信息“值”字符串
///               提供给电子病历的接口
/// Table：       
/// Input：       argInstanceID 实例数据ID
/// Return：      return 医政组附件单元信息“值”字符串
/// w ##class(web.DHCMedClinicalReport.ReportInterface).GetTDCellsString("395420||6")
ClassMethod GetTDCellsString(argInstanceID As %String) As %String
{
	New (argInstanceID)
	Set return=##class(DHCMed.CRService.Interface).GetTDCellsString(argInstanceID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-07-30
/// Description:  提供在病历书写下病历是否可再修改（保存）
///               提供给电子病历的接口
/// Table：       
/// Input：       argInstanceID 实例数据ID
/// Return：      return=0:表示不可修改  return=1:表示可修改
/// w ##class(web.DHCMedClinicalReport.ReportInterface).CanEdit(argInstanceID)
ClassMethod CanEdit(argInstanceID As %String) As %String
{
	New (argInstanceID)
	Set return=##class(DHCMed.CRService.Interface).CanEdit(argInstanceID)
	Quit return
}

}
