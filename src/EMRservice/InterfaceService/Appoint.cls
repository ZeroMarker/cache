Class EMRservice.InterfaceService.Appoint Extends %RegisteredObject
{

/// input: AEpisodeID:           就诊ID (不能为空)
///        AAppointCateCharpter: 1、病历ID串(病历ID^病历ID) 2、ALL(全部病历)
///        ARequestUserID:       获得权限的医护人员UserID (不能为空)
///        ARequestDeptID:       获得权限的科室ID (不能为空)
///        AActions:             view (授予的病历操作权限，不能为空)
///        AAppointUserID:       进行授权的医护人员UserID (不能为空)
///        AAppointType:         0-对ARequestUserID进行授权; 1-对ARequestDeptID进行授权
///        AAppointSpan:         数字-授权时长，单位为小时 (例：时长6小时，参数为6)
///        AStatus:              IC-会诊授权;IP-检查授权;IL-检验授权 (不能为空)
///        AObjID:               具体模块的业务ID(会诊申请ID，不能为空)
/// output: 0 此就诊没有病历; 1 授权成功; -1 授权失败
/// desc: 使用说明-根据参数AAppointType的不同，对ARequestUserID或者ARequestDeptID进行病历查看(view)授权
/// debug: w ##Class(EMRservice.InterfaceService.Appoint).addAppoint("220","ALL","359","6","view","628","1","6","IC","1")
ClassMethod addAppoint(AEpisodeID As %String, AAppointCateCharpter As %String, ARequestUserID As %String, ARequestDeptID As %String, AActions As %String, AAppointUserID As %String, AAppointType As %String, AAppointSpan As %String, AStatus As %String, AObjID As %String) As %String
{
	q:(AEpisodeID = "")||(ARequestUserID = "")||(ARequestDeptID = "")||(AActions = "")||(AAppointUserID = "")||(AAppointType = "")||(AObjID = "") "-1"
	if (AAppointCateCharpter = "ALL")
	{
		s AAppointCateCharpter = ..getInstanceIDsByAdmID(AEpisodeID)
		q:(AAppointCateCharpter = "") "0"
	}
	s ret = ##Class(EMRservice.Ajax.AuthDirectAppoint).GivePower(AAppointSpan,AAppointCateCharpter,AAppointUserID,AActions,ARequestUserID,ARequestDeptID,AEpisodeID,AAppointType,AStatus,AObjID)

	q ret
}

/// w ##Class(EMRservice.InterfaceService.Appoint).getInstanceIDsByAdmID("220")
ClassMethod getInstanceIDsByAdmID(AEpisodeID As %String) As %String
{
	s InstanceIDs = ""
	q:(AEpisodeID = "") InstanceIDs
	s date = ""
	for
	{
		s date = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date))
		q:(date = "")
		
		s time = ""
		for
		{
			s time = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time))
			q:(time = "")
			
			s ECRecordID = ""
			for
			{
				s ECRecordID = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,ECRecordID))
				q:(ECRecordID = "")
				
				s subID = ""
				for
				{
					s subID = $O(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeID," SAVE",date,time,ECRecordID,subID))
					q:(subID = "")
					
					s InstanceID = ECRecordID_"||"_subID
					
					if (InstanceIDs = "")
					{
						s InstanceIDs = InstanceID
					}
					else
					{
						s InstanceIDs = InstanceIDs_"^"_InstanceID
					}
				}
			}
		}
	}
	q InstanceIDs
}

/// input: AEpisodeID:就诊ID
///        AStatus: IC-会诊授权;IP-检查授权;IL-检验授权
///        AObjID: 具体模块的业务ID(会诊申请ID)
/// debug: w ##Class(EMRservice.InterfaceService.Appoint).closeAppoint("220","IC","1")
ClassMethod closeAppoint(AEpisodeID As %String, AStatus As %String, AObjID As %String) As %String
{
	s ret = "1"
	q:(AEpisodeID = "")||(AStatus = "")||(AObjID = "") "-1"
	s date = $p($h,",",1)
	s time = $p($h,",",2)
	TStart
	s AppointSubID = ""
	for
	{
		s AppointSubID = $o(^DHCEMRI.AuthAppointSubI("IdxStatusEpisodeIDObjID"," "_AStatus, " "_AEpisodeID, " "_AObjID,AppointSubID))
		q:(AppointSubID = "")
		
		s AppointSubObj = ##class(EMRinstance.AuthAppointSub).%OpenId(AppointSubID)
		s AppointID = AppointSubObj.AppointID
		q:(AppointID = "")
		
		s AppointObj = ##class(EMRinstance.AuthAppoint).%OpenId(AppointID)
		s AppointObj.AppointEndDate = date
		s AppointObj.AppointEndTime = time-1
		
		s sc = AppointObj.%Save()
		if ('$$$ISOK(sc))
		{
			s ret = "-1"
		}
	}
	
	if (ret = "-1")
	{
		TRollback
		s ret = "-1"
		q ret
	}
	
	TCommit
	q ret
}

}
