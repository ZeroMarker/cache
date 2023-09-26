/// 名称: DHCMed.DCEns.LIS.TSResultTask
/// 描述: 检验数据输入任务类
/// 编写者：zhufei
/// 编写日期: 2016-03-29
Class DHCMed.DCEns.LIS.TSResultTask Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-25
/// Description:  根据起止日期同步检验报告数据
/// Table：       DHCMed.DC.LIS.LabReport、DHCMed.DC.LIS.LabResult
/// Input：       FromDate ：开始日期
///               ToDate   ：结束日期
///               HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode  ：LIS系统版本代码（旧版V1、新版V2）
/// Return：      OK
/// w ##class(DHCMed.DCEns.LIS.TSResultTask).SyncRepByDate("2016-01-01","2016-04-26","LIS01","V2")
ClassMethod SyncRepByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aVerCode As %String = "V2", aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	If aVerCode="V1" {
		//东华老版本检验系统基础数据同步
		Set return="-101^检验报告数据同步错误"
		Set flg=##class(DHCMed.DCEns.LIS.TSResultByV1).SyncRepByDate(aFromDate,aToDate,aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} ElseIf aVerCode="V2" {
		//东华新版本检验系统基础数据同步
		Set return="-102^检验报告数据同步错误"
		Set flg=##class(DHCMed.DCEns.LIS.TSResultByV2).SyncRepByDate(aFromDate,aToDate,aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} Else {
		//第三方检验系统接口
	}
	
	Quit "OK"
}

/// Creator：     jiangpengpeng
/// CreatDate：   2016-03-15
/// Description:  检验基础数据同步
/// Table：       DHCMed.DC.LIS.*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode ：LIS系统版本代码（旧版V1、新版V2）
/// Return：      OK
/// w ##class(DHCMed.DCEns.LIS.TSResultTask).ProcBaseData("LIS01","V2")
ClassMethod ProcBaseData(aHospCode As %String, aVerCode As %String = "V2", aInitFlag As %String = "0") As %String
{
	New (aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	If aVerCode="V1" {
		//东华老版本检验系统基础数据同步
		Set return="-101^检验基础数据同步错误"
		Set flg=##class(DHCMed.DCEns.LIS.TSResultByV1).ProcBaseData(aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} ElseIf aVerCode="V2" {
		//东华新版本检验系统基础数据同步
		Set return="-102^检验基础数据同步错误"
		Set flg=##class(DHCMed.DCEns.LIS.TSResultByV2).ProcBaseData(aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} Else {
		//第三方检验系统接口
	}
	
	Quit "OK"
}

}
