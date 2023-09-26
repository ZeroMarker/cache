/// 名称: DHCMed.DPCustom.Meta.AutoDPTask
/// 描述: 数据池任务Service
/// 编写者：Zhugz
/// 编写日期: 2013-11-28
Class DHCMed.DPCustom.Meta.AutoDPTask Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.DPCustom.Meta.AutoDPTask).DPAutoWork(+$h-1,+$h-1)
ClassMethod DPAutoWork(FromDate As %String, ToDate As %String)
{
	New (FromDate,ToDate)
	
	Set $ZT="DPAutoWork"
	
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set FromDate=+FromDate
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set ToDate=+ToDate
	Quit:(FromDate<1)||(ToDate<1) "OK"
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).GetAntiInfoByDate(FromDate,ToDate)
	/*Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)
	Set RetAdmAimAnti=##class(DHCMed.DPCustom.Meta.AdmAimAnti).getAntiInfoByDate(FromDate,ToDate)*/
	Quit "OK"
	
DPAutoWork
	Quit "Error"
}

}
