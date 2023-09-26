Import SQLUser

/// 微量泵micro pump入库、自动填写数据代码
Class web.DHCICUMicroPump Extends web.DHCClinicCom
{

// 从UI调用生成数据

ClassMethod GenPumpDataFromUI(icuaId, icuoId, date, time)
{
	// w ##class(web.DHCICUMicroPump).GenPumpDataFromUI(icuaId, icuoId, date, time)
	SET $ZTRAP="GenPumpDataFromUIError"
	s ^tmpicudebug("GenPumpDataFromUI",icuaId)=icuaId_","_icuoId_","_date_","_time
	s recordItemId="",paraItemId=""
	s obj=##class(User.DHCICUOrder).%OpenId(icuoId)
	i obj.ICUOComOrdDr'=""  s recordItemId=obj.ICUOComOrdDr.%Id()
	
	i obj.ICUOICUPIDr s paraItemId=obj.ICUOICUPIDr.%Id()
	q:obj="" "obj=null"
	d obj.%Close()
	q:recordItemId="" "recordItemId=null"
	s recordObj=##Class(User.DHCICUCRecordItem).%OpenId(recordItemId)
	
	q:recordObj="" "recordObj=null"
	s code=recordObj.ICUCRICode
	d recordObj.%Close()
	q:code'="PumpNo" "recordObj=null"
	/*
	s obj=##class(User.DHCICUOrder).%OpenId(icuoId)
	s obj.ICUOQty=..GetEquipId(icuaId,obj.ICUONote)
	d obj.%Save()
	*/
	d GenData(icuaId,recordItemId,paraItemId,date,time)
	q "Over"
	
GenData(icuaId,recordItemId,paraItemId,date,time)
	s oneDay=3600*24
	s fromDateTime=(date*oneDay)+((time\3600)*3600)+3600
	s toDateTime=(+$h*oneDay)+(($p($h,",",2)\3600)*3600)
	
	f dateTime=fromDateTime:3600:toDateTime d
	.s startDate=dateTime\oneDay
	.s startTime=dateTime#oneDay
	.
	.;s res=..GenPumpData(icuaId,recordItemId,paraItemId,startDate,startTime) ;按累计量计算
	.s speedCode="DetailSpeedPump"          // 泵速
	.s speedRecordItemId=##class(web.DHCICUCRecordItem).GetId(speedCode)
	.
	.s res=..GenDataByDateTime(icuaId,speedRecordItemId,paraItemId,startDate,startTime)
	.w "GenData",speedRecordItemId," ",paraItemId," ",$zd(startDate)," ",$zt(startTime)," ",res,!
	.
	q
GenPumpDataFromUIError
	d ..Log("GenPumpDataFromUIError",$zerror)
	q
}

// 后台调用[每小时生成数据]

ClassMethod LoadPumpPatData(icuaId, date, time)
{
	// w ##class(web.DHCICUMicroPump).LoadPumpPatData(icuaId,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s insertDate=date,insertTime=time-3600
	i insertTime<0 s insertDate=date-1,insertTime=23*3600
	NEW %ROWCOUNT,%ROWID
    s SQLCODE=""
    SET name="LastName,FirstName",state="##"
    s pumpNoCode="PumpNo",pumpSpeed="DetailSpeedPump"
    s recordItemId=##class(web.DHCICUCRecordItem).GetId(pumpNoCode)
	s pumpSpeedId=##class(web.DHCICUCRecordItem).GetId(pumpSpeed)
	
	q:recordItemId=""
	&sql(DECLARE PumpCursor CURSOR FOR 
        select ICUPI_RowId into:paraItemId from dhc_icu_paraitem 
		where ICUPI_Parref->ICUP_ICUA_Dr=:icuaId AND 
		ICUPI_ComOrd_Dr=:recordItemId)
    &sql(OPEN PumpCursor)
    FOR { &sql(FETCH PumpCursor)
        QUIT:SQLCODE
        i paraItemId'="" d
        .w "GenDataByDateTime:",icuaId," ",pumpSpeedId," ",paraItemId," ",date," ",time,!
        .
        .s res=..GenDataByDateTime(icuaId,pumpSpeedId,paraItemId,date,time)
   }
   &sql(CLOSE PumpCursor)
   q ""
}

// 按日期生成泵数据(只调试时使用)

ClassMethod LoadPumpPatDataByDate(icuaId, date)
{
	// w ##class(web.DHCICUMicroPump).LoadPumpPatDataByDate(icuaId, date)
	i date="" s date=+$h
	i '$ISVALIDNUM(date) s date=..ConvertToDateH(date)
	f i=0:1:23  d
	.
	.
	.;q:((i#2)=0)
	.d ..LoadPumpPatData(icuaId,date,i*3600)
	.w "time:"," ",$zt(i*3600),!
	q "Over"
}

ClassMethod GenCollectData(equipId, icuaId, pumpSeq = 4, date = "")
{
	// w ##class(web.DHCICUMicroPump).GenCollectData(equipId,icuaId)
	s date="" s date=+$h
	i '$ISVALIDNUM(date) s date=..ConvertToDateH(date)
	f i=0:1:23  d
	.w "Index:",i,!
	.d InsertOneHour(i)
	.

	q "Over"
InsertOneHour(hour)
	s time=hour*3600
	s bed="bed01"
	i ((hour#2)=1) d
	.s speed=1
	.d InsertByDateTime(equipId, icuaId,date,time+60,bed,speed,pumpSeq)
	.d InsertByDateTime(equipId, icuaId,date,time+1800,bed,speed+1,pumpSeq)
	.d InsertByDateTime(equipId, icuaId,date,time+3600-60,bed,speed,pumpSeq)
	e  d
	.s speed=1
	.d InsertByDateTime(equipId, icuaId,date,time+60,bed,speed,pumpSeq)
	.d InsertByDateTime(equipId, icuaId,date,time+3600-60,bed,speed,pumpSeq)
	q
InsertByDateTime(equipId, icuaId,date,time,bed,speed,pumpSeq)
	s dataPara=$$GenOnePumpData(date,time,bed,speed,pumpSeq)
	;b // InsertByDateTime(equipId, icuaId,date,time,bed,speed,pumpSeq)

	w ##class(web.DHCICUMicroPump).InsertToDb("I",equipId, icuaId, "", dataPara, "")
	q
GenOnePumpData(date,time,bed,speed,pumpSeq)
	s dateTime=..ToDateTimeStr(date,time)
	s str=..GetCollectStr("DateTime",dateTime)_"^"
	s str=str_..GetCollectStr("Bed",bed)_"^"
	s str=str_..GetCollectStr("PumpSpeed",speed)_"^"
	s str=str_..GetCollectStr("PumpSeq",pumpSeq)
	q str
}

// 按指定时间向后找数据生成数据

// speedRecordItemId: 速度RecordItemId

// paraItemId: 泵编号ParaItemId

ClassMethod GenDataByDateTime(icuaId, speedRecordItemId, paraItemId, startDate, startTime, curSpeed = "", curDate = "", curTime = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GenDataByDateTime(equipId, icuaId, speedRecordItemId,paraItemId, curDate, curTime, curSpeed)
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	d ..Log("GenDataByDateTime",icuaId_","_speedRecordItemId_","_paraItemId_","_startDate_","_startTime_","_curSpeed_","_curDate_","_curTime_","_scope)
	s genDataType="Post"
	i genDataType="Pre" q ..GenPreDataByDateTime(icuaId, speedRecordItemId, paraItemId, startDate, startTime, curSpeed, curDate, curTime, scope)
	e  i genDataType="Post" q ..GenPostDataByDateTime(icuaId, speedRecordItemId, paraItemId, startDate, startTime, curSpeed, curDate, curTime,scope)
	q "Config Error!!!!!!!!!!!!!!!!"
}

// 计算某小时的入量

// startDate/startTime: 要开始处理的时间点

// speedRecordItemId: 泵速ID

// paraItemId: 泵编号ID

ClassMethod GenPostDataByDateTime(icuaId, speedRecordItemId, paraItemId, startDate, startTime, curSpeed = "", curDate = "", curTime = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GenPostDataByDateTime(icuaId, speedRecordItemId,paraItemId, curDate, curTime, curSpeed)
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	d ..Log("GenPostDataByDateTime",icuaId_","_speedRecordItemId_","_paraItemId_","_startDate_","_startTime_","_curSpeed_","_curDate_","_curTime_","_scope)
	
	i curDate="" s curDate=startDate,curTime=startTime
	s curDateTime=..ToDateTime(curDate,curTime)
	s fromDateTime=curDateTime
	s oneDaySec=24*3600
	s manualData=..GetManualPreData(icuaId,startDate,startTime,paraItemId)
	
	q:manualData="" "没有找到泵号"
	s pumpNo=$p(manualData,"^",1)
	s equipId=..GetEquipId(icuaId,pumpNo)
	q:equipId="" "没有找到equipId"
	s searchIcuaId=icuaId
	i equipId'["-" s searchIcuaId=""
	
	i curSpeed="" d
	.s rootData=..PreDataInScope(equipId, searchIcuaId, speedRecordItemId, curDate, curTime,"",scope/2)
	.
	.i rootData="" s rootData=..NextDataInCurPeriod(equipId, searchIcuaId, speedRecordItemId, curDate, curTime)
	.
	.s curSpeed=$p(rootData,"^",1)
	.s rootDateTime=$p(rootData,"^",4)
	.s rootIntDateTime=((curDateTime\scope)*scope)
	.
	.i rootIntDateTime<rootDateTime s fromDateTime=rootDateTime
	.e  s fromDateTime=rootIntDateTime
	.
	b ////
	q:curSpeed="" ""
	s nextSpeedData=..NextDataInCurPeriod(equipId, searchIcuaId, speedRecordItemId, curDate, curTime, curSpeed,scope)
	w "nextSpeedData:",nextSpeedData,!
	
	i nextSpeedData=""  d
	.d LastData
	.s nextSpeedData=""
	
	q:nextSpeedData="" ""
	
	s nextSpeed=$p(nextSpeedData,"^",1)
	s nextDate=$p(nextSpeedData,"^",2)
	s nextTime=$p(nextSpeedData,"^",3)
	s nextDateTime=$p(nextSpeedData,"^",4)
	
	
	s startDateTime=..ToDateTime(startDate,startTime)
	
	
	s quit=0
	s interval=$zabs(nextDateTime-startDateTime)
	i (interval>=scope) d
	.s nextDateTime=startDateTime+scope
	.s quit=1
	
	d DoCalculate(fromDateTime,nextDateTime)
	q:quit "" // 只处理一个周期的数据
	
	q ..GenPostDataByDateTime(icuaId, speedRecordItemId, paraItemId,startDate,startTime, nextSpeed,nextDate, nextTime , scope)
	
DoCalculate(fromDateTime,nextDateTime)
	s time=nextDateTime-fromDateTime
	q:time<=0 "error"
	q:curSpeed=0 "curSpeed is null"
	s vol=$fn((time*curSpeed)/3600,"",2)
	
	w "Vol:",vol," ",time," FromDateTime:",..DateTimeToStr(fromDateTime)," EndDateTime:",..DateTimeToStr(nextDateTime),!
	// 插入计算结果
	s logStr="StartDateTime:"_..DateTimeToStr(fromDateTime)_" EndDateTime:"_..DateTimeToStr(nextDateTime)_" Speed:"_curSpeed_" Vol:"_vol
	d ..Log("InsertAllPumpData",logStr)
	//d ..DeleteAllPumpData(icuaId,paraItemId,fromDateTime,nextDateTime)
	s fromDate=fromDateTime\oneDaySec
	s fromTime=fromDateTime#oneDaySec
	q ..InsertAllPumpData(equipId,icuaId, fromDate, fromTime, paraItemId, curSpeed, time,pumpNo)
LastData
	; 说明这小时都是一样的速度，如果下小时有速度则按当前时间计算来计算
	; 下一周期的第一个数据
	
	s toIntDateTime=((curDateTime\scope)*scope)+scope ;下一整小时
	s toIntDate=toIntDateTime\oneDaySec
	s toIntTime=toIntDateTime#oneDaySec
	s toData=..NextDataInScope(equipId, searchIcuaId, speedRecordItemId, toIntDate, toIntTime, "",scope/2)
	;s toData=..GetNextSpeedByDateTime(equipId, searchIcuaId, speedRecordItemId,toIntDateTime,"",scope/2)
	i toData="" d
	.
	.;s toData=..GetPreSpeedByDateTime(equipId, searchIcuaId, speedRecordItemId,toIntDateTime,"",scope/2)
	.s toData=..PreDataInScope(equipId, searchIcuaId, speedRecordItemId, toIntDate, toIntTime, "",scope)
	.
	
	q:(toData="")
	
	s toDateTime=$p(toData,"^",4)
	
	i toIntDateTime<toDateTime s toDateTime=toIntDateTime
	
	w "这个周期没有速度变化",!
	d DoCalculate(fromDateTime,toDateTime)
	q
}

ClassMethod GenPreDataByDateTime(icuaId, speedRecordItemId, paraItemId, startDate, startTime, curSpeed = "", curDate = "", curTime = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GenPreDataByDateTime(equipId, icuaId, speedRecordItemId,paraItemId, curDate, curTime, curSpeed)
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	d ..Log("GenPreDataByDateTime",icuaId_","_speedRecordItemId_","_paraItemId_","_startDate_","_startTime_","_curSpeed_","_curDate_","_curTime_","_scope)
	
	i curDate="" s curDate=startDate,curTime=startTime
	s curDateTime=..ToDateTime(curDate,curTime)
	s fromDateTime=curDateTime
	s oneDaySec=24*3600
	s manualData=..GetManualPreData(icuaId,startDate,startTime,paraItemId)
	q:manualData="" "没有找到泵号"
	s pumpNo=$p(manualData,"^",1)
	s equipId=..GetEquipId(icuaId,pumpNo)
	q:equipId="" "没有找到equipId"
	s searchIcuaId=icuaId
	i equipId'["-" s searchIcuaId=""
	
	// 第一次递归找到
	i curSpeed="" d
	.; 向后查找 
	.s rootData=..NextDataInScope(equipId, icuaId, speedRecordItemId, curDate, curTime,"",scope/2)
	.; 向后查找未找到时向前查找
	.//i rootData="" s rootData=..PreDataInCurPeriod(equipId, icuaId, speedRecordItemId, curDate, curTime,"",scope/2)
	.
	.s curSpeed=$p(rootData,"^",1)
	.s rootDateTime=$p(rootData,"^",4)
	.s rootIntDateTime=((curDateTime\scope)*scope)
	.s fromDateTime=rootIntDateTime
	.//i rootIntDateTime>rootDateTime s fromDateTime=rootDateTime 
	.//e  s fromDateTime=rootIntDateTime 
	.
	
	s preSpeedData=..PreDataInCurPeriod(equipId, searchIcuaId, speedRecordItemId, curDate, curTime, curSpeed,scope,startDate, startTime,"Pre")
	w "preSpeedData:",preSpeedData,!
	
	i preSpeedData=""  d
	.
	.d LastData
	.s preSpeedData=""
	
	q:preSpeedData="" ""
	
	s preSpeed=$p(preSpeedData,"^",1)
	s preDate=$p(preSpeedData,"^",2)
	s preTime=$p(preSpeedData,"^",3)
	s preDateTime=$p(preSpeedData,"^",4)
	
	
	s startDateTime=..ToDateTime(startDate,startTime)
	
	
	s quit=0
	s interval=$zabs(startDateTime-preDateTime)
	i (interval>=scope) d
	.s preDateTime=startDateTime+scope
	.s quit=1
	
	d DoCalculate(fromDateTime,preDateTime,preSpeed)
	q:quit "" // 只处理一个周期的数据
	
	q ..GenPreDataByDateTime(icuaId, speedRecordItemId, paraItemId,startDate,startTime, preSpeed,preDate, preTime , scope)
	
DoCalculate(fromDateTime,preDateTime,preSpeed)
	
	s time=fromDateTime-preDateTime
	q:time<=0 "error"
	s vol=$fn((time*curSpeed)/3600,"",2)
	
	w "Vol:",vol," ",time," FromDateTime:",..DateTimeToStr(fromDateTime)," preDateTime:",..DateTimeToStr(preDateTime),!
	// 插入计算结果
	s logStr="StartDateTime:"_..DateTimeToStr(fromDateTime)_" EndDateTime:"_..DateTimeToStr(preDateTime)_" Speed:"_curSpeed_" Vol:"_vol
	d ..Log("InsertAllPumpData",logStr)
	
	s toDate=fromDateTime\oneDaySec
	s toTime=fromDateTime#oneDaySec
	
	q ..InsertAllPumpData(equipId,icuaId, toDate, toTime, paraItemId, preSpeed, time,pumpNo)
LastData
	; 说明这小时都是一样的速度，如果下小时有速度则按当前时间计算来计算
	; 下一周期的第一个数据
	
	s toIntDateTime=((curDateTime\scope)*scope) ;上一整小时
	s toIntDate=toIntDateTime\oneDaySec
	s toIntTime=toIntDateTime#oneDaySec
	s fromData=..PreDataInScope(equipId, searchIcuaId, speedRecordItemId, toIntDate, toIntTime, "",scope)
	
	;s toData=..GetNextSpeedByDateTime(equipId, searchIcuaId, speedRecordItemId,toIntDateTime,"",scope/2)
	i fromData="" d
	.
	.;s toData=..GetPreSpeedByDateTime(equipId, searchIcuaId, speedRecordItemId,toIntDateTime,"",scope/2)
	.s fromData=..NextDataInScope(equipId, searchIcuaId, speedRecordItemId, toIntDate, toIntTime, "",scope)
	.
	
	q:(fromData="")
	s nextSpeed=$p(fromData,"^",1)
	s fromDateTime=$p(fromData,"^",4)
	i fromDateTime<toIntDateTime s fromDateTime=toIntDateTime
	w "这个周期没有速度变化",!
	
	d DoCalculate(..ToDateTime(curDate,curTime),fromDateTime,nextSpeed)
	q
}

ClassMethod GetPreSpeedByDateTime(equipId, icuaId, recordItemId, dateTime, value = "", scope = 3600)
{
	s oneDaySec=24*3600
	s id="",num="",startDate="",startTime="",startDatetime=""
	if (value="")
	{
		&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime 
		from DHC_ICU_DeviceData 
		where EquipId=:equipId and 
		((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
		RecordItemId=:recordItemId and 
		(StartDate*:oneDaySec+StartTime)<=:dateTime and 
		(:dateTime-(StartDate*:oneDaySec+StartTime))<:scope
		Order by StartDate*:oneDaySec+StartTime desc
		)
	}
	else{
		&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime 
		from DHC_ICU_DeviceData 
		where EquipId=:equipId and 
		((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
		RecordItemId=:recordItemId and 
		(StartDate*:oneDaySec+StartTime)<=:dateTime and
		(:dateTime-(StartDate*:oneDaySec+StartTime))<:scope and 
		Num<>:value
		Order by StartDate*:oneDaySec+StartTime desc
		)
	}
	
	q:SQLCODE'=0 ""
	w num_" "_$zd(startDate)_" "_$zt(startTime),!
	s startDatetime=..ToDateTime(startDate,startTime)
	q num_"^"_startDate_"^"_startTime_"^"_startDatetime_"^"_id
}

ClassMethod GetPreSpeed(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GetPreSpeed(equipId,icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s dateTime=..ToDateTime(date,time)
	q ..GetPreSpeedByDateTime(equipId, icuaId, recordItemId, dateTime,value, scope)
}

ClassMethod GetNextSpeedByDateTime(equipId, icuaId, recordItemId, dateTime, value = "", scope = 3600)
{
	s oneDaySec=24*3600
	s id="",num="",startDate="",startTime="",startDatetime=""
	if (value="")
	{
		&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime from DHC_ICU_DeviceData 
	where EquipId=:equipId and 
	((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
	RecordItemId=:recordItemId and 
	(StartDate*:oneDaySec+StartTime)>=:dateTime and
	((StartDate*:oneDaySec+StartTime)-:dateTime)<:scope
	Order by StartDate*:oneDaySec+StartTime
	)
	}
	else{
		&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime from DHC_ICU_DeviceData 
	where EquipId=:equipId and
	((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
	RecordItemId=:recordItemId and 
	(StartDate*:oneDaySec+StartTime)>=:dateTime and
	((StartDate*:oneDaySec+StartTime)-:dateTime)<:scope and 
	Num<>:value
	Order by StartDate*:oneDaySec+StartTime
	)
	}
	
	q:SQLCODE'=0 ""
	w num_" "_$zd(startDate)_" "_$zt(startTime),!
	s startDatetime=..ToDateTime(startDate,startTime)
	q num_"^"_startDate_"^"_startTime_"^"_startDatetime_"^"_id
}

ClassMethod GetNextSpeed(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GetNextSpeed(equipId,icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s dateTime=..ToDateTime(date,time)
	q ..GetNextSpeedByDateTime(equipId, icuaId, recordItemId, dateTime,value, scope)
}

/*ClassMethod GetNextSpeedNew(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GetNextSpeed(equipId,icuaId, recordItemId, date, time)
	s oneDaySec=24*3600
	s id="",num="",startDate="",startTime="",startDatetime=""
	s dateTime=(date*oneDaySec)+time
	s fromDateTime=(dateTime\scope)*scope
	s toDateTime=fromDateTime+scope
	s fromDate=fromDateTime\oneDaySec
	s fromTime=fromDateTime#oneDaySec
	s toDate=toDateTime\oneDaySec
	s toTime=toDateTime#oneDaySec
	w ..DateTimeToStr(toDateTime),!
	if (value="")
	{
		&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime from DHC_ICU_DeviceData 
	where EquipId=:equipId and 
	((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
	RecordItemId=:recordItemId and 
	((StartDate=:date) and (StartTime>:time) or (StartDate>:date)) and 
	((StartDate=:date) and (StartTime<=:toTime) or (StartDate<:toDate))  
	Order by StartDate*:oneDaySec+StartTime
	)
	}
	else{
	&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime from DHC_ICU_DeviceData 
	where EquipId=:equipId and 
	((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
	RecordItemId=:recordItemId and 
	((StartDate=:date) and (StartTime>:time) or (StartDate>:date)) and 
	((StartDate=:date) and (StartTime<=:toTime) or (StartDate<:toDate))  and
	Num<>:value
	Order by StartDate*:oneDaySec+StartTime
	)
	}
	
	q:SQLCODE'=0 ""
	w num_" "_$zd(startDate)_" "_$zt(startTime),!
	s startDatetime=..ToDateTime(startDate,startTime)
	q num_"^"_startDate_"^"_startTime_"^"_startDatetime_"^"_id
}*/
ClassMethod DeleteAllPumpData(icuaId, paraItemId, fromDateTime, toDateTime)
{
	// w ##class(web.DHCICUMicroPump).DeleteAllPumpData(icuaId,paraItemId,fromDateTime,toDateTime)
	i '$ISVALIDNUM(fromDateTime) s fromDateTime=..StrToDateTime(fromDateTime)
	i '$ISVALIDNUM(toDateTime) s toDateTime=..StrToDateTime(toDateTime)
	s mainParaItemId=..GetMainParaItemId(icuaId,paraItemId)
	
	w "delete:"," from:",..DateTimeToStr(fromDateTime)," to:",..DateTimeToStr(toDateTime),!
	
	s oneDaySec=24*3600
	&sql(
	update DHC_ICU_Order set ICUO_EditFlag='C' 
	where (ICUO_StartDate*:oneDaySec+ICUO_StartTime)>:fromDateTime and 
	(ICUO_StartDate*:oneDaySec+ICUO_StartTime)<:toDateTime and 
	(ICUO_ICUPI_Dr in (SELECT ICUPI_RowId FROM DHC_ICU_ParaItem 
	WHERE ICUPI_Parref->ICUP_ICUA_Dr=:icuaId AND 
	(ICUPI_ICUPI_Dr=:mainParaItemId or ICUPI_RowId=:mainParaItemId)))
	)
	q SQLCODE
}

ClassMethod InsertAllPumpData(equipId, icuaId, startDate, startTime, paraItemId, speed, time, pumpNo)
{
	// w ##class(web.DHCICUMicroPump).InsertAllPumpData(pumpNo,icuaId, startDate, startTime, paraItemId, speed, time)
	i startDate'=+startDate s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	i startTime'=+startTime s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	d ..Log("InsertAllPumpData",equipId_","_icuaId_","_startDate_","_startTime_","_paraItemId_","_speed_","_time_","_pumpNo)
	s everyHourVolCode="DetailVolumePump"  // 每小时入量
	s speedCode="DetailSpeedPump"          // 泵速
	s concnCode="DetailConcentrationPump"  // 浓度
	s doseCode="DetailDosePump"            // 剂量
	//s paraDisposal="DetailDisposalPump"  // 处置
	s passageCode="DetailPassagePump"      // 输液通路
	s pumpNoCode="PumpNo"                  // 泵编号
	
	s oneDaySec=24*3600
	s startDateTime=(startDate*oneDaySec)+startTime
	s insertDateTime=startDateTime
	s insertDate=insertDateTime\oneDaySec
	s insertTime=+(insertDateTime#oneDaySec)
	
	s vol=$fn((speed*time)/3600,"",2)
	s mainParaItemId=..GetMainParaItemId(icuaId,paraItemId)
	i mainParaItemId="" w "===========ERROR:未找到主项============="
	q:mainParaItemId="" "未找到主项"
	s paraConcn=..GetParaItemId(icuaId,mainParaItemId,concnCode)
	s preData=..GetManualPreData(icuaId,startDate,startTime,paraConcn)
	
	s concnValue=+$p(preData,"^",1)
	s oeoriId=$p(preData,"^",2)
	s prepareVol=+$p(preData,"^",3)
	s totalVol=+$p(preData,"^",4)
	s unitItemStr=..GetUnitIdByOeori(icuaId,oeoriId)
	s speedUnitId=$p(unitItemStr,"^",1)
	s doseUnitId=$p(unitItemStr,"^",2) 
	w "PreData:",concnValue," ",prepareVol," ",totalVol," ",!
	
	; 插入泵号
	// s res=..Insert2ICUOrder(icuaId,recordItemId,insertDate,insertTime,"",equipId,paraItemId,prepareVol,totalVol,oeoriId)
	s res=..InsertPumpData(icuaId,pumpNoCode,insertDate,insertTime,"",pumpNo,mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	; 每小时入量
	
	s res=..InsertPumpData(icuaId,everyHourVolCode,insertDate,insertTime,vol,"",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	w "每小时入量:",res,!
	; 浓度--是手填项
	s res=..InsertPumpData(icuaId,concnCode,insertDate,insertTime,"","",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	; 输液通路
	s paraPassage=..GetParaItemId(icuaId,mainParaItemId,passageCode)
	s passageValue=..GetManualPreData(icuaId,startDate,startTime,paraPassage)
	s passageValue=$p(passageValue,"^",1)
	
	w "输液通路:",passageValue,!
	s res=..InsertPumpData(icuaId,passageCode,insertDate,insertTime,"",passageValue,mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	
	; 泵速
	s res=..InsertPumpData(icuaId,speedCode,insertDate,insertTime,"","",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	
	; 计算剂量
	//s dose=..GetPumpDose(icuaId,oeoriId,vol,concnValue)
	
	
	s res=..InsertPumpData(icuaId,doseCode,insertDate,insertTime,"","",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	s mainValue=..GetMainItem(icuaId,startDate,startTime,mainParaItemId)
	s obj=##Class(User.DHCICUParaItem).%OpenId(mainParaItemId)
	s mainRecordItemId=""
	i obj'="" d
	.i obj.ICUPIComOrdDr'="" s mainRecordItemId=obj.ICUPIComOrdDr.%Id()
	.d obj.%Close()
	.s res=..Insert2ICUOrder(icuaId,mainRecordItemId,insertDate,insertTime,"",mainValue,mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,speed,speedUnitId,doseUnitId)
	q res
}

// 按日期生成微泵数据 [按泵入量生成][只测试或每小时生成数据失败时调用][现在按泵入量生成不用该代码]

ClassMethod GetPumpDataByDate(icuaId, recordItemId, paraItemId, date)
{
	// w ##class(web.DHCICUMicroPump).GetPumpDataByDate(1185,6957,"1191||10015","2015-01-27")
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	f i=0:1:23 d
	.s time=i*3600
	.w "time:",$zt(time),!
	.d ..GenPumpData(icuaId, recordItemId, paraItemId, date, time)
	q "Over"
}

// 按泵入量生成dateTime点间点的泵数据 [按泵入量生成][现在按泵入量生成不用该代码]

ClassMethod GenPumpData(icuaId, recordItemId, paraItemId, date, time)
{
	// w ##class(web.DHCICUMicroPump).GenPumpData(icuaId,recordItemId,paraItemId,date,time)
	// 查找上一个选择的泵号
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s oneDay=3600*24
	s startDateTime=(date*oneDay)+time
	s everyHourVolCode="DetailVolumePump"  // 每小时入量
	s speedCode="DetailSpeedPump"          // 泵速
	s concnCode="DetailConcentrationPump"  // 浓度
	s doseCode="DetailDosePump"        // 剂量
	//s paraDisposal="DetailDisposalPump"    // 处置
	s passageCode="DetailPassagePump"      // 输液通路
	
	s preData=..GetManualPreData(icuaId,date,time,paraItemId)
	s pumpNo=$p(preData,"^",1)
	s oeoriId=$p(preData,"^",2)
	s insertDateTime=startDateTime
	s insertDate=insertDateTime\oneDay
	s insertTime=insertDateTime#oneDay 
	s res=""
	
	i pumpNo'="" d
	.
	.s pumpTotalVolCode="PumpTotalVol"
	.s str=..GetValueOfHour(pumpNo,pumpTotalVolCode,date,time)
	.s vol=$p(str,"^",1)
	.s fromDateTime=$p(str,"^",2)
	.s toDateTime=$p(str,"^",3)
	.w "pumpNo:",pumpNo,"date:",$zd(date)," ",$zt(time)," vol:",vol,!
	.
	.i $ISVALIDNUM(vol) d
	..; 将数据与iucaId关联
	..s ^tmpdebug("LinkDeviceDataWithPat",time)=pumpNo_"^"_fromDateTime_"^"_toDateTime_"^"_icuaId_$zt($p($h,",",2))
	..d ..LinkDeviceDataWithPat(pumpNo,fromDateTime,toDateTime,icuaId)
	..s mainParaItemId=..GetMainParaItemId(icuaId,paraItemId)
	..i mainParaItemId="" w "===========ERROr:未找到主项============="
	..q:mainParaItemId=""
	..s paraConcn=..GetParaItemId(icuaId,mainParaItemId,concnCode)
	..s preData=..GetManualPreData(icuaId,date,time,paraConcn)
	..s concnValue=+$p(preData,"^",1)
	..s prepareVol=+$p(preData,"^",3)
	..s totalVol=+$p(preData,"^",4)
	..s doseUnitId=..GetUnitIdByOeori(icuaId,oeoriId)
	..w "PreData:",concnValue," ",prepareVol," ",totalVol," ",!
	..
	..; 插入泵号
	..s res=..Insert2ICUOrder(icuaId,recordItemId,insertDate,insertTime,"",pumpNo,paraItemId,prepareVol,totalVol,oeoriId)
	..; 每小时入量
	..
	..s res=..InsertPumpData(icuaId,everyHourVolCode,insertDate,insertTime,vol,"",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,vol,doseUnitId)
	..w "每小时入量:",res,!
	..; 浓度--是手填项
	..s res=..InsertPumpData(icuaId,concnCode,insertDate,insertTime,"","",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,vol,doseUnitId)
	..; 输液通路
	..s paraPassage=..GetParaItemId(icuaId,mainParaItemId,passageCode)
	..s passageValue=..GetManualPreData(icuaId,date,time,paraPassage)
	..s passageValue=$p(passageValue,"^",1)
	..
	..w "输液通路:",passageValue,!
	..s res=..InsertPumpData(icuaId,passageCode,insertDate,insertTime,"",passageValue,mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,vol,doseUnitId)
	..
	..; 泵速
	..s res=..InsertPumpData(icuaId,speedCode,insertDate,insertTime,"","",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,vol,doseUnitId)
	..
	..; 计算剂量
	..//s dose=..GetPumpDose(icuaId,oeoriId,vol,concnValue)
	..
	..
	..s res=..InsertPumpData(icuaId,doseCode,insertDate,insertTime,"","",mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,vol,doseUnitId)
	..s mainValue=..GetMainItem(icuaId,date,time,mainParaItemId)
	..s obj=##Class(User.DHCICUParaItem).%OpenId(mainParaItemId)
	..s mainRecordItemId=""
	..i obj'="" d
	...i obj.ICUPIComOrdDr'="" s mainRecordItemId=obj.ICUPIComOrdDr.%Id()
	...d obj.%Close()
	...s res=..Insert2ICUOrder(icuaId,mainRecordItemId,insertDate,insertTime,"",mainValue,mainParaItemId,prepareVol,totalVol,oeoriId,vol,concnValue,vol,doseUnitId)
	q res
}

// 生成泵速模拟数据

// equipId:设备号

// date: 日期

ClassMethod GenPumpSpeedData(equipId, icuaId = "", date = "", recordItemId = 5381)
{
	// w ##class(web.DHCICUMicroPump).GenPumpSpeedData(1)
	i date="" s date=+$h
	f i=0:1:23 d
	.s startTime=i*3600
	.d GenHourData(startTime)
	q "Over"
GenHourData(startTime)
	f j=1:1:59 d
	.s vol=1*(j\10+1)
	.s time=startTime+(j*60)
	.d ..AddDeviceData(equipId, icuaId, recordItemId, vol, date, time)
	.//d ..AddDeviceData(equipId,recordItemId,vol,date,time)
	.w "Insert:",$zd(date)," ",$zt(time)," Vol:",vol,!
	q ""
}

// 泵入库

// source: 

// equipId: 设备ID , icuaId:DHC_ICU_Arrange ID， dataPara:采集参数,status: 状态

// 

ClassMethod InsertToDb(source, equipId, icuaId, extInfo, dataPara, status)
{
	// w ##class(web.DHCICUMicroPump).InsertToDb(source, equipId, icuaId, extInfo, dataPara, status)
	// 查找设备类型ID
	s devTypeId=$$GetDevTypeId(equipId) //GetDevTypeId(equipId,extInfo)
	q:((+devTypeId)<=0) "未知采集设备类型"
	s dateTime=##class(web.DHCICUCom).GetValue(dataPara,"DateTime")
	
	i dateTime="" q "DateTime is Null"
	s actDate=##class(web.DHCClinicCom).ConvertToDateH($p(dateTime,"~",1))
	i dateTime["~" d
	.s actTime=##class(web.DHCClinicCom).ConvertToTimeH($p(dateTime,"~",2))
	.;s actTime=$zth($p(dateTime,"~",2))
	
	// icuaId不为空时equipId为[equipId]-[pumpSeq]
	i icuaId'="" d
	.s PumpSeq=##class(web.DHCICUCom).GetValue(dataPara,"PumpSeq")
	.i PumpSeq'="" s equipId=equipId_"-"_PumpSeq
	
	// 循环解析数据
	s itemNum=$L(dataPara,"^")
	s resStr=""
	f i=1:1:itemNum d
	.s itemStr=$P(dataPara,"^",i)
	.q:itemStr=""
	.s itemName=$P(itemStr,"#",1)
	.s date=$P(itemStr,"#",2)
	.s time=$P(itemStr,"#",3)
	.;s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	.;s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	.s value=$P(itemStr,"#",5)
	.s ancctiSub=$o(^DHCANC("CType",0,"ChannelNo",itemName,devTypeId,""))
	.q:ancctiSub=""
	.s recordItemId=$p(^DHCANC("CType",devTypeId,"I",ancctiSub),"^",1)
	.
	.q:recordItemId=""
	.s res=$$AddPumData(equipId,icuaId,recordItemId,actDate,actTime,value)
	.i resStr="" s resStr="0 "_icuaId_" "_itemName_":"_res
	.e  s resStr=resStr_","_itemName_":"_res
	
	q resStr
	
GetDevTypeId(equipId)
	// 如RELAY设备，则获取真实的设备ID
	s devTypeId=$p($g(^DHCICUBedEquip(equipId)),"^",5)
	q:devTypeId="" "Invalid EquipId"
	s devCode=$p(^DHCANC("CType",devTypeId),"^",1)
	i ($$ALPHAUP^SSUTIL4(devCode)="RELAY")  d
	.s devCode=$p($p($g(^DHCICUBedEquip(equipId)),"^",3),"|",3)
	.s TypeId=##class(web.DHCANCCollectType).GetDevIdByCode(devCode,source)
		
	// 如果是自动识别或模拟设备，则查找设备类型Id
	i (((devCode="AutoCheckDev")||(devCode="TestDev"))) d 
	.;查找设备类型Id
	.s devTypeId=##class(web.DHCANCCollectType).GetDevIdByCode(extInfo,source)
	q devTypeId
	
AddPumData(equipId,icuaId,recordItemId,date,time,value)
	s code=$p($g(^DHCICUC("RecordItem",recordItemId)),"^",1)
	
	i code["Speed" d
	.s value=+value
	.i value>0 d
	..s res=..AddPumpSpeed(equipId, icuaId,recordItemId, date, time, value)
	.e  d
	..s res="value is :"_value
	e  d
	.s res=..AddDeviceData(equipId,icuaId, recordItemId, value, date, time)
	q res
}

ClassMethod GetMainItem(icuaId, date, time, mainParaItemId)
{
	// w ##class(web.DHCICUMicroPump).GenMainItem(icuaId,date,time,mainRecordItemId)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s dataFormat="",formatField="",mainRecordItemId=""
	&sql(SELECT ICUPI_ComOrd_Dr into:mainRecordItemId FROM DHC_ICU_ParaItem WHERE ICUPI_Parref->ICUP_ICUA_Dr=1185 AND ICUPI_RowId=:mainParaItemId)
	
	q:mainRecordItemId="" ""
	&sql(select ICUCRI_DataFormat,ICUCRI_FormatField into:dataFormat,:formatField from DHC_ICUC_RecordItem 
	where ICUCRI_RowId=:mainRecordItemId)
	s value=dataFormat
	s count=$L(formatField,";")
	f j=0:1:count d
    .s fStr=..Replace("{N}","N",j)
    .s subRecordItemCode=$p(formatField,";",(j+1))
    .s recordItemId=""
    .s iValue="",txtValue=""
    .&sql(SELECT ICUCRI_RowId into:recordItemId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code=:subRecordItemCode)
    .
    .i recordItemId'="" d
    ..s paraItemId=..GetSubParaItemId(icuaId,recordItemId,mainParaItemId)
    ..
    ..s value=..GetICUOrderValue(icuaId,recordItemId,date,time,paraItemId)
    ..
    ..s oneValue=""
    ..i iValue'="" s oneValue=iValue
    ..e  i txtValue'="" s oneValue=txtValue
    ..s value=..Replace(value,fStr,oneValue)
    q value
}

ClassMethod GetSubParaItemId(icuaId, recordItemId, mainParaItemId)
{
	s paraItemId=""
	&sql(SELECT ICUPI_RowId into:paraItemId FROM DHC_ICU_ParaItem WHERE ICUPI_Parref->ICUP_ICUA_Dr=:icuaId AND ICUPI_ComOrd_Dr=:recordItemId AND ICUPI_ICUPI_Dr=:mainParaItemId)
	q paraItemId
}

ClassMethod GetICUOrderValue(icuaId, recordItemId, date, time, paraItemId)
{
	s num="",txt="",concn="",speed="",oeoriId=""
	&sql(SELECT top 1 ICUO_Qty,ICUO_Note,ICUO_Concentration,ICUO_Speed ,ICUO_Oeore_Dr
	into:num,:txt,:concn,:speed,:oeoriId
	FROM DHC_ICU_Order 
	WHERE ICUO_ICUA_Dr=:icuaId AND ICUO_ComOrd_Dr=:recordItemId AND ICUO_StartDate=:date AND 
	ICUO_StartTime=:time and ICUO_ICUPI_Dr=:paraItemId and 
	(ICUO_EditFlag="N" or ICUO_EditFlag="E"))
	s obj=##Class(User.DHCICUCRecordItem).%OpenId(recordItemId)
	q:obj="" ""
	s field=obj.ICUCRIDataField
	d obj.%Close()
	
	s value=""
	i field="Qty" s value=num
	e  i field="Note"  s value=text
	e  i field="Concentration"  s value=concn
	e  i field="DoseSpeed"  d
	.//s value=speed*concn
	.s value=..GetPumpDose(icuaId, oeoriId, speed, concn)
	i field'="Note" s value=$fn(value,"",2)
	q value
}

ClassMethod Insert2ICUOrder(icuaId, recordItemId, date, time, num, text, paraItemId = "", prepareVol = "", totalVol = "", oeoriId = "", vol = "", concn = "", speed = "", speedUnitId = "", doseUnitId = "", editFlag = "N", source = "I") As %String
{
	// w ##class(web.DHCICUMicroPump).Insert2ICUOrder(icuaId, recordItemId, date, time,num,text)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s count=0
	&sql(select count(*) into:count from DHC_ICU_Order where ICUO_ICUA_Dr=:icuaId and ICUO_ComOrd_Dr=:recordItemId and 
	ICUO_StartDate=:date and ICUO_StartTime=:time and (ICUO_ICUPI_Dr IS NULL or ICUO_ICUPI_Dr=:paraItemId))
	s SQLCODE=""
	
	s updateDate=+$h
	s updateTime=$p($h,",",2)
	w "count:",count,!
	
	if count>0{
	&sql(update DHC_ICU_Order set 
	ICUO_Note=:text, ICUO_Qty=:num, ICUO_Concentration=:concn, ICUO_Speed=:speed, ICUO_Volume=:vol,
	ICUO_UpdateDate=:updateDate, ICUO_UpdateTime=:updateTime, ICUO_EditFlag=:editFlag,
	ICUO_PreparedVolume=:prepareVol,ICUO_TotalQty=:totalVol,ICUO_SpeedUnit_Dr=:speedUnitId,
	ICUO_Oeore_Dr=:oeoriId,ICUO_Uom_Dr=:doseUnitId
	 where ICUO_ICUA_Dr=:icuaId and ICUO_ComOrd_Dr=:recordItemId and 
	ICUO_StartDate=:date and ICUO_StartTime=:time and (ICUO_ICUPI_Dr IS NULL or ICUO_ICUPI_Dr=:paraItemId))
	w "update",!
	
	}
	else {
	&sql(insert into DHC_ICU_Order(ICUO_ICUA_Dr, ICUO_ComOrd_Dr, ICUO_Oeore_Dr, ICUO_User_Dr, ICUO_StartDate, 
	ICUO_StartTime,  ICUO_EndDate, ICUO_EndTime, ICUO_Note, ICUO_Qty, ICUO_Concentration, ICUO_Speed, ICUO_Volume,
	ICUO_UpdateDate, ICUO_UpdateTime, ICUO_EditFlag, ICUO_Source, ICUO_ICUPI_Dr,ICUO_PreparedVolume,ICUO_TotalQty,
	ICUO_SpeedUnit_Dr,ICUO_Uom_Dr)
	values(:icuaId,:recordItemId,:oeoriId,:userId,:date,:time,:date,:time,:text,:num,:concn,:speed,:vol,
	:updateDate,:updateTime,:editFlag,:source,:paraItemId,:prepareVol,:totalVol,:speedUnitId,:doseUnitId)
	)
	w "Insert",!
	
	}
	i SQLCODE=0 s rowId=$g(%ROWID)
	e  s rowId=SQLCODE b
	q rowId
}

ClassMethod InsertPumpData(icuaId, code, insertDate, insertTime, num, text, mainParaItemId, prepareVol = "", totalVol = "", oeoriId = "", vol = "", concn = "", speed = "", speedUnitId = "", doseUnitId = "")
{
	s recordItemId=..GetRecordItemId(code)
	s paraItemId=..GetParaItemId(icuaId,mainParaItemId,code)
	w "InsertPumpData:   ",code,"  ",recordItemId,"  ",paraItemId,!
	s res=..Insert2ICUOrder(icuaId,recordItemId,insertDate,insertTime,num,text,paraItemId,prepareVol,totalVol,oeoriId,vol, concn, speed,speedUnitId,doseUnitId)
	q res
}

ClassMethod GetRecordItemId(code)
{
	s recordItemId=""
	&sql(SELECT ICUCRI_RowId into:recordItemId FROM DHC_ICUC_RecordItem WHERE ICUCRI_Code=:code)
	i recordItemId="" w "recordItem Code is Invalid",!
	q recordItemId
}

// 往前查询最新的人工录入的数据

// icuaId,date:日期,time:时间,searchId:recordItemId

ClassMethod GetManualPreData(icuaId, date, time, searchId)
{
	// w ##class(web.DHCICUMicroPump).GetManualPreData(icuaId,date,time,searchId)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s oneDay=3600*24
	s startDateTime=(date*oneDay)+time
	s recordItemId="",oeoriId=""
	
	&sql(
	SELECT top 1 ICUO_RowId,ICUO_StartDate*:oneDay+ICUO_StartTime as StartDateTime,ICUO_Note,ICUO_Qty,ICUO_StartDate,ICUO_StartTime,ICUO_ComOrd_Dr,ICUO_Oeore_Dr,ICUO_PreparedVolume,ICUO_TotalQty,ICUO_Concentration,ICUO_Speed 
	into :id,:dateTime,:text,:num,:startDate,:startTime,:recordItemId,:oeoriId,:preparedVolume,:totalQty,:concn,:speed
	FROM DHC_ICU_Order WHERE ICUO_ICUA_Dr=:icuaId and ICUO_ICUPI_Dr=:searchId AND 
	ICUO_Source='M' AND (ICUO_EditFlag='N' or ICUO_EditFlag='E') and 
	(ICUO_StartDate*:oneDay+ICUO_StartTime)<=:startDateTime 
	Order by StartDateTime desc)
	
	s obj=##Class(User.DHCICUCRecordItem).%OpenId(recordItemId)
	q:obj="" ""
	s field=obj.ICUCRIDataField
	d obj.%Close()
	
	s value=""
	i field="Qty" s value=num
	e  i field="Note"  s value=text
	e  i field="Concentration"  s value=concn
	e  i field="DoseSpeed"  s value=speed*concn
	e  i field="Speed" s value=speed
	
	q value_"^"_oeoriId_"^"_preparedVolume_"^"_totalQty
}

ClassMethod GetMainParaItemId(icuaId, subParaItemId)
{
	s mainParaItemId=""
	&sql(
	SELECT ICUPI_ICUPI_Dr into :mainParaItemId from dhc_icu_paraitem 
	where ICUPI_Parref->ICUP_ICUA_Dr=:icuaId AND 
	ICUPI_RowId=:subParaItemId AND 
	(ICUPI_IsActive IS NULL OR ICUPI_IsActive!='N')
	)
	q mainParaItemId
}

// 根据泵的ParaItemId和Code获取泵速、深度

ClassMethod GetParaItemId(icuaId, mainParaItemId, code)
{
	// w ##class(web.DHCICUMicroPump).GetParaItemId(icuaId,pumpNoParaItemId,code)
	s paraItemId=""
	&sql(
	SELECT ICUPI_RowId into :paraItemId from dhc_icu_paraitem 
	where ICUPI_Parref->ICUP_ICUA_Dr=:icuaId AND 
	ICUPI_ICUPI_Dr=:mainParaItemId AND 
	(ICUPI_IsActive IS NULL OR ICUPI_IsActive!='N') AND
	ICUPI_ComOrd_Dr->ICUCRI_Code=:code)
	
	q paraItemId
}

ClassMethod GetValueOfHour(equipId, code, date, time)
{
	// w ##class(web.DHCICUMicroPump).GetValueOfHour(equipId,recordItemId,date,time)
	i date'=+date s date=..ConvertToDateH(date)
	i time'=+time s time=..ConvertToTimeH(time)
	s recordItemId=..GetRecordItemId(code)
	s postValue="",preValue="" ;后一个值，前一个值
	s postValue=..GetLastValue(equipId,recordItemId,date,(time))
	
	q:postValue="" "" ;上小时内一个数据没有则没有数据
	
	s preValue=..GetLastValue(equipId,recordItemId,date,(time-3600))
	
	i preValue="" d
	.s preValue=..GetFirstValue(equipId,recordItemId,date,time)
	.
	
	s fromDateTime=$p(preValue,"^",2)
	s toDateTime=$p(postValue,"^",2)
	s preValue=$p(preValue,"^",1)
	s postValue=$p(postValue,"^",1)
	
	i preValue'=""  d
	.
	.s value=postValue-preValue
	.
	e  s value="" ;如果这个小时只有一个数据，认为这小时没有出入量
	
	q value_"^"_fromDateTime_"^"_toDateTime
}

// 查询上时间点最后一条记录

// 如19:00，查询18:00到19:00的数据

ClassMethod GetLastValue(equipId, recordItemId, date, time, scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).GetLastValue(equipId,date,time)
	i date'=+date s date=..ConvertToDateH(date)
	i time'=+time s time=..ConvertToTimeH(time)
	s oneDaySec=3600*24
	
	s toDateTime=(date*oneDaySec)+time
	s fromDateTime=toDateTime-scope
	
	s value="",note="",startDateTime=""
	&sql(SELECT TOP 1 (StartDate*:oneDaySec+StartTime) as StartDateTime,Num,Text 
	into:startDateTime,:value,:note 
	FROM DHC_ICU_DeviceData 
	WHERE EquipId=:equipId 
	AND RecordItemId=:recordItemId
	AND (StartDate*:oneDaySec+StartTime)>=:fromDateTime 
	AND (StartDate*:oneDaySec+StartTime)<:toDateTime
	Order by StartDateTime desc
	)
	i value="" s value=note
	q value_"^"_startDateTime
}

ClassMethod GetFirstValue(equipId, recordItemId, date, time, scope = 3600)
{
	// w ##class(web.DHCICUOrder).GetFirstValue(equipId,date,time)
	i date'=+date s date=..ConvertToDateH(date)
	i time'=+time s time=..ConvertToTimeH(time)
	s oneDaySec=3600*24
	
	s toDateTime=(date*oneDaySec)+time
	s fromDateTime=toDateTime-scope
	
	s value=""
	s value="",note="",startDateTime=""
	//&sql(SELECT TOP 1 ICUCD_Qty into:value  FROM DHC_ICU_CollectData WHERE ICUCD_Parref=1209 AND ICUCD_StartDate=63522 AND ICUCD_ComOrd_Dr=6939 AND (ICUCD_StartTime>(8*3600) AND ICUCD_StartTime<(9*3600)) ORDER BY ICUCD_StartTime)
	&sql(SELECT TOP 1 (StartDate*:oneDaySec+StartTime) as StartDateTime,Num,Text into:startDateTime,:value,:note FROM DHC_ICU_DeviceData 
	WHERE EquipId=:equipId 
	AND RecordItemId=:recordItemId
	AND (StartDate*:oneDaySec+StartTime)>=:fromDateTime 
	AND (StartDate*:oneDaySec+StartTime)<:toDateTime
	Order by StartDateTime
	)
	
	i value="" s value=note
	q value_"^"_startDateTime
}

ClassMethod GetPumpDose(icuaId, oeoriId, pumpSpeed, pumpConcn)
{
	// w ##class(web.DHCICUMicroPump).GetPumpDose(icuaId,oeoriId,pumpSpeed,pumpConcn)
	s doseUnitId=+..GetUnitIdByOeori(icuaId,oeoriId)
	q:doseUnitId="" ""
	s type=$p(^DHCICUC("SUnit",doseUnitId),"^",3)
	s pumpSpeed=..ToStandardUnit(doseUnitId,pumpSpeed)
	s dose=pumpSpeed*pumpConcn
	b ///
	i type["W" d
	.; 按体重计算
	.s patWeight=$p($g(^DHCICUArrange(icuaId)),"^",25)
	.i (patWeight>0) d
	..s dose=dose/patWeight
	
	q dose
}

ClassMethod ToStandardUnit(doseUnitId, value)
{
	// w ##class(web.DHCICUMicroPump).ToStandardUnit(doseUnitId,value)
	s pUnitId=$p($g(^DHCICUC("SUnit",doseUnitId)),"^",7)
	i pUnitId=doseUnitId q value
	s factor=+$p($g(^DHCICUC("SUnit",doseUnitId)),"^",5)
	q ..ToStandardUnit(pUnitId,value)/factor
}

ClassMethod GetUnitIdByOeori(icuaId, oeoriId)
{
	// w ##class(web.DHCICUMicroPump).GetUnitIdByOeori(icuaId,oeoriId)  3659280||8718||1
	
	// w ##class(web.DHCICUMicroPump).GetUnitIdByOeori(icuaId,oeoriId)  3659280||8718||1
	
	s itemStr=##class(web.DHCICUOrder).GetIcucriStr(oeoriId,icuaId)
	s speedUnitId=$p(itemStr,"^",2)
	s doseUnitId=$p(itemStr,"^",3)
	
	
	q speedUnitId_"^"_doseUnitId
}

ClassMethod LinkDeviceDataWithPatByCacheTime(equipId, fromDate, fromTime, toDate, toTime, icuaId)
{
	// w ##class(web.DHCICUMicroPump).LinkDeviceDataWithPatByCacheTime(equipId,fromDate,fromTime,toDate,toTime,icuaId)
	i fromDate'=+fromDate s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	i fromTime'=+fromTime s fromTime=##class(web.DHCClinicCom).ConvertToTimeH(fromTime)
	i toDate'=+toDate s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i toTime'=+toTime s toTime=##class(web.DHCClinicCom).ConvertToTimeH(toTime)
	s oneDaySec=3600*24
	s fromDateTime=(fromDate*oneDaySec)+fromTime
	s toDateTime=(toDate*oneDaySec)+toTime
	q ..LinkDeviceDataWithPat(equipId,fromDateTime,toDateTime,icuaId)
}

ClassMethod LinkDeviceDataWithPat(equipId, fromDateTime, toDateTime, icuaId)
{
	s oneDaySec=3600*24
	s count=0
	&sql(update DHC_ICU_DeviceData set IcuaId=:icuaId 
	where EquipId=:equipId and (StartDate*:oneDaySec+StartTime)>=:fromDateTime AND
	(StartDate*:oneDaySec+StartTime)<=:toDateTime)
	q SQLCODE
}

/// 添加泵速到DHC_ICU_DeviceData
/// 如与上一时间点数据一至则修改上一个数据的时间
ClassMethod AddPumpSpeed(equipId, icuaId, recordItemId, date, time, value, scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).AddPumpSpeed(equipId,recordItemId,date,time,value)
	// 查询上一个时间点数据是否与这一次相同
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s count=0,res=""
	// i icuaId="" s res=$$Add()
	// e  s res=$$AddByIcuaId()
	s oneDaySec=3600*24
	s lastid="",lastValue=""
	s preData=..GetPreSpeed(equipId, icuaId, recordItemId, date, time)
	s nextData=..GetNextSpeed(equipId, icuaId, recordItemId, date, time)
	
	s preDateTime=$p(preData,"^",4)
	s nextDateTime=$p(nextData,"^",4)
	s startDateTime=..ToDateTime(date,time)
	s preIntPoint=(date*oneDaySec)+((time\scope)*scope)
	s nextIntPoint=preIntPoint+scope
	s hasPreData=(preDateTime<=startDateTime) && (preIntPoint<=preDateTime) && (nextIntPoint>=preDateTime)
	s hasNextData=(nextDateTime>startDateTime) && (preIntPoint<=nextDateTime) && (nextIntPoint>=nextDateTime)
	s dstId="",status="",operation="无操作"
	i hasPreData d
	.
	.i hasNextData d
	..s status="有前驱和后驱"
	..d HasPreAndNextData
	.e  d
	..s status="只有前驱"
	..d JustHasPreData
	e  d
	.i hasNextData d
	..s status="只有后驱"
	..d JustHasNextData
	.e  d
	..s status="没有数据"
	..s operation="Add"
	..i (preDateTime=startDateTime)&&(nextDateTime=startDateTime) s status="该时间点已有数据"
	w operation,": ",status,!
	b
	i dstId="" d
	.i operation="Add" s res=..AddDeviceData(equipId,icuaId, recordItemId,value,date,time)
	e  d
	.
	.s res="update:"_..UpdateDeviceData(dstId, value,"", date, time)
	
	q res
	
AddByIcuaId()
	
HasPreAndNextData
	// 与前驱或后驱相同，则不修改也不添加; 与不前驱和后驱都不相同，则添加
	s preValue=$p(preData,"^",1)
	s nextValue=$p(nextData,"^",1)
	i ((preValue'=value)&&(nextValue'=value)) d
	.s operation="Add"
	e  i (nextValue=value) d
	.; 与后驱速度相同,则修改后驱时间
	.s dstId=$p(nextData,"^",5)
	e  d
	.; 只与前驱速度相同，不处理
	
	q
JustHasPreData
	s preValue=$p(preData,"^",1)
	i preValue=value d
	s prepreData=..GetPreSpeed(equipId, icuaId, recordItemId, $p(preData,"^",2), $p(preData,"^",3)-1)
	s prepreDateTime=$p(prepreData,"^",4)
	s hasOtherPreData=(prepreDateTime<preDateTime) && (preIntPoint<=prepreDateTime) && (nextIntPoint>=prepreDateTime)
	
	i hasOtherPreData d
	.s status=status_" 多个"
	.i preValue=value d
	..s status=status_" 前一个相同"
	..
	..s prePreValue=$p(prepreData,"^",1)
	..i prePreValue=value d
	...s status=status_" 两个相同"
	...s dstId=$p(preData,"^",5)
	..e  d
	...s status=status_" 一个相同"
	...s operation="Add"
	.e  d
	..s status=status_" 不相同"
	..s operation="Add"
	e  d
	.s status=status_" 一个"
	.s operation="Add"
	.q
	.i preValue=value d
	..s status=status_" 相同"
	..s dstId=$p(preData,"^",5)
	.e  d
	..s status=status_" 不相同"
	..s operation="Add"
	q
JustHasNextData
	s nextValue=$p(nextData,"^",1)
	i nextValue=value d
	s nextnextData=..GetNextSpeed(equipId, icuaId, recordItemId, $p(nextData,"^",2), $p(nextData,"^",3)+1)
	s nextnextDateTime=$p(nextnextData,"^",4)
	s hasOtherNextData=(nextnextDateTime>nextDateTime) && (preIntPoint<=nextnextDateTime) && (nextIntPoint>=nextnextDateTime)
	
	i hasOtherNextData d
	.s status=status_" 多个"
	.i nextValue=value d
	..s status=status_" 相同"
	..s dstId=$p(nextData,"^",5)
	.e  d
	..s status=status_" 不相同"
	..s operation="Add"
	e  d
	.s operation="Add"
	.s status=status_" 一个"
	.q
	.i nextValue=value d
	..s status=status_" 相同"
	..s dstId=$p(nextData,"^",5)
	.e  d
	..s status=status_" 不相同"
	..s operation="Add"
	q
}

ClassMethod AddDeviceData(equipId, icuaId, recordItemId, value, date, time)
{
	// w ##class(web.DHCICUMicroPump).AddDeviceData(equipId,recordItemId,value,date,time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s dataType=""
	&sql(select ICUCRI_DataType into:dataType from DHC_ICUC_RecordItem where ICUCRI_RowId=:recordItemId)
	i dataType="N" s text="",num=+value
	e  s text=value,num=""
	s count=""
	s dateTime=$h
	s updateDate=+dateTime
	s updateTime=$p(dateTime,",",2)
	i icuaId="" d
	.d Add
	e  d
	.d AddByIcuaId
	
	i SQLCODE=0 s res="Add:"_$g(%ROWID)
	e  s res="Add Error:"_SQLCODE
	q res
AddByIcuaId
	
	&sql(select count(*) into:count from DHC_ICU_DeviceData where equipId=:equipId and StartDate=:date and StartTime=:time and RecordItemId=:recordItemId and IcuaId=:icuaId)
	s count=+count
	s SQLCODE=""
	i count>0 d
	.
	.&sql(update DHC_ICU_DeviceData set Num=:num,Text=:text,UpdateDate=:updateDate,UpdateTime=:updateTime where equipId=:equipId and StartDate=:date and StartTime=:time and RecordItemId=:recordItemId  and IcuaId=:icuaId)
	e  d
	.&sql(INSERT INTO DHC_ICU_DeviceData(IcuaId,EquipId,RecordItemId,StartDate,StartTime,Num,Text,UpdateDate,UpdateTime) VALUES(:icuaId,:equipId,:recordItemId,:date,:time,:num,:text,:updateDate,:updateTime))
	q
Add
	&sql(select count(*) into:count 
	from DHC_ICU_DeviceData 
	where equipId=:equipId and 
	StartDate=:date and 
	StartTime=:time and 
	RecordItemId=:recordItemId)
	s count=+count
	s SQLCODE=""
	
	i count>0 d
	.
	.&sql(update DHC_ICU_DeviceData set Num=:num,Text=:text,UpdateDate=:updateDate,UpdateTime=:updateTime where equipId=:equipId and StartDate=:date and StartTime=:time and RecordItemId=:recordItemId)
	e  d
	.&sql(INSERT INTO DHC_ICU_DeviceData(IcuaId,EquipId,RecordItemId,StartDate,StartTime,Num,Text,UpdateDate,UpdateTime) VALUES("",:equipId,:recordItemId,:date,:time,:num,:text,:updateDate,:updateTime))
	q
}

ClassMethod UpdateDeviceData(id, value, text, date, time)
{
	s dateTime=$h
	s updateDate=+dateTime
	s updateTime=$p(dateTime,",",2)
	&sql(update DHC_ICU_DeviceData 
	set Num=:value,Text=:text,UpdateDate=:updateDate,UpdateTime=:updateTime ,StartDate=:date,StartTime=:time
	where ID=:id)
	q SQLCODE
}

ClassMethod GenOneIntakeData(icuaId, recordItemId, speed, fromDate, fromTime, toDate, toTime)
{
	// 查找当前时间点是否有数据，如无则查找一小时内上一个时间点的数据
	&sql(select * from DHC_ICU_DeviceData 
	where EquipId=:equipId and 
	IcuaId=:icuaId and 
	StartDate=:date and 
	StartTime=:time
	)
	s oneDaySec=3600*24
	s fromDateTime=(oneDaySec*fromDate)+fromTime
	s toDateTime=(oneDaySec*toDate)+toTime
	s time=toDateTime-fromDateTime
	q:time<=0 "fomeDateTime>toDateTime"
	s vol=speed*time
	// s res=..Insert2ICUOrder()
}

ClassMethod GetEquipId(icuaId, text)
{
	// w ##Class(web.DHCICUMicroPump).GetEquipId(icuaId,text)
	s ^DHCCLSet("Pump")=""
	s ^DHCCLSet("Pump","M")="Medcaptain"
	s pumpDevCode="CardinalAlarisCS"
	
	s equipId=""
	i $ISVALIDNUM(text) d
	.s bedId=##Class(web.DHCICUArrange).GetBedId(icuaId)
	.s equipId=$$GetPumpEquipId(bedId)
	.i equipId'="" d
	..s equipId=equipId_"-"_text
	e  i (text["P") d
	.; <P>[pumpSeq]
	.s equipId=$p(text,"P",2)
	e  i (text["p") d
	.; <p>[pumpSeq]
	.s equipId=$p(text,"p",2)
	.
	q equipId
GetPumpEquipId(bedId)
	s pumpDevList="CardinalAlarisCS;"
	s equipId=""
	
	&sql(DECLARE EquipCursor CURSOR FOR 
	SELECT ICUBE_RowId,ICUBE_InterfaceProgram into:id,:devTypeId
	FROM DHC_ICU_BedEquip 
	WHERE ICUBE_Bed_Dr=:bedId)
	&sql(OPEN EquipCursor)
    FOR { &sql(FETCH EquipCursor)
        QUIT:SQLCODE 
        s devType=##class(web.DHCANCCollectType).GetDevTypeCode(devTypeId)
        i ";"_pumpDevList_";"[(";"_devType_";") d
        .s equipId=id
 	}
 	
   &sql(CLOSE EquipCursor)
	q equipId
}

ClassMethod ToDateTime(date, time)
{
	s oneDaySec=24*3600
	q (date*oneDaySec)+time
}

ClassMethod DateTimeToStr(dateTime)
{
	s oneDaySec=24*3600
	s str=$zd(dateTime\oneDaySec)_" "_$zt(dateTime#oneDaySec)
	q str
}

ClassMethod StrToDateTime(dateTimeStr)
{
	s date=$p(dateTimeStr," ",1)
	s time=$p(dateTimeStr," ",2)
	s date=..ConvertToDateH(date)
	s time=..ConvertToTimeH(time)
	q ..ToDateTime(date,time)
}

ClassMethod GetCollectStr(itemName, itemValue)
{
	// w ##class(web.DHCICUMicroPump).GetCollectStr(itemName,itemValue)
	s str="DateTime#2015-03-24#14:39:09#V#2015-03-24~11:36::00####"
	s $p(str,"#",1)=itemName
	s $p(str,"#",2)=..ConvertToDate(+$h)
	s $p(str,"#",3)=..ConvertToTime($p($h,",",2))
	s $p(str,"#",5)=itemValue
	q str
}

ClassMethod ToDateTimeStr(date, time)
{
	s date=..ConvertToDate(date)
	s time=..ConvertToTime(time)
	q date_"~"_time
}

// 

ClassMethod PreData(equipId, icuaId, recordItemId, date, time, value = "")
{
	// w ##class(web.DHCICUMicroPump).PreData(equipId, icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s id="",num="",startDate="",startTime="",startDatetime=""
	&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime 
		from DHC_ICU_DeviceData 
		where EquipId=:equipId and 
		((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
		RecordItemId=:recordItemId and 
		((StartDate<:date)or(StartDate=:date and StartTime<:time)) and
		((:value is not null and Num<>:value)or(:value is null))
		Order by StartDate desc,StartTime desc
	)
	i SQLCODE'=0 w $SYSTEM.SQL.SQLCODE(SQLCODE),!
	b //
	q:SQLCODE'=0 ""
	w num_" "_$zd(startDate)_" "_$zt(startTime),!
	s startDatetime=..ToDateTime(startDate,startTime)
	
	q num_"^"_startDate_"^"_startTime_"^"_startDatetime_"^"_id
}

// 获取第scope范围内的date/time前的第一个数据

ClassMethod PreDataInScope(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).PreDataInScope(equipId, icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s preData=..PreData(equipId, icuaId, recordItemId, date, time,value)
	s startDatetime=$p(preData,"^",4)
	s preIntDateTime=((..ToDateTime(date,time)/scope)*scope)
	//w "preIntDateTime:"_..DateTimeToStr(preIntDateTime),!
	s interval=$zabs(startDatetime-..ToDateTime(date,time))
	
	i interval>scope q ""
	w "Find:",preData,!
	q preData
}

// 获取当前周期内的date/time前的第一个数据

ClassMethod PreDataInCurPeriod(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600, startDate = "", startTime = "", type = "Post")
{
	// w ##class(web.DHCICUMicroPump).PreDataInCurPeriod(equipId, icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s preData=..PreData(equipId, icuaId, recordItemId, date, time,value)
	s dateTime=$p(preData,"^",4)
	i startDate="" s startDate=date
	i startTime="" s startTime=time
	s searchDateTime=..ToDateTime(startDate,startTime)
	
	i type="Post"  d
	.;eg,preIntDateTime:09:00,dateTime:09:01
	.s fromDateTime=((searchDateTime\scope)*scope)
	.s toDateTime=fromDateTime+scope
	e  i type="Pre" d
	.;eg,preIntDateTime:08:00,dateTime:09:01
	.s toDateTime=((searchDateTime\scope)*scope)
	.s fromDateTime=toDateTime-scope
	w "dateTime:",..DateTimeToStr(dateTime),!
	w "fromDateTime:",..DateTimeToStr(fromDateTime),!
	w "toDateTime",..DateTimeToStr(toDateTime),!	
	i ((dateTime<fromDateTime)||(dateTime>toDateTime)) s preData="" 
	
	i preData'="" w "Find:",preData
	q preData
}

ClassMethod NextData(equipId, icuaId, recordItemId, date, time, value = "")
{
	// w ##class(web.DHCICUMicroPump).PreData(equipId, icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s id="",num="",startDate="",startTime="",startDatetime=""
	
	&sql(Select top 1 ID,Num,StartDate,StartTime into :id,:num,:startDate,:startTime 
		from DHC_ICU_DeviceData 
		where EquipId=:equipId and 
		((:icuaId is not null and IcuaId=:icuaId) OR (:icuaId is null)) and
		RecordItemId=:recordItemId and 
		((StartDate>:date)or(StartDate=:date and StartTime>:time)) and
		((:value is not null and Num<>:value)or(:value is null))
		Order by StartDate asc,StartTime asc
	)
	
	i SQLCODE'=0 w $SYSTEM.SQL.SQLCODE(SQLCODE),!
	
	q:SQLCODE'=0 ""
	w num_" "_$zd(startDate)_" "_$zt(startTime),!
	s startDatetime=..ToDateTime(startDate,startTime)
	i id<=0 q ""
	
	q num_"^"_startDate_"^"_startTime_"^"_startDatetime_"^"_id
}

// 当前周期内date/time后的第一个数据

// type: Post:向前查询,向

ClassMethod NextDataInCurPeriod(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600, startDate = "", startTime = "", type = "Post")
{
	// w ##class(web.DHCICUMicroPump).NextDataInCurPeriod(equipId, icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s preData=..NextData(equipId, icuaId, recordItemId, date, time,value)
	s dateTime=$p(preData,"^",4)
	s nextIntDateTime=((..ToDateTime(date,time)/scope)*scope)+scope
	s searchDateTime=..ToDateTime(startDate,startTime)
	w "searchDateTime:"_..DateTimeToStr(searchDateTime),!
	w "nextIntDateTime:"_..DateTimeToStr(nextIntDateTime),!
	
	i type="Post"  d
	.;eg,preIntDateTime:09:00,dateTime:09:01
	.s fromDateTime=((searchDateTime\scope)*scope)
	.s toDateTime=fromDateTime+scope
	e  i type="Pre" d
	.;eg,preIntDateTime:08:00,dateTime:09:01
	.s toDateTime=((searchDateTime\scope)*scope)
	.s fromDateTime=toDateTime-scope
	w "dateTime:",..DateTimeToStr(dateTime),!
	w "fromDateTime:",..DateTimeToStr(fromDateTime),!
	w "toDateTime",..DateTimeToStr(toDateTime),!	
	q preData
}

// scope范围内date/time后的第一个数据

ClassMethod NextDataInScope(equipId, icuaId, recordItemId, date, time, value = "", scope = 3600)
{
	// w ##class(web.DHCICUMicroPump).PreDataInScope(equipId, icuaId, recordItemId, date, time)
	i date'=+date s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	i time'=+time s time=##class(web.DHCClinicCom).ConvertToTimeH(time)
	s preData=..NextData(equipId, icuaId, recordItemId, date, time,value)
	
	s startDatetime=$p(preData,"^",4)
	s interval=$zabs(startDatetime-..ToDateTime(date,time))
	
	i interval>scope q ""
	w "Find:",preData,!
	q preData
}

}
