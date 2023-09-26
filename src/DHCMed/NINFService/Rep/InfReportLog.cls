/// 名称: DHCMed.NINFService.Rep.InfReportLog
/// 描述: 医院感染报告 更新日志
/// 编写者：zhufei
/// 编写日期: 2011-06-26
Class DHCMed.NINFService.Rep.InfReportLog Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  取医院感染报告 更新日志
/// Table：       DHCMed.NINF.Rep.InfReportLog
/// Input：       DHCMed.NINF.Rep.InfReportLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportLog).GetSubRec(1)
ClassMethod GetSubRec(aRepID As %String) As DHCMed.NINF.Rep.InfReportLog
{
	New (aRepID)
	Set return=""
	Quit:aRepID="" return
	
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",aRepID,"Log",SubID))
		Quit:SubID=""
		Set return=return_$c(1)_aRepID_"||"_SubID
	}
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-26
/// Description:  取医院感染报告 更新日志
/// Table：       DHCMed.NINF.Rep.InfReportLog
/// Input：       DHCMed.NINF.Rep.InfReportLog.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINFService.Rep.InfReportLog).GetSubObj(1)
ClassMethod GetSubObj(aId As %String) As DHCMed.NINF.Rep.InfReportLog
{
	New (aId)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportLog).GetObjById(aId)
	If $IsObject(obj) {
		Set return=obj
	} Else {
		Set obj=##Class(DHCMed.NINF.Rep.InfReportLog).%New()
		If obj'="" Do obj.%Close()
		set return=obj
	}
	
	Quit return
}

}
