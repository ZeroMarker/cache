/// 此类为电子病历提供给“会诊申请”页面的接口类，“会诊申请”页面中的“关闭授权”按钮调用此类，来关闭相应的授权；
Class EPRservice.browser.BOConsultation Extends %RegisteredObject [ ProcedureBlock ]
{

/// Debug: w ##Class(EPRservice.browser.BOConsultation).FinishConsultation(AConsultID)
ClassMethod FinishConsultation(AConsultID As %String) As %String
{
	s ret = -1
	q:(AConsultID = "") ret
	
	s flag = 1
	//为了保证会诊申请调用我们的接口信息不变，做此分支判断，若二版会诊申请授权没有记录，则看三版病历；
	s EPRSubID = ""
	for {
		s EPRSubID = $o(^DHCEPRI.EPRActionAppointSubI("IdxConsultationID"," "_AConsultID,EPRSubID))
		q:(EPRSubID = "")
		
		s objAppointSub = ##Class(EPRinstance.EPRActionAppointSub).%OpenId(EPRSubID)
		s AppointID = objAppointSub.AppointID
		s objAppoint = ##Class(EPRinstance.EPRActionAppoint).%OpenId(AppointID)
		
		s IsActive = ..CheckAppointIsActive(objAppoint.AppointEndDate,objAppoint.AppointEndTime)
		continue:('IsActive)
		
		//取当前系统时间
		s date = $p($h,",",1)
		s time = $p($h,",",2)

		s objAppoint.AppointEndDate = date
		s objAppoint.AppointEndTime = time
		s objAppoint.AppointStatus = "F"

		s sc = objAppoint.%Save()
		if '(objAppoint.%Save())
		{
			s flag = 0
		}
		
		d objAppoint.%Close()
	}
	
	
	s EMRSubID = ""
	for {
		s EMRSubID = $o(^DHCEMRI.ActionAppointSubI("IdxConsultationID"," "_AConsultID,EMRSubID))
		q:(EMRSubID = "")
		
		s objEMRAppointSub = ##Class(EMRinstance.ActionAppointSub).%OpenId(EMRSubID)
		s EMRAppointID = objEMRAppointSub.AppointID
		s objEMRAppoint = ##Class(EMRinstance.EMRActionAppoint).%OpenId(EMRAppointID)
		
		s IsActive = ..CheckAppointIsActive(objEMRAppoint.AppointEndDate,objEMRAppoint.AppointEndTime)
		continue:('IsActive)
		
		//取当前系统时间
		s date = $p($h,",",1)
		s time = $p($h,",",2)

		s objEMRAppoint.AppointEndDate = date
		s objEMRAppoint.AppointEndTime = time
		s objEMRAppoint.AppointStatus = "F"

		s sc = objEMRAppoint.%Save()
		if '(objEMRAppoint.%Save())
		{
			s flag = 0
		}
		
		d objEMRAppoint.%Close()
	}
	s:(flag = 1) ret = 1
	
	if (ret = 1)
	{
		s ResultMessaage = "关闭授权成功！"
	}
	else
	{
		s ResultMessaage = "关闭授权失败！请确认选中条目是否已授权！"
	}
	q ResultMessaage
}

/// Input:AID-申请记录RowID
/// Output:
/// Return::1-已授权且授权有效, 0-无授权或者授权已失效
/// Others: w ##Class(EPRservice.browser.BOConsultation).CheckAppointIsActive("1")
ClassMethod CheckAppointIsActive(AppointEndDate As %String, AppointEndTime As %String) As %String
{
	///授权日期或者授权时间为空,即没有授权
	q:(AppointEndDate = "" || AppointEndTime = "") "0"
	
	s date = $p($H,",",1)
	s time = $p($H,",",2)
	
	///授权截止日期小于当前日期,授权已过期
	q:(AppointEndDate<date) "0"
	
	///授权截止日期等于当前日期,授权截至时间小于当前时间,授权已过期
	q:(AppointEndDate=date)&&(AppointEndTime<time) "0"
	
	q "1"
}

}
