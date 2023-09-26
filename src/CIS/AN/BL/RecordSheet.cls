/// 手术麻醉记录表单业务逻辑类
Class CIS.AN.BL.RecordSheet Extends %RegisteredObject
{

/// w ##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCode("1093","AnaestRecord","10209")
ClassMethod GetRecordSheetIdByModCode(opsId As %String, moduleCode As %String, userId As %String, new As %String = "Y") As %String
{
	set moduleQuery=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindDataModule")
	set sc=moduleQuery.Execute("","",moduleCode)
	set moduleId="",moduleDesc=""
	while(moduleQuery.Next())
	{
		set moduleId=moduleQuery.Get("RowId")	
		set moduleDesc=moduleQuery.Get("Description")
	}	
	set ret=..GetRecordSheetId(opsId,moduleId,userId,new)
	set:(##class(CIS.AN.RecordSheet).%ExistsId(ret)=0) ret=""
	quit ret
}

/// w ##class(CIS.AN.BL.RecordSheet).GetRecordSheetIdByModCodeNew("597","AN_OPS_002","10850")
ClassMethod GetRecordSheetIdByModCodeNew(opsId As %String, moduleCode As %String, userId As %String) As %String
{
	set moduleQuery=##class(%ResultSet).%New("CIS.AN.BL.CodeQueries:FindDataModule")
	set sc=moduleQuery.Execute("","",moduleCode)
	set moduleId="",moduleDesc=""
	while(moduleQuery.Next())
	{
		set moduleId=moduleQuery.Get("RowId")	
		set moduleDesc=moduleQuery.Get("Description")
	}	
	set ret=..GetRecordSheetIdNew(opsId,moduleId,userId)
	set:(##class(CIS.AN.RecordSheet).%ExistsId(ret)=0) ret=""
	quit ret
}

/// Creator：      	陈长青
/// CreatDate：    	2018-5-11
/// Description： 	获取记录表单ID
/// Table：        	DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleId:模块ID，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.RecordSheet).GetRecordSheetId("2","63","1")
ClassMethod GetRecordSheetId(opsId As %String, moduleId As %String, userId As %String, new As %String = "Y") As %String
{
	set recordSheetQuery=##class(%ResultSet).%New("CIS.AN.BL.RecordSheet:FindRecordSheets")
	set sc=recordSheetQuery.Execute(opsId,moduleId)
	set recordSheetID=""
	while(recordSheetQuery.%Next())
	{
		set recordSheetID=recordSheetQuery.Get("RowId")	
	}	
	if (##class(CIS.AN.RecordSheet).%ExistsId(recordSheetID)=0)&(new="Y")
	{
		set recordSheet=##class(CIS.AN.RecordSheet).%New()
		set recordSheet.OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set recordSheet.DataModule=##class(CT.AN.DataModule).%OpenId(moduleId)
		set recordSheet.EditFlag="N"
		set recordSheet.CreateUser=userId
		set sc=recordSheet.%Save()
		if ($System.Status.IsError(sc))
		{
			set recordSheetID="E^"_$System.Status.GetErrorText(sc)	
		}	
		else
		{
			set recordSheetID=recordSheet.%Id()	
		}
	}	
	quit recordSheetID
}

/// Creator：      	陈长青
/// CreatDate：    	2018-5-11
/// Description： 	获取记录表单ID,不创建
/// Table：        	DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleId:模块ID，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.RecordSheet).GetRecordSheetId("2","63","1")
ClassMethod GetRecordSheetIdNew(opsId As %String, moduleId As %String, userId As %String) As %String
{
	set recordSheetQuery=##class(%ResultSet).%New("CIS.AN.BL.RecordSheet:FindRecordSheets")
	set sc=recordSheetQuery.Execute(opsId,moduleId)
	set recordSheetID=""
	while(recordSheetQuery.%Next())
	{
		set recordSheetID=recordSheetQuery.Get("RowId")	
	}
	quit recordSheetID
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询手术记录表单
/// Table：        	DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleId:模块ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.RecordSheet","FindRecordSheets","2","63")
Query FindRecordSheets(opsId As %String, moduleId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT * 
	   from CIS_AN.RecordSheet 
	   where OperSchedule=:opsId 
	   and DataModule=:moduleId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询手术记录表单
/// Table：        	DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleId:模块ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.RecordSheet","FindRecordSheets","74","AN_OPS_004")
Query FindRecordSheetsByModCode(opsId As %String, moduleCode As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT * 
	   from CIS_AN.RecordSheet 
	   where OperSchedule=:opsId 
	   and DataModule->Code=:moduleCode
}

ClassMethod GetArchiveList(opsId As %String, archiveArr As %String) As %String
{
	set recordSheetId=0
	for
	{
		set recordSheetId=$o(^CIS.AN.RecordSheetI("IOPS",opsId,recordSheetId))
		quit:(recordSheetId="")
		set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
		set dataModule=recordSheet.DataModule
		continue:(dataModule="")
		continue:(dataModule.Archive'="Y")!(dataModule.ArchiveCode="")
		set archiveUrl=recordSheet.FilePath
		set archiveArr(dataModule.ArchiveCode)=archiveUrl
	}
	
	quit ""
}

/// Creator：      	陈长青
/// CreatDate：    	2017-10-11
/// Description： 	查询手术记录表单
/// Table：        	DHCAN.RecordSheet
/// Input:			opsId:手术ID，moduleId:模块ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.RecordSheet","FindRecordSheets","2","63")
Query FindArchiveList(opsId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT FilePath As ArchiveUrl,
	   %ODBCOUT(FileDate)_" "_%ODBCOUT(FileTime) As ArchiveDT,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',FileUser) As ArchiveUser
	   from CIS_AN.RecordSheet 
	   where OperSchedule=:opsId 
	   and DataModule->Archive='Y'
	   and (not DataModule->ArchiveCode is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2020-09-05
/// Description： 	提交表单
/// Table：        	CIS.AN.RecordSheet
/// Input:					sheetId:表单ID，userId：用户ID
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.RecordSheet).SubmitSheet()
ClassMethod SubmitSheet(sheetId As %String, userId As %String) As %String
{
		set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
		set:(recordSheet.EditFlag'="A") recordSheet.EditFlag="S"
		set recordSheet.SubmitUser=userId
		set recordSheet.SubmitDate=+$Horolog
		set recordSheet.SubmitTime=$p($h,",",2)
		set sc=recordSheet.%Save()
		quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
		quit "S^"
}

/// Creator：      	陈长青
/// CreatDate：    	2020-09-05
/// Description： 	获取表单编辑状态
/// Table：        	CIS.AN.RecordSheet
/// Input:					sheetId:表单ID
/// Return：       	表单编辑状态标志
/// w ##class(CIS.AN.BL.RecordSheet).GetSheetEditFlag("1324","10850","51")
ClassMethod GetSheetEditFlag(sheetId As %String, userId As %String, groupId As %String) As %String
{
		set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
		set editFlag=recordSheet.EditFlag
		set:(editFlag="") editFlag="N"
		set submitUser="N"
		set:(recordSheet.SubmitUser=userId) submitUser="Y"

		set groupEditFlag=""
		&sql(select SheetEditFlag into :groupEditFlag from CF_AN.SSGroup where GroupID=:groupId)
		set:(editFlag'="N")&(("^"_groupEditFlag_"^") [ ("^"_editFlag_"^")) submitUser="Y"
		set res=##class(%DynamicObject).%New()
		set res.editFlag=editFlag
		set res.submitUser=submitUser

		quit res.%ToJSON()
}

/// Creator：      	杨国宾
/// CreatDate：    	2020-10-13
/// Description： 	获取表单归档链接
/// Table：        	CIS.AN.RecordSheet
/// Input:					sheetId:表单ID
/// Return：       	表单归档链接
/// w ##class(CIS.AN.BL.RecordSheet).GetSheetFilePath("1614")
ClassMethod GetSheetFilePath(sheetId As %String) As %String
{
	s result=""
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
	if (recordSheet'="")
	{
		if (recordSheet.FilePath'="")
		{
			s result=recordSheet.FilePath
		}
		else
		{
			s result="E^表单还未归档，请归档后再浏览"
		}
	}
	else
	{
		s result="E^表单还未归档，请归档后再浏览"
	}
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2019-4-12
/// Description： 	获取表单是否可以编辑（保存）
/// Table：        	DHCAN.Model.SurgicalItem
/// Input:			opsId:手术ID，moduleCode:模块代码
/// Return：       	ResultSet
/// w ##class(CIS.AN.BL.RecordSheet).CanEdit("1256","10209")
/// w ##class(CIS.AN.BL.RecordSheet).CanEdit("1256","12123")
ClassMethod CanEdit(recordSheetId, userId) As %String
{
	quit:'##class(CIS.AN.RecordSheet).%ExistsId(recordSheetId) "Y"
	b ;111
	///用户是否为当前页的签名用户，提交后、归档后判断
	///手术病人已出院后不能修改，接口新增获取出院状态
	set editable="Y"
	set recordSheet=##class(CIS.AN.RecordSheet).%OpenId(recordSheetId)
	set editFlag=recordSheet.EditFlag
	
	if (editFlag="S")||(editFlag="A")
	{
		set editable="N"
		if $o(^CIS.AN.SignatureI("ISheet",recordSheetId,""))="" set editable="Y"
		set signId=""
		for
		{
			set signId=$o(^CIS.AN.SignatureI("ISheet",recordSheetId,signId))
			quit:signId=""
			
			set signature=##class(CIS.AN.Signature).%OpenId(signId)
			set signUser=signature.SignUser
			if signUser=userId
			{
				set editable="Y"
				quit
			}
		}
	}
	
	quit editable
}

/// 根据表单名创建手麻表单
ClassMethod CreateSheet(opsId As %String, moduleCode As %String, sheetName As %String, createUserID As %String) As %String
{
	quit:('##class(CIS.AN.OperSchedule).%ExistsId(opsId)) "E^手术申请不存在"
	quit:(sheetName="") "E^表单名不能为空"
	quit:(createUserID="") "E^创建表单的用户ID不能为空"
	set moduleID=##class(CIS.AN.BL.DataModule).GetDataModuleID(moduleCode)
	quit:('##class(CT.AN.DataModule).%ExistsId(moduleID)) "E^数据模块不存在"
	&sql(insert into CIS_AN.RecordSheet (OperSchedule,DataModule,SheetName,CreateUser,EditFlag) values (:opsId,:moduleID,:sheetName,:createUserID,'N'))
	quit:(SQLCODE'=0) "E^创建表单失败，原因："_$System.SQL.SQLCODE(SQLCODE)
	quit "S^"_%ROWID
}

/// 获取手麻表单
ClassMethod GetSheets(opsId As %String, moduleCode As %String = "") As %String
{
	set sheets=##class(%DynamicArray).%New()
	&sql(declare SheetCursor cursor for select RowId,SheetName into :RowId,:SheetName from CIS_AN.RecordSheet
		 where OperSchedule=:opsId
		 and (DataModule->Code=:moduleCode or :moduleCode is null)
		 and EditFlag<>'D')	
	&sql(open SheetCursor)
	for
	{
		&sql(fetch SheetCursor)
		quit:(SQLCODE'=0)
		set sheet=##class(%DynamicObject).%New()
		set sheet.RowId=RowId
		set sheet.SheetName=SheetName
		set:(SheetName="") sheet.SheetName="默认"
		do sheets.%Push(sheet)	
	}
	&sql(close SheetCursor)
	
	quit sheets.%ToJSON()
}

/// 修改清点名称
ClassMethod EditSheet(sheetId As %String, sheetName As %String, editUserID As %String) As %String
{
	quit:('##class(CIS.AN.RecordSheet).%ExistsId(sheetId)) "E^清点单不存在"
	quit:(sheetName="") "E^清点单名称不能为空"
	quit:(editUserID="") "E^修改清点单名称的用户的ID不能为空"
	set sheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
	set sheet.SheetName=sheetName
	set sheet.UpdateUser=editUserID
	set sheet.UpdateDate=+$h
	set sheet.UpdateTime=$p($h,",",2)
	set sc=sheet.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set sheet=""
	quit "S^"
}

/// 删除清点单
ClassMethod DelSheet(sheetId As %String, delUserID As %String) As %String
{
	quit:('##class(CIS.AN.RecordSheet).%ExistsId(sheetId)) "E^清点单不存在"
	quit:(delUserID="") "E^删除清点单的用户的ID不能为空"
	set sheet=##class(CIS.AN.RecordSheet).%OpenId(sheetId)
	set sheet.EditFlag="D"
	set sheet.UpdateUser=delUserID
	set sheet.UpdateDate=+$h
	set sheet.UpdateTime=$p($h,",",2)
	set sc=sheet.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set sheet=""
	quit "S^"
}

}
