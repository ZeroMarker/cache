/// Desc:       记录病程记录中选择的医师信息逻辑
/// Creator:    董璐璐
/// CreateDate: 2018-7-20
Class EMRservice.BL.BLRecordTitleSuperiorDoctor Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加病程记录中选择的医师信息数据
/// Creator:    Donglulu
/// CreateDate: 2018-7-20
/// Input:      AEpisodeID
///             AInstanceID
///             AApplyUserID
/// Output:     result 0:失败 1:成功
/// Debug:      w ##Class(EMRservice.BL.BLRecordTitleSuperiorDoctor).AddTitleSuperiorDoctor("230","1||1","359","","")
ClassMethod AddTitleSuperiorDoctor(ADoctorID As %String, ADoctorLevelCode As %String, ADoctorLevelDescription As %String, ADoctorName As %String, AInstanceID As %String) As %String
{
	s result = 0
	q:(AInstanceID = "")||(ADoctorID = "") result
	s superiorID = ""
	s superiorID = $o(^DHCEMRI.TitleDoctorI("IdxInstanceID"," "_AInstanceID,""))	
    if (superiorID = "")
    {
	    s obj = ##Class(EMRinstance.RecordTitleSuperiorDoctor).%New()
		s obj.InstanceID = AInstanceID
    }
    else
    {
	    s obj = ##Class(EMRinstance.RecordTitleSuperiorDoctor).%OpenId(superiorID)
	    q:(obj = "") result
    }
	s obj.UserID = ADoctorID
	s obj.UserLevel = ADoctorLevelCode
	s obj.UserLevelDesc = ADoctorLevelDescription
	s obj.UserName = ADoctorName
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

/// Desc:       添加病程记录中选择的医师信息数据
/// Creator:    lifengbo
/// CreateDate: 2022-07-15
/// Input:      AInstanceID
/// Output:     result userID|医生级别信息
/// Debug:      w ##Class(EMRservice.BL.BLRecordTitleSuperiorDoctor).GetTitleSuperiorDoctorInfo("1||1")
ClassMethod GetTitleSuperiorDoctorInfo(AInstanceID As %String) As %String
{
	s result = 0
	q:(AInstanceID = "") result
	s superiorID = ""
	s superiorID = $o(^DHCEMRI.TitleDoctorI("IdxInstanceID"," "_AInstanceID,""))	
    	q:(superiorID = "") result

	s obj = ##Class(EMRinstance.RecordTitleSuperiorDoctor).%OpenId(superiorID)
	q:(obj = "") result
	    
	s DoctorID = obj.UserID 
	
	s DoctorLevelDescription = obj.UserLevelDesc
	s DoctorName = obj.UserName 
	
	s result = DoctorID_"|"_DoctorName_DoctorLevelDescription
	q result
}

}
