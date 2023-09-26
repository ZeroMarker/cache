Import SQLUser

Class web.DHCICUDeviceStatus
{

// w ##class(CIS.AN.BL.CollectData).GetOpDevInfo(1429, "")

// w ##class(CIS.AN.BL.CollectData).GetOpDevInfo(1429, "")

/// 
/// Creator：      	邓体进
/// CreatDate：    	2021-08-19
/// Description： 	获取并检测设备状态信息
/// Table：        	CIS_AN.CollectedData
/// Input:			deviceId:设备ID, dataPara:数据, extInfo:设备类型
/// Return：       	ResultSet
/// Debug: 			w ##class(web.DHCICUDeviceStatus).GetDevInfo(61)
ClassMethod GetDevInfo(icuaId)
{
	&sql(declare itemCursor Cursor for 
	SELECT ICUO_ComOrd_Dr->ICUCRI_Desc,ICUO_StartTime,ICUO_Qty,ICUO_Note into :itemName,:time,:value,:text
	FROM DHC_ICU_Order 
	WHERE ICUO_ICUA_Dr=:icuaId AND ICUO_Source="I"  and ICUO_StartDate=+$h
	order by ICUO_RowId asc
	)
	// GROUP BY DataItem->Description  HAVING RowId=MAX(RowId) 查询最后一组数据
	&sql(open itemCursor)
	set lastDataList=[]
	For
	{
		&sql(Fetch itemCursor)
		quit:SQLCODE
		set item={}
		set item.Name=itemName
		set item.Time=##class(web.DHCClinicCom).ConvertToTime(time)
		set item.Value=value
		do lastDataList.%Push(item)
	}
	&sql(close itemCursor)
	// 同步时间
	
	set arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	set bedId=arrange.ICUABedDr
	set startDate=arrange.ICUAStartDate
	set startTime=arrange.ICUAStartTime
	set startDatetime=(startDate*24*3600)+startTime
	set endDate=arrange.ICUAEndDate
	set endTime=arrange.ICUAEndTime
	set endDatetime=""

	
	
	if (endTime'="")
	{
		set endDatetime=(startDate*24*3600)+startTime
	}
	else
	{
		
	}
	&sql(declare equipCursor Cursor for 
	SELECT b.RowId,a.DeviceId->DeviceName,b.Ip,b.Port
	into :equipId,:equipName,:ip,:port
	FROM DHC_ICU_BedDevice AS a,DHC_ICU_Device AS b  
	WHERE a.BedId=:bedId and a.DeviceId=b.RowId)
	&sql(open equipCursor)
	set equipList=[]
	For
	{
		&sql(Fetch equipCursor)
		quit:SQLCODE
		set item={}
		set item.EquipId=equipId
		set item.Name=equipName_"-"_ip
		set item.Port=port
		set item.LastCollectTime=..GetLastCollectDatetime(equipId)
		set item.Status=..GetCurStatus(icuaId,equipId, startDatetime, endDatetime,port)
		
		
		
		do equipList.%Push(item)
	}
	&sql(close equipCursor)
	// 手术开始、结束时间
	set startDatetime=##class(web.DHCClinicCom).ConvertToDate(arrange.ICUAStartDate)_" "_##class(web.DHCClinicCom).ConvertToTime(arrange.ICUAStartTime)
	set endDatetime=##class(web.DHCClinicCom).ConvertToDate(arrange.ICUAEndDate)_" "_##class(web.DHCClinicCom).ConvertToTime(arrange.ICUAEndTime)
    set toTotalInfo={}
    set toTotalInfo.LastDataList=lastDataList
    set toTotalInfo.EquipList=equipList
    set toTotalInfo.StartDatetime=startDatetime
    set toTotalInfo.EndDatetime=endDatetime
    
    set toTotalInfo.IcuaId=icuaId
    set admObj=##class(User.PAAdm).%OpenId(arrange.ICUAAdmDr)
	set patName=admObj.PAADMPAPMIDR.PAPMIName
	set regNo=admObj.PAADMPAPMIDR.PAPMINo
	set toTotalInfo.PatName=patName
	set toTotalInfo.PatientNo=regNo
	set bedName="" b
	if (bedId'="")
	{
		set bed=##class(User.PACBed).%OpenId(bedId)
		set bedName=bed.BEDCode
	}
	set toTotalInfo.BedName=bedName
    
    quit toTotalInfo.%ToJSON()
}

// w ##class(CIS.AN.BL.CollectData).GetCurStatus(2050, 1601,"","")

/// 入参：
///     equipId: 设备号
///     startDatetime: 重症记录开始时间
///     endDatetime: 重症记录结束时间
///     port : 端口号
ClassMethod GetCurStatus(icuaId, equipId, startDatetime, endDatetime, port)
{
	set curDatetime=(+$h*24*3600)+$p($h,",",2)
	set lastRecvPacketDataTime="",lastRecvValidDataTime=""
	&sql(select LastRecvPacketDataTime ,LastRecvValidDataTime into :lastRecvPacketDataTime,:lastRecvValidDataTime
	from DHC_ICU_DeviceStatus
	where Equip=:equipId)
	set lastRecvPacketDataTime=..TimeStampToSeconds(lastRecvPacketDataTime)
	set lastRecvValidDataTime=..TimeStampToSeconds(lastRecvValidDataTime)
	set span=curDatetime-lastRecvPacketDataTime
	
	if (span>120)
	{
		set span=span\60
		if (((port\1000)=4)&&((port#1000)<10)) 
		{
			quit "设备掉线:请检查网线或检查MOXA NPort电源是否插牢 离线时间长:"_span_"min"
		}
		elseif lastRecvPacketDataTime="" 
		{
			quit "设备掉线:请检查网线或检查MOXA NPort电源是否插牢 一直未连接到网络"
		}
		else  
		{
			quit "设备掉线:请检查网线"_" 离线时间长:"_span_"min"
		}
	}
	set span=curDatetime-lastRecvValidDataTime
	if (span>120)
	{
		set span=span\60
		if (((port\1000)=4)&&((port#1000)<10))  quit "未收到有效数据: 设备上无显示数据或串口线未插牢或损坏,或者设备上未配置正确串口参数:已"_span_"min未取到数据"
		else  quit "未收到有效数据: 原因:设备上无显示数据:已"_span_"min未取到数据"
	}
	
	
	
	set arrange=##class(User.DHCICUArrange).%OpenId(icuaId)
	set status=arrange.ICUAStatus
	if ((status'="M"))
	{
		quit "当前状态不采集数据:"_arrange.ICUAStatus
	}
    
    
    if (curDatetime<startDatetime)
    {
	    quit "当前时间在设备使用开始时间前，无法同步设备数据"
    }
    if ((+endDatetime'=0)&&curDatetime>endDatetime)
    {
	    quit "当前时间在设备使用结束时间后，无法同步设备数据"
	}
	
	quit "正常"
}

ClassMethod TimeStampToSeconds(timeStamp As %String) As %String
{
    if timeStamp="" quit ""
    
    set date=$piece(timeStamp," ",1)
    set time=$piece(timeStamp," ",2)
    set dateH=##class(CIS.AN.COM.DateTime).ConvertToDateH(date)
    set timeH=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time)
    
    quit (dateH*24*3600)+timeH
}

// w ##class(web.DHCICUDeviceStatus).GetLastCollectDatetime(56)

ClassMethod GetLastCollectDatetime(equipId)
{
	//quit "暂时注释，太慢了"
	set date=""
	set time=""
	set rowId=$O(^DHCICUDeviceData(0,"EquipStartDateIndex",equipId,+$h,""),-1)
	&sql(SELECT TOP 1 %ODBCOUT(StartDate),%ODBCOUT(StartTime) into :date,:time 
	FROM DHC_ICU_DeviceData 
	WHERE Id=:rowId ORDER BY Id desc)
	set dateTime=""
	if (time'="")
	{
		set dateTime=date_" "_time
	}
	quit dateTime
}

Query FindDataByEquipId(equipId) As %SQLQuery(CONTAINID = 1)
{
	SELECT Id As RowId ,RecordItemId->ICUCRI_Desc AS Name,%ODBCOUT(StartDate) as CollectDate  ,%ODBCOUT(StartTime) as CollectTime ,Num As Value
	FROM DHC_ICU_DeviceData 
	WHERE EquipId=:equipId and StartDate=+$h 
	Order by Id desc
}

/// 
/// Creator：      	邓体进
/// CreatDate：    	2021-08-21
/// Description： 	获取并检测美欧设备状态信息
/// Table：        	DHC_ICU_Device,DHC_ICU_BedDevice
/// Input:			deviceId:设备ID, dataPara:数据, extInfo:设备类型
/// Return：       	ResultSet
/// Debug: 			w ##class(web.DHCICUDeviceStatus).GetWardDevInfo()
ClassMethod GetWardDevInfo(wardId = "", bedId = "")
{
	&sql(declare wardEquipCursor Cursor for 
	SELECT b.RowId,a.DeviceId->DeviceName,b.Ip,b.Port,a.BedId,c.ICUA_RowId ,c.ICUA_Status,a.BedId->BED_Code
	into :equipId,:equipName,:ip,:port,:bedId,:arrangeId,:icuStatus,:bedName
	FROM DHC_ICU_BedDevice AS a,DHC_ICU_Device AS b ,DHC_ICU_Arrange as c
	WHERE a.DeviceId=b.RowId and a.BedId=c.ICUA_Bed_Dr 
	and ((:wardId is null) or a.BedId->BED_WARD_ParRef=:wardId)
	and ((:bedId is null) or a.BedId=:bedId)
	GROUP BY b.RowId
	Having c.ICUA_RowId=max(c.ICUA_RowId)
	Order by +a.BedId->BED_Sequence
	)
	// Having ((:wardId="") or a.BedId->BED_WARD_ParRef=:wardId)
	&sql(open wardEquipCursor)
	set equipList=[]
	set icuaStatusDic("A")="安排"
	set icuaStatusDic("M")="监护中"
	set icuaStatusDic("T")="结束"
	For
	{
		&sql(Fetch wardEquipCursor)
		quit:SQLCODE
		set item={}
		set item.EquipId=equipId
		set item.Name=equipName
		set item.IPAddress=ip
        set item.Port=port
		set item.LastCollectTime=..GetLastCollectDatetime(equipId)
		
		set arrange=##class(User.DHCICUArrange).%OpenId(arrangeId)
		// set bedId=arrange.ICUABedDr
		set startDate=arrange.ICUAStartDate
		set startTime=arrange.ICUAStartTime
		set startDatetime=(startDate*24*3600)+startTime
		set endDate=arrange.ICUAEndDate
		set endTime=arrange.ICUAEndTime
		set endDatetime=""
		set item.StartDatetime=##class(CIS.AN.COM.DateTime).ConvertToDate(startDate)_" "_##class(CIS.AN.COM.DateTime).ConvertToTime(startTime)
		if (endTime'="")
		{
			set item.EndDatetime=##class(CIS.AN.COM.DateTime).ConvertToDate(startDate)_" "_##class(CIS.AN.COM.DateTime).ConvertToTime(startTime)
		}
	
		set item.Status=..GetCurStatus(arrangeId,equipId, startDatetime, endDatetime,port)
		set item.ICUStatus=$g(icuaStatusDic(icuStatus))
		set item.IcuaId=arrangeId
		set item.BedName=bedName
		if (arrangeId'="")
		{
			set admObj=##class(User.PAAdm).%OpenId(arrange.ICUAAdmDr)
			set patName=admObj.PAADMPAPMIDR.PAPMIName
			set regNo=admObj.PAADMPAPMIDR.PAPMINo
			set item.PatName=patName
			set item.PatientNo=regNo
			set item.BedName=bedName
		}
		
		do equipList.%Push(item)
	}
	&sql(close wardEquipCursor)
    set toTotalInfo={}
    set toTotalInfo.EquipList=equipList
    quit toTotalInfo.%ToJSON()
}

// d ##class(%ResultSet).RunQuery("web.DHCICUDeviceStatus","FindWard","")

Query FindWard(filterStr) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	Select top 10 WARD_RowId as Id ,WARD_Desc as Text 
	from PAC_Ward
	where WARD_LocationDR IN (SELECT ICUP_Ctloc_Dr 
	FROM DHC_ICU_para 
	WHERE ICUP_Ctloc_Dr IS NOT NULL) 
	and (:filterStr is null or WARD_Desc [ :filterStr)
	/*(:filterStr is null or WARD_Desc like "'%"_:filterStr_"%'")*/
}

// d ##class(%ResultSet).RunQuery("web.DHCICUDeviceStatus","FindBed",66,"")

Query FindBed(wardId, filterStr) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	Select top 10 BED_RowID as Id ,BED_Code as Text 
	from PAC_Bed
	where (BED_WARD_ParRef=:wardId) and (:filterStr is null or BED_Code [ :filterStr )
	/*Order by +BED_Sequence asc BED_Code like "'%"_:filterStr_"%'"*/
}

}
