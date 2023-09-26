Import SQL

/// 采集数据处理类
Class CIS.AN.BL.CollectData Extends %RegisteredObject
{

/// 界面数据与采集数据间的有效时间间隔,单位为秒
Parameter ValidDuration = 120;

/// 界面数据与采集数据(血压)间的有效时间间隔,单位为秒
Parameter BPValidDuration = 900;

/// 
/// Creator：      	钟鸣远
/// CreatDate：    	2020-12-25
/// Description： 	处理共享设备采集数据（血气机）
/// Table：        	CIS_AN.CollectedData
/// Input:			deviceId:设备ID, dataPara:数据, extInfo:设备类型
/// Return：       	ResultSet
/// Debug: 			w ##class(CIS.AN.BL.CollectData).InsertShareDev("", "", "")
ClassMethod InsertShareDev(equipId, dataPara, extInfo)
{
    if (dataPara["PatientID")
	{
		quit ..SetBloodSysResult(equipId, dataPara, extInfo)
	}
}

/// 
/// Creator：      	邓体进
/// CreatDate：    	2018-5-27
/// Description： 	处理采集数据
/// Table：        	CIS_AN.CollectedData
/// Input:			deviceId:设备ID, dataPara:数据, extInfo:设备类型
/// Return：       	ResultSet
/// Debug: 			w ##class(CIS.AN.BL.CollectData).AddData("", "", "")
ClassMethod AddData(equipId, dataPara, extInfo)
{

	set devClass=$piece(extInfo,".",1)
	if (dataPara["PatientID")
	{
		
		quit ..SetBloodSysResult(equipId, dataPara, extInfo)
	}
	// 有创血压，异常有创血压去除：不满足 有创收缩压>平均动脉压>有创舒张压 则不存入
	set ASys=0,AMean=0,ADia=0,T=0
	set ASysChannelNo="A_SYS",ADiaChannelNo="A_DIA",AMeanChannelNo="A_MEAN",TempNo="T"
	set ABPDate="",ABPTime=""
	
	q:dataPara="" "null"
	s dataPara=..AddNBPDataStr(equipId, dataPara)      // ======此句为修改的代码===========
	// 循环解析数据
	set len=$length(dataPara,"^")
	set result="",date="",time=""
	for i=1:1:len
	{
		set dataStr=$P(dataPara,"^",i)
		quit:dataStr=""
		set channelNo=$P(dataStr,"#",1)
		set date=$P(dataStr,"#",2)
		set time=$P(dataStr,"#",3)
		set value=$P(dataStr,"#",5)
		
		if (channelNo=ASysChannelNo)
		{
			set ASys=value
			set ABPDate=date,ABPTime=time
			continue
		}
		if (channelNo=ADiaChannelNo)
		{
			set ADia=value 
			continue
		}
		if (channelNo=AMeanChannelNo)
		{
			set AMean=value 
			continue
		}
		if (channelNo=TempNo)
		{
			set T=(+value)/100 
			continue
		}
		
		do AddCollectData
	}
	
	if (AMean>ADia)&&(AMean<ASys)
	{
		set date=ABPDate,time=ABPTime
		
		set channelNo=ASysChannelNo
		set value=ASys
		do AddCollectData
		
		set channelNo=ADiaChannelNo
		set value=ADia
		do AddCollectData
		
		set channelNo=AMeanChannelNo
		set value=AMean
		do AddCollectData
	}
	if (T>0)
	{
		set channelNo=TempNo
		set value=T
		do AddCollectData	
	}
	
	if result="" set result="2 未插入任何数据"
	quit result
	
AddCollectData
	if $$ExistChannelNo(channelNo)
	{
		set res=..AddDeviceData(equipId,channelNo,date,time,value)
	}
	else
	{
		set res="does not exist"
	}
		
	if result="" set result="0 "_" "_channelNo_":"_res
	else  set result=result_","_channelNo_":"_res
	quit
	
ExistChannelNo(channelNo)
	set count=0
	&sql(select count(rowId) into:count from CT_AN.VitalSign where ChannelNo=:channelNo)
	quit count
}

/// Creator：      	邓体进
/// CreatDate：    	2018-5-27
/// Description： 	添加单条采集数据
/// Table：        	CIS_AN.CollectedData
/// Input:			deviceId:设备ID, channelNo:通道号, date:日期, time:时间, value:值
/// Return：       	ResultSet
/// Debug: 			w ##class(CIS.AN.BL.CollectData).AddDeviceData("", "", "", "", "")
ClassMethod AddDeviceData(equipId, channelNo, date, time, value)
{
	quit:'##class(CF.AN.DeptEquip).%ExistsId(equipId) "deviceId isn't exist"
	
	set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	set time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
	
	set rowId=$$ExistCollectedData(date,time,channelNo)
	if rowId="" {
		set obj=##class(CIS.AN.CollectedData).%New()
		set obj.ChannelNo=channelNo
		set obj.CollectDate=date
		set obj.CollectTime=time
		set obj.CreateDate=+$h
		set obj.CreateTime=$p($h,",",2)
		set obj.DataValue=value
		set obj.Equip=##class(CF.AN.DeptEquip).%OpenId(equipId)
	}
	else  {
		set obj=##class(CIS.AN.CollectedData).%OpenId(rowId)
		set obj.DataValue=value
	}
	
	set ret=obj.%Save()
	do obj.%Close()
	quit obj.%Id()
	
ExistCollectedData(date,time,channelNo)
	set rowId=""
	&sql(select rowId into:rowId from CIS_AN.CollectedData
	where Equip=:deviceId and ChannelNo=:channelNo and CollectDate=:date and CollectTime=:time)
	quit rowId
}

/// Creator：      	邓体进
/// CreatDate：    	2018-5-27
/// Description： 	同步数据
/// Table：        	CIS_AN.CollectedData，CIS_AN.AnaData
/// Input:			recordSheetId:表单ID, equipId:设备ID, startDate, startTime, endDate, endTime
/// Return：       	ResultSet
/// Debug: 			w ##class(HCAN.BLL.CollectData).SyncData("", "", "", "", "")
ClassMethod SyncData(recordSheetId, equipId, ByRef timeList)
{
	set modCode="AnaestRecord"
	
	set rowId="",code="",date="",time="",value=""
	set vitalSigns=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindVitalSign")
	
	do GetParaItemId(recordSheetId,"Respiration")
	set respParaItemId=paraItemId
	do GetParaItemAttr(paraItemId)
	set respSuspend=suspendCollect
	do GetParaItemId(recordSheetId,"ControlResp")
	set controlRespParaItemId=paraItemId
	do GetParaItemAttr(paraItemId)
	set ctrlRespSuspend=suspendCollect
	do GetParaItemId(recordSheetId,"NSBP")
	set nsbpParaItemId=paraItemId
	do GetParaItemAttr(paraItemId)
	set nsbpSuspend=suspendCollect
	do GetParaItemId(recordSheetId,"NDBP")
	set ndbpParaItemId=paraItemId
	do GetParaItemAttr(paraItemId)
	set ndbpSuspend=suspendCollect
	do GetParaItemId(recordSheetId,"ASBP")
	set asbpParaItemId=paraItemId
	do GetParaItemAttr(paraItemId)
	set asbpSuspend=suspendCollect
	do GetParaItemId(recordSheetId,"ADBP")
	set adbpParaItemId=paraItemId
	do GetParaItemAttr(paraItemId)
	set adbpSuspend=suspendCollect
	b //ccq3
	for i=1:1:(vitalSigns.Size)
	{
		set vitalSign=vitalSigns.GetAt(i)
		quit:vitalSign=""
		
		set code = vitalSign.GetValue("Code")
		set syncInterval = vitalSign.GetValue("SyncInterval")
		
		set:syncInterval="" syncInterval = 1
		set channelNo = $ZCVT(vitalSign.GetValue("ChannelNo"),"U")
		do GetParaItemId(recordSheetId,code)
		
		if (paraItemId'="")
		{
			do GetParaItemAttr(paraItemId)
			do GetMinMaxValue(dataItemId)
			do SyncItem(paraItemId,dataItemId,channelNo,syncInterval,maxValue,minValue)
		}
	}
    
	quit "over"
	
SyncItem(paraItemId,dataItemId,channelNo,syncInterval,maxValue,minValue)
	set date="",count=-1
	set lastDate="",lastTime="",nextDate="",nextTime=""
	for
	{
		set date=$o(timeList(date))
		quit:date=""
		
		set time=""
		for
		{
			set time=$o(timeList(date,time))
			quit:time=""
			
			set count = count+1
			continue:(count#syncInterval)'=0 //间隔执行同步
			
			write channelNo,"  sync at ",date, ",", time, " count:", count, " syncInterval:",syncInterval
			set isExist = ""
			if controlRespParaItemId=paraItemId
			{
				set isExist = $$ExistData(respParaItemId,date,time)
			}
			elseif respParaItemId=paraItemId
			{
				set isExist = $$ExistData(respParaItemId,date,time)
			}
			elseif (nsbpParaItemId=paraItemId)||(ndbpParaItemId=paraItemId)
			{
				set isExist = $$ExistData(asbpParaItemId,date,time)
			}
			elseif (asbpParaItemId=paraItemId)||(adbpParaItemId=paraItemId)
			{
				set isExist = $$ExistData(nsbpParaItemId,date,time)
			}
			
			continue:isExist'="" //互斥的项目存在数据则不同步
			
			set value=""
			if autoGenerate="Y"
			{
				set value = defaultValue //取自动生成的默认数据值
			}
			elseif suspendCollect'="Y"
			{
				set value = ..GetProximateValue(equipId,channelNo,date,time) //取采集数据值
			}
			
			if (value'="")
			{
				write " value:",value
				if (channelNo="N_SYS")||(channelNo="N_DIA") // 采集有有创数据时不同步无创
				{
					set ABP = ..GetProximateValue(equipId,"A_SYS",date,time)
					continue:(ABP'="")&&(+ABP>40)&&(asbpSuspend'="Y")&&(asbpParaItemId'="")
				}
				/*if (channelNo="RR") // 采集有机控呼吸时不同步自主呼吸
				{
					b ////////=====
					set awRR = ..GetProximateValue(equipId,"AWRR",date,time)
					continue:awRR'=""
				}*/
				
				if (maxValue'="")&&(value>maxValue) set value=maxValue
				if (minValue'="")&&(value<minValue) set value=minValue
				
				if value<0 set value=0
				
				do GetLastDateTime(syncInterval\2)
				do GetNextDateTime(syncInterval\2)
				if (channelNo="RR")
				{
					set breathModeLinkedItem=..SetBreathMode(recordSheetId,date,time)
					set otherParaItemId=$p(breathModeLinkedItem,"^",1)
					set otherDataItemId=$p(breathModeLinkedItem,"^",2)
					if (otherParaItemId'="")&&(otherDataItemId'="")
					{
						set paraItemId=otherParaItemId
						set dataItemId=otherDataItemId
					}
				}
				set res=..AddRecordData(paraItemId,dataItemId, date, time, value, lastDate, lastTime, nextDate, nextTime)
				//write "res:",res
			}
			
			write !
		}
	
	}
	
	quit
	
GetLastDateTime(interval)
	set lastDate=date,lastTime=time
	set timecount=0
	
	while(timecount<interval)
	{
		set lastTime=$o(timeList(lastDate,lastTime),-1)
		set:lastTime="" lastDate=lastDate-1, lastTime=$o(timeList(lastDate,""),-1)
		set timecount=timecount+1
	}
	
	quit
	
GetNextDateTime(interval)
	set nextDate=date,nextTime=time
	set timecount=0
	
	while(timecount<interval)
	{
		set nextTime=$o(timeList(nextDate,nextTime))
		set:nextTime="" nextDate=nextDate+1, nextTime=$o(timeList(nextDate,""))
		set timecount=timecount+1
	}
	
	quit
	
GetParaItemAttr(paraItemId)
	set suspendCollect="",autoGenerate="",defaultValue=""
	&sql(SELECT SuspendCollect,AutoGenerate,DefaultValue into :suspendCollect,:autoGenerate,:defaultValue FROM CIS_AN.ParaItemAttr 
		WHERE ParaItem=:paraItemId)
	quit
	
GetParaItemId(recordSheetId,code)
	set paraItemId="",categoryItemId="",dataItemId=""
	&sql(SELECT RowId,CategoryItem,CategoryItem->DataItem into :paraItemId,:categoryItemId,:dataItemId FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit
	
GetMinMaxValue(dataItemId)
	set maxValue="",minValue=""
	&sql(SELECT MaxValue,MinValue into :maxValue,:minValue FROM CT_AN.VitalSign
		WHERE DataItem=:dataItemId)
	quit

ExistData(iParaItemId,date,time)
    set rowId=""
	&sql(select top 1 RowId into :rowId from CIS_AN.AnaData
		where ParaItem=:iParaItemId
		and StartDate=:date and StartTime=:time 
		and EditFlag="N")
	quit rowId
}

/// 无创血压测量间隔过长导致界面无法正常绘制血压图线 st
ClassMethod GetValue(dataPara As %String, itemName As %String) As %String
{
	s itemValue=""
	s itemNum=$L(dataPara,"^")
	f i=1:1:itemNum q:itemValue'=""  d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s chNo=$P(itemStr,"#",1)
	.i chNo=itemName s itemValue=$P(itemStr,"#",5) s i=itemNum	
	q itemValue
}

ClassMethod GetCombStr(itemName As %String, itemValue As %String, date As %String, time As %String) As %String
{
	s fStr="###V#####"
	s $p(fStr,"#",1)=itemName ;Name
	s $p(fStr,"#",2)=$zd(date,3) ;Date
	s $p(fStr,"#",3)=$zt(time) ;Time
	s $p(fStr,"#",5)=itemValue ;Value
	q fStr
}

ClassMethod AddNBPDataStr(equipId, dataPara)
{
	s dataDate=$P($p(dataPara,"^",1),"#",2)
	s dataTime=$P($p(dataPara,"^",1),"#",3)
	q:(dataDate=""||dataTime="") dataPara
	s dataDate=##class(web.DHCClinicCom).ConvertToDateH(dataDate)
	s dataTime=##class(web.DHCClinicCom).ConvertToTimeH(dataTime)
	s sys=..GetValue(dataPara,"N_SYS")
	s dia=..GetValue(dataPara,"N_DIA")
	s mean=..GetValue(dataPara,"N_MEAN")
	i ((sys'="")&&(dia'="")&&(mean'="")) d
	.s tmp=$$AddToCache(sys,dia,mean)
	e  d
	.s NBPStr=$$GetFromCache(dataPara)
	.s dataPara=dataPara_"^"_NBPStr
	q dataPara
	
AddToCache(sys,dia,mean)
	s ^tmpANNBP("NBP",equipId,"DateTime")=dataDate_","_dataTime
	s ^tmpANNBP("NBP",equipId,"NBPs")=sys
	s ^tmpANNBP("NBP",equipId,"NBPd")=dia
	s ^tmpANNBP("NBP",equipId,"NBPm")=mean
	q 0
GetFromCache(dataPara)
	s oldDateTime=$g(^tmpANNBP("NBP",equipId,"DateTime"))
	s NBPStr=""
	i oldDateTime'="" d
	.s secOldDateTime=$p(oldDateTime,",",1)*24*3600+$p(oldDateTime,",",2)
	.s curDateTime=$p($h,",",1)*24*3600+$p($h,",",2)
	.i (curDateTime-secOldDateTime)<(5*60) d
	..s sys=^tmpANNBP("NBP",equipId,"NBPs")
	..s dia=^tmpANNBP("NBP",equipId,"NBPd")
	..s mean=^tmpANNBP("NBP",equipId,"NBPm")
	..s NBPStr=..GetCombStr("N_SYS",sys,dataDate,dataTime)_"^"_..GetCombStr("N_DIA",dia,dataDate,dataTime)_"^"_..GetCombStr("N_MEAN",mean,dataDate,dataTime)
	..
	.b ;1
	q NBPStr
}

/// 无创血压测量间隔过长导致界面无法正常绘制血压图线 end 
/// Creator：      	邓体进
/// CreatDate：    	2018-5-27
/// Description： 	同步数据
/// Table：        	CIS_AN.CollectedData，CIS_AN.AnaData
/// Input:			paraItemId:表单项目ID, categoryItemId:数据分类项目ID,startDate, startTime, endDate, endTime
/// Return：       	
/// Debug: 			w ##class(HCAN.BLL.CollectData).AddRecordData(2,21,"2018-5-4","12:00",70)
ClassMethod AddRecordData(paraItemId, dataItemId, date, time, value, lastDate = "", lastTime = "", nextDate = "", nextTime = "")
{
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	
	set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	set time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
	
	//set rowId=$$GetRowId(paraItemId, date, time)
	set rowId=..GetExistedDataId(paraItemId, date, time,lastDate,lastTime,nextDate,nextTime)
	if (rowId'=""){
		/// 已有数据则不处理对应的采集数据
	}
	else {
		set obj=##class(CIS.AN.AnaData).%New()
		set obj.ParaItem=##class(CIS.AN.ParaItem).%OpenId(paraItemId)
		set obj.StartDate=date
		set obj.StartTime=time
		set obj.EndDate=date
		set obj.EndTime=time
		set obj.CreateDate=+$h
		set obj.CreateTime=$p($h,",",2)
		set obj.DataValue=value
		set obj.EditFlag="N"
		set obj.Source="I"
		set:dataItemId'="" obj.DataItem=##class(CT.AN.DataItem).%OpenId(dataItemId)
		
		set ret=obj.%Save()
		do obj.%Close()
		set rowId=obj.%Id()
	}
	quit rowId
	
	
GetRowId(paraItemId, date, time)
    set rowId=""
	&sql(select top 1 RowId into :rowId from CIS_AN.AnaData
		where ParaItem=:paraItemId 
		and StartDate=:date and StartTime=:time)
	quit rowId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-12-12
/// Description： 	获取已存在的数据ID
/// Table：        	CIS_AN.AnaData
/// Input:			paraItemId:显示项目ID，date：目标日期，time:目标时间，
/// 				lastDate:时间区间上限日期, lastTime:时间区间上限时间, 
/// 					nextDate:时间区间下限日期, nextTime:时间区间下限时间
/// Return：       	String：数据值，空字符串表示未获取到
/// Debug: 			w ##class(CIS.AN.BL.CollectData).GetExistedDataId(86,,,,,,)
ClassMethod GetExistedDataId(paraItemId, date, time, lastDate, lastTime, nextDate, nextTime) As %String
{
	set rowId=""
	
	set rowId=$o(^CIS.AN.AnaDataI("IItemTime",paraItemId,date,time,""))
	if (rowId="")
	{
		if (lastTime'="")
		{
			set foundDate=date
			set foundTime=$o(^CIS.AN.AnaDataI("IItemTime",paraItemId,date,time),-1)
			if foundTime="" set foundDate=date-1, foundTime=$o(^CIS.AN.AnaDataI("ItemTime",paraItemId,foundDate,""),-1)
			if (foundTime'="") && (##class(CIS.AN.COM.DateTime).CompareDateTime(foundDate,foundTime,lastDate,lastTime)>-1)
			{
			 	set rowId=$o(^CIS.AN.AnaDataI("IItemTime",paraItemId,foundDate,foundTime,""),-1)
			}
		}
		
		if (nextTime'="")
		{
			set foundDate=date
			set foundTime=$o(^CIS.AN.AnaDataI("IItemTime",paraItemId,date,time))
			if foundTime="" set foundDate=date+1, foundTime=$o(^CIS.AN.AnaDataI("ItemTime",paraItemId,foundDate,""))
			if (foundTime'="") && (##class(CIS.AN.COM.DateTime).CompareDateTime(nextDate,nextTime,foundDate,foundTime)>-1)
			{
				set rowId=$o(^CIS.AN.AnaDataI("IItemTime",paraItemId,foundDate,foundTime,""),-1)
			}
		}
	}
	
	quit rowId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-9-20
/// Description： 	获取采集数据中最接近某一时间的数据值
/// Table：        	CIS_AN.CollectedData
/// Input:			equipId:设备ID, channelNo:表单项目ID, date, time
/// Return：       	String：数据值，空字符串表示未获取到
/// Debug: 			w ##class(CIS.AN.BL.CollectData).GetProximateValue(86,"HR","2018-10-29","10:20")
ClassMethod GetProximateValue(equipId, channelNo, date, time) As %String
{
	set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	set time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
	
	set validDuration = ..#ValidDuration
	set BPChannelNoList = $lb("N_SYS","N_DIA","A_SYS","A_DIA")
	if $LISTFIND(BPChannelNoList,channelNo) set validDuration= ..#BPValidDuration
	
	set channelNo=$ZCVT(channelNo,"U")
	
	/// 如果此时间点有数据，先直接取此时间点的采集数据
	if $d(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,date,time))
	{
		set rowId = $o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,date,time,""),-1)
		set dataValue = $lg(^CIS.AN.CollectedDataD(rowId),3)
		quit dataValue
	}
	
	/// 如果此时间点没有确定值，则取前后最近的一次采集数据
	set previousDate = date,isPreviousTimeValid=0,previousDuration=0
	set previousTime = $o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,previousDate,time), -1)
	
	if (previousTime="")&&(time<validDuration)
	{
		set previousDate = date-1
		set previousTime = $o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,previousDate,""), -1)
		
		set previousDuration = 86400 - previousTime + time
	}
	else
	{
		set previousDuration = time-previousTime
	}
	if (previousTime'="")&&(previousDuration<=validDuration) set isPreviousTimeValid=1
	
	set nextDate = date,isNextTimeValid=0,nextDuration=0
	set nextTime = $o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,nextDate,time))
	if (nextTime="")&&(time>(86400 - validDuration))
	{
		set nextDate = date + 1
		set nextTime = $o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,nextDate,""))
		set nextDuration = 86400 - time + nextTime
	}
	else
	{
		set nextDuration = nextTime-time
	}
	if (nextTime'="")&& (nextDuration <= validDuration) {
		if 'isPreviousTimeValid set isNextTimeValid=1
		if isPreviousTimeValid && (nextDuration <= previousDuration) set isNextTimeValid=1,isPreviousTimeValid=0
	}
	
	set rowId=""
	if isPreviousTimeValid set rowId=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,previousDate,previousTime,""),-1)
	if isNextTimeValid set rowId=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,nextDate,nextTime,""),-1)
	
	set dataValue=""
	if rowId
	{
		set dataValue=$lg(^CIS.AN.CollectedDataD(rowId),3)
	}
	
	quit dataValue
}

/// 获取采集到有数据的生命体征项目
ClassMethod GetCollectedVitalsign(equipId, startDate, startTime, endDate, endTime) As %DynamicObject
{
	set vitalSigns=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindVitalSign")
	set result={}
	for i=1:1:(vitalSigns.Size)
	{
		set vitalSign=vitalSigns.GetAt(i)
		quit:vitalSign=""
		
		set code = vitalSign.GetValue("Code")
		set channelNo = $ZCVT(vitalSign.GetValue("ChannelNo"),"U")
		
		do result.%Set(code,0)
		if (..HasAvailableValue(equipId,channelNo,startDate,startTime,endDate,endTime)) do result.%Set(code,1)
	}
	write result.%ToJSON()
	quit result
}

/// 是否有可用数据
ClassMethod HasAvailableValue(equipId, channelNo, startDate, startTime, endDate, endTime) As %Boolean
{
	set date=startDate,time=startTime
	set time=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,date,time))
	if time=""
	{
		set date=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,date))
		set:date'="" time=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId," "_channelNo,date,time))
	}
	
	set result=0
	if (time'="")&&((date<endDate)||((date=endDate)&&(time<endTime))) set result=1
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-23
/// Description： 	查询最新的采集数据
/// Table：        	
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CollectData","FindLatestCollectData")
Query FindLatestCollectData(opsId As %String) As %Query(ROWSPEC = "ChannelNo,ItemDesc,Color,UomDesc,DataValue,Threshold,Warning") [ SqlProc ]
{
}

ClassMethod FindLatestCollectDataExecute(ByRef qHandle As %Binary, opsId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set statusCode=""
	set:$ISOBJECT(operSchedule.Status) statusCode=operSchedule.Status.Code
	set moduleCode = $s(statusCode="PACUIn":"PACURecord",1:"AnaestRecord")
	set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew(opsId,moduleCode,"")
	
	set equipRecords = ##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.DataQueries:FindEquipRecord",recordSheetId)
	
	kill collectDataList
	
	set date=+$h,time=+$p($h,",",2)
	for i=1:1:equipRecords.Size
	{
		set equipRecord = equipRecords.GetAt(i)
		quit:equipRecord=""
		
		set EquipId = equipRecord.GetValue("Equip")
		
		do GetLatestData(EquipId)
	}
	
	set vitalSigns=##class(CIS.AN.COM.Query).ToObjects("CIS.AN.BL.CodeQueries:FindVitalSign")
	
	set NBPD="",NBPS="",ABPS="",ABPD=""
	set NBPSWarning="",NBPDWarning="",ABPSWarning="",ABPDWarning=""
	for i=1:1:(vitalSigns.Size)
	{
		set vitalSign=vitalSigns.GetAt(i)
		quit:vitalSign=""
		
		set code = vitalSign.GetValue("Code")
		set syncInterval = vitalSign.GetValue("SyncInterval")
		set channelNo = vitalSign.GetValue("ChannelNo")
		continue:channelNo=""
		 b
		set itemDesc = vitalSign.GetValue("Code")
		set color = vitalSign.GetValue("Color")
		set uomDesc = vitalSign.GetValue("Uom")
		set min = vitalSign.GetValue("WarningMin")
		set max = vitalSign.GetValue("WarningMax")
		set threshold = min_"~"_max
		set dataValue = $g(collectDataList(channelNo))
		if (channelNo="RR")&&((dataValue="--")||(dataValue=""))
		{
			set dataValue = $g(collectDataList("AWRR"))
		}
		
		set warning = "N"
		if (dataValue<min)||(dataValue>max) set warning = "Y"
	
		if channelNo="N_SYS" set NBPS=dataValue,NBPSWarning=warning
		else  if channelNo="N_DIA" set NBPD=dataValue,NBPDWarning=warning
		else  if channelNo="A_SYS" set ABPS=dataValue,ABPSWarning=warning
		else  if channelNo="A_DIA" set ABPD=dataValue,ABPDWarning=warning
		else  if dataValue do OutputRow
		
		if ((channelNo="N_SYS")||(channelNo="N_DIA")) && ((NBPS>0)&&(NBPD>0))
		{
			set warning=NBPSWarning
			set warning=$s(NBPDWarning="Y":"Y",1:warning)
			set channelNo="NBP"
			set itemDesc="NBP"
			set dataValue=NBPS_"/"_NBPD
			do OutputRow
		}
		
		if ((channelNo="A_SYS")||(channelNo="A_DIA")) && ((ABPS>0)&&(ABPD>0))
		{
			set warning=ABPSWarning
			set warning=$s(ABPDWarning="Y":"Y",1:warning)
			set channelNo="ABP"
			set itemDesc="ABP"
			set dataValue=ABPS_"/"_ABPD
			do OutputRow
		}
	}
	
	s qHandle=$lb(0,repid,0)
	q $$$OK	

GetLatestData(equipId)
	set latestDate="",latestTime=""
	set Channelno=""
	for
	{
		set Channelno=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId,Channelno))
		quit:Channelno=""
		set latestDate=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId,Channelno,""),-1)
		continue:latestDate=""
		set latestTime=$o(^CIS.AN.CollectedDataI("IChannelDT",equipId,Channelno,latestDate,""),-1)
		set rowId=""
		set currentTime=$p($h,",",2)
		for
		{
			set rowId = $o(^CIS.AN.CollectedDataI("IChannelDT",equipId,Channelno,latestDate,rowId))
			quit:rowId=""
			set ChannelNo = $lg(^CIS.AN.CollectedDataD(rowId),2)
			set DataValue = $lg(^CIS.AN.CollectedDataD(rowId),3)
			if (currentTime-latestTime)>300 set DataValue="--"
			set collectDataList(ChannelNo)=DataValue
		}
			
	}
	
	quit

