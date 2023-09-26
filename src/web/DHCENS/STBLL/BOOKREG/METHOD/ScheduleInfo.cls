/// 排班
Class web.DHCENS.STBLL.BOOKREG.METHOD.ScheduleInfo Extends (%RegisteredObject, %XML.Adaptor)
{

/// 门诊排班
/// Others：w ##class(web.DHCENS.STBLL.BOOKREG.Method.ScheduleInfo).GetOScheInfoPortal("574||108^1")
ClassMethod GetOScheInfoPortal(Input As %String) As %String [ WebMethod ]
{
	set scheId=$p(Input,"^",1)
	set KeyName=$p(Input,"^",2)
	set result=##class(DtPortal.Doctor.DHCDocComService).SendOScheInfoPortal(scheId,KeyName)
	Quit result
}

/// Creator：lyh
/// CreatDate：2016-06-29
/// Description：发送医生排班信息
/// Table：User.RBApptSchedule User.DHCRBApptSchedule
/// Input： RBASId^RBASId 门诊排班标识
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.ScheduleInfo).GetScheduleInfo("10229||4")
ClassMethod GetScheduleInfo(RBASID As %String) As %GlobalCharacterStream
{
	s $ztrap="ErrorMsg"
	s request=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s request.header=header
	s body=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Body).%New()
	s rbApptObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RBApptSchedule).%New()
	s rbApptObj.TradeCode="T001"
	s rbApptObj.HospitalId="HNSRMYY"
	s rbApptObj.HospitalName="河南省人民医院"
	s rbApptObj.TransactionId=""
	s ResID=+RBASID
	s Sub=$p(RBASID,"||",2)
	s parentCount=$l(RBASID,"^")
	for i=1:1:parentCount{
		s tRBASID=$p(RBASID,"^",i)
		s reqXml="<Request><ScheduleItemCode>"_tRBASID_"</ScheduleItemCode></Request>"
		s DHCRBASObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.FindOneAdmScheduleRp).%New()
		s DHCRBASObj=##class(DHCExternalService.RegInterface.SelfRegMethods).FindOneAdmSchedule(reqXml)
		s rbParentApptObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RBParentApptSchedule).%New()
		s rbParentApptObj.RBASId=tRBASID
		s rbParentApptObj.RBASDate=DHCRBASObj.RBASDate
		s rbParentApptObj.RBASWeekDay=DHCRBASObj.RBASWeekDay
		s rbParentApptObj.RBASSessionCode=DHCRBASObj.RBASSessionCode
		s rbParentApptObj.RBASSessionName=DHCRBASObj.RBASSessionName
		s rbParentApptObj.DoctorId=DHCRBASObj.DoctorId
		s rbParentApptObj.DoctorCode=DHCRBASObj.DoctorCode
		s rbParentApptObj.DoctorName=DHCRBASObj.DoctorName
		s rbParentApptObj.DoctorTitleCode=DHCRBASObj.DoctorTitleCode
		s rbParentApptObj.DoctorTitle=DHCRBASObj.DoctorTitle
		s rbParentApptObj.DeptId=DHCRBASObj.DeptId
		s rbParentApptObj.DeptCode=DHCRBASObj.DeptCode
		s rbParentApptObj.Dept=DHCRBASObj.Dept
		
		s rbParentApptObj.DeptParentId=DHCRBASObj.DeptParentId
		s rbParentApptObj.DeptParentCode=DHCRBASObj.DeptParentCode
		s rbParentApptObj.DeptParentName=DHCRBASObj.DeptParentName
		
		s rbParentApptObj.DeptMainId=DHCRBASObj.DeptMainId
		s rbParentApptObj.DeptMainCode=DHCRBASObj.DeptMainCode
		s rbParentApptObj.DeptMainName=DHCRBASObj.DeptMainName
		s rbParentApptObj.DeptNote=DHCRBASObj.DeptNote
		s rbParentApptObj.DeptParentNote=DHCRBASObj.DeptParentNote
		s rbParentApptObj.WaitNum=DHCRBASObj.WaitNum
		
		s rbParentApptObj.SubjectId=DHCRBASObj.SubjectId
		s rbParentApptObj.Subject=DHCRBASObj.Subject
		s rbParentApptObj.RBASPrice=DHCRBASObj.RBASPrice
		s rbParentApptObj.RegFee=DHCRBASObj.RegFee
		s rbParentApptObj.CheckupFee=DHCRBASObj.CheckupFee
		s rbParentApptObj.ServiceFee=DHCRBASObj.ServiceFee
		s rbParentApptObj.OtherFee=DHCRBASObj.OtherFee
		s rbParentApptObj.RBASSessionTypeId=DHCRBASObj.RBASSessionTypeId
		s rbParentApptObj.RBASSessionType=DHCRBASObj.RBASSessionType
		s rbParentApptObj.ClinicGroupCode=DHCRBASObj.ClinicGroupCode
		s rbParentApptObj.ClinicGroupName=DHCRBASObj.ClinicGroupName
		s rbParentApptObj.AdmitAddress=DHCRBASObj.AdmitAddress
		s rbParentApptObj.RBASSessionLoad=DHCRBASObj.RBASSessionLoad
		s rbParentApptObj.StartTime=DHCRBASObj.StartTime
		s rbParentApptObj.EndTime=DHCRBASObj.EndTime
		s rbParentApptObj.AdmitTimeRange=DHCRBASObj.AdmitTimeRange
		s rbParentApptObj.Note=DHCRBASObj.Note
		s rbParentApptObj.EnableDate=DHCRBASObj.EnableDate
		s rbParentApptObj.EnableTime=DHCRBASObj.EnableTime
		s rbParentApptObj.ClinicRoomCode=DHCRBASObj.ClinicRoomCode
		s rbParentApptObj.ClinicRoomName=DHCRBASObj.ClinicRoomName

		s RegNumlen=DHCRBASObj.TimeRangeList.Count()
		for j=1:1:RegNumlen{
			s RBChildApptObj=##class(DHCExternalService.RegInterface.Entity.SelfReg.TimeRange).%New()
			s RBChildApptObj=DHCRBASObj.TimeRangeList.GetAt(j)
			s rbChildApptObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RBChildApptSchedule).%New()
			s rbChildApptObj.Time=RBChildApptObj.Time
			s rbChildApptObj.TotalNumber=RBChildApptObj.TotalNumber
			s rbChildApptObj.SurplusNumber=RBChildApptObj.SurplusNumber
			s rbChildApptObj.SerialNumbers=RBChildApptObj.SerialNumbers
			d rbParentApptObj.RBChildApptScheduleList.Insert(rbChildApptObj)
		}
		d rbApptObj.RBParentApptSchedule.Insert(rbParentApptObj)
	}
	s body.rbApptSchedule=rbApptObj
	s request.body=body
	d request.XMLExportToStream(.xml)
	b ;lyh end
	q xml
