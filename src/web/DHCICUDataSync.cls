/// 重症监护数据同步
Class web.DHCICUDataSync Extends %RegisteredObject
{

/// 体温单时间点数量
Parameter SyncTimeCount = 6;

/// 每日分隔时间节点（按此时间点分隔每天） 28800
Parameter DaySeparateTimePoint = 7200;

/// 出入量统计结果同步时间节点
Parameter SummarySyncTimePoint = 86340;

/// 零点日期调整
Parameter ZeroDateCordinate = -1;

/// 零点时间调整
Parameter ZeroTimeCordinate = 86340;

/// 灌肠项目代码
Parameter EnemaItemCode = "Enema1";

/// 体温项目代码
Parameter TemperItemCode = "Temper|EW|GW|PGWD";

/// 高体温阈值
Parameter HighTemperThreshold = 38;

/// 降温体温观察项目ID
Parameter TemperAfterBringDownItemCode = "TemperAfterBringDown";

/// 根据物理降温医嘱的执行数据来获取降温体温
Parameter HighTemperNextFromOrderLoc = 181;

/// 体重项目代码 SyncWeightItem
Parameter WeightItemCode = "Weight";

/// 大便项目代码
Parameter StoolItemCode = "Stool";

/// 大便汇总项目代码
Parameter StoolSummaryItemCode = "TotalStoolTimes";

/// 互斥项目代码
Parameter ExclusiveItemList = "{Temper|EW|GW|PGWD},{Resp|RR-Set}";

/// 护理记录项目代码
Parameter NursingRecordItemCode = "NursingRecord";

/// 按时间点获取数据时的有效数据时间范围
Parameter ValidInterval = 1800;

/// 同步体温单数据
/// w ##class(web.DHCICUDataSync).SyncTemperatureData(16,7,"2022-09-19","7:00","2022-09-20","6:59:59","Y")
ClassMethod SyncTemperatureData(locId, icuaId, startDate, startTime, endDate, endTime, ifSend = "Y") As %String
{
	set date=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set result=""
	if icuaId'="" set result=..SyncPatTemperData(icuaId,date,ifSend)
	else  if locId'="" set result=..SyncDeptTemperData(locId, date, ifSend)
	
	quit result
}

/// 同步科室体温单数据
ClassMethod SyncDeptTemperData(locId, date, ifSend = "N") As %String
{
	quit:locId="" "科室ID为空"
	
	kill items
	do ..GetItems(locId,date,.items)
	set patList=..GetCurrentPatsInLoc(locId)
	
	for i=1:1:$ll(patList)
	{
		set icuaId=$lg(patList,i)
		set sendingData=..GetSendingDatas(icuaId,.items)
		if ifSend="Y" do ..SendToNUR(sendingData)
		else  do ..Debug(sendingData)
	}
	
	quit "0"
}

/// 同步病人体温单数据
/// w ##class(web.DHCICUDataSync).SyncPatTemperData(269250,$zdh("2021-06-14",3))
ClassMethod SyncPatTemperData(icuaId, date, ifSend = "N") As %String
{
	quit:icuaId="" "重症记录ID为空"
	
	kill items
	set locId=..GetLocation(icuaId)
	do ..GetItems(locId,date,.items)
	
	// 获取同步发送数据
	set sendingData=..GetSendingDatas(icuaId,.items)
	
	// 发送至护士站接口
	if ifSend="Y" do ..SendToNUR(sendingData)
	else  do ..Read(sendingData)
	quit "0"
}

ClassMethod GetSendingDatas(icuaId, ByRef items) As %DynamicObject
{
	// 获取同步发送数据
	set sendingData=..GetPatInfo(icuaId)
	set syncDatas=..GetSyncDatas(icuaId,.items)
	set sendingData.SyncDatas=syncDatas
	
	quit sendingData
}

/// 获取同步发送数据
ClassMethod GetSyncDatas(icuaId, ByRef items) As %DynamicArray
{
	
	// 获取普通同步数据
	set primaryData=..GetICUData(icuaId,.items)
	
	// 获取统计数据
	set summaryData=..GetDailyInOut(icuaId,.items)
	//break //before proceed high temper
	// 特殊数据处理
	set primaryData=..ProceedHighTemper(icuaId,primaryData)
	//break //before proceed high temper by oeorder execution
	//大ICU从物理降温医嘱的执行记录来判断获取降温体温
	set location=..GetLocation(icuaId)
	if location=..#HighTemperNextFromOrderLoc
	{
		set primaryData=..ProceedHighTemperByExec(icuaId,items("SyncDate"),primaryData)
	}
	//break //before proceed pat weight
	set primaryData=..ProceedPatWeight(icuaId,items("SyncDate"),primaryData)
	set primaryData=..ProceedExclusiveItem(icuaId,primaryData)
	//set summaryData=..ProceedStool(icuaId,items("SyncDate"),summaryData)
	set summaryData=..ProceedFirstDayIn(icuaId,items("SyncDate"),summaryData)
	//break //before convert
	set result=..ConvertToSendingDatas(icuaId,.items,primaryData,summaryData)
	
	quit result
}

/// 调试数据
ClassMethod Debug(data As %DynamicObject) As %String
{
	set EpisodeID=data.EpisodeID
	set PatName=data.PatName
	set WardBed=data.WardBed
	set RowId=data.RowId
	
	set foundError=0,errorInfo=##class(%DynamicArray).%New()
	set iter=data.SyncDatas.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=value.Date
		set time=value.Time
		//write !,date,",",time
		set rows=value.Rows
		set rowIter=rows.%GetIterator()
		while rowIter.%GetNext(.index,.row)
		{
			set observeItem=row.ObserveItem
			set desc=row.Description
			set userId=row.UserId
			set qty=row.Value
			if userId=""{
				set foundError=1
				do errorInfo.%Push(date_","_time_","_desc_":"_qty_" ["_userId_"]; ")
			}
			//write ",",desc,":",qty," [",userId,"]"
		}
	}
	
	write data.%ToJSON(),!
	
	if foundError{
		write RowId,",",EpisodeID,",",WardBed,",",PatName
		write errorInfo.%ToJSON()
		write !
	}
	quit ""
}

