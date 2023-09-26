Class CIS.AN.BL.DeviceStatus
{

// w ##class(CIS.AN.BL.DeviceStatus).GetOpDevInfo(1429, "")

/// 
/// Creator：      	邓体进
/// CreatDate：    	2021-08-19
/// Description： 	获取并检测设备状态信息
/// Table：        	CIS_AN.CollectedData
/// Input:			deviceId:设备ID, dataPara:数据, extInfo:设备类型
/// Return：       	ResultSet
/// Debug: 			w ##class(CIS.AN.BL.DeviceStatus).GetOpDevInfo(2052,"")
ClassMethod GetOpDevInfo(opsId, sheetId)
{
	&sql(declare itemCursor Cursor for 
	SELECT DataItem->Description,StartDate,StartTime,DataValue 
		into :itemName,:date,:time,:value
	FROM CIS_AN.ANAData 
	WHERE ParaItem->RecordSheet->OperSchedule=:opsId AND Source="I"
	order by RowId desc
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
		set item.Date=##class(web.DHCClinicCom).ConvertToDate(date)
		set item.Time=##class(web.DHCClinicCom).ConvertToTime(time)
		set item.Value=value
		do lastDataList.%Push(item)
	}
	&sql(close itemCursor)
	// 同步时间
	&sql(declare equipCursor Cursor for 
	SELECT a.Equip,a.Equip->EquipDesc,StartDate,StartTime,EndDate,EndTime,b.TcpipAddress,b.ComPort,a.Equip->EquipModel->Description
	into :equipId,:equipName,:startDate,:startTime,:endDate,:endTime,:ip,:port,:deviceModel
	FROM CIS_AN.EquipRecord AS a,CF_AN.EquipCollection AS b  
	WHERE RecordSheet->OperSchedule=:opsId AND a.Equip=b.Equip 
	group by  a.Equip)
	&sql(open equipCursor)
	set equipList=[]
	For
	{
		&sql(Fetch equipCursor)
		quit:SQLCODE
		set item={}
		set item.EquipId=equipId
		set item.Name=equipName
		set item.IP=ip
		set item.Port=port
		set item.DeviceModel=deviceModel
		set item.StartTime=##class(web.DHCClinicCom).ConvertToDate(startDate)_" "_##class(web.DHCClinicCom).ConvertToTime(startTime)
		set item.EndTime=##class(web.DHCClinicCom).ConvertToDate(endDate)_" "_##class(web.DHCClinicCom).ConvertToTime(endTime)
		set item.LastCollectTime=..GetLastCollectDatetime(equipId)
		set endDatetime=""
		if (endTime="") 
		{
			set item.EndTime=""
			set endDatetime=(endDate*24*3600)+endTime
		}
		set startDatetime=(startDate*24*3600)+startTime
		
		set item.Status=..GetCurStatus(opsId,equipId, startDatetime, endDatetime,port)
		do equipList.%Push(item)
	}
	&sql(close equipCursor)
	// 手术开始、结束时间
	
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anEndDateTime=""
	
	set anaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId) 
	set theatreInDT=anaesthesiaObj.TheatreInDT
	set TheatreOutDT=anaesthesiaObj.TheatreOutDT
	set anStartDateTime =theatreInDT ; ##class(CIS.AN.BL.AnaestRecord).GetRecordStartDT(opsId)
    set anEndDateTime = TheatreOutDT


    
    set PACUInDT=anaesthesiaObj.PACUInDT
    set pacuStartDateTime = PACUInDT  ;##class(CIS.AN.BL.PACURecord).GetRecordStartDT(opsId)
    set PACUOutDT=anaesthesiaObj.PACUOutDT
    set pacuEndDateTime = PACUOutDT // ##class(CIS.AN.BL.PACURecord).GetRecordEndDT(opsId)
    
    set toTotalInfo={}
    set toTotalInfo.LastDataList=lastDataList
    set toTotalInfo.EquipList=equipList
    set toTotalInfo.AnStartDatetime=anStartDateTime
    set toTotalInfo.AnEndDatetime=anEndDateTime
    set toTotalInfo.PACUStartDatetime=pacuStartDateTime
    set toTotalInfo.PACUEndDatetime=pacuEndDateTime
    set toTotalInfo.OpsId=opsId
    set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
    // set recordSheetId=##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode(opsId,moduleCode,"")
    set toTotalInfo.AnId=anaId
    quit toTotalInfo.%ToJSON()
}

