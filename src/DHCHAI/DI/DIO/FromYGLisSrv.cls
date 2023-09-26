/// 名称: DHCHAI.DI.DIO.FromYGLisSrv
/// 描述: 院感检验数据接口
/// 编写者: zhoubo
/// 编写日期: 2021-09-03
Class DHCHAI.DI.DIO.FromYGLisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2021-09-03
/// Description:  通过检验报告ID取检验结果接口
/// Input：       aReportID:检验报告ID
/// Return：      检验结果信息
/// w ##Class(DHCHAI.DI.DIO.FromYGLisSrv).GetRepResult("869")
ClassMethod GetRepResult(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return

	Set $ZT="GetRepResultErr"
	//调用检验组提供的接口
	Set $NAMESPACE = "DHC-LISDATA"
	Set ds = ##class(%Library.ResultSet).%New("Service.LIS.Report.DHCReportServiceYG:QryYGReportResByReportID")
	Do ds.Execute(aReportID,"","","","","","","","","","","","","","","")
	Set $NAMESPACE = "DHC-APP"
	while(ds.Next()){
		Set ResultID     = ds.Data("ResultID")
		Set TestCodeDesc = ds.Data("TestCodeDesc")	   //检验项目名称
		Set TestCodeCode = ds.Data("TestCodeCode")	   //检验项目代码
		Continue:(TestCodeCode="")||(TestCodeDesc="")
		Set RstFormat 	 = ds.Data("RstFormat")		   //结果类型
		Set Result 		 = ds.Data("Result")		   //检测结果
		Set TextRes 	 = ds.Data("TextRes")		   //定性结果
		Set ResNoes 	 = ds.Data("ResNoes")		   //结果说明(备注)
		Set AbFlag 		 = ds.Data("AbFlag")		   //异常提示
		Set Unit 		 = ds.Data("Unit")			   //单位
		Set RefRanges 	 = ds.Data("RefRanges")		   //参考范围
		Set MDRResult 	 = ds.Data("MDRResult")		   //多耐结果
		Set ResultData = ResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
		
		Set return = return_$lb(ResultData)
	}
	Quit return
	
GetRepResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
