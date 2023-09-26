/// 名称: DHCMed.DCEns.ORIS.OperationTask
/// 描述: 手麻系统数据输入任务类
/// 编写者：zhufei
/// 编写日期: 2016-04-19
Class DHCMed.DCEns.ORIS.OperationTask Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  根据起止日期同步手麻系统数据
/// Table：       DHCMed.DC.ORIS.Observations
/// Input：       FromDate ：开始日期
///               ToDate   ：结束日期
///               HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode  ：手麻系统版本代码（东华V1、东华V2、第三方V3）
/// Return：      OK
/// w ##class(DHCMed.DCEns.ORIS.OperationTask).SyncOperByDate("2015-03-10","2015-03-20","ORIS01","V3")
ClassMethod SyncOperByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aVerCode As %String = "V1", aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	If aVerCode="V1" {
		//东华手麻V1.0接口
		Set return="-101^东华手麻V1.0接口数据同步错误"
		Set flg=##class(DHCMed.DCEns.ORIS.OperationByV1).SyncOperByDate(aFromDate,aToDate,aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} ElseIf aVerCode="V3" {
		//安贞第三方手麻（麦迪克斯）接口
		Set return="-103^安贞第三方手麻（麦迪克斯）接口数据同步错误"
		Set flg=##class(DHCMed.DCEns.ORIS.OperationByV3).SyncOperByDate(aFromDate,aToDate,aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} Else {
		//东华手麻V1.0接口
		Set return="-101^东华手麻V1.0接口数据同步错误"
		Set flg=##class(DHCMed.DCEns.ORIS.OperationByV1).SyncOperByDate(aFromDate,aToDate,aHospCode,aInitFlag)
		Quit:flg'="OK" return
	}
	
	Quit "OK"
}

/// Creator：     zhufei
/// CreatDate：   2016-04-19
/// Description:  手麻系统基础数据同步
/// Table：       DHCMed.DC.ORIS.BT*
/// Input：       HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode  ：手麻系统版本代码（东华V1、东华V2、第三方V3）
/// Return：      OK
/// w ##class(DHCMed.DCEns.ORIS.OperationTask).ProcBaseData("3")
ClassMethod ProcBaseData(aHospCode As %String, aVerCode As %String = "V1", aInitFlag As %String = "0") As %String
{
	New (aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:aHospCode="" return
	
	If aVerCode="V1" {
		//东华手麻V1.0接口
		Set return="-201^东华手麻V1.0接口字典同步错误"
		Set flg=##class(DHCMed.DCEns.ORIS.OperationByV1).ProcBaseData(aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} ElseIf aVerCode="V3" {
		//安贞第三方手麻接口（麦迪克斯）
		Set return="-203^安贞第三方手麻（麦迪克斯）接口字典同步错误"
		Set flg=##class(DHCMed.DCEns.ORIS.OperationByV3).ProcBaseData(aHospCode,aInitFlag)
		Quit:flg'="OK" return
	} Else {
		//东华手麻V1.0接口
		Set return="-201^东华手麻V1.0接口字典同步错误"
		Set flg=##class(DHCMed.DCEns.ORIS.OperationByV1).ProcBaseData(aHospCode,aInitFlag)
		Quit:flg'="OK" return
	}
	
	Quit "OK"
}

}
