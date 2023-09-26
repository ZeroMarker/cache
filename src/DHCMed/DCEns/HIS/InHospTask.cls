/// 名称: DHCMed.DCEns.HIS.InHospTask
/// 描述: 在院病人列表数据输入任务类
/// 编写者：zhufei
/// 编写日期: 2016-04-14
Class DHCMed.DCEns.HIS.InHospTask Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2016-04-14
/// Description:  根据起止日期同步在院病人列表数据
/// Table：       DHCMed.DC.HIS.InHospital
/// Input：       FromDate ：开始日期
///               ToDate   ：结束日期
///               HospCode ：医院缩写码（DHCMed_DC_SYS.BTHospital.SCode）
///               VerCode  ：HIS系统版本代码（东华V1（住院+急诊）、第三方V3）
/// Return：      OK
/// w ##class(DHCMed.DCEns.HIS.InHospTask).SyncInHospByDate("2014-01-01","2015-12-31","HIS01")
ClassMethod SyncInHospByDate(aFromDate As %String, aToDate As %String, aHospCode As %String, aVerCode As %String = "V1", aInitFlag As %String = "0") As %String
{
	New (aFromDate,aToDate,aHospCode,aVerCode,aInitFlag)
	Set return="0^入参为空"
	Quit:(aFromDate="")||(aToDate="")||(aHospCode="") return
	
	If aVerCode="V1" {
		//东华在院患者列表数据同步
		Set return=##class(DHCMed.DCEns.HIS.InHospByV1).SyncInHospByDate(aFromDate,aToDate,aHospCode,aInitFlag)
	} Else {
		//东华在院患者列表数据同步
		Set return=##class(DHCMed.DCEns.HIS.InHospByV1).SyncInHospByDate(aFromDate,aToDate,aHospCode,aInitFlag)
	}
	Quit return
}

}
