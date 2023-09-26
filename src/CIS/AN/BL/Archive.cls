Class CIS.AN.BL.Archive Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.Archive).Archive("74","116","17418","OperSafetyCheck","手术安全核查AN.pdf")
ClassMethod Archive(opsID As %String, recordSheetID As %String, userID As %String, archiveCode As %String, filename As %String) As %String
{
	set $zt="Error"
	
	set id=opsID
	quit:('##class(CIS.AN.OperSchedule).%ExistsId(opsID)) "E^手术申请不存在"
	quit:('##class(CIS.AN.RecordSheet).%ExistsId(recordSheetID)) "E^表单Id不存在"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsID)
	set date=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
	set valueStr="{""valueObject"":{"
	
	//手术申请信息
	set ret=##class(CIS.AN.COM.String).QueryToArray(.scheduleArr,"CIS.AN.BL.OperScheduleList","FindOperScheduleList","","","",opsID,"","","")
	set scheduleProperty=""
	set ifHasValue=0
	for
	{
		set scheduleProperty=$o(scheduleArr(1,scheduleProperty))
		quit:scheduleProperty=""
		set scheduleValue=scheduleArr(1,scheduleProperty)
		if ifHasValue set valueStr=valueStr_","_""""_scheduleProperty_""""_":"_""""_scheduleValue_""""
		else  set valueStr=valueStr_""""_scheduleProperty_""""_":"_""""_scheduleValue_""""
		
		set ifHasValue=1
	}
	
	//用户填写数据
	set ret=##class(CIS.AN.COM.String).QueryToArray(.operDataArr,"CIS.AN.BL.OperData","FindOperDataBySheet",recordSheetID)
	set operDataInd=0
	for
	{
		set operDataInd=$o(operDataArr(operDataInd))
		quit:(operDataInd="")
		set dataItem=operDataArr(operDataInd,"DataItem")
		set dataValue=operDataArr(operDataInd,"DataValue")
		
		if ifHasValue set valueStr=valueStr_","_""""_dataItem_""""_":"_""""_dataValue_""""
		else  set valueStr=valueStr_""""_dataItem_""""_":"_""""_dataValue_""""
		
		set ifHasValue=1
	}
	
	//签名数据
	set ret=##class(CIS.AN.COM.String).QueryToArray(.signDataArr,"CIS.AN.CA.SignatureService","FindSignature",recordSheetID)
	set signId=0
	for 
	{
		set signId=$o(signDataArr(signId))
		quit:(signId="")
		set sheetId=signDataArr(signId,"RecordSheet")
		set signCode=signDataArr(signId,"SignCode")
		set fullName=signDataArr(signId,"FullName")
		set signImage=##class(CIS.AN.CA.SignatureService).GetSignImage(sheetId,signCode)
		set dataItem=signCode
		set dataValue=""
		if (signImage'="")
		{
			set dataValue="data:image/png;base64,"_signImage
		}
		else
		{
			set dataValue=fullName
		}
		
		if ifHasValue set valueStr=valueStr_","_""""_dataItem_""""_":"_""""_dataValue_""""
		else  set valueStr=valueStr_""""_dataItem_""""_":"_""""_dataValue_""""
		
		set ifHasValue=1
	}
	
	set valueStr=valueStr_"}}"

	set archiveServerIP=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerIP")
    set archiveServerPort=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerPort")
    
    set isHttps=0
    if (archiveServerPort=8889) set isHttps=1
	;;b ;;001
	Set httprequest=##class(%Net.HttpRequest).%New()
	Set httprequest.Server=archiveServerIP
	Set httprequest.Port=archiveServerPort
	if (isHttps=1)
	{
		set httprequest.SSLConfiguration="SSLECP"
    	set httprequest.Https=1
	}
	Do httprequest.InsertFormData("type","AN")
	Do httprequest.InsertFormData("id",id)
	Do httprequest.InsertFormData("date",date)
	Do httprequest.InsertFormData("filename",filename)
	Do httprequest.InsertFormData("archiveCode",archiveCode)
	Do httprequest.InsertFormData("valueStr",valueStr)
	Do httprequest.Post("/templateArchives")
	set response=httprequest.HttpResponse
	b ;;001
	if (response="")
	{
		set ret="S^归档成功"
	}
	else
	{
		set ret=httprequest.HttpResponse.Data.Read()
	}
	
	
	if ($piece(ret,"^",1)="S")
	{
		set recordSheetObj=##class(CIS.AN.RecordSheet).%OpenId(recordSheetID)
		set recordSheetObj.FileUser=userID
		set recordSheetObj.FileDate=+$h
		set recordSheetObj.FileTime=$piece($h,",",2)
		set recordSheetObj.FilePath="http://"_archiveServerIP_":"_archiveServerPort_"/pdfviewer?type=AN&id="_id_"&date="_date_"&filename="_filename
		if (isHttps=1) set recordSheetObj.FilePath="https://"_archiveServerIP_":"_archiveServerPort_"/pdfviewer?type=AN&id="_id_"&date="_date_"&filename="_filename
		set result=recordSheetObj.%Save()
		
		set result=recordSheetObj.%Save()
		set archiveLog=##class(CIS.AN.ArchiveLog).%New()
		set archiveLog.RecordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetID)
		set archiveLog.ArchiveUser=userID
		set archiveLog.ArchiveDate=+$h
		set archiveLog.ArchiveTime=$piece($h,",",2)
		set archiveLog.Url=recordSheetObj.FilePath
		set result=archiveLog.%Save()
	}
	
	quit ret

Error
	quit "E^"_$ze
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Archive","FindArchiveInfoList","2020-01-01","2020-12-01","364","")
Query FindArchiveInfoList(startDate As %String, endDate As %String, userDeptID As %String, operRoomId As %String) As %Query(ROWSPEC = "OPSID,PatName,PatGender,PatAge,OperDate,RoomDesc,OperSeq,OperDesc,SurgeonDesc,AnesthesiologistDesc,ScrubNurseDesc,CircualNurseDesc,StatusDesc,StatusColor,SourceType,SourceTypeDesc,PatDeptDesc,AnaMethodDesc,IfAllArchived,ArchiveMsg") [ SqlProc ]
{
}

ClassMethod FindArchiveInfoListExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, userDeptID As %String, operRoomId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	do rset.Execute(startDate,endDate,userDeptID,"","","","Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop",operRoomId,"","","N")
	while (rset.Next()) 
	{
		set OPSID=rset.GetDataByName("OPSID")
		set PatName=rset.GetDataByName("PatName")
		set PatGender=rset.GetDataByName("PatGender")
		set PatAge=rset.GetDataByName("PatAge")
		set OperDate=rset.GetDataByName("OperDate")
		set RoomDesc=rset.GetDataByName("RoomDesc")
		set OperSeq=rset.GetDataByName("OperSeq")
		set OperDesc=rset.GetDataByName("OperDesc")
		set SurgeonDesc=rset.GetDataByName("SurgeonDesc")
		set AnesthesiologistDesc=rset.GetDataByName("AnesthesiologistDesc")
		set AnaMethodDesc=rset.GetDataByName("AnaMethodDesc")
		set ScrubNurseDesc=rset.GetDataByName("ScrubNurseDesc")
		set CircualNurseDesc=rset.GetDataByName("CircualNurseDesc")
		set StatusDesc=rset.GetDataByName("StatusDesc")
		set StatusColor=rset.GetDataByName("StatusColor")
		set SourceType=rset.GetDataByName("SourceType")
		set SourceTypeDesc=rset.GetDataByName("SourceTypeDesc")
		set PatDeptDesc=rset.GetDataByName("PatDeptDesc")
		
		set total=0,archivedCount=0
		set rset2=##class(%ResultSet).%New("CIS.AN.BL.Archive:FindArchiveRecordSheets")
		do rset2.Execute(OPSID)
		while (rset2.Next()) 
		{
			set RecordSheetId=rset2.GetDataByName("RecordSheetId")
			set FilePath=rset2.GetDataByName("FilePath")
			set total=total+1
			if FilePath'="" set archivedCount=archivedCount+1
		}
		set IfAllArchived="Y", ArchiveMsg=total_"个归档，已全部归档"
		if total'=archivedCount
		{
			set IfAllArchived="N", ArchiveMsg="共"_total_"个归档，已归档"_archivedCount_"个"
		}
		do OutputRow
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(OPSID,PatName,PatGender,PatAge,OperDate,RoomDesc,OperSeq,OperDesc,SurgeonDesc,AnesthesiologistDesc,ScrubNurseDesc,CircualNurseDesc,StatusDesc,StatusColor,SourceType,SourceTypeDesc,PatDeptDesc,AnaMethodDesc,IfAllArchived,ArchiveMsg)
	s ind=ind+1
	q
}

ClassMethod FindArchiveInfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArchiveInfoListExecute ]
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

ClassMethod FindArchiveInfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArchiveInfoListExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.Archive","FindArchiveRecordSheets",1)
Query FindArchiveRecordSheets(opsId As %String) As %Query(ROWSPEC = "RecordSheetId,DataModuleId,DataModuleCode,DataModuleDesc,ArchiveCode,FileDate,FileTime,FilePath") [ SqlProc ]
{
}

ClassMethod FindArchiveRecordSheetsExecute(ByRef qHandle As %Binary, opsId As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	
	if ('##class(CIS.AN.OperSchedule).%ExistsId(opsId))
	{
		s qHandle=$lb(0,repid,0)
		q $$$OK		
	}
	
	set RowId=""
	for{
		set RowId=$o(^CIS.AN.RecordSheetI("IOPS",opsId, RowId))
		quit:RowId=""
		
		set RecordSheetId=RowId
		set DataModuleId=$lg(^CIS.AN.RecordSheetD(RowId),2)
		set DataModuleCode=$lg(^CT.AN.DataModuleD(DataModuleId),1)
		set DataModuleDesc=$lg(^CT.AN.DataModuleD(DataModuleId),2)
		set ArchiveCode=$lg(^CT.AN.DataModuleD(DataModuleId),14)
		continue:ArchiveCode=""
		
		set templateId=""
		&sql(select TOP 1 RowId into :templateId from CT_AN.PrintTemplate where DataModule=:DataModuleId)
		continue:templateId=""
		
		set FileDate=$zd($lg(^CIS.AN.RecordSheetD(RowId),10),3)
		set FileTime=$zt($lg(^CIS.AN.RecordSheetD(RowId),11))
		set FilePath=$lg(^CIS.AN.RecordSheetD(RowId),12)
		do OutputRow
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(RecordSheetId,DataModuleId,DataModuleCode,DataModuleDesc,ArchiveCode,FileDate,FileTime,FilePath)
	s ind=ind+1
	q
}

ClassMethod FindArchiveRecordSheetsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArchiveRecordSheetsExecute ]
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

ClassMethod FindArchiveRecordSheetsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArchiveRecordSheetsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// w ##class(CIS.AN.BL.Archive).BatchArchive(1,"32")
ClassMethod BatchArchive(opsId As %String, userId As %String) As %String
{
	set result=""
	set rset=##class(%ResultSet).%New("CIS.AN.BL.Archive:FindArchiveRecordSheets")
	do rset.Execute(opsId)
	while (rset.Next()) 
	{
		set RecordSheetId=rset.GetDataByName("RecordSheetId")
		set ArchiveCode=rset.GetDataByName("ArchiveCode")
		set DataModuleDesc=rset.GetDataByName("DataModuleDesc")
		set ret=##class(CIS.AN.BL.Archive).Archive(opsId,RecordSheetId,userId,ArchiveCode,DataModuleDesc_".pdf")
		set ret=ret_"^"_DataModuleDesc
		
		if (result="") set result=ret
		else  set result=result_"||"_ret
	}
	quit result
}

}
