Class EMRservice.BL.ClinicDiagPath Extends %RegisteredObject
{

/// Desc:  判断入院记录有无符合诊断描述的临床路径
/// CreatDate:2018-12-10
/// Creator:Lina
/// Input: AEpisodeID 就诊号
///        ADocID 模板DocID,EMRinstance.ECRecord的ChartItemID
///        AInstanceID 病历InstanceID,EMRinstance.InstanceData的ID
/// Output:ret
/// Return:返回空：无符合诊断描述的临床路径
/// Debug：w ##Class(EMRservice.BL.ClinicDiagPath).GetClinicPath("1215","58","130||1")
ClassMethod GetClinicPath(AEpisodeID As %String, ADocID As %String, AInstanceID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "")||($d(ADocID) = 0)||(ADocID = "") ret
	
	s isClinicPathVerification = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("IsClinicPathVerification","N")
	q:(isClinicPathVerification = "N")||(isClinicPathVerification '= ADocID) ret
	//"HDSD00.13.023" 入院记录初步诊断术语集内部标识符
	s glossarySet = ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(AEpisodeID,"HDSD00.13.01",AInstanceID)
	s diagDesc = glossarySet.GetAt("HDSD00.13.023")
	q:(diagDesc = "") ret
	s CPWStr =##Class(EMRservice.HISInterface.HisData).GetCPWListByDesc(AEpisodeID,diagDesc)
	q:(CPWStr = "") ret
	s ret = CPWStr
	q ret
}

}