OutputRow
	s Data=$lb(channelNo,itemDesc,color,uomDesc,dataValue,threshold,warning)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindLatestCollectDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLatestCollectDataExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindLatestCollectDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLatestCollectDataExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// 通过添加事件控制呼吸之间转换，默认自主呼吸，添加辅助呼吸后，插入辅助呼吸，
/// 添加机械通气后，插入机控呼吸
/// input：表单ID RecordSheet，插入数据时间点
/// output：呼吸模式
/// w ##Class(CIS.AN.BL.CollectData).SetBreathMode(829,"2019-3-3","15:00")
ClassMethod SetBreathMode(RecordSheet As %String, date As %String, time As %String) As %String
{
	set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	set time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
	set categoryItem=""
	do GetParaItemId(RecordSheet,"Respiration")  // 默认自主呼吸
	//自主呼吸 事件
	set respEventDate="",respEventTime=""
	set respEventReult=..GetEventTimeByRecordSheet(RecordSheet,"RespEvent","N")
	set respEventDate=$p(respEventReult,"^",3)
	set respEventTime=$p(respEventReult,"^",4)
	set categoryItem1=$p(respEventReult,"^",2)
	//机械通气 事件
	set machEventDate="",machEventTime=""
	set machEventReult=..GetEventTimeByRecordSheet(RecordSheet,"MechanicalVentilation","N")
	set machEventDate=$p(machEventReult,"^",3)
	set machEventTime=$p(machEventReult,"^",4)
	set categoryItem2=$p(machEventReult,"^",2)
	
	//辅助通气 事件
	set AsstEventDate="",AsstEventTime=""
	set AsstEventReult=..GetEventTimeByRecordSheet(RecordSheet,"AssEvent","N")
	set AsstEventDate=$p(AsstEventReult,"^",3)
	set AsstEventTime=$p(AsstEventReult,"^",4)
	set categoryItem3=$p(AsstEventReult,"^",2)

	if ((machEventDate=respEventDate)&&(+machEventTime>(+respEventTime)))!((machEventDate>respEventDate))
	{
		if (respEventDate'="")
		{
			q:(categoryItem1="")&&(categoryItem2="")&&(categoryItem3="") ""_"^"_""
			//b //w 123
			if (date>machEventDate)!((date=machEventDate)&&(machEventTime<time))
			{
				do GetParaItemId(RecordSheet,"ControlResp")
			}
		}
	}
	if ((respEventDate="")&&(machEventDate'=""))
	{
	
		q:(categoryItem1="")&&(categoryItem2="")&&(categoryItem3="") ""_"^"_""
		if (date>machEventDate)!((date=machEventDate)&&(machEventTime<time))
		{
			do GetParaItemId(RecordSheet,"ControlResp")
		}
	}
	if (respEventDate'="")&&((machEventDate=respEventDate)&&(+machEventTime<(+respEventTime)))!((machEventDate<respEventDate))
	{
	 
		do GetParaItemId(RecordSheet,"Respiration")
	}
	else
	{
		q:(categoryItem1="")&&(categoryItem2="")&&(categoryItem3="") ""_"^"_""
		if (respEventDate'="")
		{
			if (date>machEventDate)!((date=machEventDate)&&(machEventTime<time))
			{
				do GetParaItemId(RecordSheet,"ControlResp")
			}
		}
	}
	//if (AsstEventDate'="")&&(respEventTime<AsstEventTime) do GetParaItemId(RecordSheet,"AssBreath")
	quit paraItemId_"^"_dataItemId

GetParaItemId(recordSheetId,code)
	set paraItemId="",categoryItemId="",dataItemId=""
	&sql(SELECT RowId,CategoryItem,(CategoryItem->DataItem) into :paraItemId,:categoryItemId,:dataItemId FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit
}

/// 获取麻醉记录单事件有效数据的时间
/// input: 表单ID RecordSheet,有效状态 EditFlag, 事件ID DataItem
/// output: StartDate，StartTime
/// table: CIS_AN.AnaData
/// w ##Class(CIS.AN.BL.CollectData).GetEventTimeByRecordSheet(747,94,"N")
ClassMethod GetEventTimeByRecordSheet(recordSheet As %String, dataItemCode As %String, EditFlag As %String = "N") As %String
{
	set stDate="",stTime="",paraItem="",categoryItem=""
	
	&sql(SELECT top 1 Count(RowId), ParaItem,DataItem,StartDate, StartTime into:count, :paraItem,:categoryItem, :stDate,:stTime FROM CIS_AN.AnaData 
				WHERE ParaItem->RecordSheet=:recordSheet
		  		AND DataItem->Code=:dataItemCode
		  		AND EditFlag=:EditFlag ORDER BY EndDate DESC,EndTime DESC )
 	set:count=0 stDate="",stTime="",paraItem="",categoryItem=""
	quit paraItem_"^"_categoryItem_"^"_stDate_"^"_stTime
}

ClassMethod StartTask(collectEquipId)
{
	quit:'##class(CF.AN.EquipCollection).%ExistsId(collectEquipId) "deviceId isn't exist"
	/*&sql(select RowId into:collectEquipId from CF_AN.EquipCollection
	where Equip=:equipId)
	*/
	s equip=##class(CF.AN.EquipCollection).%OpenId(collectEquipId)
	s IP=equip.TcpipAddress
	s port=equip.ComPort
	s devType=equip.Program
	s equipId=equip.Equip.%Id()
	s res=##class(web.DHCCLDevTool).ExcuteDevTask("A", equipId, "", IP , port, 60 , devType, "","StartEq")
}

//  w ##class(CIS.AN.BL.CollectData).CheckAlertData("A","8)

ClassMethod CheckAlertData(source, recordSheetID) As %String
{
	    set RowId="",rest=0
        f  set RowId=$o(^CIS.AN.EquipRecordI("Sheet",recordSheetID,RowId)) q:RowId=""  d
        .b  ;3
		.set EquipId=$lg(^CIS.AN.EquipRecordD(RowId),2)
		.set EndDate=$lg(^CIS.AN.EquipRecordD(RowId),5)
		.quit:EndDate'=""
		.set IsHaveNewAlertData=$g(^AlarmDate("New",source,EquipId))
		.b
		.set:IsHaveNewAlertData=1 rest=IsHaveNewAlertData
		.set ^AlarmDate("New",source,EquipId)=0
        q rest
}

//  w ##class(CIS.AN.BL.CollectData).CheckICUAlertData("I","8")

ClassMethod CheckICUAlertData(source, icuaId) As %String
{
	    set RowId="",rest=0
	    s arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	    s bedId=arrange.ICUABedDr
	    d arrange.%Close()
        f  set RowId=$o(^User.DHCICUBedDeviceD(RowId))  q:RowId=""  d
        .quit:$lg(^User.DHCICUBedDeviceD(RowId),2)'=bedId
		.set EquipId=$lg(^User.DHCICUBedDeviceD(RowId),3)
		.set IsHaveNewAlertData=$g(^AlarmDate("New",source,EquipId))
		.set:IsHaveNewAlertData=1 rest=IsHaveNewAlertData
		.set ^AlarmDate("New",source,EquipId)=0
        q rest
}

Query FindAlertData(recordSheetID As %String) As %Query(ROWSPEC = "Value:%String,DateTime:%String,DeviceType:%String,AlertType:%String")
{
}

ClassMethod FindAlertDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CollectData","FindAlertData","7")

ClassMethod FindAlertDataExecute(ByRef qHandle As %Binary, recordSheetID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	If $g(ind)="" s ind=1
	   s RowId=""
        f  s RowId=$o(^CIS.AN.EquipRecordI("Sheet",recordSheetID,RowId)) q:RowId=""  d
		   .s EquipId=$lg(^CIS.AN.EquipRecordD(RowId),2)
		   .s EndDate=$lg(^CIS.AN.EquipRecordD(RowId),5)
		   .q:EndDate'=""
		   .s Time=""
		   .f  s Time=$o(^AlarmDate("A",EquipId,Time),-1) q:Time=""  d 
		   ..s AlertType=$p(^AlarmDate("A",EquipId,Time),"$",5)
		   ..s $p(^AlarmDate("A",EquipId,Time),"$",5)="已读"
		   ..s dataPara=$p(^AlarmDate("A",EquipId,Time),"$",2)
	       ..s DateTime=$zd($p(^AlarmDate("A",EquipId,Time),"$",3),3)_" "_$zt($p(^AlarmDate("A",EquipId,Time),"$",4))
	       ..;s DeviceType=EquipId
	       ..s DeviceTypeId=$o(^CF.AN.EquipCollectionI("IEquip",EquipId,""))
	       ..s DeviceType=$li(^CF.AN.EquipCollectionD(DeviceTypeId),2)
	       ..s len=$L(dataPara,"^")
	       ..s i=0,Value=""
	       ..f  s i=i+1 q:i>len  d
	       ...s dataStr=$P(dataPara,"^",i)
		   ...quit:dataStr=""
		   ...b
		   ...s Item=$P(dataStr,"#",1)
		   ...s ValueSingle=$P(dataStr,"#",5)
		   ...s:Value'="" Value=Value_" ; "_Item_":"_ValueSingle
		   ...s:Value="" Value=Item_":"_ValueSingle
		   ..Do OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow9
	set Data=$lb(Value,DateTime,DeviceType,AlertType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindAlertDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query FindICUAlertData(icuaId As %String) As %Query(ROWSPEC = "AlarmValue:%String,AlarmDateTime:%String,DeviceType:%String,AlertType:%String")
{
}

ClassMethod FindICUAlertDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("CIS.AN.BL.CollectData","FindICUAlertData","8")

ClassMethod FindICUAlertDataExecute(ByRef qHandle As %Binary, icuaId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	If $g(ind)="" s ind=1
	   s RowId=""
       set RowId="",rest=0
	    s arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	    s bedId=arrange.ICUABedDr
	    d arrange.%Close()
        f  s RowId=$o(^User.DHCICUBedDeviceD(RowId))  q:RowId=""  d
           .quit:$lg(^User.DHCICUBedDeviceD(RowId),2)'=bedId
		   .s EquipId=$lg(^User.DHCICUBedDeviceD(RowId),3)
		   .s DeviceType=$li(^User.DHCICUDeviceD(EquipId),4)
	       .s Time=""
		   .f  s Time=$o(^AlarmDate("I",EquipId,Time),-1) q:Time=""  d 
		   ..s AlertType=$p(^AlarmDate("I",EquipId,Time),"$",5)
		   ..s $p(^AlarmDate("I",EquipId,Time),"$",5)="已读"
		   ..s dataPara=$p(^AlarmDate("I",EquipId,Time),"$",2)
	       ..s AlarmDateTime=$zd($p(^AlarmDate("I",EquipId,Time),"$",3),3)_" "_$zt($p(^AlarmDate("I",EquipId,Time),"$",4))
	       ..;s DeviceType=EquipId
	       ..s len=$L(dataPara,"^")
	       ..s i=0,AlarmValue=""
	       ..f  s i=i+1 q:i>len  d
	       ...s dataStr=$P(dataPara,"^",i)
		   ...quit:dataStr=""
		   ...s Item=$P(dataStr,"#",1)
		   ...s ValueSingle=$P(dataStr,"#",5)
		   ...s:AlarmValue'="" AlarmValue=AlarmValue_" ; "_Item_":"_ValueSingle
	       ...s:AlarmValue="" AlarmValue=Item_":"_ValueSingle
		   ..Do OutputRow9
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow9
	set Data=$lb(AlarmValue,AlarmDateTime,DeviceType,AlertType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindICUAlertDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SaveANAlarmDate(taskId, dataPara, source)
{
	set NowDate=$p($h,",",1),NowTime=$p($h,",",2)
	set ^AlarmDate("New",source,taskId)=1
	set ^AlarmDate(source,taskId,NowTime)=taskId_"$"_dataPara_"$"_NowDate_"$"_NowTime_"$未读"
	q ""
}

ClassMethod SaveICUAlarmDate(taskId, dataPara, source)
{
	set NowDate=$p($h,",",1),NowTime=$p($h,",",2)
	set ^AlarmDate("New",source,taskId)=1
	set ^AlarmDate(source,taskId,NowTime)=taskId_"$"_dataPara_"$"_NowDate_"$"_NowTime_"$未读"
	q ""
}

ClassMethod StartAllTask()
{
	s equipId=""
	for
	{
		s equipId=$O(^CF.AN.EquipCollectionD(equipId))
		q:equipId=""
		w ..StartTask(equipId)
	}
	q "Over"
}

/// 血气机入库代码
/// w ##Class(CIS.AN.BL.CollectData).SetBloodSysResult("",^tmpzmy("test"),"")
ClassMethod SetBloodSysResult(taskId, dataPara, extInfo)
{
	set leb=$l(dataPara,"^")
	for i=1:1:leb
	{
		set tmpData=$piece(dataPara,"^",i)
		set code=$piece(tmpData,"#",1)
		set value=$piece(tmpData,"#",5)
		set dataArr(code)=value
		
	}
	set patientId=dataArr("PatientID")
	quit:patientId=""
	set opsId=..GetOpsIdByPatientId(patientId)
	quit:opsId="" "invalid PatientID"_patientId
	set dateTime=dataArr("DateTime")
	set dateTime=$replace(dateTime,"~"," ")
	set ret=..InsertAnaData(opsId,"",dateTime,"BloodGasAnalysis",.dataArr)
	break
	quit 0_"_"_ret
}

/// w ##Class(CIS.AN.BL.CollectData).GetOpsIdByPatientId("0000000092")
ClassMethod GetOpsIdByPatientId(MedicareNo As %String) As %String
{
	set opsId=""
	&sql(SELECT RowId into:opsId FROM CIS_AN.OperSchedule WHERE MedicareNo=:MedicareNo and Status=4  order by RowId desc)
	quit opsId
}

/// 插入麻醉单数据
/// 
ClassMethod InsertAnaData(opsId As %String, userId As %String, dateTime As %String, eventCode As %String, array As %String) As %String
{
	set eventCodeId=""
	&sql(SELECT RowId into:eventCodeId FROM CT_AN.DataItem WHERE Code=:eventCode)
	quit:eventCodeId="" "为找到血气分析项目项目:"_eventCode
	tstart
	set moduleCode = "AnaestRecord"
	set recordSheetId=##class(CIS.AN.COM.DataService).GetRecordSheetIdByModCode(opsId,moduleCode,"")
	set paraItemId=$$GetParaItemId(recordSheetId,"OperationEvent")
	set categoryItemId=$$GetCategoryItemId(eventCode)
	//b  ;3
	if (recordSheetId="")||(paraItemId="") || ((categoryItemId=""))
	{
		trollback
		quit "E^数据错误"		
	}
	
	set dataSource="M",rowId=""	
	if (categoryItemId="")
	{
		trollback
		quit "E^数据插入失败！"
	}
	
	set date=$p(dateTime," ",1)
	set time=$p(dateTime," ",2)
	
	set result="",saveResult="",userDefinedItemId=""
	kill data
	set data("ClassName")="CIS.AN.AnaData"
	set data("RowId")=rowId
	set data("ParaItem")=paraItemId
	set data("CategoryItem")=categoryItemId
	set data("UserDefinedItem")=userDefinedItemId
	set data("EditFlag")="N"
	set data("StartDate")=date
	set data("StartTime")=time
	set data("EndDate")=date
	set data("EndTime")=time
	set data("DataItem")=eventCodeId
	set data("CreateUserID")=userId
	set data("Source")="M"
	set data("FromData")=""
	set date=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
	set time=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
    &sql(SELECT RowId into :rowId FROM CIS_AN.ANAData 
    WHERE ParaItem=:paraItemId AND StartDate=:date AND StartTime=:time)
    
    if (rowId="")
    {
	    set saveResult=##class(CIS.AN.COM.DataService).SaveData(.data)
    }
    else
    {
	    quit "0 "_rowId
    }

	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		b
		quit saveResult		
	}
	set anaDataRowId=$piece(saveResult,"^",2)
	
	set res=""
	set detailIndex=0
	
	for
	{
		
		set detailIndex=$order(array(detailIndex))
		quit:(detailIndex="")
		set desc=detailIndex //123
		set detailData("AnaData")=anaDataRowId
		set detailData("ClassName")="CIS.AN.EventData"
		set tmprowId="",unit=""
		b:detailIndex="Na"
		&sql(SELECT RowId,Unit into:tmprowId,:unit FROM CT_AN.EventOptions WHERE DataItem=:eventCodeId and Description=:detailIndex)
		b:detailIndex="Na"   ;5
		continue:tmprowId=""
		//b ;6
		set detailData("DataUnit")=unit
		set detailData("DataValue")=array(detailIndex)
		set detailData("Description")=desc
		set detailData("EventDetailItem")=tmprowId
		set detailData("Unit")=unit
		
		set saveResult=""
           ////b   ;7
		if tmprowId'="" do  set saveResult=##class(DHCCL.BLL.DataService).SaveData(.detailData)
		if res="" set res=saveResult
		else  set res=res_" "_saveResult
		//quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S") 
	{
		trollback
		quit saveResult
	}
	
	tcommit
	quit res
	
GetParaItemId(recordSheetId,code)
	set result=""
	&sql(SELECT RowId into :result FROM CIS_AN.ParaItem 
		WHERE RecordSheet=:recordSheetId and Code=:code)
	quit result
	
GetCategoryItemId(code)
	set result=""
	&sql(SELECT RowId into :result FROM CT_AN.DataCateItem
		WHERE DataItem->Code=:code)
	quit result
}

}
