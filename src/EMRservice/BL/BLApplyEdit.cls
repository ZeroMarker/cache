/// Desc:       自动审批逻辑
/// Creator:    Donglulu
/// CreateDate: 2017-10-18
Class EMRservice.BL.BLApplyEdit Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       添加自动审批申请数据
/// Creator:    Donglulu
/// CreateDate: 2017-10-18
/// Input:      AEpisodeID
///             AInstanceID
///             AApplyUserID
/// Output:     result 0:失败 1:成功
/// Debug:      w ##Class(EMRservice.BL.BLApplyEdit).AddApplyData("230","1||1","359")
ClassMethod AddApplyData(AEpisodeID As %String, AInstanceID As %String, AApplyUserID As %String, AAppointID As %String) As %String
{
	s result = 0
	q:(AInstanceID = "")||(AApplyUserID = "") result
	s obj = ##Class(EMRinstance.ApplyEdit).%New()
	s obj.EpisodeID = AEpisodeID
	s obj.InstanceID = AInstanceID
	s obj.ApplyUserID = AApplyUserID
	s obj.AppointID = AAppointID
	s obj.ApplyDate = $p($h,",",1)
	s obj.ApplyTime = $p($h,",",2)
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = 1 
	q result
}

/// Desc:       获取自动审批次数
/// Creator:    Donglulu
/// CreateDate: 2017-10-18
/// Input:      AInstanceID
///             AApplyUserID
/// Output:     count
/// Debug:      w ##Class(EMRservice.BL.BLApplyEdit).GetApplyCount("1||1","359")
ClassMethod GetApplyCount(AInstanceID As %String, AApplyUserID As %String) As %String
{
	s count = 0
	q:(AInstanceID = "")||(AApplyUserID = "") count
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRI.ApplyEditI("IndexApplyUserIDInstanceID"," "_AApplyUserID," "_AInstanceID,rowId))
		q:(rowId = "")
		s count = count + 1
	}
	q count
}

/// Desc:       获取当前自动审批状态
/// Creator:    Donglulu
/// CreateDate: 2017-12-8
/// Input:      AInstanceID
///             AApplyUserID
/// Output:     1-已授权且授权有效, 0-无授权或者授权已失效
/// Debug:      w ##Class(EMRservice.BL.BLApplyEdit).GetApplyStatus("2674158||22","4133")
ClassMethod GetApplyStatus(AInstanceID As %String, AApplyUserID As %String) As %String
{
	s active = 0
	q:(AInstanceID = "")||(AApplyUserID = "") active
	s rowId = $o(^DHCEMRI.ApplyEditI("IndexApplyUserIDInstanceID"," "_AApplyUserID," "_AInstanceID,""),-1)
	q:(rowId = "") active
	s objApplyEdit = ##Class(EMRinstance.ApplyEdit).%OpenId(rowId)
	q:(objApplyEdit = "") active
	s appointID = objApplyEdit.AppointID
	s active = ##Class(EMRservice.Ajax.AuthAppoint).CheckAppointIsActive(appointID)
	q active_"^"_appointID
}

/// Desc:       回收自动审批状态
/// Creator:    Donglulu
/// CreateDate: 2017-12-8
/// Input:      AInstanceID
///             AApplyUserID
/// Output:     1-成功(或本身无申请编辑权限), -1失败
/// Debug:      w ##Class(EMRservice.BL.BLApplyEdit).WithdrawApplyEdit("2674158||22","4133")
ClassMethod WithdrawApplyEdit(AInstanceID As %String, AApplyUserID As %String) As %String
{
	s result = 1
	q:(AInstanceID = "")||(AApplyUserID = "") result
	s active = ##Class(EMRservice.BL.BLApplyEdit).GetApplyStatus(AInstanceID,AApplyUserID)
	q:($p(active,"^",1) = "0") result
	s appointID = $p(active,"^",2)
	q:(appointID = "") result
	s result = ##Class(EMRservice.BL.BLApplyEdit).WithdrawAppoint(appointID)
	q result
}

/// Desc:       回收本次就诊所有自动审批状态
/// Creator:    Donglulu
/// CreateDate: 2018-6-12
/// Input:      AEpisodeID
///             
/// Output:     
/// Debug:      d ##Class(EMRservice.BL.BLApplyEdit).WithdrawAllApplyEdit("2193947")
ClassMethod WithdrawAllApplyEdit(AEpisodeID As %String)
{
	q:(AEpisodeID = "")
	s appointID = ""
	for
	{
		s appointID = $o(^DHCEMRI.ApplyEditI("IndexEpisodeIDAppointID"," "_AEpisodeID," "_appointID))
		q:(appointID = "")
		s appointID = $e(appointID,2,$l(appointID))
		s active = ##Class(EMRservice.Ajax.AuthAppoint).CheckAppointIsActive(appointID)
		if (active = "1")
		{
			s result = ##Class(EMRservice.BL.BLApplyEdit).WithdrawAppoint(appointID)
		}
	}
}

ClassMethod WithdrawAppoint(AappointID As %String) As %String
{
	s appoint = ##class(EMRinstance.AuthAppoint).%OpenId(AappointID)
	q:(appoint="") "-1"	
	
	//取当前系统时间
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	s appoint.AppointEndDate = date
	s appoint.AppointEndTime = time - 60
	
	s sc = appoint.%Save()
	d appoint.%Close()
	q:($$$ISOK(sc)) "1"
	q "-1"
}

}
