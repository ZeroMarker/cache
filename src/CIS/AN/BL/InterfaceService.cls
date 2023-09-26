Class CIS.AN.BL.InterfaceService Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-07-26
/// Description： 	判断病人所有手术完成状态
/// Table：        	
/// Input：        	EpisodeID:就诊ID
/// Return：       	所有手术都已完成返回"S^"，存在未完成的手术返回"E^提示信息"
/// Debug:			w ##class(CIS.AN.BL.InterfaceService).OperCompleted("1963788")
ClassMethod OperCompleted(EpisodeID As %String) As %String
{
	set $zt="Error"
	set existsEpisode=##class(CIS.AN.COM.Admission).ExistsEpisode(EpisodeID)
	quit:(existsEpisode=0) "E^就诊表不存在ID为"_EpisodeID_"的就诊记录！"
	
	set opsId=0,incompleteCount=0
	set finishStatus=$System.SQL.UPPER("^Finish^Cancel^Decline^Revoke^")
	for
	{
		set opsId=$order(^DHCAN.OperScheduleI("Adm"," "_EpisodeID,opsId))
		quit:(opsId="")
		continue:(##class(DHCAN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(DHCAN.OperSchedule).%OpenId(opsId)
		set operStatus="^"_$System.SQL.ALPHAUP(operSchedule.Status.Code)_"^"
		set:(finishStatus'[operStatus) incompleteCount=incompleteCount+1	
	}	
	
	quit:(incompleteCount>0) "E^还有未完成的手术，请联系手术室进行处理！"
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2017-07-26
/// Description： 	判断病人所有手术收费状态
/// Table：        	
/// Input：        	EpisodeID:就诊ID
/// Return：       	所有手术都已收费返回"S^"，存在未收费的手术返回"E^提示信息"
/// Debug:			w ##class(CIS.AN.BL.InterfaceService).OperOrdered("1963788")
ClassMethod OperOrdered(EpisodeID As %String) As %String
{
	set $zt="Error"
	set existsEpisode=##class(CIS.AN.BL.Admission).ExistsEpisode(EpisodeID)
	quit:(existsEpisode=0) "E^就诊表不存在ID为"_EpisodeID_"的就诊记录！"
	
	set opsId=0,unpaidCount=0
	set finishStatus=$System.SQL.ALPHAUP("Finish")
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("Adm"," "_EpisodeID,opsId))
		quit:(opsId="")
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set operStatus=$System.SQL.ALPHAUP(operSchedule.Status.Code)
		quit:(finishStatus'=operStatus)
		set paid=##class(CIS.AN.BL.OperOrder).OperPaid(opsId)
		set:(paid'="S^") unpaidCount=unpaidCount+1
	}	
	
	quit:(unpaidCount>0) "E^还有未收费的手术，请联系手术室处理！"
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

ClassMethod IfFinishCharge(opsId) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set OPFeeFlag=operSchedule.OPFeeFlag
	set ANFeeFlag=operSchedule.ANFeeFlag
	quit:OPFeeFlag'="Y" "E^未收取手术费用!"
	quit:ANFeeFlag'="Y" "E^未收取麻醉费用!"
	quit "S^"
}

}
