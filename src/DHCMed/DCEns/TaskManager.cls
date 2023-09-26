/// 名称: DHCMed.DCEns.TaskManager
/// 描述: 数据抽取自动任务服务类
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.TaskManager Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Do ##Class(DHCMed.DCEns.TaskManager).AutoTask("2013-11-01","2013-11-15")
ClassMethod AutoTask(FromDate As %String, ToDate As %String) As %String
{
	//在院患者（东华HIS）
	Do ##class(DHCMed.DCEns.HIS.InHospTask).SyncInHospByDate(FromDate,ToDate,"HIS01","V1")
	
	//检验系统（东华检验系统）
	Do ##class(DHCMed.DCEns.LIS.TSResultTask).SyncRepByDate(FromDate,ToDate,"LIS01","V1")
	
	//护理管理（远卓数据同步到东华HIS中，相当于使用东华护理管理系统）
	Do ##class(DHCMed.DCEns.NIS.ObResultTask).SyncObsByDate(FromDate,ToDate,"NIS01","V1")
	
	//手术麻醉记录（麦迪斯顿数据同步到东华HIS中，安贞接口做的特殊处理）
	Do ##class(DHCMed.DCEns.ORIS.OperationTask).SyncOperByDate(FromDate,ToDate,"ORIS01","V3")
	
	Quit "OK"
}

}