ErrorMsg
	b ;lyh $ze
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

/// Creator：lyh
/// CreatDate：2016-06-30
/// Description：发送医生排班状态变更信息
/// Table：
/// Input： RBASId^RBASId 门诊排班标识
/// Return：
/// Others: w ##class(web.DHCENS.STBLL.BOOKREG.METHOD.ScheduleInfo).SynChangeScheduleStatusInfo("3204||2")
ClassMethod SynChangeScheduleStatusInfo(RBASID As %String) As %GlobalCharacterStream
{
	s $zt="Err"
	s request=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Request).%New()
	s header=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Header).%New()
	s header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID($h)
	s header.SourceSystem="02"
	s request.header=header
	s body=##class(web.DHCENS.STBLL.BOOKREG.MODEL.Body).%New()
	s rbApptStatusObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RBApptScheduleStatus).%New()
	s rbApptStatusObj.TradeCode="T002"
	s rbApptStatusObj.HospitalId=""
	s rbApptStatusObj.HospitalName="河南省人民医院"
	s rbApptStatusObj.TransactionId=""

	s parentCount=$l(RBASID,"^")
	for i=1:1:parentCount{
		s tRBASID=$p(RBASID,"^",i)
		s rbApptStatusInfoObj=##class(web.DHCENS.STBLL.BOOKREG.MODEL.RBApptScheduleStatusInfo).%New()
		s rbApptStatusInfoObj.RBASId=tRBASID
		s rbApptStatusInfoObj.RBASStatusCode="S"	//N: 正常出诊 S: 停诊
		d rbApptStatusObj.RBApptScheduleStatusInfo.Insert(rbApptStatusInfoObj)
	}
	s body.rbApptScheduleStatus=rbApptStatusObj
	s request.body=body
	d request.XMLExportToStream(.stream)
	b ;lyh end
	q stream
Err
	b ;lyh $ze
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	q stream
}

}
