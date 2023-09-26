/// 名称:	EMR.IP.BL.PrivLogic
/// 描述:	住院诊病历导航逻辑类
/// 编写者：yejian(lifengbo)
/// 编写日期: 2022-6-8
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLPrivLogic Extends %RegisteredObject
{

/// "查看"操作的标志
Parameter ACTIONVIEW = "READ";

/// Desc:       取出患者信息
/// Creator:    yejian(lifengbo)
/// CreateDate: 2021-7-30
/// Input:      aEpisodeID 就诊号
/// 			aUserID 用户ID
/// OutPut:     EMR.IP.BL.PrivLogic 患者信息
/// debug:		w ##class(EMR.IP.BL.PrivLogic).GetPatInfo("67","1")
ClassMethod GetPatInfo(aEpisodeID As %String, aUserID As %String) As %Library.List
{
	 q:(($d(aEpisodeID)=0) || (aEpisodeID = "")) ""
	 s objPatInfo = ##class(EMR.IP.DTO.PatientInfo).%New()
	 s objPatInfo.AdmId = aEpisodeID
	 s objPatInfo.UserId = aUserID
	 
	 s patSex = objPatInfo.PatSex //性别
	 s patDept = objPatInfo.PatDept //当前科室
	 s patWard = objPatInfo.PatWard //当前病区
	 s patPriv = objPatInfo.PatPriv //所有权限
     s patULevel = objPatInfo.PatULevel //用户级别
     s SSLAN = objPatInfo.SSLAN //用户语言
     
     q $lb(patSex,patDept,patWard,patPriv,patULevel,SSLAN)
}

}