// w ##class(CIS.AN.BL.DeviceStatus).GetCurStatus(2050, 1601,"","")

ClassMethod GetCurStatus(opsId, equipId, startDatetime, endDatetime, port)
{
	set curDatetime=(+$h*24*3600)+$p($h,",",2)
	&sql(select LastRecvPacketDataTime ,LastRecvValidDataTime into :lastRecvPacketDataTime,:lastRecvValidDataTime
	from CIS_AN.CollectEquipStatus
	where Equip=:equipId)
	set lastRecvPacketDataTime=..TimeStampToSeconds(lastRecvPacketDataTime)
	set lastRecvValidDataTime=..TimeStampToSeconds(lastRecvValidDataTime)
	set span=curDatetime-lastRecvPacketDataTime
	
	if (span>120)
	{
		set span=span\60
		if (((port\1000)=4)&&((port#1000)<10)) 
		{
			quit "设备掉线，原因:网线或检查MOXA NPort电源是否插牢 离线时间长:"_span_"min"
		}
		elseif lastRecvPacketDataTime="" 
		{
			quit "设备掉线 原因:请检查网线或检查MOXA NPort电源是否插牢 一直未连接到网络"
		}
		else  
		{
			quit "设备掉线 原因:请检查网线"_" 离线时间长:"_span_"min"
		}
	}
	set span=curDatetime-lastRecvValidDataTime
	if (span>120)
	{
		set span=span\60
		if (((port\1000)=4)&&((port#1000)<10)) quit "未收到有效数据: 原因:串口线未插牢、插错接口或串口线损坏,,或者设备上未配置正确串口参数:已"_span_"min未取到数据"
		else  quit "未收到有效数据:设备上未显示数据"
	}
	
	
	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set status=operSchedule.Status.Code
	if ((status'="PACUIn") && (status'="RoomIn"))
	{
		quit "当前状态不采集数据:"_operSchedule.Status.Description
	}
    
    
    if (curDatetime<startDatetime)
    {
	    quit "当前时间在设备使用开始时间前，无法同步设备数据"
    }
    if ((endDatetime'=0)&&curDatetime>endDatetime)
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

ClassMethod GetLastCollectDatetime(equipId)
{
	set date=""
	set time=""
	&sql(SELECT TOP 1 CollectDate,CollectTime into :date,:time FROM CIS_AN.CollectedData 
	WHERE Equip=:equipId and CollectDate=+$h ORDER BY RowId desc)
	set dateTime=""
	if (time'="")
	{
		// _
		set dateTime=##class(web.DHCClinicCom).ConvertToDate(date)_" "_##class(web.DHCClinicCom).ConvertToTime(time)
	}
	quit dateTime
}

Query FindDataByEquipId(equipId) As %SQLQuery(CONTAINID = 1)
{
	SELECT RowId ,ChannelNo AS Name,%ODBCOUT(CollectDate) as CollectDate  ,%ODBCOUT(CollectTime) as CollectTime ,DataValue As Value
	FROM CIS_AN.CollectedData 
	WHERE Equip=:equipId and CollectDate=+$h 
	Order by RowId desc
}

/// 
/// Creator：      	邓体进
/// CreatDate：    	2021-08-19
/// Description： 	获取并检测手术室设备状态信息
/// Table：        	CIS_AN.CollectedData
/// Input:			deviceId:设备ID, dataPara:数据, extInfo:设备类型
/// Return：       	ResultSet
/// Debug: 			w ##class(CIS.AN.BL.DeviceStatus).GetOverviewDevInfo("","")
ClassMethod GetOverviewDevInfo(operDeptId = "", opRoomId = "")
{
	&sql(declare equipOverViewCursor Cursor for 
	SELECT a.Equip,a.Equip->EquipDesc,StartDate,StartTime,EndDate,EndTime,b.TcpipAddress,b.ComPort,a.RecordSheet->OperSchedule,a.RecordSheet->OperSchedule->OperRoom->Description,a.RecordSheet->OperSchedule->PatName,a.RecordSheet->OperSchedule->RegNo,a.RecordSheet->OperSchedule->Status->Description
	into :equipId,:equipName,:startDate,:startTime,:endDate,:endTime,:ip,:port,:opsId,:opRoomName,:patName,:regNo,:opStatus
	FROM CIS_AN.EquipRecord AS a,CF_AN.EquipCollection AS b 
	WHERE a.Equip=b.Equip and (:operDeptId is null or a.RecordSheet->OperSchedule->OperDeptID=:operDeptId)
	      and (:opRoomId is null or a.RecordSheet->OperSchedule->OperRoom=:opRoomId)
	group by a.RecordSheet->OperSchedule->OperRoom
	having a.RecordSheet->OperSchedule=max(a.RecordSheet->OperSchedule)
	)
	&sql(open equipOverViewCursor)
	set equipList=[]
	For
	{
		&sql(Fetch equipOverViewCursor)
		quit:SQLCODE
		set item={}
		set item.EquipId=equipId
		set item.Name=equipName
		set item.IpAddress=ip
		set item.Port=port
		set item.StartTime=##class(web.DHCClinicCom).ConvertToDate(startDate)_" "_##class(web.DHCClinicCom).ConvertToTime(startTime)
		set item.EndTime=##class(web.DHCClinicCom).ConvertToDate(endDate)_" "_##class(web.DHCClinicCom).ConvertToTime(endTime)
		set item.LastCollectTime=..GetLastCollectDatetime(equipId)
		set item.PatName=patName
		set item.PatientNo=regNo
		set item.RoomName=opRoomName
		set item.OpStatus=opStatus
		set endDatetime=""
		if (endTime="") 
		{
			set item.EndTime=""
			set endDatetime=(endDate*24*3600)+endTime
		}
		set startDatetime=(startDate*24*3600)+startTime
		
		set item.Status=..GetCurStatus(opsId,equipId, startDatetime, endDatetime,port)
		
		// 手术开始、结束时间
	
		set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
		set anEndDateTime=""
		
		set anaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId) 
		set TheatreOutDT=anaesthesiaObj.TheatreOutDT
		set anStartDateTime = ##class(CIS.AN.BL.AnaestRecord).GetRecordStartDT(opsId)
	    set anEndDateTime = TheatreOutDT


	    set pacuStartDateTime = ##class(CIS.AN.BL.PACURecord).GetRecordStartDT(2081)
	    set PACUOutDT=anaesthesiaObj.PACUOutDT
	    set pacuEndDateTime = PACUOutDT 
	    set item.AnStartDatetime=anStartDateTime
	    set item.AnEndDatetime=anEndDateTime
	    set item.PACUStartDatetime=pacuStartDateTime
	    set item.PACUEndDatetime=pacuEndDateTime
	    set item.OpsId=opsId
		do equipList.%Push(item)
	}
	&sql(close equipOverViewCursor)
	
    
    set toTotalInfo={}
    set toTotalInfo.EquipList=equipList
    quit toTotalInfo.%ToJSON()
}

// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DeviceStatus","FindOperLoc","")

Query FindOperLoc(filterStr) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT distinct LOC_CTLOC_DR As Id,
       LOC_CTLOC_DR->CTLOC_Code As Code,
       LOC_CTLOC_DR->CTLOC_Desc As Text,
       LOC_CTLOC_DR->CTLOC_Hospital_DR As HospID,
       LOC_CTLOC_DR->CTLOC_Hospital_DR->HOSP_Desc As HospDesc,
       LOC_CTLOC_DR->CTLOC_ContactName As Alias
       from SQLUser.CT_LocationList_Locations
       where (('OP^OUTOP^EMOP' [ UPPER('^'||LOC_ParRef->LL_Code||'^')) 
       and (:filterStr is null or LOC_CTLOC_DR->CTLOC_Desc like "'%"_:filterStr_"%'"))
    /*
	SELECT CTLOC_RowID as Id, CTLOC_Desc as Text 
	FROM CT_loc WHERE CTLOC_Desc LIKE '%手术室%'
	and (:filterStr is null or CTLOC_Desc like "'%"_:filterStr_"%'") */
}

// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DeviceStatus","FindOperRoom",46,"")

Query FindOperRoom(operDeptId, filterStr) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT RowId as Id,Description as Text FROM CF_AN.Location 
	WHERE ((:operDeptId is null) or (OperDeptID=:operDeptId)) 
	AND ((:filterStr is null) or Description like "'%"_:filterStr_"%'")
	Order by +Code asc
}

}
