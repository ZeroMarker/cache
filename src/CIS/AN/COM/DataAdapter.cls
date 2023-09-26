/// 数据适配器
Class CIS.AN.COM.DataAdapter Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2019-1-7
/// Description： 	适配医嘱项价格接口
/// Table：        	
/// Input:			arcimId:医嘱项ID，fromDate:开始日期，EpisodeID:患者就诊ID
/// Return：       	String
/// w ##class(DHCCL.BLL.DataAdapter).GetArcimPrice("2||1","","7")
ClassMethod GetArcimPrice(arcimId As %String, fromDate As %String, EpisodeID As %String = "") As %String
{
	set price=0
	try
	{
		set fromDateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(fromDate)
		set price=+##Class(web.DHCDocOrderEntry).GetOrderPrice("","",arcimId,fromDateH,"","","","","","","^^"_EpisodeID)
	}
	catch
	{
		set price=0
	}
	
	quit price
}

/// Creator：      	陈长青
/// CreatDate：    	2019-1-7
/// Description： 	适配接收科室接口
/// Table：        	
/// Input:			locId:科室ID，EpisodeID:患者就诊ID，arcimId:医嘱项ID
/// Return：       	String
/// w ##class(DHCCL.BLL.DataAdapter).GetRecvLocJSON("364","7","1257||1")
ClassMethod GetRecvLocJSON(locId As %String, EpisodeID As %String, arcimId As %String) As %String
{
	s recvLoc=""
	//s itemMain=$p(arcimId,"||",1),itemSub=$p(arcimId,"||",2)
	//s itemCatId=$p($g(^ARCIM(itemMain,itemSub,1)),"^",10)
	//s orderType=$P(^ARC("IC",itemCatId),"^",7)
	//if (EpisodeID'=""){
	//	i (orderType="R"){
	//		s recvLoc=##class(web.DHCDocOrderCommon).GetHolidaysRecLoc(EpisodeID,locId,arcimId)
	//	}
	//	if (recvLoc=""){
	//		i locId'="" s recvLoc=##class(web.DHCDocOrderCommon).GetLocRecLoc(locId,arcimId)
	//		e  s recvLoc=##class(web.DHCDocOrderCommon).GetRecloc(EpisodeID,arcimId)
	//	}
	//}	
	set recvLoc=##class(web.DHCANCall).GetOrderItemRecloc("",arcimId,EpisodeID,locId)
	set recvLocCount=$l(recvLoc,"^"),result=""
	for i=1:1:recvLocCount
	{
		set recvLocStr=$p(recvLoc,"^",i)
		set recvLocId=$p(recvLocStr,$c(3),1),recvLocDesc=$p(recvLocStr,$c(3),2)
		continue:(recvLocId="")
		set:(result'="") result=result_","
		set result=result_"{""RecvLocId"":"_""""_recvLocId_""",""RecvLocDesc"":"_""""_recvLocDesc_"""}"	
	}
	set result="["_result_"]"
	quit result
}

}
