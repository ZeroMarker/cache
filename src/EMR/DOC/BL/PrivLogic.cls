/// 名称:	EMR.DOC.BL.PrivLogic
/// 描述:	权限规则脚本专科病历逻辑
/// 编写者：yejian
/// 编写日期: 2021-7-22
/// 产品组：电子病历产品组
Class EMR.DOC.BL.PrivLogic Extends %RegisteredObject
{

/// Description：获取指定病人当前被指定的科室
/// Creator: 	yejian
/// CreatDate: 	2022-8-11
/// Table:
/// Input:		EpisodeID 就诊号
/// 			argProductcode 项目标识
/// Output:
/// Return:		指定的科室ID，如果在当前时间段中没有有效的指定，则返回空
ClassMethod GetAppointDept(EpisodeID As %String, argProductcode As %String = "") As %String
{
	 q:(EpisodeID = "") ""
	 
	 //取出指定科室表中的记录ID
	 s TILEMRDept = ##Class(EMR.DAO.EMRDept).GetTureIndexLocation(EpisodeID)
	 s appointDeptRowID = ""
	 if ($d(@TILEMRDept@("EpisodeAndActIdx"," "_EpisodeID," Y")) '= 0)
	 {
	 	s appointDeptRowID = $o(@TILEMRDept@("EpisodeAndActIdx", " "_EpisodeID, " Y", 0))
	 }
	 q:(appointDeptRowID = "") ""
	 
	 //取出指定科室记录中的有效期并判断其是否仍有效
	 s curObjAppointDept = ##class(EMR.DAO.EMRDept).doOpenByID(EpisodeID,appointDeptRowID)
	 q:(curObjAppointDept = "") ""
	 q:(curObjAppointDept.IsActivity = "N") ""
	 
	 s isActivity = "N"
	 s endDate = curObjAppointDept.EndDate
	 s endTime = curObjAppointDept.EndTime
	 s curDate = $p($h, ",", 1)
	 s curTime = $p($h, ",", 2)
	 s:((+endDate) > (+curDate)) isActivity = "Y"
	 s:(((+endDate) = (+curDate))&&((+endTime) > (+curTime))) isActivity = "Y"
	 
	 //如果有效则返回指定的DeptID,如果无效则返回空同时设置状态
	 s resultDept = ""
	 if (isActivity = "Y")
	 {
	 	 s resultDept = curObjAppointDept.EMRDept
	 }
	 else
	 {
		 s resultDept = ""
		 s curObjAppointDept.IsActivity = "N"
		 d curObjAppointDept.%Save()
	 }
	 d curObjAppointDept.%Close()
	 s curObjAppointDept = ""
	 q resultDept
}

/// Desc:       取出患者信息
/// Creator:    yejian
/// CreateDate: 2021-7-30
/// Input:      aEpisodeID 就诊号
/// 			aUserID 用户ID
/// OutPut:     EMR.DOC.DTO.PatientInfo 患者信息
/// debug:		w ##class(EMR.DOC.BL.PrivLogic).GetPatInfo("67","1")
ClassMethod GetPatInfo(aEpisodeID As %String, aUserID As %String, aCTLocID As %String, aProduct As %String = "OP") As %Library.List
{
	 q:(($d(aEpisodeID)=0) || (aEpisodeID = "")) ""
	 if (aProduct="OP")
	 {
	 	s objPatInfo = ##class(EMR.OP.DTO.PatientInfo).%New()
	 }
	 else
	 {
		s objPatInfo = ##class(EMR.IP.DTO.PatientInfo).%New() 
	 }
	 s objPatInfo.AdmId = aEpisodeID
	 s objPatInfo.UserId = aUserID
	 s objPatInfo.CTLocID = aCTLocID
	 
	 s patSex = objPatInfo.PatSex //性别
	 s patDept = objPatInfo.PatDept //当前科室
	 s patWard = objPatInfo.PatWard //当前病区
	 s patPriv = objPatInfo.PatPriv //所有权限
     s patULevel = objPatInfo.PatULevel //用户级别
     s SSLAN = objPatInfo.SSLAN //用户语言
     
     q $lb(patSex,patDept,patWard,patPriv,patULevel,SSLAN)
}

}
