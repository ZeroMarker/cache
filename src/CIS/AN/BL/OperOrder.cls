Class CIS.AN.BL.OperOrder Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-02-23
/// Description： 	保存手术申请医嘱
/// Table：        	OE_Order,OE_OrdItem
/// Input：        	opsId:手术ID
/// Return：       	
/// Debug:			w ##class(CIS.AN.BL.OperOrder).SaveAppOrderItem("160")
ClassMethod SaveAppOrderItem(opsId As %String) As %String
{
	set $zt="Error"
	
	set arcimId=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AppArcim")
	quit:(##class(User.ARCItmMast).%ExistsId(arcimId)=0) "E^手术申请关联的医嘱项不存在!"
	
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术计划不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	set EpisodeID=operSchedule.EpisodeID
	quit:(##class(User.PAAdm).%ExistsId(EpisodeID)=0) "E^就诊记录不存在！"
	
	quit:(##class(User.ORAnaesthesia).%ExistsId(operSchedule.ExtAnaestID)=0) "E^HIS麻醉计划不存在！"
	set anaId=operSchedule.ExtAnaestID
	
	set orderItemID=operSchedule.AppOrderItem
	set orderDesc=..GetOrderDesc(opsId)
	// 如果已经存在手术申请医嘱，那么更新手术申请医嘱的描述
	if (orderItemID'="")
	{
		set orderID=$piece(orderItemID,"||",1),itemSub=$piece(orderItemID,"||",2)
		quit:($data(^OEORDi(0,"Ana",anaId,orderID,itemSub))=0) "E^手术申请医嘱不存在！"
		set orderStatCode=##class(CIS.AN.BL.OEOrder).GetOrdStatCode(orderItemID)
		if (orderStatCode="E")!(orderStatCode="V")
		{
			set ^OEORD(orderID,"I",itemSub,"DEP",1)=orderDesc	
		}	
		quit "S^"_orderItemID
	}
	else
	{
		set orderId=$order(^OEORD(0,"Adm",EpisodeID,""))
		// 医嘱主表ID不存在，那么先创建医嘱主表的数据
		if (+orderId=0)
		{
			set today=+$horolog,now=$piece($horolog,",",2)
			set order=##class(User.OEOrder).%New()
			set order.OEORDAdmDR=##class(User.PAAdm).%OpenId(EpisodeID)
			set order.OEORDDate=today
			set order.OEORDTime=now
			set sc=order.%Save()
			quit:($System.Status.IsError(sc)) "E^插入医嘱主表失败，原因："_$System.Status.GetErrorText(sc,"zh-cn")
		}	
		set orderData=arcimId_$c(3)_$zd(+$h,3)_$c(3)_$zt($p($h,",",2))_$c(3)_operSchedule.AppDeptID_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_$c(3)_opsId_$c(3)_orderDesc
		set ret=##class(CIS.AN.BL.OEOrder).InsertOrderItemNew(EpisodeID,orderData,operSchedule.AppUserID,operSchedule.AppDeptID,opsId)
		if ($piece(ret,"^",1)=0)
		{
			quit "E^"_$piece(ret,"^",2)
		}
		else
		{
			set orderItemID=$piece(ret,"*",2)
			set operSchedule.AppOrderItem=orderItemID
			set sc=operSchedule.%Save()
			if ($System.Status.IsError(sc))
			{
				quit "E^"_$System.Status.GetErrorText(sc)	
			}
			else
			{
				quit "S^"_orderItemID	
			}
				
		}
	}
Error
	set $zt=""
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2017-06-22
/// Description： 	获取手术申请医嘱的描述
/// Table：        	
/// Input：        	opsId:手术计划ID
/// Return：       	手术申请医嘱描述
/// Debug:			w ##class(CIS.AN.BL.OperOrder).GetOrderDesc("149")
ClassMethod GetOrderDesc(opsId As %String) As %String
{
	set result=""
	set query=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=query.Execute("","","",opsId)
	set operData=##class(CIS.AN.COM.DataObject).%New()
	while(query.%Next())
	{
		set columnCount=query.GetColumnCount()
		for i=1:1:columnCount
		{
			set keyValuePair=##class(CIS.AN.COM.KeyValuePair).%New()
			set keyValuePair.Key=query.GetColumnName(i)
			set keyValuePair.Value=query.GetData(i)
			do operData.KeyValuePairs.Insert(keyValuePair)	
		}
	}
	set query=##class(%ResultSet).%New("CIS.AN.BL.ConfigQueries:FindDataConfigurations")
	set sc=query.Execute("OrderFormatter")
	set orderFormat=""
	while(query.%Next())
	{
		set orderFormat=query.Get("DataValue")
	}
	if (orderFormat'="")
	{
		set orderDesc=""
		
		do ..GenerateOrderDesc(orderFormat,operData,.orderDesc)
		set result=orderDesc
	}	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-02-23
/// Description： 	根据医嘱格式生成医嘱名称
/// Table：        	
/// Input：        	orderFormat:医嘱格式字符串,operData:手术详细数据
/// Return：       	返回成功状态
/// Debug:			w ##class(CIS.AN.BL.OperOrder).GenerateOrderDesc()
ClassMethod GenerateOrderDesc(orderFormat As %String, operData As CIS.AN.COM.DataObject, Output orderDesc As %String = "") As %String
{
	set leftIndex=$find(orderFormat,"{")
	quit:(leftIndex=0) $$$OK
	set leftIndex=leftIndex-1
	set rightIndex=$find(orderFormat,"}")-1
	set dataField=$extract(orderFormat,leftIndex+1,rightIndex-1)
	set dataValue=operData.GetValue(dataField)
	set $extract(orderFormat,leftIndex,rightIndex)=dataValue
	set orderDesc=orderFormat
	do ..GenerateOrderDesc(orderFormat,operData,.orderDesc)
}

ClassMethod OperPaid(opsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set anaId=operSchedule.ExtAnaestID
	quit:(##class(User.ORAnaesthesia).%ExistsId(anaId)) "E^麻醉不存在！"
	set orderCount=0,orderID=0,itemID=0
	for
	{
		set orderID=$order(^OEORDi(0,"Ana",anaId,orderID))
		quit:(orderID="")
		set itemID=0
		for
		{
			set itemID=$order(^OEORDi(0,"Ana",anaId,orderID,itemID))
			quit:(itemID="")
			set orderItem=##class(User.OEOrdItem).%OpenId(orderID_"||"_itemID)
			continue:(orderItem.OEORIRecDepDR.%Id()'=operSchedule.OperDeptID)
			b //ccq
			set orderCount=orderCount+1	
		}	
	}
	quit:(orderCount>1) "S^"
	quit "E^手术室未完成收费！"
}

ClassMethod ExistsOperOrderItem(EpisodeID As %String) As %String
{
	set opsId=0,result="N"
	for
	{
		set opsId=$order(^DHCAN.OperScheduleI("Adm",EpisodeID,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set existsOrderItem=..ExistsANOrderItem(operSchedule.ExtAnaestID,operSchedule.OperDeptID)
		set:(existsOrderItem) result="Y"
		quit:(result="Y")
	}	
	quit result
}

ClassMethod ExistsANOrderItem(ORAnaestID As %String, recvLocID As %String) As %Boolean
{
	set orderID=0,itemSub=0,existsFlag=0
	for
	{
		set orderID=$order(^OEORDi(0,"Ana",anaId,orderID))
		quit:(orderID="")
		for
		{
			set itemSub=$order(^OEORDi(0,"Ana",anaId,orderID,itemSub))
			quit:(itemSub="")
			set orderItem=##class(User.OEOrdItem).%OpenId(orderID_"||"_itemSub)
			set curRecvLocId=orderItem.OEORIRecDepDR.%Id()
			quit:(curRecvLocId'=recvLocID)
			set existsFlag=1	
		}	
	}	
	quit existsFlag
}

}
