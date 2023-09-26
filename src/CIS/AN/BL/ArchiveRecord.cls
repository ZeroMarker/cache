/// 手术麻醉提交归档记录
Class CIS.AN.BL.ArchiveRecord Extends (%RegisteredObject, %CSP.Page)
{

ClassMethod OnPage() As %Status
{
	set action = $g(%request.Data("Action", 1), "")
	
	if (action="SubmitRecord")
	{
		set recordSheetId=$g(%request.Data("recordSheetId", 1), "")
		set archiveDataContent=$g(%request.Data("archiveDataContent", 1), "")
		set submitUserId=$g(%request.Data("submitUserId", 1), "")
		set sheetTemplateId=$g(%request.Data("sheetTemplateId", 1), "")
		set sheetSelector=$g(%request.Data("sheetSelector", 1), "")
		set archiveCode=$g(%request.Data("archiveCode", 1), "")
		set archiveData=$g(%request.Data("archiveData", 1), "")
		set signData=$g(%request.Data("signData", 1), "")
		set result=..SubmitRecord(recordSheetId,archiveDataContent,submitUserId,sheetTemplateId,sheetSelector,archiveCode,archiveData,signData)
		w result
	}
	elseif (action="BackstageArchive")
	{
		set drawContext=$g(%request.Data("drawContext", 1), "")
		set result=..BackstageArchive(drawContext)
		w result
	}
	else 
	{
		w "无参数"
	}
	Quit $$$OK
}

ClassMethod SubmitRecord(recordSheetId, archiveDataContent, submitUserId, sheetTemplateId, sheetSelector, archiveCode, archiveData, signData) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) "E^表单Id不存在,recordSheetId="_recordSheetId
	quit:archiveDataContent="" "E^表单打印数据为空"
	quit:..CheckSubmitState(recordSheetId,archiveCode)="Y" "E^表单已经提交，请撤销后再提交"
	
	set archiveData=##class(CIS.AN.BL.PrintTemplate).GetSheetDataStr(archiveData)
	set signData=##class(CIS.AN.BL.PrintTemplate).GetSheetDataStr(signData)
	
	set $ZT="ERROR"
	tstart
	
	
	//保存归档记录
	set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%New()
	set archiveRecordObj.RecordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	if (archiveDataContent["CharacterStream") do archiveRecordObj.ArchiveDataContent.CopyFrom(archiveDataContent)
	else  do archiveRecordObj.ArchiveDataContent.Write(archiveDataContent)
	set archiveRecordObj.SubmitUser=submitUserId
	set archiveRecordObj.SumitState="S"
	set archiveRecordObj.SheetTemplate=sheetTemplateId
	set archiveRecordObj.SheetSelector=sheetSelector
	set archiveRecordObj.ArchiveCode=archiveCode
	set status=archiveRecordObj.%Save()
	if '$System.Status.IsOK(status)
	{
		tro
		quit "E^"_$System.Status.GetErrorText(status)
	}
	set archiveRecordId=archiveRecordObj.%Id()
	
	
	if (archiveData'="")
	{
		//保存归档数据
		kill array
		set sc=##class(CIS.AN.COM.String).ToArray(archiveData,.array)
		set dataIndex=0,saveResult=""
		for
		{
			set dataIndex=$order(array(dataIndex))
			quit:(dataIndex="")
			merge singleData=array(dataIndex)
			set singleData("ArchiveRecord")=archiveRecordId
			set singleData("RowId")=""
			set singleData("ClassName")="CIS.AN.ArchiveData"
			set saveResult=##class(CIS.AN.COM.DataService).SaveData(.singleData)
			quit:($piece(saveResult,"^",1)'="S")
		}
		if ($piece(saveResult,"^",1)'="S")
		{
			trollback
			quit saveResult	
		}
	}
	
	//保存归档签名数据
	kill array
	set sc=##class(CIS.AN.COM.String).ToArray(signData,.array)
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		merge singleData2=array(dataIndex)
		set singleData2("ArchiveRecord")=archiveRecordId
		set singleData2("RowId")=""
		set singleData2("ClassName")="CIS.AN.ArchiveSignature"
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.singleData2)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	
	tcommit
	quit "S^"_archiveRecordId
	
ERROR
	set ErrorMsg=$ZE
	trollback 
	quit "E^"_ErrorMsg
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArchiveRecord","FindArchiveRecordList","2","")
Query FindArchiveRecordList(recordSheetId As %String, archiveStatus As %String = "S") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
Select 
	RowId,
	RecordSheet As RecordSheetId,
	SubmitUser As SubmitUserId,
	CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',SubmitUser) As SubmitUserDesc,
	%ODBCOUT(SubmitDate)_" "_%ODBCOUT(SubmitTime) As SubmitDT,
	CIS_AN_COM.DateTime_ConvertToDateHis(SubmitDate,'') As SubmitDate,
	CIS_AN_COM.DateTime_ConvertToTimeHis(SubmitTime) As SubmitTime,
	SumitState As SumitStateCode,
	%EXTERNAL(SumitState) As SumitStateDesc,
	RevokeSubmitUser As RevokeSubmitUserId,
	SheetSelector,
	CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',RevokeSubmitUser) As RevokeSubmitUserDesc,
	%ODBCOUT(RevokeSubmitDate)_" "_%ODBCOUT(RevokeSubmitTime) As RevokeSubmitDT,
	ArchiveCode,
	FilePath
	from CIS_AN.ArchiveRecord
	where RecordSheet=:recordSheetId
	and ((SumitState=:archiveStatus) or (:archiveStatus is null))
	order by RowId Desc
}

Query FindArchiveDataList(archiveRecordId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
Select *
	from CIS_AN.ArchiveData
	where ArchiveRecord=:archiveRecordId
}

Query FindArchiveSignatureList(archiveRecordId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
Select 
	RowId,
	SignCode,
	SignUser As SignUserId,
	CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',SignUser) As SignUserDesc,
	CIS_AN_BL.ArchiveRecord_GetSignImage(SignUser) As SignImage
	from CIS_AN.ArchiveSignature
	where ArchiveRecord=:archiveRecordId
}

ClassMethod RevokeSubmitRecord(recordSheetId, archiveCode, revokeSubmitUserId) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) "E^表单Id不存在,recordSheetId="_recordSheetId
	
	set saveResult="S^"
	set archiveRecordId=0
	set ifHasRevokeSubmitRecord="N"
	for
	{
		set archiveRecordId=$order(^CIS.AN.ArchiveRecordI("ISheet",recordSheetId,archiveRecordId))
		quit:archiveRecordId=""
		set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(archiveRecordId)
		if (archiveRecordObj.ArchiveCode=archiveCode)&&(archiveRecordObj.SumitState="S")
		{
			set ifHasRevokeSubmitRecord="Y"
			set archiveRecordObj.SumitState="R"
			set archiveRecordObj.RevokeSubmitUser=revokeSubmitUserId
			set archiveRecordObj.RevokeSubmitDate=+$h
			set archiveRecordObj.RevokeSubmitTime=$piece($h,",",2)
			set status=archiveRecordObj.%Save()
			if '$System.Status.IsOK(status) set saveResult="E^"_$System.Status.GetErrorText(status)
		}
	}
	quit:ifHasRevokeSubmitRecord="N" "E^无可撤消提交的记录"
	
	quit saveResult
}

