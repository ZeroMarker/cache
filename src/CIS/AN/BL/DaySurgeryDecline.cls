Class CIS.AN.BL.DaySurgeryDecline Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.DaySurgeryDecline).SaveDaySurgeryDecline()
ClassMethod SaveDaySurgeryDecline(opsId As %String, declineNote As %String, userId As %String) As %String
{
	s operObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s admId=operObj.EpisodeID
	s oldStatCode=operObj.Status.Code
	if (oldStatCode="Application")!(oldStatCode="DaySurgery")
	{
		
	set operStatusCode=""
	set operStatus=	##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Cancel")
	set operObj.Status=##class(CT.AN.OperStatus).%OpenId(operStatus)
	set status=operObj.%Save()
	if +status < 1 set saveResult="E^"
	if (operObj.AppOrderItem)
	{
	set saveResult=##class(CIS.AN.BL.OEOrder).CancelOEOrder(operObj.AppOrderItem,userId)
	
	}
	quit:(saveResult'="S^") "E^"_saveResult
	set opaId=operObj.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set operArrange.OPAStatus="C"
	set sc=operArrange.%Save()
	//调用接口取消床位
	//根据就诊号获取住院证：
	
	s bookdr=$O(^DHCDocIPBK(0,"EpisodeIDTo",admId,0))
	i bookdr>0 s ret=##Class(Nur.InService.Interface).cancelPatAppBed(bookdr,userId)
	}
	
		set ret=""
		 set daysurgery=##class(CIS.AN.DaySurgeryDecline).%New() 
		 set daysurgery.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		 set daysurgery.Content=declineNote
		 set daysurgery.UpdateDate=+$h
		 set daysurgery.UpdateTime=$p($h,",",2)
		 set daysurgery.UpdateUser=userId
		 set sc=daysurgery.%Save()
  		quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
		q 0
}

}