/// 读取数据
ClassMethod Read(data As %DynamicObject) As %String
{
	set EpisodeID=data.EpisodeID
	set PatName=data.PatName
	set WardBed=data.WardBed
	set RowId=data.RowId
	write RowId,",",EpisodeID,",",WardBed,",",PatName
	set iter=data.SyncDatas.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=value.Date
		set time=value.Time
		write !,date,",",time
		set rows=value.Rows
		set rowIter=rows.%GetIterator()
		while rowIter.%GetNext(.index,.row)
		{
			set observeItem=row.ObserveItem
			set desc=row.Description
			set userId=row.UserId
			set qty=row.Value
			write ",",desc,":",qty," [",userId,"]"
		}
	}
	write !
	quit ""
}

/// 发送给护士站接口
ClassMethod SendToNUR(data As %DynamicObject) As %String
{
	set EpisodeID=data.EpisodeID
	set iter=data.SyncDatas.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=value.Date
		set time=value.Time
		set rows=value.Rows
		set rowIter=rows.%GetIterator()
		while rowIter.%GetNext(.index,.row)
		{
			set observeItem=row.ObserveItem
			set userId=row.UserId
			set qty=row.Value
			
 			set retStr=##class(web.DHCTHREEE).InsertData(EpisodeID,observeItem,date,time,userId,qty)
		}
	}
	
	quit ""
}

/// 获取汇总项目
/// w ##class(web.DHCICUDataSync).GetItems(181,.summaryItems)
ClassMethod GetItems(locId, date, ByRef items) As %String
{
	kill summaryItems
	do ..GetSummaryItems(locId,.summaryItems)
	do ..GetSyncItems(locId,.summaryItems,.items)
	do ..CordinateTime(date,.items)
	quit ""
}

/// 时间校对
/// w ##class(web.DHCICUDataSync).CordinateTime($zdh("2021-06-09",3),.items)
ClassMethod CordinateTime(date, ByRef items) As %String
{
	set items("SyncDate")=date
	set time=""
	set interval=3600*24\..#SyncTimeCount
	for i=1:1:..#SyncTimeCount
	{
		set time=..#DaySeparateTimePoint + (interval * (i-1))
		
		set actualDate=date + (time\86400)
		set actualTime=time#86400
		set insertDate=actualDate,insertTime=actualTime
		if actualTime=0 set insertDate=actualDate-1,insertTime=..#ZeroTimeCordinate
		set items("SyncTime",time,"DateH")=actualDate
		set items("SyncTime",time,"TimeH")=actualTime
		set items("SyncTime",time,"InsertDateH")=insertDate
		set items("SyncTime",time,"InsertTimeH")=insertTime
	}
	
	quit ""
}

/// 获取汇总项目
/// w ##class(web.DHCICUDataSync).GetSummaryItems(181,.summaryItems)
ClassMethod GetSummaryItems(locId, ByRef items) As %String
{
	set rowId=""
	for
	{
		set rowId=$o(^DHCICUC("IOItem",0,"Ctloc",locId,rowId))
		quit:rowId=""
		
		set IOItem=##class(User.DHCICUCIOItem).%OpenId(rowId)
		set active=IOItem.ICUCIOIActive
		continue:active="N"
		
		set mainItem="",mainItemCode="",mainRecordItem=""
		if $ISOBJECT(IOItem.ICUCIOIMainICUCIOIDr) 
		{
			set mainItem=IOItem.ICUCIOIMainICUCIOIDr.%Id()
			set mainItemCode=IOItem.ICUCIOIMainICUCIOIDr.ICUCIOICode
			set:$ISOBJECT(IOItem.ICUCIOIMainICUCIOIDr.ICUCIOIComOrdDr) mainRecordItem=IOItem.ICUCIOIMainICUCIOIDr.ICUCIOIComOrdDr.%Id()
			continue:mainItemCode=""
		}
		set recordItem=""
		set:$ISOBJECT(IOItem.ICUCIOIComOrdDr) recordItem=IOItem.ICUCIOIComOrdDr.%Id()
		set field=IOItem.ICUCIOIValueField
		set multiple=IOItem.ICUCIOIMultiple
		set code=IOItem.ICUCIOICode
		set desc=IOItem.ICUCIOIDesc
		set type=IOItem.ICUCIOIType
		continue:code=""
		
		if mainItem'=""
		{
				set:'$d(items("Summary",mainItem)) items("Summary",mainItem)=""
				set:recordItem'="" items("Summary",mainItem,"I",recordItem)=$lb(rowId,code,desc,recordItem,field,multiple,type)
		}
		else
		{
			set items("Summary",rowId)=$lb(rowId,code,desc,recordItem,field,multiple,type)
		}
	}
	
	quit ""
}

