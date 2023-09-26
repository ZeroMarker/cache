/// 麻醉计划业务类
Class CIS.AN.BL.AnaSchedule Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-06-22
/// Description： 	获取HIS麻醉计划ID
/// Table：        	
/// Input：        	opsId:手术计划ID
/// Return：       	HIS麻醉计划ID(ORAnaesthesia)，错误返回错误原因
/// Debug:			w ##class(CIS.AN.BL.AnaSchedule).GetORAnaestID("7")
ClassMethod GetORAnaestID(opsId As %String) As %String
{
	set result=""
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	
	set anaSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	;set operArrange=##class(User.DHCANOPArrange).%OpenId(anaSchedule.
	set result=anaSchedule.ExtAnaestID
	
	quit result
}

}