/// w ##class(CIS.AN.BL.ArchiveRecord).CheckSubmitState(11,"PreANAnaestSign")
ClassMethod CheckSubmitState(recordSheetId, archiveCode) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) "N"
	
	set archiveRecordId=0, result="N"
	for
	{
		set archiveRecordId=$order(^CIS.AN.ArchiveRecordI("ISheet",recordSheetId,archiveRecordId))
		quit:archiveRecordId=""
		set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(archiveRecordId)
		if (archiveRecordObj.SumitState="S") && (archiveRecordObj.ArchiveCode=archiveCode)
		{
			set result="Y"
		}
	}
	quit result
}

ClassMethod CheckAllSubmitState(recordSheetId, archiveCodeStr) As %String
{
	set result="Y"
	for i=1:1:$length(archiveCodeStr,"^")
	{
		set archiveCode=$piece(archiveCodeStr,"^",i)
		set state=..CheckSubmitState(recordSheetId, archiveCode)
		if (state="N")
		{
			set result="N"
			break
		}
	}
	quit result
}

ClassMethod CheckValidUser(accout As %String, pwd As %String) As %String
{
	set validateUser=##class(web.SSUser).IsValidUser(accout,pwd)
	if (+validateUser>0)
	{
		quit "S^"
	}
	else
	{
		set result=$s(validateUser["UserNotFindErr":"用户不存在",validateUser["UnActiveErr":"用户未激活",validateUser["DateFromScopeErr":"未到用户启用日",validateUser["DateToScopeErr":"用户已过有效期",validateUser["PasswordErr":"密码输入错误",1:validateUser)
		quit "E^"_result
	}
}

ClassMethod GetSignImage(userId As %String) As %String [ SqlProc ]
{
	//quit "iVBORw0KGgoAAAANSUhEUgAAAHIAAAAYCAYAAAAmsqlBAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAWLSURBVGhD7ZpZSJVbFICX5qw5EGV1cciciggCQ6XUAqPEl1SO5hBHPQ96pRBLEAUnfOjFDDVIE5ECsQGTUEFKKhXJ4SWazTJFKjWvIprDQ62713KfBm83Pce4/3/FD2Kvtfb/73732nvttbaaoADW+d9jKlvFuXLlCpiYmMCXL1+kRV2ofb2rxpFarRby8vKgvLxcWtQFLTKNRgM7duyAwcFBaVUPqnEkMTY2BnFxcVL7fYyMjEBUVJTUjOfmzZvQ0tICaX+msZ6ZmQmtra0sK42qHEkrfcuWLVBQUCAthqPT6aT0ja1bt4KlpSWH79XS19cHE5MTYGZmBp6enhAaGip7FIaSHTXw6tUrOoRwfHycdXFW4vmS81hZWcn6StmzZw+3RUVF+PjxY5aJ3bt385jGkp6ezt9nZ2eHfn5+0qoeFN+RFJ6OHz8OISEhcPDgQejo6AAHBwcwNTWFi+UXwc3NTT65PLRbZmdnISIiAnJzc8HdzV32AMzNzfE5p5dXwp07d8DLywsOHz4MLi4u4OrmCtPT0yAWBQhnwsaNG3m3Dw0NyTcURDpUMcTEcPv27Vte8VVVVTg1NcU2Q6H3RajDWw238Ny5c9KKKBIovH37Ns7MzKCTkxM/txImJyelhHjo0CFuL126xO+XlZWxnpiYiEeOHGFZSVQRWi9fvsyTI5IdnuycnBwUSYXsXRn+/v4YExPDMo0VHR2N7e3trPv6+mJxcTGK8xcfPHjANkOgb0pJScGamhpsaGjgMJuUlMR9VlZWKCIBy0qiuCNpB9GO+fz5MzuDzjJyxLt37/DatWsrOtdqa2t5oglyGL3//v17bglqbW1tvzrWUMLCwvh7iPz8fBRhH0Wyg/39/Whvb892pVHMkeIsQxsbG3z+/DmHJprsN2/eYEVFBR44cICfsba25tYQaGJFScAhmsYMCAhgWZxjeCL2hHzKMMQ5yO2ZM2fwwoULaGFhwQ6l8Xt6erhPaRRxJE3A/v37pbaoNzc34/3791kmXF1dcXR0lOWV0tvbiydPnkRHR0cUiQ2PRf9ev37NO5VCo6EcO3YMHz58KLXFrJjG3LlzJ5aUlKCHhweePXtW9iqH4qGV8PHx4WRC78Rdu3Zx8mMI+kUQGBiImzdvxu7ubszOzua+oKCgr2MbwqdPn3hR6BEZLI9D36uH9KtXr0pNOVRxISB2J4gkBNLS0sDc3BwSEhJAnD9cjvwb8/Pz8PLlSxC7DMRkc4kgnAdNTU1QX18P169fh9jYWH5WhFfupyLeELy9veHZ02csUxmysLBAqwFE+AbhZC5n7t27ByIK8DNKogpHPn32FMQqh87OThAZLIjEBERmyFdr27Zt4wmjqzsRIuUbAMPDwyB2LjQ2NoI4p9g2MDAAmzZtArETobS0FMRO4ZryxYsXPOFPnjzhsQoLC/n5X0E1pAijsP2P7axHRkZCfHw8iIya61A7Ozv+ZgtzC+5XnMWNqRw6nQ4zMjJw3759OPHXhLTiP2qztrY2Tn6Sk5Ol5RvUd/ToUTx16hSfhVQi0I9WXV3NZQiF3e+hZIr6U1NT+Vz9GUunRj/mjRs3OMt+9OgR27VaLdtb77ayrhSKOrKuru7reUPO1NPV1YUFBQVS+5HlskSx83hil55bVMZ8X8rQpcPp06f5DAwODpbWRfbu3YsdHR1SW4TG3GC2geWsrKwf6lFKppY6/r9Gsf+d7kEtLS2lhihCl5SMKzv0UPFO96HGQrs4PDxcaot8+PABNRoNy1R6/MxpHz9+lJIyKOZIygi/R38FRpOkv7ZbDXTBYCh0YU+1LfGriwh9NqwmVPOnHu7u7nz5TAmOs7OztBoP/Vj6S3JjWO791Y7/u1n/m501gqp+sbyO8aw7co2w7sg1AcDfAnPM9wT6+VMAAAAASUVORK5CYII="
	set signImage=""
	set signInfo=##class(CA.UsrSignatureInfo).GetInUseInfo(userId)
	if signInfo'="" set signImage=signInfo.SignImage
	quit signImage
}

/// w ##class(CIS.AN.BL.ArchiveRecord).GetArchiveDataContent(18)
ClassMethod GetArchiveDataContent(recordSheetId As %String) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) ""
	
	set archiveRecordId=""
	set archiveStatus="S"
	&sql(select top 1 RowId into :archiveRecordId from CIS_AN.ArchiveRecord where RecordSheet=:recordSheetId and SumitState=:archiveStatus order by RowId desc)
	
	quit:'##class(CIS.AN.ArchiveRecord).%ExistsId(archiveRecordId) ""
	
	set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(archiveRecordId)
	quit archiveRecordObj.ArchiveDataContent.Read(1000000)
}

ClassMethod GetPDFArchiveFilePath(recordSheetId As %String) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) ""
	
	set archiveRecordId=""
	set archiveStatus="S"
	&sql(select top 1 RowId into :archiveRecordId from CIS_AN.ArchiveRecord where RecordSheet=:recordSheetId and SumitState=:archiveStatus order by RowId desc)
	
	quit:'##class(CIS.AN.ArchiveRecord).%ExistsId(archiveRecordId) ""
	
	set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(archiveRecordId)
	quit archiveRecordId_"^"_archiveRecordObj.FilePath
}

ClassMethod SavePDFArchiveFilePath(archiveRecordId As %String, url As %String, userId As %String) As %String
{
	quit:'##class(CIS.AN.ArchiveRecord).%ExistsId(archiveRecordId) "E^未提交，请提交后再归档"
	
	set saveResult="S^"
	set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(archiveRecordId)
	set archiveRecordObj.FilePath=url
	set archiveRecordObj.FileUser=userId
	set archiveRecordObj.FileDate=+$h
	set archiveRecordObj.FileTime=$piece($h,",",2)
	set status=archiveRecordObj.%Save()
	if '$System.Status.IsOK(status) set saveResult="E^"_$System.Status.GetErrorText(status) 
	
	quit saveResult
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ArchiveRecord","FindArchiveRecordSheets",586)
Query FindArchiveRecordSheets(opsId As %String) As %Query(ROWSPEC = "RecordSheetId,DataModuleId,DataModuleCode,DataModuleDesc,ArchiveCode,SumitState,SubmitUserDesc,SubmitDT,FilePath,ArchiveRecordId") [ SqlProc ]
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
		
		set SumitState=""
		set SubmitUserDesc=""
		set SubmitDT=""
		set FilePath=""
		set ArchiveRecordId=""
		&sql(select top 1 RowId into :ArchiveRecordId from CIS_AN.ArchiveRecord where RecordSheet=:RecordSheetId and SumitState="S" order by RowId desc)
	    if ##class(CIS.AN.ArchiveRecord).%ExistsId(ArchiveRecordId) 
	    {
		    set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(ArchiveRecordId)
		    set SumitState=archiveRecordObj.SumitState
			set FilePath=archiveRecordObj.FilePath
			set SubmitUser=archiveRecordObj.SubmitUser
			set SubmitUserDesc=##class(CIS.AN.COM.String).GetDescByID("User.SSUser","SSUSRName",SubmitUser)
			set SubmitDate=archiveRecordObj.SubmitDate
			set SubmitTime=archiveRecordObj.SubmitTime
			if (SubmitDate'="")&&(SubmitTime'="")
			{
				set SubmitDate=##class(CIS.AN.COM.DateTime).ConvertToDateHis(SubmitDate)
				set SubmitTime=##class(CIS.AN.COM.DateTime).ConvertToTimeHis(SubmitTime)
				;set SubmitDT=$zd(SubmitDate,3)_" "_$zt(SubmitTime)
				set SubmitDT=SubmitDate_" "_SubmitTime
			}
		}
		do OutputRow
	}

	s qHandle=$lb(0,repid,0)
	q $$$OK
	
OutputRow
	s ^CacheTemp(repid,ind)=$lb(RecordSheetId,DataModuleId,DataModuleCode,DataModuleDesc,ArchiveCode,SumitState,SubmitUserDesc,SubmitDT,FilePath,ArchiveRecordId)
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

/// w ##class(CIS.AN.BL.ArchiveRecord).GetArchiveDataContentList("18^14")
ClassMethod GetArchiveDataContentList(archiveRecordIdStr As %String) As %String
{
	set ret=""
	for i=1:1:$length(archiveRecordIdStr,"^")
	{
		set ArchiveRecordId=$piece(archiveRecordIdStr,"^",i)
		if ##class(CIS.AN.ArchiveRecord).%ExistsId(ArchiveRecordId)
		{
			set archiveRecordObj=##class(CIS.AN.ArchiveRecord).%OpenId(ArchiveRecordId)
			set ArchiveDataContent=archiveRecordObj.ArchiveDataContent.Read(1000000) 
			if ret="" set ret=ArchiveDataContent
			else  set ret=ret_","_ArchiveDataContent
		}
	}
	quit "["_ret_"]"
}

ClassMethod BackstageArchive(archiveDataContent) As %String
{
	set archiveServerIP=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerIP")
    set archiveServerPort=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("ArchiveServerPort")

	Set httprequest=##class(%Net.HttpRequest).%New()
	Set httprequest.Server=archiveServerIP
	Set httprequest.Port=8888 ;;archiveServerPort
	//if (archiveDataContent["CharacterStream") do httprequest.EntityBody.CopyFrom(archiveDataContent)
	//else  do httprequest.EntityBody.Write(archiveDataContent)
	
	set drawContextStr=##class(CIS.AN.BL.PrintTemplate).GetSheetDataStr(archiveDataContent)
	Do httprequest.InsertFormData("drawContext",drawContextStr)
	
	Do httprequest.Post("/archivesNew")
	set response=httprequest.HttpResponse
	set ret=httprequest.HttpResponse.Data.Read()
	quit ret
}

}
