/// 名称: DHCMed.DCEns.NIS.ObResultTask
/// 描述: 护理记录数据输入任务类
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.NIS.ObResultTask Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据起止日期同步护理记录数据
/// Table：       DHCMed.DC.NIS.Observations
/// Input：       FromDate ：开始日期
///               ToDate   ：结束日期
///               HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode  ：NIS系统版本代码（东华V1、第三方V3）
/// Return：      OK
/// w ##class(DHCMed.DCEns.NIS.ObResultTask).SyncObsByDate("2015-03-10","2015-03-20","LIS01")
ClassMethod SyncObsByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aVerCode As %String = "V1", aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	If aVerCode="V1" {
		//东华护理记录（体温、大便次数）数据同步
		Set return="-101^护理记录数据同步错误"
		Set flg=##class(DHCMed.DCEns.NIS.ObResultByV1).SyncObsByDate(aFromDate,aToDate,aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} Else {
		//第三方检验系统接口
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  护理管理基础数据同步
/// Table：       DHCMed.DC.NIS.*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode  ：NIS系统版本代码（东华V1、第三方V3）
/// Return：      OK
/// w ##class(DHCMed.DCEns.NIS.ObResultTask).ProcBaseData("3")
ClassMethod ProcBaseData(aHospCode As %String, aVerCode As %String = "V1", aInitFlag As %String = "0") As %String
{
	New (aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	If aVerCode="V1" {
		//东华护理记录（体温、大便次数）基础数据同步
		Set return="-101^护理记录基础数据同步错误"
		Set flg=##class(DHCMed.DCEns.NIS.ObResultByV1).ProcBaseData(aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} Else {
		//第三方检验系统接口
	}
	
	Quit "OK"
}

}