/// 获取同步项目
/// w ##class(web.DHCICUDataSync).GetSyncItems(181,.summaryItems,.items)
ClassMethod GetSyncItems(locId, ByRef summaryItems, ByRef items) As %String
{
	set rowId=0,summaryTime=0
	for
	{
		set rowId=$o(^DHCICUC("Temperature",rowId))
		quit:rowId=""
		//write !,rowId,","
		continue:'##class(User.DHCICUCTemperature).%ExistsId(rowId)
		
		set temperSyncSetting=##class(User.DHCICUCTemperature).%OpenId(rowId)
		set recordItem=temperSyncSetting.ICUCTRecordItemCode
		if recordItem'=+recordItem set recordItem=$O(^DHCICUC("RecordItem",0,"Code",recordItem,""))
		//write recordItem,",",temperSyncSetting.ICUCTCtlocId,","
		continue:recordItem=""
		continue:(temperSyncSetting.ICUCTCtlocId'="")&&(temperSyncSetting.ICUCTCtlocId'=locId)
		
		set items("Item",recordItem)=temperSyncSetting.ICUCTObservationItemCode
		
		set inOutItem=$p(^DHCICUC("RecordItem",recordItem),"^",12)
		if (inOutItem'="")
		{
			if $d(summaryItems("Summary",inOutItem))
			{
				set items("Item",recordItem,"Summary")=inOutItem
				merge items("Summary",recordItem)=summaryItems("Summary",inOutItem)
			}
			else
			{
				kill items("Item",recordItem)
			}
		}
	}
	
	quit "S^"
}

/// 获取重症监护数据（初级数据）
/// w ##class(web.DHCICUDataSync).GetICUData(269250,.items)
ClassMethod GetICUData(icuaId, ByRef items) As %DynamicObject
{
	set result=##class(%DynamicObject).%New()
	set syncTime=""
	for
	{
		set syncTime=$o(items("SyncTime",syncTime))
		quit:syncTime=""
		
		set date=items("SyncTime",syncTime,"DateH")
		set time=items("SyncTime",syncTime,"TimeH")
		set timeObj=##class(%DynamicObject).%New()
		set timeObj.Date=date
		set timeObj.Time=time
		
		set rows=##class(%DynamicObject).%New()
		set recordItem="",userId=""
		for
		{
			set recordItem=$o(items("Item",recordItem))
			quit:recordItem=""
			
			set value=..GetValue(icuaId,recordItem,date,time,"Y")
			if value'=""
			{
				do rows.%Set(recordItem,value)
				set:value.UserId'="" userId=value.UserId
			}
		}
		
		set timeObj.UserId=userId
		set timeObj.Rows=rows
		do result.%Set(date_","_time,timeObj)
	}
	//write result.%ToJSON()
	quit result
}

/// 计算每日的出入量
/// w ##class(web.DHCICUDataSync).GetDailyInOut(269250,.items)
ClassMethod GetDailyInOut(icuaId, ByRef items) As %DynamicObject
{
	set result=##class(%DynamicObject).%New()
	
	set date=items("SyncDate")
	kill datas
	set code=""
	for
	{
		set code=$o(items("Summary",code))
		quit:code=""
		
		set subItem=""
		for
		{
			set subItem=$o(items("Summary",code,"I",subItem))
			quit:subItem=""
		
			set itemCode=$lg(items("Summary",code,"I",subItem),2)
			set itemDesc=$lg(items("Summary",code,"I",subItem),3)
			set recordItem=$lg(items("Summary",code,"I",subItem),4)
			set field=$lg(items("Summary",code,"I",subItem),5)
			set:field="" field="Qty"
			set multiple=+$lg(items("Summary",code,"I",subItem),6)
			set:multiple=0 multiple=1
			do CalculateSummary
		}
	}
	
	set data=##class(%DynamicObject).%New()
	set code=""
	for
	{
		set code=$o(datas(code))
		quit:code=""
		
		set obj=##class(%DynamicObject).%New()
		set obj.Value=+$g(datas(code,date))
		set obj.Code=$lg(items("Summary",code),2)
		set obj.Description=$lg(items("Summary",code),3)
		set obj.UserId=$g(datas(code,date,0,"UserId"))
		set obj.Details=##class(%DynamicArray).%New()
		set obj.Count=0
		set subItem=0
		for
		{
			set subItem=$o(datas(code,date,subItem))
			quit:subItem=""
			set subObj=##class(%DynamicObject).%New()
			set subObj.Code=$lg(items("Summary",code,"I",subItem),2)
			set subObj.Description=$lg(items("Summary",code,"I",subItem),3)
			set subObj.Value=+$g(datas(code,date,subItem))
			set subObj.Count=+$g(datas(code,date,subItem,"Count"))
			set obj.Count=obj.Count+subObj.Count
			do obj.Details.%Push(subObj)
		}
		do data.%Set(code,obj)
	}
	
	do result.%Set("StartTime",$zd(date,3)_" "_$zt(..#DaySeparateTimePoint))
	do result.%Set("EndTime",$zd(date+1,3)_" "_$zt(..#DaySeparateTimePoint-1))
	do result.%Set("Data",data)
	
	set EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	set admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	set admTime=$p($g(^PAADM(EpisodeID)),"^",7)
	set icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	set icuaStartTime=$p($g(^DHCICUArrange(icuaId)),"^",8)
	set duration=##class(web.DHCClinicCom).CalculateDuration(admDate,admTime,icuaStartDate,icuaStartTime)
	if (duration<10800)&&(icuaStartTime<7200)&&(date=icuaStartDate-1)
	{
		do result.%Set("Data",##class(%DynamicObject).%New())
	}
	
	//write result.%ToJSON()
	quit result
	
CalculateSummary()

	for datei=date:1:date+1
	{
		set time=""
		set:datei=date time=..#DaySeparateTimePoint - 1
		for
		{
			set time=$o(^DHCICUOrder(0,"RecordItem",recordItem,datei,icuaId,time))
			quit:time=""
			
			continue:(datei=date)&&(time<..#DaySeparateTimePoint)
			quit:(datei>date)&&(time>=..#DaySeparateTimePoint)
			
			set hourlyTime=time\3600
			set icuoId=""
			for
			{
				set icuoId=$o(^DHCICUOrder(0,"RecordItem",recordItem,datei,icuaId,time,icuoId))
				quit:icuoId=""
				
				set order=$g(^DHCICUOrder(icuoId))
				set editflag=$p(order,"^",25)
				continue:(editflag'="N")&&(editflag'="E")
		
				set value=$s(field="Note":$p(order,"^",10),
							field="Qty":$p(order,"^",11),
							field="Volume":$p(order,"^",28),
							1:$p(order,"^",11))
				set userId=$p(order,"^",4)
				set abbreviate=$p(order,"^",34)
				set datas(code,date)=+$g(datas(code,date))+(value*multiple)
				set:userId'="" datas(code,date,0,"UserId")=userId
				set datas(code,date,subItem)=+$g(datas(code,date,subItem))+(value*multiple)
				set datas(code,date,subItem,"Count")=+$g(datas(code,date,subItem,"Count"))+1
			}
		}
	}
	quit
}

/// 转换为发送中处理的数据结构
ClassMethod ConvertToSendingDatas(icuaId, ByRef items, datas As %DynamicObject, summaryDatas As %DynamicObject) As %DynamicArray
{
	set summaryInsertTime=..#SummarySyncTimePoint
	set result=##class(%DynamicArray).%New()
	set syncDate=items("SyncDate")
	set iter=datas.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=$p(key,",",1)
		set time=$p(key,",",2)
		if date>syncDate set time=time+86400
		set insertDateH=items("SyncTime",time,"InsertDateH")
		set insertTimeH=items("SyncTime",time,"InsertTimeH")
		set sendingTimePoint=##class(%DynamicObject).%New()
		set sendingTimePoint.Date=$zd(insertDateH,3)
		set sendingTimePoint.Time=$zt(insertTimeH)
		
		set sendingRows=##class(%DynamicArray).%New()
		set rowIter=value.Rows.%GetIterator()
		while rowIter.%GetNext(.rowIndex,.row)
		{
			if row.%IsDefined("Value")&&($d(items("Item",rowIndex)))
			{
				set sendingRow=##class(%DynamicObject).%New()
				set sendingRow.RecordItem=rowIndex
				set sendingRow.ObserveItem=items("Item",rowIndex)
				set sendingRow.Value=row.Value
				set sendingRow.UserId=row.UserId
				set:sendingRow.UserId="" sendingRow.UserId=..GetUserId(icuaId,insertDateH,insertTimeH)
				set sendingRow.Description=row.Description
				do sendingRows.%Push(sendingRow)
			}
		}
		
		if insertTimeH=summaryInsertTime
		{
			set rowIter=summaryDatas.Data.%GetIterator()
			while rowIter.%GetNext(.rowIndex,.row)
			{
				set sendingRow=##class(%DynamicObject).%New()
				set sendingRow.RecordItem=rowIndex
				set sendingRow.ObserveItem=items("Item",rowIndex)
				set sendingRow.Value=row.Value
				set sendingRow.UserId=row.UserId
				set:sendingRow.UserId="" sendingRow.UserId=..GetUserId(icuaId,insertDateH,insertTimeH)
				set sendingRow.Description=row.Description
				do sendingRows.%Push(sendingRow)
			}
		}
		
		set sendingTimePoint.Rows=sendingRows
		do result.%Push(sendingTimePoint)
	}
	
	quit result
}

ClassMethod GetRecordItemIdList(itemCodeStr As %String) As %List
{
	set result=""
	set list=$LISTFROMSTRING(itemCodeStr,"|")
	for i=1:1:$ll(list)
	{
		set itemCode=$lg(list,i)
		if itemCode'=""
		{
			set rowId=$o(^DHCICUC("RecordItem",0,"Code",itemCode,""),-1)
			set:rowId'="" result=result_$lb(rowId)
		}
	}
	
	quit result
}

/// 降温体温
ClassMethod ProceedHighTemper(icuaId, data As %DynamicObject) As %DynamicObject
{
	set temperItemIdList=..GetRecordItemIdList(..#TemperItemCode)
	set valueThreshold=..#HighTemperThreshold
	set temperAfterBringDownItemId=..GetRecordItemIdList(..#TemperAfterBringDownItemCode)
	set iter=data.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=value.Date
		set time=value.Time
		set nextDate=date
		set nextTime=time+60
		if nextTime>=86400 set nextTime=nextTime-86400,nextDate=nextDate+1
		
		set rows=value.Rows
		set highTemper=0
		for i=1:1:$ll(temperItemIdList)
		{
			set recordItem=$lg(temperItemIdList,i)
			set value=rows.%Get(recordItem)
			if (value'="") && (value.Value>=valueThreshold)
			{
				set highTemper=1
				set nextValue=..GetValue(icuaId,recordItem,nextDate,nextTime)
				set value.HighTemper=1
				do:temperAfterBringDownItemId'="" rows.%Set(temperAfterBringDownItemId,nextValue)
			}
		}
	}
	
	quit data
}

/// 根据物理降温医嘱执行记录来获取降温体温数据
/// w ##class(web.DHCICUOrder).ProceedHighTemperByExec(54451,"")
ClassMethod ProceedHighTemperByExec(icuaId, date, data As %DynamicObject) As %DynamicObject
{
	kill executionList
	set ret=..GetOrderExecTime(icuaId, "2449||1", date,.executionList)
	set ret=..GetOrderExecTime(icuaId, "2514||1", date,.executionList)
	set highTemperNextDatas=..GetTemperAfterExec(icuaId,.executionList)
	
	set temperItemIdList=..GetRecordItemIdList(..#TemperItemCode)
	set temperAfterBringDownItemId=..GetRecordItemIdList(..#TemperAfterBringDownItemCode)
	set iter=data.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=value.Date
		set time=value.Time
		set rows=value.Rows
		
		set nextValue=highTemperNextDatas.%Get(key)
		if nextValue'=""
		{
			set highTemper=1
			for i=1:1:$ll(temperItemIdList)
			{
				set recordItem=$lg(temperItemIdList,i)
				set value=rows.%Get(recordItem)
				if value'=""
				{
					set value.HighTemper=1
					do:temperAfterBringDownItemId'="" rows.%Set(temperAfterBringDownItemId,nextValue)
				}
			}
		}
	}
	
	quit data
}

/// w ##class(web.DHCICUOrder).GetOrderExecTime(1,65450,.executionList)
ClassMethod GetOrderExecTime(icuaId, arcimId, date, ByRef executionList) As %String
{
	set ArcimId=arcimId
	set startDate=date
	set startTime=..#DaySeparateTimePoint
	set endDate=date
	set endTime=..#DaySeparateTimePoint
	
	set EpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	set oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	quit:oeordId="" "-1"
	
	for datei=(startDate-1):1:endDate
	{
		set oeoriSub=""
		for
		{
			set oeoriSub=$o(^OEORDi(0,"ARCIM",oeordId,arcimId,datei,oeoriSub))
			quit:oeoriSub=""

			set oeoreSub=1
			set oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
			set oeoreStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16)
			set oeoreStatus=$p($g(^OEC("STAT",+oeoreStatusId)),"^",1)
			continue:((oeoreStatus'="E")&&(oeoreStatus'="F"))
		
			set oeoreDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)
			set oeoreTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)
			
			continue:((oeoreDate+(oeoreTime*0.00001))<(startDate+(startTime*0.00001)))||((oeoreDate+(oeoreTime*0.00001))>(endDate+(endTime*0.00001)+0.036))
		    
			set executionList(icuaId,oeoreId)=oeoreDate_","_oeoreTime
		}
	}
	
	quit $d(executionList(icuaId))
}

/// w ##class(web.DHCICUOrder).GetTemperAfterExec(1,.executionList)
ClassMethod GetTemperAfterExec(icuaId, ByRef executionList) As %DynamicObject
{
	set result = ##class(%DynamicObject).%New()
	set syncTimeCount = ..#SyncTimeCount
	set temperItemIdList=..GetRecordItemIdList(..#TemperItemCode)
	set syncTime=""
	set temperItemId=""
	
	set oeoreId=""
	for
	{
		set oeoreId=$o(executionList(icuaId,oeoreId))
		quit:oeoreId=""
		
		set oeoreDate=+executionList(icuaId,oeoreId)
		set oeoreTime=+$p(executionList(icuaId,oeoreId),",",2)
		set syncDate=oeoreDate
		set syncTime=$fn((oeoreTime*syncTimeCount/(3600*24)),"",0)*3600*24/syncTimeCount
		if (syncTime>=(3600*24)) set syncDate=syncDate+1,syncTime=syncTime-(3600*24)
		
		set endDate=oeoreDate
		set endTime=$s(syncTime>oeoreTime:syncTime,1:oeoreTime)+3600
		if (endTime >= (3600*24)) set endDate=endDate+1,endTime=endTime-(3600*24)
		
		set foundIcuoId=""
		for date=oeoreDate:1:endDate
		{
			quit:foundIcuoId>0
			
			for i=1:1:$ll(temperItemIdList)
			{
				set temperItemId=$lg(temperItemIdList,i)
				quit:foundIcuoId>0
				
				set time=$s(date=oeoreDate:oeoreTime,1:"")-1
				for
				{
					set time=$o(^DHCICUOrder(0,"RecordItem",temperItemId,date,icuaId,time))
					quit:(time="")||((date=endDate)&&(time>endTime))
			    	quit:foundIcuoId>0
			    	
					set icuoId=""
					for
					{
						set icuoId=$o(^DHCICUOrder(0,"RecordItem",temperItemId,date,icuaId,time,icuoId))
						quit:icuoId=""
				
						set editFlag=$p(^DHCICUOrder(icuoId),"^",25)
						if (editFlag="N")||(editFlag="E") 
						{
							set foundIcuoId=icuoId
							quit
						}
					}
				}
			}
		}
		
		set obj = ##class(%DynamicObject).%New()
		if (foundIcuoId)
		{
			set value=$p(^DHCICUOrder(foundIcuoId),"^",11)
			set userId=$p(^DHCICUOrder(foundIcuoId),"^",4)
			set obj.Date=syncDate
			set obj.Time=syncTime
			set obj.RowId=foundIcuoId
			set obj.Value=value
			set obj.UserId=userId
			set obj.Note="FromOEOrder"
			do result.%Set(syncDate_","_syncTime,obj)
		}
	}
	
	quit result
}

/// 体重数据
ClassMethod ProceedPatWeight(icuaId, date, data As %DynamicObject) As %DynamicObject
{
	set weightSyncItemId=$o(^DHCICUC("RecordItem",0,"Code",..#WeightItemCode,""),-1)
	set syncTimeCount=..#SyncTimeCount
	set DaySeparateTimePoint=..#DaySeparateTimePoint
	
	set EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	set admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	set admTime=$p($g(^PAADM(EpisodeID)),"^",7)
	set icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	set icuaStartTime=$p($g(^DHCICUArrange(icuaId)),"^",8)
	set syncDate=date,firstInPatSyncDate=date
	set syncTime=DaySeparateTimePoint
	set firstInPatSyncTime=((icuaStartTime*syncTimeCount\(3600*24))+1)*3600*24/syncTimeCount
	if (firstInPatSyncTime>=(3600*24)) set firstInPatSyncDate=date+1,firstInPatSyncTime=firstInPatSyncTime-(3600*24)
	
	if (date+1)<icuaStartDate quit data
	
	set userId="",value=""
	set obj=##class(%DynamicObject).%New()
	if (((date-admDate)#7)=0)&&(date>admDate)
	{
		set value="卧床"
	}
	if (admDate=icuaStartDate)&&(((date=admDate)&&(firstInPatSyncTime>=DaySeparateTimePoint))||((firstInPatSyncTime<DaySeparateTimePoint)&&(date=(admDate-1))))
	{
		set value="平车"
		set syncDate=firstInPatSyncDate,syncTime=firstInPatSyncTime
	}

	if value'=""
	{
		set timePoint=syncDate_","_syncTime
		set userId=..GetUserId(icuaId,syncDate,syncTime)
		if userId="" set userId=..GetUserId(icuaId,syncDate+1,0)
		if userId="" set userId=..GetUserId(icuaId,syncDate+1,28800)
		set obj.Value=value
		set obj.UserId=userId
		set obj.Description="体重"
		set timePointData=data.%Get(timePoint)
		do timePointData.Rows.%Set(weightSyncItemId,obj)
	}
	
	quit data
}

/// 互斥项目
ClassMethod ProceedExclusiveItem(icuaId, data As %DynamicObject) As %DynamicObject
{
	set list=$LISTFROMSTRING(..#ExclusiveItemList,",")
	
	kill exclusiveItemList
	for i=1:1:$ll(list)
	{
		set recordItemCodeStr=$lg(list,i)
		set recordItemCodeStr=$Replace(recordItemCodeStr,"{","")
		set recordItemCodeStr=$Replace(recordItemCodeStr,"}","")
		set recordItemIdList=..GetRecordItemIdList(recordItemCodeStr)
		set exclusiveItemList(i)=""
		for j=1:1:$ll(recordItemIdList)
		{
			set recordItem=$lg(recordItemIdList,j)
			set exclusiveItemList(i,"I",recordItem)=$p($g(^DHCICUC("RecordItem",+recordItem)),"^",2)
		}
	}
	
	set iter=data.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		set date=value.Date
		set time=value.Time
		set rows=value.Rows
		
		set index=""
		for
		{
			set index=$o(exclusiveItemList(index))
			quit:index=""
			
			set exclued=0,exValue="",recordItem=""
			for
			{
				set recordItem=$o(exclusiveItemList(index,"I",recordItem))
				quit:recordItem=""
				
				set value=rows.%Get(recordItem)
				if value'=""
				{
					set exclued=1,exValue=value
					quit
				}
			}
			
			if exclued
			{
				set recordItem=""
				for
				{
					set recordItem=$o(exclusiveItemList(index,"I",recordItem))
					quit:recordItem=""
					
					set value=rows.%Get(recordItem)
					if value=""{
						set emptyValue=##class(%DynamicObject).%New()
						set emptyValue.Value=""
						set emptyValue.UserId=exValue.UserId
						set emptyValue.Description=$g(exclusiveItemList(index,"I",recordItem))
						set emptyValue.Note="ExclusiveItem"
						do rows.%Set(recordItem,emptyValue)
					}
				}
			}
		}
	}
	
	quit data
}

/// 大便同步：次数,次数/E
ClassMethod ProceedStool(icuaId, date, data As %DynamicObject) As %DynamicObject
{
	set EnemaItemId=$o(^DHCICUC("RecordItem",0,"Code",..#EnemaItemCode,""),-1)
	set existsEnema=..ExistsData(icuaId,EnemaItemId,date)
	set StoolSummaryItemCode=..#StoolSummaryItemCode
	
	set iter=data.Data.%GetIterator()
	while iter.%GetNext(.key,.value)
	{
		if (value'="")&&(value.Code[StoolSummaryItemCode)&&(value.Value>0)
		{
			if existsEnema set value.Value=value.Count_"/E"
			else  set value.Value=value.Count
		}
	}
	
	quit data
}

/// 处理入科首日,出入量添加时间间隔备注
ClassMethod ProceedFirstDayIn(icuaId, date, data As %DynamicObject) As %DynamicObject
{
	set EpisodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	set admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	set icuaStartDate=$p($g(^DHCICUArrange(icuaId)),"^",6)
	set icuaStartTime=$p($g(^DHCICUArrange(icuaId)),"^",8)
	set NursingRecordItemId=+$o(^DHCICUC("RecordItem",0,"Code",..#NursingRecordItemCode,""),-1)
	set DaySeparateTimePoint=..#DaySeparateTimePoint
	set isFirstDate=0
	if (icuaStartDate=(date+1))&&(icuaStartTime<DaySeparateTimePoint) set isFirstDate=1
	if (icuaStartDate=date)&&(icuaStartTime>DaySeparateTimePoint+3600) set isFirstDate=1
	
	if isFirstDate
	{
		set firstOrderTime=$o(^DHCICUOrder(0,"RecordItem",NursingRecordItemId,icuaStartDate,icuaId,""))
		set firstDayDuration=##class(web.DHCClinicCom).CalculateDuration(icuaStartDate,icuaStartTime,date+1,DaySeparateTimePoint)
		set firstDayDuration=firstDayDuration\3600
		set inOutTotalNote="("_firstDayDuration_"h)"
		set iter=data.Data.%GetIterator()
		while iter.%GetNext(.key,.value)
		{
			set:value'="" value.Value=value.Value_inOutTotalNote
		}
	}
	
	quit data
}

/// 获取用户ID
/// w ##class(web.DHCICUDataSync).GetUserId(274839,66029,28800)
ClassMethod GetUserId(icuaId, filterDate, filterTime) As %String
{
	set result=""
	set startDate=filterDate,endDate=filterDate
	set startTime=filterTime,endTime=filterTime
	set startTime=filterTime-..#ValidInterval,endTime=filterTime+..#ValidInterval
	if startTime<0 set startDate=startDate-1,startTime=startTime+86400
	if endTime>=86400 set endDate=endDate+1,endTime=endTime-86400
	
	set hasFound=0
	for date=startDate:1:endDate
	{
		quit:hasFound
		set time=""
		if date=startDate set time=startTime
		for
		{
			set time=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time))
			quit:time=""
			quit:(date=endDate)&&(time>=endTime)
			quit:hasFound
			
			set icuoId=""
			for
			{
				set icuoId=$o(^DHCICUOrder(0,"SttDateTime",date,icuaId,time,icuoId))
				quit:icuoId=""
				quit:hasFound
			
				set editflag=$p(^DHCICUOrder(icuoId),"^",25)
				continue:(editflag'="N")&&(editflag'="E")
			
				set userId=$p(^DHCICUOrder(icuoId),"^",4)
				set startDate=+$p(^DHCICUOrder(icuoId),"^",5)
				set startTime=+$p(^DHCICUOrder(icuoId),"^",6)
		
				if userId'="" set hasFound=1,result=userId
			}
		}
	}
	
	quit result
}

/// 获取数据值
/// w ##class(web.DHCICUDataSync).GetValue(269250,5329,65909,28800).%ToJSON()
ClassMethod GetValue(icuaId, recordItemId, filterDate, filterTime, isExact = "N") As %DynamicObject
{
	set result=##class(%DynamicObject).%New()
	set field=$p($g(^DHCICUC("RecordItem",+recordItemId)),"^",24)
	set desc=$p($g(^DHCICUC("RecordItem",+recordItemId)),"^",2)
	set startDate=filterDate,endDate=filterDate
	set startTime=filterTime,endTime=filterTime
	set startTime=filterTime-..#ValidInterval,endTime=filterTime+..#ValidInterval
	if startTime<0 set startDate=startDate-1,startTime=startTime+86400
	if endTime>=86400 set endDate=endDate+1,endTime=endTime-86400
	
	set hasFound=0
	for date=startDate:1:endDate
	{
		quit:hasFound
		set time=""
		if date=startDate set time=startTime
		for
		{
			set time=$o(^DHCICUOrder(0,"RecordItem",recordItemId,date,icuaId,time))
			quit:time=""
			quit:(date=endDate)&&(time>=endTime)
			quit:(isExact="Y")&&((date'=filterDate)||(time'=filterTime))
			quit:hasFound
			
			set icuoId=""
			for
			{
				set icuoId=$o(^DHCICUOrder(0,"RecordItem",recordItemId,date,icuaId,time,icuoId))
				quit:icuoId=""
				quit:hasFound
			
				set editflag=$p(^DHCICUOrder(icuoId),"^",25)
				continue:(editflag'="N")&&(editflag'="E")
			
				set value=$s(field="Note":$p(^DHCICUOrder(icuoId),"^",10),
						field="Qty":$p(^DHCICUOrder(icuoId),"^",11),
						field="Volume":$p(^DHCICUOrder(icuoId),"^",28),
						1:$p(^DHCICUOrder(icuoId),"^",10))
				set userId=$p(^DHCICUOrder(icuoId),"^",4)
				set startDate=+$p(^DHCICUOrder(icuoId),"^",5)
				set startTime=+$p(^DHCICUOrder(icuoId),"^",6)
			
				do result.%Set("RowId",icuoId)
				do result.%Set("Date",$zd(startDate,3))
				do result.%Set("Time",$zt(startTime))
				do result.%Set("RecordItem",recordItemId)
				do result.%Set("UserId",userId)
				do result.%Set("Value",value)
				do result.%Set("Description",desc)
				set hasFound=1
			}
		}
	}
	
	quit result
}

/// 是否存在数据
ClassMethod ExistsData(icuaId, recordItemId, filterDate, filterTime = "") As %String
{
	set exists=0
	for i=0:1:1
	{
		set date=filterDate+i
		set:date=filterDate time=..#DaySeparateTimePoint-1
		quit:exists
		for
		{
			set time=$o(^DHCICUOrder(0,"RecordItem",recordItemId,date,icuaId,time))
			quit:time=""
			quit:(date>filterDate)&&(time>=..#DaySeparateTimePoint)
			quit:exists
		
			set icuoId=""
			for
			{
				set icuoId=$o(^DHCICUOrder(0,"RecordItem",recordItemId,date,icuaId,time,icuoId))
				quit:icuoId=""
				quit:exists
			
				set editflag=$p(^DHCICUOrder(icuoId),"^",25)
				continue:(editflag'="N")&&(editflag'="E")
				
				set exists=1
			}
		}
	}
	
	quit exists
}

ClassMethod GetLocation(icuaId) As %String
{
	set bedId=$p(^DHCICUArrange(icuaId),"^",4)
	set locId=$p($g(^PAWARD(+bedId)),"^",5)
	quit locId
}

ClassMethod GetCurrentPatsInLoc(locId) As %List
{
	set icuaIdList=##class(web.DHCICUCom).FindIcuaIdList("", "", locId)
	
	quit $LISTFROMSTRING(icuaIdList,"^")
}

ClassMethod GetPatInfo(icuaId) As %DynamicObject
{
	set object=##class(%DynamicObject).%New()
	
	set icuArrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	set EpisodeID=icuArrange.ICUAAdmDr
	set wardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	set bedId=$p($g(^PAADM(EpisodeID)),"^",73)
	set bedSub=$p(bedId,"||",2)
	set bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	set icuBedId=icuArrange.ICUABedDr
	set Location=$p($g(^PAWARD(+icuBedId)),"^",5)
	set icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	set icuBedTPId=$p($g(^PAWARD(+icuBedId,"BED",+$p(icuBedId,"||",2))),"^",2)
	set icuMonBed=$p($g(^PAC("BEDTP",+icuBedTPId)),"^",5)
	set icuBedSub=$p(icuBedId,"||",2)
	set BedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
	if BedCode="" set BedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
	set Ward=$P($g(^PAWARD(+bedId)),"^",2)
	set WardBed=Ward_" "_BedCode
	set deptId=+icuArrange.ICUAPatDeptDr
	set Dept=$p($g(^CTLOC(deptId)),"^",2)
	
	set papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	set RegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	set MedcareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	
	set PatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	set PatGender=$p($g(^CT("SEX",+$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	set patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	set PatAge=##class(web.DHCClinicCom).CalAge(patBirth,+$h) //年龄
	if patBirth'="" set patBirth=$zd(patBirth,3)	//出生日期
	
	set PatHeight=icuArrange.ICUAPatHeight
	set PatWeight=icuArrange.ICUAPatWeight
	
	set object.RowId=icuaId
	set object.EpisodeID=EpisodeID
	set object.RegNo=RegNo
	set object.MedcareNo=MedcareNo
	set object.PatName=PatName
	set object.PatAge=PatAge
	set object.PatGender=PatGender
	set object.PatWeight=PatWeight
	set object.PatHeight=PatHeight
	set object.Dept=Dept
	set object.Ward=Ward
	set object.Location=Location
	set object.BedCode=BedCode
	set object.WardBed=WardBed
	
	quit object
}

}
