/// 名称: DHCHAI.DI.DIO.EnsFromLis1Srv
/// 描述: 检验数据接口--平台
/// 编写者：zhoubo
/// 编写日期: 2019-10-29
Class DHCHAI.DI.DIO.EnsFromLis1Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2019-10-29
/// Description:  通过检验报告ID取检验结果接口
/// Input：       aReportID:检验报告ID
/// Return：      检验结果信息
/// w ##Class(DHCHAI.DI.DIO.EnsFromLis1Srv).GetRepResult(22870)
ClassMethod GetRepResult(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="GetRepResultErr"
	//调用检验组提供的接口
	Set ds = ##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
	Do ds.Execute(aReportID)
	while(ds.Next())
	{
		Set TestCode 	= ds.Data("TestCodeName")	//检验项目名称
		Set TCCode	 	= ds.Data("TestCodeCode")	//检验项目代码
		Continue:(TestCode="")||(TCCode="")
		Set RstFormat 	= ds.Data("ResultFormat")	//结果类型
		Set Result 		= ds.Data("Result")			//检测结果
		Set TextRes 	= ds.Data("Result")		    //定性结果与结果一样
		Set ResNoes 	= ds.Data("ResNoes")		//结果说明(备注)
		Set AbFlag 		= ds.Data("AbFlag")			//异常提示
		Set Unit 		= ds.Data("Units")			//单位
		Set RefRanges 	= ds.Data("RefRanges")		//参考范围
		Set MDRResult 	= ds.Data("MultipleResistant")		//多耐结果
		Set IsActive 	= "1"               		//有效标志
		Set ResultSenID = ds.Data("ReportResultDR")	//药敏结果ID
		Set ResultData = ResultSenID_"^"_TestCode_"^"_TCCode_"^"_RstFormat_"^"_Result_"^"_TextRes
		_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
		Set return = return_$lb(ResultData)
	}
	Quit return
	
GetRepResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2019-10-29
/// Description:  通过检验结果ID取药敏结果接口
/// Input：       aResultSenID:检验结果ID
/// Return：      药敏结果信息
/// w ##Class(DHCHAI.DI.DIO.EnsFromLis1Srv).GetResultSen(61)
ClassMethod GetResultSen(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetResultSenErr"
	//调用检验组提供的接口
	Set ds = ##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryReportResultSen")
	Do ds.Execute(aResultID)
	while(ds.Next())
	{
		Set AntCode 	= ds.Data("SName")
		Set AntDesc	 	= ds.Data("AntibioticsName")
		Set Sensitivity = ds.Data("SensitivityName")
		Set IsActive 	= "1"
		Set ResultSenData = AntCode_"^"_AntDesc_"^"_Sensitivity_"^"_IsActive
		Set return = return_$lb(ResultSenData)
	}
	Quit return
	
GetResultSenErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
